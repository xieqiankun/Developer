//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by 谢乾坤 on 2/24/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

import Foundation

class CalculatorBrain {
    
    private enum Op: CustomStringConvertible
    {
        case Operand(Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
        
        var description: String {
            get{
                switch self {
                case .Operand(let operand):
                    return "\(operand)"
                case .UnaryOperation(let symbol, _):
                    return symbol
                case .BinaryOperation(let symbol, _):
                    return symbol
                    
                }
            }
        }
    }
    
    
    //var knownOps = Dictionary<String, Op>()
    private var knownOps = [String:Op]()
    
    //Or do thing like var opStack = [Op]()
    private var opStack: Array<Op> = Array<Op>()
    
    
    init() {
        //knownOps["*"] = Op.BinaryOperation("*", {$0 * $1})
        knownOps["*"] = Op.BinaryOperation("*") {$0 * $1}
        knownOps["/"] = Op.BinaryOperation("/") {$1 / $0}
        knownOps["+"] = Op.BinaryOperation("+") {$0 + $1}
        knownOps["-"] = Op.BinaryOperation("-") {$1 - $0}
        
        knownOps["√"] = Op.UnaryOperation("√") {sqrt($0)}

        
    }
    
    private func evaluate(ops:[Op])-> (result:Double?, remainingOps:[Op]){
        
        if !ops.isEmpty {
            var remainingOps = ops;
            let op = remainingOps.removeLast()
            switch op {
            case .Operand(let operand):
                return (operand, remainingOps)
            case .UnaryOperation(_, let operation):
                let operationEvaluation = evaluate(remainingOps)
                if let operand = operationEvaluation.result {
                    return (operation(operand),operationEvaluation.remainingOps)
                }
            case .BinaryOperation(_, let operation):
                let op1Evaluation = evaluate(remainingOps)
                if let operation1 = op1Evaluation.result {
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                    if let operation2 = op2Evaluation.result{
                        return (operation(operation1,operation2), op2Evaluation.remainingOps)
                    }
                }
            }
        }
        return (nil,ops)
    }
    
    func evaluate() -> Double? {
        let (result, _) = evaluate(opStack)
        return result
    }
    
    func pushOperand(operand: Double) -> Double{
        opStack.append(Op.Operand(operand))
        return evaluate()!
    }
    
    func performOperation(symble: String){
        
        if let operation = knownOps[symble]{
            opStack.append(operation)
        }
        
        
    }
    
}
