import Foundation
final class RegisterViewModel: ObservableObject {
    @Published var name = ""; @Published var email = ""; @Published var password = ""; @Published var confirmPassword = ""
    @Published var errorMessage: String?; @Published var didSucceed = false
    func submit(auth: AuthStore) -> UserModel? {
        let n = name.trimmed; let m = email.trimmed
        guard !n.isEmpty, !m.isEmpty, !password.isEmpty, !confirmPassword.isEmpty else { errorMessage = "Completa todos los campos."; return nil }
        guard Validators.isValidEmail(m) else { errorMessage = "Correo inválido."; return nil }
        guard !auth.emailExists(m) else { errorMessage = "Correo ya registrado."; return nil }
        if let msg = Validators.passwordError(password) { errorMessage = msg; return nil }
        guard password == confirmPassword else { errorMessage = "Contraseñas no coinciden."; return nil }
        let u = UserModel(name: n, email: m, password: password); auth.register(u); errorMessage = nil; didSucceed = true; return u
    }
}
