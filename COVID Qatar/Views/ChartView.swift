//
//  ContentView.swift
//  COVID Qatar
//
//  Created by Omar Al-Ansari on 3/20/21.
//

import SwiftUI
import SwiftUICharts

struct ChartView: View {
    
    @ObservedObject var cvvm = ChartViewViewModel()
    @State var chartData = LineChartData(dataSets: LineDataSet(dataPoints: []))
    @State private var hasAppeared: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView(showsIndicators: false) {
                        ZStack {
                            FilledLineChart(chartData: chartData)
                                .touchOverlay(chartData: chartData, specifier: "%.0f")
                                .averageLine(chartData: chartData,strokeStyle: StrokeStyle(lineWidth: 1, dash: [5,10]))
                                .yAxisGrid(chartData: chartData)
                                .yAxisLabels(chartData: chartData)
                                .infoBox(chartData: chartData)
                                .floatingInfoBox(chartData: chartData)
                                .headerBox(chartData: chartData)
                                .legends(chartData: chartData, columns: [GridItem(.flexible()), GridItem(.flexible())])
                                .id(chartData.id)
                                .frame(minWidth: 150, maxWidth: 900, minHeight: 300, idealHeight: 350, maxHeight: 400, alignment: .center)
                                .padding()
                                .onAppear {
                                    if !hasAppeared {
                                            updateUI()
                                            hasAppeared = true
                                        }
                                }
                            if cvvm.inProgress {
                                ProgressView()
                            }
                        }
                                             
                        GroupBox(label: Text(cvvm.groupBoxTitle()).font(.caption).padding(.bottom, 5)) {
                            HStack {
                                VStack {
                                    Text(String(format: "%.0f", cvvm.numberOfCases.min() ?? 0) + "\(cvvm.chartPositiveOrDeathTab == 2 ? "%" : "")")
                                        .font(.title)
                                        .redacted(reason: cvvm.inProgress ? .placeholder : [])
                                    Text("Min")
                                        .font(.footnote)
                                        .foregroundColor(.secondary)
                                }.padding(.leading)
                                Spacer()
                                VStack {
                                    Text(String(format: "%.0f", cvvm.numberOfCases.max() ?? 0) + "\(cvvm.chartPositiveOrDeathTab == 2 ? "%" : "")")
                                        .font(.title)
                                        .redacted(reason: cvvm.inProgress ? .placeholder : [])
                                    Text("Max")
                                        .font(.footnote)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                                VStack {
                                    Text(String(format: "%.0f", cvvm.numberOfCases.first ?? 0) + "\(cvvm.chartPositiveOrDeathTab == 2 ? "%" : "")")
                                        .font(.title)
                                        .redacted(reason: cvvm.inProgress ? .placeholder : [])
                                    Text("Latest")
                                        .font(.footnote)
                                        .foregroundColor(.secondary)
                                }.padding(.trailing)
                            }
                        }.padding(.horizontal)
                }
                Picker("", selection: $cvvm.chartNumberOfDaysTab) {
                    Text("30 Days").tag(30)
                    Text("90 Days").tag(90)
                    Text("180 Days").tag(180)
                    Text("All").tag(-1)
                }.pickerStyle(SegmentedPickerStyle())
                .padding([.bottom, .horizontal])
                .padding(.bottom, 10)
                .onChange(of: cvvm.chartNumberOfDaysTab) { (_) in
                    updateUI()
                }
            }
            
            .toolbar(content: {
                    Menu {
                        Button(action: {
                            cvvm.lineChartType = ChartType.numberOfNewPositiveCasesInLast24Hrs
                            updateUI()
                        }) {
                            Text("Positive Cases")
                        }
                        
                        Button(action: {
                            cvvm.lineChartType = ChartType.numberOfNewDeathsInLast24Hrs
                            updateUI()
                        }) {
                            Text("Death Cases")
                        }
                        
                        Button(action: {
                            cvvm.lineChartType = ChartType.totalNumberOfCasesUnderIcuTreatment
                            updateUI()
                        }) {
                            Text("Current ICU Cases")
                        }
                        
                        Button(action: {
                            cvvm.lineChartType = ChartType.totalNumberOfActiveCasesUndergoingTreatmentToDate
                            updateUI()
                        }) {
                            Text("Current Active")
                        }
                        
                        Button(action: {
                            cvvm.lineChartType = ChartType.totalNumberOfAcuteCasesUnderHospitalTreatment
                            updateUI()
                        }) {
                            Text("Current Hospitalized")
                        }
                    } label: {
                        Image(systemName: "slider.horizontal.3")
                            .foregroundColor(.blue)
                    }
            })
                .navigationTitle("Charts")
        }
    }
    
    func updateUI() {
        cvvm.getChartData(numberOfDays: cvvm.chartNumberOfDaysTab, chartType: cvvm.lineChartType) { (data) in
            self.chartData = data
        }
        cvvm.fetchData()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView()
    }
}
