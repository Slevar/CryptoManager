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
    
    @Published var searchText: String = ""
    
    // Связываем класс, отвественный за забор информации из интернета
    private let coinDataService = CoinDataService()
    private var cancellable = Set<AnyCancellable>()
    private let marketDataService = MarketDataService()
    private let portfolioDataServices = PortfolioDataService()
    
    // Временное заполнение массива
    init() {
        addSubscribers()
    }
    func addSubscribers() {
        // Вслед за введением текста фильтруем наш Лист коинов
        $searchText
            .combineLatest(coinDataService.$allCoins)
        // .debounce - не даст начать код ниже (фильтрацию), пока пользователь не остановиь печать на 0.6 секунд, соответсвенно не затрачиваются лишние ресурсы 
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterCoins)
            .sink { [weak self] receivedCoins in
                self?.allCoins = receivedCoins
            }
            .store(in: &cancellable)
        
        marketDataService.$marketData
            .map(mapGlobalmarkedData)
            .sink { [weak self] statisticmodel in
                self?.statistics = statisticmodel
            }
            .store(in: &cancellable)
        
        // update portfolioCoins from CoreData
        
        $allCoins
            .combineLatest(portfolioDataServices.$savedEntyties)
            .map{ (coinModels, portfolioEntities) -> [CoinModel] in
                coinModels
                    .compactMap { (coin) -> CoinModel? in
                        guard let entity = portfolioEntities.first(where:{ $0.coinID == coin.id}) else {
                            return nil
                        }
                        return coin.updateHoldings(amount: entity.amount)
                    }
            }
            .sink { [weak self] returnedCoins in
                self?.portfolioCoins = returnedCoins
            }
            .store(in: &cancellable)
    }
    
    func updatePortfolio(coin: CoinModel, amount: Double) {
        portfolioDataServices.updatePortfolio(coin: coin, amount: amount)
    }
    
    private func filterCoins(text: String, coin: [CoinModel]) -> [CoinModel] {
        // Если текст не введён - возвращаем не изменённый Лист
        guard !text.isEmpty else {
            return coin
        }
        let lowercasedText = text.lowercased()
        
        return coin.filter { (coin) -> Bool in
            return coin.name.lowercased().contains(lowercasedText) ||
            coin.symbol.lowercased().contains(lowercasedText) ||
            coin.id.lowercased().contains(lowercasedText)
        }
    }
    
    private func mapGlobalmarkedData(markedDataModel : MarketDataModel?) -> [StatisticModel] {
        var stats: [StatisticModel] = []
        
        guard let data = markedDataModel else { return stats }
        
        let markedCap = StatisticModel(title: "Marked Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
        let volume = StatisticModel(title: "24 Volume", value: data.volume)
        let btcDominance = StatisticModel(title: "BTC Dominance", value: data.btcDominance)
        let portfolio = StatisticModel(title: "Portfolio", value: "$0.00", percentageChange: 0)
        
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
