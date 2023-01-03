//
//  RootViewController.swift
//  NativeiOSApp
//
//  Created by anthony on 2023/01/02.
//  Copyright © 2023 unity. All rights reserved.
//

import UIKit

@objc (RootViewController)
class RootViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Root"
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func unityButtonTouched(_ sender: UIButton) {
        navigationController?.pushViewController(UnityViewController(nibName: "UnityViewController", bundle: nil), animated: true);
    }
}
