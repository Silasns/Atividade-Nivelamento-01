//
//  ViewPergunta.swift
//  JogoDePerguntas
//
//  Created by Cardoso, Silas Nunes on 25/04/26.
//

import SwiftUI

struct ViewPergunta: View {
    @EnvironmentObject var viewModel: ViewQuiz
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Pergunta \(viewModel.indiceAtual + 1) de 5")
                .font(.headline)
                .foregroundColor(.gray)
                .padding(.top)
            
            if let pergunta = viewModel.perguntaAtual {
                Text(pergunta.texto)
                    .font(.title2)
                    .bold()
                    .multilineTextAlignment(.center)
                    .padding()
                
                ForEach(0..<4) { indice in
                    Button(action: {
                        if !viewModel.mostrarFeedback {
                            viewModel.selecionarResposta(indice)
                        }
                    }) {
                        HStack {
                            Text(pergunta.opcoes[indice])
                                .foregroundColor(.primary)
                            Spacer()
                            if viewModel.mostrarFeedback {
                                if indice == pergunta.respostaCorreta {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.green)
                                } else if indice == viewModel.respostasUsuario[viewModel.indiceAtual] {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.red)
                                }
                            }
                        }
                        .padding()
                        .background(corDeFundo(para: indice, pergunta: pergunta))
                        .cornerRadius(10)
                    }
                }
            }
            
            Spacer()
        }
        .padding()
    }
    
    func corDeFundo(para indice: Int, pergunta: Pergunta) -> Color {
        if !viewModel.mostrarFeedback {
            return Color.gray.opacity(0.1)
        }
        if indice == pergunta.respostaCorreta {
            return Color.green.opacity(0.3)
        } else if indice == viewModel.respostasUsuario[viewModel.indiceAtual] {
            return Color.red.opacity(0.3)
        }
        return Color.gray.opacity(0.1)
    }
}

#Preview {
    ViewPergunta()
        .environmentObject(ViewQuiz())
}
