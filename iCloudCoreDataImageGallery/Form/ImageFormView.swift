//
//  ImageFormView.swift
//  iCloudCoreDataImageGallery
//
//  Created by Hafizh Mo on 05/07/23.
//

import SwiftUI
import PhotosUI

struct ImageFormView: View {
  @EnvironmentObject var shareService: ShareService
  @ObservedObject var viewModel: FormViewModel
  @StateObject var imagePicker = ImagePicker()
  @FetchRequest(sortDescriptors: [])
  private var myImages: FetchedResults<MyImage>
  @Environment(\.managedObjectContext) var moc
  @Environment(\.dismiss) var dismiss
  @State private var share = false
  @State private var name = ""
  @State private var sendMail = false
  @State private var email = EmailForm()

  var body: some View {
    NavigationStack {
      VStack {
        Image(uiImage: viewModel.uiImage)
          .resizable()
          .scaledToFit()
        TextField("Image Name", text: $viewModel.name)
        TextField("Comment", text: $viewModel.comment, axis: .vertical)

        HStack {
          Text("Date Taken")
          Spacer()
          if viewModel.dateHidden {
            Text("No Date")
            Button("Set Date") {
              viewModel.date = Date()
            }
          } else {
            HStack {
              DatePicker("", selection: $viewModel.date, in: ...Date(), displayedComponents: .date)
              Button("Clear date") {
                viewModel.date = Date.distantPast
              }
            }
          }
        }
        .padding()
        .buttonStyle(.bordered)

        if !viewModel.receivedFrom.isEmpty {
          Text("**Received From**: \(viewModel.receivedFrom)")
        }

        HStack {
          if viewModel.updating {
            PhotosPicker("Change Image", selection: $imagePicker.imageSelection, matching: .images, photoLibrary: .shared())
              .buttonStyle(.bordered)
          }
          Button {
            if viewModel.updating {
              updateImage()
            } else {
              let newImage = MyImage(context: moc)
              newImage.id = UUID().uuidString
              newImage.name = viewModel.name
              newImage.comment = viewModel.comment
              newImage.dateTaken = viewModel.date
              try? moc.save()
              FileManager().saveImage(with: newImage.imageID, image: viewModel.uiImage)
            }
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
      .textFieldStyle(.roundedBorder)
      .disabled(!viewModel.receivedFrom.isEmpty)
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
            HStack {
              Button {
                if let selectedImage = myImages.first(where: { $0.id == viewModel.id }) {
                  FileManager().deleteImage(with: selectedImage.imageID)
                  moc.delete(selectedImage)
                  try? moc.save()
                }
                dismiss()
              } label: {
                Image(systemName: "trash")
              }
              .buttonStyle(.borderedProminent)
              .tint(.red)

              Button {
                updateImage()
                share.toggle()
              } label: {
                Image(systemName: "square.and.arrow.up")
              }
            }
          }
        }
      }
      .onChange(of: imagePicker.uiImage) { newImage in
        if let newImage {
          viewModel.uiImage = newImage
        }
      }
      .alert("Your Name", isPresented: $share) {
        TextField("Your Name", text: $name)
        Button("OK") {
          if let id = viewModel.id {
            viewModel.receivedFrom = viewModel.receivedFrom.isEmpty ? name : viewModel.receivedFrom + " -> " + name
            let codableImage = CodableImage(comment: viewModel.comment, dateTaken: viewModel.date, id: id, name: viewModel.name, receivedFrom: viewModel.receivedFrom)
            shareService.saveMyImage(codableImage)
            email.messageHeader = "Sent from the My Images CD app"
            email.fileName = "\(id).\(ShareService.ext)"
            email.mimeType = "application/zip"
            let attachmentURL = URL.documentsDirectory.appending(path: email.fileName)
            if let data = try? Data(contentsOf: attachmentURL) {
              email.data = data
            }
            if MailView.canSendMail {
              sendMail.toggle()
            } else {
              print("This device does not support email")
              dismiss()
            }
            try? FileManager().removeItem(at: attachmentURL)
          }
        }
        Button("Cancel", role: .cancel) {}
      } message: {
        Text("Please enter your name.")
      }
      .sheet(isPresented: $sendMail) {
        MailView(mailForm: $email) { result in
          switch result {
          case .success:
            print("Email sent")
          case .failure(let error):
            print(error.localizedDescription)
          }
          dismiss()
        }
      }
    }
  }

  func updateImage() {
    if let id = viewModel.id,
       let selectedImage = myImages.first(where: {$0.id == id}) {
      selectedImage.name = viewModel.name
      selectedImage.comment = viewModel.comment
      selectedImage.dateTaken = viewModel.date
      FileManager().saveImage(with: id, image: viewModel.uiImage)
      if moc.hasChanges {
        try? moc.save()
      }
    }
  }

}

struct ImageFormView_Previews: PreviewProvider {
  static var previews: some View {
    ImageFormView(viewModel: FormViewModel(UIImage(systemName: "photo")!))
  }
}
