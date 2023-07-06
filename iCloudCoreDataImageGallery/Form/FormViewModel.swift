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
  @Published var comment = ""
  @Published var date = Date.distantPast
  @Published var receivedFrom = ""

  var dateHidden: Bool {
    date == Date.distantPast
  }

  var id: String?

  var updating: Bool { id != nil }

  init(_ uiImage: UIImage) {
    self.uiImage = uiImage
  }

  init(_ myImage: MyImage) {
    name = myImage.nameView
    id = myImage.imageID
    uiImage = myImage.uiImage
    comment = myImage.commentView
    date = myImage.dateTaken ?? Date.distantPast
    receivedFrom = myImage.receivedFromView
  }

  var incomplete: Bool {
    name.isEmpty || uiImage == UIImage(systemName: "photo")!
  }
}
