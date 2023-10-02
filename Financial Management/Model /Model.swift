//
//  Model.swift
//  Financial Management
//
//  Created by Vladyslav Behim on 21.09.2023.
//

import Foundation

class Wallet:ObservableObject{
    static var sharedWallet = Wallet()

    private var amountMoney:Double{
        return amountMoneyCard + amountMoneyCash
    }
    private var amountMoneyCard:Double = 0.0
    private var amountMoneyCash:Double = 0.0
    
    
    func getAmountMoney() -> Double{
        return self.amountMoney
    }
    
    func getAmountMoneyCard() -> Double{
        return self.amountMoneyCard
    }
    
    func getAmountMoneyCash() -> Double{
        return self.amountMoneyCash
    }
    
    func setAmountMoneyCard(amountMoney:Double){
        self.amountMoneyCard = amountMoney
    }
    
    func setAmountMoneyCash(amountMoney:Double){
        self.amountMoneyCash = amountMoney
    }
    
}

class Transaction:Wallet{
    var typeTransaction:String
    var amountMoneyToAdd:Double
    var walletType:String
    var note:String
    var category:String
    var date:Date
    
    init(amountMoneyToAdd: Double, walletType: String, note: String, category: String,date:Date,typeTransaction:String) {
        self.amountMoneyToAdd = amountMoneyToAdd
        self.walletType = walletType
        self.note = note
        self.category = category
        self.date = date
        self.typeTransaction = typeTransaction
    }
}

class Goal:Wallet{
    var goalName:String
    var collectedMoney:Double
    var amountMoneyToGoal:Double
    var startDate:Date
    var progress:Double
    var showInfo:Bool
    
    init(goalName: String, collectedMoney: Double,amountMoneyToGoal:Double,startDate:Date,progress:Double,showInfo:Bool) {
        self.goalName = goalName
        self.collectedMoney = collectedMoney
        self.amountMoneyToGoal = amountMoneyToGoal
        self.startDate = startDate
        self.progress = progress
        self.showInfo = showInfo
    }
}
