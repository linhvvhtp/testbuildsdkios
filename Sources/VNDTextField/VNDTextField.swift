import Foundation
import UIKit

// MARK: - Define
public enum TitleButton {
    case buttonOne
    case buttonTwo
    case buttonThree
    
    public var setTitileButton: String {
        switch self {
        case .buttonOne:
            if let listSuggest = UserDefaultHelper.suggestions {
                let index = 0
                if listSuggest.count > 0 && index < listSuggest.count {
                    return listSuggest[index]
                }
            }
        case .buttonTwo:
            if let listSuggest = UserDefaultHelper.suggestions {
                let index = 1
                if listSuggest.count > 1 && index < listSuggest.count {
                    return listSuggest[index]
                }
            }
        case .buttonThree:
            if let listSuggest = UserDefaultHelper.suggestions {
                let index = 2
                if listSuggest.count > 2 && index < listSuggest.count {
                    return listSuggest[index]
                }
            }
        }
        return ""
    }
}

// MARK: - VNDTextField
public class VNDTextField: UITextField {
    
    private let viewSuggest: UIView = {
        let accessoryView = UIView(frame: .zero)
        accessoryView.backgroundColor = .white
        return accessoryView
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 5
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private let button1: UIButton = {
        let title: TitleButton = .buttonOne
        let button = UIButton()
        button.backgroundColor = .gray
        button.setTitle(title.setTitileButton, for: .normal)
        button.layer.cornerRadius = 5.0
        return button
    }()
    
    private let button2: UIButton = {
        let title: TitleButton = .buttonTwo
        let button = UIButton()
        button.backgroundColor = .gray
        button.setTitle(title.setTitileButton, for: .normal)
        button.layer.cornerRadius = 5.0
        return button
    }()
    
    private let button3: UIButton = {
        let title: TitleButton = .buttonThree
        let button = UIButton()
        button.backgroundColor = .gray
        button.setTitle(title.setTitileButton, for: .normal)
        button.layer.cornerRadius = 5.0
        return button
    }()
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
        commonInit()
        addViewSuggest()
        saveListSuggest()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        makeUI()
        commonInit()
        addViewSuggest()
        saveListSuggest()
    }
    
    /// Set background for buttons
    /// - Parameter backgroudColor: backgroudColor for button
    public func setButtonBackGroundColor(backgroudColor: UIColor) {
        self.button1.backgroundColor = backgroudColor
        self.button2.backgroundColor = backgroudColor
        self.button3.backgroundColor = backgroudColor
        self.buttonNeedDisplay()
    }
    
    /// Set corner Radius for buttons
    /// - Parameter cornerRadius: cornerRadius for buttons
    public func setButtonCornerRadius(cornerRadius: CGFloat) {
        self.button1.layer.cornerRadius = cornerRadius
        self.button2.layer.cornerRadius = cornerRadius
        self.button3.layer.cornerRadius = cornerRadius
        self.buttonNeedDisplay()
    }
        
    private func buttonNeedDisplay() {
        self.button1.setNeedsDisplay()
        self.button2.setNeedsDisplay()
        self.button3.setNeedsDisplay()
    }
    
    /// Init Data
    private func saveListSuggest() {
        UserDefaultHelper.suggestions = ["100.000", "300.000", "500.000"]
    }
    
    private func makeUI() {
        translatesAutoresizingMaskIntoConstraints = false
        keyboardType = .numberPad
        textAlignment = .left
        font = UIFont.preferredFont(forTextStyle: .title2)
        minimumFontSize = 12
        autocorrectionType = .no
        returnKeyType = .go
        clearButtonMode = .whileEditing
        placeholder = "0đ"
    }
    
