//
//  CoinDetailDataService.swift
//  CryptoManager (iOS)
//
//  Created by Вардан Мукучян on 15.04.2022.
//

import Foundation
import Combine

class CoinDetailDataService {
    
    // Реактивный формат, создадим массив паблишера, на которого впоследствии можно подписаться
    @Published var coinDetails: CoinDetailModel? = nil
    
    var coinDetailSubscribtions: AnyCancellable?
    let coin: CoinModel
    
    init(coin: CoinModel) {
        self.coin = coin
        getCoinDetails()
    }
    
    func getCoinDetails() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/\(coin.id)?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false")
        else { return }
        
        coinDetailSubscribtions = NetworkingManager.download(url: url)
            .decode(type: CoinDetailModel.self, decoder: JSONDecoder())
            .sink { completion in
                NetworkingManager.handleCompletion(completion: completion)
            } receiveValue: { [weak self] returnedCoinDetails in
                self?.coinDetails = returnedCoinDetails
                self?.coinDetailSubscribtions?.cancel()
            }

    }
}
