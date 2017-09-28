//
//  FirebaseDestination.swift
//  XCGLogger+Firebase
//
//  Created by Oleksii Shvachenko on 9/27/17.
//  Copyright © 2017 oleksii. All rights reserved.
//

import Foundation
import XCGLogger
import FirebaseCommunity
import CryptoSwift

extension LogDetails {
  var json: [String: Any] {
    return [
      "level": level.description,
      "date": ISO8601DateFormatter().string(from: date),
      "message": message,
      "functionName": functionName,
      "fileName": fileName,
      "lineNumber": lineNumber
    ]
  }
}

public class FirebaseDestination: BaseDestination {
  private let firebaseRef: DatabaseReference
  private let aesEncoder: AES
  /**
   Designated initialization

   - Parameter encryptionKey: key to use in AES 128 encryption.
   - Parameter firebaseSettingsPath: path to plist generated by goole, Bundle.main.path(forResource: "FirebaseSetting", ofType: "plist").
   */
  public init?(encryptionKey: String, firebaseSettingsPath: String) {
    guard let options = FirebaseOptions(contentsOfFile: firebaseSettingsPath) else {
      return nil
    }
    guard let aesEncoder = try? AES(key: encryptionKey, iv: "0123456789012345") else {
      return nil
    }
    self.aesEncoder = aesEncoder
    FirebaseApp.configure(name: "FirebaseLogs", options: options)
    let app = FirebaseApp.app(name: "FirebaseLogs")!
    let database = Database.database(app: app)
    database.isPersistenceEnabled = true
    firebaseRef = Database.database(app: app).reference()
  }
  
  public override func output(logDetails: LogDetails, message: String) {
    var logDetails = logDetails
    var message = message
    // Apply filters, if any indicate we should drop the message, we abort before doing the actual logging
    guard !self.shouldExclude(logDetails: &logDetails, message: &message) else { return }

    self.applyFormatters(logDetails: &logDetails, message: &message)
    //store log detail
    let encryptedDaga = encryptLogData(logDetails: logDetails)
    firebaseRef.child("Logs").child(message.md5()).setValue(encryptedDaga)
  }

  private func encryptLogData(logDetails: LogDetails) -> String {
    let data = try! JSONSerialization.data(withJSONObject: logDetails.json, options: JSONSerialization.WritingOptions(rawValue: 0))
    let raw = try! aesEncoder.encrypt(data)
    let encryptedData = Data(bytes: raw)
    return encryptedData.toHexString()
  }
}
