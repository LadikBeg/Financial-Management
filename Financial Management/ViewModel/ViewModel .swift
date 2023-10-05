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
    @Published var futurePayments:[UUID:PaymentInFuture] = [:]

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
        let newGoal = Goal(goalName: goalName, collectedMoney: 0, amountMoneyToGoal: goalAmountMoney, startDate: Date(), progress: 0.0, emoji: emoji)
        goals[id] = newGoal
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
    func getMessageEmptyField(amount amountMoney:String, name nameFor:String ) ->String{
        var message = ""
        if amountMoney.isEmpty{
            message = "The amount to be collected cannot be zero."
        }
        if nameFor.isEmpty{
            message = "The name field cannot be empty."
        }
        if(nameFor.isEmpty && amountMoney.isEmpty){
            message = "Fill in all fields."
        }
        return message
    }
    func getExpensesForDay(date: Date) -> Double {
        // Фильтруем транзакции, оставляем только те, которые имеют дату, совпадающую с выбранным днем.
        let filteredTransactions = transaction.values.filter { transaction in
            Calendar.current.isDate(transaction.date, inSameDayAs: date)
        }
        
        // Вычисляем общую сумму расходов за день.
        let expensesForDay = filteredTransactions.reduce(0.0) { result, transaction in
            if transaction.typeTransaction == "-" {
                // Учитываем только те транзакции, которые являются расходами (с отрицательным типом).
                return result + transaction.amountMoneyToAdd
            } else {
                return result
            }
        }
        return expensesForDay
    }
    //FUTURE PAYMENT
    func addFuturePayment(FPAmoutMoney:Double, FPName:String){
        let id = UUID()
        let newPayment = PaymentInFuture(FPName: FPName, FPAmount: FPAmoutMoney, isDone: false)
        futurePayments[id] = newPayment
    }
    
    func addMoneyToFuturePayment(amountMoney:Double,key:UUID,selectedWalletType:String){
        let id = UUID()
        futurePayments[key]?.FPAmount += amountMoney
        futurePayments[key]?.isDone = true
        var amount = 0.0
        if selectedWalletType == "💳"{
            amount = wallet.getAmountMoneyCard() - amountMoney
            wallet.setAmountMoneyCard(amountMoney: amount)

        }else{
            amount = wallet.getAmountMoneyCash() - amountMoney
            wallet.setAmountMoneyCash(amountMoney: amount)
        }
        let newTransaction = Transaction(amountMoneyToAdd: amountMoney, walletType: "💳", note: "", category: "🧾" + (futurePayments[key]?.FPName ?? ""), date: Date(), typeTransaction: "-")
        transaction[id] = newTransaction
    }
    func getFuturePayment() -> [(UUID, PaymentInFuture)] {
        let futurePaymentArray = self.futurePayments.map { id, payment in
            (id, payment)
        }
        return futurePaymentArray
    }
}





