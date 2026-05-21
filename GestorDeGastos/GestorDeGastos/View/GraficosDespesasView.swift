import SwiftUI
import Charts
import CoreData

// Requer iOS 17+
struct GraficosDespesasView: View {
    @EnvironmentObject var viewModel: DespesasViewModel
    @State private var mesGraficoCategorias: MesDespesa = .janeiro

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    graficoComparacaoMeses
                    graficoCategorias
                    resumoAnual
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Análise")
            .navigationBarTitleDisplayMode(.large)
            .onAppear {
                mesGraficoCategorias = viewModel.mesSelecionado
            }
        }
    }

    // MARK: - Comparativo Mensal

    private var graficoComparacaoMeses: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Comparativo por Mês")
                .font(.headline)

            let dados = MesDespesa.allCases.map { mes in
                (mes: mes, total: viewModel.totalPorMes(mes))
            }.filter { $0.total > 0 }

            if dados.isEmpty {
                estadoVazioGrafico
            } else {
                Chart(dados, id: \.mes) { item in
                    BarMark(
                        x: .value("Mês", item.mes.abreviacao),
                        y: .value("Total", item.total)
                    )
                    .foregroundStyle(
                        item.mes == viewModel.mesSelecionado
                            ? Color.blue
                            : Color.blue.opacity(0.35)
                    )
                    .cornerRadius(6)
                    .annotation(position: .top, alignment: .center) {
                        if item.mes == viewModel.mesSelecionado {
                            Text(viewModel.formatar(valor: item.total))
                                .font(.caption2)
                                .fontWeight(.semibold)
                                .foregroundStyle(.blue)
                        }
                    }
                }
                .frame(height: 220)
                .chartYAxis {
                    AxisMarks(values: .automatic(desiredCount: 4)) { value in
                        AxisGridLine()
                        AxisValueLabel {
                            if let v = value.as(Double.self) {
                                Text(abreviarValor(v))
                                    .font(.caption2)
                            }
                        }
                    }
                }

                HStack {
                    Circle().fill(Color.blue).frame(width: 8, height: 8)
                    Text("Mês selecionado")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Spacer()
                    Text("Total geral: \(viewModel.formatar(valor: viewModel.totalGeral()))")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding(.top, 4)
            }
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    // MARK: - Gráfico por Categoria

    private var graficoCategorias: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Categorias")
                    .font(.headline)
                Spacer()
                Picker("Mês", selection: $mesGraficoCategorias) {
                    ForEach(MesDespesa.allCases) { mes in
                        Text(mes.abreviacao).tag(mes)
                    }
                }
                .pickerStyle(.menu)
            }

            let categorias = viewModel.totalPorCategoria(mes: mesGraficoCategorias)

            if categorias.isEmpty {
                Text("Sem despesas em \(mesGraficoCategorias.nome)")
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 24)
            } else {
                Chart(categorias, id: \.categoria) { item in
                    SectorMark(
                        angle: .value("Total", item.total),
                        innerRadius: .ratio(0.55),
                        angularInset: 2
                    )
                    .foregroundStyle(item.categoria.cor)
                    .cornerRadius(4)
                }
                .frame(height: 220)

                let totalMes = categorias.reduce(0) { $0 + $1.total }
                VStack(spacing: 6) {
                    ForEach(categorias, id: \.categoria) { item in
                        HStack(spacing: 8) {
                            RoundedRectangle(cornerRadius: 3)
                                .fill(item.categoria.cor)
                                .frame(width: 12, height: 12)
                            Label(item.categoria.rawValue, systemImage: item.categoria.icone)
                                .font(.caption)
                                .foregroundStyle(item.categoria.cor)
                            Spacer()
                            Text(viewModel.formatar(valor: item.total))
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text(String(format: "(%.0f%%)", item.total / totalMes * 100))
                                .font(.caption2)
                                .foregroundStyle(.tertiary)
                        }
                    }
                    Divider()
                    HStack {
                        Text("Total")
                            .font(.caption)
                            .fontWeight(.semibold)
                        Spacer()
                        Text(viewModel.formatar(valor: totalMes))
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundStyle(.blue)
                    }
                }
                .padding(.top, 8)
            }
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    // MARK: - Resumo Anual

    private var resumoAnual: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Resumo por Categoria (Acumulado)")
                .font(.headline)

            let categorias = CategoriaDespesa.allCases.compactMap { cat -> (categoria: CategoriaDespesa, total: Double)? in
                let total = viewModel.despesas
                    .filter { $0.categoria == cat }
                    .reduce(0) { $0 + $1.valor }
                return total > 0 ? (cat, total) : nil
            }.sorted { $0.total > $1.total }

            if categorias.isEmpty {
                estadoVazioGrafico
            } else {
                ForEach(categorias, id: \.categoria) { item in
                    HStack {
                        Image(systemName: item.categoria.icone)
                            .foregroundStyle(item.categoria.cor)
                            .frame(width: 20)
                        Text(item.categoria.rawValue)
                            .font(.subheadline)
                        Spacer()
                        Text(viewModel.formatar(valor: item.total))
                            .font(.subheadline)
                            .fontWeight(.semibold)
                    }
                    .padding(.vertical, 4)

                    if item.categoria != categorias.last?.categoria {
                        Divider()
                    }
                }

                Divider()
                HStack {
                    Text("Total Geral")
                        .fontWeight(.bold)
                    Spacer()
                    Text(viewModel.formatar(valor: viewModel.totalGeral()))
                        .fontWeight(.bold)
                        .foregroundStyle(.blue)
                }
            }
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    // MARK: - Helpers

    private var estadoVazioGrafico: some View {
        Text("Sem dados para exibir")
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.vertical, 24)
    }

    private func abreviarValor(_ valor: Double) -> String {
        if valor >= 1000 {
            return String(format: "R$%.0fk", valor / 1000)
        }
        return String(format: "R$%.0f", valor)
    }
}

#Preview {
    GraficosDespesasView()
        .environmentObject(DespesasViewModel(context: PersistenceController.preview.container.viewContext))
}
