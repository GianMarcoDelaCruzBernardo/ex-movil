import SwiftUI
struct RootView: View {
    @EnvironmentObject private var auth: AuthStore; @State private var showSplash = (Demo.screen == nil || Demo.screen == "splash")
    var body: some View {
        ZStack { BBVA.navy.ignoresSafeArea()
            if showSplash { SplashView(autoAdvance: Demo.screen == nil) { showSplash = false }.transition(.opacity) }
            else if auth.currentUser != nil { HomeView().transition(.opacity) }
            else { AuthFlow().transition(.opacity) }
        }.animation(.easeInOut(duration: 0.45), value: showSplash).animation(.easeInOut(duration: 0.45), value: auth.currentUser)
    }
}
