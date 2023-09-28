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

    func formatDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy"
        return dateFormatter.string(from: date)
    }
    var body: some View {
        NavigationView{
            VStack{
                //Title
                HStack{
                    Text("\(goalName)").font(.title)
                    Spacer()
                }
                .padding()
                //AmountMoney
                VStack{
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
                            .replacingOccurrences(of: ",", with: ".") // Заменяем запятую на точку
                            .filter { "0123456789.".contains($0) }
                        if filtered != newValue {
                            self.amountMoney = filtered
                        }
                    }
                }
                .padding(.horizontal)
                
                Form{
                    Section("formAdditionally"){
                        HStack{
                            Text("Дата")
                            Spacer()
                            Text("\(formatDate(date: date))")
                                .foregroundColor(.gray)
                        }
                    }
                    
                }
                .scrollContentBackground(.hidden)
                .background(Color("FormColor"))
                .cornerRadius(15)
                .padding()
                
                
                
                //Add button
                Button {
                    viewModel.addMoneyToGoal(amountMoney: Double(amountMoney) ?? 0, id: id)
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
        .animation(.default)
    }
}

struct AddMoneyToGoal_Previews: PreviewProvider {
    static var previews: some View {
        AddMoneyToGoal(goalName: "Test", id: UUID(), viewModel: ViewModel())
    }
}