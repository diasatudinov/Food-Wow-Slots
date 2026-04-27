//
//  FSFavoritesViewModel.swift
//  Food Wow Slots
//
//

import SwiftUI

final class FSFavoritesViewModel: ObservableObject {
    @Published var favoriteMeals: [Meal] = [
        
    ] {
        didSet {
            saveMealsItem()
        }
    }
    
    private let userDefaultsMealsKey = "userDefaultsMealsKey"
    
    init() {
        loadMealsItem()
    }
    
    private func saveMealsItem() {
        if let encodedData = try? JSONEncoder().encode(favoriteMeals) {
            UserDefaults.standard.set(encodedData, forKey: userDefaultsMealsKey)
        }
        
    }
    
    private func loadMealsItem() {
        if let savedData = UserDefaults.standard.data(forKey: userDefaultsMealsKey),
           let loadedItem = try? JSONDecoder().decode([Meal].self, from: savedData) {
            favoriteMeals = loadedItem
        } else {
            print("No saved data found")
        }
    }
    
    func addMeal(_ meal: Meal) {
        favoriteMeals.append(meal)
    }
}
