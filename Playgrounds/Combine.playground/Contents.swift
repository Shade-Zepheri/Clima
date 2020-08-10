import UIKit
import Combine

let pubA = PassthroughSubject<Int, Never>()
let pubB = PassthroughSubject<Int, Never>()
let pubC = PassthroughSubject<Int, Never>()
let pubD = PassthroughSubject<Int, Never>()

let cancellable = Publishers.MergeMany([pubA, pubB, pubC, pubD])
    .sink { print("\($0)", terminator: " " ) }

pubA.send(1)
pubB.send(40)
pubC.send(90)
pubD.send(-1)
//pubA.send(2)
//pubB.send(50)
//pubC.send(100)
//pubD.send(-2)
