//
//  NavigationViewModel.swift
//  zoqs_sns
//
//  Created by 島田将太郎 on 2023/02/18.
//

import Foundation
import SwiftUI


final class RouterNavigationPath: ObservableObject {
//    @Published var path =  NavigationPath()
    @Published var path: [Route] = []
    
    func gotoHomePage() {
//        path.removeLast(path.count)
//        self.path = []
        self.path.forEach {_ in 
            self.path.removeLast()
        }
    }
}

enum Route: Hashable {
    case userList([UserListData])
    case basicProfile(BasicProfile)
}

enum ChatRoute: Hashable {
    case roomList
    case basicProfile(BasicProfile)
}
