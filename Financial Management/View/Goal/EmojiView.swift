//
//  EmojiView.swift
//  Financial Management
//
//  Created by Vladyslav Behim on 03.10.2023.
//

import SwiftUI

struct EmojiView: View {
    @Binding var selectedEmoji:String
    @State var emoji:[String]
    @State var tech:[String]
    @State var activity:[String]
    @State var travel:[String]
    @State var food:[String]
    var body: some View {
        VStack{
            ScrollView{
                LazyVStack(selectedEmoji: $selectedEmoji, emoji: emoji, headerOfSection: "Face")
                LazyVStack(selectedEmoji: $selectedEmoji, emoji: tech, headerOfSection: "Technique")
                LazyVStack(selectedEmoji: $selectedEmoji, emoji: activity, headerOfSection: "Activity")
                LazyVStack(selectedEmoji: $selectedEmoji, emoji: travel, headerOfSection: "Travel and places")
                LazyVStack(selectedEmoji: $selectedEmoji, emoji: food, headerOfSection: "Food")
            }
            .scrollIndicators(.hidden)
        }
    }
}

struct LazyVStack: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedEmoji:String
    @State var emoji:[String]
    @State var headerOfSection:String
    let columns = [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible())
        ]
    var body: some View {
        VStack{
                Section {
                    ScrollView(.horizontal){
                        LazyHGrid(rows: columns,spacing: 20, content: {
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
                    }
                    .scrollIndicators(.hidden)
                } header: {
                    HStack{
                        Text("\(headerOfSection)")
                            .font(.title2)
                            .foregroundStyle(.secondary)
                        Spacer()
                    }
                }
                .padding(.horizontal)
        
            

            
        }
    }
}

