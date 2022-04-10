//
//  HomeViewModel.swift
//  CryptoManager (iOS)
//
//  Created by Вардан Мукучян on 09.04.2022.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    
    // Моя ViewModel хранит паблишь массивы коинов, которые будут представлены в таблице HomeView
    
    @Published var allCoins: [CoinModel] = []
    @Published var portfolioCoins: [CoinModel] = []
    
    // Связываем класс, отвественный за забор информации из интернета
    private let dataService = CoinDataService()
    private var cancellable = Set<AnyCancellable>()
    
    // Временное заполнение массива
    init() {
        addSubscribers()
    }
    // Подписываем и соответственно переносим данные из одного класса к данной ВьюМодели
    func addSubscribers() {
        dataService.$allCoins
            .sink { [weak self] receivedCoin in
                self?.allCoins = receivedCoin
            }
            .store(in: &cancellable)
    }
}
