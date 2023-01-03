//
//  UnityViewController.swift
//  b-us
//
//  Created by anthony on 2023/01/02.
//

import UIKit

class UnityViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Unity"

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UnityManager.sharedInstance().view = view;
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        UnityManager.sharedInstance().view = nil;
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func initButtonTouched(_ sender: UIButton) {
        UnityManager.sharedInstance().initUnity()
    }
    
    @IBAction func showButtonTouched(_ sender: UIButton) {
        UnityManager.sharedInstance().showUnity()
    }
    
    @IBAction func unloadButtonTouched(_ sender: UIButton) {
        UnityManager.sharedInstance().unloadUnity()
    }
    
    @IBAction func quitButtonTouched(_ sender: UIButton) {
        UnityManager.sharedInstance().quitUnity()
    }
}
