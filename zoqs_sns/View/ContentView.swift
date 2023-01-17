//
//　一番最初に出てくる画面
//
//
//  Created by 島田将太郎 on 2022/12/17.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var userData = UserDataViewModel(model: UserDataModel())
    
    @State var dataHelper:DatabaseHelper!
    @State private var isNotUserActive = false
    
    var body: some View {
        VStack
        {
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
                    if userData.uid == "" {
                        isNotUserActive = true
                        return
                    } else {
                        print("USER_ID: "+userData.uid)
                        userData.getUserName()
                    }
                }
        }
        .onAppear {
            if userData.uid == "" {
                isNotUserActive = true
                return
            } else {
                print("USER_ID: "+userData.uid)
                userData.getUserName()
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
