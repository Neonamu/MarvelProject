//
//  MarvelCharacterListViewController.swift
//  MarvelProject
//
//  Created by Manuel Alvarez Marin on 17/5/22.
//

import UIKit
import Combine

public final class MarvelCharacterListViewController: BaseMarvelController {
    // MARK: - Properties
    private var cancellables = Set<AnyCancellable>()

    private let viewModel: MarvelCharacterListViewModelProtocol
    private let coordinator: MarvelCharacterListCoordinatorProtocol?
    private lazy var dataSource = makeDataSource()

    private enum Section: CaseIterable { case characters }
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.delegate = self
        table.separatorStyle = .singleLine
        table.backgroundColor = .white
        table.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        table.register(MarvelCharacterListCell.nib, forCellReuseIdentifier: MarvelCharacterListCell.identifier)
        return table
    }()

    // MARK: - Initializer
    init(viewModel: MarvelCharacterListViewModelProtocol,
         coordinator: MarvelCharacterListCoordinatorProtocol? = nil) {
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
}

// MARK: - Setups
extension MarvelCharacterListViewController {
    private func setupLayout() {
        title = "Marvel Heroes"

        view.backgroundColor = UIColor.black
        view.addSubview(tableView)

        let safeAreaLayout = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayout.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeAreaLayout.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeAreaLayout.trailingAnchor)
        ])
    }

    private func setupBinding() {
        viewModel.dataSourcePublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.update(with: self.viewModel.dataSource)
            }
            .store(in: &cancellables)

        viewModel.errorMsgPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                if !self.viewModel.errorMsg.isEmpty {
                    self.showMessage(title: MarvelConstants.errorTitle, msg: self.viewModel.errorMsg)
                }
            }
            .store(in: &cancellables)
    }

    private func fetchData() {
        viewModel.fetchCharacters()
    }
}

// MARK: - Datasource
extension MarvelCharacterListViewController {
    private func setupDataSource() {
        tableView.delegate = self
        tableView.dataSource = dataSource
        tableView.reloadData()
    }

    private func makeDataSource() -> UITableViewDiffableDataSource<Section, MarvelCharacter> {
        let reuseIdentifier = MarvelCharacterListCell.identifier

        return UITableViewDiffableDataSource(
            tableView: tableView,
            cellProvider: {  tableView, indexPath, character in
                var tableViewCell = UITableViewCell()
                if let cell = tableView.dequeueReusableCell(
                    withIdentifier: reuseIdentifier,
                    for: indexPath
                ) as? MarvelCharacterListCell {
                    cell.selectionStyle = .none
                    cell.configure(character)
                    tableViewCell = cell
                }


                return tableViewCell
            }
        )
    }

    private func update(with list: [MarvelCharacter], animate: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, MarvelCharacter>()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(list, toSection: .characters)
        dataSource.apply(snapshot, animatingDifferences: animate)
    }
}

// MARK: - TableView Delegate
extension MarvelCharacterListViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = viewModel.dataSource[indexPath.row]
        coordinator?.coordinateToCharacterDetail(identifier: model.identifier)
    }

    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.dataSource.count - 1 {
            viewModel.fetchCharacters()
        }
    }
}
