//
//  BarChart.swift
//  COVID Qatar
//
//  Created by Omar Al-Ansari on 4/9/21.
//

import SwiftUI


struct BarChart: View {
    
    @ObservedObject var lvm = ListViewModel()
    @State var animateChart = false
    
    var body: some View {
        VStack {
            ZStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .bottom) {
                        ForEach(lvm.data, id: \.self) { record in
                            VStack {
                                Rectangle()
                                        .frame(width: 20, height: animateChart ? (CGFloat(record.numberOfNewTestsInLast24Hrs ?? 0) / self.lvm.getMaxTests()) * 300 : 0)
                                    .foregroundColor(Color.chartBars)
                                        .overlay(
                                            VStack(spacing: 0) {
                                                Rectangle().fill(Color.blue)
                                                    .frame(height: animateChart ? (CGFloat(record.numberOfNewPositiveCasesInLast24Hrs ?? 0) / self.lvm.getMaxTests()) * 300 : 0)
                                                
                                                Rectangle().fill(Color.red)
                                                    .frame(height: animateChart ? (CGFloat(record.numberOfNewDeathsInLast24Hrs ?? 0) / self.lvm.getMaxTests()) * 10000 : 0)

                                                Text("\(record.numberOfNewPositiveCasesInLast24Hrs ?? 0)")
                                                    .font(.caption2)
                                                    .rotationEffect(.degrees(-90))
                                                    .frame(width: 70)
                                                    .offset(y: -45)
                                                    .lineLimit(1)
                                                    .minimumScaleFactor(0.5)
                                                
                                                Spacer()
                                                Text("\(record.numberOfNewTestsInLast24Hrs ?? 0)")
                                                    .font(.caption2)
                                                    .rotationEffect(.degrees(-90))
                                                    .frame(width: 70)
                                                    .lineLimit(1)
                                                    .minimumScaleFactor(0.5)
                                                    
                                                Spacer()
                                                Text("\(record.date ?? "")")
                                                    .font(.caption2)
                                                    .rotationEffect(.degrees(-90))
                                                    .frame(width: 70)
                                                    .offset(y: 45)
                                                    .lineLimit(1)
                                                    .minimumScaleFactor(0.5)
                                            }
                                            
                                    )
                                        .onAppear {
                                            withAnimation(.easeInOut(duration: 1)) {
                                                animateChart = true
                                            }
                                    }
                            }
                        }
                    }.frame(height: 450)
                }
                if lvm.inProgress {
                    ProgressView()
                }
            }
            
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Circle()
                        .frame(width: 10)
                        .foregroundColor(Color.chartBars)
                    Text("Number of tests in the last 24 hours")
                        .font(.caption2)
                }
                HStack {
                    Circle()
                        .frame(width: 10)
                        .foregroundColor(Color.blue)
                    Text("Number of positive cases in the last 24 hours")
                        .font(.caption2)
                }
                HStack {
                    Circle()
                        .frame(width: 10)
                        .foregroundColor(Color.red)
                    Text("Number of death cases in the last 24 hours")
                        .font(.caption2)
                }
            }.frame(maxWidth: .infinity, maxHeight: 120, alignment: .leading)
            .padding(.leading)
            
        }
        .toolbar(content: {
            Menu {
                Button(action: {
                    lvm.numberOfDays = 30
                    lvm.fetchData()
                }) {
                    Text("30 Days")
                }
                
                Button(action: {
                    lvm.numberOfDays = 90
                    lvm.fetchData()
                }) {
                    Text("90 Days")
                }
                
                Button(action: {
                    lvm.numberOfDays = 180
                    lvm.fetchData()
                }) {
                    Text("180 Days")
                }
            } label: {
                Image(systemName: "slider.horizontal.3")
                    .foregroundColor(.blue)
            }
        })
    }
}

struct BarChart_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            BarChart()
            BarChart().preferredColorScheme(.dark)
        }
    }
}
