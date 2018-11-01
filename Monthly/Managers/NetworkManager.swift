//
//  NetworkManager.swift
//  Monthly
//
//  Created by Denis Litvin on 10/30/18.
//  Copyright © 2018 Denis Litvin. All rights reserved.
//

import Foundation
import Moya

enum General {
    case image(String)
}

extension General: TargetType {
    var baseURL: URL { return URL(string: "https://logo.clearbit.com")! }
    
    var path: String {
        switch self {
        case .image(let companyName): return "/\(companyName).com"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .image: return .get
        }
    }
    
    var sampleData: Data {
        switch self {
        case .image: return UIImagePNGRepresentation(UIImage(named: "signature")!)!
        }
    }
    
    var task: Moya.Task {
        return .requestParameters(parameters: ["size": Int(33 * UIScreen.main.scale)], encoding: URLEncoding.default)
    }
    
    var headers: [String : String]? {
        return nil
    }
}
