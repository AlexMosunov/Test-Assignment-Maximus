//
//  MainViewController.swift
//  Test-Assignment-Maximus
//
//  Created by Alex Mosunov on 05.10.2020.
//  Copyright © 2020 Alex Mosunov. All rights reserved.
//

import UIKit
import AVFoundation
import AppstoreTransition

class MainViewController: UIViewController {
    
    
    @IBOutlet weak var videoLayer: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var mainLabel: UILabel!
    

    var apiManager = APIManager()
    private var transition: CardTransition?
    
    let sectionInsets = UIEdgeInsets(top: 12.0, left: 16.0, bottom: 12.0, right: 16.0)
    let itemsPerRow: CGFloat = 1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playVideo()
        apiManager.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        apiManager.postRequest()
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MainMenuToDetail" {
            let destVC = segue.destination as! DetailVC
            destVC.apiManager = apiManager
            destVC.index = sender as? IndexPath
        }
    }
    
    
    
    func playVideo() {
        guard let path = Bundle.main.path(forResource: "gradient_60", ofType: "mp4") else {
            return
        }
        let player = AVPlayer(url: URL(fileURLWithPath: path))
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.view.bounds
        playerLayer.videoGravity = .resizeAspectFill
        self.videoLayer.layer.addSublayer(playerLayer)
        
        player.play()
        
        videoLayer.bringSubviewToFront(mainLabel)
        
    }
    
    
}


//MARK: - APIManangerDelegate

extension MainViewController: APIManangerDelegate {
    func didUpdateData(_ DataManager: APIManager, data: [String]) {
        
        apiManager.imageURLsArray = data
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}



//MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return apiManager.imageURLsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        
        
        let imageURLString = apiManager.imageURLsArray[indexPath.row]
        cell.updateUI(image: imageURLString)
    
        cell.collectionCellDelegate = self
        cell.index = indexPath
        
        return cell
    }
    
    
}



//MARK: - UICollectionViewDelegateFlowLayout

extension MainViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        //2
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem + 10)
    }
    
    //3
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    // 4
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}



//MARK: - CollectionViewNew

extension MainViewController: CollectionViewNew {
    func onClickCellButton(index: IndexPath) {
        
        performSegue(withIdentifier: "MainMenuToDetail", sender: index)
        
    }
    
    
}
