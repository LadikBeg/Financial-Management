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
    @Environment(\.presentationMode) var presentationMode


    var body: some View {
        VStack{
            HStack{
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Back")
                }

            }
            if viewModel.getGoal().isEmpty{
                addGoalView(viewModel: viewModel)
            }else{
                ListForGoal(goals: viewModel.getGoal(), viewModel: viewModel)
                
            }
        }
    }
}

struct ListForGoal:View{
    @State var goals:[(UUID, Goal)]
    @State var showInfoGoal:Bool = false
    @State var showAddMoneyToGoal:Bool = false
    @ObservedObject var viewModel:ViewModel
    
    var body: some View{
        VStack{
            ScrollView{
                ForEach(goals, id: \.0) { id, goal in
                    VStack{
                        HStack{
                            Text(goal.goalName)
                            Spacer()
                            Text("\(String(goal.collectedMoney)) €")
                            Button {
                                showInfoGoal.toggle()
                            } label: {
                                Image(systemName: "info.circle")
                            }
                            .foregroundColor(Color("ButtonColor"))
                            .sheet(isPresented: $showInfoGoal) {
                                InfoGoalView(title: goal.goalName, collectedMoney: goal.collectedMoney, amountMoneyToGoal: goal.amountMoneyToGoal, progress: goal.progress, startDate: goal.startDate, expirationDate: goal.expirationDate)
                            }
                            Button {
                                showAddMoneyToGoal.toggle()
                            } label: {
                                Image(systemName: "plus.circle")
                            }
                            .foregroundColor(Color("ButtonColor"))
                            .sheet(isPresented: $showAddMoneyToGoal) {
                                AddMoneyToGoal(goalName: goal.goalName, id: id, viewModel: viewModel)
                            }
                        }
                        ProgressView(value: goal.collectedMoney , total: goal.amountMoneyToGoal)
                        
                    }
                    .padding()
                    .background(Color("FormColor"))
                    .cornerRadius(15)
                }
            }
        }
        .padding()
    }
    
}
class GoalViewData: ObservableObject {
    @Published var collected: Double
    
    init(collected: Double) {
        self.collected = collected
    }
}

struct GoalView_Previews: PreviewProvider {
    static var previews: some View {
        GoalView(viewModel: ViewModel())
    }
}
