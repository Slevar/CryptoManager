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
    private var imageSubscribtion: AnyCancellable?
    private let coin: CoinModel
    private let fileManager = LocalFileManager.instance
    private let folderName = "coin_images"
    private let imageName: String

    init(coin: CoinModel) {
        self.coin = coin
        self.imageName = coin.id
        getCoinImage()
    }
    
    // Проверяет имеется ли в нашем локальном файле картинка, если нет - скачает её, если да - возьмёт картинку из локального файла
    private func getCoinImage() {
        if let savedImage = fileManager.getImage(imageName: imageName, folderName: folderName) {
            image = savedImage
            //print("Take image from cashe")
        }
        else {
            downloadCoinImage()
            //print("downloading image")
        }
    }
    
    private func downloadCoinImage() {
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
                guard let self = self, let downloadedImage = returnedImage else { return }
                self.image = returnedImage
                self.imageSubscribtion?.cancel()
                self.fileManager.saveImage(image: downloadedImage, imageName: self.imageName, folderName: self.folderName)
            }
    }
}
