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
    
    var body: some View {
        VStack{
            List {
                ForEach(userList, id: \.id) { (user) in
                    NavigationLink(value: Route.basicProfile(BasicProfile(id:user.id, name: user.name, image: user.image))) {
                        HStack{
                            HStack(alignment: .top) {
                                PhotoCircleView(image: user.image, diameter: 40)
                                VStack(alignment: .leading) {
                                    Text("\(user.name)")
                                        .fontWeight(.bold)
                                }
                            }
                            .padding(.horizontal, 0)
                            Text("\(user.name)")
                            Spacer()
                            VStack{
                                Text(followSwich(bool: !myDataViewModel.model.follows.contains(user.id)).text())
                                    .font(.system(size: 12))
                                    .foregroundColor(.white)
                                    .padding(4)
                                    .bold()
                                    .background(followSwich(bool: !myDataViewModel.model.follows.contains(user.id)).backGroundColor())
                                    .cornerRadius(8)
                                    .onTapGesture {
                                        if !myDataViewModel.model.follows.contains(user.id) {
                                            print("Hello world!") // これなら反応する!
                                        } else {
                                            print("Hello world!") // これなら反応する!
                                        }
                                    }
                                
                            }
                        }
                    }
                }
            }
        }
    }
}

struct UserListView_Previews: PreviewProvider {
    static var previews: some View {
        UserListView(userList: [.init(id: "0HRpCbTuBTW2e3UQ0OTqH6sZe1V2", name: "takumi")], myDataViewModel: MyDataViewModel(model: MyDataModel()))
    }
}
