//
//  ViewController.swift
//  ReSwiftContainers
//
//  Created by Evan Compton on 7/5/17.
//  Copyright © 2017 Evan Compton. All rights reserved.
//

import UIKit
import ReSwift
class ContainerViewController: UIViewController, Container {
    
    typealias StoreSubscriberStateType = AppState
    
    var root : ComponentType<PropsType,ActionsType>!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var store : Store<AppState>!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        store = appDelegate.mainStore
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // subscribe when VC appears
        // we are only interested in repository substate, filter it out of the overall state
        store.subscribe(self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let segueID = segue.identifier else {
            return
        }
        
        if(segueID == "embedRoot") {
            root = segue.destination as? ComponentType
            mapActions()
        }
    }
    
    func newState(state: StoreSubscriberStateType) {
        map(state: state)
        root.render()
    }
    func map(state: StoreSubscriberStateType) {
        let props = PropsType(count: state.count)
        root.props = props
    }
    
    func mapActions() {
        root.actions = ActionsType(incrementCount: incrementCount)
    }
    
    func incrementCount(_ sender: Any?) {
        store.dispatch(AppLogic.AddAction())
    }

}

struct PropsType {
    var count : Int
    
}

struct ActionsType {
     var incrementCount : (_ sender: Any?) -> ()
}

class ComponentViewController: ComponentType<PropsType,ActionsType> {
    
    @IBOutlet weak var label : UILabel!
    @IBOutlet weak var button : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        button.addTarget(self, action: #selector(incrementCount), for: .touchUpInside)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @objc func incrementCount() {
        guard let a = actions else {
            return
        }
        a.incrementCount(nil)
    }
    
    override func render() {
        guard let p = props else {
            return
        }
        label.text = "Count: \(p.count)"
    }
    
}
