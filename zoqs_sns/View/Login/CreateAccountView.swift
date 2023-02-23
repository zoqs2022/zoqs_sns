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
    @State var loading = false
    
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
                HStack(alignment: .center, spacing: 0){
                    Button(action: {
                        if loading {return}
                        if nameFeild.count < 3 || nameFeild.count > 11 {
                            errorMessage = "名前は3字以上10字以内で設定してください。"
                            isAlert = true
                            return
                        }
                        auth.createAccount(emailFeild, passwordFeild, nameFeild, image, errorResult: { error in
                            if error == nil {
                                loading = false
                                self.isActive = true
                            } else {
                                errorMessage = error!
                                isAlert = true
                            }
                        })
                    }, label: {
                        Group{
                            if loading {
                                LoadingView()
                                    .padding(.horizontal, 8)
                            } else {
                                Text("登録")
                                    .font(.system(size: 16))
                                    .foregroundColor(.black)
                            }
                        }
                    })
                    .padding(.vertical,10)
                    .padding(.horizontal, 20)
                }
                .background(Color(.tertiaryLabel))
                .cornerRadius(8)
                .padding(20)
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
//    @State var isActive = false
//    static var previews: some View {
//        CreateAccountView(isActive: nil)
//    }
//}
