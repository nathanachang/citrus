//
//  LoginResponse.swift
//  Citis
//
//  Created by Paul Minyoo Kim on 2/6/25.
//

import Foundation

struct LoginResponse: Decodable {
    let data: LoginResponseData
}

struct LoginResponseData: Decodable {
    let accessToken: String
    let refreshToken: String
}
