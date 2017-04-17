//
//  Test.swift
//  MonitorMiddleware
//
//  Created by Mauro Bolis on 16/04/2017.
//
//

import Foundation
import Katana

/**
 The configuration of the monitor middleware
*/
public struct Configuration {
  
  /// The host of the monitor server
  let host: String
  
  /// The port of the monitor server
  let port: Int
  
  /// Default configuration. It works with simulator
  public static let defaultConfiguration = Configuration(host: "localhost", port: 8000)
  
  /**
   Creates a configuration
   
   - parameter host: the host of the monitor server
   - parameter port: the port of the monitor server
  */
  public init(host: String, port: Int) {
    self.host = host
    self.port = port
  }
}

/**
 A middleware that can be used to show actions and state diffs in the browser.
 See the readme for the whole setup
*/
public struct MonitorMiddleware {
  
  /**
   Create a middleware with the given configuration
  */
  public static func create(using configuration: Configuration) -> StoreMiddleware {
    // create the operation queue to handle the message send
    let queue = OperationQueue()
    queue.maxConcurrentOperationCount = 1
    queue.qualityOfService = .default
    queue.isSuspended = true
    
    return { getState, dispatch in
      
      // start socket comunication
      let client = SCSocket.client()!
      client.initWithHost(configuration.host, onPort: configuration.port, securely: false)
      client.connect()
      
      return { next in
        return { action in
          next(action)
          
          queue.isSuspended = client.getState() != SOCKET_STATE_OPEN
          let operation = SendActionToMonitor(state: getState(), action: action, socket: client)
          queue.addOperation(operation)
        }
      }
    }
  }
}

/// Operation that handles the serialization and communication with the remote monitor
fileprivate class SendActionToMonitor: Operation {
  private let state: State
  private let action: Action
  private unowned let socket: SCSocket
  
  init(state: State, action: Action, socket: SCSocket) {
    self.state = state
    self.action = action
    self.socket = socket
  }
  
  override func main() {
    let serializedState = MonitorSerialization.convertValueToDictionary(self.state)
    var serializedAction = MonitorSerialization.convertValueToDictionary(self.action)
    
    if var sAction = serializedAction as? [String: Any] {
      // add type to nicely show the action name in the UI
      sAction["type"] = String(reflecting: type(of: self.action))
      serializedAction = sAction
    }
    
    let data: [String: Any] = [
      "type": "ACTION",
      "id": self.socket.socketId,
      "action": [
        "action": serializedAction,
        "timestamp": Date().timeIntervalSinceReferenceDate
      ],
      "payload": serializedState ?? "No_state"
    ]

    socket.emitEvent("log", withData: data)
  }
}
