//
//  FSDietView.swift
//  Food Wow Slots
//
//

import SwiftUI

struct FSDietView: View {
    
    private let topSectorOffsetDegrees: Double = 0

        @State private var wheelRotation: Double = 0
        @State private var isSpinning = false
        @State private var selectedDiet: DietOption?
        @State private var showResult = false

        private let diets: [DietOption] = DietOption.all
        private var sectorAngle: Double { 360.0 / Double(diets.count) }
    
    var body: some View {
        ZStack {
            VStack {
                VStack {
                    Image(.dietTextFS)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 20)
                    
                    ZStack {
                        wheelView
                        
                        pointerView
                            .offset(y: -170)
                    }
                    .padding(.top, 60)
                    
                    Button {
                        spinWheel()
                    } label: {
                        Image(.spinWheelBtnFS)
                            .resizable()
                            .scaledToFit()
                            .padding(.horizontal)
                    }
                    
                    Spacer()
                }
                .padding(.vertical, 30)
            }
            .background(
                Image(.appBgFS)
                    .resizable()
                    .ignoresSafeArea()
            )
            
            if showResult, let selectedDiet {
                resultPopup(for: selectedDiet)
            }
        }
    }
    
    private var backgroundView: some View {
            LinearGradient(
                colors: [
                    Color(red: 0.07, green: 0.10, blue: 0.22),
                    Color(red: 0.10, green: 0.24, blue: 0.45),
                    Color(red: 0.14, green: 0.42, blue: 0.62)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        }

        private var wheelView: some View {
            ZStack {
                Image("diet_wheelBg")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 370)
                    .offset(y: -5)

                Image("diet_wheel")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 320, height: 320)
                    .rotationEffect(.degrees(wheelRotation))
                    .shadow(color: .black.opacity(0.25), radius: 15, x: 0, y: 8)

            }
        }

        private var pointerView: some View {
            VStack(spacing: 0) {
                Triangle()
                    .fill(Color.yellow)
                    .frame(width: 30, height: 36)
                    .shadow(color: .yellow.opacity(0.45), radius: 8)

                Circle()
                    .fill(Color.yellow)
                    .frame(width: 12, height: 12)
                    .offset(y: -6)
            }
        }

        private func resultPopup(for diet: DietOption) -> some View {
            ZStack {
                Color.black.opacity(0.45)
                    .ignoresSafeArea()
                    .onTapGesture {
                        showResult = false
                    }

                VStack(spacing: 18) {
                    Text("Result")
                        .font(.system(size: 28, weight: .heavy))
                        .foregroundColor(.white)

                    VStack(spacing: 10) {
                        Text(diet.title)
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.yellow)
                            .multilineTextAlignment(.center)

                        Text("Пример меню на неделю")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white.opacity(0.85))
                    }

                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 10) {
                            ForEach(Array(diet.weekMenu.enumerated()), id: \.offset) { _, item in
                                Text("• \(item)")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                    }
                    .frame(maxHeight: 260)

                    Button {
                        showResult = false
                    } label: {
                        Text("OK")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .frame(height: 52)
                            .background(Color.yellow)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                }
                .padding(22)
                .frame(maxWidth: 360)
                .background(
                    RoundedRectangle(cornerRadius: 28)
                        .fill(Color(red: 0.08, green: 0.12, blue: 0.22))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 28)
                        .stroke(Color.white.opacity(0.10), lineWidth: 1)
                )
                .padding(.horizontal, 24)
            }
            .transition(.opacity)
        }

        private func spinWheel() {
            guard !isSpinning else { return }

            showResult = false
            isSpinning = true

            let selectedIndex = Int.random(in: 0..<diets.count)
            let selected = diets[selectedIndex]

            let currentNormalized = normalizedDegrees(wheelRotation)
            let targetNormalized = normalizedDegrees(
                360 - (topSectorOffsetDegrees + Double(selectedIndex) * sectorAngle)
            )

            let delta = normalizedDegrees(targetNormalized - currentNormalized)
            let extraSpins = Double(Int.random(in: 5...8)) * 360
            let finalRotation = wheelRotation + extraSpins + delta
            let duration = 4.2

            selectedDiet = selected

            withAnimation(.easeOut(duration: duration)) {
                wheelRotation = finalRotation
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                isSpinning = false
                showResult = true
            }
        }

        private func normalizedDegrees(_ value: Double) -> Double {
            let remainder = value.truncatingRemainder(dividingBy: 360)
            return remainder >= 0 ? remainder : remainder + 360
        }
    }

#Preview {
    FSDietView()
}

// MARK: - Triangle

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.closeSubpath()
        return path
    }
}

struct DietOption: Identifiable {
    let id = UUID()
    let title: String
    let weekMenu: [String]

    static let all: [DietOption] = [
        DietOption(
            title: "Mediterranean Diet",
            weekMenu: [
                "Mon: Fish + vegetables",
                "Tue: Pasta + seafood",
                "Wed: Chicken + salad",
                "Thu: Lentils + bread",
                "Fri: Vegetable soup",
                "Sat: Baked eggplants",
                "Sun: Omelet + olives"
            ]
        ),
        DietOption(
            title: "Keto Diet",
            weekMenu: [
                "Mon: Eggs + bacon",
                "Tue: Steak + avocado",
                "Wed: Salmon + asparagus",
                "Thu: Chicken + cauliflower",
                "Fri: Stuffed peppers",
                "Sat: Cheese platter",
                "Sun: Mushroom omelet"
            ]
        ),
        DietOption(
            title: "Vegetarian Diet",
            weekMenu: [
                "Mon: Buckwheat + tofu",
                "Tue: Vegetable stew",
                "Wed: Quinoa + chickpeas",
                "Thu: Pasta with pesto",
                "Fri: Lentil soup",
                "Sat: Vegetable cutlets",
                "Sun: Rice + vegetables"
            ]
        ),
        DietOption(
            title: "Low-Carb Diet",
            weekMenu: [
                "Mon: Chicken + broccoli",
                "Tue: Fish + zucchini",
                "Wed: Turkey + spinach",
                "Thu: Eggs + avocado",
                "Fri: Beef + cauliflower",
                "Sat: Cottage cheese + nuts",
                "Sun: Baked fish + greens"
            ]
        ),
        DietOption(
            title: "Frequent Small Meals",
            weekMenu: [
                "Mon: 6 meals (porridge, fruit, soup, salad, fish, kefir)",
                "Tue: 6 meals (omelet, nuts, borscht, vegetables, chicken, yogurt)",
                "Wed: 6 meals (cottage cheese, apple, soup, salad, turkey, kefir)",
                "Thu: 6 meals (porridge, banana, soup, vegetables, fish, yogurt)",
                "Fri: 6 meals (omelet, pear, soup, salad, chicken, kefir)",
                "Sat: 6 meals (cottage cheese, nuts, soup, vegetables, fish, yogurt)",
                "Sun: 6 meals (porridge, fruit, soup, salad, turkey, kefir)"
            ]
        ),
        DietOption(
            title: "Smoothie Detox Diet",
            weekMenu: [
                "Mon: Green smoothie + vegetables",
                "Tue: Berry smoothie + soup",
                "Wed: Citrus smoothie + salad",
                "Thu: Tropical smoothie + fish",
                "Fri: Vegetable smoothie + porridge",
                "Sat: Fruit smoothie + omelet",
                "Sun: Detox day (smoothies and water only)"
            ]
        )
    ]
}
