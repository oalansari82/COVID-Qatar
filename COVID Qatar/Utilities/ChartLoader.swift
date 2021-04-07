//
//  ChartLoader.swift
//  COVID Qatar
//
//  Created by Omar Al-Ansari on 4/7/21.
//

import SwiftUI

struct ChartLoader: View {
    
    @State var isAtMaxScale = false
    private let animation = Animation.easeInOut(duration: 1).repeatForever(autoreverses: true)
    private var maxScale: CGFloat = 1.5
    
    var body: some View {
        VStack {
            Text("Loading")
                .font(.system(size: 16))
            RoundedRectangle(cornerRadius: 25.0)
                .fill(Color.blue)
                .frame(width: UIScreen.main.bounds.width / 2, height: 3)
                .scaleEffect(CGSize(width: isAtMaxScale ? maxScale : 0.01, height: 1))
                .onAppear {
                    withAnimation(animation) {
                        self.isAtMaxScale.toggle()
                    }
                }
        }
    }
}


struct ChartLoader_Previews: PreviewProvider {
    static var previews: some View {
        ChartLoader()
    }
}
