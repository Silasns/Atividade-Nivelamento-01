import SwiftUI
import CoreData

struct ConteudoView: View {
    @EnvironmentObject var viewModel: DespesasViewModel

    var body: some View {
        TabView {
            ResumoDespesasView()
                .environmentObject(viewModel)
                .tabItem {
                    Label("Resumo", systemImage: "house.fill")
                }

            ListaDespesasView()
                .environmentObject(viewModel)
                .tabItem {
                    Label("Despesas", systemImage: "list.bullet.rectangle.fill")
                }

            GraficosDespesasView()
                .environmentObject(viewModel)
                .tabItem {
                    Label("Análise", systemImage: "chart.bar.fill")
                }
        }
        .tint(.blue)
    }
}

#Preview {
    ConteudoView()
        .environmentObject(DespesasViewModel(context: PersistenceController.preview.container.viewContext))
}
