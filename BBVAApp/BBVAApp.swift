import SwiftUI; import UIKit
@main struct BBVAApp: App {
    @StateObject private var auth = AuthStore()
    init() { let a = UINavigationBarAppearance(); a.configureWithTransparentBackground(); a.titleTextAttributes = [.font: UIFont.systemFont(ofSize: 17, weight: .semibold), .foregroundColor: UIColor.white]; UINavigationBar.appearance().standardAppearance = a; UINavigationBar.appearance().scrollEdgeAppearance = a; UINavigationBar.appearance().compactAppearance = a; UINavigationBar.appearance().tintColor = .white }
    var body: some Scene { WindowGroup { RootView().environmentObject(auth).preferredColorScheme(.dark).tint(BBVA.midBlue) } }
}
