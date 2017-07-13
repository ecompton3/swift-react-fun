//
//  ContainerComponent.swift
//  ReSwiftContainers
//
//  Created by Evan Compton on 7/6/17.
//  Copyright © 2017 Evan Compton. All rights reserved.
//

import Foundation
import ReSwift
import UIKit

protocol Container : StoreSubscriber where StoreSubscriberStateType == AppState {
    func newState(state: StoreSubscriberStateType)
    func map(state: StoreSubscriberStateType)
    func mapActions()
}

class ComponentType<T,U> : UIViewController, Component {
    typealias PropType = T
    typealias ActionType = U
    
    var props: T?
    var actions: U?
    
    func render() {
        fatalError("Subclass must Implement")
    }
}

protocol Component {
    associatedtype PropType
    associatedtype ActionType
    var props: PropType? { get set }
    var actions: ActionType? { get set }
    func render()
}
