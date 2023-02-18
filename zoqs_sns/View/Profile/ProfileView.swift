//
//  ProfileView.swift
//  zoqs_sns
//
//  Created by 島田将太郎 on 2023/02/08.
//

import SwiftUI

struct ProfileView: View {
    var basicProfile: BasicProfile
    
    @StateObject var profileViewModel = ProfileViewModel(model: ProfileModel())
    @State private var toUserList = false
    
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
                            HStack(alignment: .center, spacing: 0){
                            }
                            .background(Color(.tertiaryLabel))
                            .cornerRadius(8)
                        }.padding(.leading, 24)
                        
                        Spacer()
                        
                        HStack{
                            VStack{
                                Text("10").bold()
                                Text("投稿").font(.system(size: 12))
                            }
                            Spacer()
                            NavigationLink(destination: UserListView(userList: profileViewModel.model.followUserList).onDisappear {
                                profileViewModel.selfInit()
                            }){
                                VStack {
                                    Text("\(profileViewModel.model.followUserList.count)").bold()
                                    Text("フォロー中").font(.system(size: 12))
                                }
                            }
                            Spacer()
                            NavigationLink(destination: UserListView(userList: profileViewModel.model.followUserList) ){
                                VStack {
                                    Text("100").bold()
                                    Text("フォロワー").font(.system(size: 12))
                                }
                            }
                        }.padding(.leading, 40)
                    }.frame(height: 80)
                }.frame(maxWidth: .infinity, alignment: .leading).padding(24)
            }
            .onAppear(){
                profileViewModel.convertUserId(id: basicProfile.id)
                profileViewModel.getUserData()
            }
        }
    }
}

//struct ProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileView()
//    }
//}
