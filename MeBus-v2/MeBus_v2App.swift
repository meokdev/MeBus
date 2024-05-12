//
//  MeBus_v2App.swift
//  MeBus-v2
//
//  Created by ian cheng on 5/12/24.
//

import SwiftUI

@main
struct MeBus_v2App: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
