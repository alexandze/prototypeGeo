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
        
        topConstraintContainerNavigation = safeAreaLayoutGuide.topAnchor.constraint(equalTo: containerFieldNavigationView.topAnchor)
        
       // topConstraintContainerNavigation!.constant += -(frame.height * 0.8)
        
       constraintNavigationViewControllerView = [
            leadingAnchor.constraint(equalTo: containerFieldNavigationView.leadingAnchor),
            trailingAnchor.constraint(equalTo: containerFieldNavigationView.trailingAnchor),
            topConstraintContainerNavigation!,
            bottomAnchor.constraint(equalTo: containerFieldNavigationView.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(constraintNavigationViewControllerView!)
        
        
        
    }
    
    func activate1() {
        NSLayoutConstraint.deactivate(constraintFieldViewController!)
        NSLayoutConstraint.deactivate(constraintNavigationViewControllerView!)
        NSLayoutConstraint.activate(constraintFieldViewController!)
        NSLayoutConstraint.activate(constraintNavigationViewControllerView!)
    }
    
    public func initDragGestureOnContainerFieldNavigation(titleView: TitleView) {
        let panGesture = createPanGestureRecognizer()
        addPanGestureRecognizerToTitleView(titleView: titleView, panGesture: panGesture)
        
    }
    
    private func createPanGestureRecognizer() -> UIPanGestureRecognizer {
        UIPanGestureRecognizer(target: self, action: #selector(dragging(_:)))
    }
    
    private func addPanGestureRecognizerToTitleView(titleView: TitleView, panGesture: UIPanGestureRecognizer) {
        titleView.addGestureRecognizer(panGesture)
    }
    
    private func getContainerNavigationView() -> UIView? {
        viewWithTag(2)
    }
    
    @objc func dragging(_ panGestureRecognizer: UIPanGestureRecognizer) {

      //  print(getContainerNavigationView()?.frame)
      //  print(getContainerNavigationView()?.frame.origin)
        
        switch panGestureRecognizer.state {
        case .began, .changed:
            let delta = panGestureRecognizer.translation(in: superview)
            
            if let containerNavigationView = getContainerNavigationView() {
                var centerContainerNavigationView = containerNavigationView.center
                centerContainerNavigationView.y += delta.y
                containerNavigationView.center = centerContainerNavigationView
                panGestureRecognizer.setTranslation(.zero, in: superview)
            }
            
            
            
        default:
            break
            
        }
    }
    
    func getMinY() -> CGFloat? {
        if let parentView = superview {
            return parentView.layoutMargins.top
        }
        
        return nil
    }
    
    func getMaxY() -> CGFloat {
        frame.height * 0.8
    }
    
    func getMidY() -> CGFloat {
        frame.midY
    }
    
    func getMinMidY(minY: CGFloat, midY: CGFloat) -> CGFloat {
        (minY + midY) / 2
    }
    
    func getMaxMidY(maxY: CGFloat, midY: CGFloat) -> CGFloat {
        (maxY + midY) / 2
    }
    
    func createPositionY() -> PositionY? {
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
}

struct PositionY {
    let maxY: CGFloat
    let midY: CGFloat
    let minY: CGFloat
    let minMidY: CGFloat
    let maxMidY: CGFloat
}
