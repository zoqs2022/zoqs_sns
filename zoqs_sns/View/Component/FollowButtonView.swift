//
//  FollowButtonView.swift
//  zoqs_sns
//
//  Created by 島田将太郎 on 2023/02/21.
//

import SwiftUI

struct FollowButtonView: View {
    @ObservedObject var myDataViewModel: MyDataViewModel
    var basicProfile: BasicProfile
    var fontSize: CGFloat = 12
    
    @State var loading = false
    
    var body: some View {
        VStack{
            Group{
                if loading {
                    LoadingView()
                        .padding(.horizontal, 8)
                } else {
                    Text(followSwich(bool: !myDataViewModel.model.follows.contains(basicProfile.id)).text())
                        .font(.system(size: fontSize))
                        .foregroundColor(.white)
                        .padding(4)
                        .bold()
                        .background(followSwich(bool: !myDataViewModel.model.follows.contains(basicProfile.id)).backGroundColor())
                        .cornerRadius(8)
                }
            }
        }
        .onTapGesture {
            if loading {return}
            Task{
                loading = true
                if !myDataViewModel.model.follows.contains(basicProfile.id) {
                    await myDataViewModel.followUser(id: basicProfile.id, name: basicProfile.name, image: basicProfile.image)
                } else {
                    await myDataViewModel.unfollowUser(id: basicProfile.id)
                }
                loading = false
            }
        }
    }
}

//struct FollowButtonView_Previews: PreviewProvider {
//    static var previews: some View {
//        FollowButtonView()
//    }
//}
