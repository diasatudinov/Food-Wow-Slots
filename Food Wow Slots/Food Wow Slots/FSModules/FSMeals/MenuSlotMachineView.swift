import SwiftUI

struct MenuScrollMachineView: View {

    @ObservedObject var viewModel: FSFavoritesViewModel
    
    @State private var selectedMeal: MealType = .lunch
    @State private var spinToken = 0
    @State private var isSpinning = false
    @State private var targetIndexes: [Int] = [0, 0, 0]
    @State private var finishedColumns = 0
    @State private var showResultPopup = false

    private let itemHeight: CGFloat = 78

    private var columns: [MenuColumn] {
        selectedMeal.columns
    }

    var body: some View {
        GeometryReader { geo in
            let horizontalPadding: CGFloat = 24
            let spacing: CGFloat = 14
            let columnWidth = (geo.size.width - horizontalPadding * 2 - spacing * 2) / 3

            ZStack {
                backgroundView
                    .ignoresSafeArea()

                VStack(spacing: 22) {
                   

                    Image(.menuTextFS)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 20)

                    mealPicker
                        .padding(.bottom, 40)

                    HStack(spacing: spacing) {
                        ForEach(columns.indices, id: \.self) { index in
                            Text(columns[index].title.uppercased())
                                .font(.system(size: 18, weight: .black))
                                .foregroundColor(.yellow)
                                .frame(width: columnWidth)
                        }
                    }
                    .padding(.top, 6)

                    ZStack {
                        HStack(spacing: spacing) {
                            ForEach(columns.indices, id: \.self) { index in
                                MenuScrollColumnView(
                                    items: columns[index].items,
                                    width: columnWidth,
                                    itemHeight: itemHeight,
                                    spinToken: spinToken,
                                    targetIndex: targetIndexes[index],
                                    pattern: pattern(for: index),
                                    durationSet: durations(for: index),
                                    onFinished: {
                                        finishedColumns += 1

                                        if finishedColumns == 3 {
                                            isSpinning = false
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                                showResultPopup = true
                                            }
                                        }
                                    }
                                )
                            }
                        }

                        selectionFrame
                    }
                    .padding(.horizontal, horizontalPadding)
                    .padding(.bottom, 30)

                    Button(action: spin) {
                        HStack(spacing: 12) {
                            Image(systemName: "star.fill")
                                .font(.system(size: 26, weight: .bold))

                            Text(isSpinning ? "SPINNING..." : "SPIN NOW!")
                                .font(.system(size: 24, weight: .heavy))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 88)
                        .background(
                            Gradients.spinBtn.linear
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 28))
                        .shadow(color: .orange.opacity(0.55), radius: 16, x: 0, y: 8)
                    }
                    .disabled(isSpinning)
                    .padding(.horizontal, horizontalPadding)
                    
                    Spacer(minLength: 20)
                }
                .padding(.top, 40)
                
