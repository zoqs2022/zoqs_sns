//
//  DAYS.swift
//  zoqs_sns
//
//  Created by takumi on 2022/12/17.
//

import SwiftUI

struct DAYS: View {
    var body: some View {
        VStack{
            ZStack{
                Rectangle()
                    .fill(Color.blue)
                    .frame(height: 300)
                Text("カレンダー")
            }

            ZStack{
                Rectangle()
                    .fill(Color.gray)
                    .frame(height: 200)
                Text("選択された日付の日記を表示する")
            }
            HStack{
                Spacer()
                Text("今日の日記を書く").padding(10).background(Color.green)
            }
            Spacer()
        }
    }
}

struct DAYS_Previews: PreviewProvider {
    static var previews: some View {
        DAYS()
    }
}
