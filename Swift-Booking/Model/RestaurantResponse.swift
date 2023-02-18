//
//  RestaurantResponse.swift
//  Swift-Booking
//
//  Created by Deep Baath on 18/02/23.
//


import Foundation

extension RestaurantResponse {
    init(data: Data) throws {
        self = try JSONDecoder().decode(RestaurantResponse.self, from: data)
    }
}

//// MARK: - RestaurantResponse
struct RestaurantResponse: Codable {
    let status: Int?
    let message: String?
    let listed: [Restaurant]?

    enum CodingKeys: String, CodingKey {
        case status = "status"
        case message = "message"
        case listed = "listed"
    }
}

// MARK: - Listed
struct Restaurant: Codable {
    let businessName: String?
    let image: String?
    let rating: String?
    let id: String?
    let address: String?
    let description: String?
    let restaurantType: [RestaurantType]?
    let timeAvailable: [TimeAvailable]?
    let seatAvailable: String?
    let getTime: String?
    let serviceProvider: String?
    let price: Price?

    enum CodingKeys: String, CodingKey {
        case businessName = "business_name"
        case image = "image"
        case rating = "rating"
        case id = "id"
        case address = "address"
        case description = "description"
        case restaurantType = "restaurant_type"
        case timeAvailable = "time_available"
        case seatAvailable = "seat_available"
        case getTime = "get_time"
        case serviceProvider = "service_provider"
        case price = "price"
    }
}

enum Price: Codable {
    case integer(Int)
    case string(String)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Int.self) {
            self = .integer(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        throw DecodingError.typeMismatch(Price.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for Price"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .integer(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }
}

// MARK: - RestaurantType
struct RestaurantType: Codable {
    let name: String?
    let id: String?

    enum CodingKeys: String, CodingKey {
        case name = "name"
        case id = "id"
    }
}

// MARK: - TimeAvailable
struct TimeAvailable: Codable {
    let time: String?

    enum CodingKeys: String, CodingKey {
        case time = "time"
    }
}