                if showResultPopup {
                    resultPopup
                }
            }
        }
        .onChange(of: selectedMeal) { _ in
            showResultPopup = false
        }
    }

    private var backgroundView: some View {
        Image(.appBgFS)
            .resizable()
    }

    private var mealPicker: some View {
        HStack(spacing: 12) {
            ForEach(MealType.allCases) { meal in
                Button {
                    guard !isSpinning else { return }
                    selectedMeal = meal
                    showResultPopup = false
                } label: {
                    
                    Image("\(meal.image)\(selectedMeal == meal ? "On" : "Off")")
                        .resizable()
                        .scaledToFit()
                }
            }
        }
        .padding(.horizontal, 24)
    }

    private var selectionFrame: some View {
        
        Image(.selectionFrameFS)
            .resizable()
            .scaledToFit()
            .padding(.horizontal, -24)
            .allowsHitTesting(false)
            
    }

    private var resultPopup: some View {
        ZStack {
            Color.black.opacity(0.45)
                .ignoresSafeArea()
                .onTapGesture {
                    showResultPopup = false
                }

            VStack(spacing: 18) {
                Text("Your Meal\nCombo!")
                    .font(.system(size: 30, weight: .black))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)

                VStack(spacing: 12) {
                    resultRow(image: "mainIcon", title: columns[0].title, value: columns[0].items[targetIndexes[0]])
                    resultRow(image: "drinkIcon", title: columns[1].title, value: columns[1].items[targetIndexes[1]])
                    resultRow(image: "sideIcon", title: columns[2].title, value: columns[2].items[targetIndexes[2]])
                }
                
                VStack {
                    Button {
                        showResultPopup = false
                        let meal = Meal(main: columns[0].items[targetIndexes[0]], drink: columns[1].items[targetIndexes[1]], side: columns[2].items[targetIndexes[2]])
                        viewModel.addMeal(meal)
                    } label: {
                        HStack {
                            Image(systemName: "heart.fill")
                            
                            Text("Save to Favorites")
                        }
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Gradients.spinBtn.linear)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                    
                    HStack {
                        Button {
                            showResultPopup = false
                        } label: {
                            Text("Close")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(.white.opacity(0.1))
                                .clipShape(RoundedRectangle(cornerRadius: 14))
                        }
                        
                        Button {
                            showResultPopup = false
                        } label: {
                            Text("Spin Again")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(Color.btn3.opacity(0.5))
                                .clipShape(RoundedRectangle(cornerRadius: 14))
                        }
                    }
                    
                }
            }
            .padding(22)
            .frame(maxWidth: 340)
            .background(.resultBg)
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(Color.resultStroke, lineWidth: 1)
            )
            .padding(.horizontal, 24)
        }
        .transition(.opacity)
    }

    private func resultRow(image: String, title: String, value: String) -> some View {
        HStack {
            Image(image)
                .resizable()
                .scaledToFit()
                .frame(height: 35)
            
            VStack(alignment: .leading, spacing: 6) {
                Text(title.uppercased())
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.yellow)
                
                Text(value)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal, 18)
        .frame(maxWidth: .infinity)
        .padding(.vertical, 18)
        .background(Color.white.opacity(0.06))
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay {
            RoundedRectangle(cornerRadius: 14)
                .stroke(lineWidth: 1)
                .foregroundStyle(.yellow)
        }
    }

    private func spin() {
        guard !isSpinning else { return }

        showResultPopup = false
        isSpinning = true
        finishedColumns = 0

        targetIndexes = columns.map { _ in Int.random(in: 0..<10) }
        spinToken += 1
    }

    private func pattern(for index: Int) -> [ScrollEdge] {
        switch index {
        case 0:
            return [.bottom, .top, .bottom]
        case 1:
            return [.top, .bottom, .top, .bottom]
        default:
            return [.bottom, .top, .bottom, .top]
        }
    }

    private func durations(for index: Int) -> [Double] {
        switch index {
        case 0:
            return [0.70, 0.75, 0.65, 0.35]
        case 1:
            return [0.55, 0.80, 0.60, 0.75, 0.35]
        default:
            return [0.80, 0.60, 0.75, 0.55, 0.35]
        }
    }
}

struct MenuScrollColumnView: View {
    let items: [String]
    let width: CGFloat
    let itemHeight: CGFloat
    let spinToken: Int
    let targetIndex: Int
    let pattern: [ScrollEdge]
    let durationSet: [Double]
    let onFinished: () -> Void

    private let repeatCount = 12
    private let middleCycle = 5

    @State private var didSetupInitialPosition = false

    private var repeatedItems: [String] {
        Array(repeating: items, count: repeatCount).flatMap { $0 }
    }

    private var centerIndex: Int {
        middleCycle * items.count
    }

    var body: some View {
        ScrollViewReader { proxy in
            ZStack {
                RoundedRectangle(cornerRadius: 28)
                    .fill(Color.white.opacity(0.08))

                RoundedRectangle(cornerRadius: 28)
                    .stroke(Color.white.opacity(0.95), lineWidth: 3)

                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack(spacing: 0) {
                        Color.clear
                            .frame(height: itemHeight)

                        ForEach(Array(repeatedItems.enumerated()), id: \.offset) { index, item in
                            Text(item)
                                .font(.system(size: 17, weight: .bold))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .lineLimit(2)
                                .minimumScaleFactor(0.72)
                                .padding(.horizontal, 8)
                                .frame(width: width, height: itemHeight)
                                .id(index)
                        }

                        Color.clear
                            .frame(height: itemHeight)
                    }
                }
                .scrollDisabled(true)
                .onAppear {
                    guard !didSetupInitialPosition else { return }
                    didSetupInitialPosition = true

                    DispatchQueue.main.async {
                        proxy.scrollTo(centerIndex, anchor: .center)
                    }
                }
                .onChange(of: spinToken) { _ in
                    Task { @MainActor in
                        await runSpin(proxy: proxy)
                    }
                }

                VStack {
                    LinearGradient(
                        colors: [Color.black.opacity(0.35), Color.clear],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: 54)

                    Spacer()

                    LinearGradient(
                        colors: [Color.clear, Color.black.opacity(0.35)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: 54)
                }
                .clipShape(RoundedRectangle(cornerRadius: 28))
                .allowsHitTesting(false)
            }
            .frame(width: width, height: itemHeight * 3)
            .clipped()
        }
    }

