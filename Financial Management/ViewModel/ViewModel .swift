//
//  ViewModel .swift
//  Financial Management
//
//  Created by Vladyslav Behim on 21.09.2023.
//

import Foundation

class ViewModel:ObservableObject{
    @Published var transaction:[UUID:Transaction] = [:]
    @Published var goals:[UUID:Goal] = [:]
     var wallet = Wallet.sharedWallet
    

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
    func addGoal(goalName:String , goalAmountMoney:Double , expirationDate:Date){
        let id = UUID()
        let newGoal = Goal(goalName: goalName, collectedMoney: 0, amountMoneyToGoal: goalAmountMoney, expirationDate: expirationDate, startDate: Date(), progress: 0.0)
        
        goals[id] = newGoal
    }
    func getGoal() -> [(UUID, Goal)] {
        let goalArray = self.goals.map { id, goal in
            (id, goal)
        }
        let groupedTransactions = Dictionary(grouping: goalArray) { (_, goal) in
            return formatDate(goal.startDate)
            }
        return goalArray
    }
    func addMoneyToGoal(amountMoney:Double,id:UUID){
        goals[id]?.collectedMoney += amountMoney
        print(goals[id]?.collectedMoney ?? 999)
        let amount = wallet.getAmountMoneyCard() - amountMoney
        wallet.setAmountMoneyCard(amountMoney: amount)
    }
    
    func getEmoji(amountMoney:Double) -> String{
        var emoji = ""
        if (amountMoney < 0) {
            emoji = "☹️"
        }
        if(amountMoney == 0){
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
    
    func getTransactionsGroupedByDate() -> [(String, [(UUID, Transaction)])]{
        // словарь в массив кортежей (UUID, Transaction)
        let transactionArray = self.transaction.map { id, transaction in
            (id, transaction)
        }
        // Сгруппируйте транзакции по дате
        let groupedTransactions = Dictionary(grouping: transactionArray) { (_, transaction) in
                return formatDate(transaction.date)
            }
        
        // Отсортируйте массив кортежей по размеру суммы (amountMoneyToAdd)
        let sortedArray = groupedTransactions.sorted { lhs, rhs in
                // Сортировка по убыванию даты (или по вашему выбору)
                return lhs.key > rhs.key
            }

        return sortedArray
    }
    
    func getTransactions() -> [(UUID, Transaction)] {
        // Преобразуйте словарь в массив кортежей (UUID, Transaction)
        let transactionArray = self.transaction.map { id, transaction in
            (id, transaction)
        }

        return transactionArray
    }
    
    func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM" // Формат даты, который нужен
        return dateFormatter.string(from: date)
    }
    
    func locolizeString(category:String) -> String{
        return NSLocalizedString(category, comment: "")
    }
}
