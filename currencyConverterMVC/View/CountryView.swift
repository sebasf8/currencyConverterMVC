//
//  CountryView.swift
//  currencyConverterMVC
//
//  Created by Sebastian Fernandez on 20/05/2021.
//

import UIKit

protocol CountryViewDelegate {
    func currencyNameDidTap(_: CountryView, button: UIButton)
}

class CountryView: UIView {
    @IBOutlet weak var nameButton: UIButton!
    
    let nibName = "CountryView"
    var delegate: CountryViewDelegate?

        
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
        view.frame = self.bounds
        self.addSubview(view)
    }
    
    func loadViewFromNib() -> UIView? {
        let nib = UINib(nibName: nibName, bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    
    @IBAction func currencyNameTapped(_ sender: UIButton) {
        delegate?.currencyNameDidTap(self, button: sender)
    }
}
