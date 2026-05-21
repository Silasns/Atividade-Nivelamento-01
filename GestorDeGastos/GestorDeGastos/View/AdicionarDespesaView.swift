import SwiftUI
import CoreData

struct AdicionarDespesaView: View {
    @EnvironmentObject var viewModel: DespesasViewModel
    @Environment(\.dismiss) private var dismiss

    var despesaParaEditar: Despesa?

    @State private var titulo: String = ""
    @State private var valorTexto: String = ""
    @State private var categoriaSelecionada: CategoriaDespesa = .mercado
    @State private var mesSelecionado: MesDespesa = .janeiro
    @State private var anoSelecionado: Int = Calendar.current.component(.year, from: Date())
    @State private var observacao: String = ""
    @State private var mostrarErroValor: Bool = false

    private var estaEditando: Bool { despesaParaEditar != nil }

    private var podeConfirmar: Bool {
        !titulo.trimmingCharacters(in: .whitespaces).isEmpty && valorDouble != nil
    }

    private var valorDouble: Double? {
        let normalizado = valorTexto
            .replacingOccurrences(of: ",", with: ".")
            .trimmingCharacters(in: .whitespaces)
        guard let v = Double(normalizado), v > 0 else { return nil }
        return v
    }

    init(mesPadrao: MesDespesa = .janeiro, despesaParaEditar: Despesa? = nil) {
        self.despesaParaEditar = despesaParaEditar
        if let despesa = despesaParaEditar {
            _titulo = State(initialValue: despesa.titulo)
            _valorTexto = State(initialValue: String(format: "%.2f", despesa.valor)
                .replacingOccurrences(of: ".", with: ","))
            _categoriaSelecionada = State(initialValue: despesa.categoria)
            _mesSelecionado = State(initialValue: despesa.mes)
            _anoSelecionado = State(initialValue: despesa.ano)
            _observacao = State(initialValue: despesa.observacao)
        } else {
            _mesSelecionado = State(initialValue: mesPadrao)
        }
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Informações") {
                    TextField("Título da despesa", text: $titulo)

                    HStack {
                        Text("R$")
                            .foregroundStyle(.secondary)
                        TextField("0,00", text: $valorTexto)
                            .keyboardType(.decimalPad)
                    }
                }

                Section("Categoria") {
                    Picker("Categoria", selection: $categoriaSelecionada) {
                        ForEach(CategoriaDespesa.allCases) { categoria in
                            Label(categoria.rawValue, systemImage: categoria.icone)
                                .tag(categoria)
                        }
                    }
                    .pickerStyle(.navigationLink)
                }

                Section("Período") {
                    Picker("Mês", selection: $mesSelecionado) {
                        ForEach(MesDespesa.allCases) { mes in
                            Text(mes.nome).tag(mes)
                        }
                    }

                    Picker("Ano", selection: $anoSelecionado) {
                        ForEach(2024...2027, id: \.self) { ano in
                            Text(String(ano)).tag(ano)
                        }
                    }
                }

                Section("Observação (opcional)") {
                    TextEditor(text: $observacao)
                        .frame(minHeight: 80)
                }
            }
            .navigationTitle(estaEditando ? "Editar Despesa" : "Nova Despesa")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancelar") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(estaEditando ? "Salvar" : "Adicionar") {
                        confirmar()
                    }
                    .fontWeight(.semibold)
                    .disabled(!podeConfirmar)
                }
            }
            .alert("Valor inválido", isPresented: $mostrarErroValor) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("Insira um valor numérico maior que zero.\nUse vírgula como separador decimal.")
            }
        }
    }

    private func confirmar() {
        guard let valor = valorDouble else {
            mostrarErroValor = true
            return
        }

        if let original = despesaParaEditar {
            var atualizada = original
            atualizada.titulo = titulo.trimmingCharacters(in: .whitespaces)
            atualizada.valor = valor
            atualizada.categoria = categoriaSelecionada
            atualizada.mes = mesSelecionado
            atualizada.ano = anoSelecionado
            atualizada.observacao = observacao
            viewModel.atualizarDespesa(atualizada)
        } else {
            let nova = Despesa(
                titulo: titulo.trimmingCharacters(in: .whitespaces),
                valor: valor,
                categoria: categoriaSelecionada,
                mes: mesSelecionado,
                ano: anoSelecionado,
                observacao: observacao
            )
            viewModel.adicionarDespesa(nova)
        }
        dismiss()
    }
}

#Preview {
    AdicionarDespesaView()
        .environmentObject(DespesasViewModel(context: PersistenceController.preview.container.viewContext))
}
