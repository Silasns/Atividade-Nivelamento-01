import SwiftUI

struct ConteudoView: View {

    @StateObject private var carrinhoViewModel = CarrinhoViewModel()

    var body: some View {
        TabView {
            LojaView()
                .environmentObject(carrinhoViewModel)
                .tabItem {
                    Label("Loja", systemImage: "storefront.fill")
                }
            CarrinhoView()
                .environmentObject(carrinhoViewModel)
                .tabItem {
                    Label("Carrinho", systemImage: "cart.fill")
                }
                .badge(carrinhoViewModel.totalItens > 0 ? carrinhoViewModel.totalItens : 0)
        }
        .tint(.orange)
    }
}

#Preview {
    ConteudoView()
}
