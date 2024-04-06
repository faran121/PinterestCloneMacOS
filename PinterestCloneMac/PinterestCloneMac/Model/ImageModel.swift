//
//  ImageModel.swift
//  PinterestCloneMac
//
//  Created by Maliks on 30/03/2024.
//

import SwiftUI

struct ImageModel: Codable, Identifiable {
    var id: String
    var download_url: String
    var onHover: Bool?
}
