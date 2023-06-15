//
//  ViewController.swift
//  HudDemoSwift
//
//  Created by Daniel Chick on 6/11/23.
//

import UIKit
import MBProgressHUD

enum ProgressMode {
    case special
    case indeterminate, indeterminateLabel, indeterminateDetails
    case determinate, determinateAnnular, determinateBar
    case text, customView, actionButton, modeSwitching
    case onWindow, networking, determinateProgress, dimBackground, colored
    
    var title: String {
        switch self {
        case .special:
            return "Special HUD"
        case .indeterminate:
            return "Indeterminate mode"
        case .indeterminateLabel:
            return "With label"
        case .indeterminateDetails:
            return "With details label"
        case .determinate:
            return "Determinate mode"
        case .determinateAnnular:
            return "Annular determinate mode"
        case .determinateBar:
            return "Bar determinate mode"
        case .text:
            return "Text only"
        case .customView:
            return "Custom view"
        case .actionButton:
            return "With action button"
        case .modeSwitching:
            return "Mode switching"
        case .onWindow:
            return "On window"
        case .networking:
            return "URLSession"
        case .determinateProgress:
            return "Determinate with NSProgress"
        case .dimBackground:
            return "Dim background"
        case .colored:
            return "Colored"
        }
    }
}

class ViewController: UITableViewController {
    var canceled: Bool = false
    
    let examples: [[ProgressMode]] = [
        [.special],
        [.indeterminate, .indeterminateLabel, .indeterminateDetails],
        [.determinate, .determinateAnnular, .determinateBar],
        [.text, .customView, .actionButton, .modeSwitching],
        [.onWindow, .networking, .determinateProgress, .dimBackground, .colored]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "MBProgressHUD"
    }
    
    func doSomeWork() {
        sleep(3)
    }
    
    func doSomeWorkWithProgress() {
        canceled = false
        
        var progress: CGFloat = 0.0
        while progress < 1.0 {
            guard !canceled else { break }
            
            progress += 0.01
            DispatchQueue.main.async {[weak self] in
                guard
                    let self = self,
                    let rootView = self.navigationController?.view else { return }
                MBProgressHUD.HUDFor(rootView)?.progress = progress
            }
            usleep(50000)
        }
    }
    
    @objc
    func cancelWork(_ sender: Any) {
        canceled = true
    }

    func doSomeWorkWithMixedProgress(_ hud: MBProgressHUD) {
       sleep(2)
       
       DispatchQueue.main.async {
           hud.mode = .MBProgressHUDModeDeterminate
           hud.label.text = "Loading..."
       }
       
       var progress: CGFloat = 0
       
       while progress < 1 {
           progress += 0.01
           DispatchQueue.main.async {
               hud.progress = progress
           }
           
           usleep(50000)
       }
       
       DispatchQueue.main.async {
           hud.mode = .MBProgressHUDModeIndeterminate
           hud.label.text = "Cleaning up..."
       }
       
       sleep(2)
       
       DispatchQueue.main.sync {
           let image = UIImage(named: "Checkmark")
           hud.customView = UIImageView(image: image)
           hud.mode = .MBProgressHUDModeCustomView
           hud.label.text = "Completed"
       }
       
       sleep(2)
   }
    
    func doSomeWork(with progressObject: Progress) {
        while progressObject.fractionCompleted < 1 {
            guard !progressObject.isCancelled else { return }
            
            progressObject.becomeCurrent(withPendingUnitCount: 1)
            progressObject.resignCurrent()
            
            usleep(50000)
        }
    }
    
