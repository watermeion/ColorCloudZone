//
//  UpLoadItemsViewController.swift
//  ColorCloudZoneIOSProjectV1.0
//
//  Created by GYB on 15/9/27.
//  Copyright © 2015年 SHS. All rights reserved.
//



import UIKit




let kMaxInputWordNum = 50
let kMaxPicturesNum = 5
let kUpLoadPicBtnCellIdentifier = "UpLoadPictureBtnCollectionViewCell";
let kUpLoadPicCellIdentifier = "UpLoadPicCollectionViewCell"


class UpLoadItemsViewControllerViewModel: GBViewModel {
    
    //properties
    
}

class UpLoadItemsViewController: GBCustomViewController,UICollectionViewDataSource,UICollectionViewDelegate,GBImagePickerBehaviorDataTargetDelegate {


    //IBOutlet
    @IBOutlet weak var newItemName: UITextField!
    @IBOutlet weak var newItemSerialNum: UITextField!
    @IBOutlet weak var newItemWholeSalePrice: UITextField!
    @IBOutlet weak var newItemPicCollectionView: UICollectionView!
    @IBOutlet weak var newItemCategoryBtn: UIButton!
    @IBOutlet weak var newItemColor: UITextField!
    @IBOutlet weak var newItemSizeInput: UITextField!
    @IBOutlet weak var newItemMateralBtn: UIButton!
    @IBOutlet weak var newItemSurfaceMateralBtn: UIButton!
    @IBOutlet weak var newItemDetailInputView: UITextView!
    
    
    var newItemCategory: String?
    var newItemMaterial: String?
    var newItemSurfaceMaterial: String?
    
    var newItemImagesArray: Array <AnyObject> = []
    
    @IBAction func donebtnAction(sender: AnyObject) {
        
        if self.checkUserInputDataIntegrity() {
        
         NSLog("newItemDoneBtnAction hit!")
         self.doDataUpload()
         return
        }
         NSLog("newItemDoneBtnAction Data imcomplete !")
    }
    @IBAction func newItemCategoryBtnAction(sender: AnyObject) {
        //
        NSLog("newItemCategoryBtnAction hit!")
    
    }
    @IBAction func newItemMateralBtnAction(sender: AnyObject) {
        
    }
    
    @IBAction func newItemSurfaceMateralBtnAction(sender: AnyObject) {
        
    }
    //Property
    var pictureNum: Int = 0
     // MARK: ViewController LifeCircle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.edgesForExtendedLayout = UIRectEdge.None;
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    
// MARK: UICollectionViewDelegate
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(kUpLoadPicBtnCellIdentifier, forIndexPath: indexPath) as! UpLoadPictureBtnCollectionViewCell
            return cell;
        }
        
        let cell:UpLoadPicCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(kUpLoadPicCellIdentifier, forIndexPath: indexPath) as! UpLoadPicCollectionViewCell
        
        
        cell.contentImageView.image = newItemImagesArray[indexPath.item-1] as! UIImage;
        return cell
    }
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
       
        
    }
    
    
    
    
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        pictureNum = 1+newItemImagesArray.count
        return pictureNum < kMaxPicturesNum ? pictureNum : kMaxPicturesNum
    }
    
    

    // MARK： GBImagePickerBehaviorDataTargetDelegate
    func imagePickerBehaviorSelectedImages(imageArray: [AnyObject]!) {
      
        newItemImagesArray.appendContentsOf(imageArray);
        newItemPicCollectionView.reloadData()
        
    }

    // MARK: Internal Helper
    
    
    func checkUserInputDataIntegrity() -> Bool {
       
        if self.newItemName.text!.isEmpty  {
         return false
        }
        
        
        if self.newItemSerialNum.text!.isEmpty {
         return false
        }
        
        if  self.newItemWholeSalePrice.text!.isEmpty {
         return false
        }
        
        if  self.newItemColor.text!.isEmpty  {
         return false
        }
        
        if self.newItemSizeInput.text!.isEmpty  {
         return false
        }
        
        if self.newItemDetailInputView.text!.isEmpty  {
         return false
        }
        
        //Btn selected
        
        if let category = newItemCategory {
          
        }else { return false }
        
        if let material = newItemMaterial {
            
        }else { return false }
        
        if let surfaceMaterial = newItemSurfaceMaterial {
            
        }else { return false }
        
        return true
    }
    
    
    
    
    
    func doDataUpload(){
    
        //step 1 上传 图片
    
        var product = Product();
        product.productName = self.newItemName.text
        product.productNum = self.newItemSerialNum.text
        
        product.productPrice = NSNumber(integer: Int(self.newItemWholeSalePrice.text!)!)
        product.productColor = self.newItemColor.text
        product.productSize = self.newItemSizeInput.text
        product.productDescri = self.newItemDetailInputView.text;
        
    }
    
    // MARK: UI Interface

    
    // MARK: Private Helper
    func uploadImages() ->[AnyObject]{
        var fileArray :[AnyObject] = []
        for image in newItemImagesArray{
         let file = self.uploadSingeImage(image)
            fileArray.append(file)
        }
        
        return fileArray;
    }
    
    func uploadSingeImage(image:AnyObject) -> AVFile{
    
        let data = UIImagePNGRepresentation(image as! UIImage);
        let file =  AVFile(name: "ImageFile.png",data:data);
        file.saveInBackground();
        return file
    }
}
