//
//  GoalView.swift
//  Financial Management
//
//  Created by Vladyslav Behim on 25.09.2023.
//

import SwiftUI


struct GoalView: View {
    @ObservedObject var viewModel:ViewModel
    @State var addMoneyToGoalView:Bool = false
    @State var infoGoalView:Bool = false
    @State var showAddGoalView:Bool = false
    @State var showInfoGoal:Bool = false
    @State var showAddMoneyToGoal:Bool = false
    @Environment(\.presentationMode) var presentationMode
    func formatDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy"
        return dateFormatter.string(from: date)
    }
    
    var body: some View {
        NavigationView{
            VStack{
                if viewModel.goals.isEmpty{
                    addGoalView(viewModel: viewModel)
                }else{
                    VStack{
                        ScrollView{
                            ForEach(viewModel.getGoal(), id: \.0) { id, goal in
                                VStack(alignment:.leading){
                                    HStack{
                                        Gauge(value: goal.collectedMoney, in: 0...goal.amountMoneyToGoal) {
                                            Text(goal.emoji)
                                                .font(.title)
                                        }
                                        .gaugeStyle(.accessoryCircularCapacity)
                                        .tint(.white)
                                        VStack(alignment:.leading, spacing:7){
                                            Text(goal.goalName)
                                            Text("\(String(goal.amountMoneyToGoal))€")
                                                .foregroundColor(Color(hue: 1.0, saturation: 0.0, brightness: 0.916))
                                        }
                                        Spacer()
                                        VStack(alignment:.trailing , spacing:7){
                                            HStack{
                                                if goal.collectedMoney < goal.amountMoneyToGoal {
                                                    NavigationLink {
                                                        AddMoneyToGoal(goalName: goal.goalName, id: id, viewModel: viewModel,collectedMoney:goal.collectedMoney, amountMoneyToGoal:goal.amountMoneyToGoal, selectedWalletType: "💳",emoji: goal.emoji)
                                                    } label: {
                                                        Image(systemName: "plus.circle")
                                                    }
                                                }else{
                                                    Image(systemName: "checkmark")
                                                }
                                            }
                                            Text("\(String(goal.collectedMoney)) €")
                                        }
                                    }
                                    VStack(alignment:.leading){
                                        
                                    }
                                    .font(.footnote)
                                    
                                }
                                .padding()
                                .background(goal.collectedMoney < goal.amountMoneyToGoal ? Color("FormGoalColor") : Color.green)
                                .foregroundColor(Color.white)
                                .cornerRadius(15)
                            }
                        }
                    }
                    .navigationBarItems(trailing:
                                            NavigationLink {
                        addGoalView(viewModel: viewModel)
                    } label: {
                        Image(systemName: "plus.circle")
                    })
                    .padding()
                    
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
            .navigationTitle("Goal")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}




struct GoalView_Previews: PreviewProvider {
    static var previews: some View {
        GoalView(viewModel: ViewModel())
    }
}
