import SwiftUI
import CoreData

struct ResumoDespesasView: View {
    @EnvironmentObject var viewModel: DespesasViewModel
    @State private var mostrarAdicionarDespesa = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    seletorMes
                    cartaoTotalMes

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Por Categoria")
                            .font(.headline)
                            .padding(.horizontal, 4)

                        let categorias = viewModel.totalPorCategoria(mes: viewModel.mesSelecionado)

                        if categorias.isEmpty {
                            estadoVazio
                        } else {
                            ForEach(categorias, id: \.categoria) { item in
                                CategoriaResumoView(
                                    categoria: item.categoria,
                                    total: item.total,
                                    totalGeral: viewModel.totalDoMesSelecionado
                                )
                            }
                        }
                    }
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Despesas Domésticas")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        mostrarAdicionarDespesa = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title3)
                    }
                }
            }
            .sheet(isPresented: $mostrarAdicionarDespesa) {
                AdicionarDespesaView(mesPadrao: viewModel.mesSelecionado)
                    .environmentObject(viewModel)
            }
        }
    }

    private var seletorMes: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(MesDespesa.allCases) { mes in
                    Button {
                        withAnimation(.spring(response: 0.3)) {
                            viewModel.mesSelecionado = mes
                        }
                    } label: {
                        Text(mes.abreviacao)
                            .font(.subheadline)
                            .fontWeight(viewModel.mesSelecionado == mes ? .bold : .regular)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background(
                                viewModel.mesSelecionado == mes
                                    ? Color.blue
                                    : Color(.secondarySystemGroupedBackground)
                            )
                            .foregroundStyle(viewModel.mesSelecionado == mes ? .white : .primary)
                            .clipShape(Capsule())
                    }
                }
            }
            .padding(.horizontal, 4)
        }
    }

    private var cartaoTotalMes: some View {
        VStack(spacing: 8) {
            Text("Total em \(viewModel.mesSelecionado.nome)")
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.9))

            Text(viewModel.totalDoMesSelecionadoFormatado)
                .font(.system(size: 40, weight: .bold, design: .rounded))
                .foregroundStyle(.white)

            let count = viewModel.despesasDoMesSelecionado.count
            Text("\(count) despesa\(count == 1 ? "" : "s") registrada\(count == 1 ? "" : "s")")
                .font(.caption)
                .foregroundStyle(.white.opacity(0.8))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 28)
        .background(
            LinearGradient(
                colors: [.blue, .blue.opacity(0.7)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    private var estadoVazio: some View {
        VStack(spacing: 16) {
            Image(systemName: "doc.text")
                .font(.system(size: 44))
                .foregroundStyle(.secondary)
            Text("Nenhuma despesa em \(viewModel.mesSelecionado.nome)")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            Button("Adicionar Despesa") {
                mostrarAdicionarDespesa = true
            }
            .buttonStyle(.bordered)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 32)
    }
}

#Preview {
    ResumoDespesasView()
        .environmentObject(DespesasViewModel(context: PersistenceController.preview.container.viewContext))
}
