//
//  RemoteImageView.swift
//  Seen it
//
//  Created by Sedaykin Aleksey on 01.09.2025.
//

import UIKit

final class RemoteImageView: UIImageView {
    
    private var currentTask: Task<Void, Never>?
    private var currentUrl: URL?
        
    func setImage(url: URL) {
        currentTask?.cancel()
        currentUrl = url
        
        currentTask = Task { [weak self] in
            guard let self = self else { return }
            
            do {
                let image = try await ImageLoader.shared.loadImage(from: url)
                try Task.checkCancellation()
                if self.currentUrl == url {
                    await MainActor.run {
                        self.image = image
                    }
                }
            } catch {
                if error is CancellationError { return }
            }
        }
    }
    
    func cancelLoading() {
        currentTask?.cancel()
        currentTask = nil
        currentUrl = nil
    }
    
    func prepareForReuse() {
        cancelLoading()
        self.image = UIImage(named: "placeholder")
    }
}
