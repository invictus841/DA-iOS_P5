//
//  AccountDetailViewModel.swift
//  Aura
//
//  Created by Vincent Saluzzo on 29/09/2023.
//

import Foundation

class AccountDetailViewModel: ObservableObject {
    @Published var totalAmount: Decimal = 0.0
    @Published var recentTransactions: [Transaction] = []
    @Published var error: String?
    
    var allTransactions: [Transaction] = []
    
    private let networkService: NetworkService
    private let keychainManager: KeychainManaging
    
    init(
        networkService: NetworkService = URLSessionNetworkService(),
        keychainManager: KeychainManaging = KeychainManager.standard
    ) {
        self.networkService = networkService
        self.keychainManager = keychainManager
        fetchAccountDetails()
    }
    
    func getAllTransactions() -> [Transaction] {
        return allTransactions
    }
    
    func fetchAccountDetails() {
        guard let url = URL(string: "http://127.0.0.1:8080/account"),
              let token = keychainManager.getToken() else {
            self.error = "Invalid URL or no token available"
            return
        }
        
        networkService.makeRequest(
            url: url,
            method: "GET",
            body: nil,
            token: token
        ) { [weak self] (result: Result<AccountResponse, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let accountResponse):
                    self?.totalAmount = accountResponse.currentBalance
                    self?.allTransactions = accountResponse.transactions.map { transaction in
                        return Transaction(description: transaction.label, amount: transaction.value)
                    }
                    self?.recentTransactions = Array((self?.allTransactions.prefix(3))!)
                    self?.error = nil
                    
                case .failure(let error):
                    self?.error = error.localizedDescription
                }
            }
        }
    }
}

//class AccountDetailViewModel: ObservableObject {
//    @Published var totalAmount: Decimal = 0.0
//    
//    @Published var recentTransactions: [Transaction] = []
//    
//    var allTransactions: [Transaction] = []
//    
//    init() {
//        fetchAccountDetails()
//    }
//    
//    func getAllTransactions() -> [Transaction] {
//           return allTransactions
//       }
//    
//    func fetchAccountDetails() {
//       guard let url = URL(string: "http://127.0.0.1:8080/account"),
//             let token = KeychainManager.standard.getToken() else { return }
//       
//       var request = URLRequest(url: url)
//       request.setValue(token, forHTTPHeaderField: "token")
//       
//       URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
//           guard let data = data,
//                 let accountResponse = try? JSONDecoder().decode(AccountResponse.self, from: data) else { return }
//           
//           DispatchQueue.main.async {
//               self?.totalAmount = accountResponse.currentBalance
//               
//               self?.allTransactions = accountResponse.transactions.map { transaction in
//                   return Transaction(description: transaction.label, amount: transaction.value)
//               }
//               
//               self?.recentTransactions = Array((self?.allTransactions.prefix(3))!)
//               
//               print("Transactions récentes:")
//               self?.recentTransactions.forEach { transaction in
//                   print("\(transaction.description): \(transaction.amount)")
//               }
//           }
//       }.resume()
//    }}
