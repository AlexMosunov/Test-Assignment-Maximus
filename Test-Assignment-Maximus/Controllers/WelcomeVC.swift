//
//  WelcomeVC.swift
//  Test-Assignment-Maximus
//
//  Created by iOS on 13.10.2020.
//  Copyright © 2020 Alex Mosunov. All rights reserved.
//

import UIKit

class WelcomeVC: UIViewController {

    @IBOutlet var holderView: UIView!
    var apiManager: APIManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configure()
    }
    
    lazy var labelTitles = [apiManager?.localizationObject?.input_1, apiManager?.localizationObject?.input_3 ]
    
    private func configure() {
        // set up scroll view
        let scrollView = UIScrollView(frame: holderView.bounds)
        holderView.addSubview(scrollView)
        
        
        for x in 0..<2 {
            let pageView = UIView(frame: CGRect(x: CGFloat(x) * holderView.frame.size.width, y: 0, width: holderView.frame.size.width, height: holderView.frame.size.height))
            scrollView.addSubview(pageView)
            
            // Title, image, button
            let label = UILabel(frame: CGRect(x: 10, y: 10, width: pageView.frame.size.width - 20, height: 120))
            let imageView = UIImageView(frame: CGRect(x: 10, y: 10+120+10, width: pageView.frame.size.width - 20, height: pageView.frame.size.height - 60 - 130 - 15))
            let button = UIButton(frame: CGRect(x: 10, y: pageView.frame.size.height - 60, width: pageView.frame.size.width - 20, height: 50))
            
            label.textAlignment = .center
            label.font = UIFont(name: "Helvetica-Bold", size: 32)
            pageView.addSubview(label)
            label.text = labelTitles[x]
        }
    }


}
