//
//  PortfolioView.swift
//  CryptoManager (iOS)
//
//  Created by Вардан Мукучян on 11.04.2022.
//

import SwiftUI

struct PortfolioView: View {

    @EnvironmentObject private var vm: HomeViewModel
    // Переменная будет хранить тот коин, на который мы нажмём, в дальнейшем будем сопоставлять id нажатого и нынешнего коина - если совпадают, то произведём действие
    @State private var selectedCoin: CoinModel? = nil
    @State private var quantityText: String = ""
    @State private var showCheckMark: Bool = false



    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    SearchBarView(searchText: $vm.searchText)
                    coinLogoList

                    if selectedCoin != nil {
                        portfolioInputSection
                    }

                } // VStack
            } // ScrollView
            .navigationTitle("Edit Portfolio")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    XMarkButton()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    trailingNavBarButton
                }
            }
            onChange(of: vm.searchText) { newValue in
                if newValue == "" {
                    removeSelectedCoin()
                }
            }
        } // NavigationView
    }
}

struct PortfolioView_Previews: PreviewProvider {
    static var previews: some View {

        PortfolioView()
            .environmentObject(dev.homeVM)
    }
}

extension PortfolioView {
    
    private var coinLogoList: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 10) {
                ForEach(vm.searchText.isEmpty ? vm.portfolioCoins : vm.allCoins) { coin in
                    CoinLogoView(coin: coin)
                        .frame(width: 75)
                        .padding()
                        .onTapGesture {
                            withAnimation(.easeIn) {
                                selectedCoin = coin
                                //quantityText = ""
                            }
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(
                                    selectedCoin?.id == coin.id ?
                                    Color.theme.green : Color.clear
                                    , lineWidth: 1)
                        )
                }
            }
            .padding(.vertical, 4)
            .padding(.leading)
        }

    }

    private func getCurrentValue() -> Double {
        if let quantity = Double(quantityText) {
            return quantity * (selectedCoin?.currentPrice ?? 0)
        }
        return 0
    }

    private var portfolioInputSection: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Current price of \((selectedCoin?.symbol.uppercased()) ?? ""):")
                Spacer()
                Text(selectedCoin?.currentPrice.asCurrencyWith6Decimals() ?? "")
            }
            Divider()
            HStack {
                Text("Amount holding:")
                Spacer()
                TextField("Ex: 1.4", text: $quantityText)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
            }
            Divider()
            HStack {
                Text("Current value")
                Spacer()
                Text(getCurrentValue().asCurrencyWith2Decimals())
            }
        }
        .animation(.none, value: 0)
        .padding()
        .font(.headline)
    }

    private var trailingNavBarButton: some View {
        HStack(spacing:10) {
            Image(systemName: "checkmark")
                .opacity(showCheckMark ? 1.0 : 0.0)
            Button {
                saveButtonPressed()
            } label: {
                Text("Save".uppercased())
            }
            .opacity((selectedCoin != nil && selectedCoin?.currentHoldings != Double(quantityText))  ? 1.0 : 0.0)
        }
        .font(.headline)
    }

    private func saveButtonPressed() {
        guard
            let coin = selectedCoin,
            let amount = Double(quantityText)
        else {
            return
        }
        // Сохранить в портфолио
        
        vm.updatePortfolio(coin: coin, amount: amount)

        // show checkmark

        withAnimation(.easeIn) {
            showCheckMark = true
            removeSelectedCoin()
        }

        // hide keyboard
        UIApplication.shared.endEditing()

        // hide CheckMark
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation(.easeOut) {
                showCheckMark = false
            }
        }
    }

    private func removeSelectedCoin() {
        selectedCoin = nil
        vm.searchText = ""
    }
}
