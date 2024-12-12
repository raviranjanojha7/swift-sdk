//
//  File.swift
//  swift-sdk
//
//  Created by Ravi Ranjan  Ojha on 12/12/24.
//

import CryptoKit
import Foundation

func sha256(_ input: String) -> String {
    let inputData = Data(input.utf8)
    let hashedData = SHA256.hash(data: inputData)
    return hashedData.compactMap { String(format: "%02x", $0) }.joined()
}