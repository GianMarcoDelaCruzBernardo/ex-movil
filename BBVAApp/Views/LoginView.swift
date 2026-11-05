import SwiftUI
enum AuthRoute: Hashable { case register }
struct AuthFlow: View { @State private var path: [AuthRoute] = (Demo.screen == "register" || Demo.screen == "register-ok") ? [.register] : []; var body: some View { NavigationStack(path: $path) { LoginView().navigationDestination(for: AuthRoute.self) { _ in RegisterView() } } } }
struct LoginView: View {
    @EnvironmentObject private var auth: AuthStore; @StateObject private var vm = LoginViewModel()
    var body: some View {
        AuthScaffold(title: "Bienvenido de nuevo", subtitle: "Ingresa a tu banca digital de forma segura.") {
            VStack(alignment: .leading, spacing: 20) {
                BBVAField(title: "Correo electrónico", symbol: "envelope", text: $vm.email, placeholder: "nombre@correo.com", keyboard: .emailAddress)
                BBVAField(title: "Contraseña", symbol: "lock", text: $vm.password, placeholder: "Tu contraseña", isSecure: true)
                HStack { Spacer(); Text("¿Olvidaste tu contraseña?").font(BBVAFont.body(14, .demi)).foregroundColor(BBVA.midBlue) }
                if let msg = vm.errorMessage { MessageBanner(kind: .error, text: msg).transition(.opacity.combined(with: .move(edge: .top))) }
                Button("Ingresar") { vm.submit(auth: auth) }.buttonStyle(PrimaryButtonStyle()).disabled(!vm.canSubmit).padding(.top, 4)
                HStack(spacing: 12) { Rectangle().fill(BBVA.line).frame(height: 1); Text("o").font(BBVAFont.body(13, .medium)).foregroundColor(BBVA.slate); Rectangle().fill(BBVA.line).frame(height: 1) }
                Button { vm.email = "demo@bbva.pe"; vm.password = "Bbva@2026"; vm.submit(auth: auth) } label: { HStack(spacing: 10) { Image(systemName: "faceid"); Text("Acceso rápido demo") } }.buttonStyle(SecondaryButtonStyle())
                HStack(spacing: 6) { Text("¿No tienes cuenta?").foregroundColor(BBVA.slate); NavigationLink(value: AuthRoute.register) { Text("Regístrate").foregroundColor(BBVA.coreBlue).fontWeight(.semibold) } }.font(BBVAFont.body(15, .medium)).frame(maxWidth: .infinity).padding(.top, 6)
            }.animation(.easeInOut(duration: 0.25), value: vm.errorMessage)
        }.toolbar(.hidden, for: .navigationBar).onAppear { if Demo.screen == "login-error" { vm.email = "gian@correo"; vm.password = "abc"; vm.validate() } }
    }
}
#Preview { AuthFlow().environmentObject(AuthStore()) }
