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
                                    Text("\(myDataViewModel.model.chats[room.roomID]?.last?.text ?? "")")
                                        .font(.system(size: 16))
                                        .lineLimit(1)
                                }
                                Spacer()
                                VStack(alignment: .trailing) {
                                    if let date = myDataViewModel.model.chats[room.roomID]?.last?.date  {
                                        timestamp(date: date)
                                            .multilineTextAlignment(.trailing)
                                    }
                                }
                                .frame(alignment: .trailing)
                            }
                        }
                    }
                }
            }
        }
    }
}

private func timestamp(date: Date) -> some View {
    Text(
        """
        \(date.DateToString(format: "MM/dd"))
        \(date.DateToString(format: "HH:mm"))
        """
    )
    .font(.caption)
    .foregroundColor(Color.gray)
}

//struct ChatListView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChatRoomListView()
//    }
//}
