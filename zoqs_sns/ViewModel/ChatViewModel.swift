//
//  ChatViewModel.swift
//  zoqs_sns
//
//  Created by 島田将太郎 on 2023/02/26.
//

import Foundation

final class ChatViewModel: ObservableObject {
    @Published var model: ChatModel
    
    init(model: ChatModel) {
        self.model = model
    }
    
    func getRealTimeChatData(roomID: String) {
        DatabaseHelper().chatDataListener(roomID: roomID, result: { chats in
            self.model.chats = []
            var chatTexts: [ChatText] = []
            for (_, value) in chats {
                guard let text = value["text"] as! String? else { return }
                guard let userID = value["userID"] as! String? else { return }
                guard let date = value["date"] as! Date? else { return }
                chatTexts.append(.init(text: text, userID: userID, date: date))
            }
            self.model.chats = chatTexts
        })
    }
}
