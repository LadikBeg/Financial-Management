//
//  GoalView.swift
//  Financial Management
//
//  Created by Vladyslav Behim on 25.09.2023.
//

import SwiftUI

struct GoalView: View {
    @ObservedObject var viewModel:GoalViewModel
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
                                        Text(goal.goalName)
                                        Spacer()
                                        Text("\(String(goal.collectedMoney)) €")
                                    }
                                    VStack(alignment:.leading){
                                        HStack{
                                            Text("From:")
                                            Text(formatDate(date: goal.startDate))
                                            Spacer()
                                            Text("Need to collect:")
                                            Text(String(goal.amountMoneyToGoal))
                                        }
                                    }
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                                    HStack{
                                        ProgressView(value: goal.collectedMoney , total: goal.amountMoneyToGoal)
                                        NavigationLink {
                                            InfoGoalView(title: goal.goalName, collectedMoney: goal.collectedMoney, amountMoneyToGoal: goal.amountMoneyToGoal, progress: goal.progress, startDate: goal.startDate, expirationDate: Date())
                                        } label: {
                                            Image(systemName: "info.circle")
                                        }
                                        NavigationLink {
                                            AddMoneyToGoal(goalName: goal.goalName, id: id, viewModel: viewModel,collectedMoney:goal.collectedMoney, amountMoneyToGoal:goal.amountMoneyToGoal)
                                        } label: {
                                            Image(systemName: "plus.circle")
                                        }
                                    }
                                }
                                .padding()
                                .background(Color("FormColor"))
                                .cornerRadius(15)
                            }
                        }
                    }
                    .padding()
                    NavigationLink("Add goal") {
                        addGoalView(viewModel: viewModel)
                    }
                }
            }
            .navigationTitle("Goal")
        }
    }
}




struct GoalView_Previews: PreviewProvider {
    static var previews: some View {
        GoalView(viewModel: GoalViewModel())
    }
}
