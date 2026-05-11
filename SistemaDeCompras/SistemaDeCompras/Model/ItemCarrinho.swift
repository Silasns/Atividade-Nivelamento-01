import Foundation

struct ItemCarrinho: Identifiable, Equatable {
    var id: UUID = UUID()
    var produto: Produto
    var quantidade: Int
    var subtotal: Double {
        produto.preco * Double(quantidade)
    }
    var subtotalFormatado: String {
        let formatador = NumberFormatter()
        formatador.numberStyle = .currency
        formatador.locale = Locale(identifier: "pt_BR")
        return formatador.string(from: NSNumber(value: subtotal)) ?? "R$ 0,00"
    }
}