    private func addViewSuggest() {
        viewSuggest.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40)
        viewSuggest.translatesAutoresizingMaskIntoConstraints = false
        button1.translatesAutoresizingMaskIntoConstraints = false
        button2.translatesAutoresizingMaskIntoConstraints = false
        button3.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(button1)
        stackView.addArrangedSubview(button2)
        stackView.addArrangedSubview(button3)
        viewSuggest.addSubview(stackView)
        let padding: CGFloat = 5
        
        // contrain
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: viewSuggest.topAnchor, constant: padding),
            stackView.leadingAnchor.constraint(equalTo: viewSuggest.leadingAnchor, constant: padding),
            stackView.bottomAnchor.constraint(equalTo: viewSuggest.bottomAnchor, constant: -padding),
            stackView.trailingAnchor.constraint(equalTo: viewSuggest.trailingAnchor, constant: -padding)
        ])
        
        inputAccessoryView = viewSuggest
    }
    
    private func commonInit() {
        self.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        button1.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
        button2.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
        button3.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
    }
    
    @objc private func textDidChange() {
        let inputText = getAmount()
        if let inputText = Int(inputText) {
            self.text = formatCurrency(inputText)
        }
        
        if let newPosition = self.position(from: self.endOfDocument, offset: -2) {
            self.selectedTextRange = self.textRange(from: newPosition, to: newPosition)
        }
        
        guard let inputText = self.text else {
            return
        }
        
        if inputText.count > 0 && inputText.count < 4 {
            guard let inputText = Int(inputText) else {
                return
            }
            
            let amountInput1 = df2so(inputText * 1000)
            let amountInput2 = df2so(inputText * 10000)
            let amountInput3 = df2so(inputText * 100000)
            
            button1.setTitle(String(amountInput1), for: .normal)
            button2.setTitle(String(amountInput2), for: .normal)
            button3.setTitle(String(amountInput3), for: .normal)
        }
    }
    
    @objc private func buttonAction(_ button: UIButton) {
        switch button {
        case button1:
            guard var inputText = button1.currentTitle else {
                return
            }
            inputText.removeAll { $0 == "." }
            
            if let text = Int(inputText) {
                return self.text = formatCurrency(text)
            }
        case button2:
            guard var inputText = button2.currentTitle else {
                return
            }
            inputText.removeAll { $0 == "." }
            
            if let text = Int(inputText) {
                return self.text = formatCurrency(text)
            }
        case button3:
            guard var inputText = button3.currentTitle else {
                return
            }
            
            inputText.removeAll { $0 == "." }
            
            if let text = Int(inputText) {
                return self.text = formatCurrency(text)
            }
        default:
            break
        }
    }
    
    /// Get text in texfield convert to int
    /// - Returns: interger
    public func getAmount() -> String {
        guard var inputText = self.text else {
            return ""
        }
        
        // remove symbol from text in textfield
        let charecterDeleted = "đ"
        inputText.removeAll(where: { charecterDeleted.contains($0) })
        
        // remove "." from text in textfield
        inputText.removeAll { $0 == "." }
        
        // remove space from text in textfield
        inputText.removeAll { $0 == " " }
        
        return inputText
    }
    
    /// Format input number to string
    /// - Parameter inputNumber: ext in textfield as Int
    /// - Parameter symbol: defaufl character  = "đ"
    /// - Returns: type currency
    private func formatCurrency(_ inputNumber: Int) -> String {
        let formatter = NumberFormatter()
        formatter.currencySymbol = "đ"
        formatter.currencyGroupingSeparator = "."
        formatter.locale = Locale(identifier: Constant.PRICE_LOCATION)
        formatter.positiveFormat = "#,##0 ¤"
        formatter.numberStyle = .currency
        return formatter.string(from: inputNumber as NSNumber)!
    }
    
    /// Format number
    /// - Parameter amount: text in textfied as Int
    /// - Returns: type decimal
    private func df2so(_ amount: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.groupingSeparator = "."
        numberFormatter.groupingSize = 3
        numberFormatter.usesGroupingSeparator = true
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: amount as NSNumber)!
    }
}
