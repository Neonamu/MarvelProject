//
//  MarvelComicListCell.swift
//  MarvelProject
//
//  Created by Manuel Alvarez Marin on 20/5/22.
//

import UIKit

class MarvelComicListCell: UITableViewCell {
    // MARK: - IBOutlets -

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

    func configure(_ comic: MarvelComicsItem) {
        self.loadComic(comic)
    }

    // MARK: - Private Methods -
    private func loadComic(_ comic: MarvelComicsItem) {
        self.nameLbl?.text = comic.name
    }
}
