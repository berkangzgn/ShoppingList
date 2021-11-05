//
//  VCDetails.swift
//  ShoppingList
//
//  Created by Berkan Gezgin on 3.11.2021.
//

import UIKit
import CoreData

class VCDetails: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var productView: UIImageView!
    @IBOutlet weak var productName: UITextField!
    @IBOutlet weak var price: UITextField!
    @IBOutlet weak var brand: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Klavyeyi kapatmak için ekranın herhangi bir yerine tıklanma durumu
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
        // Tıklandığında atanacak yer bildirimi
        view.addGestureRecognizer(gestureRecognizer)
        
        // Kullanıcı resim ile etkileşime geçebilsin diye
        productView.isUserInteractionEnabled = true
        let imageGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        productView.addGestureRecognizer(imageGestureRecognizer)
    }
    
    
    // Klavyeyi kapatma fonksiyonu
    @objc func closeKeyboard() {
        view.endEditing(true)
    }
    
    
    // Resim seçme fonk
    @objc func chooseImage() {
        let  picker = UIImagePickerController()
        picker.delegate = self
        // Kamera ile ilgili ne yapılacağını bu satırda belirliyoruz.
        picker.sourceType = .photoLibrary
        // Kullanıcı resim seçtikten sonra düzenleme işlemlerine izin verecek miyiz?
        picker.allowsEditing = true
        // Present : Alert kontrolü gibi. Completion : Bu işlem bitince bir şey yapmak istiyor musun?
        present(picker, animated: true, completion: nil)
    }

    
    // Resmi seçtikten sonra ekleme ekranına seçilen resmi ekleme
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        productView.image = info[.originalImage] as? UIImage
        // pickerController kapatmak için
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func saveButton(_ sender: Any) {
        // Kayıt işlemlerimizi AppDelegate altındaki context metoduyla yapıyoruz. Alttaki kodlar yardımızyla oraya erişiyoruz.
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let shopping = NSEntityDescription.insertNewObject(forEntityName: "ShoppingList", into: context)
        
        
        // DB ürün özlk ekleme
        shopping.setValue(productName.text!, forKey: "name")
        shopping.setValue(brand.text!, forKey: "brand")
        if let price = Int(price.text!) {
            shopping.setValue(price, forKey: "price")
        }
        shopping.setValue(UUID(), forKey: "id")
            // compressionQuality : Sıkıştırma kalitesi
        let data = productView.image!.jpegData(compressionQuality: 0.5)
        shopping.setValue(data, forKey: "image")
        
        // Kayıt kontrol
        do {
            try context.save()
            print("kayıt okeyto beybito")
        } catch{
            print("hata var goççum")
        }
        
        // Girilen bilgileri post etme
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "dataAdded"), object : nil)
        // Ürün ekledikten sonra ana ekrana geri dönme
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
}
