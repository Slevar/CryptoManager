//
//  CoinDataService.swift
//  CryptoManager (iOS)
//
//  Created by Вардан Мукучян on 09.04.2022.
//

import Foundation
import Combine

class CoinDataService {
    
    // Реактивный формат, создадим массив паблишера, на которого впоследствии можно подписаться
    @Published var allCoins: [CoinModel] = []
    
    var coinSubscribtions: AnyCancellable?
    
    init() {
        getCoins()
    }
    
    func getCoins() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h")
        else { return }
        
        coinSubscribtions = NetworkingManager.download(url: url)
            .decode(type: [CoinModel].self, decoder: JSONDecoder())
            .sink { completion in
                NetworkingManager.handleCompletion(completion: completion)
            } receiveValue: { [weak self] returnedCoins in
                self?.allCoins = returnedCoins
                self?.coinSubscribtions?.cancel()
            }

    }
}
