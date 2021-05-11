//
//  ViewController.swift
//  itunesGetApi
//
//  Created by Neha Penkalkar on 05/05/21.
//

import UIKit
import Alamofire
import Kingfisher

class ViewController: UIViewController, UISearchBarDelegate{
    @IBOutlet weak var songCV: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var data = [NSDictionary]()
    var realData = [NSDictionary]()
    var searching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAllData()
    }
    
    
    func getAllData(){
        
        if searchBar.text?.count == 0 {
            AF.request("https://itunes.apple.com/search?term=term&device_type=ios").responseJSON {(resp) in
                if let demo = resp.value as? NSDictionary {
                    self.data = demo.value(forKey: "results") as! [NSDictionary]
                    self.songCV.reloadData()
                }
                else {
                    print("Some Error Occured!")
                }
            }
            searchedData()
        }
    }
    
    
    func searchedData()  {
        guard let searchTxt = searchBar.text , searchTxt.count > 0 else {
            self.songCV.reloadData()
            return
        }
        
        AF.request("https://itunes.apple.com/search?term=\(searchTxt)&device_type=ios").responseJSON {(resp) in
            if let demo = resp.value as? NSDictionary {
                self.data = demo.value(forKey: "results") as! [NSDictionary]
                self.songCV.reloadData()
            }
            else {
                print("No Artist")
            }
        }
    }
}


//MARK:- Table View From Here
extension ViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searching = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searching = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searching = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchedData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCVC", for: indexPath) as! CustomCVC
        cell.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        let content = data[indexPath.row]
        
        let track = content.value(forKey: "trackName") as? String ?? "unknown"
        let collectionName = content.value(forKey: "collectionName") as? String ?? "unknown"
        let artistName = content.value(forKey: "artistName") as? String ?? "unknown"
        cell.songLbl.text = ("Track: \(track) \n \n Collection: \(collectionName) \n \n Artist: \(artistName)")
        
        let img = content.value(forKey: "artworkUrl100") as? String ?? "unknown"
        let url = URL(string: "\(img)")
        cell.imgView.kf.setImage(with: url)
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "PlayVC") as! PlayVC
        
        let content = data[indexPath.row]
        
        let aud = content.value(forKey: "previewUrl") as? String ?? "unknown"
        vc.song = aud
        
        let img = content.value(forKey: "artworkUrl100") as? String ?? "unknown"
        vc.img = img
        
        let trackName = content.value(forKey: "trackName") as? String ?? "unknown"
        vc.track = trackName
        
        present(vc, animated: true, completion: nil)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (floor(collectionView.frame.size.width/2))-6, height: (floor(collectionView.frame.size.height/1.3)))
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 6
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 6, left: 2, bottom: 6, right: 2)
    }
}

