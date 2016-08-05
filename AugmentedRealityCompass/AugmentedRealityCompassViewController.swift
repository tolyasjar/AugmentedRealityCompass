//
//  AugmentedRealityCompassViewController.swift
//  AugmentedRealityCompass
//
//  Created by Toleen Jaradat on 8/4/16.
//  Copyright © 2016 Toleen Jaradat. All rights reserved.
//

import UIKit
import CoreLocation
import CoreMotion

class AugmentedRealityCompassViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,CLLocationManagerDelegate {

    var imagePickerViewController :UIImagePickerController!
    var location : CLLocationManager!
    var manager :CMMotionManager!
    var arrowImageView:UIImageView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.manager = CMMotionManager()
        
        location=CLLocationManager()
        location.delegate = self
        location.desiredAccuracy=kCLLocationAccuracyBest
        location.startUpdatingHeading()
        location.startUpdatingLocation()

        self.imagePickerViewController = UIImagePickerController()
        self.imagePickerViewController.delegate = self
        self.imagePickerViewController.sourceType = .Camera
        
        self.imagePickerViewController.showsCameraControls = false
        
        self.imagePickerViewController.prefersStatusBarHidden()
        
        overlayViewSetUp()
        
    }
    
    
    func overlayViewSetUp () {
        
        let mainView = UIView(frame: CGRectMake(0,0,self.view.frame.width, self.view.frame.height))
        let northLabel = UILabel(frame: CGRectMake(self.view.frame.width/2 - 25, 0, 50, 50))
        northLabel.backgroundColor = UIColor.grayColor()
        northLabel.textColor = UIColor.whiteColor()
        northLabel.text = " North"
        
        let southLabel = UILabel(frame: CGRectMake(self.view.frame.width/2 - 25, self.view.frame.height-50 , 50, 50))
        southLabel.backgroundColor = UIColor.grayColor()
        southLabel.textColor = UIColor.whiteColor()
        southLabel.text = " South"
        
        let eastLabel = UILabel(frame: CGRectMake(self.view.frame.width-50, self.view.frame.height/2, 50, 50))
        eastLabel.backgroundColor = UIColor.grayColor()
        eastLabel.textColor = UIColor.whiteColor()
        eastLabel.text = "  East"
        
        let westLabel = UILabel(frame: CGRectMake(0,self.view.frame.height/2, 50, 50))
        westLabel.backgroundColor = UIColor.grayColor()
        westLabel.textColor = UIColor.whiteColor()
        westLabel.text = " West"
        
        arrowImageView = UIImageView(image: UIImage(named: "Arrow"))
        arrowImageView.frame = CGRectMake(self.view.frame.width/2 - 25, 100, 50, 50)
        
        mainView.addSubview(northLabel)
        mainView.addSubview(southLabel)
        mainView.addSubview(eastLabel)
        mainView.addSubview(westLabel)
        mainView.addSubview(arrowImageView)
        mainView.opaque = false
        
        self.imagePickerViewController.cameraOverlayView = mainView
      
    }
    
    func locationManager(manager: CLLocationManager, didUpdateHeading heading: CLHeading) {
        
        // This will print out the direction the device is heading in degrees
        print(heading.magneticHeading)
        if self.manager.deviceMotionAvailable {
            
            self.manager.deviceMotionUpdateInterval = 0.01
            self.manager.startDeviceMotionUpdatesToQueue(NSOperationQueue.mainQueue(), withHandler: { (data :CMDeviceMotion?, error :NSError?) in
                
                if data != nil {
                    
                    //convert degrees to radian values
                    let rotation =  -(heading.magneticHeading * M_PI)/180
                    print(rotation)
                    self.arrowImageView.transform = CGAffineTransformMakeRotation(CGFloat(rotation))
                }
                
                
            })
            
        }

    }

    @IBAction func LaunchMyCompassPressed(sender: AnyObject) {
        
        self.presentViewController(self.imagePickerViewController, animated: true, completion: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    


}
