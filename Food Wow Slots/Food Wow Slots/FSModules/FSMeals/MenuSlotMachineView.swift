import SwiftUI

// MARK: - Constants

private let reelItemHeight: CGFloat = 78
private let reelVisibleRows = 3
private let reelRepeatCount = 24
private let reelBaseCopyIndex = 8

// MARK: - Main View

struct MenuSlotMachineView: View {

    @State private var selectedCategory: MealCategory = .lunch
    @State private var reels: [ReelState] = []
    @State private var isSpinning = false

    init() {
        let initialColumns = MealCategory.lunch.columns
        _reels = State(initialValue: initialColumns.map { ReelState(itemCount: $0.items.count) })
    }

    private var columns: [MenuColumn] {
        selectedCategory.columns
    }

    private var resultText: String {
        guard reels.count == 3 else { return "" }

        let first = columns[0].items[reels[0].currentResult]
        let second = columns[1].items[reels[1].currentResult]
        let third = columns[2].items[reels[2].currentResult]

        return "\(first) • \(second) • \(third)"
    }

    var body: some View {
        GeometryReader { geo in
            let horizontalPadding: CGFloat = 24
            let spacing: CGFloat = 14
            let columnWidth = (geo.size.width - horizontalPadding * 2 - spacing * 2) / 3

            ZStack {
                backgroundView
                    .ignoresSafeArea()

                VStack(spacing: 24) {
                    Spacer(minLength: 12)

                    Text("Menu")
                        .font(.system(size: 34, weight: .heavy))
                        .foregroundColor(.yellow)

                    categoryPicker

                    VStack(spacing: 12) {
                        HStack(spacing: spacing) {
                            ForEach(0..<columns.count, id: \.self) { index in
                                Text(columns[index].title.uppercased())
                                    .font(.system(size: 17, weight: .black))
                                    .foregroundColor(.yellow)
                                    .frame(width: columnWidth)
                            }
                        }

                        ZStack {
                            HStack(spacing: spacing) {
                                ForEach(0..<columns.count, id: \.self) { index in
                                    SlotReelView(
                                        items: columns[index].items,
                                        reel: reels[index],
                                        width: columnWidth
                                    )
                                }
                            }

                            selectionBand
                        }
                    }
                    .padding(.top, 8)

                    VStack(spacing: 8) {
                        Text("ВЫБОР")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(.white.opacity(0.7))

                        Text(resultText)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 16)
                    }
                    .padding(.vertical, 14)
                    .frame(maxWidth: .infinity)
                    .background(Color.white.opacity(0.10))
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                    .padding(.horizontal, horizontalPadding)

                    Spacer()

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
                            LinearGradient(
                                colors: [
                                    Color.yellow,
                                    Color.orange,
                                    Color(red: 0.95, green: 0.45, blue: 0.02)
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 28))
                        .shadow(color: .orange.opacity(0.55), radius: 16, x: 0, y: 8)
                    }
                    .disabled(isSpinning)
                    .padding(.horizontal, horizontalPadding)
                    .padding(.bottom, 32)
                }
            }
        }
        .onChange(of: selectedCategory) { _ in
            resetReels()
        }
    }

    // MARK: - UI Parts

    private var backgroundView: some View {
        LinearGradient(
            colors: [
                Color(red: 0.02, green: 0.09, blue: 0.48),
                Color(red: 0.00, green: 0.45, blue: 0.82),
                Color(red: 0.00, green: 0.78, blue: 0.74)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }

    private var categoryPicker: some View {
        HStack(spacing: 0) {
            ForEach(MealCategory.allCases) { category in
                Button {
                    guard !isSpinning else { return }
                    selectedCategory = category
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: category.icon)
                            .font(.system(size: 16, weight: .semibold))

                        Text(category.title)
                            .font(.system(size: 17, weight: .bold))
                    }
                    .foregroundColor(selectedCategory == category ? .black : .white.opacity(0.75))
                    .frame(maxWidth: .infinity)
                    .frame(height: 58)
                    .background(
                        RoundedRectangle(cornerRadius: 18)
                            .fill(selectedCategory == category ? Color.yellow : Color.white.opacity(0.10))
                    )
                }
            }
        }
        .padding(6)
        .background(Color.white.opacity(0.12))
        .clipShape(RoundedRectangle(cornerRadius: 22))
        .padding(.horizontal, 24)
    }

    private var selectionBand: some View {
        RoundedRectangle(cornerRadius: 18)
            .fill(Color.yellow.opacity(0.18))
            .frame(height: reelItemHeight)
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(Color.yellow, lineWidth: 4)
            )
            .padding(.horizontal, 4)
            .allowsHitTesting(false)
    }

    // MARK: - Actions

    private func resetReels() {
        reels = columns.map { ReelState(itemCount: $0.items.count) }
    }

    private func spin() {
        guard !isSpinning else { return }
        guard reels.count == columns.count else { return }

        isSpinning = true

        for index in reels.indices {
            let delay = Double(index) * 0.18
            spinReel(at: index, delay: delay)
        }

        let lastDuration = 2.0 + Double(reels.count - 1) * 0.35
        let lastDelay = Double(reels.count - 1) * 0.18
        let totalTime = lastDuration + lastDelay

        DispatchQueue.main.asyncAfter(deadline: .now() + totalTime + 0.1) {
            isSpinning = false
        }
    }

    private func spinReel(at index: Int, delay: Double) {
        let itemsCount = columns[index].items.count
        let newResult = Int.random(in: 0..<itemsCount)
        let currentResult = reels[index].currentResult

        let delta = (newResult - currentResult + itemsCount) % itemsCount
        let extraRounds = Int.random(in: 5...7)
        let targetDisplayIndex = reels[index].currentDisplayIndex + extraRounds * itemsCount + delta
        let duration = 2.0 + Double(index) * 0.35

        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            withAnimation(.easeOut(duration: duration)) {
                reels[index].offset = ReelState.offset(for: targetDisplayIndex)
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                reels[index].currentResult = newResult
                reels[index].currentDisplayIndex = reelBaseCopyIndex * itemsCount + newResult
                reels[index].offset = ReelState.offset(for: reels[index].currentDisplayIndex)
            }
        }
    }
}

