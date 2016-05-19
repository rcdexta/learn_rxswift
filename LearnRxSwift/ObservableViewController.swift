//
//  ObservableViewController.swift
//  LearnRxSwift
//
//  Created by RC on 19/05/16.
//  Copyright © 2016 com.rcdexta. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ObservableViewController : UIViewController {

    var circleView: UIView!
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    func setup() {
        // Add circle view
        circleView = UIView(frame: CGRect(origin: view.center, size: CGSize(width: 100.0, height: 100.0)))
        circleView.layer.cornerRadius = circleView.frame.width / 2.0
        circleView.center = view.center
        circleView.backgroundColor = UIColor.greenColor()
        view.addSubview(circleView)

        let gestureRecogniser = UIPanGestureRecognizer(target: self, action: #selector(ObservableViewController.circleMoved(_:)))
        circleView.addGestureRecognizer(gestureRecogniser)

        bindEvents()
    }

    func circleMoved(recognizer: UIPanGestureRecognizer) {
        let location = recognizer.locationInView(view)
        UIView.animateWithDuration(0.1) { 
            self.circleView.center = location
        }
    }

    func bindEvents(){
        let circleViewModel = CircleViewModel()

        circleView
            .rx_observe(CGPoint.self, "center")
            .bindTo(circleViewModel.centerVariable)
            .addDisposableTo(disposeBag)

        circleViewModel.backgroundColorObservable
        .subscribeNext { (backgroundColor) in
            UIView.animateWithDuration(0.1, animations: { 
                self.circleView.backgroundColor = backgroundColor
                self.view.backgroundColor = UIColor.init(complementaryFlatColorOf: backgroundColor, withAlpha: 0.1)
            })
        }
        .addDisposableTo(disposeBag)
    }
}