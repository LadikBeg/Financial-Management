//
//  EmojiView.swift
//  Financial Management
//
//  Created by Vladyslav Behim on 03.10.2023.
//

import SwiftUI

struct EmojiView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedEmoji:String
    @State var emoji:[String]
    let columns = [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible())
        ]
    var body: some View {
        VStack{
            ScrollView{
                LazyVGrid(columns: columns,spacing: 20, content: {
                    ForEach(emoji, id: \.self) { emoji in
                        Button(action: {
                            selectedEmoji = emoji
                            presentationMode.wrappedValue.dismiss()
                        }, label: {
                            Text("\(emoji)")
                                .padding()
                                .background(selectedEmoji == emoji ? Color("FormGoalColor") : Color("FormColor"))
                                .cornerRadius(.infinity)
                        })
                            
                    }
                })
                .padding()
            }
        }
    }
}

#Preview {
    EmojiView(selectedEmoji: .constant("😌"), emoji: ["😀","😄","🥹","🥰","🙂","😌",
                                           "🎥","🖥️","⌚️","💻","📱","📷"])
}
