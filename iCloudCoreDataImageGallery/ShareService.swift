//
//  ShareService.swift
//  iCloudCoreDataImageGallery
//
//  Created by Hafizh Mo on 06/07/23.
//

import Foundation

struct CodableImage: Codable, Equatable {
  let comment: String
  let dateTaken: Date
  let id: String
  let name: String
  let receivedFrom: String
}

class ShareService: ObservableObject {
  static let ext = "myimg"
  func saveMyImage(_ codableImage: CodableImage) {
    let filename = "\(codableImage.id).\(Self.ext)"
    do {
      let data = try JSONEncoder().encode(codableImage)
      let jsonString = String(decoding: data, as: UTF8.self)
      FileManager().saveJSON(jsonString, fileName: filename)
    } catch {
      print("Could not encode data")
    }
  }
}
