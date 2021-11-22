//
//  Calculator - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {
    var newNumber: String = "" {
        didSet {
            newNumberLabel.text = newNumber
        }
    }
    
    var calculationRecord: [String] = []
    var isFirstEntry = true

    @IBOutlet weak var newNumberLabel: UILabel!
    @IBOutlet weak var newOperatorLabel: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newNumberLabel.text = "0"
        newOperatorLabel.text = ""
        stackView.arrangedSubviews.forEach {
            stackView.removeArrangedSubview($0)
        }
    }
    
    private func creatEntryView() -> UIView {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fill
        stack.spacing = 8
        
        let endRecordIndex = calculationRecord.endIndex
        let operatorLabel = UILabel()
        operatorLabel.text = calculationRecord[endRecordIndex - 2]
        operatorLabel.font = UIFont.preferredFont(forTextStyle: .title3)
        operatorLabel.textColor = UIColor.white
        let numberLabel = UILabel()
        numberLabel.text = calculationRecord[endRecordIndex - 1]
        numberLabel.font = UIFont.preferredFont(forTextStyle: .title3)
        numberLabel.textColor = UIColor.white
                                                
        stack.addArrangedSubview(operatorLabel)
        stack.addArrangedSubview(numberLabel)
        
        return stack
    }
    
    func addCalculationRecord() {
        guard newNumber.isEmpty == false  &&
                (newOperatorLabel.text?.isEmpty == false || isFirstEntry)
        else {
            clearEntry()
            return
        }
        isFirstEntry = false
        calculationRecord.append(newOperatorLabel.text ?? "")
        calculationRecord.append(newNumber)
        newNumber.removeAll()
        newNumberLabel.text = "0"
        newOperatorLabel.text = ""
        
        let recordView = creatEntryView()
        stackView.addArrangedSubview(recordView)
        
        // TODO: scroll
    }
    
    func clearEntry() {
        newNumber.removeAll()
        newNumberLabel.text = "0"
    }
    
    @IBAction func numberButton(_ sender: UIButton) {
        newNumber.append(sender.titleLabel?.text ?? "")
    }
    
    @IBAction func addButton(_ sender: UIButton) {
        addCalculationRecord()
        newOperatorLabel.text = "+"
    }
    
    @IBAction func subtractButton(_ sender: UIButton) {
        addCalculationRecord()
        newOperatorLabel.text = "-"
    }
    
    @IBAction func divideButton(_ sender: UIButton) {
        addCalculationRecord()
        newOperatorLabel.text = "/"
    }
    
    @IBAction func multiplyButton(_ sender: UIButton) {
        addCalculationRecord()
        newOperatorLabel.text = "*"
    }
    
    @IBAction func equalButton(_ sender: UIButton) {
        addCalculationRecord()
        var formula = ExpressionParser.parse(from: calculationRecord.joined())
        do {
            let calculationResult = try formula.result()
            newNumberLabel.text = String(calculationResult)
        } catch Operator.OperatorError.zeroDivision {
            newNumberLabel.text = "NaN"
        } catch {
            print(error)
        }
    }
    
    @IBAction func negativeButton(_ sender: UIButton) {
        if newNumber.first == "-" {
            newNumber.removeFirst()
        } else {
            newNumber.insert("-", at: newNumber.startIndex)
        }
    }
    
    @IBAction func clearEntryButton(_ sender: UIButton) {
        clearEntry()
    }
}

