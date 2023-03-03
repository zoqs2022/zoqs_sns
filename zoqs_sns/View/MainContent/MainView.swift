//
//　一番最初に出てくる画面
//
//
//  Created by 島田将太郎 on 2022/12/17.
//

import SwiftUI

class TabSelectViewModel: ObservableObject {
    @Published var selectionType = "PHOTO"
}


struct MainView: View {
    @StateObject var router = RouterNavigationPath()
    @ObservedObject var myDataViewModel: MyDataViewModel
    
    @Binding var isActive: Bool
    @Binding var xOffset: CGFloat
    @Binding var defaultOffset: CGFloat
    
    @StateObject private var tabSelectViewModel = TabSelectViewModel()
    
    var body: some View {
        VStack{
            TabView(selection: $tabSelectViewModel.selectionType){
                NavigationStack(path: $router.path) {
                    MyDataView(myDataViewModel: myDataViewModel, router: router)
                        .navigationDestination(for: Route.self) { route in
                            switch route {
                            case let .userList(userList):
                                UserListView(userList: userList, myDataViewModel: myDataViewModel, router: router)
                            case let .basicProfile(basicProfile):
                                ProfileView(basicProfile: basicProfile, myDataViewModel: myDataViewModel, router: router)
                            case let .roomIdAndProfile(roomIdAndProfile):
                                ChatRowView(myDataViewModel: myDataViewModel, roomIdAndProfile: roomIdAndProfile)
                            }
                        }
                        .navigationBarTitle(Text("SNS"), displayMode: .inline)
                        .navigationBarItems(
                            trailing: Button("ログアウト"){
                                AuthHelper().signout()
                                isActive = false
                            }
                        )
                    //                        .onChange(of: router.path) {
                    //                            print("FFFFFFF",$0)
                    //                        }
                    // onTapGestureはこの位置でないとnavigationviewが正常に動作しない
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
                .tag("PHOTO")
                
                CalendarView(myDataViewModel: myDataViewModel)
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
                
                NavigationStack{
                    PostView(myDataViewModel: myDataViewModel)
                        .onTapGesture {
                            if self.xOffset == .zero {
                                self.xOffset = self.defaultOffset
                            } else {
                                self.xOffset = self.defaultOffset
                            }
                        }
                }
                .tabItem{
                    Image(systemName: "pencil")
                    Text("投稿")
                }
                .tag("NIKKI")
                
                NavigationStack{
                    HomeView(myDataViewModel: myDataViewModel)
                        .navigationDestination(for: ChatRoute.self) { route in
                            switch route {
                            case .roomList:
                                ChatRoomListView(myDataViewModel: myDataViewModel)
                            case let .roomIdAndProfile(roomIdAndProfile):
                                ChatRowView(myDataViewModel: myDataViewModel, roomIdAndProfile: roomIdAndProfile)
                            }
                        }
                        .navigationBarTitle(Text("SNS"), displayMode: .inline)
                        .navigationBarItems(
                            leading: VStack{
                                PhotoCircleView(image: myDataViewModel.model.image, diameter: 30)
                            },
                            trailing: NavigationLink(value: ChatRoute.roomList){
                                Image(systemName: "sparkles")
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
                    Image(systemName: "message")
                    Text("閲覧")
                }
                .tag("SNS")
                
            }
            .accentColor(.blue)
            
            .onReceive(tabSelectViewModel.$selectionType) { selection in
                if selection == "PHOTO" {
                    router.gotoHomePage()
                }
            }
        }
    }
}

