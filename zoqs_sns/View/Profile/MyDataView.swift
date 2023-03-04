//
//  PHOTO.swift
//  zoqs_sns
//
//  Created by takumi on 2022/12/17.
//

import SwiftUI
import Charts


//グラフのサンプルデータ
struct SampleData: Identifiable {
    var id: String { name }    //
    let name: String    //横軸
    let amount: Double    //縦軸
    let from: String    //グラフ名
}
let sampleData: [SampleData] = [
    .init(name: "2月", amount: 50, from: "feeling"),
    .init(name: "4月", amount: 60, from: "feeling"),
    .init(name: "6月", amount: 65, from: "feeling"),
    .init(name: "8月", amount: 58, from: "feeling"),
    .init(name: "10月", amount: 52,from: "feeling"),
    .init(name: "12月", amount: 46,from: "feeling"),
    .init(name: "2月", amount: 54, from: "体重"),
    .init(name: "4月", amount: 55, from: "体重"),
    .init(name: "6月", amount: 58, from: "体重"),
    .init(name: "8月", amount: 60, from: "体重"),
    .init(name: "10月", amount: 54, from: "体重"),
    .init(name: "12月", amount: 53, from: "体重")
]


struct MyDataView: View {
    @ObservedObject var myDataViewModel: MyDataViewModel
    @ObservedObject var router: RouterNavigationPath
    
    @State private var image: UIImage?
    @State var showingImagePicker = false
    @State private var toEditProfile = false
    @State var focusDate: Int = 1
    
    var body: some View {
        ScrollView{
            VStack{
                //一番上のプロフィールのところ
                HStack(){
                    // 丸い写真のやつ
                    PhotoCircleView(image: myDataViewModel.model.image, diameter: 80)
                    VStack(){
                        HStack{
                            Text(myDataViewModel.name).bold()
                            Spacer()
                            HStack(alignment: .center, spacing: 0){
                                Button(action: {
                                    toEditProfile = true
                                }, label: {
                                    Label("編集", systemImage: "square.and.pencil.circle.fill")
                                        .font(.system(size: 18))
                                        .foregroundColor(.black)
                                        .padding(4)
                                        .bold()
                                })
                            }
                            .background(Color(.tertiaryLabel))
                            .cornerRadius(8)
                        }.padding(.leading, 24)
                        
                        Spacer()
                        
                        HStack{
                            VStack{
                                Text("10").bold()
                                Text("投稿").font(.system(size: 12))
                            }
                            Spacer()
                            NavigationLink(value: Route.userList(myDataViewModel.model.followUserList)){
                                VStack {
                                    Text("\(myDataViewModel.model.followUserList.count)").bold()
                                    Text("フォロー中").font(.system(size: 12))
                                }
                            }
                            Spacer()
                            NavigationLink(value: Route.userList(myDataViewModel.model.followerUserList)){
                                VStack {
                                    Text("\(myDataViewModel.model.followerUserList.count)").bold()
                                    Text("フォロワー").font(.system(size: 12))
                                }
                            }
                        }.padding(.leading, 40)
                    }.frame(height: 80)
                }.frame(maxWidth: .infinity, alignment: .leading).padding(24)
                
                //インスタのストーリーみたいなやつ
                Story(focusDate: $focusDate)
                
                //思い出表示部分
                Memory(focusDate: $focusDate)
                
                //グラフ
                graph()
                
                //〇〇ランキング
                Ranking()
                
            }
            .sheet(isPresented: $toEditProfile) {
                EditProfileView(myDataViewModel: myDataViewModel)
            }
            
        }
    }
}





struct Story : View {
    
    @Binding var focusDate:Int
    let imageName:[String] = ["flower","ikuta","diaryicon","testImage","testImage2"]
    @State private var tempNumber:[Int] = [0,1,2,3,4] //表示する写真をランダムで変更するための変数
    
    var body: some View {
        //インスタのストーリーみたいなやつ
        ScrollView(.horizontal){
            HStack{
                ForEach(0..<5){ index in
                    Image(imageName[tempNumber[index]])
                        .resizable()//.scaledToFit()
                        .overlay(
                            Circle().stroke(LinearGradient(gradient: Gradient(colors: [.cyan, .purple, .blue]), startPoint: .bottomLeading, endPoint: .topTrailing), lineWidth: 5))
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .onTapGesture {
                            focusDate = index
                        }
                        .shadow(radius: 5)
                }
            }
        }.onAppear(){
            // 5.0秒おきに{}内を繰り返す 表示する写真をランダムで変更する
            Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) {timer in
                for i in 0..<5 {
                    tempNumber[i] = Int.random(in: 0..<5)
                }
                
            }
        }//onAppear
    }
}


