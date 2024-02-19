

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let info = try? JSONDecoder().decode(Info.self, from: jsonData)

import Foundation

// MARK: - InfoElement
public struct InfoElement: Codable {
    let version, date: String
}

public typealias Info = [InfoElement]
