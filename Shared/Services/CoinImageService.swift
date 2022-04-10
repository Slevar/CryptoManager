//
//  CoinImageService.swift
//  CryptoManager (iOS)
//
//  Created by Вардан Мукучян on 10.04.2022.
//

import Foundation
import SwiftUI
import Combine

class CoinImageService: ObservableObject {
    
    @Published var image: UIImage? = nil
    var imageSubscribtion: AnyCancellable?
    let coin: CoinModel
    
    init(coin: CoinModel) {
        self.coin = coin
        getCoinImage()
    }
    
    private func getCoinImage() {
        guard let url = URL(string: coin.image)
        else { return }
        
        imageSubscribtion = NetworkingManager.download(url: url)
            // Конвертируем в нужный формат
            .tryMap({ (data) -> UIImage? in
                return UIImage(data: data)
            })
            .sink { completion in
                NetworkingManager.handleCompletion(completion: completion)
            } receiveValue: { [weak self] returnedImage in
                self?.image = returnedImage
                self?.imageSubscribtion?.cancel()
            }
    }
}
