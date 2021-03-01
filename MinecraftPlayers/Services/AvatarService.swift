//
//  AvatarService.swift
//  MinecraftPlayers
//
//  Created by Ilyat on 2/25/21.
//  Copyright © 2021 Ilyat. All rights reserved.
//

import Combine
import UIKit

class AvatarService {
    let requestTimeout = 7.0
    let urlSessionCongiguration: URLSessionConfiguration
    let uuidUrlFormat = "https://api.mojang.com/users/profiles/minecraft/%@"
//    let avatarUrlFormat = "https://minotar.net/helm/%@/8"
    let avatarUrlFormat = "https://crafatar.com/avatars/%@?size=8&overlay"
    let defaultAvatarData = UIImage(named: "Steve")!.pngData()!
    
    private var cancellable: AnyCancellable?
    
    init() {
        urlSessionCongiguration = URLSessionConfiguration.default
        urlSessionCongiguration.timeoutIntervalForRequest = requestTimeout
    }
    
    func loadAvatarForNickname(nickname: String, completion: @escaping (Data) -> Void) {
        cancellable = getUuid(nickname: nickname)
            .flatMap(self.getAvatarData)
            .replaceError(with: defaultAvatarData)
            .receive(on: DispatchQueue.main)
            .sink { completion($0) }
//            .sink(receiveCompletion: { result in
//                print("Receive completion: ")
//                switch result {
//                    case .failure(let error): //{
//                        print(error)
//                        completion(self.defaultAvatarData)
//                        break
//                    //}
//                case .finished:
//                    break
//                }
//            }, receiveValue: {data in
//                print("Received inside!")
//                completion(data)
//            })
    }
    
    func getUuid(nickname: String) -> AnyPublisher<String, Error> {
        let uuidUrlString = String(format: uuidUrlFormat, nickname)
        let uuidUrl = URL(string: uuidUrlString)!
        return URLSession(configuration: urlSessionCongiguration)
            .dataTaskPublisher(for: uuidUrl)
            .mapError { $0 as Error}
            .map { $0.data }
            .decode(type: [String: String].self, decoder: JSONDecoder())
            .tryMap {
                guard let uuid = $0["id"] else {
                    throw "No id in response"
                }
                
                return uuid
            }
            .eraseToAnyPublisher()
    }
    
    func getAvatarData(uuid: String) -> AnyPublisher<Data, Error> {
        let avatarUrlString = String(format: avatarUrlFormat, uuid)
        let avatarUrl = URL(string: avatarUrlString)!
        return URLSession(configuration: urlSessionCongiguration)
            .dataTaskPublisher(for: avatarUrl)
            .mapError { $0 as Error }
            .map {$0.data }
            .eraseToAnyPublisher()
    }
    
    func cancel() {
        cancellable?.cancel()
    }
}

extension String: Error {}
