//
//  AuthenticationViewModelTests.swift
//  AuraTests
//
//  Created by Alexandre Talatinian on 20/11/2024.
//

import XCTest
@testable import Aura


class AuthenticationViewModelTests: XCTestCase {
    var sut: AuthenticationViewModel!
    var mockNetwork: MockNetworkService!
    var mockKeychain: MockKeychainManager!
    var loginSucceeded: Bool!
    
    // Set up before each test
    override func setUp() {
        super.setUp()
        mockNetwork = MockNetworkService()
        mockKeychain = MockKeychainManager()
        loginSucceeded = false
        
        sut = AuthenticationViewModel(
            networkService: mockNetwork,
            keychainManager: mockKeychain
        ) {
            self.loginSucceeded = true
        }
    }
    
    // Clean up after each test
    override func tearDown() {
        sut = nil
        mockNetwork = nil
        mockKeychain = nil
        loginSucceeded = nil
        super.tearDown()
    }
    
    // TEST 1: Successful login
    func testLoginSuccess() {
        // Given
        mockNetwork.shouldSucceed = true
        mockNetwork.resultToken = "test-token"
        mockKeychain.shouldSaveSucceed = true
        sut.username = "test@aura.app"
        sut.password = "test123"
        
        // When
        sut.login()
        
        // Then
        XCTAssertTrue(loginSucceeded)
        XCTAssertFalse(sut.showError)
        XCTAssertEqual(mockKeychain.savedToken, "test-token")
    }
    
    // TEST 2: Network error
    func testLoginFailure_NetworkError() {
        // Given
        mockNetwork.shouldSucceed = false
        mockNetwork.error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Network error"])
        sut.username = "test@aura.app"
        sut.password = "test123"
        
        // When
        sut.login()
        
        // Then
        XCTAssertFalse(loginSucceeded)
        XCTAssertTrue(sut.showError)
        XCTAssertEqual(sut.errorMessage, "Network error")
    }
    
    // TEST 3: Keychain save failure
    func testLoginFailure_KeychainError() {
        // Given
        mockNetwork.shouldSucceed = true
        mockNetwork.resultToken = "test-token"
        mockKeychain.shouldSaveSucceed = false
        sut.username = "test@aura.app"
        sut.password = "test123"
        
        // When
        sut.login()
        
        // Then
        XCTAssertFalse(loginSucceeded)
        XCTAssertTrue(sut.showError)
        XCTAssertEqual(sut.errorMessage, "Failed to save authentication token")
    }
}
