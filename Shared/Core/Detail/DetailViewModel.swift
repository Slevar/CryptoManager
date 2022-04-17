//
//  DetailViewModel.swift
//  CryptoManager (iOS)
//
//  Created by Вардан Мукучян on 15.04.2022.
//

import Foundation
import Combine

class DetailViewModel: ObservableObject {
    
    @Published var overviewStatistic: [StatisticModel] = []
    @Published var additionalStatistic: [StatisticModel] = []

    @Published var coin: CoinModel
    private let coinDetailService: CoinDetailDataService
    private var cancellable = Set<AnyCancellable>()
    
    init(coin: CoinModel) {
        self.coin = coin 
        self.coinDetailService = CoinDetailDataService(coin: coin)
        self.addSubscribers()
    }
    
    private func addSubscribers() {
        coinDetailService.$coinDetails
            .combineLatest($coin)
            .map(mapDataToStatistic)
            .sink { [weak self] returnedCoinDetails in
                self?.overviewStatistic = returnedCoinDetails.overview
                self?.additionalStatistic = returnedCoinDetails.additional
            }
            .store(in: &cancellable)
    }
}



extension DetailViewModel {
    func mapDataToStatistic(coinDetailModel: CoinDetailModel?, coinModel: CoinModel) -> (overview: [StatisticModel], additional: [StatisticModel]) {
        
        let overview = createOverviewArray(coinModel: coinModel)
        let additional = createAdditionalArray(coinModel: coinModel, coinDetailModel: coinDetailModel)
        
        return (overview, additional)
        
    }
    
    func createOverviewArray(coinModel: CoinModel) -> [StatisticModel] {
        
        let price = coinModel.currentPrice.asCurrencyWith6Decimals()
        let pricePercentageChange1 = coinModel.priceChangePercentage24H
        let priceStats = StatisticModel(title: "Current price", value: price, percentageChange: pricePercentageChange1)
        
        let marketCap = "$" + (coinModel.marketCap?.formattedWithAbbreviations() ?? "")
        let marketCapPercentageChange = coinModel.marketCapChange24H
        let marketStats = StatisticModel(title: "Market Capitalization", value: marketCap, percentageChange: marketCapPercentageChange)
        
        let rank = "\(coinModel.rank)"
        let rankStats = StatisticModel(title: "Rank", value: rank)
        
        let volume = "\(coinModel.totalVolume)"
        let volumeStats = StatisticModel(title: "Volume", value: volume)
        
        let overviewArray: [StatisticModel] = [
            priceStats, marketStats, rankStats, volumeStats
        ]
        return overviewArray
    }
    
    func createAdditionalArray(coinModel: CoinModel, coinDetailModel: CoinDetailModel?) -> [StatisticModel] {
        let high = coinModel.high24H?.asCurrencyWith6Decimals() ?? "n/a"
        let highStats = StatisticModel(title: "24h High", value: high)
        
        let low = coinModel.low24H?.asCurrencyWith6Decimals() ?? "n/a"
        let lowStats = StatisticModel(title: "24h Low", value: low)
        
        let priceChange = coinModel.priceChange24H?.asCurrencyWith2Decimals() ?? "n/a"
        let pricePercentageChange = coinModel.priceChangePercentage24H
        let priceChangeStats = StatisticModel(title: "24h price change", value: priceChange, percentageChange: pricePercentageChange)
        
        let marketCapChange = "$" + (coinModel.marketCapChange24H?.formattedWithAbbreviations() ?? "")
        let marketCapPercentageChange = coinModel.priceChangePercentage24H
        let marketCapChangeStats = StatisticModel(title: "24h Market Cap change", value: marketCapChange, percentageChange: marketCapPercentageChange)
        
        let blockTime = coinDetailModel?.blockTimeInMinutes ?? 0
        let blockTimeString = blockTime == 0 ? "n/a" : "\(blockTime)"
        let blockStats = StatisticModel(title: "Block Time", value: blockTimeString)
        
        let hashing = coinDetailModel?.hashingAlgorithm ?? "n/a"
        let hashingStats = StatisticModel(title: "Hashing", value: hashing)
        
        let additionalArray: [StatisticModel] = [
            highStats, lowStats, priceChangeStats, marketCapChangeStats, blockStats, hashingStats
        ]
        return additionalArray

    }
}
