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
                                        Text(goal.emoji)
                                            .font(.title)
                                        Text(goal.goalName)
                                        Spacer()
                                        Text("\(String(goal.collectedMoney)) €")
                                    }
                                    VStack(alignment:.leading){
                                        HStack{
                                            Text("Target:")
                                            Text("\(String(goal.amountMoneyToGoal))€")
                                            Spacer()
                                        }
                                        .foregroundColor(Color(hue: 1.0, saturation: 0.0, brightness: 0.916))
                                    }
                                    .font(.footnote)
                                    HStack{
                                        ProgressView(value: goal.collectedMoney , total: goal.amountMoneyToGoal)
                                            .tint(.white)
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
                    }
                    )
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
