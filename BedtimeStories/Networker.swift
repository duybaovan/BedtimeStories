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

    
    func fetchStory(completion: @escaping (Result<Story, Error>) -> Void) {
        let url = "http://localhost:8000/dev/story"
        let parameters: [String: Any] = [
            "name": "Ben",
            "modifier": "Make the story super funny",
            "narration": "Dumbledore",
            "topic": "What is energy?",
            "character_environment": "Ninja universe",
            "character_descriptors": ["freckles", "glasses", "fast"]
        ]
        
        AF.request(url, method: .post).responseDecodable(of: Response.self) { (response) in
            switch response.result {
            case .success(let data):
                completion(.success(data.data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    func setUpAudio() {
        guard let url = Bundle.main.url(forResource: "test_audio", withExtension: "mp3") else { return }

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
}
