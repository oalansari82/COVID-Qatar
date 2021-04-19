//
//  CovidTabView.swift
//  COVID Qatar
//
//  Created by Omar Al-Ansari on 4/2/21.
//

import SwiftUI

struct CovidTabView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    VStack {
                        Image(systemName: "house")
                        Text("Home")
                    }
                }
            ChartView()
                .tabItem {
                    Image(systemName: "chart.bar.xaxis")
                    Text("Chart")
                }
            ListView()
                .tabItem {
                    Image(systemName: "clock")
                    Text("History")
                }
        }.accentColor(.maroon)
    }
}

struct CovidTabView_Previews: PreviewProvider {
    static var previews: some View {
        CovidTabView()
    }
}
