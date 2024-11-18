//
//  AuthenticationView.swift
//  Aura
//
//  Created by Vincent Saluzzo on 29/09/2023.
//

import SwiftUI

struct AuthenticationView: View {
    let gradientStart = Color(hex: "#94A684").opacity(0.7)
    let gradientEnd = Color(hex: "#94A684").opacity(0.0)

    @ObservedObject var viewModel: AuthenticationViewModel
    
    private var isUsernameValid: Bool {
        viewModel.username.contains("@") && viewModel.username.contains(".")
    }
    
    private var isPasswordValid: Bool {
        viewModel.password.count > 3
    }
    
    private var isFormValid: Bool {
        isUsernameValid && isPasswordValid
    }
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [gradientStart, gradientEnd]),
                          startPoint: .top,
                          endPoint: .bottomLeading)
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 20) {
                Image(systemName: "person.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    
                Text("Welcome !")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                
                VStack {
                    Text("email adress is not valid")
                        .foregroundColor(.red)
                        .opacity(isUsernameValid ? 0 : 1)
                        .animation(.easeInOut(duration: 0.2), value: isUsernameValid)
                    
                    TextField("Adresse email", text: $viewModel.username)
                        .padding()
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(8)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                        .disableAutocorrection(true)
                }
                
                VStack {
                    SecureField("Mot de passe", text: $viewModel.password)
                        .padding()
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(8)
                    
                    Text("password should be 3 characters or more")
                        .foregroundColor(.red)
                        .opacity(isPasswordValid ? 0 : 1)
                        .animation(.easeInOut(duration: 0.2), value: isPasswordValid)
                }
                
                Button(action: {
                    if isFormValid {
                        viewModel.login()
                    }
                }) {
                    Text("Se connecter")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isFormValid ? Color.black : Color.gray)
                        .cornerRadius(8)
                }
                .disabled(!isFormValid)
            }
            .padding(.horizontal, 40)
        }
        .onTapGesture {
            self.endEditing(true)
        }
    }
}

#Preview {
    AuthenticationView(viewModel: AuthenticationViewModel({
        
    }))
}
