import Foundation

struct Despesa: Identifiable, Equatable {
    var id: UUID
    var titulo: String
    var valor: Double
    var categoria: CategoriaDespesa
    var mes: MesDespesa
    var ano: Int
    var dataCriacao: Date
    var observacao: String

    var valorFormatado: String {
        let formatador = NumberFormatter()
        formatador.numberStyle = .currency
        formatador.locale = Locale(identifier: "pt_BR")
        return formatador.string(from: NSNumber(value: valor)) ?? "R$ 0,00"
    }

    init(
        id: UUID = UUID(),
        titulo: String,
        valor: Double,
        categoria: CategoriaDespesa,
        mes: MesDespesa,
        ano: Int = Calendar.current.component(.year, from: Date()),
        dataCriacao: Date = Date(),
        observacao: String = ""
    ) {
        self.id = id
        self.titulo = titulo
        self.valor = valor
        self.categoria = categoria
        self.mes = mes
        self.ano = ano
        self.dataCriacao = dataCriacao
        self.observacao = observacao
    }
}
