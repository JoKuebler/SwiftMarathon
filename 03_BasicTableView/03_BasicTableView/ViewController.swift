//
//  ViewController.swift
//  BasicTableView
//
//  Created by Jonas Kübler on 04.07.19.
//  Copyright © 2019 Jonas.K. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var pictures = [String]()
    var sortedPictures = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Table View"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        for item in items {
            if item.hasPrefix("nss") {
                pictures.append(item)
            }
        }
        
        sortedPictures = pictures.sorted()
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Create reuseable Cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        // Set Text Label
        cell.textLabel?.text = "Picture \(indexPath.row + 1) of \(sortedPictures.count)"
        // Adjust Text Size
        cell.textLabel?.font = UIFont.systemFont(ofSize: 20)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.selectedImage = sortedPictures[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }


}

