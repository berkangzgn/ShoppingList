//
//  VCDetails.swift
//  ShoppingList
//
//  Created by Berkan Gezgin on 3.11.2021.
//

import UIKit

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

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        productView.image = info[.originalImage] as? UIImage
        // pickerController kapatmak için
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButton(_ sender: Any) {
        
    }
    
}
