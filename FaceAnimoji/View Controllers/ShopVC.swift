//
//  ShopVC.swift
//  FaceAnimoji
//
//  Created by Justin Peters on 1/19/21.
//  Copyright © 2021 ashutosh.dingankar. All rights reserved.
//

import UIKit
import Foundation.NSFileManager
import AVFoundation
import CoreData

class ShopVC: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var pgControll: UIPageControl!
    
    @IBOutlet weak var pointsLabel: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var contentWidth : CGFloat = 0.0
    
    var myButtonArray : [ShopData] = []
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var baseFunc = BaseFunctions()
    var shopData = ShopDataConstruction()
    
    var student : StudentData? = nil
    
    var storeButtons: [UIButton] = []
    
    var storeLabels : [UILabel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        baseFunc.setUpParticles(View: self.view, Leaves: false)
        //set up background picture in view
        baseFunc.setUpBackground(view: self.view, imageName: "BackgroundBlue")
        
        //Change the textbox showing the user how many points they currently have
        changePointsValue()
        
        //Generate the store entries based on the information stored in coreData
        generateStore()
        
        //Method used for testing to figure out which font names are usable in code
        //checkFontNames()
    }
    
    func checkFontNames(){
        for family in UIFont.familyNames.sorted(){
            let names = UIFont.fontNames(forFamilyName: family)
            print("Family: \(family) Font names: \(names)")
        }
    }
    
    func generateStore(){
        
        //Set up the inital size of the content view. It is needed to expand on it later
        scrollView.contentSize = CGSize(width: view.frame.height, height: view.frame.height)
        
        //Get the shopData stored on the currently selected student
        let request = ShopData.fetchRequest() as NSFetchRequest<ShopData>

        let predString = "student == %@"

        let pred = NSPredicate(format: predString, student!)
        
        let sorter = NSSortDescriptor(key: "price", ascending: true)
        request.sortDescriptors = [sorter]

        request.predicate = pred

        do{
            //Populate the array for the button based on the information from coreData
            self.myButtonArray = try context.fetch(request)
        }
        catch{
            print("Unable to retrive data")
        }
        
        scrollView.delegate = self
        
        //For each element in the array, generate a button, expand the scrollview and add labels to inform the user of prices/purchase status
        for index in 0...myButtonArray.count - 1{
            
            let imageView = UIImageView()
            
            var image = UIImage(named: myButtonArray[index].name!)
            
            if(image == nil){
                image = UIImage(named: "Girl")
            }
            
            let button = UIButton()
            
            let xCord = (view.frame.midX) + (view.frame.width * CGFloat(index))
            
            contentWidth += view.frame.width
            
            let yCord = (view.frame.midY) - view.frame.width/5
            
            
            imageView.image = image
            imageView.frame = CGRect(x: xCord - view.frame.width/4, y: yCord, width: view.frame.width/2, height: view.frame.width/2)
            imageView.contentMode = UIView.ContentMode.scaleAspectFit
            
            button.frame = CGRect(x: xCord - view.frame.width/6, y: yCord + imageView.frame.height, width: view.frame.width/3, height: view.frame.width/5)
            
            button.setTitle(myButtonArray[index].name, for: .normal)
            button.setBackgroundImage(UIImage(named: "PinkButton"), for: UIControl.State.normal)
            button.setTitleColor(UIColor.white, for: .normal)
            button.contentHorizontalAlignment = .center
            button.titleLabel?.font = UIFont(name: "BerlinSansFBDemi-Bold", size: button.frame.height/3)
            button.layer.cornerRadius = 5
            button.addTarget(self, action: #selector(buttonClick), for: .touchUpInside)
            
            storeButtons.append(button)
            scrollView.addSubview(button)
            scrollView.addSubview(imageView)
            
            let lable = UILabel()
            
            if(myButtonArray[index].purchased){
                lable.text = "Purchased"
            }
            else{
                lable.text = "Buy: " + String(myButtonArray[index].price)
            }
            
            lable.frame = CGRect(x: xCord - view.frame.width/8, y: yCord + imageView.frame.height + (2 * button.frame.height/3), width: view.frame.width/4, height: view.frame.width/5)
            lable.font = UIFont(name: "BerlinSansFBDemi-Bold", size: lable.frame.height/4)
            lable.textAlignment = NSTextAlignment.center
            lable.textColor = UIColor.white
            
            storeLabels.append(lable)
            scrollView.addSubview(lable)
            
        }
        
        scrollView.contentSize = CGSize(width: contentWidth, height: view.frame.height)
        
        //Set up the page count for how many buttons you can scroll through
        pgControll.numberOfPages = myButtonArray.count
    }
    
    //If you scroll, update the pageControll based on the current offset of the scrollView
    func scrollViewDidScroll(_ scrollView: UIScrollView){
        pgControll.currentPage = Int(scrollView.contentOffset.x / view.frame.width)
    }
    
    //This method is used by all of the buttons in the store
    @IBAction func buttonClick(sender: UIButton){
        
        //Populate a new var based on the buttons title. The if is to prevent errors from a null button title
        if let buttonTitle = sender.title(for: .normal){
            
            //Request data for the entry based on the buttonTitle and currentStudent
            let request = ShopData.fetchRequest() as NSFetchRequest<ShopData>
            
            let predString = "name == '" + buttonTitle + "' && student == %@"
            
            let pred = NSPredicate(format: predString, student!)
            request.predicate = pred
            
            var item:[ShopData] = []
            
            do{
                item = try context.fetch(request)
            }
            catch{
                print("Unable to retrive data")
            }
            
            //Check the unique item that the fetch returns, seeing if it is purchased or not
            //If it is purcahsed, then equip the mask that is clicked
            if(item[0].purchased){
                student?.setValue(buttonTitle, forKey: "lastUsedMask")
            }
            //If the mask isn't purchased, then check to see if the user can unlock it with their points
            else{
                if(item[0].price <= student!.points){
                    //If you can purcahse the mask, then update the coreData entry
                    item[0].setValue(true, forKey: "purchased")
                    
                    let pointsAfterDeduction = student!.points - Int64(item[0].price)
                    student?.setValue(pointsAfterDeduction, forKey: "points")
                    student?.setValue(buttonTitle, forKey: "lastUsedMask")
                    
                    do {
                        try self.context.save()
                    } catch let error as NSError {
                        print("Could not save. \(error), \(error.userInfo)")
                    }
                    
                    //Update the text box showing points
                    changePointsValue()
                    //update the text of the store item you bought
                    changeStoreText(button: sender)
                }
            }
            
            //Play sounds/haptics
            baseFunc.Feedback()
        }
    }
    
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        baseFunc.Feedback()
    }
    
    //Update the points value in the string
    func changePointsValue(){
        pointsLabel.text = String(student!.points)
    }
    
    //Get the array value of the button you used to change the value of the text in the parallel array
    func changeStoreText(button: UIButton) {
        let index = storeButtons.firstIndex(of: button)
        storeLabels[index!].text = "Purchased"
    }
}
