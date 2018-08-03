//
//  HorizontalScrollViewController.swift
//  REDspace Challenge
//
//  Created by Michael Thompson on 2018-07-28.
//  Copyright © 2018 Michael Thompson. All rights reserved.
//

import UIKit
import AVKit

class HorizontalScrollViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let videoLoader: VideoLoader = VideoLoader()
    var assets: [AVAsset] = []
    var players: [Player] = []
    var currentPlayerIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        activityIndicator.startAnimating()
        preLoadAssets()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: - setup methods
    
    func preLoadAssets() {
        videoLoader.loadAssets { (data) in
            self.activityIndicator.stopAnimating()
            if data.count > 0 {
                self.assets = data
                self.createPlayers()
                self.configureScrollView()
            
                // play first asset in first player view
                guard let firstPlayer = self.players.first else {return }
                if let playerLayer = firstPlayer.playerLayer {
                    self.view.layer.addSublayer(playerLayer)
                    playerLayer.frame = self.view.frame
                    //self.navigationItem.title = "Video Feed 1"
                    firstPlayer.playerView.titleLabel.text = "Video Feed 1"
                    firstPlayer.play()
                }
            }
        }
    }
    
    func createPlayers() {
        for asset in assets {
            let playerView = Bundle.main.loadNibNamed("PlayerView", owner: self, options: nil)?.first as! PlayerView
            let videoPlayer = VideoPlayer(playerView: playerView, asset: asset)
            players.append(videoPlayer)
        }
        return
    }

    func configureScrollView() {
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(players.count), height: view.frame.height)
        
        for i in 0 ..< players.count {
            players[i].playerView.frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: view.frame.height)
            scrollView.addSubview(players[i].playerView)
        }
    }

}


// MARK: - Scrollview delegate

extension HorizontalScrollViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let pageIndex = Int(round(scrollView.contentOffset.x / view.frame.width))
        if pageIndex != currentPlayerIndex {
            players[currentPlayerIndex].pause()
            if let currentPlayerLayer = players[currentPlayerIndex].playerLayer, let pageIndexPlayerLayer = players[pageIndex].playerLayer {
                view.layer.replaceSublayer(currentPlayerLayer, with: pageIndexPlayerLayer)
                pageIndexPlayerLayer.frame = view.frame
//                players[pageIndex].play()
//                navigationItem.title = "Video Feed \(pageIndex + 1)"
                players[pageIndex].playerView.titleLabel.text = "Video Feed \(pageIndex + 1)"
                players[pageIndex].playFromBeginning()
            }
            currentPlayerIndex = pageIndex
        }
    }
    
}


