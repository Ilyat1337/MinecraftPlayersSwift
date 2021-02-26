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
    let urlFormat = "https://minotar.net/helm/%@/8"
    let defaultAvatarData = UIImage(named: "Steve")!.pngData()!
    
    private var cancellable: AnyCancellable?
    
    func loadAvatarForNickname(nickname: String, completion: @escaping (Data) -> Void) {
        let urlString = String(format: urlFormat, nickname)
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = requestTimeout
        cancellable = URLSession(configuration: configuration).dataTaskPublisher(for: URL(string: urlString)!)
            .map {$0.data }
            .replaceError(with: defaultAvatarData)
            .receive(on: DispatchQueue.main)
            .sink { completion($0) }
    }
    
    func cancel() {
        cancellable?.cancel()
    }
}
