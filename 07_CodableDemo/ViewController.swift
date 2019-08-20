//
//  ViewController.swift
//  07_CodableDemo
//
//  Created by Jonas Kübler on 11.08.19.
//  Copyright © 2019 Jonas.K. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var petitions = [Petition]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Runs selector method and all methods in it in background
        performSelector(inBackground: #selector(fetchData), with: nil)
        
        //self.navigationController?.navigationBar.topItem.leftBarButtonItem =
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(title: "Credits", style: .plain, target: self, action: #selector(showCredits))
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(promptForAnswer))
        
        // COMMENTED OUT TO IMPLEMENT PERFORM SELECTOR BUT MAYBE HELPFUL LATER
        
        //          let urlString: String
        //
        //          //self.navigationController?.navigationBar.topItem.leftBarButtonItem =
        //          navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(title: "Credits", style: .plain, target: self, action: #selector(showCredits))
        //
        //          // Load different files depending on tag of TabItem
        //          if navigationController?.tabBarItem.tag == 0 {
        //              urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        //          } else {
        //              urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        //          }
        //        // Download does not block main thread anymore
        //        // Never do UIWork on a background thread
        //        DispatchQueue.global(qos: .userInitiated) .async { [weak self] in
        //            // Get json date as Data object and parse it
        //            if let url = URL(string: urlString) {
        //                if let data = try? Data(contentsOf: url) {
        //                    // Reload data in this method down below is pushed back to main thread because it is UIWork
        //                    self?.parseJson(json: data)
        //                } else {
        //                    // Show alert in this method down below is pushed back to main thread because it is UIWork
        //                    self?.showError()
        //                }
        //            } else {
        //                self?.showError()
        //            }
        //        }
        
    }
    
    @objc func promptForAnswer() {
        
        let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        ac.addTextField()
        let submitAction = UIAlertAction(title: "Submit", style: .default) {
            [weak self, weak ac] _ in
            guard let answer = ac?.textFields?[0].text else { return }
            self?.submit(answer)
        }
        
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    func submit(_ answer: String) {
        let lowerAnswer = answer.lowercased()
        let capitalized = answer.capitalized
        let filteredArray = petitions.filter { $0.title.contains(lowerAnswer) || $0.title.contains(capitalized)}
        petitions = filteredArray
        print(petitions)
        self.tableView.reloadData()
    }
    
    @objc func fetchData() {
        
        let urlString: String
        
        // Load different files depending on tag of TabItem
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        // Get json date as Data object and parse it
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                // Reload data in this method down below is pushed back to main thread because it is UIWork
                parseJson(json: data)
            } else {
                // Calls showError on MainThread using perform selector because it is UI work
                performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
            }
        } else {
            performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
        }
    }
    
    @objc func showCredits() {
        let ac = UIAlertController(title: "Credits", message: "Data comes from the 'We the people' API of the White House", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    @objc func showError() {
            let ac = UIAlertController(title: "Loading Error", message: "There was a problem loading the feed, check connection!", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
    }
    
    func parseJson(json: Data) {
        
        let decoder = JSONDecoder()
        
        // Convert Data from Decoder to singles petitions object
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            // Reload table view on mainThread
            tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
        } else {
            // Catches error when error cant be showed
            performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
        }
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let petition = petitions[indexPath.row]
        
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

