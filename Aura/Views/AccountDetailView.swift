//
//  AccountDetailView.swift
//  Aura
//
//  Created by Vincent Saluzzo on 29/09/2023.
//

import SwiftUI

struct AccountDetailView: View {
    @ObservedObject var accountViewModel = AccountDetailViewModel()
    @ObservedObject var transactionViewModel = TransactionListViewModel(accountDetailViewModel: AccountDetailViewModel())
    
    var body: some View {
        NavigationView {  // Add this
            VStack(spacing: 20) {
                VStack(spacing: 10) {
                    Text("Your Balance")
                        .font(.headline)
                    Text("\(accountViewModel.totalAmount, format: .number)€")
                        .font(.system(size: 60, weight: .bold))
                        .foregroundColor(Color(hex: "#94A684"))
                    Image(systemName: "eurosign.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 80)
                        .foregroundColor(Color(hex: "#94A684"))
                }
                .padding(.top)
                
                // Display recent transactions
                VStack(alignment: .leading, spacing: 10) {
                    Text("Recent Transactions")
                        .font(.headline)
                        .padding([.horizontal])
                    ForEach(accountViewModel.recentTransactions) { transaction in
                        HStack {
                            Image(systemName: transaction.amount >= 0 ? "arrow.up.right.circle.fill" : "arrow.down.left.circle.fill")
                                .foregroundColor(transaction.amount >= 0 ? .green : .red)
                            Text(transaction.description)
                            Spacer()
                            Text("\(transaction.amount, format: .number)€")
                                .fontWeight(.bold)
                                .foregroundColor(transaction.amount >= 0 ? .green : .red)
                        }
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                        .padding([.horizontal])
                    }
                }
                
                // Replace Button with NavigationLink
                NavigationLink(destination: TransactionListView()) {
                    HStack {
                        Image(systemName: "list.bullet")
                        Text("See Transaction Details")
                    }
                    .padding()
                    .background(Color(hex: "#94A684"))
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                .padding([.horizontal, .bottom])
                
                Spacer()
            }
            .onTapGesture {
                self.endEditing(true)
            }
        }  // Close NavigationView
    }
}

#Preview {
    AccountDetailView(transactionViewModel: TransactionListViewModel(accountDetailViewModel: AccountDetailViewModel()))
}
