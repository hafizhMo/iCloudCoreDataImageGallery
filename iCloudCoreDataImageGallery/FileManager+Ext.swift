//
//  FileManager+Ext.swift
//  iCloudCoreDataImageGallery
//
//  Created by Hafizh Mo on 06/07/23.
//

import UIKit

extension FileManager {

  func retrieveImage(with id: String) -> UIImage? {
    let url = URL.documentsDirectory.appendingPathComponent("\(id).jpg")
    do {
      let imageData = try Data(contentsOf: url)
      return UIImage(data: imageData)
    } catch {
      print(error.localizedDescription)
      return nil
    }
  }

  func saveImage(with id: String, image: UIImage) {
    if let data = image.jpegData(compressionQuality: 0.6) {
      do {
        let url = URL.documentsDirectory.appendingPathComponent("\(id).jpg")
        try data.write(to: url)
      } catch {
        print(error.localizedDescription)
      }
    } else {
      print("Couldn't save image")
    }
  }

  func deleteImage(with id: String) {
    let url = URL.documentsDirectory.appendingPathComponent("\(id).jpg")
    if fileExists(atPath: url.path) {
      do {
        try removeItem(at: url)
      } catch {
        print(error.localizedDescription)
      }
    } else {
      print("Image doesn't exist")
    }
  }

  func saveJSON(_ json: String, fileName: String) {
    let url = URL.documentsDirectory.appending(path: fileName)
    do {
      try json.write(to: url, atomically: false, encoding: .utf8)
    } catch {
      print("Could not save json")
    }
  }

  func decodeJSON(from url: URL) -> CodableImage? {
    do {
      let data = try Data(contentsOf: url)
      do {
        return try JSONDecoder().decode(CodableImage.self, from: data)
      } catch {
        print(error.localizedDescription)
        return nil
      }
    } catch {
      print(error.localizedDescription)
      return nil
    }
  }

  func moveFile(oldURL: URL, newURL: URL) {
    if fileExists(atPath: newURL.path) {
      try? removeItem(at: newURL)
    }
    do {
      try moveItem(at: oldURL, to: newURL)
    } catch {
      print(error.localizedDescription)
    }
  }
}
