//
//  MarketDataService.swift
//  CryptoManager (iOS)
//
//  Created by Вардан Мукучян on 10.04.2022.
//

import Foundation
import Combine

class MarketDataService {
    
    // Реактивный формат, создадим массив, на которого впоследствии можно подписаться
    @Published var marketData: MarketDataModel? = nil
    
    var marketDataSubscribtions: AnyCancellable?
    
    // Дабы снаружи не давать возможность вызывать метод getCoins(), работаем опосредованно через инициализатор
    init() {
        getData()
    }
    
    func getData() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/global")
        else { return }
        
        marketDataSubscribtions  = NetworkingManager.download(url: url)
            .decode(type: GlobalData.self, decoder: JSONDecoder())
            .sink { completion in
                NetworkingManager.handleCompletion(completion: completion)
            } receiveValue: { [weak self] returnedGlobalData in
                self?.marketData = returnedGlobalData.data
                self?.marketDataSubscribtions?.cancel()
            }
    }
}
