import Foundation

enum MesDespesa: Int, CaseIterable, Identifiable {
    case janeiro   = 1
    case fevereiro = 2
    case marco     = 3
    case abril     = 4
    case maio      = 5
    case junho     = 6
    case julho     = 7
    case agosto    = 8
    case setembro  = 9
    case outubro   = 10
    case novembro  = 11
    case dezembro  = 12

    var id: Int { rawValue }

    var nome: String {
        switch self {
        case .janeiro:   return "Janeiro"
        case .fevereiro: return "Fevereiro"
        case .marco:     return "Março"
        case .abril:     return "Abril"
        case .maio:      return "Maio"
        case .junho:     return "Junho"
        case .julho:     return "Julho"
        case .agosto:    return "Agosto"
        case .setembro:  return "Setembro"
        case .outubro:   return "Outubro"
        case .novembro:  return "Novembro"
        case .dezembro:  return "Dezembro"
        }
    }

    var abreviacao: String { String(nome.prefix(3)) }
}
