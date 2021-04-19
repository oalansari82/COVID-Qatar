//
//  ChartViewModel.swift
//  COVID Qatar
//
//  Created by Omar Al-Ansari on 3/28/21.
//

import SwiftUI
import SwiftUICharts

class ChartViewViewModel: ObservableObject {
    
    private var serviceAPI = ServicesAPI()
    @Published var inProgress = false
    @Published var numberOfCases = [CGFloat]()
    @Published var chartNumberOfDaysTab = 90
    @Published var chartPositiveOrDeathTab = 0
    @Published var lineChartType: ChartType = .numberOfNewPositiveCasesInLast24Hrs
    
    init() {
        fetchData()
    }
    
    func fetchData() {
        inProgress = true
        numberOfCases.removeAll()
        serviceAPI.fetchData(numberOfDays: chartNumberOfDaysTab == 30 ? 30 : chartNumberOfDaysTab == 90 ? 90 : chartNumberOfDaysTab == 180 ? 180 : -1) { results in
            switch results {
            case .success(let data):
                data.records.forEach { record in
                    switch self.lineChartType {
                    case .numberOfNewPositiveCasesInLast24Hrs:
                        self.numberOfCases.append(CGFloat(record.fields.numberOfNewPositiveCasesInLast24Hrs ?? 0))
                    case .totalNumberOfDeathsToDate:
                        self.numberOfCases.append(CGFloat(record.fields.totalNumberOfDeathsToDate ?? 0))
                    case .totalNumberOfActiveCasesUndergoingTreatmentToDate:
                        self.numberOfCases.append(CGFloat(record.fields.totalNumberOfActiveCasesUndergoingTreatmentToDate ?? 0))
                    case .numberOfNewAcuteHospitalAdmissionsInLast24Hrs:
                        self.numberOfCases.append(CGFloat(record.fields.numberOfNewAcuteHospitalAdmissionsInLast24Hrs ?? 0))
                    case .numberOfNewTestsInLast24Hrs:
                        self.numberOfCases.append(CGFloat(record.fields.numberOfNewTestsInLast24Hrs ?? 0))
                    case .totalNumberOfVaccineDosesAdministeredInLast24Hrs:
                        self.numberOfCases.append(CGFloat(record.fields.totalNumberOfVaccineDosesAdministeredInLast24Hrs ?? 0))
                    case .totalNumberOfAcuteCasesUnderHospitalTreatment:
                        self.numberOfCases.append(CGFloat(record.fields.totalNumberOfAcuteCasesUnderHospitalTreatment ?? 0))
                    case .totalNumberOfCasesUnderIcuTreatment:
                        self.numberOfCases.append(CGFloat(record.fields.totalNumberOfCasesUnderIcuTreatment ?? 0))
                    case .numberOfNewIcuAdmissionsInLast24Hrs:
                        self.numberOfCases.append(CGFloat(record.fields.numberOfNewIcuAdmissionsInLast24Hrs ?? 0))
//                    case .totalNumberOfVaccineDosesAdministeredSinceStart:
//                        self.numberOfCases.append(CGFloat(record.fields.totalNumberOfVaccineDosesAdministeredSinceStart ?? "0"))
                    case .numberOfNewDeathsInLast24Hrs:
                        self.numberOfCases.append(CGFloat(record.fields.numberOfNewDeathsInLast24Hrs ?? 0))
                    case .totalNumberOfTestsToDate:
                        self.numberOfCases.append(CGFloat(record.fields.totalNumberOfTestsToDate ?? 0))
                    case .numberOfNewRecoveredCasesInLast24Hrs:
                        self.numberOfCases.append(CGFloat(record.fields.numberOfNewRecoveredCasesInLast24Hrs ?? 0))
                    case .totalNumberOfRecoveredCasesToDate:
                        self.numberOfCases.append(CGFloat(record.fields.totalNumberOfRecoveredCasesToDate ?? 0))
                    case .totalNumberOfPositiveCasesToDate:
                        self.numberOfCases.append(CGFloat(record.fields.totalNumberOfPositiveCasesToDate ?? 0))
                    default:
                        return
                    }
                }
                self.inProgress = false
            case .failure(let err):
                self.inProgress = false
                print(err.localizedDescription)
            }
        }
    }
    
