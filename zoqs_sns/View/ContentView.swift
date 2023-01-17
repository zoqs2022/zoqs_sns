//
//　一番最初に出てくる画面
//
//
//  Created by 島田将太郎 on 2022/12/17.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var userData = UserDataViewModel(model: UserDataModel())
    @Binding var isActive: Bool
    
//    init() {
//        self.userData = UserDataViewModel(model: UserDataModel())
//    }
    
    var body: some View {
        VStack{
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
        .onAppear {
            print("USER_ID: "+userData.uid)
            userData.getUserName()
            userData.getUserImageData()
        }
        .toolbar{
            ToolbarItem(placement: .navigationBarTrailing, content: {
                Button("ログアウト"){
                    AuthHelper().signout()
                    isActive = false
                }
            })
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
