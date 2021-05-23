//
//  CountryPickerViewController.swift
//  currencyConverterMVC
//
//  Created by Sebastian Fernandez on 23/05/2021.
//

import UIKit

protocol CountryPickerViewControllerDelegate {
    func didConuntrySelection(_ :CountryPickerViewController, country: (String, String))
}

class CountryPickerViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var countryPicker: UITableView!
    
    let cellIdentifier = "countryCell"
    var delegate: CountryPickerViewControllerDelegate?
    var repository: CurrencyConverterRepository = CurrencyConverterRepository()
    var currencies: [(String, String)]!
    var filteredCurrencies: [(String,String)]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let currencies = repository.getCurrencies() else { fatalError() }
        
        searchBar.delegate = self
        countryPicker.delegate = self
        countryPicker.dataSource = self
        self.currencies = currencies
        self.filteredCurrencies = self.currencies
        countryPicker.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
    }
}
    
//MARK: - UITableViewDelegate
extension CountryPickerViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCurrencies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        let (short, name) = filteredCurrencies[indexPath.row]
        cell.textLabel!.text = "\(short) - \(name)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didConuntrySelection(self, country: filteredCurrencies[indexPath.row])
        self.searchBar.text = ""
        self.filteredCurrencies = currencies
        countryPicker.reloadData()
        
        dismiss(animated: true)
    }
}

extension CountryPickerViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText != "" {
            filteredCurrencies = currencies.filter { (short, name) -> Bool in
                return short.contains(searchText.uppercased()) || name.lowercased().contains(searchText.lowercased())
            }
        } else {
            filteredCurrencies = currencies
        }
        
        self.countryPicker.reloadData()
    }
}
