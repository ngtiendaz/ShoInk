import SwiftUI

@main
struct ShoInkApp: App {

    init() {
        FontRegistrar.registerAll()
    }
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}
