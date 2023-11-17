import Authentication
import CoreUI
import SwiftUI

public struct AppView: View {
    public init() {}

    public var body: some View {
//        TabView {
//            VStack {
//                Image(systemName: "globe")
//                    .imageScale(.large)
//                    .foregroundColor(.accentColor)
//                Text("Hello, Home!")
//            }
//                .padding()
//                .tabItem {
//                    Label("Home", systemImage: "house")
//                }
//
//            VStack {
//                Image(systemName: "globe")
//                    .imageScale(.large)
//                    .foregroundColor(.accentColor)
//                Text("Hello, Settings!")
//            }
//                .padding()
//                .tabItem {
//                    Label("Settings", systemImage: "gear")
//                }
//        }
        LoginPage()
    }
}
