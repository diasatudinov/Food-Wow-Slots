//
//  Gradients.swift
//  Food Wow Slots
//
//


import SwiftUI

enum Gradients {
    case tabBar, color3Btn, spinBtn
    
    var color: Gradient {
        switch self {
        case .tabBar:
            Gradient(colors: [.tabTop, .tabBottom])
        case .color3Btn:
            Gradient(colors: [.btn1, .btn2, .btn3])
        case .spinBtn:
            Gradient(colors: [.btn1, .btn2, .btn3])
        }
    }
    
    var linear: LinearGradient {
        switch self {
        case .tabBar:
            LinearGradient(colors: [.tabTop, .tabBottom], startPoint: .top, endPoint: .bottom)
        case .color3Btn:
            LinearGradient(gradient: Gradient(colors: [.btn1, .btn2, .btn3]), startPoint: .topLeading, endPoint: .bottomTrailing)
        case .spinBtn:
            LinearGradient(gradient: Gradient(colors: [.spinBtn1, .spinBtn2, .spinBtn1]), startPoint: .topLeading, endPoint: .bottomTrailing)
        }
    }
    
}

