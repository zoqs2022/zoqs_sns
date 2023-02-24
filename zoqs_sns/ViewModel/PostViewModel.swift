//
//  PostViewModel.swift
//  zoqs_sns
//
//  Created by 島田将太郎 on 2023/02/05.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseFirestore


class PostViewModel: ObservableObject {
    @Published var posts: [PostModel]
    
    init(model: [PostModel]) {
        self.posts = model
    }
    
    func getAllPostList(ids: [String]) {
        DatabaseHelper().getPostList(ids: ids,result: { posts in
            self.posts = []
            var userIds: [String] = []
            for (key,value) in posts {
                let uid = value["userID"] as! String
                userIds.append(uid)
                self.posts.append(PostModel(id: key, text: value["text"] as! String, userID: uid, date: (value["date"] as! Timestamp).dateValue(), userName: "", userImage: nil, postImage: nil))
                DatabaseHelper().getPostImage(id: key, result: { data in
                    if let data = data {
                        if let i = self.posts.firstIndex(where: { $0.id == key}) {
                            self.posts[i].postImage = UIImage(data: data)
                        }
                    }
                })
            }
            // 日付でソートする
            self.posts = self.posts.sorted(by: {
                $0.date.compare($1.date) == .orderedDescending
            })
            let uniqueUserIds = Array(Set(userIds))
            uniqueUserIds.forEach({ uid in
                DatabaseHelper().getUserName(userID: uid, result: { name in
                    var i = 0
                    while i != -1 {
                        i = self.posts.firstIndex(where: { ($0.userID == uid) && ($0.userName == "")}) ?? -1
                        if i != -1 {
                            self.posts[i].userName = name
                        }
                    }
                })
                DatabaseHelper().getImageData(userID: uid, result: { data in
                    if let data = data {
                        var i = 0
                        while i != -1 {
                            i = self.posts.firstIndex(where: { ($0.userID == uid) && ($0.userImage == nil)}) ?? -1
                            if i != -1 {
                                self.posts[i].userImage = UIImage(data: data)
                            }
                        }
                    }
                })
            })
        })
    }
}
