enum ExpressionParser {
    static func parse(from input: String) -> Formula {
        let splitInput = componentsByOperators(from: input)
        let operands = splitInput.compactMap { Double($0) }
        let operators = splitInput.compactMap { Operator(rawValue: Character(text: $0)) }
        let formula = Formula(operands: operands,
                              operators: operators)
        return formula
    }
    
    private static func componentsByOperators(from input: String) -> [String] {
        let operators = Operator.allCases.map { $0.rawValue }
        var result: [String] = [input]
        for `operator` in operators {
            result = result.flatMap { $0.split(with: `operator`) }
        }
        result = joinedNegativeNumber(from: result)
        return result
    }
    
    private static func joinedNegativeNumber(from input: [String]) -> [String] {
        var result: [String] = []
        
        for value in input {
            let isNegativeSign = (result.last?.isOperator == true || result.isEmpty) && value == "-"
            let isNegativeValue = result.last == "negative"
            
            if isNegativeSign {
                result.append("negative")
            } else if isNegativeValue {
                let negativeIndex = result.endIndex - 1
                result[negativeIndex] = "-" + value
            } else {
                result.append(value)
            }
        }
        return result
    }
}

fileprivate extension String {
    var isOperator: Bool {
        guard let char = Character(text: self) else {
            return false
        }
        
        let operators = Operator.allCases.map { $0.rawValue }
        for `operator` in operators {
            if char == `operator` {
                return true
            }
        }
        return false
    }
    
    func split(with target: Character) -> [String] {
        var result: [String] = []
        var number = ""
        for char in self {
            if char == target {
                result.append(number)
                result.append(String(char))
                number.removeAll()
            } else {
                number += String(char)
            }
        }
        
        if number.isEmpty == false {
            result.append(number)
        }
        return result
    }
}

fileprivate extension Character {
    init?(text: String) {
        guard text.count == 1 else {
            return nil
        }
        self.init(text)
    }
}
