//
//  fetch_exerciseApp.swift
//  fetch-exercise
//
//  Created by Jasmine Zhang on 3/20/24.
//

import SwiftUI

@main
struct fetch_exerciseApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
