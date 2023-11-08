import Foundation

struct SummonerLeagueEntry: Codable {
    let tier: String
    let rank: String
    let wins: Int
    let losses: Int
    
    enum CodingKeys: String, CodingKey {
        case tier, rank, wins, losses
    }
}
