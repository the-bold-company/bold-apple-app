//
//  BaseTargetType.swift
//
//
//  Created by Hien Tran on 23/11/2023.
//

import Foundation
import Moya

public protocol BaseTargetType: TargetType {}

public extension BaseTargetType {
    var baseURL: URL {
        // TODO: Use environment flag to set up different schemes
        // TODO: Move base url to env variable
//        guard let url = URL(string: "http://ec2-13-250-60-209.ap-southeast-1.compute.amazonaws.com/api") else {
        guard let url = URL(string: "http://ec2-13-229-86-105.ap-southeast-1.compute.amazonaws.com/api") else {
            preconditionFailure("Missing base URL in \(String(describing: self))")
        }
        return url
    }

    var headers: [String: String]? {
        return nil
    }
}
