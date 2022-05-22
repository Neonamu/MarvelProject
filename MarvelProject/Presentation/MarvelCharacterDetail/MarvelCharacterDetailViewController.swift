//
//  MarvelCharacterDetailViewController.swift
//  MarvelProject
//
//  Created by Manuel Alvarez Marin on 20/5/22.
//

import UIKit
import Combine

public final class MarvelCharacterDetailViewController: BaseMarvelController {
    // MARK: - Properties
    private var cancellables = Set<AnyCancellable>()

    private let viewModel: MarvelCharacterDetailViewModelProtocol
    private let coordinator: MarvelCharacterDetailCoordinatorProtocol?

    private enum Section: CaseIterable { case comics }
    private lazy var dataSource = makeDataSource()

    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.delegate = self
        table.separatorStyle = .none
        table.backgroundColor = .white
        table.contentInset = UIEdgeInsets(top: 30, left: 0, bottom: 20, right: 0)
        table.showsVerticalScrollIndicator = false
        table.register(MarvelComicListCell.nib, forCellReuseIdentifier: MarvelComicListCell.identifier)
        return table
    }()


    private let viewTitle: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()

    private lazy var labelTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 40.0)
        label.textColor = .black
        label.text = ""
        label.backgroundColor = .white.withAlphaComponent(0.7)
        return label
    }()

    private let image: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.image = UIImage(named: "character_placeholder")
        return image
    }()

    private let labelComics: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 20.0)
        label.textColor = .black
        label.text = "Comics"
        label.isHidden = true
        label.backgroundColor = .white
        return label
    }()


    // MARK: - Initializer
    init(viewModel: MarvelCharacterDetailViewModel,
         coordinator: MarvelCharacterDetailCoordinator? = nil) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupDataSource()
        setupBinding()
        fetchData()
    }

    // MARK: - Actions
    @objc private func buttonDismissTapped(_ sender: UIButton) {
        coordinator?.dismiss()
    }
}

// MARK: - Setups
extension MarvelCharacterDetailViewController {
    private func setupLayout() {
        view.backgroundColor = .white
        view.addSubview(image)
        view.addSubview(viewTitle)
        viewTitle.addSubview(labelTitle)
        view.addSubview(tableView)
        view.addSubview(labelComics)

        viewTitle.layer.cornerRadius = 10
        let safeAreaLayout = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            image.widthAnchor.constraint(equalTo: safeAreaLayout.widthAnchor),
            image.heightAnchor.constraint(equalTo: safeAreaLayout.widthAnchor),
            image.topAnchor.constraint(equalTo: safeAreaLayout.topAnchor),
            image.leadingAnchor.constraint(equalTo: safeAreaLayout.leadingAnchor),
            image.trailingAnchor.constraint(equalTo: safeAreaLayout.trailingAnchor)
        ])

        NSLayoutConstraint.activate([
            viewTitle.bottomAnchor.constraint(equalTo: image.bottomAnchor, constant: -5),
            viewTitle.leadingAnchor.constraint(equalTo: image.leadingAnchor, constant: 5),
            viewTitle.trailingAnchor.constraint(equalTo: image.trailingAnchor, constant: -5)
        ])


        NSLayoutConstraint.activate([
            labelTitle.topAnchor.constraint(equalTo: viewTitle.topAnchor, constant: 10),
            labelTitle.bottomAnchor.constraint(equalTo: viewTitle.bottomAnchor, constant: -10),
            labelTitle.leadingAnchor.constraint(equalTo: viewTitle.leadingAnchor, constant: 10),
            labelTitle.trailingAnchor.constraint(equalTo: viewTitle.trailingAnchor, constant: -10)
        ])

        NSLayoutConstraint.activate([
            labelComics.heightAnchor.constraint(equalToConstant: 30),
            labelComics.topAnchor.constraint(equalTo: image.bottomAnchor),
            labelComics.leadingAnchor.constraint(equalTo: safeAreaLayout.leadingAnchor),
            labelComics.trailingAnchor.constraint(equalTo: safeAreaLayout.trailingAnchor)
        ])

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: image.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeAreaLayout.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeAreaLayout.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10)
        ])
    }

    private func setupBinding() {
        viewModel.dataSourcePublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                guard let character = self.viewModel.dataSource else { return }
                self.update(with: character)
            }
            .store(in: &cancellables)
    }

    private func fetchData() {
        viewModel.fetchData()
    }
}

// MARK: - Datasource
extension MarvelCharacterDetailViewController {
    private func setupDataSource() {
        tableView.delegate = self
        tableView.dataSource = dataSource
        tableView.reloadData()
    }

    private func makeDataSource() -> UITableViewDiffableDataSource<Section, MarvelComicsItem> {
        let reuseIdentifier = MarvelComicListCell.identifier

        return UITableViewDiffableDataSource(
            tableView: tableView,
            cellProvider: {  tableView, indexPath, comic in
                var tableViewCell = UITableViewCell()
                if let cell = tableView.dequeueReusableCell(
                    withIdentifier: reuseIdentifier,
                    for: indexPath
                ) as? MarvelComicListCell {
                    cell.configure(comic)
                    tableViewCell = cell
                }
                return tableViewCell
            }
        )
    }

    private func update(with character: MarvelCharacter, animate: Bool = false) {
        labelTitle.text = character.name
        labelComics.isHidden = false
        if let thumbnail = character.thumbnail,
           let imageURL = URL(string: "\(thumbnail.path).\(thumbnail.thumbnailExtension)") {
            image.load(url: imageURL)
        }
        if let comics = character.comics?.comicItems {
            var snapshot = NSDiffableDataSourceSnapshot<Section, MarvelComicsItem>()
            snapshot.appendSections(Section.allCases)
            if comics.isEmpty {
                let comic = MarvelComicsItem(resourceURI: nil, name: "No comics available")
                snapshot.appendItems([comic], toSection: .comics)
            } else {
                snapshot.appendItems(comics, toSection: .comics)
            }

            dataSource.apply(snapshot, animatingDifferences: animate)
        }
    }
}

// MARK: - TableView Delegate
extension MarvelCharacterDetailViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
