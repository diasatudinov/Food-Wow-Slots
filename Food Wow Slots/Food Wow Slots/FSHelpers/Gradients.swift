import SwiftUI

enum Gradients {
    case buttons
    case brightButton
    var color: Gradient {
        switch self {
        case .buttons:
            Gradient(colors: [.buttonsTop, .buttonsBottom])
        case .brightButton :
            Gradient(colors: [.brightButtonTop, .brightButtonBottom])
        }
    }
    
}