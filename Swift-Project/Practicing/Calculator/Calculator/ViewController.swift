//
//  ViewController.swift
//  Calculator
//
//  Created by 谢乾坤 on 2/24/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    
    @IBOutlet weak var display: UILabel!
    
    var userIsInTheMiddleOfTypeingNumber: Bool = false
    
    var brain = CalculatorBrain()
    
    @IBAction func appendDigit(sender: UIButton) {
        
        let digit = sender.currentTitle!
        
        if userIsInTheMiddleOfTypeingNumber {
            display.text = display.text! + digit
        } else {
            display.text = digit
            userIsInTheMiddleOfTypeingNumber = true
        }
        
        print("digit = \(digit)")
        
        
    }
    
    // var operandStack :Array<Double> = Array<Double>()
    var operandStack = Array<Double>()
    
    @IBAction func enter() {
        
        userIsInTheMiddleOfTypeingNumber = false

        if let result = brain.pushOperand(displayValue) {
            displayValue = result
        } else {
            displayValue = 0
        }
        
    }
    
    @IBAction func operate(sender: UIButton) {
        
        if userIsInTheMiddleOfTypeingNumber {
            enter()
        }
        if let operation = sender.currentTitle{
            
            if let result = brain.performOperation(operation) {
                displayValue = result
            } else {
                displayValue = 0
            }
        }
        /*
        switch operation{
            /*
            // can also do this but it is not efficient
            case "*": performOperation({(op1: Double, op2: Double) -> Double in
            return op1 * op2
            })
            */
            
            //we can also remove return because swift automatically know it will return something
            //case "*": performOperation({(op1, op2) in return op1 * op2})
            
            //also, swift don't need to know all variable names
            //case "*": performOperation({(op1, op2) in op1 * op2})
            
            //also, last argument can go outside the () so it makes it into
            //case "*": performOperation({$0 * $1})
            
        case "*": performOperation {$0 * $1}
            
        case "/": performOperation {$1 / $0}
            
        case "+": performOperation {$0 + $1}
            
        case "-": performOperation {$1 - $0}
            
        case "√": performOperation { sqrt($0)}

            
        default: break
        }
        */
        
    }
    
    func performOperation(operation: (Double, Double) ->Double) {
        if operandStack.count >= 2 {
            displayValue = operation (operandStack.removeLast() ,operandStack.removeLast())
            enter()
        }
    }
    private func performOperation(operation: Double -> Double) {
        if operandStack.count >= 1 {
            displayValue = operation (operandStack.removeLast())
            enter()
        }
    }
    
    var displayValue: Double{
        get {
            
            //TODO figure what is this!!!
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set{
            display.text = "\(newValue)"
            userIsInTheMiddleOfTypeingNumber = false
        }
    }
}





