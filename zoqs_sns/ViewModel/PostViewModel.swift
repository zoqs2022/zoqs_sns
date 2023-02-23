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
            var i = 0
            for (key,value) in posts {
                let index = i
                let uid = value["userID"] as! String
                self.posts.append(PostModel(id: key, text: value["text"] as! String, userID: uid, date: (value["date"] as! Timestamp).dateValue(), userName: "", userImage: nil, postImage: nil))
                DatabaseHelper().getUserName(userID: uid, result: { name in
                    self.posts[index].userName = name
                })
                DatabaseHelper().getImageData(userID: uid, result: { data in
                    if let data = data {
                        self.posts[index].userImage = UIImage(data: data)
                    }
                })
                DatabaseHelper().getPostImage(id: key, result: { data in
                    if let data = data {
                        self.posts[index].postImage = UIImage(data: data)
                    }
                })
                i = i + 1
            }
        })
    }
}
