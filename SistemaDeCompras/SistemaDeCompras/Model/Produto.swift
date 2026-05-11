import Foundation

enum CategoriaProduto: String, CaseIterable, Identifiable {
    case caes     = "Cães"
    case gatos    = "Gatos"
    case passaros = "Pássaros"

    var id: String { rawValue }
    var icone: String {
        switch self {
        case .caes:     return "dog"
        case .gatos:    return "cat"
        case .passaros: return "bird"
        }
    }
}

struct Produto: Identifiable, Equatable {
    var id: UUID = UUID()
    var nome: String
    var descricao: String
    var preco: Double
    var categoria: CategoriaProduto
    var precoFormatado: String {
        let formatador = NumberFormatter()
        formatador.numberStyle = .currency
        formatador.locale = Locale(identifier: "pt_BR")
        return formatador.string(from: NSNumber(value: preco)) ?? "R$ 0,00"
    }
}
