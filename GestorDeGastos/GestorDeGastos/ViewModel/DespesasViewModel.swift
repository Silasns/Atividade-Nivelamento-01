import Foundation
import Combine
import CoreData

class DespesasViewModel: ObservableObject {

    @Published var despesas: [Despesa] = []
    @Published var mesSelecionado: MesDespesa = .janeiro

    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
        let mesAtual = Calendar.current.component(.month, from: Date())
        mesSelecionado = MesDespesa(rawValue: mesAtual) ?? .janeiro
        carregarDespesas()
    }

    // MARK: - Computed Properties

    var despesasDoMesSelecionado: [Despesa] {
        despesas(para: mesSelecionado)
    }

    var totalDoMesSelecionado: Double {
        totalPorMes(mesSelecionado)
    }

    var totalDoMesSelecionadoFormatado: String {
        formatar(valor: totalDoMesSelecionado)
    }

    // MARK: - Filtros

    func despesas(para mes: MesDespesa) -> [Despesa] {
        despesas.filter { $0.mes == mes }
    }

    func despesas(para categoria: CategoriaDespesa, mes: MesDespesa) -> [Despesa] {
        despesas.filter { $0.categoria == categoria && $0.mes == mes }
    }

    func totalPorMes(_ mes: MesDespesa) -> Double {
        despesas(para: mes).reduce(0) { $0 + $1.valor }
    }

    func totalPorCategoria(mes: MesDespesa) -> [(categoria: CategoriaDespesa, total: Double)] {
        CategoriaDespesa.allCases.compactMap { categoria in
            let total = despesas
                .filter { $0.categoria == categoria && $0.mes == mes }
                .reduce(0) { $0 + $1.valor }
            return total > 0 ? (categoria, total) : nil
        }.sorted { $0.total > $1.total }
    }

    func totalGeral() -> Double {
        despesas.reduce(0) { $0 + $1.valor }
    }

    // MARK: - CRUD

    func adicionarDespesa(_ despesa: Despesa) {
        let entity = DespesaEntity(context: context)
        entity.id = despesa.id
        entity.titulo = despesa.titulo
        entity.valor = despesa.valor
        entity.categoria = despesa.categoria.rawValue
        entity.mes = Int16(despesa.mes.rawValue)
        entity.ano = Int16(despesa.ano)
        entity.dataCriacao = despesa.dataCriacao
        entity.observacao = despesa.observacao
        salvar()
        carregarDespesas()
    }

    func atualizarDespesa(_ despesa: Despesa) {
        let request: NSFetchRequest<DespesaEntity> = DespesaEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", despesa.id as CVarArg)
        guard let entity = try? context.fetch(request).first else { return }
        entity.titulo = despesa.titulo
        entity.valor = despesa.valor
        entity.categoria = despesa.categoria.rawValue
        entity.mes = Int16(despesa.mes.rawValue)
        entity.ano = Int16(despesa.ano)
        entity.observacao = despesa.observacao
        salvar()
        carregarDespesas()
    }

    func removerDespesa(_ despesa: Despesa) {
        let request: NSFetchRequest<DespesaEntity> = DespesaEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", despesa.id as CVarArg)
        guard let entity = try? context.fetch(request).first else { return }
        context.delete(entity)
        salvar()
        carregarDespesas()
    }

    // MARK: - Core Data

    private func carregarDespesas() {
        let request: NSFetchRequest<DespesaEntity> = DespesaEntity.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \DespesaEntity.mes, ascending: true),
            NSSortDescriptor(keyPath: \DespesaEntity.dataCriacao, ascending: false)
        ]
        guard let entities = try? context.fetch(request) else { return }
        despesas = entities.compactMap { entity in
            guard
                let id = entity.id,
                let titulo = entity.titulo,
                let categoriaRaw = entity.categoria,
                let categoria = CategoriaDespesa(rawValue: categoriaRaw),
                let mes = MesDespesa(rawValue: Int(entity.mes)),
                let dataCriacao = entity.dataCriacao
            else { return nil }
            return Despesa(
                id: id,
                titulo: titulo,
                valor: entity.valor,
                categoria: categoria,
                mes: mes,
                ano: Int(entity.ano),
                dataCriacao: dataCriacao,
                observacao: entity.observacao ?? ""
            )
        }
    }

    private func salvar() {
        guard context.hasChanges else { return }
        try? context.save()
    }

    // MARK: - Formatação

    func formatar(valor: Double) -> String {
        let formatador = NumberFormatter()
        formatador.numberStyle = .currency
        formatador.locale = Locale(identifier: "pt_BR")
        return formatador.string(from: NSNumber(value: valor)) ?? "R$ 0,00"
    }
}
