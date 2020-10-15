//
//  HeaderCollectionReusableView.swift
//  Test-Assignment-Maximus
//
//  Created by Alex Mosunov on 06.10.2020.
//  Copyright © 2020 Alex Mosunov. All rights reserved.
//

import UIKit
import AVFoundation

class HeaderCollectionReusableView: UICollectionReusableView {
        
    static let identifier = "HeaderCollectionReusableView"
    
    
    let label: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 33)
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    private let videoView: UIView = {
        let videoView = UIView()

        return videoView
        
    }()
    
    public func configure() {
        
        addSubview(videoView)
        videoView.addSubview(label)
        videoView.frame = bounds
        label.frame = bounds
        label.clipsToBounds = true
        
        videoView.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.videoView.topAnchor.constraint(equalTo: self.topAnchor),
            self.videoView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.videoView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.videoView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        label.leftAnchor.constraint(equalTo: videoView.leftAnchor, constant: 26).isActive = true
        label.rightAnchor.constraint(equalTo: videoView.rightAnchor, constant: 16).isActive = true
        label.topAnchor.constraint(equalTo: videoView.topAnchor, constant: 100).isActive = true
        
        playVideo()
    }
    
    
    
    func playVideo() {
        guard let path = Bundle.main.path(forResource: "gradient_60", ofType: "mp4") else {
            return
        }
        let player = AVPlayer(url: URL(fileURLWithPath: path))
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.bounds
        playerLayer.videoGravity = .resizeAspectFill
        self.videoView.layer.addSublayer(playerLayer)
        
        player.play()
        
        videoView.bringSubviewToFront(label)
        
    }
}
