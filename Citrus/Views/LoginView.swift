import SwiftUI

struct LoginScreen: View {
    @ObservedObject var viewModel: LoginViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                // Logo or app title
                Image(systemName: "lock.shield")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80, height: 80)
                    .foregroundColor(.blue)
                    .padding(.bottom, 20)
                
                Text("Welcome Back")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 30)
                
                VStack(spacing: 20) {
                    TextField(
                        "Login.UsernameField.Title".localized,
                        text: $viewModel.username
                    )
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    SecureField(
                        "Login.PasswordField.Title".localized,
                        text: $viewModel.password
                    )
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    if let error = viewModel.errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                
                Button(action: viewModel.login) {
                    if viewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                    } else {
                        Text("Login.LoginButton.Title".localized)
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .foregroundColor(.white)
                    }
                }
                .disabled(viewModel.isLoading)
                .background(Color.blue)
                .cornerRadius(10)
                .padding(.horizontal)
                
                NavigationLink(
                    destination: MainView(),
                    isActive: $viewModel.isLoggedIn,
                    label: { EmptyView() }
                )
            }
            .padding(30)
        }
    }
}

struct LoginScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoginScreen(viewModel: LoginViewModel())
    }
}
