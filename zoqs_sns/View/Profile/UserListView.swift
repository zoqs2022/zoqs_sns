//
//  UserListView.swift
//  zoqs_sns
//
//  Created by 島田将太郎 on 2023/02/08.
//

import SwiftUI

struct followSwich {
    var bool: Bool
    
    func text() -> String{
        return bool ? "フォローする" : "フォローを外す"
    }
    func fontColor() -> Color{
        return bool ? .white : .black
    }
    func backGroundColor() -> Color{
        return bool ? .blue : .gray
    }
}


struct UserListView: View {
    let userList: [UserListData]
    @ObservedObject var myDataViewModel: MyDataViewModel
    @ObservedObject var router: RouterNavigationPath
    
    var body: some View {
        VStack{
            List {
                ForEach(Array(userList.enumerated()), id: \.offset) { (index: Int, user: UserListData) in
                    if user.id == myDataViewModel.uid {
                        HStack{
                            HStack(alignment: .top) {
                                PhotoCircleView(image: user.image, diameter: 40)
                                VStack(alignment: .leading) {
                                    Text("\(user.name)")
                                        .fontWeight(.bold)
                                    Spacer().frame(height: 4)
                                    Text("\(user.name)")
                                        .font(.system(size: 12))
                                }
                            }
                            .padding(.horizontal, 0)
                            Spacer()
                        }
                    } else {
                        NavigationLink(value: Route.basicProfile(BasicProfile(id:user.id, name: user.name, image: user.image))) {
                            HStack{
                                HStack(alignment: .top) {
                                    PhotoCircleView(image: user.image, diameter: 40)
                                    VStack(alignment: .leading) {
                                        Text("\(user.name)")
                                            .fontWeight(.bold)
                                        Spacer().frame(height: 4)
                                        Text("\(user.name)")
                                            .font(.system(size: 12))
                                    }
                                }
                                .padding(.horizontal, 0)
                                Spacer()
                                
                                FollowButtonView(myDataViewModel: myDataViewModel, basicProfile: .init(id: user.id, name: user.name, image: user.image), fontSize: 12)
                                
                            }
                        }
                    }
                }
            }
        }
    }
}

//struct UserListView_Previews: PreviewProvider {
//    static var previews: some View {
//        UserListView(userList: [.init(id: "0HRpCbTuBTW2e3UQ0OTqH6sZe1V2", name: "takumi")], myDataViewModel: MyDataViewModel(model: MyDataModel()))
//    }
//}
