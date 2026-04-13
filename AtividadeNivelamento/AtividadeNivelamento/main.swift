//
//  main.swift
//  AtividadeNivelamento
//
//  Created by Cardoso, Silas Nunes on 09/04/26.
//

import Foundation

protocol IUsuario {
    var id: UUID { get }
    var nome: String { get }
    var idade: String { get }
    var telefone: String  { get }
    var email: String { get }
}

struct Usuario: IUsuario {
    let id: UUID = UUID()
    var nome: String
    var idade: String
    var telefone: String
    var email: String
    
    init(_ nome: String,_ idade: String,_ telefone: String,_ email: String){
        self.nome = nome
        self.idade = idade
        self.telefone = telefone
        self.email = email
    }
}

struct Acoes<T: IUsuario> {
    private var dados: [T] = []
    
    func verificaNomeExistente(_ nome: String) -> Bool {
            return dados.contains(where: { $0.nome.lowercased() == nome.lowercased() })
    }
    
    mutating func cadastrar(valor: T) {
        dados.append(valor)
    }
    
    func listar() -> [T] {
        return dados
    }
    
    mutating func alterar(id: UUID, novoUsuario: T) -> Bool {
        if let index = dados.firstIndex(where: { $0.id == id }) {
            dados[index] = novoUsuario
            return true
        }
        return false
    }
    
    mutating func remover(id: UUID) -> Bool {
        if let index = dados.firstIndex(where: { $0.id == id }) {
            dados.remove(at: index)
            return true
        }
        return false
    }
}

var sair: Bool = true;
var usuarios = Acoes<Usuario>()

func validaCampoObrigatorio(_ campo: String) -> String {
    var valor: String!
    
    while valor == nil {
        print("\(campo): ", terminator: "")
        guard let input = readLine(), !input.isEmpty else {
            print("\(campo) é obrigatório!")
            continue
        }
        valor = input
    }
    
    return valor
}

func lerNomeUnico(usuarios: Acoes<Usuario>, _ campo: String) -> String {
    var nome: String!
    
    while nome == nil {
        let input = validaCampoObrigatorio(campo)
        
        // Verifica se já existe
        if usuarios.verificaNomeExistente(input) {
            print("Este nome já está cadastrado! Escolha outro.")
            continue
        }
        
        nome = input
    }
    
    return nome
}

while(sair) {
    print("*****---------------------------------*****")
    print("Olá, Bem vindo ao nosso Sistema de cadastro")
    print("Pressione 1 - Para Cadastrar")
    print("Pressione 2 - Para Listar")
    print("Pressione 3 - Para Alterar")
    print("Pressione 4 - Para Remover")
    print("Pressione 0 - Para Finalizar e sair.")

    
    let listaUsuarios = usuarios.listar();
    print("Opção: ", terminator: "")
    guard let opcao = readLine() else { continue }

    switch opcao {
    case "1":
        print("\n*****---------------------------------*****")
        print("*****------- CADASTRAR USUÁRIO -------*****\n")
        print("Para cadastrar usuário informe: ")

        let nome = lerNomeUnico(usuarios: usuarios, "Nome")
        
        let idade = validaCampoObrigatorio("Idade")
        
        let telefone = validaCampoObrigatorio("Telefone")
        
        let email = validaCampoObrigatorio("E-mail")
        
        let novoUsuario = Usuario(nome, idade, telefone, email)
        usuarios.cadastrar(valor: novoUsuario)
        print("Usuário cadastrado! ID: \(novoUsuario.id)\n\n")
        
        
    case "2":
        if listaUsuarios.isEmpty {
            print("Nenhum usuário cadastrado! \n")
        } else {
            print("┌──────────────────────┬───────┬────────────────┬─────────────────────┐")
            print("│ Nome                 │ Idade │ Telefone       │ Email               │")
            print("├──────────────────────┼───────┼────────────────┼─────────────────────┤")
            
            usuarios.listar().forEach { usuario in
                let nome = usuario.nome.padding(toLength: 20, withPad: " ", startingAt: 0)
                let idade = String(usuario.idade).padding(toLength: 5, withPad: " ", startingAt: 0)
                let telefone = usuario.telefone.padding(toLength: 14, withPad: " ", startingAt: 0)
                let email = usuario.email.padding(toLength: 19, withPad: " ", startingAt: 0)
                
                print("│ \(nome) │ \(idade) │ \(telefone) │ \(email) │")
            }
            print("└──────────────────────┴───────┴────────────────┴─────────────────────┘")
        }
        
    case "3":
        print("\n*****---------------------------------*****")
        print("*****-------- ALTERAR USUÁRIO --------*****\n")
        
        if listaUsuarios.isEmpty {
            print("Nenhum usuário cadastrado!\n")
            continue
        }

        print("Usuários cadastrados:")
        listaUsuarios.enumerated().forEach { index, usuario in
            print("\(index + 1). \(usuario.nome) - ID: \(usuario.id)")
        }
        
        print("\nDigite o número do usuário para alterar: ", terminator: "")
        guard let escolhaStr = readLine(),
              let escolha = Int(escolhaStr),
              escolha > 0,
              escolha <= listaUsuarios.count else {
            print("Opção inválida!")
            continue
        }
        
        let usuarioSelecionado = listaUsuarios[escolha - 1]
        
        print("\n--- Alterando dados de: \(usuarioSelecionado.nome) ---")
        
        print("Nome atual: \(usuarioSelecionado.nome)")
        let novoNome = lerNomeUnico(usuarios: usuarios,"Novo nome")
        
        print("Idade atual: \(usuarioSelecionado.idade)")
        let novaIdade = validaCampoObrigatorio("Nova idade")
        
        print("Telefone atual: \(usuarioSelecionado.telefone)")
        let novoTelefone = validaCampoObrigatorio("Novo telefone")
        
        print("Email atual: \(usuarioSelecionado.email)")
        let novoEmail = validaCampoObrigatorio("Novo email")
        
        var usuarioAtualizado = Usuario(novoNome, novaIdade, novoTelefone, novoEmail)
        
        if usuarios.alterar(id: usuarioSelecionado.id, novoUsuario: usuarioAtualizado) {
            print("Usuário alterado com sucesso!")
        } else {
            print("Erro ao alterar usuário!")
        }
        
    case "4":
        print("\n*****---------------------------------*****")
        print("*****-------- REMOVER USUÁRIO --------*****\n")
        if listaUsuarios.isEmpty {
            print("Nenhum usuário cadastrado!\n")
            continue
        }

        print("Usuários cadastrados:")
        listaUsuarios.enumerated().forEach { index, usuario in
            print("\(index + 1). \(usuario.nome) - ID: \(usuario.id)")
        }
        
        print("\nDigite o número do usuário para alterar: ", terminator: "")
        guard let escolhaStr = readLine(),
              let escolha = Int(escolhaStr),
              escolha > 0,
              escolha <= listaUsuarios.count else {
            print("Opção inválida!")
            continue
        }
        
        let usuarioSelecionado = listaUsuarios[escolha - 1]
        
        if usuarios.remover(id: usuarioSelecionado.id) {
            print(
                "\nUsuário: \(usuarioSelecionado.nome) - ID: \(usuarioSelecionado.id)  removido com sucesso!\n"
            )
        } else {
            print("Erro ao remover usuario!")
        }

    case "0":
        print("Programa finalizado !")
        print("*****---------------------------------***** \n")
        sair = false

    default:
        print("Opção inválida")
    }
    
}
