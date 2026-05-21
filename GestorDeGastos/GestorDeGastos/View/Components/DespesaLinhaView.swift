import SwiftUI

struct DespesaLinhaView: View {
    let despesa: Despesa

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(despesa.categoria.cor.opacity(0.15))
                    .frame(width: 42, height: 42)
                Image(systemName: despesa.categoria.icone)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(despesa.categoria.cor)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(despesa.titulo)
                    .font(.body)
                    .fontWeight(.medium)
                    .lineLimit(1)
                if !despesa.observacao.isEmpty {
                    Text(despesa.observacao)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
            }

            Spacer()

            Text(despesa.valorFormatado)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(.primary)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    DespesaLinhaView(despesa: Despesa(titulo: "Netflix", valor: 39.90, categoria: .assinaturas, mes: .janeiro))
        .padding()
}
