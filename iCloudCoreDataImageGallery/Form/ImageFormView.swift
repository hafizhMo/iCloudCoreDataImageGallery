//
//  ImageFormView.swift
//  iCloudCoreDataImageGallery
//
//  Created by Hafizh Mo on 05/07/23.
//

import SwiftUI
import PhotosUI

struct ImageFormView: View {
  @ObservedObject var viewModel: FormViewModel
  @StateObject var imagePicker = ImagePicker()
  @Environment(\.dismiss) var dismiss

  var body: some View {
    NavigationStack {
      VStack {
        Image(uiImage: viewModel.uiImage)
          .resizable()
          .scaledToFit()
        TextField("Image Name", text: $viewModel.name)

        HStack {
          if viewModel.updating {
            PhotosPicker("Change Image", selection: $imagePicker.imageSelection, matching: .images, photoLibrary: .shared())
              .buttonStyle(.borderedProminent)
          }
          Button {
            dismiss()
          } label: {
            Image(systemName: "checkmark")
          }
          .buttonStyle(.borderedProminent)
          .tint(.green)
          .disabled(viewModel.incomplete)
        }

        Spacer()
      }
      .padding()
      .navigationTitle(viewModel.updating ? "Update Image" : "New Image")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .navigationBarLeading) {
          Button("Cancel") {
            dismiss()
          }
          .buttonStyle(.bordered)
        }
        
        if viewModel.updating {
          ToolbarItem(placement: .navigationBarTrailing) {
            Button {
              
            } label: {
              Image(systemName: "trash")
            }
            .buttonStyle(.borderedProminent)
            .tint(.red)
          }
        }
      }
      .onChange(of: imagePicker.uiImage) { newImage in
        if let newImage {
          viewModel.uiImage = newImage
        }
      }
    }
  }

}

struct ImageFormView_Previews: PreviewProvider {
  static var previews: some View {
    ImageFormView(viewModel: FormViewModel(UIImage(systemName: "photo")!))
  }
}
