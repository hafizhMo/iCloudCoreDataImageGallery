//
//  MyImage+Ext.swift
//  iCloudCoreDataImageGallery
//
//  Created by Hafizh Mo on 05/07/23.
//

import UIKit

extension MyImage {
  var nameView: String {
    name ?? ""
  }

  var imageID: String {
    id ?? ""
  }

  var uiImage: UIImage {
    if !imageID.isEmpty, let image = FileManager().retrieveImage(with: imageID) {
      return image
    } else {
      return UIImage(systemName: "photo")!
    }
  }

  var commentView: String {
    comment ?? ""
  }

  var receivedFromView: String {
    receivedFrom ?? ""
  }
}
