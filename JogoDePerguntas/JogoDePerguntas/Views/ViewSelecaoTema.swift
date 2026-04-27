//
//  ViewSelecaoTema.swift
//  JogoDePerguntas
//
//  Created by Cardoso, Silas Nunes on 25/04/26.
//

import SwiftUI

struct ViewSelecaoTema: View {
    @EnvironmentObject var viewModel: ViewQuiz
    let temas = BancoPerguntas.compartilhado.todosTemas
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Escolha um Tema")
                .font(.largeTitle)
                .bold()
                .padding(.top, 40)
            
            ForEach(temas) { tema in
                Button(action: {
                    viewModel.iniciarJogo(com: tema)
                }) {
                    HStack {
                        Image(systemName: tema.icone)
                            .font(.title)
                            .foregroundColor(.blue)
                        
                        Text(tema.nome)
                            .font(.title2)
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(12)
                }
            }
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    ViewSelecaoTema()
        .environmentObject(ViewQuiz())
}
