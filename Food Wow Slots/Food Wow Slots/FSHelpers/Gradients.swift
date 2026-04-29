//
//  Gradients.swift
//  Food Wow Slots
//
//


import SwiftUI

enum Gradients {
    case tabBar, color3Btn, spinBtn, snack, tab, mealCell, snackCell, dietCell
    
    var color: Gradient {
        switch self {
        case .tabBar:
            Gradient(colors: [.tabTop, .tabBottom])
        case .color3Btn:
            Gradient(colors: [.btn1, .btn2, .btn3])
        case .spinBtn:
            Gradient(colors: [.btn1, .btn2, .btn3])
        case .snack:
            Gradient(colors: [.btn1, .btn2, .btn3])
        case .tab:
            Gradient(colors: [.btn1, .btn2, .btn3])
        case .mealCell:
            Gradient(colors: [.btn1, .btn2, .btn3])
        case .snackCell:
            Gradient(colors: [.btn1, .btn2, .btn3])
        case .dietCell:
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
        case .snack:
            LinearGradient(gradient: Gradient(colors: [.snackTop.opacity(0.2), .snackBottom.opacity(0.2)]), startPoint: .top, endPoint: .bottom)
        case .tab:
            LinearGradient(gradient: Gradient(colors: [.tabLeft, .tabRight]), startPoint: .leading, endPoint: .trailing)
        case .mealCell:
            LinearGradient(gradient: Gradient(colors: [.mealCellTop.opacity(0.4), .mealCellBottom.opacity(0.4)]), startPoint: .topLeading, endPoint: .bottomTrailing)
        case .snackCell:
            LinearGradient(gradient: Gradient(colors: [.mealCellBottom.opacity(0.4), .mealCellBottom.opacity(0.4)]), startPoint: .topLeading, endPoint: .bottomTrailing)
        case .dietCell:
            LinearGradient(gradient: Gradient(colors: [.greenLeft.opacity(0.4), .greenRight.opacity(0.4)]), startPoint: .topLeading, endPoint: .bottomTrailing)
        }
    }
    
}

