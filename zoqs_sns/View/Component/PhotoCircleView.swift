//
//  PhotoCircleView.swift
//  zoqs_sns
//
//  Created by 島田将太郎 on 2023/02/06.
//

import SwiftUI

struct PhotoCircleView: View {
    var image: UIImage?
    var diameter: CGFloat
    
    var body: some View {
        VStack() {
            if let uiImage = image {
                Image(uiImage: uiImage)
                    .resizable()
                    .frame(width: diameter, height: diameter, alignment: .center)
                    .clipShape(Circle())
            } else {
                Image(systemName: "person.fill")
                    .resizable()
                    .frame(width: diameter, height: diameter, alignment: .center)
                    .clipShape(Circle())
            }
        }
    }
}

//struct PhotoCircleView_Previews: PreviewProvider {
//    static var previews: some View {
//        PhotoCircleView()
//    }
//}
