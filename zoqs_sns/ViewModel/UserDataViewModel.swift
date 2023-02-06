//
//  InitialAction.swift
//  zoqs_sns
//
//  Created by 島田将太郎 on 2023/01/16.
//

import Foundation
import SwiftUI

class UserDataViewModel: ObservableObject {
    @Published var model: UserDataModel
    
    init(model: UserDataModel) {
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
    
    var uiImageData: UIImage? {
        get {
            return model.imageData
        }
        set {
            model.imageData = newValue
        }
    }
    
    func getUserName(){
        DatabaseHelper().getUserData(userID: uid, result: { data in
            if let data = data {
                print(data)
                self.name = data["name"] as? String ?? "No Name"
            } else {
                print("error")
            }
        })
    }
    
    func getUserImageData(){
        DatabaseHelper().getImageData(userID: uid, result: { data in
            if let data = data {
                self.uiImageData = UIImage(data: data)
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
                self.uiImageData = image
                errorResult(nil)
            }
        })
    }
    
    
    
    
    
    
}
