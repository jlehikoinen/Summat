//
//  Extensions.swift
//  Summat
//
//  Created by Janne Lehikoinen on 31.1.2022.
//

import SwiftUI

// Binding extension
func ??<T>(lhs: Binding<Optional<T>>, rhs: T) -> Binding<T> {
    Binding(
        get: { lhs.wrappedValue ?? rhs },
        set: { lhs.wrappedValue = $0 }
    )
}

extension UserDefaults {

    static func exists(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
}

extension UIDevice {
    
    static var isiPod: Bool {
        var systemInfo = utsname()
        uname(&systemInfo)
        let modelCode = withUnsafePointer(to: &systemInfo.machine) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) {
                ptr in String.init(validatingUTF8: ptr)
            }
        }
        
        if let code = modelCode {
            return code.contains("iPod")
            // return code.contains("arm64")
        }
        return false
    }
}

extension Bundle {
    
    var cfBundleShortVersionNumber: String? {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    var appVersionNumber: String {
        cfBundleShortVersionNumber ?? "1.0.0"
    }
}
