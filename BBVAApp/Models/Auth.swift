import Foundation
struct UserModel: Identifiable, Equatable { let id = UUID(); var name: String; var email: String; var password: String; var firstName: String { name.split(separator: " ").first.map(String.init) ?? name } }
enum Validators {
    static func isValidEmail(_ s: String) -> Bool { s.range(of: #"^[A-Za-z0-9._%+\-]+@[A-Za-z0-9.\-]+\.[A-Za-z]{2,}$"#, options: .regularExpression) != nil }
    private static let notSpecial: Set<Character> = [".", ",", ";", "´", "`", "¨", "~", "^"]
    static func isSpecial(_ c: Character) -> Bool { !c.isLetter && !c.isNumber && !c.isWhitespace && !notSpecial.contains(c) }
    static func passwordError(_ p: String) -> String? {
        if p.count < 6 { return "Mínimo 6 caracteres." }
        if !p.contains(where: { $0.isUppercase }) { return "Incluye una mayúscula." }
        if !p.contains(where: { isSpecial($0) }) { return "Incluye un carácter especial (! @ # $ %)." }
        return nil
    }
}
final class AuthStore: ObservableObject {
    @Published private(set) var users: [UserModel] = [UserModel(name: "Gian Marco", email: "demo@bbva.pe", password: "Bbva@2026")]
    @Published var currentUser: UserModel?
    init() { if ["home", "home-search", "detail"].contains(Demo.screen ?? "") { currentUser = users.first } }
    func emailExists(_ e: String) -> Bool { users.contains { $0.email.lowercased() == e.lowercased() } }
    func login(email: String, password: String) -> String? {
        if let u = users.first(where: { $0.email.lowercased() == email.lowercased() }) { guard u.password == password else { return "Correo o contraseña incorrectos." }; currentUser = u }
        else { let base = email.split(separator: "@").first.map(String.init) ?? "Cliente"; currentUser = UserModel(name: base.capitalized, email: email, password: password) }
        return nil
    }
    func register(_ u: UserModel) { users.append(u) }; func signIn(_ u: UserModel) { currentUser = u }; func logout() { currentUser = nil }
}
