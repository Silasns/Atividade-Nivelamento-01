//
//  JogoDePerguntasApp.swift
//  JogoDePerguntas
//
//  Created by Cardoso, Silas Nunes on 25/04/26.
//

import SwiftUI

@main
struct AppQuiz: App {
    @StateObject private var viewModel = ViewQuiz()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}
