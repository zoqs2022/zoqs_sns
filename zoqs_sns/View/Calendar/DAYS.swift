//
//  DAYS.swift
//  zoqs_sns
//
//  Created by takumi on 2022/12/17.
//

import SwiftUI

struct DAYS: View {
    
    let week: [String] = ["日","月","火","水","木","金","土"]
    @State var diff: Int = 0
    let today: Int = Int(Date().DateToString(format: "d"))! - 1
    
    var body: some View {
        
        ScrollView{
            VStack{
                
                HStack{
                    Button(action: {diff -= 1}, label: {Image(systemName: "chevron.left.circle.fill")})
                    Text(Date().changeMonth(diff: diff).DateToString(format: "yyyy年M月")).fontWeight(.bold)
                    Button(action: {diff += 1}, label: {Image(systemName: "chevron.right.circle.fill")})
                }
                
                ScrollView{
                    LazyVGrid(columns: Array(repeating: GridItem(), count: 7), spacing: 8)
                    {
                        ForEach(week, id: \.self) {
                            i in
                            Text(i).foregroundColor(.indigo).fontWeight(.bold).padding(.top)
                        }
                        
                        let days: [Date] = Date().changeMonth(diff: diff).getAllDays()
                        let start = days[0].getWeekDay()
                        let end = start + days.count
                        
                        let maxBlock: Int = end <= 35 ? 34 : 41
                        
                        ForEach((0...maxBlock), id: \.self) {
                            index in
                            VStack(spacing : 4){
                                if(index >= start && index < end){
                                    let i = index - start
                                    if(i == today && diff == 0) {
                                        ZStack(alignment: .center){
                                            Circle()
                                                    .frame(width: 24,
                                                           height: 24,
                                                           alignment: .center)
                                                    .foregroundColor(.indigo)
                                            Text(days[i].DateToString(format: "d"))
                                                .foregroundColor(.white)
                                        }
                                        RoundedRectangle(cornerRadius: 8)
                                            .frame(width: 40, height: 40, alignment: .center)
                                            .foregroundColor(.indigo)
                                            .opacity(1)
                                        
                                    } else {
                                        Text(days[i].DateToString(format: "d"))
                                        RoundedRectangle(cornerRadius: 8)
                                            .frame(width: 40, height: 40, alignment: .center)
                                            .foregroundColor(.cyan)
                                            .opacity(0.5)
                                    }
                
                                } else {
    //                                Text("--")
                                }
    //                            RoundedRectangle(cornerRadius: 8)
    //                                .frame(width: 40, height: 40, alignment: .center)
    //                                .foregroundColor(.yellow)
    //                                .opacity(0.5)
                            }
                        }
                    }
                }
            }
            .padding(.bottom, 30)

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
