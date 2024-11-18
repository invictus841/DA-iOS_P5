//
//  AccountResponse.swift
//  Aura
//
//  Created by Alexandre Talatinian on 18/11/2024.
//

import Foundation


// La réponse que l'on attend de l'api suite à notre request
struct AccountResponse: Decodable {
    let currentBalance: Decimal
    let transactions: [APITransaction]
    
    struct APITransaction: Decodable {
        let value: Decimal
        let label: String
    }
}
