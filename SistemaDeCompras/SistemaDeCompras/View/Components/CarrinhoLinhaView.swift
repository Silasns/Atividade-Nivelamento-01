import SwiftUI

struct CarrinhoLinhaView: View {

    let item: ItemCarrinho
    let aoAdicionar: () -> Void
    let aoDecrementar: () -> Void
    let aoRemover: () -> Void

    var body: some View {
        HStack(spacing: 12) {

            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(corCategoria.opacity(0.15))
                    .frame(width: 48, height: 48)

                if let uiImage = UIImage(named: item.produto.categoria.icone) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 28, height: 28)
                }
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(item.produto.nome)
                    .font(.headline)
                    .lineLimit(1)

                Text(item.produto.precoFormatado)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            HStack(spacing: 10) {
                Button(action: aoDecrementar) {
                    Image(systemName: "minus.circle.fill")
                        .font(.title3)
                        .foregroundStyle(.orange)
                }
                .buttonStyle(.plain)

                Text("\(item.quantidade)")
                    .font(.headline)
                    .frame(minWidth: 24)

                Button(action: aoAdicionar) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title3)
                        .foregroundStyle(corCategoria)
                }
                .buttonStyle(.plain)
            }

            Text(item.subtotalFormatado)
                .font(.subheadline)
                .fontWeight(.semibold)
                .frame(minWidth: 70, alignment: .trailing)
        }
        .padding(.vertical, 4)
        .swipeActions(edge: .trailing) {
            Button(role: .destructive, action: aoRemover) {
                Label("Remover", systemImage: "trash")
            }
        }
    }

    private var corCategoria: Color {
        switch item.produto.categoria {
        case .caes:     return .brown
        case .gatos:    return .purple
        case .passaros: return .green
        }
    }
}

#Preview {
    CarrinhoLinhaView(
        item: ItemCarrinho(
            produto: Produto(
                nome: "Whiskas Adulto Frango",
                descricao: "Ração para gatos adultos.",
                preco: 69.90,
                categoria: .gatos
            ),
            quantidade: 2
        ),
        aoAdicionar: {},
        aoDecrementar: {},
        aoRemover: {}
    )
    .padding()
}
