//
//  HomeView.swift
//  COVID Qatar
//
//  Created by Omar Al-Ansari on 3/26/21.
//

import SwiftUI
import SwiftUICharts

struct HomeView: View {
    
    @ObservedObject var hvm = HomeViewModel()
    @State private var presentingSheet = false
    
    var body: some View {
        NavigationView {
            ZStack {
                 ScrollView {
                    HStack {
                        Text("Qatar's Snapshot as of \(hvm.latestDaySnapshot.date ?? "")")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 20)
                        Spacer()
                    }

                    LazyVGrid(columns: [GridItem(.flexible())], alignment: .center, content: {
                        
                        HomeViewRow(leftValue: Int( hvm.latestDaySnapshot.totalNumberOfVaccineDosesAdministeredSinceStart ?? "") ?? 0, leftText: "Total Vaccines Given\nإجمالي عدد اللقاح التي تم ", rightValue: Int(hvm.latestDaySnapshot.totalNumberOfVaccineDosesAdministeredInLast24Hrs ?? 0), rightText: "Total Vaccines in 24h\nاللقاحات خلال ٢٤ ساعة", backgroundColor: .green)
                        
                        HomeViewRow(leftValue: hvm.latestDaySnapshot.totalNumberOfActiveCasesUndergoingTreatmentToDate ?? 0, leftText: "Current Active Cases\nإجمالي الحالات النشطة", rightValue: hvm.latestDaySnapshot.numberOfNewPositiveCasesInLast24Hrs ?? 0, rightValueIncreasing: hvm.isPositiveCasesIncreasing(), rightText: "Positive Cases in 24h\nالحالات الجديدة خلال ٢٤ ساعة")
                        
                        HomeViewRow(leftValue: hvm.latestDaySnapshot.totalNumberOfRecoveredCasesToDate ?? 0, leftText: "Total Recovered Cases\nإجمالي عدد المتعافين", rightValue: hvm.latestDaySnapshot.numberOfNewRecoveredCasesInLast24Hrs ?? 0, rightText: "Recovered Cases in 24h\nالمتعافين خلال ٢٤ ساعة")
                        
                        HomeViewRow(leftValue: hvm.latestDaySnapshot.totalNumberOfTestsToDate ?? 0, leftText: "Total Tested Cases\nإجمالي الأشخاص الذين تم فحصهم", rightValue: hvm.latestDaySnapshot.numberOfNewTestsInLast24Hrs ?? 0, rightValueIncreasing: hvm.isNumberOfTestsIncreasing(), rightText: "Test Cases in 24h\nعدد الإختبارات خلال\n٢٤ ساعة")
                        
                        HomeViewRow(leftValue: hvm.latestDaySnapshot.totalNumberOfAcuteCasesUnderHospitalTreatment ?? 0, leftText: "Current Hospitalized\nعدد الحالات في المستشفى", rightValue: hvm.latestDaySnapshot.numberOfNewAcuteHospitalAdmissionsInLast24Hrs ?? 0, rightText: "Hospitalized in 24h\nالحالات التي تم إدخالها\nالمستشفى خلال ٢٤ ساعة")
                        
                        HomeViewRow(leftValue: hvm.latestDaySnapshot.totalNumberOfCasesUnderIcuTreatment ?? 0, leftText: "Current in ICU\nالحالات في العناية المركزة", rightValue: hvm.latestDaySnapshot.numberOfNewIcuAdmissionsInLast24Hrs ?? 0, rightText: "ICU Cases in 24h\nالحالات التي دخلت العناية\nالمركزة خلال ٢٤ ساعة")
                        
                        HomeViewRow(leftValue: hvm.latestDaySnapshot.totalNumberOfDeathsToDate ?? 0, leftText: "Total Death to Date\nإجمالي الوفيات", rightValue: hvm.latestDaySnapshot.numberOfNewDeathsInLast24Hrs ?? 0, rightValueIncreasing: hvm.isDeathCasesIncreasing(), rightText: "Death Cases in 24h\nالوفيات خلال ٢٤ ساعة")
                    })
                 }.redacted(reason: hvm.inProgress ? .placeholder : [])
                
                if self.hvm.inProgress == true {
                    ProgressView()
                        .scaleEffect(1.5)
                }
            }
            .navigationTitle("COVID-19")
            .navigationBarItems(trailing:
                                    Button(action:{
                                        hvm.fetchData()
                                    }) {
                                        Image(systemName: "arrow.triangle.2.circlepath")
                                            .rotationEffect(Angle.degrees(self.hvm.inProgress ? 360 : 0))
                                            .animation(.easeInOut)
                                    }
        )
        }
    }
}

struct DayView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

struct HomeViewRow: View {
    var leftValue: Int
    var leftText: String
    var rightValue: Int
    var rightValueIncreasing: CasesIncrease?
    var rightText: String
    var backgroundColor: Color?
    
    var body: some View {
        HStack {
            Spacer()
            VStack {
                Text("\(leftValue)")
                    .foregroundColor(backgroundColor == .green ? .white : .primary)
                    .font(.system(size: 33, weight: .bold))
                Text(leftText)
                    .foregroundColor(backgroundColor == .green ? .white : .secondary)
                    .font(.caption)
                    .foregroundColor(Color.secondary)
            }.frame(width: (UIScreen.main.bounds.width / 2) - 10, alignment: .center)
            Spacer()
            VStack {
                HStack {
                    Text("\(rightValue)")
                        .foregroundColor(backgroundColor == .green ? .white : .primary)
                        .font(.system(size: 33, weight: .bold))
                    if rightValueIncreasing != nil {
                        Image(systemName: rightValueIncreasing == .increasing ? "arrow.up.circle.fill" : rightValueIncreasing == .decreasing ? "arrow.down.circle.fill" : "equal.circle.fill")
                            .foregroundColor(rightValueIncreasing ==  .increasing ? .red : rightValueIncreasing ==  .decreasing ? .green : .orange)
                    }
                }
                Text(rightText)
                    .foregroundColor(backgroundColor == .green ? .white : .secondary)
                    .font(.caption)
                    .foregroundColor(Color.secondary)
            }.frame(width: (UIScreen.main.bounds.width / 2) - 10, alignment: .center)
            Spacer()
        }.padding(20)
        .background(backgroundColor != nil ? backgroundColor : nil)
        .multilineTextAlignment(.center)
    }
}
