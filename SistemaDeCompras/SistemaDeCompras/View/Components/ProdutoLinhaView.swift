import SwiftUI

struct ProdutoLinhaView: View {

    let produto: Produto

    @EnvironmentObject var carrinhoViewModel: CarrinhoViewModel

    private var quantidade: Int {
        carrinhoViewModel.quantidade(de: produto)
    }

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(corCategoria.opacity(0.15))
                    .frame(width: 56, height: 56)

                if let uiImage = UIImage(named: produto.categoria.icone) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32, height: 32)
                }
            }
            VStack(alignment: .leading, spacing: 4) {
                Text(produto.nome)
                    .font(.headline)
                    .lineLimit(1)

                Text(produto.descricao)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)

                Text(produto.precoFormatado)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(corCategoria)
            }

            Spacer()

            if quantidade == 0 {
                Button {
                    carrinhoViewModel.adicionarProduto(produto)
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundStyle(corCategoria)
                }
                .buttonStyle(.plain)
            } else {
                HStack(spacing: 8) {
                    Button {
                        carrinhoViewModel.decrementarProduto(produto)
                    } label: {
                        Image(systemName: "minus.circle.fill")
                            .font(.title2)
                            .foregroundStyle(.orange)
                    }
                    .buttonStyle(.plain)

                    Text("\(quantidade)")
                        .font(.headline)
                        .frame(minWidth: 20)

                    Button {
                        carrinhoViewModel.adicionarProduto(produto)
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundStyle(corCategoria)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(.vertical, 4)
    }

    private var corCategoria: Color {
        switch produto.categoria {
        case .caes:     return .brown
        case .gatos:    return .purple
        case .passaros: return .green
        }
    }
}

#Preview {
    ProdutoLinhaView(produto: Produto(
        nome: "Golden Fórmula Filhotes",
        descricao: "Ração completa para cães filhotes.",
        preco: 89.90,
        categoria: .caes
    ))
    .environmentObject(CarrinhoViewModel())
    .padding()
}
