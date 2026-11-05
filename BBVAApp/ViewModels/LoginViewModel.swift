import Foundation
final class LoginViewModel: ObservableObject {
    @Published var email = ""; @Published var password = ""; @Published var errorMessage: String?
    @Published private(set) var validEmail = ""; @Published private(set) var validPassword = ""
    var canSubmit: Bool { !email.trimmed.isEmpty && !password.isEmpty }
    @discardableResult func validate() -> Bool {
        let mail = email.trimmed
        guard Validators.isValidEmail(mail) else { errorMessage = "Correo inválido."; return false }
        if let msg = Validators.passwordError(password) { errorMessage = msg; return false }
        errorMessage = nil; validEmail = mail; validPassword = password; return true
    }
    func submit(auth: AuthStore) { guard validate() else { Haptics.error(); return }; if let err = auth.login(email: validEmail, password: validPassword) { errorMessage = err; Haptics.error() } else { Haptics.success() } }
}
