//
//  Calculator.swift
//  Raman
//
//  Created by Denis Ricard on 2017-06-17.
//  Copyright © 2017 Hexaedre. All rights reserved.
//

import Foundation

struct Calculator {
    
    private struct IntermediateState {
        let firstOperand: Double
        let operation: (Double, Double) -> Double
        
        func perform(with secondOperand: Double) -> Double {
            return operation(firstOperand, secondOperand)
        }
    }
    
    private enum Operation {
        case constant(Double)
        case unaryOperation((Double) -> Double)
        case binaryOperation((Double, Double) -> Double)
        case equalOperation
    }
    
    // MARK: - Properties
    
    private var intermediateState: IntermediateState?
    
    private let operators: [String:Operation] = [
        "+": Operation.binaryOperation(+),
        "-": Operation.binaryOperation(-),
        "=": Operation.equalOperation
    ]
    
    mutating func performOperation(key: String, operand: Double?) -> Double? {
        if let function = operators[key] {
            switch function {
                
            case .constant(let value):
                return value
            case .unaryOperation(let functionToPerform):
                if let operand = operand {
                    return functionToPerform(operand)
                }
            case .binaryOperation(let functionToPerform):
                if let operand = operand {
                    intermediateState = IntermediateState(firstOperand: operand, operation: functionToPerform)
                    return nil
                }
            case .equalOperation:
                if let intermediateState = intermediateState, let operand = operand {
                    let value = intermediateState.perform(with: operand)
                    self.intermediateState = nil
                    return value
                } else if let operand = operand {
                    return operand
                }
            }
        }
        return nil
    }
}
