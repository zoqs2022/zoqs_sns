//
//  InitialAction.swift
//  zoqs_sns
//
//  Created by 島田将太郎 on 2023/01/16.
//

import Foundation
import SwiftUI

class UserViewModel: ObservableObject {
    @Published var model: UserModel
    
    init(model: UserModel) {
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
    
    func getUserData(){
        DatabaseHelper().getUserData(userID: uid, result: { data in
            if let data = data {
                self.name = data["name"] as? String ?? "No Name"
                self.model.follows = data["follows"] as? [String] ?? []
                self.getUserList()
            } else {
                print("error")
            }
        })
    }
    
    func getUserImageData(){
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
    
    func getUserList(){
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
}
