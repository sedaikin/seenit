//
//  RemoteImageView.swift
//  Seen it
//
//  Created by Sedaykin Aleksey on 01.09.2025.
//

import UIKit

final class RemoteImageView: UIImageView {
        
    func setImage(url: URL) {
        Task {
            do {
                let image = try await ImageLoader.shared.loadImage(from: url)
                await MainActor.run {
                    self.image = image
                }
            } catch {
                print("Ошибка при загрузки изображения: \(error.localizedDescription)")
            }
        }
    }
}
