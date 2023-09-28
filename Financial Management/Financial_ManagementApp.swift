//
//  Financial_ManagementApp.swift
//  Financial Management
//
//  Created by Vladyslav Behim on 20.09.2023.
//

import SwiftUI

public var screenWidth: CGFloat {
    return UIScreen.main.bounds.width
}

public var screenHeight: CGFloat {
    return UIScreen.main.bounds.height
}
@main
struct Financial_ManagementApp: App {
    var body: some Scene {
        WindowGroup {
            MainView()
                
        }
    }
}
