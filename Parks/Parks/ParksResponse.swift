//
//  ParksResponse.swift
//  Parks
//
//  Created by Jose Folgar on 3/24/24.
//

import Foundation

struct ParksResponse: Codable {
    let data: [Park]
}

struct Park: Codable, Identifiable, Hashable, Equatable {
    let id: String
    let fullName: String
    let description: String
    let latitude: String
    let longitude: String
    let images: [ParkImage]
    let name: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct ParkImage: Codable, Identifiable, Equatable {
    let title: String
    let caption: String
    let url: String
    
    var id: String {
        return url
    }
}

extension Park {
    static var mocked: Park {
        let jsonUrl = Bundle.main.url(forResource: "park_mock", withExtension: "json")!
        let data = try! Data(contentsOf: jsonUrl)
        let park = try! JSONDecoder().decode(Park.self, from: data)
        return park
    }
}
