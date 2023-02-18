//
//  ProfileModel.swift
//  zoqs_sns
//
//  Created by 島田将太郎 on 2023/02/08.
//

import Foundation
import SwiftUI

struct ProfileModel {
    var id: String = ""
    var name: String = ""
    var image: UIImage?
    var follows: [String] = []
    var followUserList: [UserListData] = []
    var followers: [String] = []
    var followerUserList: [UserListData] = []
}

struct BasicProfile: Hashable {
    var id: String = ""
    var name: String = ""
    var image: UIImage?
}
