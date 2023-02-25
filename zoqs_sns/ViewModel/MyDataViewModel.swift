//
//  InitialAction.swift
//  zoqs_sns
//
//  Created by 島田将太郎 on 2023/01/16.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseFirestore

class MyDataViewModel: ObservableObject {
    @Published var model: MyDataModel
    
    init(model: MyDataModel) {
        self.model = model
    }
    
    var uid: String {
        return AuthHelper().uid()
    }
    
    var name: String {
        get {
            return model.name
        }
        set {
            model.name = newValue
        }
    }
    
    func getBasicData(){
        DatabaseHelper().getUserData(userID: uid, result: { data in
            if let data = data {
                self.name = data["name"] as? String ?? "No Name"
                self.model.follows = data["follows"] as? [String] ?? []
                if !self.model.follows.isEmpty {
                    self.getFollowList()
                    self.getDisplayPosts(ids: self.model.follows)
                }
            } else {
                print("error")
            }
        })
        DatabaseHelper().getFollowers(id: uid, result: { ids in
            self.model.followers = ids
            self.getFollowerList()
        })
    }
    
    func getImageData(){
        DatabaseHelper().getImageData(userID: uid, result: { data in
            if let data = data {
                self.model.image = UIImage(data: data)
            }
        })
    }
    
    func updataUserData(_ name: String,_ image: UIImage?, errorResult:@escaping(String?) -> Void) {
        DatabaseHelper().editUserInfo(name: name, image: image, result: { result in
            if result == nil {
                errorResult("画像登録に失敗しました")
            } else {
                print(result!)
                self.name = name
                self.model.image = image
                errorResult(nil)
            }
        })
    }
    
    func getFollowList(){
        self.model.follows.enumerated().forEach {
            let index = $0.0 
            let uid = $0.1
            self.model.followUserList.append(UserListData(id: uid, name: "", image: nil))
            DatabaseHelper().getUserName(userID: uid, result: { name in
                self.model.followUserList[index].name = name
            })
            DatabaseHelper().getImageData(userID: uid, result: { data in
                if let data = data {
                    self.model.followUserList[index].image = UIImage(data: data)
                }
            })
        }
    }
    
    func getFollowerList(){
        self.model.followers.enumerated().forEach {
            let index = $0.0
            let uid = $0.1
            self.model.followerUserList.append(UserListData(id: uid, name: "", image: nil))
            DatabaseHelper().getUserName(userID: uid, result: { name in
                self.model.followerUserList[index].name = name
            })
            DatabaseHelper().getImageData(userID: uid, result: { data in
                if let data = data {
                    self.model.followerUserList[index].image = UIImage(data: data)
                }
            })
        }
    }
    
    func followUser(id: String, name: String, image: UIImage?) async {
        let res = await DatabaseHelper().addUserInFollows(id: id)
        if res == nil {
            DispatchQueue.main.async{ //ここをDispatchQueue.main.asyncで囲わないと警告が出てしまう
                self.model.follows.append(id)
                self.model.followUserList.append(UserListData(id: id, name: name, image: image))
            }
        }
    }
    
    func unfollowUser(id: String) async {
        let res = await DatabaseHelper().removeUserInFollows(id: id)
        if res == nil {
            DispatchQueue.main.async{
                self.model.follows.removeAll(where: {$0 == id})
                self.model.followUserList.removeAll(where: {$0.id == id})
            }
        }
    }
    
    func createPost(text:String, feeling:Int, emotion:Int, with:Int, image:UIImage?, result:@escaping(String?) -> Void){
        let date = Timestamp()
        let data: [String: Any] = [
            "userID": uid,
            "date": date,
            "feeling":feeling,
            "emotion":emotion,
            "text":text,
            "with":with
        ]
        DatabaseHelper().createPost(data: data, image: image, result: { responseId in
            if let id = responseId {
                self.model.myPosts.append(.init(id: id, date: date.dateValue(), text: text, feeling: feeling, emotion: emotion, with: with, image: image))
                result(nil)
            } else {
                result("画像の投稿に失敗しました")
            }
        })
        
    }
    
