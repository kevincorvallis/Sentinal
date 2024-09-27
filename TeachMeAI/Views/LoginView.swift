import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var phoneNumber: String = ""
    @State private var verificationCode: String = ""
    @State private var verificationID: String?
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""
    @State private var isLoading: Bool = false
    
    @Binding var isLoggedIn: Bool  // Binding to control login state
    
    var body: some View {
        ZStack {
            // Background Gradient
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.6), Color.purple.opacity(0.8)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                // App Title or Logo
                Text("Sentinal")
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .shadow(radius: 10)
                    .padding(.top, 80)
                
                Spacer()
                
                // Phone Number Field
                CustomTextField(placeholder: "Phone Number", text: $phoneNumber, keyboardType: .phonePad)
                
                // Send Verification Code Button
                Button(action: sendVerificationCode) {
                    Text("Send Verification Code")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                        .foregroundColor(.white)
                        .shadow(radius: 5)
                        .opacity(isLoading ? 0.5 : 1)
                }
                .disabled(isLoading)
                
                // Verification Code Field
                CustomTextField(placeholder: "Verification Code", text: $verificationCode, keyboardType: .numberPad)
                
                // Verify Button
                Button(action: verifyCode) {
                    Text("Verify Code")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(10)
                        .foregroundColor(.white)
                        .shadow(radius: 5)
                        .opacity(isLoading ? 0.5 : 1)
                }
                .disabled(isLoading)
                
                // Error Message
                if showError {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                        .padding(.horizontal, 24)
                        .transition(.opacity)
                        .animation(.easeInOut)
                }
                
                Spacer()
            }
            .padding(.horizontal, 24)
            
            if isLoading {
                // Loading Indicator
                ProgressView()
                    .scaleEffect(1.5)
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .shadow(radius: 10)
            }
        }
    }

    // Custom reusable TextField with styling
    struct CustomTextField: View {
        var placeholder: String
        @Binding var text: String
        var keyboardType: UIKeyboardType
        
        var body: some View {
            TextField(placeholder, text: $text)
                .keyboardType(keyboardType)
                .padding()
                .background(Color.white.opacity(0.2))
                .cornerRadius(10)
                .foregroundColor(.white)
                .shadow(radius: 5)
                .padding(.horizontal, 24)
        }
    }

    // Send the verification code to the phone number
    func sendVerificationCode() {
        isLoading = true
        let formattedPhoneNumber = phoneNumber.replacingOccurrences(of: " ", with: "")
        
        PhoneAuthProvider.provider().verifyPhoneNumber(formattedPhoneNumber, uiDelegate: nil) { verificationID, error in
            isLoading = false
            if let error = error {
                showError = true
                errorMessage = "Error sending verification code: \(error.localizedDescription)"
                return
            }
            self.verificationID = verificationID
        }
    }

    // Verify the entered code
    func verifyCode() {
        guard let verificationID = verificationID else {
            showError = true
            errorMessage = "No verification ID found. Please request a new code."
            return
        }
        
        isLoading = true
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: verificationCode)
        
        Auth.auth().signIn(with: credential) { authResult, error in
            isLoading = false
            if let error = error {
                showError = true
                errorMessage = "Error verifying code: \(error.localizedDescription)"
                return
            }
            isLoggedIn = true
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    @State static var isLoggedIn = false
    
    static var previews: some View {
        LoginView(isLoggedIn: $isLoggedIn)
    }
}
