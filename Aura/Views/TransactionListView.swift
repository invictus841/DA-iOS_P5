//
//  TransactionListView.swift
//  Aura
//
//  Created by Alexandre Talatinian on 9/11/2024.
//

import SwiftUI

struct TransactionListView: View {
    @State private var viewModel = AccountDetailViewModel()
   
   var body: some View {
       ScrollView {
           LazyVStack(spacing: 16) {
               ForEach(viewModel.allTransactions) { transaction in
                   TransactionRow(transaction: transaction)
                       .padding(.horizontal)
               }
           }
           .padding(.vertical)
       }
       .navigationTitle("All Transactions")
   }
}

struct TransactionRow: View {
   let transaction: Transaction
   
   var body: some View {
       HStack {
           VStack(alignment: .leading) {
               Text(transaction.description)
                   .font(.headline)
           }
           Spacer()
           Text("\(transaction.amount, format: .number)€")
               .font(.headline)
               .foregroundColor(transaction.amount >= 0 ? .green : .red)
       }
       .padding()
       .background(Color(.systemBackground))
       .cornerRadius(10)
       .shadow(radius: 2)
   }
}

#Preview {
    TransactionListView()
}
