//
//  ViewQuiz.swift
//  JogoDePerguntas
//
//  Created by Cardoso, Silas Nunes on 25/04/26.
//

import Foundation
import Combine

class ViewQuiz: ObservableObject {
    @Published var temaSelecionado: Tema?
    @Published var perguntasAtuais: [Pergunta] = []
    @Published var indiceAtual = 0
    @Published var respostasUsuario: [Int?] = []
    @Published var mostrarFeedback = false
    @Published var estaCorreto = false
    @Published var jogoFinalizado = false
    
    var perguntaAtual: Pergunta? {
        guard indiceAtual < perguntasAtuais.count else { return nil }
        return perguntasAtuais[indiceAtual]
    }
    
    var pontuacao: Int {
        var contador = 0
        for i in 0..<respostasUsuario.count {
            if let resposta = respostasUsuario[i],
               resposta == perguntasAtuais[i].respostaCorreta {
                contador += 1
            }
        }
        return contador
    }
    
    func iniciarJogo(com tema: Tema) {
        temaSelecionado = tema
        perguntasAtuais = BancoPerguntas.compartilhado.obterPerguntasAleatorias(do: tema, quantidade: 5)
        indiceAtual = 0
        respostasUsuario = Array(repeating: nil, count: 5)
        jogoFinalizado = false
    }
    
    func selecionarResposta(_ indice: Int) {
        respostasUsuario[indiceAtual] = indice
        estaCorreto = (indice == perguntaAtual?.respostaCorreta)
        mostrarFeedback = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.proximaPergunta()
        }
    }
    
    func proximaPergunta() {
        mostrarFeedback = false
        
        if indiceAtual < perguntasAtuais.count - 1 {
            indiceAtual += 1
        } else {
            jogoFinalizado = true
        }
    }
    
    func reiniciarJogo() {
        temaSelecionado = nil
        perguntasAtuais = []
        indiceAtual = 0
        respostasUsuario = []
        jogoFinalizado = false
    }
}
