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
    
    @Published var favoriteDiets: [FSDiet] = [
    ] {
        didSet {
            saveDietsItem()
        }
    }
    
    @Published var favoriteSnacks: [Snack] = [
        
    ] {
        didSet {
            saveSnacksItem()
        }
    }
    
    private let userDefaultsMealsKey = "userDefaultsMealsKey"
    private let userDefaultsDietsKey = "userDefaultsDietsKey"
    private let userDefaultsSnacksKey = "userDefaultsSnacksKey"
    
    init() {
        loadMealsItem()
        loadDietsItem()
        loadSnacksItem()
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
    
    private func saveDietsItem() {
        if let encodedData = try? JSONEncoder().encode(favoriteDiets) {
            UserDefaults.standard.set(encodedData, forKey: userDefaultsDietsKey)
        }
        
    }
    
    private func loadDietsItem() {
        if let savedData = UserDefaults.standard.data(forKey: userDefaultsDietsKey),
           let loadedItem = try? JSONDecoder().decode([FSDiet].self, from: savedData) {
            favoriteDiets = loadedItem
        } else {
            print("No saved data found")
        }
    }
    
    private func saveSnacksItem() {
        if let encodedData = try? JSONEncoder().encode(favoriteSnacks) {
            UserDefaults.standard.set(encodedData, forKey: userDefaultsSnacksKey)
        }
        
    }
    
    private func loadSnacksItem() {
        if let savedData = UserDefaults.standard.data(forKey: userDefaultsSnacksKey),
           let loadedItem = try? JSONDecoder().decode([Snack].self, from: savedData) {
            favoriteSnacks = loadedItem
        } else {
            print("No saved data found")
        }
    }
    
    func addMeal(_ meal: Meal) {
        favoriteMeals.append(meal)
    }
    
    func deleteMeal(_ meal: Meal) {
        if let index = favoriteMeals.firstIndex(where: { $0.id == meal.id }) {
            favoriteMeals.remove(at: index)
        }
    }
    
    func addDiet(_ diet: FSDiet) {
        favoriteDiets.append(diet)
    }
    
    func deleteDiet(_ diet: FSDiet) {
        if let index = favoriteDiets.firstIndex(where: { $0.id == diet.id }) {
            favoriteDiets.remove(at: index)
        }
    }
    
    func addSnack(_ snack: Snack) {
        favoriteSnacks.append(snack)
    }
    
    func deleteSnack(_ snack: Snack) {
        if let index = favoriteSnacks.firstIndex(where: { $0.id == snack.id }) {
            favoriteSnacks.remove(at: index)
        }
    }
}
