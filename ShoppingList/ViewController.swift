//
//  ViewController.swift
//  ShoppingList
//
//  Created by Berkan Gezgin on 3.11.2021.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var tableView: UITableView!
    
    
    var nameArray = [String]()
    var idArray = [UUID]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // Sağ üstteki ekleme butonu
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addButtonClicked))
        
        giveData()
    }
    
    
    // Seelctor - dataAdded bildiirmi gelirse ne yapacağı
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(giveData), name: NSNotification.Name(rawValue: "dataAdded"), object: nil)
    }
    
    
    @objc func giveData() {
        // Aynı üürnden 2 ve daha fazla eklenirse ana ekranda bunların filtrelenmesi
        nameArray.removeAll(keepingCapacity: false)
        idArray.removeAll(keepingCapacity: false)
        
        // DB bağlanma
        let context = (UIApplication.shared.delegate as? AppDelegate)!.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ShoppingList")
        // Çok büyük verileri çekerken cashing mekanizmasından faydalanmaya yarar
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            // Any döndüğü için - try context.fetch - dönüştürdük.
            let sonuclar = try context.fetch(fetchRequest)
            
            // sonuclar'ı ANy'den NSManagedObjectContext dönüşümünü yapıtoruz.
            for sonuc in sonuclar as! [NSManagedObject]{
                    // Verdiğimiz anahtar kelime bize istediğimiz sonucu verecektir.
                if let name = sonuc.value(forKey: "name") as? String {
                    nameArray.append(name)
                }
                if let id = sonuc.value(forKey: "id") as? UUID {
                    idArray.append(id)
                }
            }
            
            // Verileri güncelledikten sonra tabloyu güncellemesi için
            tableView.reloadData()
            
        } catch {
            print("hata var goççum")
        }
        
    }
    
    
    @objc func addButtonClicked(){
     performSegue(withIdentifier: "toVCDetails", sender: nil)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = nameArray[indexPath.row]
        return cell
    }
}
