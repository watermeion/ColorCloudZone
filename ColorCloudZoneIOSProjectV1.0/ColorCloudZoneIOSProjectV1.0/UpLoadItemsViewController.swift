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

class UpLoadItemsViewController: GBCustomViewController,UICollectionViewDataSource,UICollectionViewDelegate,GBImagePickerBehaviorDataTargetDelegate,GBTableViewSelectorBehaviorDelegate {


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
    @IBOutlet weak var surfaceMaterialLabel: UILabel!
    @IBOutlet weak var materialLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    
    
    var newItemCategory: String?
    var newItemMaterial: String?
    var newItemSurfaceMaterial: String?
    var newItemImagesArray: Array <AnyObject> = []
    var selector = GBTableViewSelectorBehavior()
    //Property
    var pictureNum: Int = 0
    var imageFiles: [AVFile] = []
    

     // MARK: ViewController LifeCircle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selector.delegate = self
        selector.owner = self
        
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
    
    
    
    // MARK: GBTableViewSelectorBehaviorDelegate

    
    func callSelectorAction (sender: AnyObject!) {
      selector.callSelectAction(sender)
    }
    
    
    func arrayforGBTableViewSelectorBehaviorWith(sender: AnyObject!) -> [AnyObject]! {
        
        let newItemCategoryData: [String] = ["上衣","裤子","西服","西装","外套"]
        let newItemMaterialData: [String] = ["棉","麻","混纺"]
        let newItemSurfaceMaterialData: [String] = ["光","哑光","非光"]
        
        
        if sender.isEqual(self.newItemCategoryBtn){
         return newItemCategoryData
        }
        
        if sender.isEqual(self.newItemMateralBtn){
        return newItemMaterialData
        }
        
        if sender.isEqual(self.newItemSurfaceMateralBtn){
          return newItemSurfaceMaterialData
        }
        return [];
    }
    
    
    var selectedCateory = []
    var selectedMaterial = []
    var selectedSurfaceMaterial = []
    
    func checkedArrayforGBTableViewSelectorBehaviorWith(sender: AnyObject!) -> [AnyObject]! {
        
        if sender.isEqual(self.newItemCategoryBtn){
            return selectedCateory as [AnyObject]
        }
        
        if sender.isEqual(self.newItemMateralBtn){
            return selectedMaterial as [AnyObject]
        }
        
        if sender.isEqual(self.newItemSurfaceMateralBtn){
            return selectedSurfaceMaterial as [AnyObject]
        }
        return [];
    }
    
    func tableViewSelectorSelectedResults(results: [AnyObject]!, fromSender sender: AnyObject!) {
    
        let resultString = self.mapStringWithArray(results as! [String!])
        
        if sender.isEqual(self.newItemCategoryBtn){
            newItemCategory = resultString
            self.categoryLabel.text = newItemCategory
            selectedCateory = results
        }
        
        if sender.isEqual(self.newItemMateralBtn){
            newItemMaterial = resultString
            self.materialLabel.text = newItemMaterial
            selectedMaterial = results
        }
        
        if sender.isEqual(self.newItemSurfaceMateralBtn){
            newItemSurfaceMaterial = resultString
            self.surfaceMaterialLabel.text = newItemSurfaceMaterial
            selectedSurfaceMaterial = results
        }
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
        
        if let _ = newItemCategory {
          
        }else { return false }
        
        if let _ = newItemMaterial {
            
        }else { return false }
        
        if let _ = newItemSurfaceMaterial {
            
        }else { return false }
        
        return true
    }
    
    
    func doDataUpload(){
    
        guard self.imageUploadSuccess && newItemImagesArray.count>0 else{
            SVProgressHUD.showInfoWithStatus("请先上传照片")
            return
        }
        let product = Product();
        product.productName = self.newItemName.text
        product.productNum = self.newItemSerialNum.text
        
        guard let _ = Int(self.newItemWholeSalePrice.text!) else{
           SVProgressHUD.showErrorWithStatus("请输入正确的价格")
           return
        }
        product.productPrice = (integer: Int(self.newItemWholeSalePrice.text!))
        product.productColor = self.newItemColor.text
        product.productSize = self.newItemSizeInput.text
        product.productDescri = self.newItemDetailInputView.text;
        product.productImage = self.imageFiles.first
        
        product.productMaterial = newItemMaterial
        product.productStyle = newItemCategory
        
        product.userId = AVUser.currentUser().objectId
        
        
        product.saveInBackgroundWithBlock { (success, error) -> Void in
            if success {
                SVProgressHUD.showSuccessWithStatus("上传成功")
            }
            else
            {
               SVProgressHUD.showErrorWithStatus("失败")
                print(error.description)
            }
        }
    }
    
    // MARK: UI Interface
    
    @IBOutlet weak var upLoadAction: UIButton!
    var imageUploadSuccess:Bool = false
    @IBAction func uploadImageAction(sender: AnyObject) {
        self.uploadImages()
    }
    
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
        self .callSelectorAction(sender);
    }
    @IBAction func newItemMateralBtnAction(sender: AnyObject) {
        self .callSelectorAction(sender);
    }
    
    @IBAction func newItemSurfaceMateralBtnAction(sender: AnyObject) {
        self .callSelectorAction(sender);
    }
    
    
    // MARK: Private Helper
    func uploadImages(){
        for image in newItemImagesArray{
          self.uploadSingeImageAsync(image)
        }
    }
    
    func uploadSingeImageAsync(image:AnyObject) {
        var count = newItemImagesArray.count
         SVProgressHUD.showWithStatus("正在上传照片");
        let data = UIImagePNGRepresentation(image as! UIImage);
        let file =  AVFile(name: "ImageFile.png",data:data);
        file.saveInBackgroundWithBlock { (success, error) -> Void in
            if success {
                self.imageFiles.append(file)
                var productImageFileobject = AVObject.init(className: "ProductImageFile")
                productImageFileobject.setObject(file, forKey: "productImageFile")
                productImageFileobject.saveInBackground();
                --count
            }
            if count == 0 {
              SVProgressHUD.showSuccessWithStatus("上传照片成功");
                self.imageUploadSuccess = true
            }
        }
    }
    
    func mapStringWithArray (array:[String!]) -> String{
        var string = ""
        for item in array{
          string.appendContentsOf(item)
            if array.count > 1 {
            string.appendContentsOf(",")
            }
        }
        return string
    }
}
