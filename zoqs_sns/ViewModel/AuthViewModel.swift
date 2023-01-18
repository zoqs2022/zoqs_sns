//
//  AuthViewModel.swift
//  zoqs_sns
//
//  Created by 島田将太郎 on 2023/01/18.
//

import Foundation
import SwiftUI

struct AuthViewModel {
    
    func login(_ email: String, _ password: String, result:@escaping(_ success: Bool) -> Void) {
        AuthHelper().login(email: email, password: password, result: { success in
            if success {
                print("ログイン成功")
                result(true)
            } else {
                result(false)
            }
        })
    }
    
    func createAccount(_ email: String, _ password: String, _ name: String, _ image: UIImage?, errorResult:@escaping(_ error: String?) -> Void) {
        AuthHelper().createAccount(email: email, password: password, result: {
            success in
            if success {
                DatabaseHelper().resisterUserInfo(name: name, image: image,result: {success in
                    if !success {
                        errorResult("画像を登録できませんでした。")
                    } else {
                        errorResult(nil)
                    }
                })
            } else {
                errorResult("有効なメールアドレス、6文字以上のパスワードを設定してください。")
            }
        })
    }
    
}

