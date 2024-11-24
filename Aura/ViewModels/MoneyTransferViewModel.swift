//
//  MoneyTransferViewModel.swift
//  Aura
//
//  Created by Vincent Saluzzo on 29/09/2023.
//

import Foundation

class MoneyTransferViewModel: ObservableObject {
    @Published var recipient: String = ""
    @Published var amount: String = ""
    @Published var transferMessage: String = ""
    
    @Published var isTransferring: Bool = false
    @Published var showError: Bool = false
    
    private let networkService: NetworkService
    private let keychainManager: KeychainManaging
    
    init(
        networkService: NetworkService = URLSessionNetworkService(),
        keychainManager: KeychainManaging = KeychainManager.standard
    ) {
        self.networkService = networkService
        self.keychainManager = keychainManager
    }
    
    func sendMoney() {
        guard let url = URL(string: "http://127.0.0.1:8080/account/transfer"),
              let token = keychainManager.getToken(),
              let amountDecimal = Decimal(string: amount) else {
            transferMessage = "Invalid amount format"
            showError = true
            return
        }
        
        let transferData = [
            "recipient": recipient,
            "amount": amountDecimal
        ] as [String: Any]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: transferData) else {
            transferMessage = "Error preparing data"
            showError = true
            return
        }
        
        isTransferring = true
        
        networkService.makeRequest(
            url: url,
            method: "POST",
            body: jsonData,
            token: token
        ) { [weak self] (result: Result<[String: String], Error>) in
            DispatchQueue.main.async {
                self?.isTransferring = false
                
                switch result {
                case .success:
                    self?.transferMessage = "Successfully transferred \(self?.amount ?? "0")€ to \(self?.recipient ?? "")"
                    self?.showError = false
                    self?.amount = ""
                    self?.recipient = ""
                case .failure(let error):
                    self?.transferMessage = "Transfer failed: \(error.localizedDescription)"
                    self?.showError = true
                }
            }
        }
    }
}
