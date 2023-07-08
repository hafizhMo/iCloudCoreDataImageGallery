//
//  ContentView.swift
//  iCloudCoreDataImageGallery
//
//  Created by Hafizh Mo on 05/07/23.
//

import SwiftUI
import PhotosUI

struct ContentView: View {
  @EnvironmentObject var shareService: ShareService
  @Environment(\.managedObjectContext) var moc
  @FetchRequest(sortDescriptors: [SortDescriptor(\.name)])
  private var myImages: FetchedResults<MyImage>
  @StateObject private var imagePicker = ImagePicker()
  @State private var formType: FormType?
  @State private var imageExists = false
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
      .onChange(of: shareService.codeableImage) { codableImage in
        if let codableImage {
          if let myImage = myImages.first(where: {$0.id == codableImage.id}) {
            // This is an upate of an existing image
            updateImageInfo(myImage: myImage)
            imageExists.toggle()
          } else {
            // This is a new MyImage Item
            restoreMyImage()
          }
        }
      }
      .sheet(item: $formType) { $0 }
      .alert("Image Updated", isPresented: $imageExists) {
        Button("OK") {}
      }
    }
  }

  func restoreMyImage() {
    if let codableImage = shareService.codeableImage {
      let newImage = MyImage(context: moc)
      newImage.name = codableImage.name
      newImage.id = codableImage.id
      newImage.comment = codableImage.comment
      newImage.dateTaken = codableImage.dateTaken
      newImage.receivedFrom = codableImage.receivedFrom
      try? moc.save()
    }
    shareService.codeableImage = nil
  }

  func updateImageInfo(myImage: MyImage) {
    if let codableImage = shareService.codeableImage {
      myImage.name = codableImage.name
      myImage.id = codableImage.id
      myImage.comment = codableImage.comment
      myImage.dateTaken = codableImage.dateTaken
      myImage.receivedFrom = codableImage.receivedFrom
      try? moc.save()
    }
    shareService.codeableImage = nil
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
