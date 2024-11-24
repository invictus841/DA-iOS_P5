//
//  MoneyTransferView.swift
//  Aura
//
//  Created by Vincent Saluzzo on 29/09/2023.
//

import SwiftUI

struct MoneyTransferView: View {
    @ObservedObject var viewModel = MoneyTransferViewModel()
    @State private var animationScale: CGFloat = 1.0
    
    @State private var showAlert = false
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "arrow.right.arrow.left.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundColor(Color(hex: "#94A684"))
                .padding()
                .scaleEffect(animationScale)
                .onAppear {
                    withAnimation(Animation.easeInOut(duration: 0.5).repeatForever(autoreverses: true)) {
                        animationScale = 1.2
                    }
                }
            
            Text("Send Money!")
                .font(.largeTitle)
                .fontWeight(.heavy)
            
            VStack(alignment: .leading) {
                Text("Recipient (Email or Phone)")
                    .font(.headline)
                TextField("Enter recipient's info", text: $viewModel.recipient)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .keyboardType(.emailAddress)
            }
            
            VStack(alignment: .leading) {
                Text("Amount (€)")
                    .font(.headline)
                TextField("0.00", text: $viewModel.amount)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .keyboardType(.decimalPad)
            }
            
            Button(action: validateAndSend) {
                HStack {
                    Image(systemName: "arrow.right.circle.fill")
                    Text("Send")
                }
                .padding()
                .background(Color(hex: "#94A684"))
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            
            
            if !viewModel.transferMessage.isEmpty && !viewModel.showError {
                Text(viewModel.transferMessage)
                    .foregroundColor(.green)
                    .padding(.top, 20)
            }
            
            Spacer()
        }
        .padding()
        .onTapGesture {
            self.endEditing(true)
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Error"),
                message: Text(viewModel.transferMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    private func validateAndSend() {
        if viewModel.recipient.isEmpty {
            viewModel.transferMessage = "Please enter recipient"
            viewModel.showError = true
            showAlert = true
            return
        }
        
        let emailPattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}+"
            if !NSPredicate(format:"SELF MATCHES %@", emailPattern).evaluate(with: viewModel.recipient) {
                viewModel.transferMessage = "Please enter a valid email address"
                viewModel.showError = true
                showAlert = true
                return
            }
        
        if viewModel.amount.isEmpty {
            viewModel.transferMessage = "Please enter amount"
            viewModel.showError = true
            showAlert = true
            return
        }
        
        viewModel.sendMoney()
    }
}


#Preview {
    MoneyTransferView()
}
