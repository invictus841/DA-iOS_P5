//
//  AccountDetailViewModelTests.swift
//  AuraTests
//
//  Created by Alexandre Talatinian on 22/11/2024.
//

import XCTest
@testable import Aura

class AccountDetailViewModelTests: XCTestCase {
    var sut: AccountDetailViewModel!
    var mockNetwork: MockNetworkService!
    var mockKeychain: MockKeychainManager!
    
    // Sample test data
    let sampleAccountResponse = AccountResponse(
        currentBalance: 1000.0,
        transactions: [
            AccountResponse.APITransaction(value: 500.0, label: "Deposit"),
            AccountResponse.APITransaction(value: -4.5, label: "Coffee"),
            AccountResponse.APITransaction(value: 2000.0, label: "Salary"),
            AccountResponse.APITransaction(value: -50.0, label: "Restaurant")
        ]
    )
    
    override func setUp() {
        super.setUp()
        mockNetwork = MockNetworkService()
        mockKeychain = MockKeychainManager()
        mockKeychain.savedToken = "test-token" // Simulate having a saved token
        
        sut = AccountDetailViewModel(
            networkService: mockNetwork,
            keychainManager: mockKeychain
        )
    }
    
    override func tearDown() {
        sut = nil
        mockNetwork = nil
        mockKeychain = nil
        super.tearDown()
    }
    
    func testFetchAccountDetailsSuccess() {
        // Given
        let expectation = XCTestExpectation(description: "Fetch Success")
        mockNetwork.shouldSucceed = true
        mockNetwork.mockData = sampleAccountResponse
        
        // When
        sut.fetchAccountDetails()
        
        // Wait for async operation
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            // Then
            XCTAssertEqual(self.sut.totalAmount, 1000.0)
            XCTAssertEqual(self.sut.allTransactions.count, 4)
            XCTAssertEqual(self.sut.recentTransactions.count, 3)
            XCTAssertNil(self.sut.error)
            
            // Verify first transaction
            let firstTransaction = self.sut.allTransactions.first
            XCTAssertEqual(firstTransaction?.description, "Deposit")
            XCTAssertEqual(firstTransaction?.amount, 500.0)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }

    func testGetAllTransactions() {
        // Given
        let expectation = XCTestExpectation(description: "Get All Transactions")
        mockNetwork.shouldSucceed = true
        mockNetwork.mockData = sampleAccountResponse
        
        // When
        sut.fetchAccountDetails()
        
        // Wait for async operation
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let transactions = self.sut.getAllTransactions()
            
            // Then
            XCTAssertEqual(transactions.count, 4)
            if !transactions.isEmpty {
                XCTAssertEqual(transactions[0].description, "Deposit")
                XCTAssertEqual(transactions[0].amount, 500.0)
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
}
