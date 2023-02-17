//
//　一番最初に出てくる画面
//
//
//  Created by 島田将太郎 on 2022/12/17.
//

import SwiftUI
import Combine

final class RouterNavigationPath: ObservableObject {
    @Published var path =  NavigationPath()
    
    func gotoHomePage() {
        path.removeLast(path.count)
    }
}

struct MainView: View {
    @StateObject var router = RouterNavigationPath()
    @ObservedObject var userViewModel: UserViewModel
    @StateObject var postViewModel = PostViewModel(model: [PostModel()])
    
    @Binding var isActive: Bool
    @Binding var xOffset: CGFloat
    @Binding var defaultOffset: CGFloat
    
    @State var selection = ""
    @StateObject private var viewModel = ViewModel()
    
    var body: some View {
        VStack{
            TabView(selection: $viewModel.selectionType){
                NavigationStack{
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
                                PhotoCircleView(image: userViewModel.model.image, diameter: 30)
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
                .tag("SNS")
                
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
                    .tag("NIKKI")
                
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
                    .tag("DAYS")
                
                NavigationStack(path: $router.path) {
                    PHOTO(userViewModel: userViewModel)
                        .environmentObject(router)
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
                        .onChange(of: router.path) {
                            print("FFFFFFF",$0)
                        }
                }
                .tabItem{
                    Image(systemName: "photo.fill")
                    Text("アルバム")
                }
                .tag("PHOTO")
            }
            .accentColor(.blue)
            .onReceive(viewModel.$selectionType) { selection in
                if selection == "PHOTO" {
                    router.gotoHomePage()
                }
            }
        }
        .onAppear() {
            self.postViewModel.getAllPostList()
        }
    }
}

class ViewModel: ObservableObject {
    @Published var selectionType = "SNS"
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
