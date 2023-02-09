//
//　一番最初に出てくる画面
//
//
//  Created by 島田将太郎 on 2022/12/17.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var userViewModel: UserViewModel
    @StateObject var postViewModel = PostViewModel(model: [PostModel()])
    
    @Binding var isActive: Bool
    
    @Binding var xOffset: CGFloat
    @Binding var defaultOffset: CGFloat
    
//    init() {
//        self.userData = userViewModel(model: UserDataModel())
//    }
    
//    init(isActive: Binding<Bool>) {
//        self._isActive = isActive
//        // タイトルバーのフォントサイズを変更
//        UINavigationBar.appearance().titleTextAttributes = [.font: UIFont.systemFont(ofSize: 24)]
//    }
    
    var body: some View {
        VStack{
            TabView{
                NavigationView{
                    ScrollView (.vertical, showsIndicators: false) {
                        SNS(postViewModel: postViewModel)
                            .onTapGesture {
                                if self.xOffset == .zero {
                                    self.xOffset = self.defaultOffset
                                } else {
                                    self.xOffset = self.defaultOffset
                                }
                            }
                    }
                        .navigationBarTitle(Text("SNS"), displayMode: .inline)
                        .navigationBarItems(
                            leading: VStack{
                                PhotoCircleView(image: userViewModel.uiImageData, diameter: 30)
                            },
                            trailing: HStack{
                                Image(systemName: "sparkles")
                            }
                            .padding(.bottom, 10)
                        )
                }
                .tabItem{
                    Image(systemName: "message")
                    Text("閲覧")
                }
                
                NIKKI()
                    .onTapGesture {
                        if self.xOffset == .zero {
                            self.xOffset = self.defaultOffset
                        } else {
                            self.xOffset = self.defaultOffset
                        }
                    }
                    .tabItem{
                    Image(systemName: "pencil")
                    Text("投稿")
                    }
                
                DAYS()
                    .onTapGesture {
                        if self.xOffset == .zero {
                            self.xOffset = self.defaultOffset
                        } else {
                            self.xOffset = self.defaultOffset
                        }
                    }
                    .tabItem{
                    Image(systemName: "30.square.fill")
                    Text("カレンダー")
                    }
                
                NavigationView{
                    PHOTO(userViewModel: userViewModel)
                        .navigationBarTitle(Text("SNS"), displayMode: .inline)
                        .navigationBarItems(
                            trailing: Button("ログアウト"){
                                AuthHelper().signout()
                                isActive = false
                            }
                        )
                        .onTapGesture {
                            if self.xOffset == .zero {
                                self.xOffset = self.defaultOffset
                            } else {
                                self.xOffset = self.defaultOffset
                            }
                        }
                }
                .tabItem{
                    Image(systemName: "photo.fill")
                    Text("アルバム")
                }
            }
            .accentColor(.blue)
        }
        .onAppear() {
            self.postViewModel.getAllPostList()
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
