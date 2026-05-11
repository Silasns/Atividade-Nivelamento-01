import Foundation
import Combine
import SwiftUI

class CarrinhoViewModel: ObservableObject {

    @Published var itens: [ItemCarrinho] = []

    var totalItens: Int {
        itens.reduce(0) { $0 + $1.quantidade }
    }

    var precoTotal: Double {
        itens.reduce(0) { $0 + $1.subtotal }
    }

    var precoTotalFormatado: String {
        let formatador = NumberFormatter()
        formatador.numberStyle = .currency
        formatador.locale = Locale(identifier: "pt_BR")
        return formatador.string(from: NSNumber(value: precoTotal)) ?? "R$ 0,00"
    }

    func adicionarProduto(_ produto: Produto) {
        if let indice = itens.firstIndex(where: { $0.produto.id == produto.id }) {
            itens[indice].quantidade += 1
        } else {
            itens.append(ItemCarrinho(produto: produto, quantidade: 1))
        }
    }

    func decrementarProduto(_ produto: Produto) {
        guard let indice = itens.firstIndex(where: { $0.produto.id == produto.id }) else { return }

        if itens[indice].quantidade > 1 {
            itens[indice].quantidade -= 1
        } else {
            itens.remove(at: indice)
        }
    }

    func removerItens(em offsets: IndexSet) {
        itens.remove(atOffsets: offsets)
    }

    func removerItem(_ item: ItemCarrinho) {
        itens.removeAll { $0.id == item.id }
    }

    func quantidade(de produto: Produto) -> Int {
        itens.first(where: { $0.produto.id == produto.id })?.quantidade ?? 0
    }

    func limparCarrinho() {
        itens.removeAll()
    }
}
