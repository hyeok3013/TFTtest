import SwiftUI
import Alamofire

struct ContentView: View {
    @State var summonerName = ""
    @State var isName = false
    var apiKey = "RGAPI-cd11dc86-9f4e-465d-afee-58d07682d8aa"
    var tier = "DIAMOND"
    var division = "III"
    @State var totalWins = 0
    @State var totalLosses = 0
    @State var summonerTotalGames = 0
    @State var summonerWinningRate: Double = 0
    @State var TotalWinningRate: Double = 0
    
    
    var body: some View {
        VStack {
            
            if summonerWinningRate == TotalWinningRate {
                
                Text("당신은 재능충일까요?")
                Text("판수충일까요?")
                Text("여기서 충은 충실할 충입니다")
            }else if summonerWinningRate > TotalWinningRate{
                
                Text("재능충")
            }else {
                Text("판수충")
            }
            
            TextField("소환사 닉네임을 입력해주세요.", text: $summonerName)
                .textFieldStyle(.roundedBorder)
                .frame(width: 300)
                .padding(.bottom, 30)
            
            Button(action: {
                let urlString = "https://kr.api.riotgames.com/tft/summoner/v1/summoners/by-name/\(summonerName)?api_key=\(apiKey)"
                
                AF.request(urlString)
                    .validate(statusCode: 200..<300)
                //                    .validate(contentType: ["application/json"])
                    .responseData { response in
                        switch response.result {
                        case .success:
                            print("Validation Successful")
                            debugPrint(response)
                            
                        case let .failure(error):
                            isName.toggle()
                            print(error)
                            debugPrint(response)
                        }
                    }
                
            }, label: {
                Text("Button")
            })
            .buttonStyle(.borderedProminent)
            
            Button(action: {
                let urlString = "https://kr.api.riotgames.com/tft/summoner/v1/summoners/by-name/\(summonerName)?api_key=\(apiKey)"
                
                AF.request(urlString).responseDecodable(of: SummonerInfo.self) { response in
                    switch response.result {
                    case .success(let summonerInfo):
                        print("Account ID: \(summonerInfo.id)")
                        let urlString = "https://kr.api.riotgames.com/tft/league/v1/entries/by-summoner/\(summonerInfo.id)?api_key=\(apiKey)"
                        
                        AF.request(urlString).responseDecodable(of: [SummonerLeagueEntry].self) { response in
                            switch response.result {
                            case .success(let leagueEntries):
                                for entry in leagueEntries {
                                    print("Tier: \(entry.tier), Rank: \(entry.rank), Wins: \(entry.wins), Losses: \(entry.losses)")
                                }
                                
                                let summonerWins = leagueEntries.reduce(0) { $0 + $1.wins }
                                let summonerLosses = leagueEntries.reduce(0) { $0 + $1.losses }
                                summonerTotalGames = summonerWins + summonerLosses
                                summonerWinningRate = Double(summonerWins) / Double(summonerTotalGames) * 100
                                print("\(summonerTotalGames * 30 / 60)시간 게임하셨습니다")

                                
                                
                                print(summonerTotalGames)
                                print(summonerWinningRate)
                                
                                
                                let urlString = "https://kr.api.riotgames.com/tft/league/v1/entries/\(tier)/\(division)?queue=RANKED_TFT&page=1&api_key=\(apiKey)"
                                
                                AF.request(urlString).responseDecodable(of: [TFTLeagueStats].self) { response in
                                    switch response.result {
                                    case .success(let tftEntries):
                                        for entry in tftEntries {
                                            // 여기에서 Wins와 Losses만 처리합니다.
                                            print("Wins: \(entry.wins), Losses: \(entry.losses)")
                                            
                                        }
                                        totalWins += tftEntries.reduce(0) { $0 + $1.wins }
                                        totalLosses += tftEntries.reduce(0) { $0 + $1.losses }
                                        
                                        
                                        // 평균 승률 계산
                                        let winRate = Double(totalWins) / Double(totalWins + totalLosses)
                                        TotalWinningRate = winRate * 100
                                        print("총 평균 승률: \(winRate * 100)%")
                                        
                                        // 평균 게임 수 계산
                                        let averageGames = Double(totalWins + totalLosses) / Double(tftEntries.count)
                                        print("평균 게임 수: \(averageGames)")
                                        
                                        
                                        
                                        
                                        
                                        
                                        
                                    case .failure(let error):
                                        print("Error: \(error)")
                                    }
                                }
                                
                                
                            case .failure(let error):
                                print("Error: \(error)")
                            }
                        }
                        
                        
                    case .failure(let error):
                        print("Error: \(error)")
                    }
                }
                
                
            }, label: {
                Text("Button")
            })
            .buttonStyle(.borderedProminent)
            
        }
        .alert(isPresented: $isName) {
            Alert(title: Text("오류"), message: Text("잘못된 소환사 닉네임입니다."), dismissButton: .default(Text("확인")))
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
