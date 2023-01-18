//
//  CreateAccountView.swift
//  zoqs_sns
//
//  Created by 島田将太郎 on 2023/01/14.
//

import UIKit
import SwiftUI

struct CreateAccountView: View {
    @Binding var isActive: Bool
    @Environment(\.presentationMode) var presentationMode
    
    let auth = AuthViewModel()
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
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                } else {
                    Image(systemName: "person.fill")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                }
                Spacer().frame(height: 32)
                Button(action: {
                    showingImagePicker = true
                }) {
                    Text("フォトライブラリから選択")
                }
            }
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(sourceType: .photoLibrary, selectedImage: $image)
            }
            Spacer().frame(height: 32)
            
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
                    auth.createAccount(emailFeild, passwordFeild, nameFeild, image, errorResult: { error in
                        if error == nil {
                            self.isActive = true
                        } else {
                            errorMessage = error!
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


//struct CreateAccountView_Previews: PreviewProvider {
//    static var previews: some View {
//        CreateAccountView()
//    }
//}
