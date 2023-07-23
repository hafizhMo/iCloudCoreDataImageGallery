//
//  MyImagesContainer.swift
//  iCloudCoreDataImageGallery
//
//  Created by Hafizh Mo on 05/07/23.
//

import Foundation
import CoreData

class MyImagesContainer {
  let persistentCloudKitContainer: NSPersistentCloudKitContainer

  init() {
    UIImageTransformer.register()
    persistentCloudKitContainer = NSPersistentCloudKitContainer(name: "ImageGalleryDataModel")
    guard let path = persistentCloudKitContainer
      .persistentStoreDescriptions
      .first?
      .url?
      .path else {
      fatalError("Could not find peresistent container")
    }
    print("Core Data", path)
    guard let description = persistentCloudKitContainer.persistentStoreDescriptions.first else {
      fatalError("Failed to initialize persistent container")
    }
    description.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
    persistentCloudKitContainer.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    persistentCloudKitContainer.viewContext.automaticallyMergesChangesFromParent = true
    persistentCloudKitContainer.loadPersistentStores { _, error in
      if let error {
        print(error.localizedDescription)
      }
    }
  }
}
