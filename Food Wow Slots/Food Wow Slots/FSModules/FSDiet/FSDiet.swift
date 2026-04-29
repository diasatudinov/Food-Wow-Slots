//
//  FSDiet.swift
//  Food Wow Slots
//
//

import SwiftUI

struct FSDiet: Codable, Hashable, Identifiable {
    let id = UUID()
    var diet: String
    var date: Date = .now
}
