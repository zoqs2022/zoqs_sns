//
// StoreModel
// ログインしているユーザーの主な個人情報をまとめてる
//
//  Created by 島田将太郎 on 2023/01/14.
//

import Foundation

final class UserData: ObservableObject {
    @Published var uid = ""
    @Published var name = ""
}
