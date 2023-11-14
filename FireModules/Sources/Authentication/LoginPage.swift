import SwiftUI
import CoreUI

public struct LoginPage: View {
    
    @ObserveInjection private var iO
    
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var verifiedPassword: String = ""
    @State private var isFormValid: Bool = false
    
    public init() {}
    
    public var body: some View {
        Form {
            VStack {
                Section(footer: Text("").foregroundColor(.red)) {
                    TextField("Enter your username", text: $username)
                        .autocapitalization(.none)
                }
                Section(footer: Text("").foregroundColor(.red)) {
                    SecureField("Enter your password", text: $password)
                    SecureField("Re-enter your password", text: $verifiedPassword)
                }
                Section {
                    Button(action: { }) {
                        Text("Sign in")
                    }
                    .disabled(!isFormValid)
                }
            }
        }
        .enableInjection()
    }
}

//struct SwiftUIView_Previews: PreviewProvider {
//    static var previews: some View {
//        SwiftUIView()
//    }
//}
