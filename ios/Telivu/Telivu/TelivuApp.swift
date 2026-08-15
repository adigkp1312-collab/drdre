import SwiftUI

@main
struct TelivuApp: App {
    var body: some Scene {
        WindowGroup {
            TelivuHomeView()
                .preferredColorScheme(.light)
                .tint(TelivuColor.ink)
        }
    }
}
