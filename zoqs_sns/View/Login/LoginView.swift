//
//  LoginView.swift
//  zoqs_sns
//
//  Created by 島田将太郎 on 2023/01/14.
//

import SwiftUI

struct LoginView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State private var emailFeild = ""
    @State private var passwordFeild = ""
    @State private var isAlert = false
    @State private var errorMessage = ""
    @State private var toCreateAccount = false
    
    var body: some View {
        ZStack{
            Form{
                Section(){
                    TextField("e-mail", text: $emailFeild)
                        .autocapitalization(.none)
                }
                Section(){
                    TextField("password", text: $passwordFeild)
                        .autocapitalization(.none)
                }
            }
            VStack{
                Button("ログイン"){
                    AuthHelper().login(email: emailFeild, password: passwordFeild, result: {
                        success in
                        if success {
                            print("ログイン成功")
                            presentationMode.wrappedValue.dismiss()
                        } else {
                            errorMessage = "メールアドレス、またはパスワードが間違っています。"
                            isAlert = true
                        }
                    })
                }.padding(40)
                Button("アカウントを新規作成"){
                    toCreateAccount = true
                }
            }

        }
        .onAppear{
            if AuthHelper().uid() != "" {
                presentationMode.wrappedValue.dismiss()
            }
        }
        .alert(isPresented: $isAlert){
            Alert(title: Text("エラー"),message: Text(errorMessage))
        }
        .fullScreenCover(isPresented: $toCreateAccount) {
            CreateAccountView()
            .onDisappear {
                if AuthHelper().uid() != "" {
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
    
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}