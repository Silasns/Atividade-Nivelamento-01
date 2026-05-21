import SwiftUI

struct CategoriaResumoView: View {
    let categoria: CategoriaDespesa
    let total: Double
    let totalGeral: Double

    private var percentual: Double {
        guard totalGeral > 0 else { return 0 }
        return min(total / totalGeral, 1.0)
    }

    private var totalFormatado: String {
        let formatador = NumberFormatter()
        formatador.numberStyle = .currency
        formatador.locale = Locale(identifier: "pt_BR")
        return formatador.string(from: NSNumber(value: total)) ?? "R$ 0,00"
    }

    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Label(categoria.rawValue, systemImage: categoria.icone)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(categoria.cor)
                Spacer()
                Text(totalFormatado)
                    .font(.subheadline)
                    .fontWeight(.semibold)
            }

            ProgressView(value: percentual)
                .tint(categoria.cor)
                .scaleEffect(x: 1, y: 1.2)

            HStack {
                Spacer()
                Text(String(format: "%.0f%% do total", percentual * 100))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}

#Preview {
    CategoriaResumoView(categoria: .mercado, total: 850, totalGeral: 3200)
        .padding()
        .background(Color(.systemGroupedBackground))
}
