//
//  FSOnboardingView.swift
//  Food Wow Slots
//
//

import SwiftUI

struct FSOnboardingView: View {
    var getStartBtnTapped: () -> ()
    @State var count = 0
    
    var onbIcon: Image {
        switch count {
        case 0:
            Image(.onboardingIcon1FS)
        case 1:
            Image(.onboardingIcon2FS)
        case 2:
            Image(.onboardingIcon3FS)
        default:
            Image(.onboardingIcon1FS)
        }
    }
    
    var onbTitle: String {
        switch count {
        case 0:
            "Spin Your Meals"
        case 1:
            "Quick Snacks in Seconds"
        case 2:
            "Save & Track"
        default:
            "Spin Your Meals"
        }
    }
    
    var onbSubtitle: String {
        switch count {
        case 0:
            "Turn food into a game"
        case 1:
            ""
        case 2:
            "Save your best combos"
        default:
            ""
        }
    }
    
    var onbDescription: String {
        switch count {
        case 0:
            "Spin to generate your perfect meal"
        case 1:
            "Hungry? Spin a snack in 5 seconds"
        case 2:
            "Track your food journey"
        default:
            ""
        }
    }
    
    var body: some View {
        VStack {
            
            onbIcon
                .resizable()
                .scaledToFit()
                .frame(height: count == 0 ? 160 : 280)
                .padding(.vertical, count == 0 ? 60 : 0)
            
            VStack(spacing: 16) {
                Text(onbTitle)
                    .font(.system(size: 36, weight: .black))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.white)
                
                if !onbSubtitle.isEmpty {
                    Text(onbSubtitle)
                        .font(.system(size: 20, weight: .regular))
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.btn3)
                }
                Text(onbDescription)
                    .font(.system(size: 16, weight: .regular))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.white.opacity(0.7))
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 8)
                
            }
            .foregroundStyle(.white)
            .padding(.horizontal, 32)
            
            VStack {
                
                HStack {
                    if count == 0 {
                        Rectangle()
                            .fill(Gradients.color3Btn.linear)
                            .frame(width: 32, height: 10)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                    } else {
                        Circle()
                            .fill(.white.opacity(0.2))
                            .frame(width: 10, height: 10)
                    }
                    
                    
                    if count == 1 {
                        Rectangle()
                            .fill(Gradients.color3Btn.linear)
                            .frame(width: 32, height: 10)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                    } else {
                        Circle()
                            .fill(.white.opacity(0.2))
                            .frame(width: 10, height: 10)
                    }
                    
                    if count == 2 {
                        Rectangle()
                            .fill(Gradients.color3Btn.linear)
                            .frame(width: 32, height: 10)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                    } else {
                        Circle()
                            .fill(.white.opacity(0.2))
                            .frame(width: 10, height: 10)
                    }
                }
                
                HStack(spacing: 16) {
                    
                    if count != 2 {
                        Button {
                            getStartBtnTapped()
                        } label: {
                            Text("Skip")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundStyle(.white)
                        }
                        .buttonStyle(.plain)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.vertical, 16)
                        .background(.white.opacity(0.2))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                    
                    Button {
                        if count < 2 {
                            count += 1
                            
                        } else {
                            getStartBtnTapped()
                        }
                    } label: {
                        Text(count < 2 ? "Next" : "Get Started")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Gradients.color3Btn.linear)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                }
                .padding(.horizontal, 32)
            }.padding(.bottom, 30)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .background(
            Image(.appBgFS)
                .resizable()
                .ignoresSafeArea()
        )
    }
    
    
    private func additionalInfoCell<Content: View>(
        text: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        HStack(alignment: .center, spacing: 8) {
            content()
            
            Text(text)
                .font(.system(size: 14, weight: .regular))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
}

#Preview {
    FSOnboardingView(getStartBtnTapped: {})
}
