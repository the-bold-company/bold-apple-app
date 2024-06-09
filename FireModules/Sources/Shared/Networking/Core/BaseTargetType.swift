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
        // "http://ec2-13-250-60-209.ap-southeast-1.compute.amazonaws.com/api"
        // "http://ec2-13-229-86-105.ap-southeast-1.compute.amazonaws.com/api"
        // "https://ens3ci4on3.execute-api.ap-southeast-1.amazonaws.com/dev/iam-bold-api"
        guard let url = URL(string: "https://ens3ci4on3.execute-api.ap-southeast-1.amazonaws.com/dev/iam-bold-api") else {
            preconditionFailure("Missing base URL in \(String(describing: self))")
        }
        return url
    }

    var headers: [String: String]? {
        return nil
    }
}
