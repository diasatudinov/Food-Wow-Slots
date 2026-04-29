import SwiftUI

struct QuickSnackScrollMachineView: View {

    @State private var spinToken = 0
    @State private var isSpinning = false
    @State private var targetIndex: Int = 0
    @State private var finishedColumns = 0
    @State private var showResultPopup = false

    private let itemHeight: CGFloat = 84
    private let combinations = QuickSnackCombination.all

    private var baseItems: [String] {
        combinations.map(\.base)
    }

    private var fillingItems: [String] {
        combinations.map(\.filling)
    }

    private var sauceItems: [String] {
        combinations.map(\.sauce)
    }

    private var selectedCombination: QuickSnackCombination {
        combinations[targetIndex]
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
                    Spacer(minLength: 18)

                    headerView
                        .padding(.horizontal, horizontalPadding)

                    Spacer(minLength: 120)

                    HStack(spacing: spacing) {
                        Text("Base")
                            .modifier(ColumnTitleModifier(width: columnWidth))

                        Text("Filling")
                            .modifier(ColumnTitleModifier(width: columnWidth))

                        Text("Sauce")
                            .modifier(ColumnTitleModifier(width: columnWidth))
                    }

                    ZStack {
                        HStack(spacing: spacing) {
                            QuickSnackScrollColumnView(
                                items: baseItems,
                                width: columnWidth,
                                itemHeight: itemHeight,
                                spinToken: spinToken,
                                targetIndex: targetIndex,
                                pattern: pattern(for: 0),
                                durationSet: durations(for: 0),
                                onFinished: handleColumnFinished
                            )

                            QuickSnackScrollColumnView(
                                items: fillingItems,
                                width: columnWidth,
                                itemHeight: itemHeight,
                                spinToken: spinToken,
                                targetIndex: targetIndex,
                                pattern: pattern(for: 1),
                                durationSet: durations(for: 1),
                                onFinished: handleColumnFinished
                            )

                            QuickSnackScrollColumnView(
                                items: sauceItems,
                                width: columnWidth,
                                itemHeight: itemHeight,
                                spinToken: spinToken,
                                targetIndex: targetIndex,
                                pattern: pattern(for: 2),
                                durationSet: durations(for: 2),
                                onFinished: handleColumnFinished
                            )
                        }

                        selectionFrame
                    }
                    .padding(.horizontal, horizontalPadding)

                    Spacer()

                    Button(action: spin) {
                        HStack(spacing: 12) {
                            Image(systemName: "bolt")
                                .font(.system(size: 24, weight: .bold))

                            Text(isSpinning ? "SPINNING..." : "QUICK SPIN")
                                .font(.system(size: 24, weight: .heavy))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 84)
                        .background(
                            LinearGradient(
                                colors: [
                                    Color.orange,
                                    Color.yellow,
                                    Color.orange
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 28))
                        .shadow(color: .orange.opacity(0.45), radius: 14, x: 0, y: 8)
                    }
                    .disabled(isSpinning)
                    .padding(.horizontal, horizontalPadding)
                    .padding(.bottom, 34)
                }

                if showResultPopup {
                    resultPopup
                }
            }
        }
    }

    // MARK: - Header

    private var headerView: some View {
        VStack(alignment: .leading, spacing: 28) {
            HStack(spacing: 18) {
                Button {
                    // сюда можно добавить dismiss / back action
                } label: {
                    Image(systemName: "arrow.left")
                        .font(.system(size: 28, weight: .medium))
                        .foregroundColor(.white)
                        .frame(width: 64, height: 64)
                        .background(Color.white.opacity(0.10))
                        .clipShape(Circle())
                }

                Text("QUICK SNACKS")
                    .font(.system(size: 34, weight: .heavy))
                    .foregroundColor(Color(red: 0.30, green: 0.90, blue: 0.95))
                    .minimumScaleFactor(0.8)
            }

            Text("It's ideal when there's no time to cook.")
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(Color.white.opacity(0.82))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - UI

    private var backgroundView: some View {
        LinearGradient(
            colors: [
                Color(red: 0.02, green: 0.05, blue: 0.45),
                Color(red: 0.02, green: 0.35, blue: 0.65),
                Color(red: 0.05, green: 0.70, blue: 0.82)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }

    private var selectionFrame: some View {
        RoundedRectangle(cornerRadius: 18)
            .fill(Color.yellow.opacity(0.14))
            .frame(height: itemHeight)
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(Color.yellow, lineWidth: 4)
            )
            .shadow(color: .yellow.opacity(0.25), radius: 8)
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
                Text("Your Snack")
                    .font(.system(size: 28, weight: .heavy))
                    .foregroundColor(.white)

                VStack(spacing: 12) {
                    resultRow(title: "Base", value: selectedCombination.base)
                    resultRow(title: "Filling", value: selectedCombination.filling)
                    resultRow(title: "Sauce", value: selectedCombination.sauce)
                }

                Button {
                    showResultPopup = false
                } label: {
                    Text("OK")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(Color.yellow)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }
            }
            .padding(22)
            .frame(maxWidth: 340)
            .background(Color(red: 0.08, green: 0.12, blue: 0.24))
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(Color.white.opacity(0.12), lineWidth: 1)
            )
            .padding(.horizontal, 24)
        }
        .transition(.opacity)
    }

    private func resultRow(title: String, value: String) -> some View {
        VStack(spacing: 6) {
            Text(title.uppercased())
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(.white.opacity(0.65))

            Text(value)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(Color.white.opacity(0.06))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    // MARK: - Actions

    private func spin() {
        guard !isSpinning else { return }

        isSpinning = true
        showResultPopup = false
        finishedColumns = 0

        targetIndex = Int.random(in: 0..<combinations.count)
        spinToken += 1
    }

    private func handleColumnFinished() {
        finishedColumns += 1

        if finishedColumns == 3 {
            isSpinning = false

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                showResultPopup = true
            }
        }
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
            return [0.75, 0.70, 0.68, 0.35]
        case 1:
            return [0.55, 0.80, 0.60, 0.72, 0.35]
        default:
            return [0.82, 0.58, 0.74, 0.55, 0.35]
        }
    }
}

