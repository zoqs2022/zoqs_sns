//
//  EditProfileView.swift
//  zoqs_sns
//
//  Created by 島田将太郎 on 2023/01/15.
//

import SwiftUI

struct EditProfileView: View {
    @ObservedObject var userData: UserDataViewModel
    
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
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                } else {
                    Image(systemName: "person.fill")
                        .resizable()
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                }
                Spacer().frame(height: 16)
                Button(action: {
                    showingImagePicker = true
                }) {
                    Text("フォトライブラリから選択").bold()
                }
            }
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(sourceType: .photoLibrary, selectedImage: $image)
            }
            
            VStack(alignment: .leading, spacing: 16){
                TextField("ユーザーネーム", text: $nameFeild).autocapitalization(.none)

            }.padding(.horizontal,40).padding(.vertical, 24)
            
            Spacer().frame(height: 16)
            
            VStack{
                HStack(alignment: .center, spacing: 0){
                    Button("変更"){
                        if nameFeild.count < 3 || nameFeild.count > 11 {
                            errorMessage = "名前は3字以上10字以内で設定してください。"
                            isAlert = true
                            return
                        }
                        userData.updataUserData(nameFeild, image, errorResult: { error in
                            if error != nil {
                                errorMessage = "画像登録に失敗しました"
                                isAlert = true
                            }
                            presentationMode.wrappedValue.dismiss()
                        })
                    }
                    .padding(10)
                    .font(.system(size: 20))
                    .foregroundColor(.black)
                }
                .background(Color(.tertiaryLabel))
                .cornerRadius(8)
                Spacer().frame(height: 16)
                Button("戻る"){
                    presentationMode.wrappedValue.dismiss()
                }.padding(10).foregroundColor(.black)
            }
        }
        .onAppear{
            nameFeild = userData.name
            image = userData.uiImageData
        }
        .alert(isPresented: $isAlert){
            Alert(title: Text("エラー"),message: Text(errorMessage))
        }
    }
}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView(userData: UserDataViewModel(model: UserDataModel()))
    }
}
