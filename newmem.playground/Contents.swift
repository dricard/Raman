//: A UIKit based Playground for presenting user interface

import UIKit
import PlaygroundSupport

struct Spot {
    var value: Double? = nil
    var isPinned: Bool = false
}

struct Memory {
    let max = 9
    var stack = [ Spot ]()
    
    init() {
        for _ in 0...max {
            self.stack.append(Spot())
        }
    }
    
    
    mutating func push(_ newValue: Double) {
        for i in (1...max).reversed() {
            if !stack[i].isPinned {
                if !stack[i - 1].isPinned {
                    stack[i] = stack[i - 1]
                } else {
                    var step = 1
                    repeat {
                        step += 1
                        if !stack[i - step].isPinned {
                            stack[i] = stack[i - step]
                        }
                    } while stack[i - step].isPinned && (i - step) > 0
                }
            }
        }
        stack[0].value = newValue
    }
}

class MyViewController : UIViewController {
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white
        
        var wavelength = Memory.init()
        
        wavelength.stack[3].value = 1234.56
        wavelength.stack[3].isPinned = true
        for i in 0...4 {
            wavelength.push(Double(i) * 1000.0 + 500.0)
        }
        wavelength.stack[2].isPinned = true
        wavelength.push(6000.0)
        let list = UIStackView.init(frame: CGRect(x: 0, y: 0, width: 340, height: 500))
        list.alignment = .center
        list.axis = .vertical
        list.distribution = .fillEqually
        
        for spot in wavelength.stack {
            let label = UILabel()
            var prefix = ""
            if let value = spot.value {
                if spot.isPinned {
                    prefix = "•"
                }
                label.text = prefix + " " + String(reflecting: value)
            } else {
                label.text = "empty"
            }
            label.textColor = .black
            list.addArrangedSubview(label)
        }
        
        view.addSubview(list)
        self.view = view
        
    }
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
