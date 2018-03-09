//
//  ViewController.swift
//  BearBeer
//
//  Created by Vince Reyes on 3/8/18.
//  Copyright © 2018 VinceReyes. All rights reserved.
//

import UIKit
import CoreMotion
import AVFoundation

class ViewController: UIViewController {
    var music: AVAudioPlayer = AVAudioPlayer()

    var motionManager = CMMotionManager()
    let opQueue = OperationQueue()
    
    @IBOutlet weak var lbl: UILabel!
    
    
    @IBAction func reset(_ sender: UIButton) {
        viewDidLoad()
        time = 0.0
        lbl.text = "0.0"
    }
    
    
    
    var time = 0.0
    var timer = Timer()
    var boolVariable: Bool = false
    
    func start() {
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(ViewController.action), userInfo: nil, repeats: true)
    }
    
    @objc func action(){
        if boolVariable {
            time += 0.1
            lbl.text = String(format: "%.1f", time)
            music.play()
        } else {
            time += 0.0
            lbl.text = String(format: "%.1f", time)
            music.stop()
        }
    }
    

    func startReadingMotionData() {
        // set read speed
        motionManager.deviceMotionUpdateInterval = 1
        // start reading
        motionManager.startDeviceMotionUpdates(to: opQueue) {
            (data: CMDeviceMotion?, error: Error?) in
            
            if let mydata = data {
                print("mydata", mydata.gravity.x)
                //                print("pitch raw", mydata.attitude.pitch)
                //                print("pitch", self.degrees(mydata.attitude.pitch))
                
                if mydata.gravity.x < (-0.86){
                    self.boolVariable = true
                } else {
                    self.boolVariable = false
                }
            }
        }
    }
    
    
    func degrees(_ radians: Double) -> Double {
        return 180/Double.pi * radians
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        start()
        // Do any additional setup after loading the view, typically from a nib.
        if motionManager.isDeviceMotionAvailable {
            print("We can detect device motion")
            startReadingMotionData()
        }
        else {
            print("We cannot detect device motion")
        }
        let musicFile = Bundle.main.path(forResource: "7454", ofType: ".mp3")
        do {
            try music = AVAudioPlayer(contentsOf: URL (fileURLWithPath: musicFile!))
        }
        catch {
            print(error)
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

