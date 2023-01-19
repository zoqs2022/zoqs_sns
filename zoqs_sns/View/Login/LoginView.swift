//
//  LoginView.swift
//  zoqs_sns
//
//  Created by 島田将太郎 on 2023/01/14.
//

import SwiftUI

struct LoginView: View {
    @Binding var isActive: Bool
    @Environment(\.presentationMode) var presentationMode
    
    let auth = AuthViewModel()
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
                    auth.login(emailFeild, passwordFeild, result: { success in
                        if success {
                            self.isActive = true
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
                self.isActive = true
            }
        }
        .alert(isPresented: $isAlert){
            Alert(title: Text("エラー"),message: Text(errorMessage))
        }
        .fullScreenCover(isPresented: $toCreateAccount) {
            CreateAccountView(isActive: $isActive)
        }
    }
    
}

//struct LoginView_Previews: PreviewProvider {
//    static var previews: some View {
//        LoginView()
//    }
//}
