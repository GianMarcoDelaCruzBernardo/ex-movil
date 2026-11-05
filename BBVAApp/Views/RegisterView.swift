import SwiftUI
struct RegisterView: View {
    @EnvironmentObject private var auth: AuthStore; @Environment(\.dismiss) private var dismiss; @StateObject private var vm = RegisterViewModel()
    var body: some View {
        AuthScaffold(title: "Abre tu cuenta", subtitle: "Solo te tomará un minuto.", onBack: { dismiss() }) {
            VStack(alignment: .leading, spacing: 20) {
                BBVAField(title: "Nombre completo", symbol: "person", text: $vm.name, placeholder: "Como en tu DNI", capitalization: .words)
                BBVAField(title: "Correo electrónico", symbol: "envelope", text: $vm.email, placeholder: "nombre@correo.com", keyboard: .emailAddress)
                BBVAField(title: "Contraseña", symbol: "lock", text: $vm.password, placeholder: "Mín. 6 caracteres", isSecure: true)
                BBVAField(title: "Confirmar contraseña", symbol: "lock.rotation", text: $vm.confirmPassword, placeholder: "Repite tu contraseña", isSecure: true)
                if let msg = vm.errorMessage { MessageBanner(kind: .error, text: msg) }
                if vm.didSucceed { MessageBanner(kind: .success, text: "¡Cuenta creada!").transition(.opacity.combined(with: .scale(scale: 0.95))) }
                Button("Crear cuenta") { create() }.buttonStyle(PrimaryButtonStyle()).disabled(vm.didSucceed).padding(.top, 4)
            }.animation(.easeInOut(duration: 0.25), value: vm.errorMessage).animation(.easeInOut(duration: 0.25), value: vm.didSucceed)
        }.toolbar(.hidden, for: .navigationBar).onAppear { if Demo.screen == "register-ok" { vm.name = "Gian Marco De la Cruz"; vm.email = "gian@tecsup.edu.pe"; vm.password = "Bbva#2026"; vm.confirmPassword = "Bbva#2026"; _ = vm.submit(auth: auth) } }
    }
    private func create() { guard let user = vm.submit(auth: auth) else { Haptics.error(); return }; Haptics.success(); guard !Demo.isActive else { return }; Task { @MainActor in try? await Task.sleep(nanoseconds: 1_500_000_000); auth.signIn(user) } }
}
#Preview { NavigationStack { RegisterView() }.environmentObject(AuthStore()) }
