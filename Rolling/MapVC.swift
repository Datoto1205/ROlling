//  Created by Li Cheng-En.
//  Copyright © 2018. All rights reserved.
//

import UIKit
import MapKit
import GoogleMobileAds
import CoreLocation

class MapVC: UIViewController, GADBannerViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var MapView: MKMapView!
    @IBOutlet weak var BannerAD: GADBannerView!
    
    let manager = CLLocationManager()
    
    func createSpanAndAnnotation() {
        let FirstSpan: MKCoordinateSpan = MKCoordinateSpanMake(0.008, 0.008)
        //I could change the scale of map I want to show to users if I change the value of "MKCooefinateSpanMake".
        let originalLocation:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 24.942653, longitude: 121.368598)
        let EdittedRegion:MKCoordinateRegion = MKCoordinateRegion(center: originalLocation, span: FirstSpan)
        MapView.setRegion(EdittedRegion, animated: true)
        //Create a span.
        
        let TemporaryGarbageCanLatitude = showData().garbageCanLatitudeArray
        let TemporaryGarbageCanLongtitude = showData().garbageCanLontitudeArray
        let TemporaryGarbageCanDiscription = showData().garbageCanDiscription
        
        for i in 0...TemporaryGarbageCanLatitude.count - 1 {
            let garbageCanLocation : CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: TemporaryGarbageCanLatitude[i], longitude: TemporaryGarbageCanLongtitude[i])
            let pin = PinAnnotation(title: "Free Garbage Can", subtitle: TemporaryGarbageCanDiscription[i], coordinate: garbageCanLocation)
            
            MapView.addAnnotation(pin)
        }
        
        self.MapView.showsUserLocation = true
    }
    
    func blurEffect() {
        let statWindow = UIApplication.shared.value(forKey:"statusBarWindow") as! UIView
        let statusBar = statWindow.subviews[0] as UIView
        statusBar.backgroundColor = UIColor.clear
        let blur = UIBlurEffect(style:.prominent)
        let visualeffect = UIVisualEffectView(effect: blur)
        visualeffect.frame = statusBar.frame
        statusBar.addSubview(visualeffect)
        visualeffect.alpha = 0.8
        self.view.addSubview(visualeffect)
    }
    // Add blur effect to the backgroung of status bar. Unfortunately, you could found that the outcome was not perfect enough when you compared it with that in Apple's Map app in ios system.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createSpanAndAnnotation()
        blurEffect()
        requestAndShowTheLocationOfUser()
        
        MapView.showsUserLocation = true
        
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID]
        BannerAD.adUnitID = "ca-app-pub-1918665180874414/3343744332"
        BannerAD.rootViewController = self
        BannerAD.delegate = self
        BannerAD.load(GADRequest())
    }
    
    /*func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
     let location = locations[0]
     
     let span : MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
     let myLocation : CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
     self.MapView.showsUserLocation = true
     }
     // It seems that this codes is used to create a mapView which center is the location of user, but it is a little bit different from what we want here.
     */
    
    func requestAndShowTheLocationOfUser() {
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        // Request the authorization of location, and show the user's location on the map.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .default
    }
    // Change the color of status bar to black. (system default). It would not work if we put the codes in the parts of "viewWillAppear" or "viewDidLoad".
    
    override func viewWillDisappear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .lightContent
    }
    // Return the color of status bar.
    
    override func viewDidDisappear(_ animated: Bool) {
        manager.stopUpdatingLocation()
        // Track user's location would consume more electricity, so we should disable this function when the user leave the page so that we could save more energy.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.}*/
}
