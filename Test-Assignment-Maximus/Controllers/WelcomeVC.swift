//
//  WelcomeVC.swift
//  Test-Assignment-Maximus
//
//  Created by iOS on 13.10.2020.
//  Copyright © 2020 Alex Mosunov. All rights reserved.
//

import UIKit
import AVFoundation

class WelcomeVC: UIViewController {

    @IBOutlet var holderView: UIView!
    @IBOutlet weak var videoViewMain: UIView!
    @IBOutlet weak var labelMain: UILabel!
    @IBOutlet weak var buttonMain: UIButton!
    
    
    var apiManager: APIManager?
    
    let scrollView = UIScrollView()
    var videoViewOne = UIView()
    var videoViewTwo = UIView()
    private let playerLayer = AVPlayerLayer()
    private var playerLooper: AVPlayerLooper?
    
    var swiped = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        apiManager?.localizationDelegate = self
        scrollView.delegate = self
        swiped = false
        
//        videoViewOne.layer.addSublayer(playerLayer)
//        videoViewTwo.layer.addSublayer(playerLayer)
//        apiManager?.postRequest(language: getLocalizationLanguageCode())
        // Do any additional setup after loading the view.
    }
    
//    override func layoutSubviews() {
//         super.layoutSubviews()
//         playerLayer.frame = bounds
//     }
//
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("ooooooooooooooo")
//        playerLayer.frame = self.bounds
//        configure()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func getLocalizationLanguageCode() -> String {
        if NSLocale.preferredLanguages[0].range(of: "en") != nil {
            return "en"
        } else if NSLocale.preferredLanguages[0].range(of: "ru") != nil {
            return "ru"
        } else {
            return "en"
        }
    }
    
    var labelTitles = ["", "" ]
    var buttonTitles = ["Next", "Start"]
    
    private func configure() {
        // set up scroll view
        
        scrollView.frame = holderView.bounds
        
        holderView.addSubview(scrollView)
        
        
        let numberOfPages = 2
        
        for x in 0..<numberOfPages {
            let pageView = UIView(frame: CGRect(x: CGFloat(x) * holderView.frame.size.width, y: 0, width: holderView.frame.size.width, height: holderView.frame.size.height))
            scrollView.addSubview(pageView)
            
            // Title, image, button
            let label = UILabel(frame: CGRect(x: 32, y: pageView.frame.size.height - 92 - 79 - 60 - 50, width: pageView.frame.size.width - 64, height: 100))
            
            print("pageView.frame.size.height - \(pageView.frame.size.height)")
            videoViewOne = UIView(frame: CGRect(x: 22, y: pageView.frame.size.height - 700, width: pageView.frame.size.width - 44, height: 321))
            videoViewTwo = UIView(frame: CGRect(x: 22, y: pageView.frame.size.height - 700, width: pageView.frame.size.width - 44, height: 321))
            
            let button = UIButton(frame: CGRect(x: 32, y: pageView.frame.size.height - 92, width: pageView.frame.size.width - 64, height: 60))
            
            label.textAlignment = .center
            label.font = UIFont.boldSystemFont(ofSize: 25)
            label.textColor = .white
            label.textAlignment = .left
            label.numberOfLines = 3
            pageView.addSubview(label)
            label.text = labelTitles[x]
            
//            videoViewOne.backgroundColor = .darkGray
//            videoViewTwo.backgroundColor = .blue
//            videoView.tag = x + 1
//            print("tag - \(videoView.tag)")
            if x == 0 {
                pageView.addSubview(videoViewOne)
                playVideo(resourceName: "vid_onboard_1", type: "mp4", videoView: videoViewOne)
//                videoViewOne.layer.addSublayer(playerLayer)
            } else if x == 1 {
                pageView.addSubview(videoViewTwo)
//                videoViewTwo.layer.addSublayer(playerLayer)
            }
            
           
//            pageView.addSubview(videoView)
            if x == 0 {
//                playVideo(resourceName: "vid_onboard_1", type: "mp4", videoView: videoView)
            } else if x == 1 {
//                playVideo(resourceName: "vid_onboard_2", type: "mp4", videoView: videoView)
            }
           
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = UIColor(red: 38.0 / 255.0, green: 86.0 / 255.0, blue: 254.0 / 255.0, alpha: 1.0)
            button.setTitle(buttonTitles[x], for: .normal)
            button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
            button.tag = x + 1
            button.layer.cornerRadius = 8
            pageView.addSubview(button)
            
        }
        
        scrollView.contentSize = CGSize(width: holderView.frame.size.width * CGFloat(numberOfPages), height: 0)
        scrollView.isPagingEnabled = true
    }
    
    
    @objc func didTapButton(_ button: UIButton) {
        guard button.tag < 2 else {
            // dismiss
            Core.shared.setIsNotNewUser()
            dismiss(animated: true)
            return
        }
        // scroll to next page
        scrollView.setContentOffset(CGPoint(x: holderView.frame.size.width * CGFloat(button.tag), y: 0), animated: true)
    }
    
    
    func playVideo(resourceName: String, type: String, videoView: UIView) {
        guard let fileURL = Bundle.main.url(forResource: resourceName, withExtension: type) else {
            return
        }
        let asset = AVAsset(url: fileURL)
        let item = AVPlayerItem(asset: asset)
        
        // Setup the player
        let player = AVQueuePlayer()
        playerLayer.player = player
        playerLayer.videoGravity = .resizeAspectFill
        videoView.layer.addSublayer(playerLayer)
        playerLayer.frame = videoView.bounds
        // Create a new player looper with the queue player and template item
        playerLooper = AVPlayerLooper(player: player, templateItem: item)
        
        
        // Start the movie
        player.play()
        
//                let item = AVPlayerItem(asset: asset)
//        let player = AVPlayer(url: URL(fileURLWithPath: path))
////        let controller = AVPlayerViewController()
////        controller.player = player
        print("player player")
//        swiped = true
//swiped
//        let playerLayer = AVPlayerLayer(player: player)
//        playerLayer.frame = videoView.bounds
//        playerLayer.videoGravity = .resizeAspectFill
//        videoView.layer.addSublayer(playerLayer)
//
//        player.play()
//        swiped = false
    }
    
    
}


extension WelcomeVC: APILocalizationDelegate {
    func didUpdateLocalizationData(_ DataManager: APIManager, data: LocalizationData) {
        self.labelTitles = [data.input_1 ?? "", data.input_3 ?? ""]
        self.buttonTitles = [data.input_2 ?? "Next", data.input_4 ?? "Next"]
        DispatchQueue.main.async {
            self.configure()
            print("hello")
        }
        
    }
    
    
    
}
extension WelcomeVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print(scrollView.contentOffset.x)
        if scrollView.contentOffset.x > 200 {
//            if videoView.tag == 2 {
            if !swiped {
                print("!!!!!!!!!!!!!!!!!")
                playVideo(resourceName: "vid_onboard_2", type: "mp4", videoView: videoViewTwo)
//                swiped = true
            }
            
        } else if scrollView.contentOffset.x == 0 {
            
            if !swiped {
//                print("<<<<<<)")
                playVideo(resourceName: "vid_onboard_1", type: "mp4", videoView: videoViewOne)
//                swiped = true
//                playVideo(resourceName: "vid_onboard_1", type: "mp4", videoView: videoViewOne)
            }
//            print("< 200")
//            if videoView.tag == 1 {
                
//            }
        }
    }
}
