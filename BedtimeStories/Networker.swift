//
//  Networker.swift
//  BedtimeStories
//
//  Created by Bao Van on 6/17/23.
//

import Foundation
import Alamofire

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
    func fetchStory(completion: @escaping (Result<Story, Error>) -> Void) {
        let url = "http://localhost:8000/dev/story"

        AF.request(url, method: .post).responseDecodable(of: Response.self) { (response) in
            switch response.result {
            case .success(let data):
                completion(.success(data.data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
