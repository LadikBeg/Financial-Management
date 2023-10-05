//
//  ContentView.swift
//  Financial Management
//
//  Created by Vladyslav Behim on 20.09.2023.
//

import SwiftUI

struct MainView: View {
    @State var showingMenu = false
    @State var showAddView = false
    @State var showGoalView = false
    @State var showFuturePaymentView = false
    @State var showCalendarHistoryView = false
    @ObservedObject var viewModel = ViewModel()
    
    @State var selectedDate = Date()
    var wallet = Wallet.sharedWallet
    var body: some View {
        VStack(alignment: .leading) {
            HStack{
                Text("Financial Management")
                    .font(.title)
                Spacer()
            }
            
            //Wallets
            HStack{
                CardView(cardViewData: CardViewData(amountMoney: wallet.getAmountMoneyCard()), viewModel: viewModel, walletType: "💳", walletTypeText: NSLocalizedString("walletCardLabel", comment: ""))
                CardView(cardViewData: CardViewData(amountMoney: wallet.getAmountMoneyCash()), viewModel: viewModel, walletType: "💶", walletTypeText: NSLocalizedString("walletCashLabel", comment: ""))
            }
            .padding(.bottom,7)
            
            
            VStack(alignment: .leading){
                HStack{
                    Text("historyLabel")
                        .font(.title2)
                        .foregroundColor(Color("TextInFormColor"))
                    Spacer()
                    Button {
                        showCalendarHistoryView.toggle()
                    } label: {
                        Image(systemName: "calendar")
                            .font(.title2)
                    }
                    .foregroundColor(Color("ButtonColor"))
                    .sheet(isPresented: $showCalendarHistoryView) {
                        VStack{
                            DatePicker("Date", selection: $selectedDate, displayedComponents: [.date])
                                .datePickerStyle(.graphical)
                                .padding()
                                .accentColor(Color("DateColor"))
                            ScrollView{
                                ForEach(viewModel.getTransactions(), id: \.0) { id, transaction in
                                    if Calendar.current.isDate(transaction.date, inSameDayAs: selectedDate) {
                                        VStack {
                                            VStack{
                                                HStack{
                                                    HStack(spacing: 5){
                                                        Text(String(transaction.typeTransaction))
                                                        Text("\(String(transaction.amountMoneyToAdd)) €")
                                                    }
                                                    .foregroundColor(transaction.typeTransaction == "+" ? Color.green : Color.red)
                                                    Spacer()
                                                    VStack(spacing:10){
                                                        HStack{
                                                            Spacer()
                                                            Text(String(transaction.category))
                                                            Text(transaction.walletType == "💳" ? "💳" : "💶")
                                                        }
                                                        if !transaction.note.isEmpty{
                                                            HStack{
                                                                Spacer()
                                                                Text(String(transaction.note))
                                                            }
                                                            
                                                        }
                                                    }
                                                    .foregroundColor(.gray)
                                                    .font(.footnote)
                                                }
                                                Divider()
                                            }
                                            .padding(.vertical,6)
                                            .padding(.horizontal)
                                        }
                                        .padding(.vertical, 6)
                                        .padding(.horizontal)
                                    }
                                }
                            }
                        }
                    }
                    
                }
                .padding(.vertical,10)
                .padding(.horizontal)
                ScrollView{
                    VStack{
                        ForEach(viewModel.getTransactionsGroupedByDate(),id: \.0){ section in
                            Section(header: HStack{
                                Text(section.0).font(.headline)
                                Spacer()
                            }.padding(.horizontal)) {
                                ForEach(section.1, id: \.0) { id, transaction in
                                    VStack{
                                        HStack{
                                            HStack(spacing: 5){
                                                Text(String(transaction.typeTransaction))
                                                Text("\(String(transaction.amountMoneyToAdd)) €")
                                            }
                                            .foregroundColor(transaction.typeTransaction == "+" ? Color.green : Color.red)
                                            Spacer()
                                            VStack(spacing:10){
                                                HStack{
                                                    Spacer()
                                                    
                                                    Text(viewModel.locolizeString(category: String(transaction.category)))
                                                    Text(transaction.walletType == "💳" ? "💳" : "💶")
                                                }
                                                if !transaction.note.isEmpty{
                                                    HStack{
                                                        Spacer()
                                                        Text(String(transaction.note))
                                                    }
                                                    
                                                }
                                            }
                                            .foregroundColor(.gray)
                                            .font(.footnote)
                                        }
                                        Divider()
                                    }
                                    .padding(.vertical,6)
                                    .padding(.horizontal)
                                }
                                
                            }
                            
                            
                            
                            
                            
                        }
                    }
                }
                
            }
            .background(Color("FormColor"))
            .cornerRadius(15)
            .animation(.easeInOut, value:showingMenu)
            
            
            VStack{
                HStack{
                    VStack(alignment: .leading){
                        Text("walletBalanceLabel")
                            .foregroundColor(.gray)
                            .font(.footnote)
                        Text("\(String(format: "%.2f",wallet.getAmountMoney())) €")
                            .foregroundColor(Color("TextInFormColor"))
                    }
                    Spacer()
                    
                    Button {
                        showingMenu.toggle()
                    } label: {
                        Image(systemName: showingMenu ? "chevron.down.circle" : "chevron.up.circle")
                            .foregroundColor(Color("ButtonColor"))
                    }
                    
                }
                if showingMenu == true{
                    Divider()
                        .background(Color("DividerColor"))
                    HStack(spacing: 30){
                        Button {
                            showGoalView.toggle()
                        } label: {
                            Image(systemName: "flag.checkered")
                                .foregroundColor(.white)
                                .padding()
                                .background(Color("ButtonColor"))
                                .cornerRadius(.infinity)
                        }
                        .fullScreenCover(isPresented: $showGoalView) {
                            GoalView(viewModel: viewModel)
                        }
                        Button {
                            showFuturePaymentView.toggle()
                        } label: {
                            Image(systemName: "clock.badge")
                                .foregroundColor(.white)
                                .padding()
                                .background(Color("ButtonColor"))
                                .cornerRadius(.infinity)
                            
                        }
                        .fullScreenCover(isPresented: $showFuturePaymentView) {
                            FuturePayment(viewModel: viewModel)
                        }
                        Button {
                            
                        } label: {
                            Image(systemName: "bonjour")
                                .foregroundColor(.white)
                                .padding()
                                .background(Color("ButtonColor"))
                                .cornerRadius(.infinity)
                        }
                        Button {
                            
                        } label: {
                            Image(systemName: "checklist")
                                .foregroundColor(.white)
                                .padding()
                                .background(Color("ButtonColor"))
                                .cornerRadius(.infinity)
                        }
                        
                        
                    }
                    .foregroundColor(Color("ButtonColor"))
                    .padding(.top,5)
                }
            }
            .padding()
            .background(Color("FormColor"))
            .cornerRadius(15)
            .animation(.easeInOut, value:showingMenu)
        }
        .padding()
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
