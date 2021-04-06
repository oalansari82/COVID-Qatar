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
    
    @Environment(\.presentationMode) var presentation
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
                        Text("All").tag(2)
                    }.pickerStyle(SegmentedPickerStyle())
                    .padding()
                    .onChange(of: cvvm.chartNumberOfDaysTab) { (_) in
                        cvvm.fetchData()
                    }
                    
                    Picker("", selection: $cvvm.chartPositiveOrDeathTab) {
                        Text("Positive Cases").tag(0)
                        Text("Death Cases").tag(1)
                    }.pickerStyle(SegmentedPickerStyle())
                    .padding([.horizontal])
                    .onChange(of: cvvm.chartPositiveOrDeathTab, perform: { _ in
                        cvvm.fetchData()
                    })
                    
                    HStack {
                        Spacer()
                        VStack {
                            Text(String(format: "%.0f", cvvm.numberOfCases.min() ?? 0))
                                .font(.title)
                            Text("Min")
                                .font(.headline)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        VStack {
                            Text(String(format: "%.0f", cvvm.numberOfCases.max() ?? 0))
                                .font(.title)
                            Text("Max")
                                .font(.headline)
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

class ChartViewViewModel: ObservableObject {
    
    private var serviceAPI = ServicesAPI()
    @Published var inProgress = false
    @Published var numberOfCases = [CGFloat]()
    @Published var chartNumberOfDaysTab = 1
    @Published var chartPositiveOrDeathTab = 0
    
    init() {
        fetchData()
    }
    
    func fetchData() {
        inProgress = true
        numberOfCases.removeAll()
        serviceAPI.fetchData(numberOfDays: chartNumberOfDaysTab == 0 ? 30 : chartNumberOfDaysTab == 1 ? 90 : -1) { results in
            switch results {
            case .success(let data):
                data.records.forEach { record in
                    self.numberOfCases.append(self.chartPositiveOrDeathTab == 0 ? CGFloat(record.fields.numberOfNewPositiveCasesInLast24Hrs ?? 0) : CGFloat(record.fields.numberOfNewDeathsInLast24Hrs ?? 0))
                }
                self.inProgress = false
            case .failure(let err):
                self.inProgress = false
                print(err.localizedDescription)
            }
        }
    }
}


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
