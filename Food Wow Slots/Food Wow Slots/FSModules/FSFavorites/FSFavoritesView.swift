//
//  FSFavoritesView.swift
//  Food Wow Slots
//
//

import SwiftUI



struct FSFavoritesView: View {
    @ObservedObject var viewModel: FSFavoritesViewModel
    
    @State var selectedTab: Tabs = .meals
    var body: some View {
        ZStack {
            Image(.appBgFS)
                .resizable()
                .ignoresSafeArea()
            
            VStack {
                HStack(spacing: 18) {
                    
                    Text("Favorites")
                        .font(.system(size: 34, weight: .black))
                        .foregroundColor(Color(red: 0.30, green: 0.90, blue: 0.95))
                        .minimumScaleFactor(0.8)
                        .textCase(.uppercase)
                }
                
                HStack {
                    ForEach(Tabs.allCases) { tab in
                        HStack(spacing: 4) {
                            Image(tab.icon)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 20)
                            
                            Text(tab.title)
                                .font(.system(size: 14, weight: .medium))
                                .foregroundStyle(.white)
                        }
                        .padding(12)
                        .padding(.horizontal, 10)
                        .background {
                            if selectedTab == tab {
                                Gradients.tab.linear
                            } else {
                                Color.white.opacity(0.1)
                            }
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .onTapGesture {
                            selectedTab = tab
                        }
                    }
                }
                
                VStack {
                    ScrollView(showsIndicators: false) {
                        
                            switch selectedTab {
                            case .meals:
                                VStack(spacing: 12) {
                                    ForEach(viewModel.favoriteMeals, id: \.id) { meal in
                                        
                                        HStack(alignment: .top) {
                                            VStack(alignment: .leading) {
                                                Text("\(formattedDate(meal.date))")
                                                    .font(.system(size: 12, weight: .regular))
                                                    .foregroundStyle(.white.opacity(0.6))
                                                
                                                VStack(alignment: .leading) {
                                                    Text("Main: \(meal.main)")
                                                        .font(.system(size: 14, weight: .medium))
                                                        .foregroundStyle(.white)
                                                    
                                                    Text("Drink: \(meal.drink)")
                                                        .font(.system(size: 14, weight: .medium))
                                                        .foregroundStyle(.white)
                                                    
                                                    Text("Side: \(meal.side)")
                                                        .font(.system(size: 14, weight: .medium))
                                                        .foregroundStyle(.white)
                                                }
                                                
                                                Text("Meals")
                                                    .font(.system(size: 12, weight: .regular))
                                                    .foregroundStyle(.white)
                                                    .padding(5)
                                                    .padding(.horizontal, 7)
                                                    .background {
                                                        Color.white.opacity(0.2)
                                                    }
                                                    .clipShape(RoundedRectangle(cornerRadius: 30))
                                                
                                            }
                                            
                                            Spacer()
                                            
                                            Button {
                                                viewModel.deleteMeal(meal)
                                            } label: {
                                                Image(systemName: "trash")
                                                    .font(.system(size: 12, weight: .regular))
                                                    .foregroundStyle(.white)
                                                    .padding(8)
                                                    .background {
                                                        Color.white.opacity(0.1)
                                                    }
                                                    .clipShape(Circle())
                                            }
                                        }
                                        .padding(20)
                                        .background {
                                            Gradients.mealCell.linear
                                        }
                                        .clipShape(RoundedRectangle(cornerRadius: 16))
                                       
                                    }
                                    
                                }
                                .padding(.horizontal, 24)
                                .padding(.bottom, 100)
                            case .diets:
                                VStack {
                                    ForEach(viewModel.favoriteDiets, id: \.id) { diet in
                                        
                                        FSDietCellView(viewModel: viewModel, diet: diet)
                                        
                                    }
                                }
                                .padding(.horizontal, 24)
                                .padding(.bottom, 100)
                            case .snacks:
                                VStack(spacing: 12) {
                                    ForEach(viewModel.favoriteSnacks, id: \.id) { snack in
                                        
                                        HStack(alignment: .top) {
                                            VStack(alignment: .leading) {
                                                Text("\(formattedDate(snack.date))")
                                                    .font(.system(size: 12, weight: .regular))
                                                    .foregroundStyle(.white.opacity(0.6))
                                                
                                                VStack(alignment: .leading) {
                                                    Text("Base: \(snack.base)")
                                                        .font(.system(size: 14, weight: .medium))
                                                        .foregroundStyle(.white)
                                                    
                                                    Text("Filling: \(snack.filling)")
                                                        .font(.system(size: 14, weight: .medium))
                                                        .foregroundStyle(.white)
                                                    
                                                    Text("Sauce: \(snack.sauce)")
                                                        .font(.system(size: 14, weight: .medium))
                                                        .foregroundStyle(.white)
                                                }
                                                
                                                Text("Snacks")
                                                    .font(.system(size: 12, weight: .regular))
                                                    .foregroundStyle(.white)
                                                    .padding(5)
                                                    .padding(.horizontal, 7)
                                                    .background {
                                                        Color.white.opacity(0.2)
                                                    }
                                                    .clipShape(RoundedRectangle(cornerRadius: 30))
                                                
                                            }
                                            
                                            Spacer()
                                            
                                            Button {
                                                viewModel.deleteSnack(snack)
                                            } label: {
                                                Image(systemName: "trash")
                                                    .font(.system(size: 12, weight: .regular))
                                                    .foregroundStyle(.white)
                                                    .padding(8)
                                                    .background {
                                                        Color.white.opacity(0.1)
                                                    }
                                                    .clipShape(Circle())
                                            }
                                        }
                                        .padding(20)
                                        .background {
                                            Gradients.snackCell.linear
                                        }
                                        .clipShape(RoundedRectangle(cornerRadius: 16))
                                       
                                    }
                                    
                                }
                                .padding(.horizontal, 24)
                                .padding(.bottom, 100)
                            }
                        
                    }
                }
            }
        }
    }
    
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "MMMM d, yyyy"
        return formatter.string(from: date)
    }
}

