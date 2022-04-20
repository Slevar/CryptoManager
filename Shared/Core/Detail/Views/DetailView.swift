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
    @State private var showFullDescriprion: Bool = false
    
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
            VStack {
                ChartView(coin: vm.coin)
                    .padding(.vertical)
                VStack(spacing:20) {
                    overviewTitle
                    Divider()
                    descriptionSection
                    lazyVGridOverview
                    additional
                    Divider()
                    lazyVGridAdditional
                    websiteSection
                    
                }
                .padding()
            }
        }
        .navigationTitle(vm.coin.name)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                navigationBarTrailingItems
            }
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(coin: dev.coin)
    }
}

extension DetailView {
    
    private var navigationBarTrailingItems: some View {
        HStack {
            Text(vm.coin.name)
                .font(.headline)
                .foregroundColor(Color.theme.secondaryText)
            CoinImageView(coin: vm.coin)
                .frame(width: 25, height: 25)
        }
    }
    
    private var overviewTitle: some View {
        
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
    
    private var descriptionSection: some View {
        ZStack {
            VStack {
                if let coinDescription = vm.coinDescription,
                    !coinDescription.isEmpty {
                    Text(coinDescription)
                        .lineLimit(showFullDescriprion ? nil : 3)
                        .font(.callout)
                        .foregroundColor(Color.theme.secondaryText)
                    
                }
                Button {
                    withAnimation(.easeOut) {
                        showFullDescriprion.toggle()
                    }
                } label: {
                    Text(showFullDescriprion ? "Less" : "Read more...")
                        .font(.caption)
                        .fontWeight(.bold)
                        .padding(.vertical, 3)
                }
                .accentColor(Color.blue)
                .frame(width: .infinity, alignment: .leading)
            }
        }

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

    private var websiteSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            if let websiteString = vm.websiteURL,
               let url = URL(string: websiteString) {
                Link("Website", destination: url)
            }
            if let reddit = vm.redditURL,
               let url = URL(string: reddit) {
                Link("Reddit", destination: url)
            }
        }
        .accentColor(.blue)
        .font(.headline)
        .frame(width: .infinity, alignment: .leading)

    }
    
    
}
