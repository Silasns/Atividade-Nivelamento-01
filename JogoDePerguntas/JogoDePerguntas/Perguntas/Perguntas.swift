//
//  Perguntas.swift
//  JogoDePerguntas
//
//  Created by Cardoso, Silas Nunes on 25/04/26.
//

import Foundation

struct Tema: Identifiable, Equatable {
    let nome: String
    let icone: String
    let perguntas: [DadosPergunta]
    
    var id: String { nome }
    
    // Conformidade com Equatable
    static func == (lhs: Tema, rhs: Tema) -> Bool {
        lhs.nome == rhs.nome
    }
}

// Também adicione Equatable em DadosPergunta
struct DadosPergunta: Equatable {
    let texto: String
    let opcoes: [String]
    let respostaCorreta: Int
}

struct Pergunta: Identifiable {
    let id = UUID()
    let texto: String
    let opcoes: [String]
    let respostaCorreta: Int
}

// Dados
struct DadosPerguntas {
    static let todosTemas: [Tema] = [
        Tema(
            nome: "Programação",
            icone: "chevron.left.forwardslash.chevron.right",
            perguntas: [
                DadosPergunta(
                    texto: "Qual linguagem foi criada pela Apple?",
                    opcoes: ["Java", "Kotlin", "Python", "Swift"],
                    respostaCorreta: 3
                ),
                DadosPergunta(
                    texto: "O que significa OOP?",
                    opcoes: ["Object-Oriented Programming", "Only One Process", "Open Operations Protocol", "Organized Object Pattern"],
                    respostaCorreta: 0
                ),
                DadosPergunta(
                    texto: "Kotlin é usado principalmente para?",
                    opcoes: ["iOS", "Android", "Windows", "Linux"],
                    respostaCorreta: 1
                ),
                DadosPergunta(
                    texto: "Qual estrutura de dados usa LIFO?",
                    opcoes: ["Queue", "Stack", "Array", "Set"],
                    respostaCorreta: 1
                ),
                DadosPergunta(
                    texto: "Python foi criado por?",
                    opcoes: ["James Gosling", "Guido van Rossum", "Dennis Ritchie", "Bjarne Stroustrup"],
                    respostaCorreta: 1
                ),
                DadosPergunta(
                    texto: "Git é um sistema de?",
                    opcoes: ["Banco de Dados", "Controle de Versão", "Deploy", "Testing"],
                    respostaCorreta: 1
                )
            ]
        ),
        
        Tema(
            nome: "História",
            icone: "book.closed",
            perguntas: [
                DadosPergunta(
                    texto: "Em que ano foi a Proclamação da República no Brasil?",
                    opcoes: ["1822", "1889", "1891", "1930"],
                    respostaCorreta: 1
                ),
                DadosPergunta(
                    texto: "Quem descobriu o Brasil?",
                    opcoes: ["Cristóvão Colombo", "Vasco da Gama", "Pedro Álvares Cabral", "Fernão de Magalhães"],
                    respostaCorreta: 2
                ),
                DadosPergunta(
                    texto: "A Revolução Francesa começou em que ano?",
                    opcoes: ["1776", "1789", "1799", "1804"],
                    respostaCorreta: 1
                ),
                DadosPergunta(
                    texto: "Qual foi a primeira capital do Brasil?",
                    opcoes: ["Rio de Janeiro", "São Paulo", "Salvador", "Brasília"],
                    respostaCorreta: 2
                ),
                DadosPergunta(
                    texto: "A Segunda Guerra Mundial terminou em?",
                    opcoes: ["1943", "1944", "1945", "1946"],
                    respostaCorreta: 2
                )
            ]
        ),
        
        Tema(
            nome: "Entretenimento",
            icone: "tv",
            perguntas: [
                DadosPergunta(
                    texto: "Quem escreveu 'Harry Potter'?",
                    opcoes: ["J.R.R. Tolkien", "J.K. Rowling", "C.S. Lewis", "George R.R. Martin"],
                    respostaCorreta: 1
                ),
                DadosPergunta(
                    texto: "Qual série tem mais temporadas?",
                    opcoes: ["Friends", "The Office", "Grey's Anatomy", "Supernatural"],
                    respostaCorreta: 2
                ),
                DadosPergunta(
                    texto: "O livro '1984' foi escrito por?",
                    opcoes: ["Aldous Huxley", "Ray Bradbury", "George Orwell", "Isaac Asimov"],
                    respostaCorreta: 2
                ),
                DadosPergunta(
                    texto: "Qual streaming lançou 'Stranger Things'?",
                    opcoes: ["Amazon Prime", "Netflix", "Disney+", "HBO Max"],
                    respostaCorreta: 1
                ),
                DadosPergunta(
                    texto: "Titanic ganhou quantos Oscars?",
                    opcoes: ["9", "10", "11", "12"],
                    respostaCorreta: 2
                )
            ]
        ),
        
        Tema(
            nome: "Ciências",
            icone: "atom",
            perguntas: [
                DadosPergunta(
                    texto: "Qual a velocidade da luz?",
                    opcoes: ["300.000 km/s", "150.000 km/s", "450.000 km/s", "200.000 km/s"],
                    respostaCorreta: 0
                ),
                DadosPergunta(
                    texto: "Quantos planetas tem o Sistema Solar?",
                    opcoes: ["7", "8", "9", "10"],
                    respostaCorreta: 1
                ),
                DadosPergunta(
                    texto: "Qual o símbolo químico do Ouro?",
                    opcoes: ["Go", "Au", "Or", "Gd"],
                    respostaCorreta: 1
                ),
                DadosPergunta(
                    texto: "A gravidade na Terra é?",
                    opcoes: ["8.8 m/s²", "9.8 m/s²", "10.8 m/s²", "11.8 m/s²"],
                    respostaCorreta: 1
                ),
                DadosPergunta(
                    texto: "Qual é o maior órgão do corpo humano?",
                    opcoes: ["Fígado", "Coração", "Pele", "Pulmão"],
                    respostaCorreta: 2
                ),
                DadosPergunta(
                    texto: "Qual é a fórmula da água?",
                    opcoes: ["H2O", "HO2", "H3O", "H2O2"],
                    respostaCorreta: 0
                )
            ]
        )
    ]
}

// Banco de Perguntas
final class BancoPerguntas {
    static let compartilhado = BancoPerguntas()
    
    private init() {}
    
    var todosTemas: [Tema] {
        DadosPerguntas.todosTemas
    }
    
    func obterPerguntasAleatorias(do tema: Tema, quantidade: Int) -> [Pergunta] {
        let perguntas = tema.perguntas.map { p in
            Pergunta(texto: p.texto, opcoes: p.opcoes, respostaCorreta: p.respostaCorreta)
        }
        return Array(perguntas.shuffled().prefix(quantidade))
    }
}
