//
//  Networker.swift
//  BedtimeStories
//
//  Created by Bao Van on 6/17/23.
//

import Foundation
import Alamofire
import AVFoundation

struct Story: Codable {
    let s1: Section
    let s2: Section
    let s3: Section
    let question: Question

    struct Section: Codable {
        let text: String
        let highlightedText: [String]?
        let imageUrl: String?
        let audioUrl: String
    }

    struct Question: Codable {
        let text: String
        let audioUrl: String
    }
}

struct Response: Codable {
    let data: Story
}

class StoryService {
    
    var audioPlayer: AVAudioPlayer?
    

    let sessionManager: Session = {
        let configuration = URLSessionConfiguration.af.default
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        return Session(configuration: configuration)
    }()

    func fetchStory(
        name: String,
        character_environment: String,
        topic: String,
        value: String,
        completion: @escaping (Result<Story, Error>) -> Void) {
        
        let url = "http://localhost:8000/dev/story"

        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]

        let parameters: [String: Any] = [
            "name": "Tina",
            "modifier": "Make the story inspire values of creativity and learning. Also make sure it's inspiring and educational",
            "narration": "Dumbledore",
            "topic": "What are atoms?",
            "character_environment": "Naruto ninja universe",
            "character_descriptors": ["freckles", "glasses", "fast"]
        ]

            
            sessionManager.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers:headers).responseDecodable(of:Response.self) { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data.data))

                case .failure(let error):
                    print("Request failed with error: \(error)")
                }
            }
            

    }
    
    
    func setUpAudio(named name: String) {
        guard let url = Bundle.main.url(forResource: name, withExtension: "mp3") else { return }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            audioPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

        } catch let error {
            print(error.localizedDescription)
        }
    }
    func playAudio() {
        audioPlayer?.play()
    }
    
    func pauseAudio() {
        audioPlayer?.pause()
    }
    
    func getAudioDuration() -> TimeInterval {
        if let audioPlayer = audioPlayer {
            return audioPlayer.duration
        }
        return 0
    }
    
    func getAudioProgress() -> TimeInterval {
        if let audioPlayer = audioPlayer {
            return audioPlayer.currentTime
        }
        return 0
    }
}
