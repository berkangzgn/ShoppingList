//
//  ViewController.swift
//  ShoppingList
//
//  Created by Berkan Gezgin on 3.11.2021.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(saveButtonClicked))
    }
    
    @objc func saveButtonClicked(){
     performSegue(withIdentifier: "toVCDetails", sender: nil)
    }


}

