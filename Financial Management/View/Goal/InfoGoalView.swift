//
//  AddMoneyToGoalView.swift
//  Financial Management
//
//  Created by Vladyslav Behim on 25.09.2023.
//

import SwiftUI

struct InfoGoalView: View {
    @State var title:String
    @State var collectedMoney:Double
    @State var amountMoneyToGoal:Double
    @State var progress:Double
    @State var startDate:Date
    @State var expirationDate:Date
    func formatDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy"
        return dateFormatter.string(from: date)
    }
    var body: some View {
        VStack{
            VStack{
                Text(title)
                    .font(.title)
                HStack{
                    Text(String(collectedMoney))
                        .bold()
                    Divider()
                    Text(String(amountMoneyToGoal))
                }
            }
            .padding()
            .background(Color("FormColor"))
            .cornerRadius(15)
            .frame(height: screenHeight * 0.12)
            .padding(.top)
            HStack{
                VStack{
                    Text("Выполнено")
                        .font(.footnote)
                        .foregroundColor(.gray)
                    Text("\(String(format: "%.1f",collectedMoney / amountMoneyToGoal * 100)) %")
                }
                .padding()
                .background(Color("FormColor"))
                .cornerRadius(15)
                VStack{
                    Text("От")
                        .font(.footnote)
                        .foregroundColor(.gray)
                    Text("\(formatDate(date: startDate))")
                }
                .padding()
                .background(Color("FormColor"))
                .cornerRadius(15)
                if !expirationDate.description.isEmpty{
                    VStack{
                        Text("до")
                            .font(.footnote)
                            .foregroundColor(.gray)
                        Text("\(formatDate(date: expirationDate))")
                    }
                    .padding()
                    .background(Color("FormColor"))
                    .cornerRadius(15)
                }
            }
            .padding()
            VStack(alignment:.leading){
                Text("История")
                Text("Операции по этой цели")
                    .font(.footnote)
                    .foregroundColor(.gray)
                
                ScrollView{
                    
                }
            }
            .padding()
            .background(Color("FormColor"))
            .cornerRadius(15)
            .padding(.horizontal)
            
            
        }
    }
}

struct InfoGoalView_Previews: PreviewProvider {
    static var previews: some View {
        InfoGoalView(title: "Test", collectedMoney: 271, amountMoneyToGoal: 1000, progress: 0.2, startDate: Date(), expirationDate: Date())
    }
}
