//
//  BarChart.swift
//  COVID Qatar
//
//  Created by Omar Al-Ansari on 4/9/21.
//

import SwiftUI


struct BarChart: View {
    
    @ObservedObject var lvm = ListViewModel()
    
    var body: some View {
        VStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .bottom) {
                    ForEach(lvm.data.prefix(90), id: \.self) { record in
                        
                            Rectangle()
                                .frame(width: 20, height: (CGFloat(record.numberOfNewTestsInLast24Hrs ?? 0) / self.lvm.getMaxTests()) * 300)
                                .foregroundColor(Color(.systemGray3))
                                .overlay(
                                    VStack(spacing: 0) {
                                        Rectangle().fill(Color.blue)
                                            .frame(height: (CGFloat(record.numberOfNewPositiveCasesInLast24Hrs ?? 0) / self.lvm.getMaxTests()) * 300)
                                        
                                        Rectangle().fill(Color.red)
                                            .frame(height: (CGFloat(record.numberOfNewDeathsInLast24Hrs ?? 0) / self.lvm.getMaxTests()) * 10000)

                                        Text("\(record.numberOfNewPositiveCasesInLast24Hrs ?? 0)")
                                            .font(.caption2)
                                            .rotationEffect(.degrees(-90))
                                            .frame(width: 70)
                                            .offset(y: -45)
                                        
                                        Spacer()
                                        Text("\(record.numberOfNewTestsInLast24Hrs ?? 0)")
                                            .font(.caption2)
                                            .rotationEffect(.degrees(-90))
                                            .frame(width: 70)
                                            
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
                    }
                }.frame(height: 450)
            }
            
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Circle()
                        .frame(width: 10)
                        .foregroundColor(Color(.systemGray3))
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
    }
}

struct BarChart_Previews: PreviewProvider {
    static var previews: some View {
        BarChart()
    }
}
