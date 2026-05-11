import SwiftUI

struct CarrinhoView: View {

    @EnvironmentObject var carrinhoViewModel: CarrinhoViewModel

    var body: some View {
        NavigationStack {
            Group {
                if carrinhoViewModel.itens.isEmpty {
                    carrinhoVazioView
                } else {
                    conteudoCarrinhoView
                }
            }
            .navigationTitle("Carrinho")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                if !carrinhoViewModel.itens.isEmpty {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(role: .destructive) {
                            carrinhoViewModel.limparCarrinho()
                        } label: {
                            Text("Limpar")
                                .foregroundStyle(.red)
                        }
                    }
                }
            }
        }
    }

    private var carrinhoVazioView: some View {
        VStack(spacing: 16) {
            Image(systemName: "cart")
                .font(.system(size: 64))
                .foregroundStyle(.secondary)

            Text("Carrinho vazio")
                .font(.title2)
                .fontWeight(.semibold)

            Text("Adicione produtos na aba Loja para começar suas compras.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
    }

    private var conteudoCarrinhoView: some View {
        List {
            Section("Produtos") {
                ForEach(carrinhoViewModel.itens) { item in
                    CarrinhoLinhaView(
                        item: item,
                        aoAdicionar: {
                            carrinhoViewModel.adicionarProduto(item.produto)
                        },
                        aoDecrementar: {
                            carrinhoViewModel.decrementarProduto(item.produto)
                        },
                        aoRemover: {
                            carrinhoViewModel.removerItem(item)
                        }
                    )
                }
                .onDelete { offsets in
                    carrinhoViewModel.removerItens(em: offsets)
                }
            }
            Section("Resumo") {
                HStack {
                    Text("Itens no carrinho")
                        .foregroundStyle(.secondary)
                    Spacer()
                    Text("\(carrinhoViewModel.totalItens)")
                        .fontWeight(.medium)
                }

                HStack {
                    Text("Total")
                        .font(.headline)
                    Spacer()
                    Text(carrinhoViewModel.precoTotalFormatado)
                        .font(.headline)
                        .foregroundStyle(.orange)
                }
            }

            Section {
                Button {
                    carrinhoViewModel.limparCarrinho()
                } label: {
                    HStack {
                        Spacer()
                        Text("Finalizar Compra")
                            .font(.headline)
                            .foregroundStyle(.white)
                        Spacer()
                    }
                    .padding(.vertical, 6)
                }
                .listRowBackground(Color.orange)
            }
        }
    }
}

#Preview {
    CarrinhoView()
        .environmentObject(CarrinhoViewModel())
}
