import Foundation
import Combine

class LojaViewModel: ObservableObject {

    @Published var produtos: [Produto] = []

    init() {
        carregarProdutos()
    }

    func produtos(para categoria: CategoriaProduto) -> [Produto] {
        produtos.filter { $0.categoria == categoria }
    }

    private func carregarProdutos() {

        produtos.append(Produto(
            nome: "Golden Fórmula Filhotes",
            descricao: "Ração completa para cães filhotes de todas as raças. Enriquecida com vitaminas e minerais essenciais.",
            preco: 89.90,
            categoria: .caes
        ))
        produtos.append(Produto(
            nome: "Royal Canin Adulto",
            descricao: "Nutrição precisa para cães adultos com proteínas de alta qualidade e suporte digestivo.",
            preco: 149.90,
            categoria: .caes
        ))
        produtos.append(Produto(
            nome: "Pedigree Sênior",
            descricao: "Ração especial para cães idosos com suporte articular e reforço imunológico.",
            preco: 79.90,
            categoria: .caes
        ))
        produtos.append(Produto(
            nome: "Petisco Ossinho Natural",
            descricao: "Petisco 100% natural para cães adultos. Auxilia na limpeza dos dentes.",
            preco: 19.90,
            categoria: .caes
        ))

        produtos.append(Produto(
            nome: "Whiskas Adulto Frango",
            descricao: "Ração completa para gatos adultos com sabor frango. Rica em taurina para saúde cardíaca.",
            preco: 69.90,
            categoria: .gatos
        ))
        produtos.append(Produto(
            nome: "Royal Canin Indoor",
            descricao: "Ração formulada para gatos de interior. Controla bolas de pelo e reduz odores.",
            preco: 129.90,
            categoria: .gatos
        ))
        produtos.append(Produto(
            nome: "Friskies Filhotes",
            descricao: "Ração balanceada para filhotes de gato. Apoia o desenvolvimento saudável.",
            preco: 59.90,
            categoria: .gatos
        ))
        produtos.append(Produto(
            nome: "Sachê Whiskas Atum",
            descricao: "Ração úmida com sabor de atum. Rico em proteínas e umidade para hidratação.",
            preco: 15.90,
            categoria: .gatos
        ))

        produtos.append(Produto(
            nome: "Mistura de Sementes Premium",
            descricao: "Mistura especial de sementes selecionadas para pássaros silvestres e domésticos.",
            preco: 29.90,
            categoria: .passaros
        ))
        produtos.append(Produto(
            nome: "Alpiste Selecionado",
            descricao: "Alpiste de alta qualidade, ideal para canários, mandarins e demais pássaros.",
            preco: 24.90,
            categoria: .passaros
        ))
        produtos.append(Produto(
            nome: "Ração Calopsita",
            descricao: "Ração completa e balanceada formulada especialmente para calopsitas.",
            preco: 34.90,
            categoria: .passaros
        ))
        produtos.append(Produto(
            nome: "Mix Tropical Periquito",
            descricao: "Mix nutritivo com frutas desidratadas e sementes variadas para periquitos.",
            preco: 39.90,
            categoria: .passaros
        ))
    }
}
