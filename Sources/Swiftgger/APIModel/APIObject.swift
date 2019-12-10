//
//  APIObject.swift
//  Swiftgger
//
//  Created by Marcin Czachurski on 02.04.2018.
//

import Foundation

/// Information about (request/response) Swift object.
public class APIObject {
    let object: Any
    let defaultName: String 
    let customName: String?

    public init(object: Any, type: Any.Type, customName: String? = nil) {
        self.object = object
        self.customName = customName
        self.defaultName = String(reflecting: type).components(separatedBy: "App.").last ?? String(describing: type)
    }
}
