//
//  ShopVC.swift
//  FaceAnimoji
//
//  Created by Justin Peters on 1/19/21.
//  Copyright © 2021 ashutosh.dingankar. All rights reserved.
//

import UIKit
import Foundation.NSFileManager

class ShopVC: UIViewController, UIScrollViewDelegate {

    let fm = FileManager.default
    
    let path = Bundle.main.resourcePath! + "/art.scnassets"
    
    @IBOutlet weak var pgControll: UIPageControl!
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var contentWidth : CGFloat = 0.0
    
    var myButtonArray : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var tempArray : [String] = []
    
        do{
            let files = try fm.contentsOfDirectory(atPath: path)
            //print(files)
            tempArray = files
            
        }
        catch let error as Error {
            print(error)
        }
        
        myButtonArray = tempArray.filter{
            word in return word.contains(".scn")
        }
        
        //print(myButtonArray)
        
        for index in 0...myButtonArray.count - 1{
           myButtonArray[index] = myButtonArray[index].replacingOccurrences(of: ".scn", with: "")
        }
        
        print(myButtonArray)
        
        scrollView.delegate = self
        
        for index in 0...myButtonArray.count - 1{
            
            let button = UIButton();
            
            scrollView.addSubview(button)
            
            let xCord = view.frame.minX + view.frame.width * CGFloat(index)
            
            contentWidth += view.frame.width
            
            button.frame = CGRect(x: xCord, y: view.frame.height/2, width: 100, height: 100)
            
            button.setTitle(myButtonArray[index], for: .normal)
            button.backgroundColor = UIColor.systemBlue
            button.layer.borderColor = UIColor.brown.cgColor
            button.layer.borderWidth = 5
            button.setTitleColor(UIColor.black, for: .normal)
            button.contentHorizontalAlignment = .center
            button.titleLabel?.font = UIFont(name: "Arial", size: 40)
            button.layer.cornerRadius = 5
            button.addTarget(self, action: #selector(buttonClick), for: .touchUpInside)
        }
        
        scrollView.contentSize = CGSize(width: contentWidth, height: view.frame.height)
        
        pgControll.numberOfPages = myButtonArray.count

        // Do any additional setup after loading the view.
    }
    
    @IBAction func buttonClick(sender: UIButton){
        if let buttonTitle = sender.title(for: .normal){
            UserDefaults.standard.set(buttonTitle, forKey: "Face")
        }
        
        func scrollViewDidScroll(_ scrollView: UIScrollView){
            pgControll.currentPage = Int(scrollView.contentOffset.x / CGFloat(375))
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
