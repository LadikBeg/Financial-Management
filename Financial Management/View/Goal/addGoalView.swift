//
//  addGoalView.swift
//  Financial Management
//
//  Created by Vladyslav Behim on 25.09.2023.
//

import SwiftUI

struct addGoalView: View {
    @State var goalName:String = ""
    @State var goalAmountMoney:String = ""
    @State var dateIsOn:Bool = false
    @State var date = Date()
    @State var error = false
    @ObservedObject var viewModel:ViewModel
    @State var emoji = ["😀","😄","🥹","🥰","🙂","😌",
                        "🎥","🖥️","⌚️","💻","📱","📷",
                        "🐶","🐱","🐭","🐹","🦊","🐮",
                        "⚽️","🏀","🏈","🎾","🏓","🥊",
                        "🧘‍♀️","🤽","🤺","🏂","🪂","🧗",
                        "🚗","🚲","🛴","✈️","🏖️","🛳️",
                        "🏡","🏠","🏘️","🏚️","🛖","⛺️",
                        "🏢","💒","🏥","🏬","⛪️","🏣"]
    @State var selectedEmoji = "🙂"
    @Environment(\.presentationMode) var presentationMode

    
    
    var body: some View {
        NavigationView{
            VStack{
                NavigationLink {
                    EmojiView(selectedEmoji: $selectedEmoji, emoji: emoji)
                        .navigationBarBackButtonHidden(true)
                } label: {
                    Text("\(selectedEmoji)")
                        .padding()
                        .background(Color("FormColor"))
                        .cornerRadius(.infinity)
                        .font(.largeTitle)
                        
                }
                

                VStack{
                    TextField(text: $goalName) {
                        Text("Goal name")
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .background(Color("TextFieldColor"))
                    .cornerRadius(15)
                    .keyboardType(.default)
                    
                    TextField(text: $goalAmountMoney) {
                        Text("1000 €")
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .background(Color("TextFieldColor"))
                    .cornerRadius(15)
                    .keyboardType(.decimalPad)
                    .onChange(of: goalAmountMoney) { newValue in
                        let filtered = newValue
                            .replacingOccurrences(of: ",", with: ".") 
                            .filter { "0123456789.".contains($0) }
                        if filtered != newValue {
                            self.goalAmountMoney = filtered
                        }
                    }
                }
                .padding(.horizontal)
                
                
                Form{
                    Section("formAdditionally"){
                        //Date piker
                        Toggle(isOn: $dateIsOn) {
                            VStack(alignment: .leading,spacing: 5){
                                Text("additionallyDate")
                                Text("additionallyDateInfo")
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                            }
                        }
                        .tint(Color("ToggleColor"))
                        
                        if dateIsOn {
                            DatePicker("additionallyDate", selection: $date , displayedComponents: .date)
                                .tint(Color("DateColor"))
                                .datePickerStyle(.graphical)
                        }
                        
                    }
                    
                }
                .scrollContentBackground(.hidden)
                .background(Color("FormColor"))
                .cornerRadius(15)
                .padding()
                
                
                
                //Add button
                Button {
                    if (goalAmountMoney.isEmpty || goalName.isEmpty){
                        error.toggle()
                    }else{
                        viewModel.addGoal(goalName: goalName, goalAmountMoney: Double(goalAmountMoney) ?? 0, emoji: selectedEmoji)
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
                        Text(viewModel.getMessageEmptyField(amount: goalAmountMoney, name: goalName))
                    }

                    
                }
                
            }
        }
    }
}

struct addGoalView_Previews: PreviewProvider {
    static var previews: some View {
        addGoalView(viewModel: ViewModel())
    }
}
