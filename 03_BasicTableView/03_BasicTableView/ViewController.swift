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
    var countViews = [String: Int]()
    
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
        
        // Initialize UserDefaults and read data if already stored
        let defaults = UserDefaults.standard
        if let savedCounts = defaults.object(forKey: "views") as? Data {
            if let decodedViews = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedCounts) as? [String: Int] {
                countViews = decodedViews
            }
        }
        
        print(countViews)
        
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
            
            // Count views and store them into dictionary
            if let _ = countViews[sortedPictures[indexPath.row].description] {
                countViews[sortedPictures[indexPath.row].description]! += 1
            } else {
                countViews[sortedPictures[indexPath.row].description] = 1
            }
            
            save()
            
            vc.selectedImage = sortedPictures[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    // save countviews in user defaults
    func save() {
        if let saveData = try? NSKeyedArchiver.archivedData(withRootObject: countViews, requiringSecureCoding: false) {
             let defaults = UserDefaults.standard
             defaults.set(saveData, forKey: "views")
         }
    }
    
    
}

