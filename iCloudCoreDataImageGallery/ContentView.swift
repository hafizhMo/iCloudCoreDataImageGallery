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
  @State private var formType: FormType?
  let columns = [GridItem(.adaptive(minimum: 100))]

  var body: some View {
    NavigationStack {
      Group {
        if !myImages.isEmpty {
          ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
              ForEach(myImages) { myImage in
                Button {
                  formType = .update(myImage)
                } label: {
                  VStack {
                    Image(uiImage: myImage.uiImage)
                      .resizable()
                      .scaledToFill()
                      .frame(width: 100, height: 100)
                      .clipped()
                      .shadow(radius: 5.0)
                    Text(myImage.nameView)
                  }
                }

              }
            }
            .padding()
          }
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
      .onChange(of: imagePicker.uiImage) { newImage in
        if let newImage {
          formType = .new(newImage)
        }
      }
      .sheet(item: $formType) { $0 }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
