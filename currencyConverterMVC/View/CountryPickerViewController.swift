//
//  CountryPickerViewController.swift
//  currencyConverterMVC
//
//  Created by Sebastian Fernandez on 23/05/2021.
//

import UIKit

protocol CountryPickerViewControllerDelegate: AnyObject {
    func currencyWasSelected(_ countryPickerViewController: CountryPickerViewController, currency: Currency)
}

class CountryPickerViewController: UIViewController {
    @IBOutlet weak private var searchBar: UISearchBar!
    @IBOutlet weak private var countryPicker: UITableView!
    
    private let cellIdentifier = "countryCell"
    private let repository = CurrencyConverterRepository()
    private var currencies: [Currency] = []
    private var filteredCurrencies: [Currency] = []

    weak var delegate: CountryPickerViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        countryPicker.delegate = self
        countryPicker.dataSource = self
        currencies = repository.getCurrencies()
        filteredCurrencies = currencies
        countryPicker.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    }
}
    
//MARK: - UITableViewDelegate
extension CountryPickerViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredCurrencies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        let currency = filteredCurrencies[indexPath.row]
        cell.textLabel?.text = "\(currency.shortName) - \(currency.name)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.currencyWasSelected(self, currency: filteredCurrencies[indexPath.row])
        dismiss(animated: true)
    }
}

//MARK: - UISearchBarDelegate
extension CountryPickerViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            filteredCurrencies = filterCoincidencies(searchText)
        } else {
            filteredCurrencies = currencies
        }
        
        countryPicker.reloadData()
    }
    
    private func filterCoincidencies(_ searchText: String) -> [Currency] {
        currencies.filter { currency in
            currency.shortName.contains(searchText.uppercased()) || currency.name.lowercased().contains(searchText.lowercased())
        }
    }
}
