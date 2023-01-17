//
//  InitialAction.swift
//  zoqs_sns
//
//  Created by 島田将太郎 on 2023/01/16.
//

import Foundation

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
}
