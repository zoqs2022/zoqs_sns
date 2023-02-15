//
//  UserListView.swift
//  zoqs_sns
//
//  Created by 島田将太郎 on 2023/02/08.
//

import SwiftUI

struct UserListView: View {
    @Environment(\.dismiss) var dismiss
    let userList: [UserListData]
    
    var body: some View {
        VStack{
            List {
                ForEach(userList, id: \.id) { (user) in
                    NavigationLink(destination: ProfileView(userId: user.id, userName: user.name, userImage: user.image) ) {
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
            
            Button(action: {
                dismiss()
            }, label: {
                Text("戻るボタン")
            })
        }
    }
}

//struct UserListView_Previews: PreviewProvider {
//    static var previews: some View {
//        UserListView()
//    }
//}
