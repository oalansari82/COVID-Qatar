//
//  GridView.swift
//  COVID Qatar
//
//  Created by Omar Al-Ansari on 4/1/21.
//

import SwiftUI

struct GridView: View {

    var record: CovidData.Records.Fields
    
    var body: some View {            
            ScrollView {
                HStack {
                    Text("Qatar's Snapshot as of \(record.date ?? "")")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 20)
                    Spacer()
                }
                LazyVGrid(columns: [GridItem(.flexible())], alignment: .center, content: {
                    HomeViewRow(leftValue: Int(record.totalNumberOfVaccineDosesAdministeredSinceStart ?? "") ?? 0, leftText: "Total Vaccines Given\nإجمالي عدد اللقاح التي تم إعطائها", rightValue: record.totalNumberOfVaccineDosesAdministeredInLast24Hrs ?? 0, rightText: "Total Vaccines in 24h\nاللقاحات خلال ٢٤ ساعة", backgroundColor: .green)
                    
                    HomeViewRow(leftValue: record.totalNumberOfPositiveCasesToDate ?? 0, leftText: "Current Active Cases\nإجمالي الحالات النشطة", rightValue: record.numberOfNewPositiveCasesInLast24Hrs ?? 0, rightText: "Positive Cases in 24h\nالحالات الجديدة خلال ٢٤ ساعة")
                    
                    HomeViewRow(leftValue: record.totalNumberOfRecoveredCasesToDate ?? 0, leftText: "Total Recovered Cases\nإجمالي عدد المتعافين", rightValue: record.numberOfNewRecoveredCasesInLast24Hrs ?? 0, rightText: "Recovered Cases in 24h\nالمتعافين خلال ٢٤ ساعة")
                    
                    HomeViewRow(leftValue: record.totalNumberOfTestsToDate ?? 0, leftText: "Total Tested Cases\nإجمالي الأشخاص الذين تم فحصهم", rightValue: record.numberOfNewTestsInLast24Hrs ?? 0, rightText: "Test Cases in 24h\nعدد الإختبارات خلال\n٢٤ ساعة")
                    
                    HomeViewRow(leftValue: record.totalNumberOfAcuteCasesUnderHospitalTreatment ?? 0, leftText: "Current Hospitalized\nعدد الحالات في المستشفى", rightValue: record.numberOfNewAcuteHospitalAdmissionsInLast24Hrs ?? 0, rightText: "Hospitalized in 24h\nالحالات التي تم إدخالها\nالمستشفى خلال ٢٤ ساعة")
                    
                    HomeViewRow(leftValue: record.totalNumberOfCasesUnderIcuTreatment ?? 0, leftText: "Current in ICU\nالحالات في العناية المركزة", rightValue: record.numberOfNewIcuAdmissionsInLast24Hrs ?? 0, rightText: "ICU Cases in 24h\nالحالات التي دخلت العناية\nالمركزة خلال ٢٤ ساعة")
                    
                    HomeViewRow(leftValue: record.totalNumberOfDeathsToDate ?? 0, leftText: "Total Death to Date\nإجمالي الوفيات", rightValue: record.numberOfNewDeathsInLast24Hrs ?? 0, rightText: "Death Cases in 24h\nالوفيات خلال ٢٤ ساعة")
                    
                })
            }
            .navigationTitle(record.date ?? "")
    }
}

struct GridView_Previews: PreviewProvider {
    static var previews: some View {
        GridView(record: CovidData.Records.Fields())
    }
}
