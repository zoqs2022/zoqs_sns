//
//  ProfileView.swift
//  zoqs_sns
//
//  Created by 島田将太郎 on 2023/02/08.
//

import SwiftUI

struct ProfileView: View {
    var accountId: String
    @StateObject var profileViewModel = ProfileViewModel(model: ProfileModel())
    @State private var toUserList = false
    
    var body: some View {
        ScrollView{
            VStack{
                HStack(){
                    // 丸い写真のやつ
                    PhotoCircleView(image: profileViewModel.uiImageData, diameter: 80)
                    VStack(){
                        HStack{
                            Text(profileViewModel.name).bold()
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
                            VStack{
                                Text("100").bold()
                                Text("フォロー中").font(.system(size: 12))
                            }
                            Spacer()
                            VStack{
                                Text("100").bold()
                                Text("フォロワー").font(.system(size: 12))
                            }
                        }.padding(.leading, 40)
                    }.frame(height: 80)
                }.frame(maxWidth: .infinity, alignment: .leading).padding(24)
                
            }
            .sheet(isPresented: $toUserList) {
//                EditProfileView(userViewModel: userViewModel)
            }
        }
    }
}

//struct ProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileView()
//    }
//}
