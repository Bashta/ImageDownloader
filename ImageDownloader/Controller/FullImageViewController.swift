//
//  FullImageViewController.swift
//  ImageDownloader
//
//  Created by Alb on 4/4/16.
//  Copyright © 2016 10gic. All rights reserved.
//

import UIKit

class FullImageViewController: UIViewController {
    static let storyboardId = "fullImageViewController"

    @IBOutlet private weak var fullImageView: UIImageView!

    var fullImage: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()

        if let image = fullImage {
            fullImageView.image = image
        }
    }
}

extension FullImageViewController {
    //MARK: Action Buttons
    @IBAction func CloseButtonTapped(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
