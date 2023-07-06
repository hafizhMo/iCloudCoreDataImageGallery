//
//  ContentView.swift
//  iCloudCoreDataImageGallery
//
//  Created by Hafizh Mo on 05/07/23.
//

import SwiftUI
import PhotosUI

struct ContentView: View {
  @FetchRequest(sortDescriptors: [SortDescriptor(\.name)])
  private var myImages: FetchedResults<MyImage>
  @StateObject private var imagePicker = ImagePicker()

  var body: some View {
    NavigationStack {
      Group {
        if !myImages.isEmpty {
          // display grid of photos
        } else {
          Text("Select your first image!")
        }
      }
      .navigationTitle("Image Gallery")
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          PhotosPicker("New Image", selection: $imagePicker.imageSelection, matching: .images, photoLibrary: .shared())
            .buttonStyle(.borderedProminent)
        }
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