#Preview {
    FSFavoritesView(viewModel: FSFavoritesViewModel())
}

enum Tabs: String, CaseIterable, Identifiable {
    case meals, diets, snacks
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .meals:
            "Meals"
        case .diets:
            "Diets"
        case .snacks:
            "Snacks"
        }
    }
    
    var icon: String {
        switch self {
        case .meals:
            "mealsIcon"
        case .diets:
            "dietsIcon"
        case .snacks:
            "snacksIcon"
        }
    }
}


struct FSDietCellView: View {
    @ObservedObject var viewModel: FSFavoritesViewModel
    @State var isCompleted: Bool = false
    let diet: FSDiet
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                Text("\(formattedDate(diet.date))")
                    .font(.system(size: 12, weight: .regular))
                    .foregroundStyle(.white.opacity(0.6))
                
                VStack(alignment: .leading) {
                    Text("Base: \(diet.diet)")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(.white)
                }
                
                HStack {
                    Text("Diets")
                        .font(.system(size: 12, weight: .regular))
                        .foregroundStyle(.white)
                        .padding(5)
                        .padding(.horizontal, 7)
                        .background {
                            Color.white.opacity(0.2)
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 30))
                    
                    Spacer()
                    
                    if isCompleted {
                        Text("Completed")
                            .font(.system(size: 12, weight: .regular))
                            .foregroundStyle(.white)
                            .padding(5)
                            .padding(.horizontal, 7)
                            .background {
                                Color.green.opacity(0.4)
                            }
                            .clipShape(RoundedRectangle(cornerRadius: 30))
                    } else {
                        Text("Expired")
                            .font(.system(size: 12, weight: .regular))
                            .foregroundStyle(.white)
                            .padding(5)
                            .padding(.horizontal, 7)
                            .background {
                                Color.red.opacity(0.4)
                            }
                            .clipShape(RoundedRectangle(cornerRadius: 30))
                    }
                }
            }
            
            Spacer()
            
            Button {
                viewModel.deleteDiet(diet)
            } label: {
                Image(systemName: "trash")
                    .font(.system(size: 12, weight: .regular))
                    .foregroundStyle(.white)
                    .padding(8)
                    .background {
                        Color.white.opacity(0.1)
                    }
                    .clipShape(Circle())
            }
        }
        .padding(20)
        .background {
            Gradients.dietCell.linear
        }
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .onTapGesture {
            isCompleted.toggle()
        }

    }
    
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "MMMM d, yyyy"
        return formatter.string(from: date)
    }
    
}