    func getChartData(numberOfDays: Int, chartType: ChartType = .numberOfNewPositiveCasesInLast24Hrs, completion: @escaping (LineChartData) -> Void) {
        inProgress = true
        var data = LineDataSet(dataPoints: [],
                               legendTitle: "Positive Cases",
                               pointStyle: PointStyle(),
                               style: LineStyle(lineColour: ColourStyle(colours: [Color.red, Color.maroon.opacity(0.5)], startPoint: .top, endPoint: .bottom), lineType: .curvedLine))
        
        var metadata   = ChartMetadata(title: "Positive Cases", subtitle: "positive COVID-19 cases in the past 90 days")
        
        let gridStyle  = GridStyle(numberOfLines: 4,
                                   lineColour   : Color(.lightGray).opacity(0.5),
                                   lineWidth    : 0.5,
                                   dash         : [4],
                                   dashPhase    : 0)
        
        var chartStyle = LineChartStyle(infoBoxPlacement    : .infoBox(isStatic: false), 
                                        infoBoxBorderColour : Color.primary,
                                        infoBoxBorderStyle  : StrokeStyle(lineWidth: 0.5),
                                        
                                        markerType          : .vertical(attachment: .line(dot: .style(DotStyle()))),
                                        
                                        xAxisGridStyle      : gridStyle,
                                        xAxisLabelPosition  : .bottom,
                                        xAxisLabelColour    : Color.primary,
                                        xAxisLabelsFrom     : .dataPoint(rotation: .degrees(0)),
                                        
                                        yAxisGridStyle      : gridStyle,
                                        yAxisLabelPosition  : .leading,
                                        yAxisLabelColour    : Color.primary,
                                        yAxisNumberOfLabels : 4,
                                        
                                        baseline            : .minimumWithMaximum(of: 0),
                                        topLine             : .maximum(of: 2000),
                                        
                                        globalAnimation     : .easeOut(duration: 1))
      
        serviceAPI.fetchData(numberOfDays: numberOfDays) { (result) in
            var dataPoint = LineChartDataPoint(value: 0.0)
            switch result {
            case .success(let dataSet):
                dataSet.records.forEach { (record) in
                    switch chartType {
                    case .numberOfNewAcuteHospitalAdmissionsInLast24Hrs:
                        dataPoint = LineChartDataPoint(value: Double(record.fields.numberOfNewAcuteHospitalAdmissionsInLast24Hrs ?? 0), xAxisLabel: "\(record.fields.date ?? "")", description: "\(record.fields.date ?? "")")
                        chartStyle.topLine = .maximum(of: Double(record.fields.numberOfNewAcuteHospitalAdmissionsInLast24Hrs ?? 0))
                        metadata   = ChartMetadata(title: "Hospital Admissions", subtitle: "Admissions in the last 24 hours")
                        data.legendTitle = "Hospital Admissions"
                        self.inProgress = false
                    case .totalNumberOfActiveCasesUndergoingTreatmentToDate:
                        dataPoint = LineChartDataPoint(value: Double(record.fields.totalNumberOfActiveCasesUndergoingTreatmentToDate ?? 0), xAxisLabel: "\(record.fields.date ?? "")", description: "\(record.fields.date ?? "")")
                        chartStyle.topLine = .maximum(of: Double(record.fields.totalNumberOfActiveCasesUndergoingTreatmentToDate ?? 0))
                        metadata   = ChartMetadata(title: "Active Cases", subtitle: "Current total active COVID-19 cases")
                        data.legendTitle = "Active Cases"
                        self.inProgress = false
                    case .totalNumberOfAcuteCasesUnderHospitalTreatment:
                        dataPoint = LineChartDataPoint(value: Double(record.fields.totalNumberOfAcuteCasesUnderHospitalTreatment ?? 0), xAxisLabel: "\(record.fields.date ?? "")", description: "\(record.fields.date ?? "")")
                        chartStyle.topLine = .maximum(of: Double(record.fields.totalNumberOfAcuteCasesUnderHospitalTreatment ?? 0))
                        metadata   = ChartMetadata(title: "Total Hospitalized", subtitle: "Total hospitalized cases")
                        data.legendTitle = "Total Hospitalized"
                        self.inProgress = false
                    case .totalNumberOfCasesUnderIcuTreatment:
                        dataPoint = LineChartDataPoint(value: Double(record.fields.totalNumberOfCasesUnderIcuTreatment ?? 0), xAxisLabel: "\(record.fields.date ?? "")", description: "\(record.fields.date ?? "")")
                        chartStyle.topLine = .maximum(of: Double(record.fields.totalNumberOfCasesUnderIcuTreatment ?? 0))
                        metadata   = ChartMetadata(title: "Total ICU Cases", subtitle: "Total ICU cases under medical care")
                        data.legendTitle = "Total ICU cases"
                        self.inProgress = false
                    case .numberOfNewDeathsInLast24Hrs:
                        dataPoint = LineChartDataPoint(value: Double(record.fields.numberOfNewDeathsInLast24Hrs ?? 0), xAxisLabel: "\(record.fields.date ?? "")", description: "\(record.fields.date ?? "")")
                        chartStyle.topLine = .maximum(of: Double(record.fields.numberOfNewDeathsInLast24Hrs ?? 0))
                        metadata   = ChartMetadata(title: "Death Cases", subtitle: "Death cases in the past 24 hours")
                        data.legendTitle = "Death Cases"
                        self.inProgress = false
                    default:
                        dataPoint = LineChartDataPoint(value: Double(record.fields.numberOfNewPositiveCasesInLast24Hrs ?? 0), xAxisLabel: "\(record.fields.date ?? "")", description: "\(record.fields.date ?? "")")
                        chartStyle.topLine = .maximum(of: Double(record.fields.numberOfNewPositiveCasesInLast24Hrs ?? 0))
                        metadata   = ChartMetadata(title: "Positive Cases", subtitle: "positive COVID-19 cases in the past 24 hours")
                        data.legendTitle = "Positive Cases"
                        self.inProgress = false
                    }
                    data.dataPoints.append(dataPoint)
                }
                completion(LineChartData(dataSets: data, metadata: metadata, chartStyle     : chartStyle))
            case .failure(_):
                self.inProgress = false
                return
            }
        }
        
        
    }
    
