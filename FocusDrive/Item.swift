//
//  Item.swift
//  FocusDrive
//
//  Created by Jiawei Zhao on 10/27/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
