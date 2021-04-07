//
//  ContentView.swift
//  COVID Qatar
//
//  Created by Omar Al-Ansari on 3/20/21.
//

import SwiftUI
import SwiftUICharts
import Combine

struct ChartView: View {
    
    @ObservedObject var cvvm = ChartViewViewModel()
    @State private var animateChart = false
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text("Chart")
                        .font(.system(size: 37, weight: .bold))
                        .padding([.horizontal, .top])
                        .padding(.top, 30)
                    Text(cvvm.chartPositiveOrDeathTab == 0 ? "Positive Cases" : "Death Cases")
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                }
                Spacer()
            }
            
            ScrollView(.vertical, showsIndicators: false) {
                
                VStack {
                    ZStack {
                        LineGraph(dataPoints: cvvm.numberOfCases.reversed().normalized)
                            .trim(to: animateChart ? 1 : 0)
                            .stroke(Color.blue)
                            .frame(width: UIScreen.main.bounds.width - 20, height: 300)
                            .onAppear {
                                withAnimation(.easeInOut(duration: 2)) {
                                    animateChart = true
                                }
                            }
                        if cvvm.inProgress {
                            ChartLoader()
                        }
                    }
                    
                    Picker("", selection: $cvvm.chartNumberOfDaysTab) {
                        Text("30 Days").tag(0)
                        Text("90 Days").tag(1)
                        if cvvm.chartPositiveOrDeathTab != 2 {
                            Text("All").tag(2)
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                    .padding()
                    .onChange(of: cvvm.chartNumberOfDaysTab) { (_) in
                        cvvm.fetchData()
                    }
                    
                    Picker("", selection: $cvvm.chartPositiveOrDeathTab) {
                        Text("Positive Cases").tag(0)
                        Text("Death Cases").tag(1)
                        if cvvm.chartNumberOfDaysTab != 2 {
                            Text("Percent Positive").tag(2)
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                    .padding([.horizontal])
                    .onChange(of: cvvm.chartPositiveOrDeathTab, perform: { _ in
                        cvvm.fetchData()
                    })
                    
                    HStack {
                        Spacer()
                        VStack {
                            Text(String(format: "%.0f", cvvm.numberOfCases.min() ?? 0) + "\(cvvm.chartPositiveOrDeathTab == 2 ? "%" : "")")
                                .font(.title)
                            Text("Min")
                                .font(.footnote)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        VStack {
                            Text(String(format: "%.0f", cvvm.numberOfCases.max() ?? 0) + "\(cvvm.chartPositiveOrDeathTab == 2 ? "%" : "")")
                                .font(.title)
                            Text("Max")
                                .font(.footnote)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        VStack {
                            Text(String(format: "%.0f", cvvm.numberOfCases.first ?? 0) + "\(cvvm.chartPositiveOrDeathTab == 2 ? "%" : "")")
                                .font(.title)
                            Text("Latest")
                                .font(.footnote)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                    }.padding()
                }
            }
            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView()
    }
}

