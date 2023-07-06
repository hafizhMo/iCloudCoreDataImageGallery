//
//  ImagePicker.swift
//  iCloudCoreDataImageGallery
//
//  Created by Hafizh Mo on 05/07/23.
//

import SwiftUI
import PhotosUI

@MainActor
class ImagePicker: ObservableObject {
  @Published var imageSelection: PhotosPickerItem?
  @Published var uiImage: UIImage?
  @Published var image: Image?

  func loadTransferable(from imageSelection: PhotosPickerItem?) async throws {
    do {
      if let data = try await imageSelection?.loadTransferable(type: Data.self) {
        if let uiImage = UIImage(data: data) {
          self.uiImage = uiImage
          self.image = Image(uiImage: uiImage)
        }
      }
    } catch {
      print(error.localizedDescription)
    }
  }
}
