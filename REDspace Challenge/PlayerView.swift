//
//  PlayerView.swift
//  REDspace Challenge
//
//  Created by Michael Thompson on 2018-07-28.
//  Copyright © 2018 Michael Thompson. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class PlayerView: UIView {
    
    var asset: AVURLAsset?
    var playerItem: AVPlayerItem?
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
    var playerItemContext = 0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }

    func setUpPlayer(url: String) {
    
        guard let url = URL(string: url) else {
            return
        }
        
        asset = AVURLAsset(url: url)
        if let asset = self.asset {
            self.playerItem = AVPlayerItem(asset: asset)
            
            self.player = AVPlayer()
            self.playerLayer = AVPlayerLayer(player: self.player)
            //playerLayer.contentsScale = 9600
            self.playerItem?.addObserver(self,
                                    forKeyPath: #keyPath(AVPlayerItem.status),
                                    options: [.old, .new],
                                    context: &self.playerItemContext)
            
            self.player?.replaceCurrentItem(with: self.playerItem)
            self.playerLayer?.videoGravity = .resizeAspect // default
        }
        
    }
    
    func play() {
        
        player?.play()
        player?.rate = 1
        
    }
    
    func playFromStart() {
        let time = CMTime(value: 0, timescale: 1)
        
        player?.seek(to: time)
        player?.play()
        player?.rate = 1
    
    }
    
    func pause() {
        DispatchQueue.main.async {
            self.player?.pause()
        }
    }
    
    // observer callback
    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {
        
        // Only handle observations for the playerItemContext
        guard context == &playerItemContext else {
            super.observeValue(forKeyPath: keyPath,
                               of: object,
                               change: change,
                               context: context)
            return
        }
        
        if keyPath == #keyPath(AVPlayerItem.status) {
            let status: AVPlayerItemStatus
            
            // Get the status change from the change dictionary
            if let statusNumber = change?[.newKey] as? NSNumber {
                status = AVPlayerItemStatus(rawValue: statusNumber.intValue)!
            } else {
                status = .unknown
            }
            
            // Switch over the status
            switch status {
            case .readyToPlay:
                print("Player item is ready to play.")
                
            case .failed:
                print("// Player item failed. See error.")
            case .unknown:
                print("// Player item is not yet ready.")
            }
        }
    }
    
}
