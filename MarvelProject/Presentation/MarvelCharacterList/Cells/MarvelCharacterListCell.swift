//
//  MarvelCharacterListCell.swift
//  MarvelProject
//
//  Created by Manuel Alvarez Marin on 19/5/22.
//

import UIKit

class MarvelCharacterListCell: UITableViewCell {
    // MARK: - IBOutlets -

    @IBOutlet private weak var characterImg: UIImageView!
    @IBOutlet private weak var nameLbl: UILabel!

    // MARK: - Properties -

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    // MARK: - identifiers

    static var nib: UINib {
        return UINib(nibName: identifier, bundle: Bundle(for: self))
    }

    static var  identifier: String {
        return String(describing: self)
    }

    func configure(_ character: MarvelCharacter) {
        self.loadCharacterData(character)
    }
}

private extension MarvelCharacterListCell {
    private func loadCharacterData(_ character: MarvelCharacter) {
        characterImg.image = nil
        if let thumbnail = character.thumbnail,
           let imageURL = URL(string: "\(thumbnail.path).\(thumbnail.thumbnailExtension)") {
            characterImg.load(url: imageURL)
        }
        self.nameLbl?.text = character.name
    }
}
