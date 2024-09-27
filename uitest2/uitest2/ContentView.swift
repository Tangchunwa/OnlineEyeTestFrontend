import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            VisionTestView()
                .tabItem {
                    Label("Vision Test", systemImage: "eye")
                }
            
            MacularDegenerationTestView()
                .tabItem {
                    Label("Macular Test", systemImage: "eye.trianglebadge.exclamationmark")
                }
            
            ColorBlindnessTestView()
                .tabItem {
                    Label("Color Test", systemImage: "eyedropper.halffull")
                }
        }
    }
}
