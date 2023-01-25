//
//  NIKKI.swift
//  zoqs_sns
//
//  Created by takumi on 2022/12/17.
//

import SwiftUI

struct NIKKI: View {
    
    @State var text: String = ""
    
    var body: some View {
        
        VStack {
            // 入力
            TextEditor(text: $text)
            // 表示
            Text(text)
                .foregroundColor(.red)
                .lineLimit(nil)
                .padding(5)
        }
    }
}

struct NIKKI_Previews: PreviewProvider {
    static var previews: some View {
        NIKKI()
    }
}
