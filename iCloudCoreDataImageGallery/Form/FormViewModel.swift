//
//  FormViewModel.swift
//  iCloudCoreDataImageGallery
//
//  Created by Hafizh Mo on 05/07/23.
//

import UIKit

class FormViewModel: ObservableObject {
  @Published var name = ""
  @Published var uiImage: UIImage

  var id: String?

  var updating: Bool { id != nil }

  init(_ uiImage: UIImage) {
    self.uiImage = uiImage
  }

  init(_ myImage: MyImage) {
    name = myImage.nameView
    id = myImage.imageID
    uiImage = UIImage(systemName: "photo")!
  }

  var incomplete: Bool {
    name.isEmpty || uiImage == UIImage(systemName: "photo")!
  }
}
