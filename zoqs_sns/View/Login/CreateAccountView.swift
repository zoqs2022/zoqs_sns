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
    @FocusState private var focusedField: Field?
    
    let auth = AuthViewModel()
    @State private var nameFeild = ""
    @State private var emailFeild = ""
    @State private var passwordFeild = ""
    @State private var isAlert = false
    @State private var errorMessage = ""
    @State var loading = false
    
    @State private var image: UIImage?
    @State var showingImagePicker = false
    
    enum Field: Hashable {
        case userName
        case email
        case password
    }
    
    var body: some View {
        VStack {
            ZStack(alignment: .center){
                VStack{
                    TextField("ユーザーネーム", text: $nameFeild)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.cyan, lineWidth: 1.0)
                        )
                        .padding(.horizontal,20)
                        .padding(.vertical, 10)
                        .autocapitalization(.none)
                        .focused($focusedField, equals: .userName)
                        .onTapGesture {
                            focusedField = .userName
                        }
                    
                    TextField("e-mail", text: $emailFeild)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.cyan, lineWidth: 1.0)
                        )
                        .padding(.horizontal,20)
                        .padding(.vertical, 10)
                        .autocapitalization(.none)
                        .focused($focusedField, equals: .email)
                        .onTapGesture {
                            focusedField = .email
                        }
                    
                    TextField("password", text: $passwordFeild)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.cyan, lineWidth: 1.0)
                        )
                        .padding(.horizontal,20)
                        .padding(.vertical, 10)
                        .autocapitalization(.none)
                        .focused($focusedField, equals: .password)
                        .onTapGesture {
                            focusedField = .password
                        }
                }
                .frame(width: UIScreen.main.bounds.width,
                       height: UIScreen.main.bounds.height)
                .contentShape(RoundedRectangle(cornerRadius: 10))
                .onTapGesture {
                    focusedField = nil
                }
                
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
                            .foregroundColor(.cyan)
                    }
                    Spacer().frame(height: 400)
                }
                .frame(alignment: .top)
                .sheet(isPresented: $showingImagePicker) {
                    ImagePicker(sourceType: .photoLibrary, selectedImage: $image)
                }
                
                VStack{
                    Spacer().frame(height: 300)
                    HStack(alignment: .center, spacing: 0){
                        Button(action: {
                            if loading {return}
                            loading = true
                            if nameFeild.count < 3 || nameFeild.count > 11 {
                                errorMessage = "名前は3字以上10字以内で設定してください。"
                                isAlert = true
                                loading = false
                                return
                            }
                            auth.createAccount(emailFeild, passwordFeild, nameFeild, image, errorResult: { error in
                                if error == nil {
                                    loading = false
                                    self.isActive = true
                                } else {
                                    errorMessage = error!
                                    isAlert = true
                                    loading = false
                                }
                            })
                        }, label: {
                            VStack{
                                if loading {
                                    LoadingView()
                                        .padding(.horizontal, 8)
                                } else {
                                    Text("登録")
                                        .font(.system(size: 16))
                                        .foregroundColor(.white)
                                }
                            }
                            .frame(height: 40)
                            .frame(maxWidth: .infinity)
                            .background(Color(.cyan))
                            .cornerRadius(10)
                        })
                        .padding(.vertical,10)
                        .padding(.horizontal, 20)
                    }
                    Button("ログイン画面に戻る"){
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(.cyan)
                    .padding(.top, 10)
                }
                .frame(alignment: .bottom)
            }
            .alert(isPresented: $isAlert){
                Alert(title: Text("エラー"),message: Text(errorMessage))
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}


struct CreateAccountView_Previews: PreviewProvider {
    @State static var dispState = true
    static var previews: some View {
        CreateAccountView(isActive: $dispState)
    }
}
