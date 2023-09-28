//
//  WalletView.swift
//  Financial Management
//
//  Created by Vladyslav Behim on 21.09.2023.
//

import Foundation
import SwiftUI


struct CardView:View{
    @ObservedObject var cardViewData:CardViewData
    @ObservedObject var viewModel:ViewModel
    var wallet = Wallet.sharedWallet


    @State var walletType:String
    @State var walletTypeText:String
    @State var isShowHistory = false
    @State var isShowingIncomeTransaction = false
    @State var isShowingExpensesTransaction = false
    
    var body: some View{
        ZStack(){
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    Color("FormColor")
                )
            VStack(alignment: .leading){
                HStack {
                    VStack(alignment:.leading){
                        Text("\(walletType)")
                            .foregroundColor(Color("TextInFormColor"))
                            .font(.title)
                    }
                    Spacer()
                    HStack{
                        Button {
                            isShowingIncomeTransaction.toggle()
                        } label: {
                            Image(systemName: "plus.circle")
                        }
                        .foregroundColor(Color("ButtonColor"))
                        .sheet(isPresented: $isShowingIncomeTransaction) {
                            AddTransactionIncomeView(selectedWalletType: walletType, viewModel: viewModel)
                        }
                        Button {
                            isShowingExpensesTransaction.toggle()
                        } label: {
                            Image(systemName: "minus.circle")
                        }
                        .foregroundColor(Color("ButtonColor"))
                        .sheet(isPresented: $isShowingExpensesTransaction) {
                            AddTransactionExpensesView(selectedWalletType: walletType, viewModel: viewModel)
                        }
                    }
                    
                }
                .padding()
                Spacer()
                HStack{
                    VStack{
                        HStack{
                            Text("walletBalanceLabel")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                            Spacer()
                        }
                        HStack{
                            Text("\(String(format: "%.2f", cardViewData.amountMoney)) €")
                            Spacer()
                        }
                    }
                    .foregroundColor(Color("TextInFormColor"))
                    Spacer()
                    Text(viewModel.getEmoji(amountMoney: walletType == "💳" ? wallet.getAmountMoneyCard() : wallet.getAmountMoneyCash()))
                }
                .padding()
                
            }
            .accentColor(.white)
            
        }
        
        .frame( height: screenHeight * 0.16)
    }
}

class CardViewData: ObservableObject {
    @Published var amountMoney: Double
    
    init(amountMoney: Double) {
        self.amountMoney = amountMoney
    }
}


//enum categoryForIncome:String, CaseIterable{
//    case salary = "categorySalary"
//    case freelance = "categoryFreelance"
//    case stock = "stock"
//    case interest = "interest"
//    case present = "present"
//
//    func locolizeString() -> String{
//        return NSLocalizedString(self.rawValue, comment: "")
//    }
//}


struct AddTransactionIncomeView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var amountMoney = ""
    @State var selectedCategory = "💼 Salary"
    @State var isOnNote = false
    @State var noteText = ""
    @State var walletType = ["💳","💶"]
    @State var selectedWalletType:String
    @State var date = Date()
    @State var dateIsOn = false
    @State private var showingAlert = false
    
    @ObservedObject var viewModel:ViewModel
    
//    func locolizeString(category:String) -> String{
//        return NSLocalizedString(category, comment: "")
//    }
    var incomeCategory = ["categorySalary",
                          "categoryFreelance",
                          "categoryStock",
                          "categoryInterest",
                          "categoryPresent"]

    var body: some View {
        NavigationView{
            VStack{
                //Title
                HStack{
                    Text("incomeViewLabel").font(.title)
                    Spacer()
                }
                .padding()
                //AmountMoney
                HStack{
                    TextField(text: $amountMoney) {
                        Text("+ 100 €")
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .background(Color("TextFieldColor"))
                    .cornerRadius(15)
                    .keyboardType(.decimalPad)
                    .onChange(of: amountMoney) { newValue in
                        let filtered = newValue
                            .replacingOccurrences(of: ",", with: ".") // Заменяем запятую на точку
                            .filter { "0123456789.".contains($0) }
                        if filtered != newValue {
                            self.amountMoney = filtered
                        }
                    }
                }
                .padding(.horizontal)
                
                
                Form{
                    //Category
                        Picker("formCategory", selection: Binding(get: {
                            selectedCategory
                        }, set: { newValue in
                            selectedCategory = newValue
                        })) {
                            ForEach( incomeCategory , id: \.self) { category in
                                Text(viewModel.locolizeString(category: category))
                                    .foregroundColor(Color("TextInFormColor"))
                            }
                        }
                        .accentColor(.blue)
                        .pickerStyle(.navigationLink)
                    
                    
                    Section("formAdditionally"){
                        //Wallet type
                        HStack{
                            Text("formWalletType")
                            Spacer()
                            Text(selectedWalletType == "💳" ? "💳" : "💶")
                                .foregroundColor(.gray)
                        }
                        //Date piker
                        Toggle(isOn: $dateIsOn) {
                            VStack(alignment: .leading,spacing: 5){
                                Text("additionallyDate")
                                Text("additionallyDateInfo")
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                            }
                        }
                        .tint(Color("ToggleColor"))
                        
                        if dateIsOn {
                            DatePicker("additionallyDate", selection: $date , displayedComponents: .date)
                                .tint(Color("DateColor"))
                                .datePickerStyle(.graphical)
                        }
                        //Note
                        Toggle(isOn: $isOnNote) {
                            Text("additionallyNote")
                        }
                        .tint(Color("ToggleColor"))
                        if isOnNote {
                            TextField("additionallyNoteInfo", text: $noteText)
                        }
                    }
                    
                }
                .scrollContentBackground(.hidden)
                .background(Color("FormColor"))
                .cornerRadius(15)
                .padding()
                .animation(.default)

                
                
                
                //Add button
                Button {
                    viewModel.addTransaction(amountMoneyToAdd: Double(amountMoney) ?? 0, walletType: selectedWalletType, note: noteText, category: selectedCategory, date: date, typeTransaction: "+") 
                } label: {
                    HStack{
                        HStack{
                            Image(systemName: "plus.circle")
                            Text("Add")
                        }
                        .foregroundColor(Color("TextInFormColor"))
                    }
                    .padding()
                    .padding(.horizontal)
                    .background(Color("ButtonColor"))
                    .cornerRadius(15)
                    .padding(.bottom)
                    .foregroundColor(.white)
                }
                
                
            }
            
        }
    }
}

