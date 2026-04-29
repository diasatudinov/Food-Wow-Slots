//
//  FSMenuView.swift
//  Food Wow Slots
//
//

import SwiftUI

struct WWMenuContainer: View {
    
    @AppStorage("firstOpenBB") var firstOpen: Bool = true
    
    var body: some View {
        NavigationStack {
            ZStack {
                if firstOpen {
                    FSOnboardingView(getStartBtnTapped: {
                        firstOpen = false
                    })
                } else {
                    FSMenuView()
                }
            }
        }
    }
}

struct FSMenuView: View {
    @State var selectedTab = 0
    @StateObject var viewModel = FSFavoritesViewModel()
    private let tabs = ["Meals", "Diets", "Snacks",  "Favorites"]
    
    var body: some View {
        ZStack(alignment: .bottom) {
            
            TabView(selection: $selectedTab) {
                MenuScrollMachineView(viewModel: viewModel)
                    .tag(0)
                
                FSDietView(viewModel: viewModel)
                    .tag(1)
                
                QuickSnackScrollMachineView(viewModel: viewModel)
                    .tag(2)
                
                FSFavoritesView(viewModel: viewModel)
                    .tag(3)
            }
            
            customTabBar
        }
        .background(.clear)
        .ignoresSafeArea(edges: .bottom)
    }
    
    private var customTabBar: some View {
        HStack(spacing: 40) {
            ForEach(0..<tabs.count, id: \.self) { index in
                Button {
                    selectedTab = index
                } label: {
                    VStack(spacing: 4) {
                        Image(selectedTab == index ? selectedIcon(for: index) : icon(for: index))
                            .resizable()
                            .scaledToFit()
                            .frame(height: 47)
                        
                        Text(tabs[index])
                            .font(.system(size: 10, weight: .medium))
                            .foregroundStyle(.white.opacity(selectedTab == index ? 1 : 0.5))
                            .padding(.bottom, 10)
                    }
                    .padding(.top, 10)
                    .padding(.bottom, 4)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.bottom, 5)
        .overlay(alignment: .top) {
            Rectangle()
                .frame(height: 2)
                .foregroundStyle(.secondary.opacity(0.2))
        }
        .background(Gradients.tabBar.color)
    }
    
    private func icon(for index: Int) -> String {
        switch index {
        case 0: return "tab1IconFS"
        case 1: return "tab2IconFS"
        case 2: return "tab3IconFS"
        case 3: return "tab4IconFS"
        default: return ""
        }
    }
    
    private func selectedIcon(for index: Int) -> String {
        switch index {
        case 0: return "tab1IconSelectedFS"
        case 1: return "tab2IconSelectedFS"
        case 2: return "tab3IconSelectedFS"
        case 3: return "tab4IconSelectedFS"
        default: return ""
        }
    }
}

#Preview {
    WWMenuContainer()
}
