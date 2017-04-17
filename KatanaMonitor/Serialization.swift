//
//  Serialization.swift
//  MonitorMiddleware
//
//  Created by Mauro Bolis on 16/04/2017.
//
//

import Foundation

protocol Monitorable {
  var monitorValue: Any { get }
}

extension Monitorable {
  var monitorValue: Any { return self }
}

extension String: Monitorable {}
extension Int: Monitorable {}
extension CGFloat: Monitorable {}
extension Double: Monitorable {}

extension Array: Monitorable {
  var monitorValue: Any {
    return self.map { MonitorSerialization.convertValueToDictionary($0) }
  }
}

extension Dictionary: Monitorable {
  var monitorValue: Any {
    var monitorDict: [String: Any] = [:]
    
    for (key, value) in self {
      monitorDict["\(key)"] = MonitorSerialization.convertValueToDictionary(value)
    }
    
    return monitorDict
  }
}

/// Serialize items using reflection
struct MonitorSerialization {
  private init() {}
  
  static func convertValueToDictionary(_ value: Any) -> Any? {
    if let v = value as? Monitorable {
      // directly representable
      return v.monitorValue
    }
  
    let mirror = Mirror(reflecting: value)
    
    guard mirror.displayStyle == .struct else {
      // not a struct, but we haven't managed it properly
      // best effort.. return the stringification
      return String(reflecting: value)
    }

    var result: [String: Any] = [:]
    
    for (key, child) in mirror.children {
      guard let key = key else {
        continue
      }
      
      result[key] = MonitorSerialization.convertValueToDictionary(child)
    }
    
    return result
  }
}
