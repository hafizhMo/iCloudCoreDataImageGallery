//
//  iCloudCoreDataImageGalleryApp.swift
//  iCloudCoreDataImageGallery
//
//  Created by Hafizh Mo on 05/07/23.
//

import SwiftUI

@main
struct AppEntry: App {
  var body: some Scene {
    WindowGroup {
      ContentView()
        .environment(\.managedObjectContext, MyImagesContainer().persistentContainer.viewContext)
    }
  }
}
