//
//  ChartViewModel.swift
//  COVID Qatar
//
//  Created by Omar Al-Ansari on 3/28/21.
//

import SwiftUI

class ChartViewViewModel: ObservableObject {
    
    private var serviceAPI = ServicesAPI()
    @Published var inProgress = false
    @Published var numberOfCases = [CGFloat]()
    @Published var chartNumberOfDaysTab = 1
    @Published var chartPositiveOrDeathTab = 0
    @Published var chartType = "line"
    @Published var lineChartType: ChartType = .numberOfNewPositiveCasesInLast24Hrs
    
    init() {
        fetchData(for: lineChartType)
    }
    
    func fetchData(for chartType: ChartType) {
        inProgress = true
        numberOfCases.removeAll()
        serviceAPI.fetchData(numberOfDays: chartNumberOfDaysTab == 0 ? 30 : chartNumberOfDaysTab == 1 ? 90 : chartNumberOfDaysTab == 2 ? 180 : -1) { results in
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
                    
//                    self.numberOfCases.append(self.chartPositiveOrDeathTab == 0 ? CGFloat(record.fields.numberOfNewPositiveCasesInLast24Hrs ?? 0) : self.chartPositiveOrDeathTab == 1 ? CGFloat(record.fields.numberOfNewDeathsInLast24Hrs ?? 0) : (CGFloat(record.fields.numberOfNewPositiveCasesInLast24Hrs ?? 0) / CGFloat(record.fields.numberOfNewTestsInLast24Hrs ?? 0)) * 100)
                }
                self.inProgress = false
            case .failure(let err):
                self.inProgress = false
                print(err.localizedDescription)
            }
        }
    }
    
    
    func groupBoxTitle() -> String {
        if chartType == "line" {
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
        return ""
    }
    
    func chartTitle() -> String {
        if chartType == "line" {
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
        return ""
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
