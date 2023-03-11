//
//  ViewController.swift
//  DiffTable
//
//  Created by Maxim Soloboev on 11.03.2023.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Model
    
    enum Section {
        case one
    }
    
    struct MyCell: Hashable {
        let title: Int
        var isSelect: Bool
    }
    
    lazy var cells: [MyCell] = (0...30).map { MyCell(title: $0, isSelect: false) }
    
    
    // MARK: - Data Source
    
    var dataSource: UITableViewDiffableDataSource<Section, MyCell>!
    
    func createDataSource() {
        dataSource = UITableViewDiffableDataSource(tableView: tableView) { tableView, indexPath, data in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell()
            cell.textLabel?.text = "\(data.title)"
            cell.accessoryType = data.isSelect ? .checkmark : .none
            return cell
        }
        dataSource.defaultRowAnimation = .fade
    }
    
    func updateData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, MyCell>()
        snapshot.appendSections([.one])
        snapshot.appendItems(cells, toSection: .one)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    // MARK: - Table View
    
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.layer.cornerRadius = 10
        table.bounces = false
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.delegate = self
        return table
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupHierarchy()
        setupNavigation()
        setupHierarchy()
        setupLayout()
        createDataSource()
        updateData()
    }
    
    // MARK: - Setup
    
    private func setupView() {
        view.backgroundColor = .systemGray5
    }
    
    private func setupNavigation() {
        title = "task-4"
        navigationController?.navigationBar.barTintColor = .systemGray5
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "shuffle",
            style: .plain,
            target: self,
            action: #selector(pressShuffle)
        )
    }
    
    private func setupHierarchy() {
        view.addSubview(tableView)
    }
    
    private func setupLayout() {
        view.subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 10),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
        ])
    }
    
    @objc func pressShuffle() {
        cells.shuffle()
        updateData()
    }
}

// MARK: - Delegate

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if cells[indexPath.row].isSelect {
            cells[indexPath.row].isSelect.toggle()
        } else {
            cells[indexPath.row].isSelect.toggle()
            let removedCell = cells.remove(at: indexPath.row)
            cells.insert(removedCell, at: 0)
        }
        updateData()
    }
}