    //MARK: - UITableViewDatasource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        guard section > examples.count else { return 0 }
        return examples[section].count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return examples.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let example = examples[indexPath.section][indexPath.row]
        let cell = UITableViewCell() // tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = example.title
        cell.textLabel?.textAlignment = .center
        return cell
    }
    
    //MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    override func tableView(_ tableView: UITableView,  didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let example = examples[indexPath.section][indexPath.row]
        
        switch example {
        case .special:
//            performSegue(withIdentifier: "special", sender: nil)
            break
        case .indeterminate:
            indeterminateExample()
        case .indeterminateLabel:
            indeterminateLabelExample()
        case .indeterminateDetails:
            indeterminateDetailsLabelExample()
        case .determinate:
            determinateExample()
        case .determinateAnnular:
            annularDeterminateExample()
        case .determinateBar:
            barDeterminateExample()
        case .text:
            textExample()
        case .customView:
            customViewExample()
        case .actionButton:
            cancelationExample()
        case .modeSwitching:
            modeSwitchingExample()
        case .onWindow:
            windowExample()
        case .networking:
            networkingExample()
        case .determinateProgress:
            determinateProgressExample()
        case .dimBackground:
            dimBackgroundExample()
        case .colored:
            colorExample()
        default:
            break
        }
    }
}
   
    
// MARK: - Indeterminate Examples
extension ViewController {
    func indeterminateExample() {
        guard let rootView = navigationController?.view else { return }
        let hud = MBProgressHUD.showHUDAddedTo(rootView, animated: true)
        DispatchQueue.global(qos: .userInitiated).async {[weak self] in
            guard let self = self else { return }
            
            self.doSomeWork()
            DispatchQueue.main.async {
                hud.hide(animated: true)
            }
        }
    }
        
    func indeterminateLabelExample() {
        guard let rootView = navigationController?.view else { return }
        
        let hud = MBProgressHUD.showHUDAddedTo(rootView, animated: true)
        hud.label.text = "Loading..."
        DispatchQueue.global(qos: .userInitiated).async {[weak self] in
            guard let self = self else { return }
            
            self.doSomeWork()
            DispatchQueue.main.async {
                hud.hide(animated: true)
            }
        }
    }
    
    func indeterminateDetailsLabelExample() {
        guard let rootView = navigationController?.view else { return }
        
        let hud = MBProgressHUD.showHUDAddedTo(rootView, animated: true)
        hud.label.text = "Loading..."
        hud.detailsLabel.text = "Parsing data\n(1/1)"
        DispatchQueue.global(qos: .userInitiated).async {[weak self] in
            guard let self = self else { return }
            
            self.doSomeWork()
            DispatchQueue.main.async {
                hud.hide(animated: true)
            }
        }
    }
}

// MARK: - Determinate Examples
extension ViewController {
    
    func determinateExample() {
        guard let rootView = navigationController?.view else { return }
        
        let hud = MBProgressHUD.showHUDAddedTo(rootView, animated: true)
        hud.mode = .MBProgressHUDModeDeterminate
        hud.label.text = "Loading..."
        DispatchQueue.global(qos: .userInitiated).async {[weak self] in
            guard let self = self else { return }
            
            self.doSomeWorkWithProgress()
            DispatchQueue.main.async {
                hud.hide(animated: true)
            }
        }
    }
    
    func annularDeterminateExample() {
        guard let rootView = navigationController?.view else { return }
        
        let hud = MBProgressHUD.showHUDAddedTo(rootView, animated: true)
        hud.mode = .MBProgressHUDModeAnnularDeterminate
        hud.label.text = "Loading..."
        DispatchQueue.global(qos: .userInitiated).async {[weak self] in
            guard let self = self else { return }
            
            self.doSomeWorkWithProgress()
            DispatchQueue.main.async {
                hud.hide(animated: true)
            }
        }
    }
    
    
    func barDeterminateExample() {
        guard let rootView = navigationController?.view else { return }
        
        let hud = MBProgressHUD.showHUDAddedTo(rootView, animated: true)
        hud.mode = .MBProgressHUDModeDeterminateHorizontalBar
        hud.label.text = "Loading..."
        DispatchQueue.global(qos: .userInitiated).async {[weak self] in
            guard let self = self else { return }
            
            self.doSomeWorkWithProgress()
            DispatchQueue.main.async {
                hud.hide(animated: true)
            }
        }
    }
    
    // MARK: - examples
    func textExample() {
        guard let rootView = navigationController?.view else { return }
        
        let hud = MBProgressHUD.showHUDAddedTo(rootView, animated: true)
        hud.mode = .MBProgressHUDModeText
        hud.label.text = "在各种沟通场合"
//        hud.bezelVectorialMargin = 16
        let width = view.bounds.width * (1.0 / 3.0)
//        hud.bezelHorizontalMargin = width / 2
        hud.hide(animated: true, after: 3)
    }
    
    
    func customViewExample() {
        guard let rootView = navigationController?.view else { return }
        
        let hud = MBProgressHUD.showHUDAddedTo(rootView, animated: true)
        hud.mode = .MBProgressHUDModeCustomView
        
        let image = UIImage(named: "Checkmark")
        hud.customView = UIImageView(image: image)
        hud.square = true
        hud.label.text = "Progress Done"
        
        hud.hide(animated: true, after: 3)
    }
    