    func getPosts(id: String) {
        DatabaseHelper().getSelfPosts(id: id) { posts in
            self.model.myPosts = []
            var i = 0
            for (key,value) in posts {
                let index = i
                self.model.myPosts.append(.init(id: key, date: (value["date"] as! Timestamp).dateValue(), text: value["text"] as! String, feeling: value["feeling"] as! Int, emotion: value["emotion"] as! Int, with: value["with"] as! Int, image: nil))
                DatabaseHelper().getPostImage(id: key, result: { data in
                    if let data = data {
                        self.model.myPosts[index].image = UIImage(data: data)
                    }
                })
                i += 1
            }
        }
    }
    
    func getDisplayPosts(ids: [String]) {
        DatabaseHelper().getPostList(ids: ids,result: { posts in
            self.model.displayPosts = []
            var userIds: [String] = []
            for (key,value) in posts {
                let uid = value["userID"] as! String
                userIds.append(uid)
                self.model.displayPosts.append(PostModel(id: key, text: value["text"] as! String, userID: uid, date: (value["date"] as! Timestamp).dateValue(), userName: "", userImage: nil, postImage: nil))
                DatabaseHelper().getPostImage(id: key, result: { data in
                    if let data = data {
                        if let i = self.model.displayPosts.firstIndex(where: { $0.id == key}) {
                            self.model.displayPosts[i].postImage = UIImage(data: data)
                        }
                    }
                })
            }
            // 日付でソートする
            self.model.displayPosts = self.model.displayPosts.sorted(by: {
                $0.date.compare($1.date) == .orderedDescending
            })
            let uniqueUserIds = Array(Set(userIds))
            uniqueUserIds.forEach({ uid in
                DatabaseHelper().getUserName(userID: uid, result: { name in
                    var i = 0
                    while i != -1 {
                        i = self.model.displayPosts.firstIndex(where: { ($0.userID == uid) && ($0.userName == "")}) ?? -1
                        if i != -1 {
                            self.model.displayPosts[i].userName = name
                        }
                    }
                })
                DatabaseHelper().getImageData(userID: uid, result: { data in
                    if let data = data {
                        var i = 0
                        while i != -1 {
                            i = self.model.displayPosts.firstIndex(where: { ($0.userID == uid) && ($0.userImage == nil)}) ?? -1
                            if i != -1 {
                                self.model.displayPosts[i].userImage = UIImage(data: data)
                            }
                        }
                    }
                })
            })
        })
    }
    
    func getMyRoomList() {
        DatabaseHelper().getMyRoomList(result: { rooms in
            self.model.roomList = []
            for (key,value) in rooms {
                guard let users = value["users"] as? [String] else { return }
                if users.count != 2 { return }
                var userID = ""
                if users[0] == self.uid {
                    userID = users[1]
                } else {
                    userID = users[0]
                }
                self.model.roomList.append(ChatRoom(roomID: key, userID: userID))
                self.getRealTimeChatData()
                DatabaseHelper().getUserName(userID: userID, result: { name in
                    guard let index = self.model.roomList.firstIndex(where: { ($0.userID == userID)}) else { return }
                    self.model.roomList[index].userName = name
                })
                DatabaseHelper().getImageData(userID: userID, result: { data in
                    if let data = data {
                        guard let index = self.model.roomList.firstIndex(where: { ($0.userID == userID)}) else { return }
                        self.model.roomList[index].userImage = UIImage(data: data)
                    }
                })
            }
        })
    }
    
    func createChatRoom(id: String, result:@escaping(String?) -> Void) {
        DatabaseHelper().createRoom(userID: id, result: { id in
            if let id = id {
                result(id)
            } else {
                result(nil)
            }
        })
    }
    
    func getRealTimeChatData() {
        self.model.roomList.forEach({ room in
            DatabaseHelper().chatDataListener(roomID: room.roomID, result: { chats in
                self.model.chats[room.roomID] = []
                var chatTexts: [ChatText] = []
                for (_, value) in chats {
                    guard let text = value["text"] as! String? else { return }
                    guard let userID = value["userID"] as! String? else { return }
                    let date = (value["date"] as! Timestamp).dateValue() 
                    chatTexts.append(.init(text: text, userID: userID, date: date))
                }
                self.model.chats[room.roomID] = chatTexts
            })
        })
    }
}
