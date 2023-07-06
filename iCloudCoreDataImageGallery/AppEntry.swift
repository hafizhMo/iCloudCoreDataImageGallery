//
//  iCloudCoreDataImageGalleryApp.swift
//  iCloudCoreDataImageGallery
//
//  Created by Hafizh Mo on 05/07/23.
//

import SwiftUI

@main
struct AppEntry: App {
  @StateObject var shareService = ShareService()
  var body: some Scene {
    WindowGroup {
      ContentView()
        .environment(\.managedObjectContext, MyImagesContainer().persistentContainer.viewContext)
        .environmentObject(shareService)
        .onAppear {
          print("Document Directory", URL.documentsDirectory.path)
        }
    }
  }
}
