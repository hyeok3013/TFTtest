import Foundation

struct TFTLeagueStats: Codable {
    let wins: Int
    let losses: Int
    
    enum CodingKeys: String, CodingKey {
        case wins, losses
    }
}
