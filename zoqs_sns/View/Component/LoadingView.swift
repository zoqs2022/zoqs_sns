//
//  LoadingView.swift
//  zoqs_sns
//
//  Created by 島田将太郎 on 2023/02/19.
//

import SwiftUI


struct LoadingView: View {
    var size: CGFloat = 20
    @State var currentDegrees = 0.0
    
    let colorGradient = LinearGradient(gradient: Gradient(colors: [
        Color.blue,
        Color.blue.opacity(0.75),
        Color.blue.opacity(0.5),
        Color.blue.opacity(0.2),
        .clear]),
        startPoint: .leading, endPoint: .trailing)
    
    var body: some View {
        Circle()
            .trim(from: 0.0, to: 0.85)
            .stroke(colorGradient, style: StrokeStyle(lineWidth: 5))
            .frame(width: size, height: size)
            .rotationEffect(Angle(degrees: currentDegrees))
            .onAppear {
                Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { _ in
                    withAnimation {
                        self.currentDegrees += 10
                    }
                }
            }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