struct AddTransactionExpensesView:View {
    @Environment(\.presentationMode) var presentationMode
    @State var amountMoney = ""
    @State var selectedCategory = "🛒 Products"
    var consumptionCategory = ["🛒 Products",
                               "🧑🏻‍🍳 Eating out",
                               "🛻 Automobile",
                               "🚎 Transport",
                               "🏡 House",
                               "🏅 Sport",
                               "🩺 Health",
                               "📚 Education",
                               "🎁 Present",
                               "💻 Technique"]
    @State var walletType = ["💳","💶"]
    @State var selectedWalletType:String
    @State var isOnNote = false
    @State var date = Date()
    @State var dateIsOn = false
    @State var noteText = ""
    @ObservedObject var viewModel:ViewModel
    @State private var showingAlert = false
    
    
    
    var body: some View{
        NavigationView{
            VStack{
                //Title
                HStack{
                    Text("Add expenses transaction").font(.title)
                    Spacer()
                }
                .padding()
                
                //AmountMoney
                HStack{
                    TextField(text: $amountMoney) {
                        Text("- 100 €")
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .background(Color("TextFieldColor"))
                    .cornerRadius(15)
                    .keyboardType(.decimalPad)
                    .onChange(of: amountMoney) { newValue in
                        let filtered = newValue
                            .replacingOccurrences(of: ",", with: ".")
                            .filter { "0123456789.".contains($0) }
                        if filtered != newValue {
                            self.amountMoney = filtered
                        }
                    }
                }
                .padding(.horizontal)
                
                
                Form{
                    //Category
                    Section("Purpose") {
                        Picker("Category", selection: Binding(get: {
                            selectedCategory
                        }, set: { newValue in
                            selectedCategory = newValue
                        })) {
                            ForEach(consumptionCategory, id: \.self) { category in
                                Text(category)
                                    .foregroundColor(Color("TextInFormColor"))
                            }
                        }
                        .accentColor(.blue)
                        .pickerStyle(.navigationLink)
                    }
                    
                    Section("Additionally"){
                        //Wallet type
                        HStack{
                            Text("Wallet type")
                            Spacer()
                            Text(selectedWalletType == "💳" ? "💳" : "💶")
                                .foregroundColor(.gray)
                        }
                        //Date piker
                        Toggle(isOn: $dateIsOn) {
                            
                            VStack(alignment: .leading){
                                Text("Date")
                                Text("Default is current date")
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                            }
                        }
                        if dateIsOn {
                            DatePicker("Date", selection: $date)
                        }
                        
                        //Note
                        Toggle(isOn: $isOnNote) {
                            Text("Note")
                        }
                        if isOnNote {
                            TextField("The text of your note", text: $noteText)
                        }
                    }
                    
                    
                }
                .scrollContentBackground(.hidden)
                .background(Color("FormColor"))
                .cornerRadius(15)
                .padding()
                .animation(.default)

                
                //Add button
                Button {
                    viewModel.addTransaction(amountMoneyToAdd: Double(amountMoney) ?? 0, walletType: selectedWalletType, note: noteText, category: selectedCategory, date: date, typeTransaction: "-")

                } label: {
                    HStack{
                        HStack{
                            Image(systemName: "plus.circle")
                            Text("Add")
                        }
                        .foregroundColor(Color("TextInFormColor"))
                    }
                    .padding()
                    .padding(.horizontal)
                    .background(Color("ButtonColor"))
                    .cornerRadius(15)
                    .padding(.bottom)
                    .foregroundColor(.white)
                }
                
            }
            
        }
        
    }
}
