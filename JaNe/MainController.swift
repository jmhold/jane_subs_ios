//
//  main.swift
//  JaNe
//
//  Created by holder on 4/15/16.
//  Copyright © 2016 holder. All rights reserved.
//

import UIKit
import SwiftyJSON


class MainController: UIViewController {
    
    var _start = false
    var _client: ACRCloudRecognition?

    @IBOutlet weak var volumeLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var showTitle: UILabel!
    @IBOutlet weak var seasonNumber: UILabel!
    @IBOutlet weak var episodeTitle: UILabel!
    
    
    override func viewDidLoad() {
        _start = false;
        
        let config = ACRCloudConfig();
        
        config.accessKey = "e114894189a2c85bbcfcaa58ae433498";
        config.accessSecret = "Xh3v7Ye2v63R9O7navgQDVoKOmZQO6i7uiXdzPEF";
        config.host = "eu-west-1.api.acrcloud.com";
        //if you want to identify your offline db, set the recMode to "rec_mode_local"
        config.recMode = rec_mode_remote;
        config.audioType = "recording";
        config.requestTimeout = 10;
        
        config.stateBlock = {[weak self] state in
            self?.handleState(state);
        }
        config.volumeBlock = {[weak self] volume in
            //do some animations with volume
            self?.handleVolume(volume);
        };
        config.resultBlock = {[weak self] result, resType in
            self?.handleResult(result, resType:resType);
        }
        self._client = ACRCloudRecognition(config: config);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func startRecognition(sender:AnyObject) {
        if (_start) {
            return;
        }

        self.showTitle.text = "Show:";
        self.seasonNumber.text = "Season:";
        self.episodeTitle.text = "Episode:";
        
        self._client?.startRecordRec();
        self._start = true;
    }
    
    @IBAction func stopRecognition(sender:AnyObject) {
        self._client?.stopRecordRec()
        self._start = false;
    }
    
    func handleResult(result: String, resType: ACRCloudResultType) -> Void
    {
        
        dispatch_async(dispatch_get_main_queue()) {
            self._client?.stopRecordRec();
            self._start = false;
            
//            if let dataFromString = result.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
//                let json = JSON(data: dataFromString)
//                self.showResults(json)
//            }
            let url = NSBundle.mainBundle().URLForResource("successResponse", withExtension: "json")
            let data = NSData(contentsOfURL: url!)
            let json = JSON(data!)
            self.showResults(json);
//            do{
//                json = try NSJSONSerialization.JSONObjectWithData(result.dataUsingEncoding(NSUTF8StringEncoding)!, options: .AllowFragments) as? [String: AnyObject]
//                print(json["status"]!["code"])
//            } catch {
//                print(error)
//            }
        }
    }
    
    func handleVolume(volume: Float) -> Void {
        dispatch_async(dispatch_get_main_queue()) {
            self.volumeLabel.text = String(format: "Volume: %f", volume)
        }
    }
    
    func handleState(state: String) -> Void
    {
        dispatch_async(dispatch_get_main_queue()) {
            self.stateLabel.text = String(format:"State : %@",state)
        }
    }
    
    func showResults(json:JSON){
        print(json)
        
        var show =
        
        self.showTitle.text = "Show: %@", show;
        self.seasonNumber.text = "Season: %@", season;
        self.episodeTitle.text = "Episode: %@", episode;
    }

}