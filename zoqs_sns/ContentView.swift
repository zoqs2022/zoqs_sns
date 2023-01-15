//
//  ContentView.swift
//  zoqs_sns
//
//  Created by 島田将太郎 on 2022/12/17.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var userData = UserData()
    
    @State var dataHelper:DatabaseHelper!
    @State private var isNotUserActive = false
    
    var body: some View {
//        if isNotUserActive {
//            LoginView()
//        } else
        VStack
        {
//            NavigationLink(
//                destination: LoginView(),
//                isActive: $isActive,
//                label: {
//                    EmptyView()
//                }
//            )
            TabView{
                SNS().tabItem{
                    Image(systemName: "message")
                    Text("閲覧")
                }
                NIKKI().tabItem{
                    Image(systemName: "pencil")
                    Text("投稿")
                }
                DAYS().tabItem{
                    Image(systemName: "30.square.fill")
                    Text("カレンダー")
                }
                PHOTO(userData: userData).tabItem{
                    Image(systemName: "photo.fill")
                    Text("アルバム")
                }
                
            }
            
        }
        .fullScreenCover(isPresented: $isNotUserActive) {
            LoginView()
                .onDisappear {
                    let uid = AuthHelper().uid()
                    print("USER_ID: "+uid)
                    if uid == "" {
                        isNotUserActive = true
                        return
                    } else {
                        print("OK")
                        userData.uid = uid
                        DatabaseHelper().getUserData(userID: uid, result: { data in
                            if let data = data {
                                print(data)
                                userData.name = data["name"] as? String ?? "..."
                            } else {
                                print("error")
                            }
                        })
                    }
                }
        }
        .onAppear {
            let uid = AuthHelper().uid()
            print("USER_ID: "+uid)
            if uid == "" {
                isNotUserActive = true
                return
            } else {
                print("OK")
                userData.uid = uid
                DatabaseHelper().getUserData(userID: uid, result: { data in
                    if let data = data {
                        print(data)
                        userData.name = data["name"] as? String ?? "..."
                    } else {
                        print("error")
                    }
                })
            }
        }
        .onDisappear {
            print("ContentView 消えた！")
        }
        
        .toolbar{
            ToolbarItem(placement: .navigationBarTrailing, content: {
                Button("ログアウト"){
                    AuthHelper().signout()
                    isNotUserActive = true
                }
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
