//
//  ViewController.swift
//  TODO
//
//  Created by DonorRaja on 7/06/21.
//

import UIKit

class DetailsViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var userId: UILabel!
    
    @IBOutlet weak var detailLabel: UILabel!
    
    @IBOutlet weak var completedLabel: UILabel!
    
    //MARK: - Variables
    var userID:String?
    var detailText:String?
    var completedText:String?
    
    //MARK: - ViewLifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.userId.text = userID
        self.detailLabel.text = detailText
        self.completedLabel.text = completedText
        
    }
    

}

