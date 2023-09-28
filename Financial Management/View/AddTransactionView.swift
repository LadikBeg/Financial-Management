//
//  AddTransactionView.swift
//  Financial Management
//
//  Created by Vladyslav Behim on 20.09.2023.
//

import SwiftUI

struct AddTransactionView: View {
    @State var amountMoney = ""
    var incomeCategory = ["💼 Salary",
                          "👨🏻‍💻 Freelance",
                          "📈 Stock",
                          "💰 Interest",
                          "🎁 Present"]
    @State var selectedCategory = "💼 Salary"
    @ObservedObject var viewModel:ViewModel

    var body: some View {
        NavigationView {
            VStack{
                HStack {
                    Text("Add income transaction")
                        .font(.title)
                    Spacer()
                }
                HStack{
                    TextField(text: $amountMoney) {
                        Text("+100 €")
                    }
                    .padding(.all,10)
                    .background(Color("UniversalColor"))
                    .cornerRadius(10)
                    Button {
                        amountMoney = ""
                    } label: {
                        Image(systemName: "multiply")
                            .foregroundColor(.gray)
                            .padding(.all,14)
                    }
                    .background(Color("UniversalColor"))
                    .cornerRadius(10)
                }
                Form{
                    Section("Purpose") {
                        Picker("Category", selection: Binding(get: {
                            selectedCategory
                        }, set: { newValue in
                            selectedCategory = newValue
                        })) {
                            ForEach(incomeCategory, id: \.self) { category in
                                Button {
                                    
                                } label: {
                                    Text(category)
                                }
                                
                            }
                            
                        }
                        .accentColor(.black)
                        .pickerStyle(.navigationLink)
                    }
                    Button {
                        viewModel.addTransaction(amountMoneyToAdd: Double(amountMoney) ?? 0, walletType: "Card", note: "gay", category: "Salary")
                    } label: {
                        Text("add")
                    }
                }
                .scrollContentBackground(.hidden)
                .background(Color("FormColor"))
                .cornerRadius(15)
            }
            .padding()
            

        }
        
    }
}

struct AddTransactionView_Previews: PreviewProvider {
    static var previews: some View {
        AddTransactionView(viewModel: ViewModel())
    }
}
