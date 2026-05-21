import SwiftUI
import CoreData
import Combine

@main
struct GestorDespesasApp: App {
    let persistenceController = PersistenceController.shared

    @StateObject private var viewModel: DespesasViewModel

    init() {
        let context = PersistenceController.shared.container.viewContext
        _viewModel = StateObject(wrappedValue: DespesasViewModel(context: context))
    }

    var body: some Scene {
        WindowGroup {
            ConteudoView()
                .environmentObject(viewModel)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