struct graph :View {
    var body: some View {
        //グラフ
        VStack{
            Text("My推移").font(.headline)
            
            Chart(sampleData) { data in
                LineMark(
                    x: .value("Name", data.name),
                    y: .value("Amount", data.amount)
                )
                .foregroundStyle(by: .value("Form", data.from))
                .lineStyle(StrokeStyle(lineWidth: 1))
            }
            .frame(height: 250)
            .padding()
            .background(Color.white)
            
        }
        
    }
}




struct Memory : View {
    
    @Binding var focusDate:Int
    
    var body: some View {
        //思い出表示部分
        ZStack{
            LinearGradient(gradient: Gradient(colors: [.cyan.opacity(0.3), .cyan]), startPoint: .top, endPoint: .bottom)
            VStack(){
                Text("Memory in  Jan 15 2023").font(.title2).fontWeight(.bold).padding()
                NikkiPage()
                NikkiInfo()
            }//日記表示全体のvstack
        }//背景色と日記のzstak
    }
}



struct Ranking : View {
    var body: some View {
        //〇〇ランキング
        ZStack{
            Rectangle()
                .fill(Color.cyan.opacity(0.5))
            VStack{
                Text("Myタグ使用ランキング").font(.headline)
                VStack{
                    ForEach(0..<5, id:\.self) { index in
                        HStack{
                            ZStack{
                                Circle().fill(Color.white).frame(width:20,height: 20)
                                Text(String(index+1)).foregroundColor(.cyan)
                            }
                            Text("#ラーメン")
                            Text("35回")
                        }
                    }//foreach
                }//vstack
            }.padding()//vstack
        }//zstack
        
        
        //〇〇ランキング
        ZStack{
            Rectangle()
                .fill(Color.cyan.opacity(0.5))
            VStack{
                Text("Myスポットランキング").font(.headline)
                VStack{
                    ForEach(0..<5, id:\.self) { index in
                        HStack{
                            ZStack{
                                Circle().fill(Color.white).frame(width:20,height: 20)
                                Text(String(index+1)).foregroundColor(.cyan)
                            }
                            Text("#大学")
                            Text("154回")
                        }
                    }//foreach
                }//vstack
            }.padding()//vstack
        }//zstack
        
        
    }
}



struct NikkiPage : View {
    var body: some View {
        ZStack(alignment: .topLeading){
            ZStack{
                //中の四角
                RoundedRectangle(cornerRadius: 30)
                    .fill(Color.white)
                //縁取りの四角
                RoundedRectangle(cornerRadius: 30)
                    .stroke()
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
                .shadow(radius: 5)
        }.shadow(radius: 10)
    }
}


struct NikkiInfo :View {
    var body: some View {
        
        VStack{
            HStack{
                Spacer()
                Text("emotion")
                Image(systemName: "face.smiling")
                Spacer()
                Text("feeling")
                Image(systemName: "face.smiling")
                Spacer()
                Text("with")
                Image(systemName: "face.smiling")
                Spacer()
            }.padding().background(Color.cyan.opacity(0.3))
            HStack(alignment: .top){//メタ情報
                VStack(alignment: .center){
                    Image(systemName: "tag")
                    Image(systemName:"location")
                    Image(systemName: "music.note.list")
                    Image(systemName: "message")
                    Image(systemName: "person.line.dotted.person")
                }
                VStack(alignment: .leading){
                    Text("tag").font(.headline)
                    Text("at").font(.headline)
                    Text("play music").font(.headline)
                    Text("contact").font(.headline)
                    Text("sns").font(.headline)
                }
                VStack(alignment: .leading){
                    Text("#〇〇、#〇〇、#〇〇")
                    Text("ドイツ")
                    Text("Norwegian Wood")
                    Text("連絡を取った人のリスト")
                    Text("他のsnsの投稿を見れる")
                }
            }
        }.frame(width: 350).background(Color.white).cornerRadius(20).padding()
    }
}
