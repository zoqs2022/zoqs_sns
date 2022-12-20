//
//  PHOTO.swift
//  zoqs_sns
//
//  Created by takumi on 2022/12/17.
//

import SwiftUI

struct PHOTO: View {
    var body: some View {
        VStack{
            ZStack{
                Rectangle()
                    .fill(Color.gray)
                    .frame(height:250)
                VStack{
                    Text("ランダムで背景のアルバム写真が変わる").frame(alignment:.topLeading)
                    Text("〇〇年○月○日")
                }
            }
            VStack{
                Text("写真")
                Text("日記")
                Text("様々なsnsの投稿など")
                Text("その日に起きたこと考えたことが一目で分かるように表示")
            }.padding()
            Spacer()
        }
    }
}

struct PHOTO_Previews: PreviewProvider {
    static var previews: some View {
        PHOTO()
    }
}
