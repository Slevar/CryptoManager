//
//  PortfolioDataService.swift
//  CryptoManager (iOS)
//
//  Created by Вардан Мукучян on 14.04.2022.
//

import Foundation
import CoreData
import UIKit

class PortfolioDataService {
    
    private let container: NSPersistentContainer
    private let containerName: String = "PortfolioContainer"
    private let entityName: String = "PortfolioEntity"
    
    @Published var savedEntyties: [PortfolioEntity] = []
    
    init() {
        self.container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { _, error in
            if let error = error {
                print("Load error occur \(error)")
            }
            self.getPortfolio()
        }
    }
    
    // MARK - Public
    
    func updatePortfolio(coin: CoinModel, amount: Double) {
        // check if coin is already in portfolio
        if let entity = savedEntyties.first(where: { $0.coinID == coin.id }) {
            if amount > 0 {
                update(entity: entity, amount: amount)
            } else {
                delete(entity: entity)
            }
        } else {
            add(coin: coin, amount: amount)
        }
    }
    
    // MARK - Private
    private func getPortfolio() {
        let request = NSFetchRequest<PortfolioEntity>(entityName: entityName)
        do {
            savedEntyties = try container.viewContext.fetch(request)
        } catch let error {
                print("Error fetcging portfolio \(error)")
        }
    }
    
    private func add(coin: CoinModel, amount: Double) {
        let entity = PortfolioEntity(context: container.viewContext)
        entity.coinID = coin.id
        entity.amount = amount
        applyCganges()
    }
    
    private func update(entity: PortfolioEntity, amount: Double) {
        entity.amount = amount
        applyCganges()
    }
    
    private func delete(entity: PortfolioEntity) {
        container.viewContext.delete(entity)
        applyCganges()
    }
    
    private func save() {
        do {
            try container.viewContext.save()
        } catch let error {
            print("Save context error \(error)")
        }
    }
    
    private func applyCganges() {
        save()
        getPortfolio()
    }
    
}
