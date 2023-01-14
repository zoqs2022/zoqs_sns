//
//  CreateAccountView.swift
//  zoqs_sns
//
//  Created by 島田将太郎 on 2023/01/14.
//

import UIKit
import SwiftUI

struct CreateAccountView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State private var nameFeild = ""
    @State private var emailFeild = ""
    @State private var passwordFeild = ""
    @State private var isAlert = false
    @State private var errorMessage = ""
    
    @State private var image: UIImage?
    @State var showingImagePicker = false
    
    var body: some View {
        VStack{
            VStack {
                if let uiImage = image {
                    Image(uiImage: uiImage)
                        .resizable()
                        .frame(width: 200, height: 200)
                        .clipShape(Circle())
                } else {
                    Image(systemName: "person.fill")
//                        .font(.system(size: 200))
                        .resizable()
                        .frame(width: 200, height: 200)
                        .clipShape(Circle())
                }
                Spacer().frame(height: 32)
                Button(action: {
                    showingImagePicker = true
                }) {
                    Text("フォトライブラリから選択")
                }
            }
            .frame(height: 300)
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(sourceType: .photoLibrary, selectedImage: $image)
            }
            
            Form{
                Section(){
                    TextField("ユーザーネーム", text: $nameFeild)
                        .autocapitalization(.none)
                }
                Section(){
                    TextField("e-mail", text: $emailFeild)
                        .autocapitalization(.none)
                }
                Section(){
                    TextField("password", text: $passwordFeild)
                        .autocapitalization(.none)
                }
            }.frame(height: 270)
            
            VStack{
                Button("登録"){
                    if nameFeild.count < 3 || nameFeild.count > 11 {
                        errorMessage = "名前は3字以上10字以内で設定してください。"
                        isAlert = true
                        return
                    }
                    AuthHelper().createAccount(email: emailFeild, password: passwordFeild, result: {
                        success in
                        if success {
                            DatabaseHelper().resisterUserInfo(name: self.nameFeild, image: self.image,result: {result in
                                print(result)
                                errorMessage = "画像登録に失敗しました"
                                isAlert = true
                            })
                            presentationMode.wrappedValue.dismiss()
                        } else {
                            errorMessage = "有効なメールアドレス、6文字以上のパスワードを設定してください。"
                            isAlert = true
                        }
                    })
                }.padding(20)
                Button("ログイン画面に戻る"){
                    presentationMode.wrappedValue.dismiss()
                }
            }

        }
        .alert(isPresented: $isAlert){
            Alert(title: Text("エラー"),message: Text(errorMessage))
        }
    }
}


struct ImagePicker: UIViewControllerRepresentable {
    
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    @Binding var selectedImage: UIImage?
    @Environment(\.presentationMode) private var presentationMode
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.sourceType = sourceType
        imagePicker.delegate = context.coordinator
        
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        var parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}


struct CreateAccountView_Previews: PreviewProvider {
    static var previews: some View {
        CreateAccountView()
    }
}
