//
//  HeroesViewCell.swift
//  Practica_IOS_Avanzado
//
//  Created by Daniel Serrano on 19/11/23.
//

import UIKit
import Kingfisher

class HeroesViewCell: UITableViewCell {
    //MARK: - CONSTANTS -
    static let identifier: String = "HeroesViewCell"
    static let sizeCell: CGFloat = 400
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var photoHeroe: UIImageView!
    @IBOutlet weak var heroDescription: UILabel!
    @IBOutlet weak var nameHeroe: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateView(
        name: String? = nil,
        photo: String? = nil,
        description: String? = nil
    ) {
        self.nameHeroe.text = name
        self.heroDescription.text = description
        self.photoHeroe.kf.setImage(with: URL(string: photo ?? ""))
    }
    
}
