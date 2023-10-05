//
//  AddFuturePaymentView.swift
//  Financial Management
//
//  Created by Vladyslav Behim on 05.10.2023.
//

import SwiftUI

struct AddFuturePaymentView: View {
    @State var futurePaymentName = ""
    @State var amountMoneyForFP = ""
    @State var error = false
    @ObservedObject var viewModel:ViewModel

    var body: some View {
        NavigationView{
            VStack{
                VStack{
                    TextField(text: $futurePaymentName) {
                        Text("Transaction name")
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .background(Color("TextFieldColor"))
                    .cornerRadius(15)
                    .keyboardType(.default)
                    .foregroundColor(.black)
                    
                    
                    TextField(text: $amountMoneyForFP) {
                        Text("350 €")
                            .foregroundColor(.gray)
                    }
                    .foregroundColor(.black)
                    .padding()
                    .background(Color("TextFieldColor"))
                    .cornerRadius(15)
                    .keyboardType(.decimalPad)
                    .onChange(of: amountMoneyForFP) { newValue in
                        let filtered = newValue
                            .replacingOccurrences(of: ",", with: ".")
                            .filter { "0123456789.".contains($0) }
                        if filtered != newValue {
                            self.amountMoneyForFP = filtered
                        }
                    }
                }
                .padding(.horizontal)
                
                
                Form{
                    Section("formAdditionally"){
                        Text("Test")
                        Text("Test")
                        Text("Test")
                        Text("Test")
                    }
                    
                }
                .foregroundColor(Color("TextInFormColor"))
                .scrollContentBackground(.hidden)
                .background(Color("FormColor"))
                .cornerRadius(15)
                .padding()
                
                
                
                //Add button
                Button {
                    if (futurePaymentName.isEmpty || amountMoneyForFP.isEmpty){
                        error.toggle()
                    }else{
                        viewModel.addFuturePayment(FPAmoutMoney: Double(amountMoneyForFP) ?? 0.0, FPName: futurePaymentName)
                    }
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
                    .alert("Error", isPresented: $error) {
                        
                    } message: {
                        Text(viewModel.getMessageEmptyField(amount: amountMoneyForFP, name: futurePaymentName))
                    }

                    
                }
                
            }
        }
    }
}

#Preview {
    AddFuturePaymentView(viewModel: ViewModel())
}
