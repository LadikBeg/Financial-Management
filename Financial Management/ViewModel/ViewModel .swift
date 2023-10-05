//
//  ViewModel .swift
//  Financial Management
//
//  Created by Vladyslav Behim on 21.09.2023.
//

import Foundation
import SwiftUI

class ViewModel:ObservableObject{
    @Published var transaction:[UUID:Transaction] = [:]
    @Published var goals:[UUID:Goal] = [:]

    var wallet = Wallet.sharedWallet
    
    //Transaction
    func addTransaction(amountMoneyToAdd:Double, walletType:String , note:String,category:String,date:Date,typeTransaction:String){
        let id = UUID()
        let newTransaction = Transaction(amountMoneyToAdd: amountMoneyToAdd, walletType: walletType, note: note, category: category, date: date, typeTransaction: typeTransaction)
        transaction[id] = newTransaction
        if walletType == "💳"{
            if typeTransaction == "+"{
                let amount = wallet.getAmountMoneyCard() + amountMoneyToAdd
                wallet.setAmountMoneyCard(amountMoney: amount)
            }else{
                let amount = wallet.getAmountMoneyCard() - amountMoneyToAdd
                wallet.setAmountMoneyCard(amountMoney: amount)
            }
        }else{
            if typeTransaction == "+"{
                let amount = wallet.getAmountMoneyCash() + amountMoneyToAdd
                wallet.setAmountMoneyCash(amountMoney: amount)
            }else{
                let amount = wallet.getAmountMoneyCash() - amountMoneyToAdd
                wallet.setAmountMoneyCash(amountMoney: amount)
            }
        }
    }
    func getTransactionsGroupedByDate() -> [(String, [(UUID, Transaction)])]{
        let transactionArray = self.transaction.map { id, transaction in
            (id, transaction)
        }
        let groupedTransactions = Dictionary(grouping: transactionArray) { (_, transaction) in
                return formatDate(transaction.date)
            }
        let sortedArray = groupedTransactions.sorted { lhs, rhs in
                return lhs.key > rhs.key
            }

        return sortedArray
    }
    
    func getTransactions() -> [(UUID, Transaction)] {
        let transactionArray = self.transaction.map { id, transaction in
            (id, transaction)
        }

        return transactionArray
    }
    
    func getEmoji(amountMoney:Double) -> String{
        var emoji = ""
        if (amountMoney < 0) {
            emoji = "☹️"
        }
        if(amountMoney < 200){
            emoji = "😐"
        }
        if(amountMoney >= 200){
            emoji = "🙂"
        }
        if(amountMoney >= 600){
            emoji = "😌"
        }
        return emoji
    }
    
    
    //Date formatter
    func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM" // Формат даты, который нужен
        return dateFormatter.string(from: date)
    }
    
    func locolizeString(category:String) -> String{
        return NSLocalizedString(category, comment: "")
    }
    
    //goal
    func addGoal(goalName:String , goalAmountMoney:Double,emoji:String){
        let id = UUID()
        print("id - \(id)")
        let newGoal = Goal(goalName: goalName, collectedMoney: 0, amountMoneyToGoal: goalAmountMoney, startDate: Date(), progress: 0.0, emoji: emoji)
        goals[id] = newGoal
        print("goal - \(goals)")
    }
    func getGoal() -> [(UUID, Goal)] {
        let goalArray = self.goals.map { id, goal in
            (id, goal)
        }
        return goalArray
    }
    func addMoneyToGoal(amountMoney:Double,key:UUID,selectedWalletType:String, emoji:String){
        let id = UUID()
        goals[key]?.collectedMoney += amountMoney
        var amount = 0.0
        if selectedWalletType == "💳"{
            amount = wallet.getAmountMoneyCard() - amountMoney
            wallet.setAmountMoneyCard(amountMoney: amount)

        }else{
            amount = wallet.getAmountMoneyCash() - amountMoney
            wallet.setAmountMoneyCash(amountMoney: amount)
        }
        let newTransaction = Transaction(amountMoneyToAdd: amountMoney, walletType: "💳", note: "", category: emoji + (goals[key]?.goalName ?? ""), date: Date(), typeTransaction: "-")
        transaction[id] = newTransaction
    }
    func getMessageEmptyField(amount amountMoneyToGoal:String, name nameGoal:String ) ->String{
        var message = ""
        if amountMoneyToGoal.isEmpty{
            message = "The amount to be collected cannot be zero."
        }
        if nameGoal.isEmpty{
            message = "The target name field cannot be empty."
        }
        if(nameGoal.isEmpty && amountMoneyToGoal.isEmpty){
            message = "Fill in all fields."
        }
        return message
    }
}





