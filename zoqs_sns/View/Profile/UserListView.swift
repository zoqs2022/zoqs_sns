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
    
    @State private var loadings: [Bool]
    @State private var isAlert = false
    @State private var errorMessage = ""
    
    init(userList: [UserListData], myDataViewModel: MyDataViewModel) {
        self.userList = userList
        self.myDataViewModel = myDataViewModel
        self.loadings = Array(repeating : false, count : userList.count)
    }
    
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
                                VStack{
                                    Group{
                                        if loadings[index] {
                                            LoadingView()
                                                .padding(.horizontal, 16)
                                        } else {
                                            Text(followSwich(bool: !myDataViewModel.model.follows.contains(user.id)).text())
                                                .font(.system(size: 12))
                                                .foregroundColor(.white)
                                                .padding(4)
                                                .bold()
                                                .background(followSwich(bool: !myDataViewModel.model.follows.contains(user.id)).backGroundColor())
                                                .cornerRadius(8)
                                        }
                                    }
                                }
                                .onTapGesture {
                                    if loadings[index] {return}
                                    if !myDataViewModel.model.follows.contains(user.id) {
                                        Task {
                                            loadings[index] = true
                                            let res = await myDataViewModel.followUser(id: user.id, name: user.name, image: user.image)
                                            if let error = res {
                                                errorMessage = error
                                                isAlert = true
                                            }
                                            loadings[index] = false
                                        }
                                    } else {
                                        Task {
                                            loadings[index] = true
                                            let res = await myDataViewModel.unfollowUser(id: user.id)
                                            if let error = res {
                                                errorMessage = error
                                                isAlert = true
                                            } 
                                            loadings[index] = false
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        .alert(isPresented: $isAlert){
            Alert(title: Text("エラー"),message: Text(errorMessage))
        }
    }
}

struct UserListView_Previews: PreviewProvider {
    static var previews: some View {
        UserListView(userList: [.init(id: "0HRpCbTuBTW2e3UQ0OTqH6sZe1V2", name: "takumi")], myDataViewModel: MyDataViewModel(model: MyDataModel()))
    }
}
