import SwiftUI
import CoreData

struct ListaDespesasView: View {
    @EnvironmentObject var viewModel: DespesasViewModel
    @State private var mostrarAdicionarDespesa = false
    @State private var despesaParaEditar: Despesa?

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                seletorMes

                if viewModel.despesasDoMesSelecionado.isEmpty {
                    estadoVazio
                } else {
                    listaView
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Despesas")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        mostrarAdicionarDespesa = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $mostrarAdicionarDespesa) {
                AdicionarDespesaView(mesPadrao: viewModel.mesSelecionado)
                    .environmentObject(viewModel)
            }
            .sheet(item: $despesaParaEditar) { despesa in
                AdicionarDespesaView(despesaParaEditar: despesa)
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
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .background(Color(.systemBackground))
    }

    private var listaView: some View {
        List {
            let categorias = viewModel.totalPorCategoria(mes: viewModel.mesSelecionado)
            ForEach(categorias, id: \.categoria) { item in
                Section {
                    let itens = viewModel.despesas(para: item.categoria, mes: viewModel.mesSelecionado)
                    ForEach(itens) { despesa in
                        DespesaLinhaView(despesa: despesa)
                            .contentShape(Rectangle())
                            .onTapGesture { despesaParaEditar = despesa }
                    }
                    .onDelete { offsets in
                        let paraRemover = offsets.map { itens[$0] }
                        paraRemover.forEach { viewModel.removerDespesa($0) }
                    }
                } header: {
                    HStack {
                        Label(item.categoria.rawValue, systemImage: item.categoria.icone)
                            .foregroundStyle(item.categoria.cor)
                            .fontWeight(.semibold)
                        Spacer()
                        Text(viewModel.formatar(valor: item.total))
                            .foregroundStyle(.secondary)
                            .fontWeight(.medium)
                    }
                }
            }

            Section {
                HStack {
                    Text("Total do Mês")
                        .fontWeight(.bold)
                    Spacer()
                    Text(viewModel.totalDoMesSelecionadoFormatado)
                        .fontWeight(.bold)
                        .foregroundStyle(.blue)
                }
            }
        }
        .listStyle(.insetGrouped)
        .animation(.default, value: viewModel.mesSelecionado)
    }

    private var estadoVazio: some View {
        VStack(spacing: 16) {
            Spacer()
            Image(systemName: "tray")
                .font(.system(size: 56))
                .foregroundStyle(.secondary)
            Text("Sem despesas em \(viewModel.mesSelecionado.nome)")
                .font(.title3)
                .fontWeight(.semibold)
            Text("Toque no botão + para adicionar uma despesa.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    ListaDespesasView()
        .environmentObject(DespesasViewModel(context: PersistenceController.preview.container.viewContext))
}
