//
//  PDFViewController.swift
//  Flash Chat iOS13
//
//  Created by Kirill Kalashnikov on 3/31/20.
//  Copyright © 2020 Angela Yu. All rights reserved.
//

import UIKit
import PDFKit
import ImageViewer_swift
import SDWebImage


class PDFViewController: UIViewController {
    
        var images:[UIImage] = imageArrayWatch.compactMap {
            $0.resize(targetSize: .thumbnail)
        }
        
        lazy var layout = GalleryFlowLayout()
        
        lazy var collectionView:UICollectionView = {
            // Flow layout setup
            let cv = UICollectionView(
                frame: .zero, collectionViewLayout: layout)
            cv.register(
                ThumbCell.self,
                forCellWithReuseIdentifier: ThumbCell.reuseIdentifier)
            cv.dataSource = self
            return cv
        }()
        
        override func loadView() {
            super.loadView()
            print(Datas.imageUrls)
            view = UIView()
            view.backgroundColor = .white
            view.addSubview(collectionView)
            collectionView.translatesAutoresizingMaskIntoConstraints = false
            collectionView.topAnchor
                .constraint(equalTo: view.topAnchor)
                .isActive = true
            collectionView.leadingAnchor
                .constraint(equalTo: view.leadingAnchor)
                .isActive = true
            collectionView.trailingAnchor
                .constraint(equalTo: view.trailingAnchor)
                .isActive = true
            collectionView.bottomAnchor
                .constraint(equalTo: view.bottomAnchor)
                .isActive = true
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            title = "Gallery"
            SDImageCache.shared.clear(with: .all, completion: nil)
        }
        
        override func viewWillLayoutSubviews() {
            super.viewWillLayoutSubviews()
            updateLayout(view.frame.size)
        }
        
        private func updateLayout(_ size:CGSize) {
            if size.width > size.height {
                layout.columns = 4
            } else {
                layout.columns = 3
            }
        }
        
        override func viewWillTransition(
            to size: CGSize,
            with coordinator: UIViewControllerTransitionCoordinator) {
            updateLayout(size)
        }
    }


extension PDFViewController:UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell:ThumbCell = collectionView
            .dequeueReusableCell(withReuseIdentifier: ThumbCell.reuseIdentifier,
                                 for: indexPath) as! ThumbCell
        cell.imageView.image = images[indexPath.item]
        
        // Setup Image Viewer with [URL]
        cell.imageView.setupImageViewer(
            urls: Datas.imageUrls,
            initialIndex: indexPath.item,
            options: [
                .theme(.dark),
                .rightNavItemTitle("Info", delegate: self)
            ],
            from: self)
        
        return cell
    }
}

extension PDFViewController:RightNavItemDelegate {
    func imageViewer(_ imageViewer: ImageCarouselViewController, didTapRightNavItem index: Int) {
        print("TAPPED", index)
    }
}
