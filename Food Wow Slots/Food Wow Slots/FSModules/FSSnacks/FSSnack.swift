//
//  FSSnack.swift
//  Food Wow Slots
//
//

import Foundation

struct Snack: Codable, Hashable, Identifiable {
    let id = UUID()
    var base: String
    var filling: String
    var sauce: String
    var date: Date = .now
}
