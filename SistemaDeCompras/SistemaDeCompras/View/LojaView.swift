import SwiftUI

struct LojaView: View {

    @StateObject private var viewModel = LojaViewModel()

    @EnvironmentObject var carrinhoViewModel: CarrinhoViewModel

    @State private var categoriaSelecionada: CategoriaProduto = .caes

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {

                Picker("Categoria", selection: $categoriaSelecionada) {
                    ForEach(CategoriaProduto.allCases) { categoria in
                        Text("\(categoria.rawValue)")
                            .tag(categoria)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                .padding(.vertical, 12)
                .background(Color(.systemGroupedBackground))

                List {
                    ForEach(viewModel.produtos(para: categoriaSelecionada)) { produto in
                        ProdutoLinhaView(produto: produto)
                            .environmentObject(carrinhoViewModel)
                    }
                }
                .listStyle(.plain)
                .animation(.default, value: categoriaSelecionada)
            }
            .navigationTitle("PetShop Nutrir")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    if carrinhoViewModel.totalItens > 0 {
                        HStack(spacing: 4) {
                            Image(systemName: "cart.fill")
                            Text("\(carrinhoViewModel.totalItens)")
                                .font(.callout)
                                .fontWeight(.semibold)
                        }
                        .foregroundStyle(.orange)
                    }
                }
            }
        }
    }
}

#Preview {
    LojaView()
        .environmentObject(CarrinhoViewModel())
}
