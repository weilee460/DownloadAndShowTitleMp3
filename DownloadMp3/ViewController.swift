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
    

    @IBOutlet weak var downloadIndicator: UIActivityIndicatorView!
    @IBOutlet weak var mp3NameLabel: UILabel!
    
    //创建URLSession Configuration
    var backgroundConfiguration: NSURLSessionConfiguration?
    //创建URLSession
    var backgroundSession: NSURLSession?
    //创建URLSessionTask
    var backgroundTask: NSURLSessionDownloadTask?
    //获取应用的文件路径
    let documents: String = "file://" + NSHomeDirectory() + "/Documents/1.mp3"
    //创建播放器
    var musicPlayer: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        backgroundConfiguration = NSURLSessionConfiguration.backgroundSessionConfigurationWithIdentifier("downLoadMusic")
        backgroundSession = NSURLSession(configuration: backgroundConfiguration!, delegate: self, delegateQueue: nil)
        downloadIndicator.hidesWhenStopped = true
    }
    //下载文件
    func downloadMusic() {
        print("Start download files!")
        
        //var urlString = "http://nginx.org/download/nginx-1.8.1.tar.gz"
        let urlString = "http://xia2.kekenet.com/Sound/song/songs/51.mp3"
        let downloadUrl = NSURL(string: urlString)!
        backgroundTask = backgroundSession!.downloadTaskWithURL(downloadUrl)
        
        backgroundTask!.resume()
        downloadIndicator.startAnimating()
    }
    //提取文件信息
    func extrctMusicInfo() {
        
        let location = NSURL(string: documents)!
        let palyerItem = AVPlayerItem(URL: location)
        let metadataList = palyerItem.asset.commonMetadata 
        for iterm in metadataList
        {
            if iterm.commonKey == "title"
            {
                print("Title: \(iterm.stringValue)!")
                //更新Label
                mp3NameLabel.text = iterm.stringValue!
            }
        }
    }
    
    
    //MARK: - Action
    @IBAction func startDownload(sender: UIButton) {
        downloadMusic()
    }
    
    //MARK: - NSURLSessionDownloadDelegate
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        
        print("finish download. location: \(location)")
        //停止indicator
        downloadIndicator.stopAnimating()
        
        let fileManager: NSFileManager = NSFileManager.defaultManager()
        
         if let documentURL = NSURL(string: documents)
         {
            do
            {
                //拷贝文件，从temp目录拷贝到Documents目录
                try fileManager.copyItemAtURL(location, toURL: documentURL)
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

