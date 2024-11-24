//
//  TransactionListViewModel.swift
//  Aura
//
//  Created by Alexandre Talatinian on 9/11/2024.
//

import Foundation

class TransactionListViewModel: ObservableObject {
    @Published var transactions: [Transaction] = []
    
    let sampleTransactions: [Transaction] = [
            Transaction(description: "Starbucks", amount: -5.50),
            Transaction(description: "Amazon Purchase", amount: -34.99),
            Transaction(description: "Salary", amount: 2.500)
        ]
    
    init(accountDetailViewModel: AccountDetailViewModel) {
        self.transactions = accountDetailViewModel.getAllTransactions()
        
        print("All transactions:")
        self.transactions.forEach { transaction in
            print("\(transaction.description): \(transaction.amount)")
        }
    }
}
