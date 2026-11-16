//
//  ShoInkApp.swift
//  ShoInk
//
//  Created by Daz on 16/11/26.
//

import SwiftUI
import CoreData

@main
struct ShoInkApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
