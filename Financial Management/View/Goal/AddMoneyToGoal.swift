//
//  AddMoneyToGoal.swift
//  Financial Management
//
//  Created by Vladyslav Behim on 25.09.2023.
//

import SwiftUI

struct AddMoneyToGoal: View {
    @State var goalName:String
    @State var id:UUID
    @State var amountMoney:String = ""
    @State var date = Date()
    @ObservedObject var viewModel:ViewModel
    @State var collectedMoney:Double
    @State var amountMoneyToGoal:Double
    @Environment(\.presentationMode) var presentationMode
    @State var selectedWalletType:String
    @State var emoji:String
    @State var walletType = ["💳","💶"]
    
    func formatDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy"
        return dateFormatter.string(from: date)
    }
    
    var body: some View {
        NavigationView{
            VStack{
                VStack{
                    HStack{
                        Text("\(goalName)")
                        Text(emoji)
                    }
                    .font(.title)
                    TextField(text: $amountMoney) {
                        Text("1000 €")
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
                VStack(alignment:.leading){
                    Text("Select the type of wallet from which you transfer money").font(.footnote)                        .foregroundColor(.gray)
                    Picker("Wallet type", selection: $selectedWalletType) {
                        ForEach(walletType,id: \.self) { walletType in
                            Text(walletType)
                        }
                        
                    }
                    .pickerStyle(.segmented)
                    
                }
                .padding(.top)
                .padding(.horizontal)
                Form{
                    Section("formAdditionally"){
                        HStack{
                            Text("Дата")
                            Spacer()
                            Text("\(formatDate(date: date))")
                                .foregroundColor(.gray)
                        }
                        HStack{
                            Text("Цель")
                            Spacer()
                            Text("\(String(format: "%.2f",amountMoneyToGoal)) €")
                                .foregroundColor(.gray)
                        }
    
                    }
                    Section {
                        HStack{
                            Text("Осталось собрать")
                            Spacer()
                            Text("\(String(format: "%.2f",amountMoneyToGoal - collectedMoney)) €")
                                .foregroundColor(.gray)
                        }
                        HStack{
                            Text("Собрано")
                            Spacer()
                            Text("\(String(format: "%.2f",collectedMoney)) €")
                                .foregroundColor(.gray)
                        }
                        HStack{
                            Text("Выполнено")
                            Spacer()
                            Text("\(String(format: "%.1f",collectedMoney / amountMoneyToGoal * 100)) %")                                .foregroundColor(.gray)
                        }
                    }
                    
                }
                .scrollContentBackground(.hidden)
                .background(Color("FormColor"))
                .cornerRadius(15)
                .padding()
                
                
                
                //Add button
                Button {
                    presentationMode.wrappedValue.dismiss()
                    viewModel.addMoneyToGoal(amountMoney: Double(amountMoney) ?? 0, key: id)
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

struct AddMoneyToGoal_Previews: PreviewProvider {
    static var previews: some View {
        AddMoneyToGoal(goalName: "Дом", id: UUID(), viewModel: ViewModel(),collectedMoney:20,amountMoneyToGoal:251, selectedWalletType: "💳", emoji: "🏡")
    }
}

