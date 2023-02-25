//
//  ChatView.swift
//  zoqs_sns
//
//  Created by 島田将太郎 on 2023/02/25.
//

import SwiftUI

struct ChatRoomListView: View {
    @ObservedObject var myDataViewModel: MyDataViewModel
    
    var body: some View {
        VStack{
            List {
                ForEach(Array(myDataViewModel.model.roomList.enumerated()), id: \.offset) { (index: Int, room: ChatRoom) in
                    NavigationLink(value: ChatRoute.basicProfile(.init(id: room.userID, name: room.userName, image: room.userImage))){
                        VStack {
                            Text(room.userName)
                        }
                    }
                }
            }
        }
        .onAppear(){
            print("TTTTT", myDataViewModel.model.roomList)
        }
    }
}

//struct ChatListView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChatRoomListView()
//    }
//}
