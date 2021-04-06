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
                    }
                }
                .navigationBarTitle("Historical Data")
                .navigationBarItems(trailing:
                                        Button(action:{
                                            lvm.fetchData()
                                        }) {
                                            Image(systemName: "arrow.triangle.2.circlepath")
                                                .rotationEffect(Angle.degrees(self.lvm.inProgress ? 360 : 0))
                                                .animation(.easeInOut)
                                        }
                )
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
                Spacer()
                Text(date)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            HStack {
                VStack {
                    Text("\(numberOfNewTestsInLast24Hrs)")
                        .font(.system(size: 33, weight: .medium))
                    Text("Tested")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                Spacer()
                VStack {
                    Text("\(numberOfPositiveCasesIn24Hrs)")
                        .font(.system(size: 33, weight: .medium))
                    Text("Positive")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                Spacer()
                VStack {
                    Text("\(numberOfNewDeathsInLast24Hrs)")
                        .font(.system(size: 33, weight: .medium))
                    Text("Death")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
            }.padding()
            
            Divider()
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal)
    }
}
