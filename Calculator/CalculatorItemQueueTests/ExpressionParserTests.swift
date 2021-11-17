import XCTest
@testable import Calculator

class ExpressionParserTests: XCTestCase {

    func test_parse() {
        let operands: [Double] = [1, 2, 3, 4, 5]
        let operators = ["+", "-", "*", "/"].compactMap { Operator(rawValue: $0) }
        var formula = Formula(operands: operands,
                              operators: operators)
        let input = "1+2-3*4/5"
        var formulaFromText = ExpressionParser.parse(from: input)
        XCTAssertEqual(try? formulaFromText.result(), try? formula.result())
    }
    
    func test_parse_남는_숫자는_무시() {
        let operands: [Double] = [1, 2, 3, 4, 5, 6]
        let operators = ["+", "-", "*", "/"].compactMap { Operator(rawValue: $0) }
        var formula = Formula(operands: operands,
                              operators: operators)
        let input = "1+2-3*4/5"
        var formulaFromText = ExpressionParser.parse(from: input)
        XCTAssertEqual(try? formulaFromText.result(), try? formula.result())
    }
    
    func test_parse_음수_변환() {
        let operands: [Double] = [-1, -3]
        let operators = ["+"].compactMap { Operator(rawValue: $0) }
        var formula = Formula(operands: operands,
                              operators: operators)
        let input = "-1+-3"
        var formulaFromText = ExpressionParser.parse(from: input)
        XCTAssertEqual(try? formulaFromText.result(), try? formula.result())
    }
}
