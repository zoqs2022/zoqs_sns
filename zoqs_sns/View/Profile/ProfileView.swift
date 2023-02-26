//
//  ProfileView.swift
//  zoqs_sns
//
//  Created by 島田将太郎 on 2023/02/08.
//

import SwiftUI

struct ProfileView: View {
    var basicProfile: BasicProfile
    @ObservedObject var myDataViewModel: MyDataViewModel
    @StateObject var profileViewModel = ProfileViewModel(model: ProfileModel())
    @ObservedObject var router: RouterNavigationPath
    @State var loading = false
    
    var body: some View {
        ScrollView{
            VStack{
                HStack(){
                    // 丸い写真のやつ
                    PhotoCircleView(image: basicProfile.image, diameter: 80)
                    VStack(){
                        HStack{
                            Text(basicProfile.name).bold()
                            Spacer()
                            
                            FollowButtonView(myDataViewModel: myDataViewModel, basicProfile: basicProfile, fontSize: 16)
                            
                        }.padding(.leading, 24)
                        
                        Spacer()
                        
                        HStack{
                            VStack{
                                Text("10").bold()
                                Text("投稿").font(.system(size: 12))
                            }
                            Spacer()
                            NavigationLink(value: Route.userList(profileViewModel.model.followUserList)){
                                VStack {
                                    Text("\(profileViewModel.model.followUserList.count)").bold()
                                    Text("フォロー中").font(.system(size: 12))
                                }
                            }
                            Spacer()
                            NavigationLink(value: Route.userList(profileViewModel.model.followerUserList)){
                                VStack {
                                    Text("\(profileViewModel.model.followerUserList.count)").bold()
                                    Text("フォロワー").font(.system(size: 12))
                                }
                            }
                        }.padding(.leading, 40)
                    }.frame(height: 80)
                }.frame(maxWidth: .infinity, alignment: .leading).padding(24)
                VStack{
                    Button(action: {
                        if loading {return}
                        loading = true
                        let room = myDataViewModel.model.roomList.first(where: {$0.userID == profileViewModel.model.id})
                        if let room = room {
                            loading = false
                            router.toChatPage(roomIdAndProfile: .init(roomID: room.roomID, id: profileViewModel.model.id, name: profileViewModel.model.name, image: profileViewModel.model.image))
                        } else {
                            myDataViewModel.createChatRoom(id: profileViewModel.model.id, result: { id in
                                loading = false
                                if let id = id {
                                    router.toChatPage(roomIdAndProfile: .init(roomID: id, id: profileViewModel.model.id, name: profileViewModel.model.name, image: profileViewModel.model.image))
                                }
                            })
                        }
                    }, label: {
                        VStack{
                            if loading {
                                LoadingView()
                                    .padding(.horizontal, 8)
                            } else {
                                Text("メッセージを送る")
                                    .foregroundColor(.white)
                            }
                        }
                        .frame(height: 40)
                        .frame(maxWidth: .infinity)
                        .background(Color(.blue))
                    })
                }
                .cornerRadius(10)
                .padding(.horizontal, 20)
                .frame(maxWidth: .infinity)
            }
            .onAppear(){
                if(!profileViewModel.checkSameId(id: basicProfile.id)){
                    profileViewModel.convertUserId(id: basicProfile.id)
                    profileViewModel.getUserData()
                }
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(basicProfile: .init(id: "jpUqvLIs7RhT9WtIfx33knfbYym1", name: "fffff", image: nil), myDataViewModel: MyDataViewModel(model: MyDataModel()),router: RouterNavigationPath())
    }
}
