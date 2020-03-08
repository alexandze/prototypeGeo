//
//  ContainerMapAndListFieldView.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-03-02.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import UIKit

class ContainerMapAndListFieldView: UIView {

    var constraintNavigationViewControllerView: [NSLayoutConstraint]?
    var constraintFieldViewController: [NSLayoutConstraint]?
    var currentYPositionSlideView: CGFloat = 0

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init() {
        super.init(frame: .zero)
    }

    public func initViewOf(viewOfMapFieldController: UIView) {
        addSubview(viewOfMapFieldController)
        viewOfMapFieldController.tag = MapFieldView.VIEW_TAG
        viewOfMapFieldController.translatesAutoresizingMaskIntoConstraints = false

        constraintFieldViewController = [
            topAnchor.constraint(equalTo: viewOfMapFieldController.topAnchor),
            bottomAnchor.constraint(equalTo: viewOfMapFieldController.bottomAnchor),
            leadingAnchor.constraint(equalTo: viewOfMapFieldController.leadingAnchor),
            trailingAnchor.constraint(equalTo: viewOfMapFieldController.trailingAnchor)
        ]

        NSLayoutConstraint.activate(constraintFieldViewController!)
    }

    public func initViewOf(containerFieldNavigationView: UIView) {
        addSubview(containerFieldNavigationView)
        containerFieldNavigationView.tag = ContainerFieldNavigationView.VIEW_TAG
        containerFieldNavigationView.translatesAutoresizingMaskIntoConstraints = false

        constraintNavigationViewControllerView = [
            leadingAnchor.constraint(equalTo: containerFieldNavigationView.leadingAnchor),
            trailingAnchor.constraint(equalTo: containerFieldNavigationView.trailingAnchor),
            safeAreaLayoutGuide.topAnchor.constraint(equalTo: containerFieldNavigationView.topAnchor),
            bottomAnchor.constraint(equalTo: containerFieldNavigationView.bottomAnchor)
        ]

        NSLayoutConstraint.activate(constraintNavigationViewControllerView!)
    }

    public func initDragGestureFor(titleView: TitleView) {
        let panGesture = createPanGestureRecognizer()
        add(panGesture: panGesture, to: titleView)
    }

    public func slideContainerFieldNavigationViewToMaxPosition() {
        slideTo { $0.frame.origin.y = $1.maxY; self.currentYPositionSlideView = $1.maxY }
    }

    public func slideContainerFieldNavigationViewToMinPostion() {
        slideTo { $0.frame.origin.y = $1.minY; self.currentYPositionSlideView = $1.minY }
    }

    public func slideContainerFieldNavigationViewToMidPosition() {
        slideTo { $0.frame.origin.y = $1.midY; self.currentYPositionSlideView = $1.midY }
    }

    public func setminYContainerFieldNavigationViewToCurrentPosition() {
        guard let containerFieldNavigationView = getContainerFieldNavigationView() else {
            return
        }

        containerFieldNavigationView.frame.origin.y = currentYPositionSlideView
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
        viewWithTag(MapFieldView.VIEW_TAG)
    }

    private func getContainerFieldNavigationView() -> UIView? {
        viewWithTag(ContainerFieldNavigationView.VIEW_TAG)
    }

    private func createPanGestureRecognizer() -> UIPanGestureRecognizer {
        UIPanGestureRecognizer(target: self, action: #selector(dragging(_:)))
    }

    private func add(panGesture: UIPanGestureRecognizer, to titleView: TitleView) {
        titleView.addGestureRecognizer(panGesture)
    }

    @objc private func dragging(_ panGestureRecognizer: UIPanGestureRecognizer) {
        let delta = panGestureRecognizer.translation(in: superview)
        let positionY = createPositionY()

        guard let containerNavigationView = getContainerFieldNavigationView(), positionY != nil else {
            return
        }

        let newMinY = containerNavigationView.frame.origin.y + delta.y

        switch panGestureRecognizer.state {
        case .began, .changed:
            handleBeganAndChangePanGesture(newMinY: newMinY, positionY: positionY!, containerNavigationView: containerNavigationView, panGestureRecognizer: panGestureRecognizer)
        case .ended, .failed:
            handleEndedPanGesture(newMinY: newMinY, positionY: positionY!)
        default:
            break
        }
    }

    private func handleBeganAndChangePanGesture(newMinY: CGFloat, positionY: PositionY, containerNavigationView: UIView, panGestureRecognizer: UIPanGestureRecognizer) {
        if isMaxSlideUp(currentMinY: newMinY, minY: positionY.minY) {
            containerNavigationView.frame.origin.y = positionY.minY
        } else if isMinSlideDown(currentMinY: newMinY, maxY: positionY.maxY) {
            containerNavigationView.frame.origin.y = positionY.maxY
        } else {
            containerNavigationView.frame.origin.y = newMinY
        }

        panGestureRecognizer.setTranslation(.zero, in: superview)
    }

    private func handleEndedPanGesture(newMinY: CGFloat, positionY: PositionY) {
        if isGreaterThanMaxMidY(currentMinY: newMinY, maxMidY: positionY.maxMidY) {
            return slideContainerFieldNavigationViewToMaxPosition()
        }

        if isLessThanMaxMidYAndGreaterThanMidY(currentMinY: newMinY, maxMidY: positionY.maxMidY, midY: positionY.midY) {
            return slideContainerFieldNavigationViewToMidPosition()
        }

        if isLessThanMidYAndGreaterThanMinMidY(currentMinY: newMinY, midY: positionY.midY, minMidY: positionY.minMidY) {
            return slideContainerFieldNavigationViewToMidPosition()
        }

        if isLessThanMinMidY(currentMinY: newMinY, minMidY: positionY.minMidY) {
            return slideContainerFieldNavigationViewToMinPostion()
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
            let minMidY = getMinMidY(minY: minY!, midY: midY)
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