// MARK: - Scroll Column

struct QuickSnackScrollColumnView: View {
    let items: [String]
    let width: CGFloat
    let itemHeight: CGFloat
    let spinToken: Int
    let targetIndex: Int
    let pattern: [ScrollEdge]
    let durationSet: [Double]
    let onFinished: () -> Void

    private let repeatCount = 10
    private let middleCycle = 4

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
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.18),
                                Color.white.opacity(0.08)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )

                RoundedRectangle(cornerRadius: 28)
                    .stroke(Color.white.opacity(0.18), lineWidth: 2)

                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack(spacing: 0) {
                        Color.clear
                            .frame(height: itemHeight)

                        ForEach(Array(repeatedItems.enumerated()), id: \.offset) { index, item in
                            Text(item)
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.white.opacity(0.92))
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
                        colors: [Color.black.opacity(0.28), Color.clear],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: 44)

                    Spacer()

                    LinearGradient(
                        colors: [Color.clear, Color.black.opacity(0.28)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: 44)
                }
                .clipShape(RoundedRectangle(cornerRadius: 28))
                .allowsHitTesting(false)
            }
            .frame(width: width, height: itemHeight * 3.15)
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

// MARK: - Helpers

enum ScrollEdge {
    case top
    case bottom
}

struct ColumnTitleModifier: ViewModifier {
    let width: CGFloat

    func body(content: Content) -> some View {
        content
            .font(.system(size: 18, weight: .black))
            .foregroundColor(.yellow)
            .frame(width: width)
    }
}

// MARK: - Data

struct QuickSnackCombination: Identifiable {
    let id = UUID()
    let base: String
    let filling: String
    let sauce: String

    static let all: [QuickSnackCombination] = [
        .init(base: "Toast",           filling: "Avocado",        sauce: "Lemon Yogurt"),
        .init(base: "Lavash",          filling: "Hummus",         sauce: "Pesto Sauce"),
        .init(base: "Crispbread",      filling: "Cream Cheese",   sauce: "Salsa"),
        .init(base: "Oatmeal Cookie",  filling: "Peanut Butter",  sauce: "Chili Honey"),
        .init(base: "Rice Ball",       filling: "Tuna",           sauce: "Teriyaki"),
        .init(base: "Bagel",           filling: "Mozzarella",     sauce: "Balsamic"),
        .init(base: "Cheese Cracker",  filling: "Falafel",        sauce: "Tahini"),
        .init(base: "Granola Bar",     filling: "Chickpeas",      sauce: "Mustard Sauce"),
        .init(base: "Apple",           filling: "Peanut Butter",  sauce: "Cinnamon (Bonus)"),
        .init(base: "Cucumber",        filling: "Cream Cheese",   sauce: "Sour Cream with Dill"),
        .init(base: "Toast",           filling: "Ham",            sauce: "Spicy Ketchup"),
        .init(base: "Lavash",          filling: "Poached Egg",    sauce: "Pesto Sauce"),
        .init(base: "Crispbread",      filling: "Avocado",        sauce: "Salsa"),
        .init(base: "Oatmeal Cookie",  filling: "Cream Cheese",   sauce: "Honey"),
        .init(base: "Rice Ball",       filling: "Hummus",         sauce: "Lemon Yogurt"),
        .init(base: "Bagel",           filling: "Tuna",           sauce: "Teriyaki"),
        .init(base: "Cheese Cracker",  filling: "Mozzarella",     sauce: "Balsamic"),
        .init(base: "Granola Bar",     filling: "Chickpeas",      sauce: "Mustard Sauce"),
        .init(base: "Apple",           filling: "Peanut Butter",  sauce: "Tahini"),
        .init(base: "Cucumber",        filling: "Falafel",        sauce: "Sour Cream with Herbs")
    ]
}

// MARK: - Preview

struct QuickSnackScrollMachineView_Previews: PreviewProvider {
    static var previews: some View {
        QuickSnackScrollMachineView()
    }
}