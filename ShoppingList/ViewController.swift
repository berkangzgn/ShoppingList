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
    
    var selectedName = ""
    var selectedUUID : UUID?
    
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
            if sonuclar.count > 0 {
                    // sonuclar'ı Any'den NSManagedObjectContext dönüşümünü yapıtoruz.
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
            }
        } catch {
            print("hata var goççum")
        }
    }
    
    
    @objc func addButtonClicked() {
        selectedName = ""
        performSegue(withIdentifier: "toVCDetails", sender: nil)
    }
    
    
        // Kaç tane row olacak
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    
        // Row içerisinde ne olacak
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = nameArray[indexPath.row]
        return cell
    }
    
    
        // Seçilen ürünü details sayfasına gönderirken kullandığımız kodlar
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toVCDetails" {
            let destinationVC = segue.destination as! VCDetails
            destinationVC.selectedProductName = selectedName
            destinationVC.selectedProductUUID = selectedUUID
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedName = nameArray[indexPath.row]
        selectedUUID = idArray[indexPath.row]
        performSegue(withIdentifier: "toVCDetails", sender: nil)
    }
    
    
        // Veriyi DB ve listeden silme işlemi
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ShoppingList")
            let uuidString = idArray[indexPath.row].uuidString
            
                // id'ye göre filtreleme yapıyoruz
            fetchRequest.predicate = NSPredicate(format: "id = %@", uuidString)
            fetchRequest.returnsObjectsAsFaults = false
            
            do {
                let conclusions = try context.fetch(fetchRequest)
                if conclusions.count > 0 {
                    for conclusion in conclusions as! [NSManagedObject] {
                        if let id = conclusion.value(forKey: "id") as? UUID {
                                // Seçilen id istenilen id mi onu kontrol ediyoruz.
                            if id == idArray[indexPath.row]{
                                context.delete(conclusion)
                                nameArray.remove(at: indexPath.row)
                                idArray.remove(at: indexPath.row)
                                
                                    // Ana tableView değişkenine ulaşıp onu güncellemesini istiyoruz
                                self.tableView.reloadData()
                                
                                do {
                                    try context.save()
                                } catch {
                                    print("x")
                                }
                                break
                            }
                        }
                    }
                }
            } catch {
                print("Program has a error !!")
            }
        }
    }
}
