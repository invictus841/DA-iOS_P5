//
//  Transaction.swift
//  Aura
//
//  Created by Alexandre Talatinian on 18/11/2024.
//

import Foundation

// Le modèle de Transaction
struct Transaction: Identifiable {
    let id = UUID()
    let description: String
    let amount: Decimal
}
