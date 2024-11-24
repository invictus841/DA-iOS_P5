//
//  MoneyTransferViewModelTests.swift
//  AuraTests
//
//  Created by Alexandre Talatinian on 23/11/2024.
//

import XCTest
@testable import Aura

class MoneyTransferViewModelTests: XCTestCase {
    var sut: MoneyTransferViewModel!
    var mockNetwork: MockNetworkService!
    var mockKeychain: MockKeychainManager!


    override func setUp() {
        super.setUp()
        mockNetwork = MockNetworkService()
        mockKeychain = MockKeychainManager()
        mockKeychain.savedToken = "test-token" // Simulate having a saved token
        
        sut = MoneyTransferViewModel(networkService: mockNetwork, keychainManager: mockKeychain)
    }
    
    override func tearDown() {
        sut = nil
        mockNetwork = nil
        mockKeychain = nil
        super.tearDown()
    }
    
    
    func testSendMoneySuccessWhenValidRecipientAndValidAmount() {
        // Given
        let expectation = XCTestExpectation(description: "Send Money Success")
        let testAmount = "100"
        let testRecipient = "test@test.com"
        sut.amount = testAmount
        sut.recipient = testRecipient
        mockNetwork.shouldSucceed = true
        mockKeychain.shouldSaveSucceed = true
        
        // When
        sut.sendMoney()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            // Then
            XCTAssertEqual(self.sut.showError, false)
            XCTAssertEqual(self.sut.transferMessage, "Successfully transferred \(testAmount)€ to \(testRecipient)")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testSendMoneyFailWhenNotValidRecipientButValidAmount() {
        // Given
        let expectation = XCTestExpectation(description: "Send Money Success")
        let testAmount = "cent"
        let testRecipient = "test@test.com"
        sut.amount = testAmount
        sut.recipient = testRecipient
        mockNetwork.shouldSucceed = false
        mockKeychain.shouldSaveSucceed = true
        
        // When
        sut.sendMoney()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            // Then
            XCTAssertEqual(self.sut.showError, true)
            XCTAssertEqual(self.sut.transferMessage, "Invalid amount format")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testSendMoneyFailedWhenNetworkFails() {
        // Given
        let expectation = XCTestExpectation(description: "Network Failure")
        let testAmount = "100"
        let testRecipient = "test@test.com"
        sut.amount = testAmount
        sut.recipient = testRecipient
        mockNetwork.shouldSucceed = false
        mockNetwork.error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Network connection failed"])
        
        // When
        sut.sendMoney()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            // Then
            XCTAssertEqual(self.sut.showError, true)
            XCTAssertEqual(self.sut.transferMessage, "Transfer failed: Network connection failed")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
}
