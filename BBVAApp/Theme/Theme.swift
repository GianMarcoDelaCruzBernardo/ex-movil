import SwiftUI; import UIKit
extension Color { init(hex: UInt32) { self.init(.sRGB, red: Double((hex >> 16) & 0xFF) / 255, green: Double((hex >> 8) & 0xFF) / 255, blue: Double(hex & 0xFF) / 255, opacity: 1) } }
extension String { var trimmed: String { trimmingCharacters(in: .whitespacesAndNewlines) } }
enum BBVA {
    static let navy = Color(hex: 0x072146), coreBlue = Color(hex: 0x004481), midBlue = Color(hex: 0x1973B8)
    static let lightBlue = Color(hex: 0x5BBEFF), aqua = Color(hex: 0x2DCCCD), serene = Color(hex: 0xDDEEFA)
    static let sand = Color(hex: 0xF4F6F9), slate = Color(hex: 0x5C6B7F), line = Color(hex: 0xD3DBE5)
    static let error = Color(hex: 0xDA3851), success = Color(hex: 0x1E8E4E)
    static let heroImage = Image("HeroBackground")
    static let hero = LinearGradient(colors: [navy, Color(hex: 0x0A3366), coreBlue], startPoint: .topLeading, endPoint: .bottomTrailing)
}
enum BBVAFont {
    enum Weight { case regular, medium, demi, bold, heavy }
    static func title(_ s: CGFloat, _ w: Font.Weight = .bold) -> Font { .system(size: s, weight: w) }
    static func body(_ s: CGFloat, _ w: Weight = .regular) -> Font {
        switch w { case .regular: return .system(size: s, weight: .regular); case .medium: return .system(size: s, weight: .medium); case .demi: return .system(size: s, weight: .semibold); case .bold: return .system(size: s, weight: .bold); case .heavy: return .system(size: s, weight: .heavy) }
    }
    static func wordmark(_ s: CGFloat) -> Font { .custom("AvenirNext-Heavy", size: s) }
}
enum Inset {
    private static var insets: UIEdgeInsets? { UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }.flatMap { $0.windows }.first(where: { $0.isKeyWindow })?.safeAreaInsets }
    static var top: CGFloat { insets?.top ?? 59 }
    static var bottom: CGFloat { insets?.bottom ?? 34 }
}
enum Demo {
    static let screen: String? = { let a = CommandLine.arguments; if let i = a.firstIndex(of: "-demo"), i + 1 < a.count { return a[i + 1] }; return nil }()
    static var isActive: Bool { screen != nil }
}
enum Haptics {
    static func success() { UINotificationFeedbackGenerator().notificationOccurred(.success) }
    static func error() { UINotificationFeedbackGenerator().notificationOccurred(.error) }
    static func tap() { UIImpactFeedbackGenerator(style: .light).impactOccurred() }
}
struct BlurView: UIViewRepresentable {
    var style: UIBlurEffect.Style
    func makeUIView(context: Context) -> UIVisualEffectView { UIVisualEffectView(effect: UIBlurEffect(style: style)) }
    func updateUIView(_ v: UIVisualEffectView, context: Context) { v.effect = UIBlurEffect(style: style) }
}
extension UINavigationController {
    open override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self as? UIGestureRecognizerDelegate
    }
}
extension UINavigationController: UIGestureRecognizerDelegate {
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        viewControllers.count > 1
    }
}
