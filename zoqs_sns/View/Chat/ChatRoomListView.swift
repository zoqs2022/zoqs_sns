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
                    NavigationLink(value: ChatRoute.roomIdAndProfile(.init(roomID: room.roomID, id: room.userID, name: room.userName, image: room.userImage))){
                        VStack{
                            HStack(alignment: .center) {
                                PhotoCircleView(image: room.userImage, diameter: 40)
                                VStack(alignment: .leading) {
                                    Text("\(room.userName)")
                                        .fontWeight(.bold)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

//struct ChatListView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChatRoomListView()
//    }
//}
