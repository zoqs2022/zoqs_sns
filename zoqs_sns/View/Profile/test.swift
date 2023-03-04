//
//  test.swift
//  zoqs_sns
//
//  Created by takumi on 2023/03/03.
//

import SwiftUI

struct test: View {
    var body: some View {
        
        ZStack(alignment: .topLeading){
            ZStack{
                //中の四角
                RoundedRectangle(cornerRadius: 30)
                    .fill(Color.white)
                //縁取りの四角
                RoundedRectangle(cornerRadius: 30)
                    .stroke(style: StrokeStyle(dash: [4, 4]))
                    .foregroundColor(Color.blue)
                //文字の線
                VStack{
                    ForEach(0..<10){index in
                        Path { path in
                            path.move(to: CGPoint(x: 20, y: 15))
                            path.addLine(to: CGPoint(x: 330, y: 15))
                        }
                        .stroke(style: StrokeStyle(dash: [4, 4]))
                        .fill(Color.black)
                    }
                }
            }.frame(width: 350, height: 250)
            Image("diaryicon")
                .resizable()
                .scaledToFit()
                .frame(width: 60)
        }
    }
}












struct test_Previews: PreviewProvider {
    static var previews: some View {
        test()
    }
}
