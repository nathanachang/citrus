//
//  CitrusApp.swift
//  Citrus
//
//  Created by Nathan Chang on 3/4/25.
//

import SwiftUI

@main
struct CitrusApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            CitrusView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
