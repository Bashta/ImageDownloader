//
//  ImagesTableViewController.swift
//  ImageDownloader
//
//  Created by Alb on 4/4/16.
//  Copyright © 2016 10gic. All rights reserved.
//

import UIKit

final class ImagesTableViewController: UITableViewController {
    static let storyboardId = "imagesTableViewController"

    private var datasource: [NSURL] = []
    private var imagesDataSource: [UIImage?] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.registerNib(ImageTableViewCell.nib, forCellReuseIdentifier: ImageTableViewCell.reuseId)
        setupDatasource()
    }
}

extension ImagesTableViewController {
    //MARK:- UITableViewDataSource
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCellWithIdentifier(ImageTableViewCell.reuseId) as? ImageTableViewCell else {
            return UITableViewCell()
        }

        cell.cellImageDownloaderCellDelegate = self
        cell.datasourceCachedImage = imagesDataSource[indexPath.row]
        cell.cellInfo = (datasource[indexPath.row], "Image Nr \(indexPath.row)", indexPath.row)
        return cell
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }

    //MARK:- UITableViewDelegate
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return GlobalConstants.ImageTableViewController.CellHeight
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        guard let fullImageViewController = storyboard?.instantiateViewControllerWithIdentifier(FullImageViewController.storyboardId) as? FullImageViewController,
              let image = imagesDataSource[indexPath.row] else {
            return
        }

        fullImageViewController.fullImage = image
        self.navigationController?.presentViewController(fullImageViewController, animated: true, completion: nil)
    }
}

private extension ImagesTableViewController {
    //MARK:- Helpers
    func setupDatasource() {
        for urlStrig in GlobalConstants.Datasource.imageUrlDatasource {
            if let url = NSURL(string: urlStrig) {
                datasource.append(url)
            }
        }

        imagesDataSource = Array(count: datasource.count, repeatedValue: nil)
    }
}

extension ImagesTableViewController: ImageDownloaderCellDelegate {
    func cellFinishedDownloadingImage(image: UIImage, cellIndex: Int) {
        imagesDataSource[cellIndex] = image
    }
}