    func cancelationExample() {
        guard let rootView = navigationController?.view else { return }
        let hud = MBProgressHUD.showHUDAddedTo(rootView, animated: true)
        hud.mode = .MBProgressHUDModeDeterminate
        hud.button.setTitle("Cancel", for: .normal)
        hud.button.addTarget(self, action: #selector(cancelWork(_:)), for: .touchUpInside)
        
        DispatchQueue.global(qos: .userInitiated).async {[weak self] in
            guard let self = self else { return }
            
            self.doSomeWorkWithProgress()
            DispatchQueue.main.async {
                hud.hide(animated: true)
            }
        }
    }
    
    func modeSwitchingExample() {
        guard let rootView = navigationController?.view else { return }
        let hud = MBProgressHUD.showHUDAddedTo(rootView, animated: true)
        hud.label.text = "Preparing..."
        
        DispatchQueue.global(qos: .userInitiated).async {[weak self] in
            guard let self = self else { return }
            
            self.doSomeWorkWithMixedProgress(hud)
            DispatchQueue.main.async {
                hud.hide(animated: true)
            }
        }
    }
    
    
    //MARK: - examples
    func windowExample() {
        guard let rootView = self.view.window else { return }
        let hud = MBProgressHUD.showHUDAddedTo(rootView, animated: true)
        DispatchQueue.global(qos: .userInitiated).async {[weak self] in
            guard let self = self else { return }
            
            self.doSomeWork()
            DispatchQueue.main.async {
                hud.hide(animated: true)
            }
        }
    }
    
    func networkingExample() {
        guard let rootView = navigationController?.view else { return }
        let hud = MBProgressHUD.showHUDAddedTo(rootView, animated: true)
        hud.label.text = "Preparing..."
        
        DispatchQueue.global(qos: .userInitiated).async {[weak self] in
            guard let self = self else { return }
            
            self.doSomeWorkWithProgress()
            DispatchQueue.main.async {
                hud.hide(animated: true)
            }
        }
        
    }
    
    func determinateProgressExample() {
        guard let rootView = navigationController?.view else { return }
        
        let hud = MBProgressHUD.showHUDAddedTo(rootView, animated: true)
        hud.mode = .MBProgressHUDModeDeterminate
        hud.label.text = "Loading..."
        
        let progressObject = Progress(totalUnitCount: 100)
        hud.progressObject = progressObject
        
        hud.button.setTitle("Cancel", for: .normal)
        hud.button.addTarget(progressObject, action: NSSelectorFromString("cancel"), for: .touchUpInside)
        
        DispatchQueue.global(qos: .userInitiated).async {[weak self] in
            guard let self = self else { return }
            
            self.doSomeWork(with: progressObject)
            DispatchQueue.main.async {
                hud.hide(animated: true)
            }
        }
    }
    
    func dimBackgroundExample() {
        guard let rootView = navigationController?.view else { return }
        let hud = MBProgressHUD.showHUDAddedTo(rootView, animated: true)
        
        hud.backgroundView.style = .solidColor
        hud.backgroundView.color = UIColor.black.withAlphaComponent(0.1)
        
        DispatchQueue.global(qos: .userInitiated).async {[weak self] in
            guard let self = self else { return }
            
            self.doSomeWork()
            DispatchQueue.main.async {
                hud.hide(animated: true)
            }
        }
    }
    
    func colorExample() {
        guard let rootView = navigationController?.view else { return }
        let hud = MBProgressHUD.showHUDAddedTo(rootView, animated: true)
        
        hud.contentColor = UIColor.red
        hud.label.text = "Loading..."
        
        DispatchQueue.global(qos: .userInitiated).async {[weak self] in
            guard let self = self else { return }
            
            self.doSomeWork()
            DispatchQueue.main.async {
                hud.hide(animated: true)
            }
        }
    }
}
