import CoreData
import Combine

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext

        let dadosTeste: [(String, Double, CategoriaDespesa, MesDespesa)] = [
            ("Conta de Energia", 180.50, .energia, .janeiro),
            ("Internet Fibra", 99.90, .internet, .janeiro),
            ("Conta de Água", 65.00, .agua, .janeiro),
            ("Netflix", 39.90, .assinaturas, .janeiro),
            ("Spotify", 21.90, .assinaturas, .janeiro),
            ("Aluguel", 1500.00, .aluguel, .janeiro),
            ("Supermercado", 850.00, .mercado, .janeiro),
            ("Curso de Swift", 299.00, .cursos, .janeiro),
            ("Cinema", 80.00, .lazer, .janeiro),
            ("Conta de Energia", 165.30, .energia, .fevereiro),
            ("Internet Fibra", 99.90, .internet, .fevereiro),
            ("Conta de Água", 72.50, .agua, .fevereiro),
            ("Netflix", 39.90, .assinaturas, .fevereiro),
            ("Aluguel", 1500.00, .aluguel, .fevereiro),
            ("Supermercado", 920.00, .mercado, .fevereiro),
            ("Academia", 89.90, .lazer, .fevereiro),
            ("Conta de Energia", 210.00, .energia, .marco),
            ("Internet Fibra", 99.90, .internet, .marco),
            ("Conta de Água", 58.00, .agua, .marco),
            ("Aluguel", 1500.00, .aluguel, .marco),
            ("Supermercado", 780.00, .mercado, .marco),
            ("Milhas Aéreas", 89.90, .assinaturas, .marco),
            ("Curso de Design", 199.00, .cursos, .marco),
            ("Shows", 150.00, .lazer, .marco),
        ]

        for (titulo, valor, categoria, mes) in dadosTeste {
            let entity = DespesaEntity(context: viewContext)
            entity.id = UUID()
            entity.titulo = titulo
            entity.valor = valor
            entity.categoria = categoria.rawValue
            entity.mes = Int16(mes.rawValue)
            entity.ano = 2025
            entity.dataCriacao = Date()
            entity.observacao = ""
        }

        try? viewContext.save()
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "GestorDespesas")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Erro ao carregar Core Data: \(error), \(error.userInfo)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
