//
//  ObservableObject.swift
//  zoqs_sns
//
//  Created by 島田将太郎 on 2023/01/15.
//

import Foundation

final class UserData: ObservableObject {
    @Published var uid = ""
    @Published var name = ""
}