// MARK: - Reel View

struct SlotReelView: View {
    let items: [String]
    let reel: ReelState
    let width: CGFloat

    private var repeatedItems: [String] {
        Array(repeating: items, count: reelRepeatCount).flatMap { $0 }
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 28)
                .fill(Color.white.opacity(0.08))

            RoundedRectangle(cornerRadius: 28)
                .stroke(Color.white.opacity(0.95), lineWidth: 3)

            VStack(spacing: 0) {
                ForEach(Array(repeatedItems.enumerated()), id: \.offset) { _, item in
                    Text(item)
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .minimumScaleFactor(0.75)
                        .padding(.horizontal, 8)
                        .frame(width: width, height: reelItemHeight)
                }
            }
            .offset(y: reel.offset)

            VStack {
                LinearGradient(
                    colors: [Color.black.opacity(0.35), Color.clear],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 56)

                Spacer()

                LinearGradient(
                    colors: [Color.clear, Color.black.opacity(0.35)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 56)
            }
            .clipShape(RoundedRectangle(cornerRadius: 28))
            .allowsHitTesting(false)
        }
        .frame(width: width, height: reelItemHeight * CGFloat(reelVisibleRows))
        .clipped()
    }
}

// MARK: - Models

struct MenuColumn {
    let title: String
    let items: [String]
}

enum MealCategory: String, CaseIterable, Identifiable {
    case breakfast
    case lunch
    case dinner

    var id: String { rawValue }

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
                    title: "Продукт",
                    items: [
                        "Омлет",
                        "Овсянка",
                        "Творог",
                        "Блины",
                        "Сырники",
                        "Тост с яйцом",
                        "Гречка",
                        "Йогурт-парфе",
                        "Круассан",
                        "Лаваш с сыром"
                    ]
                ),
                MenuColumn(
                    title: "Напиток",
                    items: [
                        "Кофе",
                        "Чай зелёный",
                        "Апельсиновый сок",
                        "Какао",
                        "Смузи",
                        "Молоко",
                        "Цикорий",
                        "Компот",
                        "Вода с лимоном",
                        "Кефир"
                    ]
                ),
                MenuColumn(
                    title: "Сладкое",
                    items: [
                        "Мёд",
                        "Варенье",
                        "Шоколадный батончик",
                        "Фруктовый салат",
                        "Печенье",
                        "Мармелад",
                        "Ореховая паста",
                        "Сгущёнка",
                        "Зефир",
                        "Пастила"
                    ]
                )
            ]

        case .lunch:
            return [
                MenuColumn(
                    title: "Суп",
                    items: [
                        "Борщ",
                        "Солянка",
                        "Том Ям",
                        "Грибной крем-суп",
                        "Окрошка",
                        "Рассольник",
                        "Чечевичный суп",
                        "Уха",
                        "Гороховый суп",
                        "Мисо-суп"
                    ]
                ),
                MenuColumn(
                    title: "Напиток",
                    items: [
                        "Морс",
                        "Чай чёрный",
                        "Лимонад",
                        "Квас",
                        "Компот из сухофруктов",
                        "Вода",
                        "Йогурт питьевой",
                        "Айран",
                        "Томатный сок",
                        "Сельдерейный сок"
                    ]
                ),
                MenuColumn(
                    title: "Салат",
                    items: [
                        "Цезарь",
                        "Греческий",
                        "Оливье",
                        "Винегрет",
                        "Крабовый",
                        "Капрезе",
                        "Свёкла с чесноком",
                        "Морковь по-корейски",
                        "Салат с тунцом",
                        "Руккола с грушей"
                    ]
                )
            ]

        case .dinner:
            return [
                MenuColumn(
                    title: "Горячее",
                    items: [
                        "Стейк",
                        "Куриная грудка",
                        "Лосось на гриле",
                        "Котлеты",
                        "Фаршированные перцы",
                        "Паста Карбонара",
                        "Шашлык",
                        "Тефтели",
                        "Запечённая рыба",
                        "Жаркое"
                    ]
                ),
                MenuColumn(
                    title: "Гарнир",
                    items: [
                        "Рис",
                        "Гречка",
                        "Картофель пюре",
                        "Макароны",
                        "Овощи гриль",
                        "Киноа",
                        "Булгур",
                        "Тушёная капуста",
                        "Фасоль",
                        "Кускус"
                    ]
                ),
                MenuColumn(
                    title: "Напиток",
                    items: [
                        "Красное вино",
                        "Белый чай",
                        "Кефир",
                        "Вода с мятой",
                        "Имбирный чай",
                        "Компот",
                        "Минералка",
                        "Ряженка",
                        "Травяной настой",
                        "Сок грейпфрута"
                    ]
                )
            ]
        }
    }
}

struct ReelState {
    var currentResult: Int = 0
    var currentDisplayIndex: Int
    var offset: CGFloat

    init(itemCount: Int) {
        currentDisplayIndex = reelBaseCopyIndex * itemCount
        offset = ReelState.offset(for: currentDisplayIndex)
    }

    static func offset(for displayIndex: Int) -> CGFloat {
        -CGFloat(displayIndex - 1) * reelItemHeight
    }
}

// MARK: - Preview

struct MenuSlotMachineView_Previews: PreviewProvider {
    static var previews: some View {
        MenuSlotMachineView()
    }
}