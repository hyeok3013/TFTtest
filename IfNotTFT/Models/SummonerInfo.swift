import Foundation

struct SummonerInfo: Codable {
    let id: String
    
    enum CodingKeys: String, CodingKey {
        case id
    }
}
