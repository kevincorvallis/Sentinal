import SwiftUI
import FirebaseCore

@main
struct TeachMeAIApp: App {
    // Register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    // State to track login status
    @State private var isLoggedIn = false
    
    // State to track if the user has seen the onboarding
    @State private var hasSeenOnboarding: Bool = UserDefaults.standard.bool(forKey: "hasSeenOnboarding")
    
    var body: some Scene {
        WindowGroup {
            if hasSeenOnboarding {
                if isLoggedIn {
                    ContentView()  // Show main content view if logged in
                } else {
                    LoginView(isLoggedIn: $isLoggedIn)  // Show login screen if not logged in
                }
            } else {
                // Show onboarding screen on first launch
                OnboardingView()
                    .onDisappear {
                        // After onboarding is complete, set the flag to true
                        UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
                    }
            }
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()  // Initialize Firebase
        return true
    }
}
