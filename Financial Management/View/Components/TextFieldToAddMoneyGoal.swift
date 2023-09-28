//
//  TextFieldToAddMoneyGoal.swift
//  Financial Management
//
//  Created by Vladyslav Behim on 25.09.2023.
//

import SwiftUI
@State var amMoney = ""

struct TextFieldToAddMoneyGoal: View {
    var body: some View {
        TextField("", text: $amMxoney)
            .padding()
            .background(Color("TextFieldColor"))
            .cornerRadius(15)
    }
}

struct TextFieldToAddMoneyGoal_Previews: PreviewProvider {
    static var previews: some View {
        TextFieldToAddMoneyGoal()
    }
}
