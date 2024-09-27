//
//  LoginViewModel.swift
//  TeachMeAI
//
//  Created by Kevin Lee on 9/27/24.
//

import SwiftUI

class LoginViewModel: ObservableObject {
    // Input fields
    @Published var email: String = ""
    @Published var password: String = ""

    // State for errors and login status
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
    
    // To control navigation between login and main content
    @Binding var isLoggedIn: Bool

    init(isLoggedIn: Binding<Bool>) {
        self._isLoggedIn = isLoggedIn
    }

    // Login logic
    func loginUser() {
        if email.isEmpty || password.isEmpty {
            errorMessage = "Please enter your email and password."
            showError = true
            return
        }

        // Simulate login logic (replace with actual API call or Firebase Auth)
        if email == "user@example.com" && password == "password123" {
            isLoggedIn = true  // Set login state to true
        } else {
            errorMessage = "Invalid email or password"
            showError = true
        }
    }
}
