//
//  SNS.swift
//  zoqs_sns
//
//  Created by takumi on 2022/12/17.
//

import SwiftUI

struct SNS: View {
    var body: some View {
        
        VStack{
            Text("twitterのホーム画面のイメージ").padding()
            Text("他の人の投稿が見れる").padding()
            Text("ストーリーみたいな感じで他の人の投稿は24時間で見れなくなる").padding()
            Text("自分がその日の日記を書かないとこのページは見れない").padding()
        }.padding()
        
        
    }
}

struct SNS_Previews: PreviewProvider {
    static var previews: some View {
        SNS()
    }
}
