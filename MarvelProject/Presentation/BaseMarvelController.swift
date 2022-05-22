//
//  BaseMarvelController.swift
//  MarvelProject
//
//  Created by Manuel Alvarez Marin on 20/5/22.
//

import Foundation
import UIKit


public class BaseMarvelController: UIViewController {
    public override func viewDidLoad() {
        super.viewDidLoad()
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = MarvelConstants.Color.MarvelRed
        appearance.titleTextAttributes = [.font: UIFont.boldSystemFont(ofSize: 20.0), .foregroundColor: UIColor.white]

        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
}
