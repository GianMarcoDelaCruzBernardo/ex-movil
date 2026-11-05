import SwiftUI
struct QuickAction: Identifiable { let id = UUID(); let title: String; let symbol: String }
struct HomeView: View {
    @EnvironmentObject private var auth: AuthStore; @StateObject private var vm = HomeViewModel()
    @State private var path: [ItemModel] = Demo.screen == "detail" ? [ItemModel.catalog[2]] : []
    @State private var hideBalance = false
    @State private var showProfile = false
    @State private var showTransfer = false
    @State private var showNotifications = false
    @State private var notificationsEnabled = true
    @AppStorage("notificationsEnabled") private var notifPref = true
    private let actions = [QuickAction(title: "Transferir", symbol: "arrow.left.arrow.right"), QuickAction(title: "Pagar", symbol: "qrcode.viewfinder"), QuickAction(title: "Recargar", symbol: "iphone"), QuickAction(title: "Más", symbol: "ellipsis")]
    var body: some View {
        NavigationStack(path: $path) {
            ZStack(alignment: .top) { VStack(spacing: 0) { BBVA.navy.frame(height: 420); BBVA.sand }.ignoresSafeArea(); ScrollView { VStack(spacing: -32) { header; sheet } }.scrollIndicators(.hidden).scrollDismissesKeyboard(.interactively).ignoresSafeArea(edges: .top) }
            .toolbar(.hidden, for: .navigationBar).navigationDestination(for: ItemModel.self) { DetailView(item: $0) }
            .sheet(isPresented: $showProfile) { NavigationStack { ProfileView() } }
            .sheet(isPresented: $showTransfer) { NavigationStack { TransferView() } }
            .sheet(isPresented: $showNotifications) { NavigationStack { NotificationsView() } }
        }.onAppear { notificationsEnabled = notifPref; if Demo.screen == "home-search" { vm.searchText = "tarjeta" } }
    }
    private var greeting: String { let h = Calendar.current.component(.hour, from: Date()); return h < 12 ? "Buenos días" : (h < 19 ? "Buenas tardes" : "Buenas noches") }
    private var header: some View { VStack(alignment: .leading, spacing: 24) { topBar; balanceCard; quickActionsRow }.padding(.horizontal, 20).padding(.top, Inset.top + 10).padding(.bottom, 56).frame(maxWidth: .infinity).background(HeroBackground()) }
    private var topBar: some View {
        HStack(spacing: 12) {
            Button { Haptics.tap(); showProfile = true } label: { ZStack { Circle().fill(LinearGradient(colors: [BBVA.aqua, BBVA.lightBlue], startPoint: .topLeading, endPoint: .bottomTrailing)); Text(String((auth.currentUser?.firstName ?? "C").prefix(1)).uppercased()).font(BBVAFont.title(18)).foregroundColor(BBVA.navy) }.frame(width: 44, height: 44) }.accessibilityLabel("Ver perfil")
            VStack(alignment: .leading, spacing: 2) { Text(greeting).font(BBVAFont.body(13, .medium)).foregroundColor(.white.opacity(0.7)); Button { Haptics.tap(); showProfile = true } label: { Text(auth.currentUser?.firstName ?? "Cliente").font(BBVAFont.title(22)).foregroundColor(.white) } }
            Spacer()
            Button { Haptics.tap(); showNotifications = true } label: { ZStack(alignment: .topTrailing) { Image(systemName: notificationsEnabled ? "bell.fill" : "bell.slash").font(.system(size: 16, weight: .semibold)).foregroundColor(.white).frame(width: 40, height: 40).background(Circle().fill(Color.white.opacity(0.12))); if notificationsEnabled { Circle().fill(BBVA.error).frame(width: 10, height: 10).offset(x: 10, y: -10).overlay(Circle().stroke(BBVA.navy, lineWidth: 2)) } } }.accessibilityLabel("Notificaciones")
            Button { Haptics.tap(); auth.logout() } label: { Image(systemName: "rectangle.portrait.and.arrow.right").font(.system(size: 16, weight: .semibold)).foregroundColor(.white).frame(width: 40, height: 40).background(Circle().fill(Color.white.opacity(0.12))) }.accessibilityLabel("Cerrar sesión")
        }
    }
    private var balanceCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack { Text("POSICIÓN GLOBAL").font(BBVAFont.body(11, .demi)).tracking(1.4).foregroundColor(.white.opacity(0.65)); Spacer(); Button { hideBalance.toggle() } label: { Image(systemName: hideBalance ? "eye.slash" : "eye").foregroundColor(.white.opacity(0.85)).font(.system(size: 16)) } }
            HStack(alignment: .firstTextBaseline, spacing: 4) { if hideBalance { Text("S/ ••••••").font(BBVAFont.title(38)) } else { Text("S/").font(BBVAFont.body(20, .demi)).foregroundColor(.white.opacity(0.8)); Text("12,480").font(BBVAFont.title(42)).monospacedDigit(); Text(".50").font(BBVAFont.body(22, .demi)).foregroundColor(.white.opacity(0.8)) } }.foregroundColor(.white)
            Rectangle().fill(Color.white.opacity(0.12)).frame(height: 1)
            HStack { Image(systemName: "banknote").foregroundColor(BBVA.aqua); Text("Cuenta Sueldo").font(BBVAFont.body(14, .medium)).foregroundColor(.white.opacity(0.9)); Spacer(); Text("•••• 4821").font(BBVAFont.body(14, .medium)).foregroundColor(.white.opacity(0.65)) }
        }.padding(20).background(BlurView(style: .systemUltraThinMaterialDark)).clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous)).overlay(RoundedRectangle(cornerRadius: 24, style: .continuous).stroke(Color.white.opacity(0.16)))
    }
    private var quickActionsRow: some View { HStack { ForEach(actions) { a in Button { Haptics.tap(); if a.title == "Transferir" { showTransfer = true } } label: { VStack(spacing: 8) { Image(systemName: a.symbol).font(.system(size: 20, weight: .semibold)).foregroundColor(.white).frame(width: 56, height: 56).background(Circle().fill(Color.white.opacity(0.12))).overlay(Circle().stroke(Color.white.opacity(0.18))); Text(a.title).font(BBVAFont.body(12, .medium)).foregroundColor(.white.opacity(0.85)) } }.frame(maxWidth: .infinity) } } }
    private var sheet: some View {
        VStack(alignment: .leading, spacing: 24) {
            searchBar
            if vm.searchText.isEmpty && vm.selectedCategory == nil { VStack(alignment: .leading, spacing: 14) { Text("Mi tarjeta").font(BBVAFont.title(20)).foregroundColor(BBVA.navy); BBVACardView(holder: auth.currentUser?.name ?? "Cliente", last4: "4821") } }
            chips
            HStack { Text("Productos para ti").font(BBVAFont.title(20)).foregroundColor(BBVA.navy); Spacer(); Text("\(vm.filteredItems.count)").font(BBVAFont.body(13, .demi)).foregroundColor(BBVA.midBlue).padding(.horizontal, 10).padding(.vertical, 4).background(Capsule().fill(BBVA.serene)) }.padding(.bottom, -8)
            if vm.filteredItems.isEmpty { VStack(spacing: 10) { Image(systemName: "magnifyingglass").font(.system(size: 32)).foregroundColor(BBVA.midBlue); Text("Sin resultados").font(BBVAFont.title(18)).foregroundColor(BBVA.navy); Text("Prueba con otro término.").font(BBVAFont.body(14)).foregroundColor(BBVA.slate) }.frame(maxWidth: .infinity).padding(.vertical, 40) }
            else { LazyVStack(spacing: 12) { ForEach(vm.filteredItems) { item in NavigationLink(value: item) { ItemRow(item: item) }.buttonStyle(.plain) } } }
        }.padding(.horizontal, 20).padding(.top, 28).padding(.bottom, 40).frame(maxWidth: .infinity, alignment: .leading).background(UnevenRoundedRectangle(topLeadingRadius: 32, topTrailingRadius: 32).fill(BBVA.sand)).animation(.easeInOut(duration: 0.25), value: vm.filteredItems)
    }
    private var searchBar: some View { HStack(spacing: 10) { Image(systemName: "magnifyingglass").foregroundColor(BBVA.slate); TextField("", text: $vm.searchText, prompt: Text("Buscar productos…").foregroundColor(BBVA.slate.opacity(0.7))).font(BBVAFont.body(16)).foregroundColor(BBVA.navy).tint(BBVA.coreBlue).submitLabel(.search).autocorrectionDisabled().textInputAutocapitalization(.never); if !vm.searchText.isEmpty { Button { vm.searchText = "" } label: { Image(systemName: "xmark.circle.fill").foregroundColor(BBVA.slate) } } }.padding(.horizontal, 16).frame(height: 52).background(RoundedRectangle(cornerRadius: 16, style: .continuous).fill(Color.white)).overlay(RoundedRectangle(cornerRadius: 16, style: .continuous).stroke(BBVA.line)) }
    private var chips: some View { ScrollView(.horizontal) { HStack(spacing: 10) { chip("Todos", selected: vm.selectedCategory == nil) { vm.selectedCategory = nil }; ForEach(ItemCategory.allCases) { c in chip(c.rawValue, selected: vm.selectedCategory == c) { vm.selectedCategory = c } } }.padding(.horizontal, 20) }.scrollIndicators(.hidden).padding(.horizontal, -20) }
    private func chip(_ title: String, selected: Bool, action: @escaping () -> Void) -> some View { Button(action: action) { Text(title).font(BBVAFont.body(14, .demi)).foregroundColor(selected ? .white : BBVA.coreBlue).padding(.horizontal, 16).padding(.vertical, 9).background(Capsule().fill(selected ? BBVA.coreBlue : Color.white)).overlay(Capsule().stroke(selected ? Color.clear : BBVA.line)) } }
}
struct ItemRow: View { let item: ItemModel; var body: some View { HStack(spacing: 14) { ZStack { RoundedRectangle(cornerRadius: 16, style: .continuous).fill(item.category.tint.opacity(0.12)); Image(systemName: item.symbol).font(.system(size: 22, weight: .semibold)).foregroundColor(item.category.tint) }.frame(width: 54, height: 54); VStack(alignment: .leading, spacing: 3) { Text(item.name).font(BBVAFont.body(16, .demi)).foregroundColor(BBVA.navy); Text(item.subtitle).font(BBVAFont.body(13)).foregroundColor(BBVA.slate).lineLimit(1); Text(item.rate).font(BBVAFont.body(12, .demi)).foregroundColor(item.category.tint) }; Spacer(minLength: 8); Image(systemName: "chevron.right").font(.system(size: 13, weight: .bold)).foregroundColor(BBVA.line) }.padding(14).background(RoundedRectangle(cornerRadius: 20, style: .continuous).fill(Color.white).shadow(color: BBVA.navy.opacity(0.06), radius: 12, y: 4)) } }
#Preview { HomeView().environmentObject(AuthStore()) }
