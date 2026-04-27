//
//  FSMeal.swift
//  Food Wow Slots
//
//

import Foundation

struct Meal: Codable, Hashable, Identifiable {
    let id = UUID()
    var main: String
    var drink: String
    var side: String
    var date: Date = .now
}
