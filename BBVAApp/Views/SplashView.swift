import SwiftUI
struct SplashView: View {
    var autoAdvance = true; var onFinish: () -> Void = {}
    @State private var appeared = false; @State private var pulse = false; @State private var progress: CGFloat = 0
    var body: some View {
        ZStack {
            HeroBackground().ignoresSafeArea()
            ZStack { ForEach(0..<3, id: \.self) { i in let d = 200 + CGFloat(i) * 90; Circle().stroke(BBVA.aqua.opacity(0.30 - Double(i) * 0.08), lineWidth: 1).frame(width: d, height: d).scaleEffect(pulse ? 1.06 : 0.94).animation(.easeInOut(duration: 2.4).repeatForever(autoreverses: true).delay(Double(i) * 0.3), value: pulse) } }.allowsHitTesting(false)
            VStack(spacing: 18) { BBVAWordmark(size: 60).scaleEffect(appeared ? 1 : 0.7).opacity(appeared ? 1 : 0).animation(.spring(response: 0.9, dampingFraction: 0.75), value: appeared); Capsule().fill(BBVA.aqua).frame(width: appeared ? 64 : 0, height: 3).animation(.easeOut(duration: 0.8).delay(0.3), value: appeared); Text("CREANDO OPORTUNIDADES").font(BBVAFont.body(12, .medium)).tracking(3).foregroundColor(.white.opacity(0.8)).opacity(appeared ? 1 : 0).animation(.easeOut(duration: 0.8).delay(0.5), value: appeared) }
            VStack(spacing: 12) { Spacer(); ZStack(alignment: .leading) { Capsule().fill(Color.white.opacity(0.15)).frame(width: 120, height: 3); Capsule().fill(BBVA.aqua).frame(width: 120 * progress, height: 3) }; Text("Banca digital").font(BBVAFont.body(12, .medium)).foregroundColor(.white.opacity(0.55)) }.padding(.bottom, 48)
        }.task { appeared = true; pulse = true; withAnimation(.easeInOut(duration: 1.8)) { progress = 1 }; guard autoAdvance else { return }; try? await Task.sleep(nanoseconds: 2_200_000_000); onFinish() }
    }
}
#Preview { SplashView(autoAdvance: false) }
