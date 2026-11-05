import SwiftUI

extension ItemCategory { var tint: Color { switch self { case .cuentas: return BBVA.coreBlue; case .tarjetas: return Color(hex: 0x0E9AA0); case .creditos: return BBVA.midBlue; case .seguros: return Color(hex: 0x2F6FB5); case .inversion: return Color(hex: 0x0F8F7A) } } }

struct BBVAWordmark: View { var size: CGFloat; var color: Color = .white; var body: some View { Text("BBVA").font(BBVAFont.wordmark(size)).tracking(size * 0.06).foregroundColor(color) } }

struct HeroBackground: View {
    var body: some View {
        GeometryReader { geo in
            ZStack {
                BBVA.heroImage
                    .resizable()
                    .scaledToFill()
                    .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                    .clipped()
                
                // Overlay azul más suave para que se vea la imagen
                BBVA.navy.opacity(0.25)
                
                // Círculos decorativos
                ZStack {
                    ForEach(0..<4, id: \.self) { i in
                        let d = geo.size.width * (0.55 + 0.28 * CGFloat(i))
                        Circle().stroke(Color.white.opacity(0.08), lineWidth: 1).frame(width: d, height: d).offset(x: geo.size.width * 0.42, y: -geo.size.height * 0.12)
                    }
                    Circle().fill(BBVA.aqua.opacity(0.15)).frame(width: geo.size.width * 0.75, height: geo.size.width * 0.75).blur(radius: 50).offset(x: geo.size.width * 0.45, y: -geo.size.height * 0.12)
                    Circle().fill(BBVA.lightBlue.opacity(0.10)).frame(width: geo.size.width * 0.6, height: geo.size.width * 0.6).blur(radius: 50).offset(x: -geo.size.width * 0.4, y: geo.size.height * 0.3)
                }
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled
    func makeBody(configuration: Configuration) -> some View {
        configuration.label.font(BBVAFont.body(17, .demi)).foregroundColor(.white).frame(maxWidth: .infinity).frame(height: 56)
            .background(RoundedRectangle(cornerRadius: 18, style: .continuous).fill(isEnabled ? LinearGradient(colors: [BBVA.coreBlue, BBVA.midBlue], startPoint: .leading, endPoint: .trailing) : LinearGradient(colors: [BBVA.coreBlue.opacity(0.35), BBVA.coreBlue.opacity(0.35)], startPoint: .leading, endPoint: .trailing)))
            .shadow(color: isEnabled ? BBVA.coreBlue.opacity(0.28) : .clear, radius: 14, y: 8)
            .scaleEffect(configuration.isPressed ? 0.98 : 1).animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label.font(BBVAFont.body(16, .demi)).foregroundColor(BBVA.coreBlue).frame(maxWidth: .infinity).frame(height: 54)
            .background(RoundedRectangle(cornerRadius: 18, style: .continuous).fill(Color.white)).overlay(RoundedRectangle(cornerRadius: 18, style: .continuous).stroke(BBVA.line))
            .scaleEffect(configuration.isPressed ? 0.98 : 1).animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }
}

struct MessageBanner: View {
    enum Kind { case error, success }; let kind: Kind; let text: String
    private var color: Color { kind == .error ? BBVA.error : BBVA.success }
    var body: some View {
        HStack(alignment: .top, spacing: 10) { Image(systemName: kind == .error ? "exclamationmark.circle.fill" : "checkmark.seal.fill"); Text(text).font(BBVAFont.body(14, .medium)).fixedSize(horizontal: false, vertical: true); Spacer(minLength: 0) }
            .foregroundColor(color).padding(14).background(RoundedRectangle(cornerRadius: 14, style: .continuous).fill(color.opacity(0.10))).overlay(RoundedRectangle(cornerRadius: 14, style: .continuous).stroke(color.opacity(0.3)))
    }
}

struct BBVAField: View {
    let title: String; let symbol: String; @Binding var text: String; var placeholder = ""; var isSecure = false; var keyboard: UIKeyboardType = .default; var capitalization: TextInputAutocapitalization = .never
    @FocusState private var focused: Bool; @State private var reveal = false
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title).font(BBVAFont.body(13, .demi)).foregroundColor(focused ? BBVA.coreBlue : BBVA.slate)
            HStack(spacing: 12) {
                Image(systemName: symbol).font(.system(size: 17, weight: .medium)).foregroundColor(focused ? BBVA.coreBlue : BBVA.slate).frame(width: 22)
                Group { if isSecure && !reveal { SecureField("", text: $text, prompt: Text(placeholder).foregroundColor(BBVA.slate.opacity(0.55))) } else { TextField("", text: $text, prompt: Text(placeholder).foregroundColor(BBVA.slate.opacity(0.55))).keyboardType(keyboard).textInputAutocapitalization(capitalization) } }
                    .focused($focused).autocorrectionDisabled().font(BBVAFont.body(17, .medium)).foregroundColor(BBVA.navy).tint(BBVA.coreBlue)
                if isSecure { Button { reveal.toggle() } label: { Image(systemName: reveal ? "eye.slash" : "eye").foregroundColor(BBVA.slate) } }
            }.padding(.horizontal, 16).frame(height: 56)
            .background(RoundedRectangle(cornerRadius: 16, style: .continuous).fill(Color.white))
            .overlay(RoundedRectangle(cornerRadius: 16, style: .continuous).stroke(focused ? BBVA.midBlue : BBVA.line, lineWidth: focused ? 1.5 : 1))
            .shadow(color: focused ? BBVA.midBlue.opacity(0.18) : .clear, radius: 8, y: 2)
            .contentShape(Rectangle()).onTapGesture { focused = true }.animation(.easeOut(duration: 0.2), value: focused)
        }
    }
}

