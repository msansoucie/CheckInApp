//
//  VCViewImage.swift
//  AuctionCheckIn
//
//  Created by Matthew Sansoucie on 7/29/19.
//  Copyright © 2019 Matthew Sansoucie. All rights reserved.
//

import UIKit

class VCViewImage: UIViewController {

    var image: UIImage? = nil
    
    @IBOutlet weak var myImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        myImageView.image = image!
        
        // Do any additional setup after loading the view.
    }
    


}
