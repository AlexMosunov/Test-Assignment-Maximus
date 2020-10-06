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
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "Тестовое заданиe для iOS разарботчика"
        label.textAlignment = .center
        label.textColor = .purple
        return label
    }()
    
    private let videoView: UIView = {
        let videoView = UIView()
        videoView.backgroundColor = .blue
        return videoView
        
    }()
    
    public func configure() {
//        addSubview(label)
        addSubview(videoView)
        videoView.addSubview(label)
        videoView.frame = bounds
        label.frame = bounds
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
