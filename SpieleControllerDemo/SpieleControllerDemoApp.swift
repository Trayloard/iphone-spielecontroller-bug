import SwiftUI

@main
struct SpieleControllerDemoApp: App {
    @StateObject private var mapper = ControllerInputMapper()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(mapper)
        }
    }
}
