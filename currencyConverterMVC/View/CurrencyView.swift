//
//  CountryView.swift
//  currencyConverterMVC
//
//  Created by Sebastian Fernandez on 20/05/2021.
//

import UIKit

protocol CountryViewDelegate {
    func currencyButtonWasTapped(_ currencyView: CurrencyView)
}

class CurrencyView: UIView {
    @IBOutlet weak private var nameButton: UIButton!
    
    var delegate: CountryViewDelegate?

    private let nibName = "CountryView"
    var id: String?
        
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    func commonInit() {
        guard let view = loadViewFromNib() else { return }
        view.frame = bounds
        addSubview(view)
    }
    
    func loadViewFromNib() -> UIView? {
        let nib = UINib(nibName: nibName, bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    func configure(title: String) {
        nameButton.setTitle(title, for: .normal)
    }
    
    @IBAction func currencyNameTapped(_ sender: UIButton) {
        delegate?.currencyButtonWasTapped(self)
    }
}