    func groupBoxTitle() -> String {
        switch lineChartType {
        case .numberOfNewPositiveCasesInLast24Hrs:
            return "Positive cases in the last 24 hours"
        case .totalNumberOfDeathsToDate:
            return "Total number of deaths to date"
        case .totalNumberOfActiveCasesUndergoingTreatmentToDate:
            return "Total number of active cases undergoing treatment"
        case .numberOfNewAcuteHospitalAdmissionsInLast24Hrs:
            return "Number of new acute hospital addmissions in the last 24 hours"
        case .numberOfNewTestsInLast24Hrs:
            return "Number of new tests in the last 24 hours"
        case .totalNumberOfVaccineDosesAdministeredInLast24Hrs:
            return "Total number of vaccine doses administered in the last 24 hours"
        case .totalNumberOfAcuteCasesUnderHospitalTreatment:
            return "Total number of acute cases under Hospital treatment"
        case .totalNumberOfCasesUnderIcuTreatment:
            return "Total number of cases under ICU treatment"
        case .numberOfNewIcuAdmissionsInLast24Hrs:
            return "Number of new ICU admissions in the last 24 hours"
        case .totalNumberOfVaccineDosesAdministeredSinceStart:
            return "Total number of vaccine doses administered to date"
        case .numberOfNewDeathsInLast24Hrs:
            return "Number of new deaths in the last 24 hours"
        case .totalNumberOfTestsToDate:
            return "Total number of test to date"
        case .numberOfNewRecoveredCasesInLast24Hrs:
            return "Number of new recovered cases in the last 24 hours"
        case .totalNumberOfRecoveredCasesToDate:
            return "Number of recovered cases to date"
        case .totalNumberOfPositiveCasesToDate:
            return "Total number of positive cases to date"
        }
    }
    
    func chartTitle() -> String {
        switch lineChartType {
        case .numberOfNewPositiveCasesInLast24Hrs:
            return "Positive Cases"
        case .totalNumberOfAcuteCasesUnderHospitalTreatment:
            return "Current Hospitalized"
        case .totalNumberOfActiveCasesUndergoingTreatmentToDate:
            return "Current Active"
        case .totalNumberOfCasesUnderIcuTreatment:
            return "Current ICU Cases"
        case .numberOfNewDeathsInLast24Hrs:
            return "Deaths in the last 24 hours"
        case .numberOfNewRecoveredCasesInLast24Hrs:
            return "Recoveries in the last 24 hours"
        default:
            return ""
        }
    }
}

enum ChartType: String {
    case numberOfNewPositiveCasesInLast24Hrs = "number_of_new_positive_cases_in_last_24_hrs"
    case totalNumberOfDeathsToDate = "total_number_of_deaths_to_date"
    case totalNumberOfActiveCasesUndergoingTreatmentToDate = "total_number_of_active_cases_undergoing_treatment_to_date"
    case numberOfNewAcuteHospitalAdmissionsInLast24Hrs = "number_of_new_acute_hospital_admissions_in_last_24_hrs_dd_lhlt_lhd_ljdyd_lty_tm_dkhlh_fy_lmstshf_khl"
    case numberOfNewTestsInLast24Hrs = "number_of_new_tests_in_last_24_hrs"
    case totalNumberOfVaccineDosesAdministeredInLast24Hrs = "total_number_of_vaccine_doses_administered_in_last_24_hrs_jmly_dd_jr_t_llqh_lty_tm_tw_h_khll_24_s_lm"
    case totalNumberOfAcuteCasesUnderHospitalTreatment = "total_number_of_acute_cases_under_hospital_treatment_jmly_dd_lhlt_lhd_tht_l_lj_fy_lmstshf"
    case totalNumberOfCasesUnderIcuTreatment = "total_number_of_cases_under_icu_treatment_jmly_dd_lhlt_tht_l_lj_fy_l_ny_lmrkz"
    case numberOfNewIcuAdmissionsInLast24Hrs = "number_of_new_icu_admissions_in_last_24_hrs_dd_lhlt_ljdyd_lty_tm_dkhlh_fy_l_ny_lmrkz_khll_l_24_s_lmd"
    case totalNumberOfVaccineDosesAdministeredSinceStart = "total_number_of_vaccine_doses_administered_since_start_of_vaccination_campaign_jmly_dd_jr_t_llqh_lty"
    case numberOfNewDeathsInLast24Hrs = "number_of_new_deaths_in_last_24_hrs"
    case totalNumberOfTestsToDate = "total_number_of_tests_to_date"
    case numberOfNewRecoveredCasesInLast24Hrs = "number_of_new_recovered_cases_in_last_24_hrs"
    case totalNumberOfRecoveredCasesToDate = "total_number_of_recovered_cases_to_date"
    case totalNumberOfPositiveCasesToDate = "total_number_of_positive_cases_to_date"
}
