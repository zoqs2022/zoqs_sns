//
//  UserListView.swift
//  zoqs_sns
//
//  Created by 島田将太郎 on 2023/02/08.
//

import SwiftUI

struct UserListView: View {
    let userList: [UserListData]
    
    var body: some View {
        VStack{
            List {
                ForEach(userList, id: \.id) { (user) in
                    NavigationLink(value: Route.basicProfile(BasicProfile(id:user.id, name: user.name, image: user.image))) {
                        HStack(alignment: .top) {
                            PhotoCircleView(image: user.image, diameter: 40)
                            VStack(alignment: .leading) {
                                Text("\(user.name)")
                                    .fontWeight(.bold)
                            }
                        }
                        .padding(.horizontal, 0)
                        Text("\(user.name)")
                    }
                }
            }
        }
    }
}

//struct UserListView_Previews: PreviewProvider {
//    static var previews: some View {
//        UserListView()
//    }
//}
