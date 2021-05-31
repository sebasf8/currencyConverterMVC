//
//  CurrencyConverterViewViewController.swift
//  currencyConverterMVC
//
//  Created by Sebastian Fernandez on 20/05/2021.
//

import UIKit

class CurrencyConverterViewController: UIViewController {
    @IBOutlet weak private var baseCurrencyView: CurrencyView!
    @IBOutlet weak private var finalCurrencyView: CurrencyView!
    @IBOutlet weak private var baseAmountTextField: UITextField!
    @IBOutlet weak private var finalAmountLabel: UILabel!
    @IBOutlet weak private var errormMessageLabel: UILabel!
    
    private let baseCurrencyViewId = "base"
    private let finalCurrencyViewId = "final"
    private var selectedCurrencyViewId = ""
    private let repository = CurrencyConverterRepository()
    private var rates: RateGroup?
    private var baseCurrency = "USD"
    private var finalCurrency = "USD"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        baseCurrencyView.delegate = self
        baseCurrencyView.id = baseCurrencyViewId
        baseCurrencyView.configure(title: baseCurrency)

        finalCurrencyView.delegate = self
        finalCurrencyView.id = finalCurrencyViewId
        finalCurrencyView.configure(title: baseCurrency)
        
        finalAmountLabel.text = "0"
        fetchLatestRates()
    }
    
    private func showErrorMessage(_ message: String) {
        self.errormMessageLabel.text = message
        self.errormMessageLabel.isHidden = false
    }
    
    private func fetchLatestRates() {
        errormMessageLabel.isHidden = true
        repository.getLatestRate(from: self.baseCurrency){ [weak self] result in
            self?.fetchLatestRatesCompletion(result: result)
        }
    }
    
    private func fetchLatestRatesCompletion(result: Result<RateGroup, Error>) {
        switch result {
        case .success(let rateGroup):
            rates = rateGroup
            makeConvertion()
        case .failure(let error):
            showErrorMessage(error.localizedDescription)
        }
    }
    
    private func makeConvertion() {
        let baseAmount = Double(baseAmountTextField.text ?? "") ?? 0.0
        
        if let convertedAmmount = rates?.convert(amount: baseAmount, to: finalCurrency) {
            finalAmountLabel.text = String(format: "%.2f", convertedAmmount)
        }
    }
    
    @IBAction private func ammountChanged(_ sender: UITextField) {
        makeConvertion()
    }
    
    @IBAction private func invertCurrencies(_ sender: Any) {
        let exFinalCurrency = finalCurrency

        finalCurrency = baseCurrency
        baseCurrency = exFinalCurrency
        
        baseCurrencyView.configure(title: baseCurrency)
        finalCurrencyView.configure(title: finalCurrency)
        
        fetchLatestRates()
    }
}

//MARK: - CountryViewDelegate
extension CurrencyConverterViewController: CountryViewDelegate {
    func currencyButtonWasTapped(_ countryView: CurrencyView) {
        selectedCurrencyViewId = countryView.id ?? ""
        
        let countryPicker = CountryPickerViewController()
        countryPicker.delegate = self
        countryPicker.modalPresentationStyle = .pageSheet
        countryPicker.modalTransitionStyle = .coverVertical

        present(countryPicker, animated: true)
    }
}

//MARK: - CountryPickerViewControllerDelegate
extension CurrencyConverterViewController: CountryPickerViewControllerDelegate {
    func currencyWasSelected(_ countryPickerViewController: CountryPickerViewController, currency: Currency) {
        
        switch selectedCurrencyViewId {
        case baseCurrencyViewId:
            baseCurrency = currency.shortName
            baseCurrencyView.configure(title: currency.shortName)
            fetchLatestRates()
        case finalCurrencyViewId:
            finalCurrency = currency.shortName
            finalCurrencyView.configure(title: currency.shortName)
            makeConvertion()
        default:
            return
        }
    }
}
