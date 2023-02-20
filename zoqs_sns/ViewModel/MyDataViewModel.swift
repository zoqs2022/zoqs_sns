//
//  InitialAction.swift
//  zoqs_sns
//
//  Created by 島田将太郎 on 2023/01/16.
//

import Foundation
import SwiftUI

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
                self.getFollowList()
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
    
    func followUser(id: String) async -> String? {
        return await DatabaseHelper().addUserInFollows(id: id)
    }
    
    func addUserDataTofollows(id: String, name: String, image: UIImage?) {
        self.model.follows.append(id)
        self.model.followUserList.append(UserListData(id: id, name: name, image: image))
    }
    
    func unfollowUser(id: String) async -> String? {
        return await DatabaseHelper().removeUserInFollows(id: id)
    }
    
    func removeUserDataTofollows(id: String, name: String, image: UIImage?) {
        self.model.follows.removeAll(where: {$0 == id})
        self.model.followUserList.removeAll(where: {$0.id == id})
    }
    
    func addPost(text:String, feeling:Int, emotion:Int, with:Int, result:@escaping(String?) -> Void){
        DatabaseHelper().addPost(text: text, feeling: feeling, emotion: emotion, with: with, result: { err in
            if let err = err {
                result(err)
            } else {
                result(nil)
            }
        })
    }
}
