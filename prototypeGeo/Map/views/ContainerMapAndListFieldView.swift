//
//  ContainerMapAndListFieldView.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-03-02.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import UIKit

class ContainerMapAndListFieldView: UIView {
    
    var topConstraintContainerNavigation: NSLayoutConstraint?
    var minFrameContainerNavigationView: CGRect?
    var maxFrameContainerNavigation: CGRect?
    
    var constraintNavigationViewControllerView: [NSLayoutConstraint]?
    var constraintFieldViewController: [NSLayoutConstraint]?
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        super.init(frame: .zero)
    }
    
    public func initViewOfMapFieldViewController(viewOfMapFieldViewController: UIView) {
        addSubview(viewOfMapFieldViewController)
        viewOfMapFieldViewController.tag = 1
        viewOfMapFieldViewController.translatesAutoresizingMaskIntoConstraints = false
        
        constraintFieldViewController = [
            topAnchor.constraint(equalTo: viewOfMapFieldViewController.topAnchor),
            bottomAnchor.constraint(equalTo: viewOfMapFieldViewController.bottomAnchor),
            leadingAnchor.constraint(equalTo: viewOfMapFieldViewController.leadingAnchor),
            trailingAnchor.constraint(equalTo: viewOfMapFieldViewController.trailingAnchor),
        ]
        
        NSLayoutConstraint.activate(constraintFieldViewController!)
    }
    
    public func initViewOfContainerFieldNavigationViewController(containerFieldNavigationView: UIView) {
        addSubview(containerFieldNavigationView)
        containerFieldNavigationView.tag = 2
        containerFieldNavigationView.translatesAutoresizingMaskIntoConstraints = false
        
        constraintNavigationViewControllerView = [
            leadingAnchor.constraint(equalTo: containerFieldNavigationView.leadingAnchor),
            trailingAnchor.constraint(equalTo: containerFieldNavigationView.trailingAnchor),
            safeAreaLayoutGuide.topAnchor.constraint(equalTo: containerFieldNavigationView.topAnchor),
            bottomAnchor.constraint(equalTo: containerFieldNavigationView.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(constraintNavigationViewControllerView!)
    }
    
    public func initDragGestureOnContainerFieldNavigation(titleView: TitleView) {
        let panGesture = createPanGestureRecognizer()
        addPanGestureRecognizerToTitleView(titleView: titleView, panGesture: panGesture)
    }
    
    public func slideContainerFieldNavigationViewToMaxPosition() {
        slideTo { $0.frame.origin.y = $1.maxY }
    }
    
    public func slideContainerFieldNavigationViewToMinPostion() {
        slideTo { $0.frame.origin.y = $1.minY }
    }
    
    public func slideContainerFieldNavigationViewToMidPosition() {
        slideTo { $0.frame.origin.y = $1.midY }
    }
    
    private func slideTo(_ slideFunc: @escaping (UIView, PositionY) -> Void) {
        let containerFieldNavigationView = getContainerFieldNavigationView()
        let positionY = createPositionY()
        let anim = createViewPropertyAnimator(duration: 2, dampingRatio: 0.8)
        
        if containerFieldNavigationView != nil && positionY != nil {
            anim.addAnimations {
               slideFunc(containerFieldNavigationView!, positionY!)
            }

            anim.startAnimation()
        }
    }
    
    private func getMapFieldView() -> UIView? {
        viewWithTag(1)
    }
    
    private func getContainerFieldNavigationView() -> UIView? {
        viewWithTag(2)
    }
    
    private func createPanGestureRecognizer() -> UIPanGestureRecognizer {
        UIPanGestureRecognizer(target: self, action: #selector(dragging(_:)))
    }
    
    private func addPanGestureRecognizerToTitleView(titleView: TitleView, panGesture: UIPanGestureRecognizer) {
        titleView.addGestureRecognizer(panGesture)
    }
    
    @objc private func dragging(_ panGestureRecognizer: UIPanGestureRecognizer) {

      //  print(getContainerNavigationView()?.frame)
      //  print(getContainerNavigationView()?.frame.origin)
        let delta = panGestureRecognizer.translation(in: superview)
        let positionY = createPositionY()
        
        guard let containerNavigationView = getContainerFieldNavigationView(), positionY != nil  else {
            return
        }
        
        let newMinY = containerNavigationView.frame.origin.y + delta.y
        
        switch panGestureRecognizer.state {
        case .began, .changed:
            

            if isMaxSlideUp(currentMinY: newMinY, minY: positionY!.minY) {
                containerNavigationView.frame.origin.y = positionY!.minY
                return panGestureRecognizer.setTranslation(.zero, in: superview)
            }

            if isMinSlideDown(currentMinY: newMinY, maxY: positionY!.maxY) {
                containerNavigationView.frame.origin.y = positionY!.maxY
                return panGestureRecognizer.setTranslation(.zero, in: superview)
            }
            
            containerNavigationView.frame.origin.y = newMinY
            panGestureRecognizer.setTranslation(.zero, in: superview)

            
        case .ended, .failed:
            if isGreaterThanMaxMidY(currentMinY: newMinY, maxMidY: positionY!.maxMidY) {
                return slideContainerFieldNavigationViewToMaxPosition()
            }
            
            if isLessThanMaxMidYAndGreaterThanMidY(currentMinY: newMinY, maxMidY: positionY!.maxMidY, midY: positionY!.midY) {
                return slideContainerFieldNavigationViewToMidPosition()
            }
            
            if isLessThanMidYAndGreaterThanMinMidY(currentMinY: newMinY, midY: positionY!.midY, minMidY: positionY!.minMidY) {
                return slideContainerFieldNavigationViewToMidPosition()
            }
            
            if isLessThanMinMidY(currentMinY: newMinY, minMidY: positionY!.minMidY) {
                return slideContainerFieldNavigationViewToMinPostion()
            }
            
        default:
            break
            
        }
    }
    
    private func isLessThanMinMidY(currentMinY: CGFloat, minMidY: CGFloat) -> Bool {
        currentMinY < minMidY
    }
    
    private func isMaxSlideUp(currentMinY: CGFloat, minY: CGFloat) -> Bool {
        currentMinY < minY
    }
    
    private func isMinSlideDown(currentMinY: CGFloat, maxY: CGFloat) -> Bool {
        currentMinY > maxY
    }
    
    private func isLessThanMidYAndGreaterThanMinMidY(currentMinY: CGFloat, midY: CGFloat, minMidY: CGFloat) -> Bool {
        currentMinY < midY && currentMinY > minMidY
    }
    
    private func isLessThanMaxMidYAndGreaterThanMidY(currentMinY: CGFloat, maxMidY: CGFloat, midY: CGFloat) -> Bool {
       (currentMinY < maxMidY) && (currentMinY > midY)
    }
    
    private func isGreaterThanMaxMidY(currentMinY: CGFloat, maxMidY: CGFloat) -> Bool {
        currentMinY > maxMidY
    }
    
    private func getMinY() -> CGFloat? {
        guard let parentView = superview else {
            return nil
        }
        
        if isLandscapeOrientationMobile() {
            return parentView.layoutMargins.top + 50
        }
        
         return parentView.layoutMargins.top
    }
    
    private func getMaxY() -> CGFloat {
        if isLandscapeOrientationMobile() {
            return (frame.height * 0.8) - 50
        }
        
        return frame.height * 0.8
    }
    
    private func getMidY() -> CGFloat {
        frame.midY
    }
    
    private func getMinMidY(minY: CGFloat, midY: CGFloat) -> CGFloat {
        (minY + midY) / 2
    }
    
    private func getMaxMidY(maxY: CGFloat, midY: CGFloat) -> CGFloat {
        (maxY + midY) / 2
    }
    
    private func createPositionY() -> PositionY? {
        let maxY = getMaxY()
        let minY = getMinY()
        let midY = getMidY()
        let maxMidY = getMaxMidY(maxY: maxY, midY: midY)
        
        if minY != nil {
            let minMidY = getMinMidY(minY: minY! , midY: midY)
            return PositionY(maxY: maxY, midY: midY, minY: minY!, minMidY: minMidY, maxMidY: maxMidY)
        }
        
        return nil
    }
    
    private func createViewPropertyAnimator(duration: TimeInterval, dampingRatio: CGFloat) -> UIViewPropertyAnimator {
        UIViewPropertyAnimator(duration: duration, timingParameters: UISpringTimingParameters(dampingRatio: dampingRatio, initialVelocity: .zero))
    }
}

struct PositionY {
    let maxY: CGFloat
    let midY: CGFloat
    let minY: CGFloat
    let minMidY: CGFloat
    let maxMidY: CGFloat
}