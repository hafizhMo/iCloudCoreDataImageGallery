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
  let moc = MyImagesContainer().persistentContainer.viewContext
  var body: some Scene {
    WindowGroup {
      ContentView()
        .environment(\.managedObjectContext, moc)
        .environmentObject(shareService)
        .onAppear {
          print("Document Directory", URL.documentsDirectory.path)
        }
        .onOpenURL { url in
          shareService.restore(url: url)
        }
    }
  }
}
