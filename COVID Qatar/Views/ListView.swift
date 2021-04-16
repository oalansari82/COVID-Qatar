//
//  ListView.swift
//  COVID Qatar
//
//  Created by Omar Al-Ansari on 4/2/21.
//

import SwiftUI

struct ListView: View {
    
    @ObservedObject var lvm = ListViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 300))], alignment: .center, spacing: 10, content: {
                            ForEach(lvm.data, id: \.self) { record in
                                NavigationLink(destination: GridView(record: record)) {
                                    ListView_Item(date: record.date ?? "", numberOfPositiveCasesIn24Hrs: record.numberOfNewPositiveCasesInLast24Hrs ?? 0, numberOfNewTestsInLast24Hrs: record.numberOfNewTestsInLast24Hrs ?? 0, numberOfNewDeathsInLast24Hrs: record.numberOfNewDeathsInLast24Hrs ?? 0)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        })
                    }.redacted(reason: lvm.inProgress ? .placeholder : [])
                    
                    if self.lvm.inProgress == true {
                        ProgressView()
                            .scaleEffect(1.5)
                    }
                }
                .navigationBarTitle("Historical Data")
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
                        
                        Button(action: {
                            lvm.numberOfDays = -1
                            lvm.fetchData()
                        }) {
                            Text("All")
                        }
                    } label: {
                        Image(systemName: "slider.horizontal.3")
                    }
                })
            }
        }
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ListView()
            ListView_Item(date: "12/12/2020", numberOfPositiveCasesIn24Hrs: 123, numberOfNewTestsInLast24Hrs: 123, numberOfNewDeathsInLast24Hrs: 123)
        }
    }
}

struct ListView_Item: View {
    var date: String
    var numberOfPositiveCasesIn24Hrs: Int
    var numberOfNewTestsInLast24Hrs: Int
    var numberOfNewDeathsInLast24Hrs: Int
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                VStack(spacing: 0) {
                    Text(cleanYear(string: date))
                        .font(.footnote)
                    Text(cleanDay(string: date))
                        .font(.title3)
                    Text(cleanMonth(string: date))
                        .font(.caption)
                }
                .padding(.horizontal)
                .padding(.vertical, 5)
                .background(Color(.systemGray3))
                .cornerRadius(10)
                .foregroundColor(.white)
                Spacer()
                VStack {
                    Text("\(numberOfNewTestsInLast24Hrs)")
                        .font(.title)
                    Text("Tested")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
                Spacer()
                VStack {
                    Text("\(numberOfPositiveCasesIn24Hrs)")
                        .font(.title)
                    Text("Positive")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
                Spacer()
                VStack {
                    Text("\(numberOfNewDeathsInLast24Hrs)")
                        .font(.title)
                    Text("Death")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
            }.padding(.bottom, 10)
            
            Divider()
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal)
    }
    
    func cleanMonth(string: String) -> String {
        var newString = string
        newString.removeLast(3)
        newString.removeFirst(5)
        switch newString {
        case "01": return "JAN"
        case "02": return "FEB"
        case "03": return "MAR"
        case "04": return "APR"
        case "05": return "MAY"
        case "06": return "JUN"
        case "07": return "JUL"
        case "08": return "AUG"
        case "09": return "SEP"
        case "10": return "OCT"
        case "11": return "NOV"
        case "12": return "DEC"
        default: return ""
        }
    }
    func cleanDay(string: String) -> String {
        var newString = string
        newString.removeFirst(8)
        return newString
    }
    func cleanYear(string: String) -> String {
        var newString = string
        newString.removeLast(6)
        return newString
    }
}
