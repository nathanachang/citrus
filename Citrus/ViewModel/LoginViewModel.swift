import Foundation
import SwiftUI

class LoginViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var isLoggedIn: Bool = false
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    private let userDefaults = UserDefaults.standard
    
    init() {
        checkExistingLogin()
    }
    
    private func checkExistingLogin() {
        if let token = userDefaults.string(forKey: "accessToken"), !token.isEmpty {
            self.isLoggedIn = true
        }
    }
    
    func login() {
        guard !username.isEmpty else {
            errorMessage = "Username cannot be empty"
            return
        }
        
        guard !password.isEmpty else {
            errorMessage = "Password cannot be empty"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        LoginAction(
            parameters: LoginRequest(
                username: username,
                password: password
            )
        ).call { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                switch result {
                case .success(let response):
                    // Store tokens in UserDefaults for now
                    // In a production app, use Keychain instead
                    self?.userDefaults.set(response.data.accessToken, forKey: "accessToken")
                    self?.userDefaults.set(response.data.refreshToken, forKey: "refreshToken")
                    self?.isLoggedIn = true
                    
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func logout() {
        userDefaults.removeObject(forKey: "accessToken")
        userDefaults.removeObject(forKey: "refreshToken")
        isLoggedIn = false
    }
}
