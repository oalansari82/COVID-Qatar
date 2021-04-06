//
//  Array+Extension.swift
//  COVID Qatar
//
//  Created by Omar Al-Ansari on 4/3/21.
//

import SwiftUI

extension Array where Element == CGFloat {
    // returns the elements of the sequence normalized
    var normalized: [CGFloat] {
        if let min = self.min(), let max = self.max() {
            return self.map { ($0 - min) / (max - min) }
        } else {
            return []
        }
    }
}
