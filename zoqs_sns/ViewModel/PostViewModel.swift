//
//  PostViewModel.swift
//  zoqs_sns
//
//  Created by 島田将太郎 on 2023/02/05.
//

import Foundation
import SwiftUI

let postsMock: [PostModel] = [
    PostModel(id: "0", text: "aaaa", userID: "5Y7MTVmyiiRSoHMVxx63SomCVe72", date: "2022-01-01"),
    PostModel(id: "1", text: "bbbb", userID: "5Y7MTVmyiiRSoHMVxx63SomCVe72", date: "2022-01-02"),
    PostModel(id: "2", text: "cccc", userID: "5Y7MTVmyiiRSoHMVxx63SomCVe72", date: "2022-01-03"),
    PostModel(id: "3", text: "dddd", userID: "5Y7MTVmyiiRSoHMVxx63SomCVe72", date: "2022-01-04"),
    PostModel(id: "4", text: "eeee", userID: "5Y7MTVmyiiRSoHMVxx63SomCVe72", date: "2022-01-05"),
]


class PostViewModel: ObservableObject {
    @Published var posts: [PostModel]
    
    init(model: [PostModel]) {
        self.posts = model
    }
    
    func getAllPostList() {
        DatabaseHelper().getPostList(result: { posts in
            self.posts = posts
        })
    }
}
