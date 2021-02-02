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
    
    let fm = FileManager.default
    
    let path = Bundle.main.resourcePath! + "/art.scnassets"
    
    @IBOutlet weak var pgControll: UIPageControl!
    
    @IBOutlet weak var pointsLabel: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var contentWidth : CGFloat = 0.0
    
    var myButtonArray : [ShopData] = []
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var baseFunc = BaseFunctions()
    var shopData = ShopDataConstruction()
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        changePointsValue()
        generateStore()
        // Do any additional setup after loading the view.
    }
    
    func generateStore(){
        
        scrollView.contentSize = CGSize(width: view.frame.height, height: view.frame.height)
        
        do{
            self.myButtonArray = try context.fetch(ShopData.fetchRequest())
        }
        catch{
            print("Can't retrive data");
        }
        
        
        scrollView.delegate = self
        
        for index in 0...myButtonArray.count - 1{
            
            let button = UIButton();
            
            let xCord = (view.frame.midX - 50) + (view.frame.width * CGFloat(index))
            
            contentWidth += view.frame.width
            
            button.frame = CGRect(x: xCord, y: view.frame.height/2, width: 100, height: 100)
            
            button.setTitle(myButtonArray[index].name, for: .normal)
            button.backgroundColor = UIColor.systemBlue
            button.layer.borderColor = UIColor.brown.cgColor
            button.layer.borderWidth = 5
            button.setTitleColor(UIColor.black, for: .normal)
            button.contentHorizontalAlignment = .center
            button.titleLabel?.font = UIFont(name: "Arial", size: 40)
            button.layer.cornerRadius = 5
            button.addTarget(self, action: #selector(buttonClick), for: .touchUpInside)
            
            
            scrollView.addSubview(button)
            
            let lable = UILabel()
            
            if(myButtonArray[index].purchased){
                lable.text = "Purchased"
            }
            else{
                lable.text = "Buy: " + String(myButtonArray[index].price)
            }
            
            lable.frame = CGRect(x: xCord - 100, y: view.frame.height/2 + 100, width: 300, height: 100)
            lable.font = UIFont(name: "Arial", size: 35)
            lable.textAlignment = NSTextAlignment.center
            
            scrollView.addSubview(lable)
            
        }
        
        scrollView.contentSize = CGSize(width: contentWidth, height: view.frame.height)
        
        pgControll.numberOfPages = myButtonArray.count
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView){
        pgControll.currentPage = Int(scrollView.contentOffset.x / view.frame.width)
    }
    
    
    @IBAction func buttonClick(sender: UIButton){
        if let buttonTitle = sender.title(for: .normal){
            
            let request = ShopData.fetchRequest() as NSFetchRequest<ShopData>
            
            let predString = "name CONTAINS '" + buttonTitle + "'"
            
            let pred = NSPredicate(format: predString)
            request.predicate = pred
            
            var item:[ShopData] = []
            
            do{
                item = try context.fetch(request)
            }
            catch{
                print("Unable to retrive data")
            }
            
            if(item[0].purchased){
                defaults.set(buttonTitle, forKey: "Face")
            }
            else{
                if(item[0].price < UserDefaults.standard.integer(forKey: "points")){
                    item[0].setValue(true, forKey: "purchased")
                    defaults.setValue(defaults.integer(forKey: "points") - Int(item[0].price), forKey: "points")
                    defaults.set(buttonTitle, forKey: "Face")
                    do {
                        try self.context.save()
                    } catch let error as NSError {
                        print("Could not save. \(error), \(error.userInfo)")
                    }
                    changePointsValue()
                    removeSubviews()
                    generateStore()
                }
            }
            
            baseFunc.Feedback()
        }
    }
    
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        baseFunc.Feedback()
    }
    
    func changePointsValue(){
        pointsLabel.text = "Points earned: " + String(defaults.integer(forKey: "points"))
    }
    
    func removeSubviews(){
        let subViews = self.scrollView.subviews
        for subView in subViews{
            subView.removeFromSuperview()
        }
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
