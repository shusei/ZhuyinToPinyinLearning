//
//  ViewController.swift
//  ZhuyinToPinyinLearning
//
//  Created by SHENG CHUN LIN on 2017/12/15.
//  Copyright © 2017年 SHENG CHUN LIN. All rights reserved.
//

import GoogleMobileAds
import UIKit
import CoreData

class FirstViewController: UIViewController, GADBannerViewDelegate {
    
    var bannerView: GADBannerView!
    let app = UIApplication.shared.delegate as! AppDelegate
    var viewContext: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // In this case, we instantiate the banner with desired ad size.
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        
        bannerView.adUnitID = "ca-app-pub-4286420050191609/7682040986"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        bannerView.delegate = self
        
        viewContext = app.persistentContainer.viewContext
        
        print(NSPersistentContainer.defaultDirectoryURL())
        
        let fetchReques: NSFetchRequest<ZhuyinPinyinTable> = ZhuyinPinyinTable.fetchRequest()
        let sort = NSSortDescriptor(key: "id", ascending: true)
        fetchReques.sortDescriptors = [sort]
        
        do {
            let allDatas = try viewContext.fetch(fetchReques)
            for data in allDatas {
                print ("\(data.id), \(String(describing: data.type))")
            }
        } catch  {
            print(error)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        view.addConstraints(
            [NSLayoutConstraint(item: bannerView,
                                attribute: .bottom,
                                relatedBy: .equal,
                                toItem: bottomLayoutGuide,
                                attribute: .top,
                                multiplier: 1,
                                constant: 0),
             NSLayoutConstraint(item: bannerView,
                                attribute: .centerX,
                                relatedBy: .equal,
                                toItem: view,
                                attribute: .centerX,
                                multiplier: 1,
                                constant: 0)
            ])
    }
    
    /// Tells the delegate an ad request loaded an ad.
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("adViewDidReceiveAd")
        // Add banner to view and add constraints as above.
        addBannerViewToView(bannerView)
    }
    
    /// Tells the delegate an ad request failed.
    func adView(_ bannerView: GADBannerView,
                didFailToReceiveAdWithError error: GADRequestError) {
        print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    
    /// Tells the delegate that a full-screen view will be presented in response
    /// to the user clicking on an ad.
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
        print("adViewWillPresentScreen")
    }
    
    /// Tells the delegate that the full-screen view will be dismissed.
    func adViewWillDismissScreen(_ bannerView: GADBannerView) {
        print("adViewWillDismissScreen")
    }
    
    /// Tells the delegate that the full-screen view has been dismissed.
    func adViewDidDismissScreen(_ bannerView: GADBannerView) {
        print("adViewDidDismissScreen")
    }
    
    /// Tells the delegate that a user click will open another app (such as
    /// the App Store), backgrounding the current app.
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
        print("adViewWillLeaveApplication")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueSequence" {
            let vc = segue.destination as! SecondViewController
            vc.type = "sequence"
        }else if segue.identifier == "segueRandom" {
            let vc=segue.destination as! SecondViewController
            vc.type = "random"
        }else if segue.identifier == "segueWrong" {
            let vc=segue.destination as! SecondViewController
            vc.type="wrong"
        }
    }
    
    @IBAction func unwindSegue(_ sender: UIStoryboardSegue) {
        print("Back")
    }
}

