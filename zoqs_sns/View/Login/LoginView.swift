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
    @FocusState private var focusedField: Field?
    
    let auth = AuthViewModel()
    @State private var emailFeild = ""
    @State private var passwordFeild = ""
    @State private var isAlert = false
    @State private var errorMessage = ""
    @State private var toCreateAccount = false
    @State var loading = false
    
    enum Field: Hashable {
        case email
        case password
    }
    
    var body: some View {
        VStack {
            ZStack(alignment: .center){
                VStack{
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
                    Spacer().frame(height: 240)
                }
                .frame(width: UIScreen.main.bounds.width,
                       height: UIScreen.main.bounds.height)
                .contentShape(RoundedRectangle(cornerRadius: 10))
                .onTapGesture {
                    focusedField = nil
                }
                
                VStack{
                    Spacer().frame(height: 0)
                    HStack(alignment: .center, spacing: 0){
                        Button(action: {
                            if loading {return}
                            loading = true
                            auth.login(emailFeild, passwordFeild, result: { success in
                                if success {
                                    self.isActive = true
                                } else {
                                    errorMessage = "メールアドレス、またはパスワードが間違っています。"
                                    isAlert = true
                                }
                                loading = false
                            })
                        }, label: {
                            VStack{
                                if loading {
                                    LoadingView()
                                        .padding(.horizontal, 8)
                                } else {
                                    Text("ログイン")
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
                    Button("アカウントを新規作成"){
                        toCreateAccount = true
                    }
                    .foregroundColor(.cyan)
                    .padding(.top, 10)
                }
                .frame(alignment: .bottom)
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
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

struct LoginView_Previews: PreviewProvider {
    @State static var dispState = true
    static var previews: some View {
        LoginView(isActive: $dispState)
    }
}
