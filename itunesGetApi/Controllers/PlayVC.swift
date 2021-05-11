//
//  PlayVC.swift
//  itunesGetApi
//
//  Created by Neha Penkalkar on 11/05/21.
//

import UIKit
import Kingfisher
import AVKit

class PlayVC: UIViewController {
    
    var img = ""
    var song = ""
    var track = ""
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var playPause: UIButton!
    @IBOutlet weak var trackName: UILabel!
    
    var player = AVPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let url = URL(string: "\(img)")
        imgView.kf.setImage(with: url)
        
        trackName.text = track
        
        player = AVPlayer(url: URL(string: "\(song)")!)
        player.volume = 0.5
        playPause.setImage(UIImage(named: "pause"), for: .normal)
        player.play()
        
        NotificationCenter.default.addObserver(self, selector: #selector(playEnd), name: .AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    
    @objc func playEnd(){
        player.play()
        print("Play End")
    }
    
    
    @IBAction func playPausedPressed(_ sender: Any) {
        if let _ = player.currentItem {
            if player.timeControlStatus == .paused{
                playPause.setImage(UIImage(named: "pause"), for: .normal)
                player.play()
            }
            else if player.timeControlStatus == .playing{
                playPause.setImage(UIImage(named: "play"), for: .normal)
                player.pause()
            }
        }
    }
    
    
    @IBAction func slideChange(_ sender: UISlider) {
        let value = sender.value
        player.volume = value
    }
    
}
