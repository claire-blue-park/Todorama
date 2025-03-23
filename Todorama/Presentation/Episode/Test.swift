////
////  Test.swift
////  Todorama
////
////  Created by Claire on 3/22/25.
////
//
//import UIKit
//
//// MARK: - Series Model
//
//struct Series {
//    let id: String
//    let title: String
//    let episodeCount: Int
//    let posterImage: UIImage?
//    let backdropImage: UIImage?
//    let synopsis: String
//    let channel: String
//    let year: String
//    let genre: String
//    let episodes: [Episode]
//}
//
//// MARK: - Episode Model
//
////struct Episode {
//    let id: String
//    let number: Int
//    let title: String
//    let duration: String
//    let broadcastDate: String
//    let description: String
//    let thumbnailImage: UIImage?
//    var isWatched: Bool
//}
//
//// MARK: - DummyData
//
//class DummyData {
//    
//    static let shared = DummyData()
//    
//    lazy var series: [Series] = createDummySeries()
//    
//    private func createDummySeries() -> [Series] {
//        let hospitalPlaylife = Series(
//            id: "hospital-playlife",
//            title: "슬기로운 의사생활",
//            episodeCount: 12,
//            posterImage: nil,
//            backdropImage: nil,
//            synopsis: "친구가 곁에 있으면 하루하루가 특별해지는, 인생의 축소판이라 불리는 병원에서 평생을 함께한 다섯 친구의 이야기. 그들의 드라마.",
//            channel: "tvN",
//            year: "2020",
//            genre: "의학 드라마",
//            episodes: createHospitalPlaylifeEpisodes()
//        )
//        
//        let hospitalPlaylifeS1 = Series(
//            id: "hospital-playlife-s1",
//            title: "슬기로운 의사생활 시즌 1",
//            episodeCount: 12,
//            posterImage: nil,
//            backdropImage: nil,
//            synopsis: "친구가 곁에 있으면 하루하루가 특별해지는, 인생의 축소판이라 불리는 병원에서 평생을 함께한 다섯 친구의 이야기. 그들의 드라마",
//            channel: "tvN",
//            year: "2020",
//            genre: "의학 드라마",
//            episodes: createHospitalPlaylifeEpisodes()
//        )
//        
//        let hospitalPlaylifeS2 = Series(
//            id: "hospital-playlife-s2",
//            title: "슬기로운 의사생활 시즌 2",
//            episodeCount: 12,
//            posterImage: nil,
//            backdropImage: nil,
//            synopsis: "누구가는 태어나고 누구가는 삶을 끝내는 단생과 죽음이 공존하는, 인생의 축소판이라 불리는 병원에서 평범한 듯 특별한 하루하루를 살아가는 사람들과 눈빛만 봐도 알 수 있는 20년지기 친구들의 케미 스토리를 담은 드라마",
//            channel: "tvN",
//            year: "2021",
//            genre: "의학 드라마",
//            episodes: createHospitalPlaylifeS2Episodes()
//        )
//        
//        let hospitalPlaylifeSpecial = Series(
//            id: "hospital-playlife-special",
//            title: "슬기로운 의사생활 스페셜",
//            episodeCount: 4,
//            posterImage: nil,
//            backdropImage: nil,
//            synopsis: "슬기로운 의사생활 스페셜 에피소드",
//            channel: "tvN",
//            year: "2022",
//            genre: "의학 드라마",
//            episodes: createHospitalPlaylifeSpecialEpisodes()
//        )
//        
//        return [hospitalPlaylife, hospitalPlaylifeS1, hospitalPlaylifeS2, hospitalPlaylifeSpecial]
//    }
//    
//    private func createHospitalPlaylifeEpisodes() -> [Episode] {
//        return [
//            Episode(
//                id: "s1-e1",
//                number: 1,
//                title: "1화",
//                duration: "1시간 23분",
//                broadcastDate: "2020. 03. 12 방영",
//                description: "99학번 의예과 동기네기 친구들, 영원할 줄 알았던 친구들과의 우정은 점점 희미해지고, 이젠 내 옆에 있는 환자 보기에도 24시간이 부족한 40대 '의사'가 되었다. 그렇게 각기 다른 인생 형태로 살아가던 다섯 명의 친구들에게 한 통의 전화가 걸려오는데!",
//                thumbnailImage: nil,
//                isWatched: true
//            ),
//            Episode(
//                id: "s1-e2",
//                number: 2,
//                title: "2화",
//                duration: "1시간 23분",
//                broadcastDate: "2020. 03. 19 방영",
//                description: "정원의 제안으로, 20년 만에 한 병원에서 만나게 된 친구들. 그동안 마음 한켠 쌓였던 서로에 대한 진심에 불과는 시간도 잠시 흘러 오늘도 각자 한 사람의 의사로서 최선을 다할 뿐이다. 한편, 송화는 환자 차트에서 예민지 낯설지 않은 이름을 발견하는데...",
//                thumbnailImage: nil,
//                isWatched: false
//            ),
//            Episode(
//                id: "s1-e3",
//                number: 3,
//                title: "3화",
//                duration: "1시간 29분",
//                broadcastDate: "2020. 03. 26 방영",
//                description: "세상에서 가장 신성한 직업인 의사가 되기 위해 인턴 때부터 쌓아온 세상의 편견과 기대를 스스로도 믿었던 준완. 그러나 응급실에서 벌어진 일을 계기로 의사로서의 윤리와 신념이 흔들리게 되고, 익숙했던 자신의 세계가 무너져 내리는 것을 느끼는데...",
//                thumbnailImage: nil,
//                isWatched: false
//            )
//        ]
//    }
//    
//    private func createHospitalPlaylifeS2Episodes() -> [Episode] {
//        return [
//            Episode(
//                id: "s2-e1",
//                number: 1,
//                title: "1화",
//                duration: "1시간 28분",
//                broadcastDate: "2021. 06. 17 방영",
//                description: "봄날의 유키스가 봄에 돌아왔다. 겨우내 움츠렸던 세상이 봄과 함께 다시 활기를 찾는 유제병원. 오늘도 누군가는 태어나고, 누군가는 떠나가는 일상의 기적들이 서로 뒤엉켜 하나의 드라마를 이룬다. 누구에게는 평범한 하루가 누구에게는 생의 마지막 하루가 되는 병원에서의 봄날.",
//                thumbnailImage: nil,
//                isWatched: false
//            ),
//            Episode(
//                id: "s2-e2",
//                number: 2,
//                title: "2화",
//                duration: "1시간 28분",
//                broadcastDate: "2021. 06. 24 방영",
//                description: "99학번 의대생에서 어느덧 20년 차 의사가 된 다섯 친구들. 이제는 늘 그랬듯이 함께 의사의 삶을 살아간다. 익숙한 일상 속에서도 위태로운 균형을 유지하는 하루하루. 오늘도 유제병원에는 각자의 사연을 안고 찾아온 환자들로 북적인다.",
//                thumbnailImage: nil,
//                isWatched: false
//            ),
//            Episode(
//                id: "s2-e3",
//                number: 3,
//                title: "3화",
//                duration: "1시간 28분",
//                broadcastDate: "2021. 07. 01 방영",
//                description: "익숙하고 평범한 일상에 작은 변화가 찾아온다. 송화의 제안으로 밴드 활동을 시작한 다섯 친구들. 바쁜 병원 생활 속에서도 음악을 통해 잠시나마 청춘의 열정을 되찾는다. 한편, 정원의 진료실에는 특별한 환자가 찾아오고, 이를 통해 드러나는 예상치 못한 과거의 인연.",
//                thumbnailImage: nil,
//                isWatched: false
//            )
//        ]
//    }
//    
//    private func createHospitalPlaylifeSpecialEpisodes() -> [Episode] {
//        return [
//            Episode(
//                id: "special-e1",
//                number: 1,
//                title: "슬기로운 의사생활 특별편: 우정",
//                duration: "1시간 40분",
//                broadcastDate: "2022. 01. 05 방영",
//                description: "99학번 의예과 동기들의 20년 우정 이야기. 의대생 시절부터 현재까지, 다섯 친구들이 함께한 크고 작은 순간들. 서로에게 의지하고 성장하며 쌓아온 특별한 우정의 순간들을 담은 특별편.",
//                thumbnailImage: nil,
//                isWatched: false
//            ),
//            Episode(
//                id: "special-e2",
//                number: 2,
//                title: "슬기로운 의사생활 특별편: 사랑",
//                duration: "1시간 42분",
//                broadcastDate: "2022. 01. 12 방영",
//                description: "유제병원에서 피어난 다양한 형태의 사랑 이야기. 환자와 의사 사이, 동료 사이, 그리고 오랜 친구 사이에서 피어나는 특별한 감정들. 때로는 아프고 때로는 달콤한 사랑의 순간들을 담은 특별편.",
//                thumbnailImage: nil,
//                isWatched: false
//            )
//        ]
//    }
//    
//    func getSeriesById(_ id: String) -> Series? {
//        return series.first { $0.id == id }
//    }
//}