    @MainActor
    private func runSpin(proxy: ScrollViewProxy) async {
        let topIndex = 0
        let bottomIndex = repeatedItems.count - 1
        let finalIndex = centerIndex + targetIndex

        for (step, edge) in pattern.enumerated() {
            let duration = durationSet[min(step, durationSet.count - 1)]

            withAnimation(.easeInOut(duration: duration)) {
                switch edge {
                case .top:
                    proxy.scrollTo(topIndex, anchor: .center)
                case .bottom:
                    proxy.scrollTo(bottomIndex, anchor: .center)
                }
            }

            try? await Task.sleep(nanoseconds: UInt64((duration + 0.08) * 1_000_000_000))
        }

        let finalDuration = durationSet.last ?? 0.35

        withAnimation(.easeOut(duration: finalDuration)) {
            proxy.scrollTo(finalIndex, anchor: .center)
        }

        try? await Task.sleep(nanoseconds: UInt64((finalDuration + 0.05) * 1_000_000_000))
        onFinished()
    }
}

enum ScrollEdge {
    case top
    case bottom
}

struct MenuColumn {
    let title: String
    let items: [String]
}

enum MealType: String, CaseIterable, Identifiable {
    case breakfast
    case lunch
    case dinner

    var id: String { rawValue }

    var image: String {
        switch self {
        case .breakfast:
            "breakfast"
        case .lunch:
            "lunch"
        case .dinner:
            "dinner"
        }
    }
    var title: String {
        switch self {
        case .breakfast: return "Breakfast"
        case .lunch: return "Lunch"
        case .dinner: return "Dinner"
        }
    }

    var icon: String {
        switch self {
        case .breakfast: return "cup.and.saucer.fill"
        case .lunch: return "sun.max.fill"
        case .dinner: return "moon.fill"
        }
    }

    var columns: [MenuColumn] {
        switch self {
        case .breakfast:
            return [
                MenuColumn(
                    title: "Main",
                    items: [
                        "Omelet",
                        "Oatmeal",
                        "Cottage Cheese",
                        "Pancakes",
                        "Syrniki",
                        "Egg Toast",
                        "Buckwheat",
                        "Yogurt Parfait",
                        "Croissant",
                        "Cheese Lavash"
                    ]
                ),
                MenuColumn(
                    title: "Drink",
                    items: [
                        "Coffee",
                        "Green Tea",
                        "Orange Juice",
                        "Cocoa",
                        "Smoothie",
                        "Milk",
                        "Chicory",
                        "Compote",
                        "Lemon Water",
                        "Kefir"
                    ]
                ),
                MenuColumn(
                    title: "Sweet",
                    items: [
                        "Honey",
                        "Jam",
                        "Chocolate Bar",
                        "Fruit Salad",
                        "Cookies",
                        "Marmalade",
                        "Nut Butter",
                        "Condensed Milk",
                        "Marshmallow",
                        "Pastila"
                    ]
                )
            ]

        case .lunch:
            return [
                MenuColumn(
                    title: "Soup",
                    items: [
                        "Borscht",
                        "Solyanka",
                        "Tom Yum",
                        "Mushroom Cream Soup",
                        "Okroshka",
                        "Rassolnik",
                        "Lentil Soup",
                        "Fish Soup",
                        "Pea Soup",
                        "Miso Soup"
                    ]
                ),
                MenuColumn(
                    title: "Drink",
                    items: [
                        "Mors",
                        "Black Tea",
                        "Lemonade",
                        "Kvass",
                        "Dried Fruit Compote",
                        "Water",
                        "Drinking Yogurt",
                        "Ayran",
                        "Tomato Juice",
                        "Celery Juice"
                    ]
                ),
                MenuColumn(
                    title: "Salad",
                    items: [
                        "Caesar",
                        "Greek Salad",
                        "Olivier Salad",
                        "Vinaigrette",
                        "Crab Salad",
                        "Caprese",
                        "Beetroot with Garlic",
                        "Korean Carrot Salad",
                        "Tuna Salad",
                        "Arugula with Pear"
                    ]
                )
            ]

        case .dinner:
            return [
                MenuColumn(
                    title: "Main",
                    items: [
                        "Steak",
                        "Chicken Breast",
                        "Grilled Salmon",
                        "Cutlets",
                        "Stuffed Peppers",
                        "Pasta Carbonara",
                        "Shashlik",
                        "Meatballs",
                        "Baked Fish",
                        "Roast"
                    ]
                ),
                MenuColumn(
                    title: "Side",
                    items: [
                        "Rice",
                        "Buckwheat",
                        "Mashed Potatoes",
                        "Pasta",
                        "Grilled Vegetables",
                        "Quinoa",
                        "Bulgur",
                        "Braised Cabbage",
                        "Beans",
                        "Couscous"
                    ]
                ),
                MenuColumn(
                    title: "Drink",
                    items: [
                        "Red Wine",
                        "White Tea",
                        "Kefir",
                        "Mint Water",
                        "Ginger Tea",
                        "Compote",
                        "Sparkling Water",
                        "Ryazhenka",
                        "Herbal Tea",
                        "Grapefruit Juice"
                    ]
                )
            ]
        }
    }
}

#Preview {
    MenuScrollMachineView(viewModel: FSFavoritesViewModel())
}
