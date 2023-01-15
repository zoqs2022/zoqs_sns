//
//  初期設定などを書いてる
//
//
//  Created by 島田将太郎 on 2022/12/17.
//

import SwiftUI
import FirebaseCore

//firebaseの接続　初期化コード
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        return true
    }
}




@main
struct zoqs_snsApp: App {
    // register app delegate for Firebase setup  firebase
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }
    }
}
