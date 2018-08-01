//
//  VideoPlayer.swift
//  REDspace Challenge
//
//  Created by Michael Thompson on 2018-08-01.
//  Copyright © 2018 Michael Thompson. All rights reserved.
//

import AVKit

class VideoPlayer: NSObject {
    var asset: AVAsset!
    var playerItem: AVPlayerItem?
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
    var playerItemContext = 0
    var playerView: PlayerView
    
    init(playerView: PlayerView, asset: AVAsset) {
        self.playerView = playerView
        self.asset = asset
        super.init()
        
        setUpPlayer()
    }

    func setUpPlayer() {
        playerItem = AVPlayerItem(asset: self.asset)
        playerItem?.preferredForwardBufferDuration = 5
        player = AVPlayer()
        player?.replaceCurrentItem(with: self.playerItem)
        playerLayer = AVPlayerLayer(player: self.player)
        
        player?.addObserver(self,
            forKeyPath: #keyPath(AVPlayer.timeControlStatus),
            options: [.old, .new],
            context: &self.playerItemContext)
        
        playerItem?.addObserver(self,
            forKeyPath: #keyPath(AVPlayerItem.status),
            options: [.old, .new],
            context: &self.playerItemContext)
        
        playerLayer?.videoGravity = .resizeAspect // default
        player?.automaticallyWaitsToMinimizeStalling = false
        playerItem?.preferredForwardBufferDuration = 0
    }
    
    func play() {
        player?.playImmediately(atRate: 1)
    }
    
    func playFromStart() {
        let time = CMTime(value: 0, timescale: 1)
        
        player?.seek(to: time)
        player?.playImmediately(atRate: 1)
    }
    
    func pause() {
        //DispatchQueue.main.async {
            self.player?.pause()
        //}
    }
    
    
    // MARK: - Observer callback
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
            
            switch status {
            case .readyToPlay:
                print("--- Player item is ready to play.")
                play()
            case .failed:
                print("---  Player item failed.")
            case .unknown:
                print("--- Player item is not yet ready.")
            }
        } else if keyPath == #keyPath(AVPlayer.timeControlStatus) {
            // Just info for this use case...
            if player?.timeControlStatus == .playing {
                print("--- Player is playing.")
            } else {
                print("--- Player is NOT playing.")
            }
        }
    }
}

