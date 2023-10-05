//
//  FuturePayment.swift
//  Financial Management
//
//  Created by Vladyslav Behim on 05.10.2023.
//

import SwiftUI

struct FuturePayment: View {
    @ObservedObject var viewModel:ViewModel
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            VStack{
                if viewModel.futurePayments.isEmpty{
                    AddFuturePaymentView(viewModel: viewModel)
                }else{
                    VStack{
                        ScrollView {
                            ForEach(viewModel.getFuturePayment(), id: \.0) { id, payment in
                                VStack(alignment:.leading){
                                    HStack{
                                        Text(payment.FPName)
                                        Spacer()
                                        if !payment.isDone{
                                            Button {
                                                viewModel.addMoneyToFuturePayment(amountMoney: payment.FPAmount, key: id, selectedWalletType: "💳")
                                            } label: {
                                                Image(systemName: "circle.dotted")
                                            }
                                        }else{
                                            Image(systemName: "checkmark.circle")
                                        }

                                    }
                                }
                                .foregroundColor(Color.white)
                                .padding()
                                .background(payment.isDone ? Color("FromAccomplishedGoalColor") : Color("FormGoalColor"))
                                .cornerRadius(15)
                                .padding()
                                
                            }
                        }
                    }
                    .navigationBarItems(trailing:
                                            NavigationLink {
                        AddFuturePaymentView(viewModel: viewModel)
                    } label: {
                        Image(systemName: "plus.circle")
                    })
                }
            }
            .navigationBarItems(leading:
                                    Button(action: {
                presentationMode.wrappedValue.dismiss()
            }, label: {
                HStack(spacing:5){
                    Image(systemName: "chevron.left")
                    Text("Back")
                }
            }))
            .navigationTitle("Future payment")
            .navigationBarTitleDisplayMode(.inline)
        }
        
    }
}

#Preview {
    FuturePayment(viewModel: ViewModel())
}
