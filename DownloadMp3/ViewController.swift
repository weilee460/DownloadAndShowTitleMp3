//
//  ViewController.swift
//  DownloadMp3
//
//  Created by ying on 16/3/26.
//  Copyright © 2016年 ying. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

class ViewController: UIViewController, NSURLSessionDownloadDelegate {
    

    @IBOutlet weak var mp3NameLabel: UILabel!
    
    var backgroundConfiguration: NSURLSessionConfiguration?
    var backgroundSession: NSURLSession?
    var backgroundTask: NSURLSessionDownloadTask?
    
    let documents: String = "file://" + NSHomeDirectory() + "/Documents/1.mp3"
    var fileManager: NSFileManager = NSFileManager.defaultManager()
    
    var musicPlayer: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        backgroundConfiguration = NSURLSessionConfiguration.backgroundSessionConfigurationWithIdentifier("downLoadMusic")
        
        backgroundSession = NSURLSession(configuration: backgroundConfiguration!, delegate: self, delegateQueue: nil)
    }
    
    func downloadMusic() {
        print("Start download files!")
        
        //var urlString = "http://nginx.org/download/nginx-1.8.1.tar.gz"
        var urlString = "http://xia2.kekenet.com/Sound/song/songs/51.mp3"
        var downloadUrl = NSURL(string: urlString)!
        backgroundTask = backgroundSession!.downloadTaskWithURL(downloadUrl)
        
        backgroundTask!.resume()
    }
    
    func extrctMusicInfo() {
        
        var location = NSURL(string: documents)!
        var palyerItem = AVPlayerItem(URL: location)
        let metadataList = palyerItem.asset.commonMetadata as! [AVMetadataItem]
        for iterm in metadataList
        {
            if iterm.commonKey == "title"
            {
                print("Title: \(iterm.stringValue)!")
            }
        }
    }

    @IBAction func startDownload(sender: UIButton) {
        downloadMusic()
    }
    
    //MARK: - delegate
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        print("finish download. location: \(location)")
        print("Home directory is: \(NSHomeDirectory())")
        
         if let documentURL = NSURL(string: documents)
         {
            do
            {
                print("destination location: \(documentURL)")
                //try filemanager.moveItemAtURL(location, toURL: documentURL!)
                try fileManager.copyItemAtURL(location, toURL: documentURL)
                print("location: \(documents)")
            }
            catch let error as NSError
            {
                print("Could not copy file to disk: \(error.localizedDescription)")
            }
        }
        
        extrctMusicInfo()
        
    }
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
        print("error: \(error?.localizedDescription)")
    }

}

