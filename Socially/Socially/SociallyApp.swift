//
//  SociallyApp.swift
//  Socially
//
//  Created by Jungman Bae on 7/23/24.
//

import SwiftUI
import FirebaseCore
import FirebaseAnalytics

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}


@main
struct SociallyApp: App {
    @StateObject var authModel = AuthViewModel()
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            TabView {
                if authModel.user != nil {
                    FeedView()
                        .tabItem {
                            Image(systemName: "text.bubble")
                            Text("Feeds")
                        }
                }
                ProfileView()
                    .tabItem {
                        Image(systemName: "person.crop.circle")
                        Text("Account")
                    }
            }
            .environmentObject(authModel)
            .environmentObject(PostViewModel())
            .onAppear {
                Analytics.logEvent("launch_app", parameters: nil)
            }
        }
    }
}
