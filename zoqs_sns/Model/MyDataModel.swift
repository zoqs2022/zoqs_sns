//
// StoreModel
// ログインしているユーザーの主な個人情報をまとめてる
//
//  Created by 島田将太郎 on 2023/01/14.
//

import Foundation
import SwiftUI


struct MyDataModel {
    var name: String = ""
    var image: UIImage?
    var follows: [String] = []
    var followUserList: [UserListData] = []
    var followers: [String] = []
    var followerUserList: [UserListData] = []
    var myPosts: [PostData] = []
    var displayPosts: [PostModel] = []
    var roomList: [ChatRoom] = []
    var chats: [String:[ChatText]] = [:]
}

struct UserListData: Hashable {
    var id: String = ""
    var name: String = ""
    var image: UIImage?
}

struct PostData {
    var id: String = ""
    var date: Date!
    var text: String = ""
    var feeling: Int = 0
    var emotion: Int = 0
    var with: Int = 0
    var image: UIImage?
}

struct ChatRoom {
    let roomID:String
    let userID:String
    var userName: String = ""
    var userImage: UIImage?
    let createdAt: Date 
}
