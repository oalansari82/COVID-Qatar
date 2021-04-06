//
//  AlertType.swift
//  COVID Qatar
//
//  Created by Omar Al-Ansari on 3/31/21.
//

import SwiftUI

enum AlertType: Identifiable {
    case ok(title: String, message: String? = nil)
    case singleButton(title: String, message: String? = nil, dismisButton: Alert.Button)
    case twoButtons(title: String, message: String? = nil, primaryButton: Alert.Button, secondaryButton: Alert.Button)
    
    var id: String {
        switch self {
        case .ok:
            return "ok"
        case .singleButton:
            return "singleButton"
        case .twoButtons:
            return "twoButtons"
        }
    }
    
    var alert: Alert {
        switch self {
        
        case .ok(title: let title, message: let message):
            return Alert(title: Text(title), message: message != nil ? Text(message!) : nil)
        case .singleButton(title: let title, message: let message, dismisButton: let dismisButton):
            return Alert(title: Text(title), message: message != nil ? Text(message!) : nil, dismissButton: dismisButton)
        case .twoButtons(title: let title, message: let message, primaryButton: let primaryButton, secondaryButton: let secondaryButton):
            return Alert(title: Text(title), message: message != nil ? Text(message!) : nil, primaryButton: primaryButton, secondaryButton: secondaryButton)
        }
    }
}
