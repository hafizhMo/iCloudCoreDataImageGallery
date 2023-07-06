//
//  MyImagesContainer.swift
//  iCloudCoreDataImageGallery
//
//  Created by Hafizh Mo on 05/07/23.
//

import Foundation
import CoreData

class MyImagesContainer {
  let persistentContainer: NSPersistentContainer

  init() {
    persistentContainer = NSPersistentContainer(name: "ImageGalleryDataModel")
    guard let path = persistentContainer
      .persistentStoreDescriptions
      .first?
      .url?
      .path else {
      fatalError("Could not find peresistent container")
    }
    print("Core Data", path)
    persistentContainer.loadPersistentStores { _, error in
      if let error {
        print(error.localizedDescription)
      }
    }
  }
}
