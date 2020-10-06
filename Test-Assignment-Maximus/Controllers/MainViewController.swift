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
    

    @IBOutlet weak var collectionView: UICollectionView!

    var apiManager = APIManager()
    private var transition: CardTransition?
    var fetchingMore = false
    
    let sectionInsets = UIEdgeInsets(top: 12.0, left: 16.0, bottom: 12.0, right:16.0)
    let itemsPerRow: CGFloat = 1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        apiManager.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(HeaderCollectionReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: HeaderCollectionReusableView.identifier)
        
        apiManager.postRequest()
        
    }
    
    //MARK: - func to implement animated transition
    
    private func showType2(indexPath: IndexPath, bottomDismiss: Bool = false) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "DetailVC") as! DetailVC
        
        // Get tapped cell location
        let cell = collectionView.cellForItem(at: indexPath) as! CollectionViewCell
        cell.settings.cardContainerInsets = sectionInsets
        cell.settings.isEnabledBottomClose = bottomDismiss
        
        transition = CardTransition(cell: cell, settings: cell.settings)
        viewController.settings = cell.settings
        viewController.transitioningDelegate = transition
        
        // If `modalPresentationStyle` is not `.fullScreen`, this should be set to true to make status bar depends on presented vc.
        viewController.modalPresentationCapturesStatusBarAppearance = true
        viewController.modalPresentationStyle = .custom
        
        viewController.apiManager = apiManager
        viewController.index = indexPath
        
        
        let imageURLString = apiManager.imageURLsArray[indexPath.row]
        guard let url = URL(string: imageURLString) else {return}
        
        if let data = try? Data(contentsOf: url) {
            viewController.picture = UIImage(data: data)
        }
        
        presentExpansion(viewController, cell: cell, animated: true)
    }
    
    
}


//MARK: - APIManangerDelegate

extension MainViewController: APIManangerDelegate {
    func didUpdateData(_ DataManager: APIManager, data: [String]) {
        
        self.apiManager.imageURLsArray += data
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}



//MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //        return viewModel.numberOfRowsInSection(section: section)
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
    
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderCollectionReusableView.identifier, for: indexPath) as! HeaderCollectionReusableView
        
        header.configure()
        
        return header
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.size.width, height: 200)
    }
    
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offseetY = scrollView.contentOffset.y
        let contentHight = scrollView.contentSize.height
        
        if offseetY > contentHight - scrollView.frame.height && offseetY > 200 {

            if !fetchingMore {

                beginBatchFetch()
            }
            
        }
        
    }
    
    // infinite scroll
    
    func beginBatchFetch() {
        fetchingMore = true
        
        self.apiManager.postRequest()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.fetchingMore = false
        }
        
        print("begin update")
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
        let widthPerItem = availableWidth
        
        return CGSize(width: widthPerItem, height: 370 )
        
    }
    
    //3UIEdgeInsets(top: 8.0, left: 16.0, bottom: 8.0, right: 16.0)
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
        
        showType2(indexPath: index)
        
    }
    
    
}



extension MainViewController: CardsViewController {
    
    
}
