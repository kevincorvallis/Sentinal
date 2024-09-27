//
//  OnboardingView.swift
//  TeachMeAI
//
//  Created by Kevin Lee on 9/27/24.
//

import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0  // Track the current page

    let onboardingData = [
        OnboardingPage(title: "Welcome to TeachMeAI", imageName: "onboarding1", description: "Learn AI concepts effortlessly."),
        OnboardingPage(title: "AI-powered Assistance", imageName: "onboarding2", description: "Get personalized AI help."),
        OnboardingPage(title: "Explore Features", imageName: "onboarding3", description: "Dive into a world of AI-powered features."),
        OnboardingPage(title: "Start Your Journey", imageName: "onboarding4", description: "Join us and get started today!")
    ]

    var body: some View {
        VStack {
            // TabView to allow swiping between pages
            TabView(selection: $currentPage) {
                ForEach(0..<onboardingData.count, id: \.self) { index in
                    OnboardingPageView(page: onboardingData[index])
                        .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle())
            .indexViewStyle(PageIndexViewStyle())  // Shows dots at the bottom to indicate the current page

            // "Get Started" button
            Button(action: {
                // Action for the button (e.g., dismiss onboarding)
                print("Get Started tapped")
            }) {
                Text(currentPage == onboardingData.count - 1 ? "Get Started" : "Skip")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
                    .padding(.horizontal, 20)
            }
            .padding()
        }
    }
}

struct OnboardingPage {
    var title: String
    var imageName: String
    var description: String
}

struct OnboardingPageView: View {
    var page: OnboardingPage

    var body: some View {
        VStack {
            Image(page.imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 300)  // Adjust as needed for your design
                .padding()

            Text(page.title)
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(.top, 30)

            Text(page.description)
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
                .padding(.top, 10)
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
