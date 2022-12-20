//
//  ContentView.swift
//  zoqs_sns
//
//  Created by 島田将太郎 on 2022/12/17.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView{
            SNS().tabItem{
                Image(systemName: "message")
                Text("閲覧")
            }
            NIKKI().tabItem{
                Image(systemName: "pencil")
                Text("投稿")
            }
            DAYS().tabItem{
                Image(systemName: "30.square.fill")
                Text("カレンダー")
            }
            PHOTO().tabItem{
                Image(systemName: "photo.fill")
                Text("アルバム")
            }
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
