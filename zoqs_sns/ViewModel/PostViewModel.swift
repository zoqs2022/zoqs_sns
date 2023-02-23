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
    
    func getAllPostList() {
        DatabaseHelper().getPostList(result: { posts in
            self.posts = []
            for (key,value) in posts {
                let uid = value["userID"] as! String
                self.posts.append(PostModel(id: key, text: value["text"] as! String, userID: uid, date: (value["date"] as! Timestamp).dateValue(), userName: "", userImage: nil, postImage: nil))
                DatabaseHelper().getUserName(userID: uid, result: { name in
                    if let i = self.posts.firstIndex(where: { $0.id == key}) {
                        self.posts[i].userName = name
                    }
                })
                DatabaseHelper().getImageData(userID: uid, result: { data in
                    if let data = data {
                        if let i = self.posts.firstIndex(where: { $0.id == key}) {
                            self.posts[i].userImage = UIImage(data: data)
                        }
                    }
                })
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
        })
    }
}
