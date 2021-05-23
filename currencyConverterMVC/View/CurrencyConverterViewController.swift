//
//  CurrencyConverterViewViewController.swift
//  currencyConverterMVC
//
//  Created by Sebastian Fernandez on 20/05/2021.
//

import UIKit

class CurrencyConverterViewController: UIViewController {
    @IBOutlet weak var countryBaseView: CountryView!
    @IBOutlet weak var countryFinalView: CountryView!
    @IBOutlet weak var ammountTextField: UITextField!
    @IBOutlet weak var convertedAmmountLabel: UILabel!
    
    var repository: CurrencyConverterRepository!
    var rates: Rate!
    
    lazy var countryPicker = CountryPickerViewController()
    var selectedButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countryBaseView.delegate = self
        countryFinalView.delegate = self
        
        countryBaseView.nameButton.setTitle("USD", for: .normal)
        countryFinalView.nameButton.setTitle("USD", for: .normal)
        convertedAmmountLabel.text = "0"
        
        repository = CurrencyConverterRepository()
        
        fetchRateData(for: "USD")
    }
    
    func fetchRateData(for currency: String) {
        repository.getLatestRate(from: currency){ response, error in
            guard error == nil else {
                fatalError()
            }
            
            guard response != nil else {
                fatalError()
            }
            
            self.rates = response!
            self.makeConvertion()
        }
    }
    
    func makeConvertion() {
        let ammount = Double(ammountTextField.text != "" ? ammountTextField.text! : "0.0")!
        
        let convertedAmmount = rates.convert(ammount: ammount, to: countryFinalView.nameButton.title(for: .normal)!)
        convertedAmmountLabel.text = String(format: "%.2f", convertedAmmount)
    }
    
    @IBAction func ammountChanged(_ sender: UITextField) {
        makeConvertion()
    }
    
    @IBAction func convertPressed(_ sender: Any) {
        makeConvertion()
    }
}

//MARK: - CountryViewDelegate
extension CurrencyConverterViewController: CountryViewDelegate {
    func currencyNameDidTap(_: CountryView, button: UIButton) {
        selectedButton = button
        
        if(countryPicker.delegate == nil) {
            countryPicker.delegate = self
        }
        
        countryPicker.modalPresentationStyle = .pageSheet
        countryPicker.modalTransitionStyle = .coverVertical

        present(countryPicker, animated: true)
    }
 
}

//MARK: - CountryPickerViewControllerDelegate
extension CurrencyConverterViewController: CountryPickerViewControllerDelegate {
    func didConuntrySelection(_: CountryPickerViewController, country: (String, String)) {
        guard let selectedButton = self.selectedButton else { return }
        
        let currency = country.0
        selectedButton.setTitle(currency, for: .normal)
        
        if selectedButton.isEqual(countryBaseView.nameButton) {
            fetchRateData(for: currency)
        } else {
            makeConvertion()
        }
    }
}
