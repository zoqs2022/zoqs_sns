//
// StoreModel
// ログインしているユーザーの主な個人情報をまとめてる
//
//  Created by 島田将太郎 on 2023/01/14.
//

import Foundation
import SwiftUI


struct UserModel {
    var name: String = ""
    var image: UIImage?
    var follows: [String] = []
    var followUserList: [UserListData] = []
}

struct UserListData: Hashable {
    var id: String = ""
    var name: String = ""
    var image: UIImage?
}
