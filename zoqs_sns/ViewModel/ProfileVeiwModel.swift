//
//  ProfileVeiwModel.swift
//  zoqs_sns
//
//  Created by 島田将太郎 on 2023/02/08.
//

import Foundation
import SwiftUI

class ProfileViewModel: ObservableObject {
    @Published var model: ProfileModel
    
    init(model: ProfileModel) {
        self.model = model
    }
    
    var myId: String {
        return AuthHelper().uid()
    }
    
    func checkSameId(id: String) -> Bool{
        return self.model.id == id
    }
    
    func convertUserId(id: String) {
        self.model.id = id
    }
    
    func selfInit() {
        self.model = .init(id: "", name: "", image: nil, follows: [], followUserList: [])
    }
    
    func getUserData(){
        DatabaseHelper().getUserData(userID: self.model.id, result: { data in
            if let data = data {
                self.model.name = data["name"] as? String ?? "No Name"
                self.model.follows = data["follows"] as? [String] ?? []
                self.getFollowList()
            } else {
                print("error")
            }
        })
        DatabaseHelper().getFollowers(id: self.model.id, result: { ids in
            self.model.followers = ids
            self.getFollowerList()
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
}