struct BBVACardView: View {
    let holder: String; let last4: String
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack { BBVAWordmark(size: 22); Spacer(); Image(systemName: "wave.3.right").font(.system(size: 20, weight: .semibold)).foregroundColor(.white.opacity(0.85)) }
            Spacer()
            RoundedRectangle(cornerRadius: 6, style: .continuous).fill(LinearGradient(colors: [Color(hex: 0xF1D98A), Color(hex: 0xC9A24B)], startPoint: .topLeading, endPoint: .bottomTrailing)).frame(width: 42, height: 32).padding(.bottom, 14)
            Text("••••  ••••  ••••  \(last4)").font(.system(size: 19, weight: .medium, design: .monospaced)).foregroundColor(.white).padding(.bottom, 14)
            HStack(alignment: .bottom) { VStack(alignment: .leading, spacing: 2) { Text("TITULAR").font(BBVAFont.body(9, .demi)).tracking(1.2).foregroundColor(.white.opacity(0.6)); Text(holder.uppercased()).font(BBVAFont.body(13, .demi)).foregroundColor(.white).lineLimit(1) }; Spacer(); Text("DÉBITO").font(BBVAFont.body(12, .heavy)).tracking(1).foregroundColor(BBVA.aqua) }
        }.padding(22).aspectRatio(1.586, contentMode: .fit)
        .background(RoundedRectangle(cornerRadius: 24, style: .continuous).fill(LinearGradient(colors: [Color(hex: 0x0B4A8F), BBVA.navy], startPoint: .topLeading, endPoint: .bottomTrailing))
            .overlay(ZStack { Circle().fill(BBVA.aqua.opacity(0.18)).frame(width: 220, height: 220).offset(x: 120, y: -90); Circle().stroke(Color.white.opacity(0.10), lineWidth: 1).frame(width: 280, height: 280).offset(x: 130, y: -100); Circle().fill(BBVA.lightBlue.opacity(0.12)).frame(width: 170, height: 170).offset(x: -130, y: 110) })
            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous)))
        .shadow(color: BBVA.navy.opacity(0.35), radius: 22, y: 12)
    }
}

struct AuthScaffold<Content: View>: View {
    let title: String; let subtitle: String; var onBack: (() -> Void)?; let content: Content
    init(title: String, subtitle: String, onBack: (() -> Void)? = nil, @ViewBuilder content: () -> Content) { self.title = title; self.subtitle = subtitle; self.onBack = onBack; self.content = content() }
    var body: some View {
        ZStack {
            HeroBackground().ignoresSafeArea()
            VStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 14) {
                    HStack(spacing: 14) { if let onBack { Button { Haptics.tap(); onBack() } label: { Image(systemName: "chevron.left").font(.system(size: 16, weight: .bold)).foregroundColor(.white).frame(width: 38, height: 38).background(Circle().fill(Color.white.opacity(0.14))) }.accessibilityLabel("Volver") }; BBVAWordmark(size: 26); Spacer() }
                    Text(title).font(BBVAFont.title(32)).foregroundColor(.white).lineLimit(1).minimumScaleFactor(0.7)
                    Text(subtitle).font(BBVAFont.body(16)).foregroundColor(.white.opacity(0.75))
                }.frame(maxWidth: .infinity, alignment: .leading).padding(.horizontal, 24).padding(.top, 12).padding(.bottom, 32)
                VStack(spacing: 0) {
                    ScrollView { content.padding(.horizontal, 24).padding(.top, 32).padding(.bottom, 24).frame(maxWidth: .infinity, alignment: .leading) }.scrollBounceBehavior(.basedOnSize).scrollDismissesKeyboard(.interactively)
                    HStack(spacing: 8) { Image(systemName: "lock.shield.fill").foregroundColor(BBVA.midBlue); Text("Conexión cifrada · Banca segura").font(BBVAFont.body(12, .medium)).foregroundColor(BBVA.slate) }.frame(maxWidth: .infinity).padding(.vertical, 14)
                }.frame(maxHeight: .infinity).background(UnevenRoundedRectangle(topLeadingRadius: 32, topTrailingRadius: 32).fill(BBVA.sand).ignoresSafeArea(edges: .bottom))
            }
        }
    }
}
