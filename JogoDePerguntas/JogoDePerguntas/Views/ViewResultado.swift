//
//  ViewResultado.swift
//  JogoDePerguntas
//
//  Created by Cardoso, Silas Nunes on 25/04/26.
//

import SwiftUI

struct ViewResultado: View {
    @EnvironmentObject var viewModel: ViewQuiz
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Resultado")
                .font(.largeTitle)
                .bold()
            
            Text("\(viewModel.pontuacao) / 5")
                .font(.system(size: 60, weight: .bold))
                .foregroundColor(.green)
            
            Text("Você acertou \(viewModel.pontuacao) de 5 perguntas!")
                .font(.title3)
                .foregroundColor(.gray)
            
            Spacer()
            
            Button("Jogar Novamente") {
                viewModel.reiniciarJogo()
            }
            .font(.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .cornerRadius(12)
            .padding()
        }
        .padding()
    }
}

#Preview {
    ViewResultado()
        .environmentObject(ViewQuiz())
}
