//
//  ViewController.swift
//  09_NameToFaces
//
//  Created by Jonas Kübler on 25.08.19.
//  Copyright © 2019 Jonas.K. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var people = [Person]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPerson))
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath) as? PersonCell else {
            fatalError("Unable to load person cell.")
        }
        
        let person = people[indexPath.item]
        cell.label.text = person.name
        
        // Get image file and set it to imageview
        let path = getDocumentsDirectory().appendingPathComponent(person.image)
        cell.imageView.image = UIImage(contentsOfFile: path.path)
        
        cell.imageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.imageView.layer.borderWidth = 2
        cell.imageView.layer.cornerRadius = 4
        cell.layer.cornerRadius = 8
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let person = people[indexPath.item]
        
        // First collection view controller to rename person
        let ac = UIAlertController(title: "Rename person", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        ac.addAction(UIAlertAction(title: "OK", style: .default) { [weak self, weak ac] _ in
            guard let newName = ac?.textFields?[0].text else { return }
            person.name = newName
            self?.collectionView.reloadData()
        })
        
        // Second collection view controller to rename person
        let acTwo = UIAlertController(title: "What do you want to do?", message: nil, preferredStyle: .alert)
        acTwo.addAction(UIAlertAction(title: "Delete", style: .default) { [weak self] _ in
            self?.people.remove(at: indexPath.item)
            self?.collectionView.deleteItems(at: [indexPath])
        })
        
        acTwo.addAction(UIAlertAction(title: "Rename", style: .default) { [weak self] _ in
            self?.present(ac, animated: true)
        })
        
        acTwo.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(acTwo, animated: true)
    }
    
    // Presents the image picker by checking if camers is available or simulator is ran
    @objc func addNewPerson() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        
        // camera only available on real devices
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        }
        
        present(picker, animated: true)
    }
    
    // Is called when user chose image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // Get selected image
        guard let image = info[.editedImage] as? UIImage else { return }
        
        // Get name and path of image
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        
        let person = Person(name: "Unknown", image: imageName)
        people.append(person)
        collectionView.reloadData()
        
        // Image Picker has to be dismissed when done
        dismiss(animated: true)
    }
    
    // Gets the path of the directory the image is stored on the phone
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
}


