//
//  ContentView.swift
//  JogoDePerguntas
//
//  Created by Cardoso, Silas Nunes on 25/04/26.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: ViewQuiz
    
    var body: some View {
        ZStack {
            if viewModel.temaSelecionado == nil {
                ViewSelecaoTema()
            } else if viewModel.jogoFinalizado {
                ViewResultado()
            } else {
                ViewPergunta()
            }
        }
        .animation(.easeInOut, value: viewModel.temaSelecionado)
        .animation(.easeInOut, value: viewModel.jogoFinalizado)
    }
}

#Preview {
    ContentView()
        .environmentObject(ViewQuiz())
}
