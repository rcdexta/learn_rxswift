//
//  CircleViewModel.swift
//  LearnRxSwift
//
//  Created by RC on 19/05/16.
//  Copyright © 2016 com.rcdexta. All rights reserved.
//

import ChameleonFramework
import Foundation
import RxSwift
import RxCocoa

class CircleViewModel {

    var centerVariable = Variable<CGPoint?>(CGPointZero)
    var backgroundColorObservable : Observable<UIColor>!

    init(){
        setup()
    }

    func setup(){
        backgroundColorObservable = centerVariable.asObservable().map { center in
            guard let center = center else { return UIColor.flatten(UIColor.blackColor())() }

            let red: CGFloat = ((center.x + center.y) % 255.0) / 255.0 
            let green: CGFloat = 0.0
            let blue: CGFloat = 0.0

            return UIColor.flatten(UIColor(red: red, green: green, blue: blue, alpha: 1.0))()
        }
    }
}
