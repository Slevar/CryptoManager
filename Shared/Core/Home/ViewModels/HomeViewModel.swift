//
//  HomeViewModel.swift
//  CryptoManager (iOS)
//
//  Created by Вардан Мукучян on 09.04.2022.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    
    @Published var statistics: [StatisticModel] = []
    
    // Моя ViewModel хранит паблишь массивы коинов, которые будут представлены в таблице HomeView
    @Published var allCoins: [CoinModel] = []
    @Published var portfolioCoins: [CoinModel] = []
    @Published var isLoading: Bool = false
    @Published var searchText: String = ""
    @Published var sortOption: SortOption = .holdings
    
    // Связываем класс, отвественный за забор информации из интернета
    private let coinDataService = CoinDataService()
    private var cancellable = Set<AnyCancellable>()
    private let marketDataService = MarketDataService()
    private let portfolioDataServices = PortfolioDataService()
    
    enum SortOption {
        case rank, rankReverced, holdings, holdingsReverced, price, priceReverced
    }
    
    // Временное заполнение массива
    init() {
        addSubscribers()
    }
    func addSubscribers() {
        // Вслед за введением текста фильтруем наш Лист коинов
        $searchText
            .combineLatest(coinDataService.$allCoins, $sortOption)
        // .debounce - не даст начать код ниже (фильтрацию), пока пользователь не остановиь печать на 0.6 секунд, соответсвенно не затрачиваются лишние ресурсы 
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filetrAndSortCoins)
            .sink { [weak self] receivedCoins in
                self?.allCoins = receivedCoins
            }
            .store(in: &cancellable)
        
        // update portfolioCoins from CoreData
        
        $allCoins
            .combineLatest(portfolioDataServices.$savedEntyties)
            .map(mapAllCoinsToPortfolioCoins)
            .sink { [weak self] returnedCoins in
                guard let self = self else { return }
                self.portfolioCoins = self.sortPortfolioCoinsIfNeeded(coins: returnedCoins)
            }
            .store(in: &cancellable)

        
        // update marketData
        
        marketDataService.$marketData
            .combineLatest($portfolioCoins)
            .map(mapGlobalmarkedData)
            .sink { [weak self] statisticmodel in
                self?.statistics = statisticmodel
                self?.isLoading = false
            }
            .store(in: &cancellable)
        
    }
    
    func updatePortfolio(coin: CoinModel, amount: Double) {
        portfolioDataServices.updatePortfolio(coin: coin, amount: amount)
    }
    
    func reloadData() {
        isLoading = true
        marketDataService.getData()
        coinDataService.getCoins()
        HapticManager.notification(type: .success)
    }
    
    private func filetrAndSortCoins(text: String, coin: [CoinModel], sort: SortOption) -> [CoinModel] {
        var updatedCoins = filterCoins(text: text, coins: coin)
        // sort
        sortCoins(sort: sort, coinModel: &updatedCoins)
        return updatedCoins
    }
    private func filterCoins(text: String, coins: [CoinModel]) -> [CoinModel] {
        // Если текст не введён - возвращаем не изменённый Лист
        guard !text.isEmpty else {
            return coins
        }
        let lowercasedText = text.lowercased()
        
        return coins.filter { (coin) -> Bool in
            return coin.name.lowercased().contains(lowercasedText) ||
            coin.symbol.lowercased().contains(lowercasedText) ||
            coin.id.lowercased().contains(lowercasedText)
        }
    }
    // Дабы не возвращать новый массив, воспльзуемся модификацией имеющегося, используя "inout"
    private func sortCoins(sort: SortOption, coinModel: inout [CoinModel]) {
        switch sort {
        case .rank, .holdings:
            coinModel.sort { $0.rank < $1.rank }
        case .rankReverced, .holdingsReverced:
            coinModel.sort { $0.rank > $1.rank }
        case .price:
            coinModel.sort{ $0.currentPrice > $1.currentPrice }
        case .priceReverced:
            coinModel.sort{ $0.currentPrice < $1.currentPrice }
        }
    }
    
    private func sortPortfolioCoinsIfNeeded(coins: [CoinModel]) -> [CoinModel] {
        // will sort only by holding or holdingReverced
        switch sortOption {
        case .holdings:
            return coins.sorted { $0.currentHoldingsValue > $1.currentHoldingsValue }
        case .holdingsReverced:
            return coins.sorted { $0.currentHoldingsValue < $1.currentHoldingsValue }
        default: return coins
        }
    }
    
    private func mapAllCoinsToPortfolioCoins(allCoins: [CoinModel], portfolioEntities: [PortfolioEntity]) -> [CoinModel] {
        allCoins
            .compactMap { (coin) -> CoinModel? in
                guard let entity = portfolioEntities.first(where:{ $0.coinID == coin.id}) else {
                    return nil
                }
                return coin.updateHoldings(amount: entity.amount)
            }
    }
    
    private func mapGlobalmarkedData(markedDataModel : MarketDataModel?, portfolioCoins: [CoinModel]) -> [StatisticModel] {
        var stats: [StatisticModel] = []
        
        guard let data = markedDataModel else { return stats }
        
        let markedCap = StatisticModel(title: "Marked Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
        let volume = StatisticModel(title: "24 Volume", value: data.volume)
        let btcDominance = StatisticModel(title: "BTC Dominance", value: data.btcDominance)
        
        let portfolioValue =
        portfolioCoins
            .map({ $0.currentHoldingsValue })
            .reduce(0, +)
        
        let previousValue =
            portfolioCoins
                .map { coin -> Double in
                    let currentValue = coin.currentHoldingsValue
                    let percentCgange = (coin.priceChangePercentage24H ?? 0) / 100
                    let previousValue = currentValue / (1 + percentCgange)
                    return previousValue
        }
                .reduce(0, +)
        
        let percentageChange = ((portfolioValue - previousValue) / previousValue) * 100

        
        let portfolio = StatisticModel(title: "Portfolio", value: portfolioValue.asCurrencyWith2Decimals(), percentageChange: percentageChange)
        
        stats.append(contentsOf:
                        [markedCap,
                         volume,
                         btcDominance,
                         portfolio
                        ])
        return stats
    }

}

// Старый addSubscribers (бещ фильтра)
// func addSubscribers() {
// Подписываем и соответственно переносим данные из одного класса к данной ВьюМодели
//        coinDataService.$allCoins
//            .sink { [weak self] receivedCoin in
//                self?.allCoins = receivedCoin
//            }
//            .store(in: &cancellable)
