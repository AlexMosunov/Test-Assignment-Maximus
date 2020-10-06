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
//        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont(name: "Helvetica Neue", size: 35)
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    private let videoView: UIView = {
        let videoView = UIView()
        videoView.backgroundColor = .blue
//        videoView.topAnchor.constraint(equalTo: bounds.topAnchor, constant: 50)

        return videoView
        
    }()
    
    public func configure() {
//        addSubview(label)
        addSubview(videoView)
        videoView.addSubview(label)
        videoView.frame = bounds
        label.frame = bounds
        
//        label.leftAnchor.constraint(equalTo: videoView.leftAnchor, constant: 16)
//        let constraints = [
//            view.centerXAnchor.constraint(equalTo: superview.centerXAnchor),
//            view.centerYAnchor.constraint(equalTo: superview.centerYAnchor),
//            view.widthAnchor.constraint(equalToConstant: 100),
//            view.heightAnchor.constraint(equalTo: view.widthAnchor)
        label.translatesAutoresizingMaskIntoConstraints = false
//        label.widthAnchor.constraint(equalToConstant: 250).isActive = true
            label.leftAnchor.constraint(equalTo: videoView.leftAnchor, constant: 16).isActive = true
            label.rightAnchor.constraint(equalTo: videoView.rightAnchor, constant: 16).isActive = true
            label.topAnchor.constraint(equalTo: videoView.topAnchor, constant: 88).isActive = true
//        superview!.topAnchor.constraint(equalTo: superview!.topAnchor, constant: -20).isActive = true
        
//        videoView.topAnchor.constraint(equalTo: superview!.topAnchor, constant: -200).isActive = true
//        ]
//        NSLayoutConstraint.activate(constraints)
        
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
