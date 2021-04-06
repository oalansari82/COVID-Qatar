//
//  CovidData.swift
//  COVID Qatar
//
//  Created by Omar Al-Ansari on 3/28/21.
//

import Foundation

import Foundation

struct CovidData: Codable {
  struct Records: Codable, Hashable {
    struct Fields: Codable, Hashable {
      let numberOfNewPositiveCasesInLast24Hrs: Int?
      let totalNumberOfDeathsToDate: Int?
      let totalNumberOfActiveCasesUndergoingTreatmentToDate: Int?
      let numberOfNewAcuteHospitalAdmissionsInLast24Hrs: Int?
      let numberOfNewTestsInLast24Hrs: Int?
      let totalNumberOfVaccineDosesAdministeredInLast24Hrs: Int?
      let totalNumberOfAcuteCasesUnderHospitalTreatment: Int?
      let totalNumberOfCasesUnderIcuTreatment: Int?
      let numberOfNewIcuAdmissionsInLast24Hrs: Int?
      let totalNumberOfVaccineDosesAdministeredSinceStart: String?
      let numberOfNewDeathsInLast24Hrs: Int?
      let totalNumberOfTestsToDate: Int?
      let date: String?
      let numberOfNewRecoveredCasesInLast24Hrs: Int?
      let totalNumberOfRecoveredCasesToDate: Int?
      let totalNumberOfPositiveCasesToDate: Int?

      private enum CodingKeys: String, CodingKey {
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
        case date
        case numberOfNewRecoveredCasesInLast24Hrs = "number_of_new_recovered_cases_in_last_24_hrs"
        case totalNumberOfRecoveredCasesToDate = "total_number_of_recovered_cases_to_date"
        case totalNumberOfPositiveCasesToDate = "total_number_of_positive_cases_to_date"
      }
        
        init() {
            self.numberOfNewPositiveCasesInLast24Hrs = 0
            self.totalNumberOfDeathsToDate = 0
            self.totalNumberOfActiveCasesUndergoingTreatmentToDate = 0
            self.numberOfNewAcuteHospitalAdmissionsInLast24Hrs = 0
            self.numberOfNewTestsInLast24Hrs = 0
            self.totalNumberOfVaccineDosesAdministeredInLast24Hrs = 0
            self.totalNumberOfAcuteCasesUnderHospitalTreatment = 0
            self.totalNumberOfCasesUnderIcuTreatment = 0
            self.numberOfNewIcuAdmissionsInLast24Hrs = 0
            self.totalNumberOfVaccineDosesAdministeredSinceStart = ""
            self.numberOfNewDeathsInLast24Hrs = 0
            self.totalNumberOfTestsToDate = 0
            self.date = ""
            self.numberOfNewRecoveredCasesInLast24Hrs = 0
            self.totalNumberOfRecoveredCasesToDate = 0
            self.totalNumberOfPositiveCasesToDate = 0
        }
    }

    let datasetid: String
    let recordid: String
    let fields: Fields
    let recordTimestamp: String

    private enum CodingKeys: String, CodingKey {
      case datasetid
      case recordid
      case fields
      case recordTimestamp = "record_timestamp"
    }
  }

  let records: [Records]

  private enum CodingKeys: String, CodingKey {
    case records
  }
}
