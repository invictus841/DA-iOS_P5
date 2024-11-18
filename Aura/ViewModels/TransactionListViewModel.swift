//
//  TransactionListViewModel.swift
//  Aura
//
//  Created by Alexandre Talatinian on 9/11/2024.
//

import Foundation

class TransactionListViewModel: ObservableObject {
    @Published var transactions: [Transaction] = []
    
    
    init(accountDetailViewModel: AccountDetailViewModel) {
//        self.transactions = accountDetailViewModel.getAllTransactions()
        
        print("All transactions:")
        self.transactions.forEach { transaction in
            print("\(transaction.description): \(transaction.amount)")
        }
    }
}
