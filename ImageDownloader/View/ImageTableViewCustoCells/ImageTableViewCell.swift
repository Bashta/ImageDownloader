//
//  ImageTableViewCell.swift
//  ImageDownloader
//
//  Created by Alb on 4/4/16.
//  Copyright © 2016 10gic. All rights reserved.
//

import UIKit
import Kingfisher

protocol ImageDownloaderCellDelegate: class {
    func cellFinishedDownloadingImage(image: UIImage, cellIndex: Int)
}

final class ImageTableViewCell: UITableViewCell {
    static let nib = UINib(nibName: "ImageTableViewCell", bundle: nil)
    static let reuseId = "imageTableViewCell"

    @IBOutlet private weak var progressView: UIProgressView?
    @IBOutlet private weak var imageThumbnailImageView: UIImageView?
    @IBOutlet private weak var imageNameLabel: UILabel?
    @IBOutlet private weak var progressPercentageLabel: UILabel?
    @IBOutlet private weak var downloadButton: UIButton?

    private var imageFetcher: RetrieveImageTask?

    weak var cellImageDownloaderCellDelegate: ImageDownloaderCellDelegate?

    var datasourceCachedImage: UIImage? {
        didSet {
            imageThumbnailImageView?.image = datasourceCachedImage ?? UIImage(named: "image_placeholder")
            setupCell()
        }
    }

    var cellInfo:(imageUrl: NSURL, imageName: String, cellIndex: Int)? {
        didSet {
            setupCell()
        }
    }
}

extension ImageTableViewCell {
    //MARK:- Action Buttons
    @IBAction func downloadButtonPressed(sender: UIButton) {
        switch sender.titleLabel!.text! {

        case "Download":
            downloadButton?.setTitle(downloadButton?.titleLabel?.text == "Download" ? "Stop" : "Download", forState: .Normal)
            imageFetcher = imageThumbnailImageView?.kf_setImageWithURL(cellInfo!.imageUrl, placeholderImage: nil, optionsInfo: [.ForceRefresh],progressBlock: { receivedSize, totalSize in
                dispatch_async(dispatch_get_main_queue(), {
                    self.progressPercentageLabel?.text = "\((Float(receivedSize) / Float(totalSize) * 100))%"
                    self.progressView?.progress = (Float(receivedSize) / Float(totalSize))
                })
                }, completionHandler: { image, error, cacheType, imageURL in
                    self.downloadButton?.setTitle("Done", forState: .Normal)
                    self.progressView?.progress

                    guard let image = image, index = self.cellInfo?.cellIndex else {
                        return
                    }
                    self.cellImageDownloaderCellDelegate?.cellFinishedDownloadingImage(image, cellIndex: index)
            })

        case "Cancel":
            imageFetcher?.cancel()
        default:
            return
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        dispatch_async(dispatch_get_main_queue(), {

        })
        progressView?.progress = datasourceCachedImage == nil ? 0 : 100
        progressPercentageLabel?.text = datasourceCachedImage == nil ? "0%" : "100%"
        imageNameLabel?.text = cellInfo?.imageName
        downloadButton?.titleLabel?.text = datasourceCachedImage == nil ? "Download" : "Done"
        imageFetcher?.cancel()
    }
}

private extension ImageTableViewCell {
    func setupCell() {
        progressView?.progress = datasourceCachedImage == nil ? 0 : 100
        progressPercentageLabel?.text = datasourceCachedImage == nil ? "0%" : "100%"
        imageNameLabel?.text = cellInfo?.imageName
        downloadButton?.titleLabel?.text = datasourceCachedImage == nil ? "Download" : "Done"
    }
}