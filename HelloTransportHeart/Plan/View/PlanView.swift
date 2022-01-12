//
//  PlanView.swift
//  HelloTransportHeart
//
//  Created by 雲端開發部-廖彥勛 on 2022/1/12.
//

import UIKit

class PlanView: UIView {

    enum SectionLayoutKind: Int, CaseIterable, Hashable {
        case main
    }
    
    private let viewModel: PlanViewModel
    private var tableView: UITableView!
    
    private var cellHeightsDictionary: [IndexPath: CGFloat] = [:]
    private var act = UIActivityIndicatorView(style: .large)
    private var spinner = UIActivityIndicatorView(style: .large)

    init(viewModel: PlanViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        configureTableView()
        makeDateSource()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension PlanView {
    
    func configureTableView() {
       
        tableView = UITableView()
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableView.automaticDimension

        tableView.register(PlanTableViewCell.self, forCellReuseIdentifier: PlanTableViewCell.reuseIdentifier)
        
        act.color = traitCollection.userInterfaceStyle == .light ? UIColor.black : UIColor.white
        act.translatesAutoresizingMaskIntoConstraints = false
      
        self.addSubview(tableView)
        self.addSubview(act)
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            tableView.topAnchor.constraint(equalTo: self.topAnchor),
            
            act.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            act.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
        
        viewModel.reloadTableView = { [weak self] in
            DispatchQueue.main.async {
                self?.isLoading(isLoading: false)
                self?.isSpinnerLoading(isLoading: false)
                self?.applyInitialSnapshots()
            }
        }
        
        viewModel.showError = { [weak self] error in
            DispatchQueue.main.async {
                self?.isLoading(isLoading: false)
                self?.isSpinnerLoading(isLoading: false)
                self?.showErrorToast(error: error)
            }
        }
    }
    
    func makeDateSource() {
        tableView.dataSource = self
    }
    
    func applyInitialSnapshots() {
        
        DispatchQueue.main.async { [self] in
 
            tableView.reloadData()
        }
    }
}

// MARK: - UITableView DataSource
extension PlanView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.viewModel.respone != nil) {
            return self.viewModel.respone.routes.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PlanTableViewCell.reuseIdentifier, for: indexPath) as? PlanTableViewCell
        
        let routes = self.viewModel.respone.routes[indexPath.row]
        
        cell?.configureCell(routes: routes)
        
        return cell ?? UITableViewCell()
    }
}

// MARK: - UITableView Delegate
extension PlanView: UITableViewDelegate, UIScrollViewDelegate  {
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cellHeightsDictionary[indexPath] = cell.frame.size.height
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if let height =  self.cellHeightsDictionary[indexPath]{
            return height
        }
        return UITableView.automaticDimension
    }
}

// MARK: - Private
extension PlanView {
    func isLoading(isLoading: Bool) {
        if isLoading {
            act.startAnimating()
        } else {
            act.stopAnimating()
        }
        act.isHidden = !isLoading
    }
    
    func isSpinnerLoading(isLoading: Bool) {
        if isLoading {
            spinner.startAnimating()
        } else {
            spinner.stopAnimating()
        }
        spinner.isHidden = !isLoading
    }
    
    func showErrorToast(error: NetworkError) {
        print("showErrorToast \(error)")
    }
}
