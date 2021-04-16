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
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView(showsIndicators: false) {
                    HStack {
                        Text(cvvm.chartTitle())
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .padding(.leading)
                        Spacer()
                    }
                    
                    if cvvm.chartType == "line" {
                        LineChart(highYValue: cvvm.numberOfCases.max() ?? 0, lowYValue: cvvm.numberOfCases.min() ?? 0, graphDataPoints: cvvm.numberOfCases, isLoading: cvvm.inProgress)
                        
                        Picker("", selection: $cvvm.chartNumberOfDaysTab) {
                            Text("30 Days").tag(0)
                            Text("90 Days").tag(1)
                            if cvvm.chartPositiveOrDeathTab != 2 {
                                Text("180 Days").tag(2)
                            }
                        }.pickerStyle(SegmentedPickerStyle())
                        .padding()
                        .onChange(of: cvvm.chartNumberOfDaysTab) { (_) in
                            cvvm.fetchData(for: .numberOfNewPositiveCasesInLast24Hrs)
                        }
                        
                        GroupBox {
                            HStack {
                                VStack {
                                    Text(String(format: "%.0f", cvvm.numberOfCases.min() ?? 0) + "\(cvvm.chartPositiveOrDeathTab == 2 ? "%" : "")")
                                        .font(.title)
                                    Text("Min")
                                        .font(.footnote)
                                        .foregroundColor(.secondary)
                                }.padding(.leading)
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
                                }.padding(.trailing)
                            }
                        }.padding()
                        
                    } else {
                        BarChart()
                    }
                }
                
                Picker("", selection: $cvvm.chartType) {
                    Text("Line Chart").tag("line")
                    Text("Bar Chart").tag("bar")
                }.pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                .padding(.vertical, 10)
            }
            .toolbar(content: {
                if cvvm.chartType == "line" {
                    Menu {
                        Button(action: {
                            cvvm.lineChartType = ChartType.numberOfNewPositiveCasesInLast24Hrs
                            cvvm.fetchData(for: cvvm.lineChartType)
                        }) {
                            Text("Positive Cases")
                                .font(.caption)
                                .bold()
                                .padding(10)
                                .background(cvvm.lineChartType == .numberOfNewPositiveCasesInLast24Hrs ? Color.secondary : .blue)
                                .foregroundColor(.white)
                                .cornerRadius(5)
                        }.disabled(cvvm.lineChartType == .numberOfNewPositiveCasesInLast24Hrs)
                        
                        Button(action: {
                            cvvm.lineChartType = ChartType.numberOfNewDeathsInLast24Hrs
                            cvvm.fetchData(for: cvvm.lineChartType)
                        }) {
                            Text("Death Cases")
                                .font(.caption)
                                .bold()
                                .padding(10)
                                .background(cvvm.lineChartType == .numberOfNewDeathsInLast24Hrs ? Color.secondary : .blue)
                                .foregroundColor(.white)
                                .cornerRadius(5)
                        }.disabled(cvvm.lineChartType == .numberOfNewDeathsInLast24Hrs)
                        
                        Button(action: {
                            cvvm.lineChartType = ChartType.totalNumberOfCasesUnderIcuTreatment
                            cvvm.fetchData(for: cvvm.lineChartType)
                        }) {
                            Text("Current ICU Cases")
                                .font(.caption)
                                .bold()
                                .padding(10)
                                .background(cvvm.lineChartType == .totalNumberOfCasesUnderIcuTreatment ? Color.secondary : .blue)
                                .foregroundColor(.white)
                                .cornerRadius(5)
                        }.disabled(cvvm.lineChartType == .totalNumberOfCasesUnderIcuTreatment)
                        
                        Button(action: {
                            cvvm.lineChartType = ChartType.totalNumberOfActiveCasesUndergoingTreatmentToDate
                            cvvm.fetchData(for: cvvm.lineChartType)
                        }) {
                            Text("Current Active")
                                .font(.caption)
                                .bold()
                                .padding(10)
                                .background(cvvm.lineChartType == .totalNumberOfActiveCasesUndergoingTreatmentToDate ? Color.secondary : .blue)
                                .foregroundColor(.white)
                                .cornerRadius(5)
                        }.disabled(cvvm.lineChartType == .totalNumberOfActiveCasesUndergoingTreatmentToDate)
                        
                        Button(action: {
                            cvvm.lineChartType = ChartType.totalNumberOfAcuteCasesUnderHospitalTreatment
                            cvvm.fetchData(for: cvvm.lineChartType)
                        }) {
                            Text("Current Hospitalized")
                                .font(.caption)
                                .bold()
                                .padding(10)
                                .background(cvvm.lineChartType == .totalNumberOfAcuteCasesUnderHospitalTreatment ? Color.secondary : .blue)
                                .foregroundColor(.white)
                                .cornerRadius(5)
                        }.disabled(cvvm.lineChartType == .totalNumberOfAcuteCasesUnderHospitalTreatment)
                        
                        Button(action: {
                            cvvm.lineChartType = ChartType.numberOfNewRecoveredCasesInLast24Hrs
                            cvvm.fetchData(for: cvvm.lineChartType)
                        }) {
                            Text("Recoveries")
                                .font(.caption)
                                .bold()
                                .padding(10)
                                .background(cvvm.lineChartType == .numberOfNewRecoveredCasesInLast24Hrs ? Color.secondary : .blue)
                                .foregroundColor(.white)
                                .cornerRadius(5)
                        }.disabled(cvvm.lineChartType == .numberOfNewRecoveredCasesInLast24Hrs)
                    } label: {
                        Image(systemName: "slider.horizontal.3")
                    }
                }
            })
                .navigationTitle("Charts")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView()
    }
}

struct LineChart: View {
    var highYValue: CGFloat
    var lowYValue: CGFloat
    var graphDataPoints: [CGFloat]
    var isLoading: Bool
    
    var body: some View {
        VStack {
            HStack {
                VStack {
                    Text(String(format: "%.0f", highYValue))
                        .font(.footnote)
                    Spacer()
                    Text(String(format: "%.0f", lowYValue))
                        .font(.footnote)
                }
                Divider()
                ZStack {
                    LineGraph(dataPoints: graphDataPoints.reversed().normalized)
                        .stroke(LinearGradient(gradient: Gradient(colors: [.red, .blue]), startPoint: .top, endPoint: .bottom))
                        .frame(width: UIScreen.main.bounds.width - 60, height: 250)

                    if isLoading {
                        ProgressView()
                    }
                }
            }
            Divider()
        }
    }
}
