//
//  SystemPicsCollectionViewController.swift
//  PicProgram
//
//  Created by 龚丹丹 on 2017/11/21.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import UIKit
import Photos
import AssetsLibrary

private let reuseIdentifier = "PicDetailCollectionViewCell"

class SystemPicsCollectionViewController: UICollectionViewController,UICollectionViewDelegateFlowLayout,CustomViewProtocol,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    var dataSource:[GDPHAsset] = Array()
    var listView:AlbumListView!
    var showSigleView:UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView?.backgroundColor = xsColor_main_white
        listView = AlbumListView.init(frame: CGRect.zero)
        listView.showFrame = CGRect.init(x: (SCREEN_WIDTH - 200)/2, y: 0, width: 200, height: 250)
        self.view.addSubview(listView)
        listView.delegate = self
        self.navigationItem.titleView = buildNavibarTitleView()
        listView.showAlbum()
        self.listDidSelected(view: self.listView, at: 0)
        self.collectionView?.register(UINib.init(nibName: "PicDetailCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    
    func buildNavibarTitleView() -> UIView {
        showSigleView = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 150, height: 44))
        showSigleView.font = xsFont(14)
        showSigleView.textColor = xsColor_main_text_blue
        showSigleView.textAlignment = .center
        showSigleView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(showList))
        showSigleView.addGestureRecognizer(tapGesture)
        
        let rowImageView = UIImageView.init(image: #imageLiteral(resourceName: "next"))
        rowImageView.frame = CGRect.init(x: showSigleView.width - 10, y: (showSigleView.height - 10)/2, width: 10, height: 10)
        showSigleView.addSubview(rowImageView)
        return showSigleView
    }
    
    
    @objc func showList() {
        if listView.isShow == false {
            self.listView.showList()
        }else {
           self.listView.hideList()
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
   
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return dataSource.count+1
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
       
        let subCell = cell as! PicDetailCollectionViewCell
        if indexPath.row == 0 {
            subCell.picImageView.image = #imageLiteral(resourceName: "xi")
        }else {
            let asset = self.dataSource[indexPath.row-1]
            subCell.picImageView?.image = UIImage.init(named: defaultImageName);
            GDPhotoTool.defaultTool.getImage(asset: asset.asset as PHAsset,imageSize: CGSize.init(width: 200, height: 200) ,complete: { (image, ret) in
                subCell.picImageView?.image = image;
            });
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: (SCREEN_WIDTH - 20)/3, height: (SCREEN_WIDTH - 20)/3)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            //TODO://系统相机
            self.showSystemCamera()
        }else {
            //TODO://图片上传
        }
    }
    
    func showSystemCamera() {
        let picker = UIImagePickerController.init()
        picker.sourceType = .camera
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //照相后回调
        picker.dismiss(animated: true, completion: nil)
    }
    
    func listDidSelected(view: UIView, at index: Int) {
        showSigleView.text = (self.listView.dataSource[index] as! PHAssetCollection).localizedTitle
        let assetCollection = self.listView.dataSource[index]
        let fetchResult = GDPhotoTool.defaultTool.getFetchResultInAlbums(assetCollection: assetCollection as! PHAssetCollection);
        let photoArray = GDPhotoTool.defaultTool.getAllPhotos(fetchResult: fetchResult);
        self.dataSource = photoArray as! [GDPHAsset]
        self.collectionView?.reloadData()
        self.listView.hideList()
    }
}
