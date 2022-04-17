//
//  DetailView.swift
//  CryptoManager (iOS)
//
//  Created by Вардан Мукучян on 15.04.2022.
//

import SwiftUI

struct DetailLoadingView: View {
    
    @Binding var coin: CoinModel?

    var body: some View {
        ZStack {
            if let coin = coin {
                DetailView(coin: coin)
            }
        }
    }
}

struct DetailView: View {
        
    @StateObject private var vm: DetailViewModel
    private let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    private let spacing: CGFloat = 30
    
    init(coin: CoinModel) {
        _vm = StateObject(wrappedValue: DetailViewModel(coin: coin))
        print("Initializing \(coin.name)")
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing:20) {
                Text("")
                    .frame(height: 150)
                
                overview
                Divider()
                lazyVGridOverview
                additional
                Divider()
                lazyVGridAdditional
            }
            .padding()
        }
        .navigationTitle(vm.coin.name)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(coin: dev.coin)
    }
}

extension DetailView {
    
    private var overview: some View {
        
        Text("Overview")
            .font(.title)
            .bold()
            .foregroundColor(.black)
            .frame(maxWidth: .infinity, alignment: .leading)

    }
    private var additional: some View {
        Text("Additional details")
            .font(.title)
            .bold()
            .foregroundColor(.black)
            .frame(maxWidth: .infinity, alignment: .leading)

    }
    private var lazyVGridOverview: some View {
        
        LazyVGrid(columns: columns,
                  alignment: .leading,
                  spacing: spacing,
                  pinnedViews: []) {
            ForEach(vm.overviewStatistic) { stat in
                StatisticView(stat: stat)
            }
        }
    }
    
    private var lazyVGridAdditional: some View {
        
        LazyVGrid(columns: columns,
                  alignment: .leading,
                  spacing: spacing,
                  pinnedViews: []) {
            ForEach(vm.additionalStatistic) { stat in
                StatisticView(stat: stat)
            }
        }
    }

    
    
}
