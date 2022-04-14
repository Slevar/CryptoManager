//
//  LazyVGridView.swift
//  CryptoManager (iOS)
//
//  Created by Вардан Мукучян on 12.04.2022.
//

import SwiftUI

struct LazyVGridView: View {
    
    @EnvironmentObject private var vm: HomeViewModel
    @State private var selectedCoin: CoinModel? = nil
    @State private var quantityText: String = ""
    @State private var showChechmark: Bool = false
    
    private var allCoinsGridColumns: [GridItem] = [
        GridItem(.adaptive(minimum: 120, maximum: 150), spacing: 15),
        GridItem(.adaptive(minimum: 120, maximum: 150), spacing: 15),
    ]
    
    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack {
                ForEach(vm.allCoins) { coin in
                    CoinImageView(coin: coin)
                        .frame(width: 75)
                        .padding()
                        .onTapGesture {
                            selectedCoin = coin
                        }
                    
                }
            }
            .padding(.vertical, 4)
            .padding(.leading)
        }
    }
}

struct LazyVGridView_Previews: PreviewProvider {
    static var previews: some View {
        LazyVGridView()
            .environmentObject(dev.homeVM)
    }
}
