//
//  BundleHelper.swift
//  Kana
//
//  Created by Paul Kim on 10/28/24.
//

import Foundation

extension Bundle {
    static var testBundle: Bundle {
        class __ { }
        return Bundle(for: __.self)
    }
}
