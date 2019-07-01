//
//  VCPhotoPreview.swift
//  AuctionCheckIn
//
//  Created by Matthew Sansoucie on 6/11/19.
//  Copyright © 2019 Matthew Sansoucie. All rights reserved.
//

import UIKit

class VCPhotoPreview: UIViewController {

    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnUpload: UIButton!
    
    
    var myImage: UIImage!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        btnBack.layer.cornerRadius = 0.5 * btnBack.bounds.size.width
        btnUpload.layer.cornerRadius = 0.5 * btnUpload.bounds.size.width
        
        photo.image = self.myImage
        
        // Do any additional setup after loading the view.
    }
    
    
    //will upload image to CR report
    @IBAction func uploadImage(_ sender: Any) {
        
    }
    
    
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
