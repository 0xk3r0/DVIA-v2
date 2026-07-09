//
//  JailbreakDetectionViewController.swift
//  DVIA - Damn Vulnerable iOS App (damnvulnerableiosapp.com)
//  Created by Prateek Gianchandani on 23/11/17.
//  Copyright © 2018 HighAltitudeHacks. All rights reserved.
//  You are free to use this app for commercial or non-commercial purposes
//  You are also allowed to use this in trainings
//  However, if you benefit from this project and want to make a contribution, please consider making a donation to The Juniper Fund (www.thejuniperfund.org/)
//  The Juniper fund is focusing on Nepali workers involved with climbing and expedition support in the high mountains of Nepal. When a high altitude worker has an accident (death or debilitating injury), the impact to the family is huge. The juniper fund provides funds to the affected families and help them set up a sustainable business.
//  For more information,  visit www.thejuniperfund.org
//  Or watch this video https://www.youtube.com/watch?v=HsV6jaA5J2I
//  And this https://www.youtube.com/watch?v=6dHXcoF590E
 


import UIKit

class JailbreakDetectionViewController: UIViewController {
    let o = Obfuscator(withSalt: [AppDelegate.self, NSObject.self, NSString.self])

    struct Constants {
        /*Original /Applications/Cydia.app*/
        static let everest: [UInt8] = [116, 5, 38, 57, 45, 54, 21, 83, 90, 40, 31, 30, 55, 74, 47, 28, 3, 8, 21, 75, 77, 80, 62]
        /*Original /Library/MobileSubstrate/MobileSubstrate.dylib*/
        static let k2: [UInt8] = [116, 8, 63, 43, 51, 62, 4, 75, 1, 12, 31, 18, 45, 9, 9, 54, 18, 3, 7, 17, 94, 65, 58, 54, 96, 47, 5, 7, 10, 24, 73, 115, 59, 49, 32, 0, 0, 8, 26, 2, 115, 63, 61, 58, 32, 35]
        /*Original /bin/bash*/
        static let Kangchenjunga: [UInt8] = [116, 38, 63, 39, 110, 61, 23, 65, 70]
        /*Original /usr/sbin/sshd*/
        static let Lhotse: [UInt8] = [116, 49, 37, 59, 110, 44, 20, 91, 64, 110, 3, 3, 44, 1]
        /*Original /etc/apt*/
        static let Makalu: [UInt8] = [116, 33, 34, 42, 110, 62, 6, 70]
        /*Original /private/jailbreak.txt*/
        static let ChoOyu: [UInt8] = [116, 52, 36, 32, 55, 62, 2, 87, 1, 43, 17, 25, 40, 7, 30, 0, 6, 10, 90, 17, 84, 84]
        /*Original cydia://package/com.example.package*/
        static let Dhaulagiri: [UInt8] = [56, 61, 50, 32, 32, 101, 89, 29, 94, 32, 19, 27, 37, 2, 9, 74, 4, 14, 25, 75, 73, 88, 47, 62, 63, 14, 15, 75, 19, 21, 79, 75, 47, 52, 54]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Bug Fix if view goes under the navigation bar
        self.edgesForExtendedLayout = []
        let button = UIButton.init(type: .custom)
        button.setImage(UIImage(named: "menu.png"), for: UIControl.State.normal)
        button.addTarget(self, action: #selector(menuTapped(_:)), for: UIControl.Event.touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 28, height: 28)
        button.widthAnchor.constraint(equalToConstant: 28).isActive = true
        button.heightAnchor.constraint(equalToConstant: 28).isActive = true
        let barButton = UIBarButtonItem(customView: button)
        //assign button to navigationbar
        self.navigationItem.leftBarButtonItem = barButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "Jailbreak Detection"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.navigationItem.title = " "
    }
    
    @IBAction func menuTapped(_ sender: Any) {
        mainViewController?.toogle()
    }
    
    @IBAction func readArticleTapped(_ sender: Any) {
        let url = UrlLinks.jailbreakDetetionArticle.url
        DVIAUtilities.loadWebView(withURL: url, viewController: self)
    }
    
    @IBAction func jailbreakTest1Tapped(_ sender: Any) {
        DVIAUtilities.showAlert(forJailbreakTestIsJailbroken: isJailbroken(), viewController: self)
    }
    
    @IBAction func jailbreakTest2Tapped(_ sender: Any) {
        DVIAUtilities.showAlert(forJailbreakTestIsJailbroken: JailbreakDetection.isJailbroken(), viewController: self)
    }
   
    @IBAction func jailbreakTest3Tapped(_ sender: Any) {
        jailbreakTest3()
    }
    
    @IBAction func jailbreakTest4Tapped(_ sender: Any) {
        var isJailbroken:Bool = false
        #if !SIMULATOR
            let suspiciousPaths = [
                "/Applications/Cydia.app",
                "/Library/MobileSubstrate/MobileSubstrate.dylib",
                "/bin/bash",
                "/usr/sbin/sshd",
                "/etc/apt",
                "/var/jb/Applications/Sileo.app",
                "/var/jb/Applications/Zebra.app",
                "/var/jb/Library/MobileSubstrate/MobileSubstrate.dylib",
                "/var/jb/usr/lib/TweakInject",
                "/var/jb/usr/bin/bash",
                "/var/jb/usr/sbin/sshd",
                "/var/jb/etc/apt",
                "/var/jb/",
                "/usr/lib/libhooker.dylib",
                "/var/jb/usr/lib/libellekit.dylib"
            ]
            
            for path in suspiciousPaths {
                if FileManager.default.fileExists(atPath: path) {
                    isJailbroken = true
                    break
                }
            }
            
            if !isJailbroken {
                do {
                    let _ = try FileManager.default.destinationOfSymbolicLink(atPath: "/var/jb")
                    isJailbroken = true
                } catch {}
            }
            
            if !isJailbroken {
                var error: Error?
                let stringToBeWritten = "This is a test."
                do {
                    try stringToBeWritten.write(toFile: "/private/jailbreak.txt", atomically: true, encoding: .utf8)
                } catch let err {
                    error = err
                }
                
                if error == nil {
                    isJailbroken = true
                    try? FileManager.default.removeItem(atPath: "/private/jailbreak.txt")
                }
            }
            
            if !isJailbroken {
                let suspiciousSchemes = [
                    "cydia://package/com.example.package",
                    "sileo://",
                    "zbra://",
                    "filza://"
                ]
                for scheme in suspiciousSchemes {
                    if let url = URL(string: scheme), UIApplication.shared.canOpenURL(url) {
                        isJailbroken = true
                        break
                    }
                }
            }
        #endif
        
        if isJailbroken {
            let alertController = UIAlertController(title: "", message: "Device is Jailbroken, Exiting !", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(action)
            present(alertController, animated: true, completion: nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5), execute: {
                exit(0)
            })
            
        }
        else {
            let alertController = UIAlertController(title: "", message: "Device is Not Jailbroken", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(action)
            present(alertController, animated: true, completion: nil)
        }
    }
    
    
    func isJailbroken() -> Bool {
        #if !SIMULATOR
            let suspiciousPaths = [
                "/Applications/Cydia.app",
                "/Library/MobileSubstrate/MobileSubstrate.dylib",
                "/bin/bash",
                "/usr/sbin/sshd",
                "/etc/apt",
                "/var/jb/Applications/Sileo.app",
                "/var/jb/Applications/Zebra.app",
                "/var/jb/Library/MobileSubstrate/MobileSubstrate.dylib",
                "/var/jb/usr/lib/TweakInject",
                "/var/jb/usr/bin/bash",
                "/var/jb/usr/sbin/sshd",
                "/var/jb/etc/apt",
                "/var/jb/",
                "/usr/lib/libhooker.dylib",
                "/var/jb/usr/lib/libellekit.dylib"
            ]
            
            for path in suspiciousPaths {
                if FileManager.default.fileExists(atPath: path) {
                    return true
                }
            }
            
            do {
                let _ = try FileManager.default.destinationOfSymbolicLink(atPath: "/var/jb")
                return true
            } catch {}
            
            var error: Error?
            let stringToBeWritten = "This is a test."
            do {
                try stringToBeWritten.write(toFile: "/private/jailbreak.txt", atomically: true, encoding: .utf8)
            } catch let err {
                error = err
            }
            
            if error == nil {
                try? FileManager.default.removeItem(atPath: "/private/jailbreak.txt")
                return true
            }
            
            let suspiciousSchemes = [
                "cydia://package/com.example.package",
                "sileo://",
                "zbra://",
                "filza://"
            ]
            for scheme in suspiciousSchemes {
                if let url = URL(string: scheme), UIApplication.shared.canOpenURL(url) {
                    return true
                }
            }
        #endif
        return false
    }
    
    @inline(__always) func jailbreakTest3() {
        var isJailbroken:Bool = false
        #if !SIMULATOR
            let suspiciousPaths = [
                "/Applications/Cydia.app",
                "/Library/MobileSubstrate/MobileSubstrate.dylib",
                "/bin/bash",
                "/usr/sbin/sshd",
                "/etc/apt",
                "/var/jb/Applications/Sileo.app",
                "/var/jb/Applications/Zebra.app",
                "/var/jb/Library/MobileSubstrate/MobileSubstrate.dylib",
                "/var/jb/usr/lib/TweakInject",
                "/var/jb/usr/bin/bash",
                "/var/jb/usr/sbin/sshd",
                "/var/jb/etc/apt",
                "/var/jb/",
                "/usr/lib/libhooker.dylib",
                "/var/jb/usr/lib/libellekit.dylib"
            ]
            
            for path in suspiciousPaths {
                if FileManager.default.fileExists(atPath: path) {
                    isJailbroken = true
                    break
                }
            }
            
            if !isJailbroken {
                do {
                    let _ = try FileManager.default.destinationOfSymbolicLink(atPath: "/var/jb")
                    isJailbroken = true
                } catch {}
            }
            
            if !isJailbroken {
                var error: Error?
                let stringToBeWritten = "This is a test."
                do {
                    try stringToBeWritten.write(toFile: "/private/jailbreak.txt", atomically: true, encoding: .utf8)
                } catch let err {
                    error = err
                }
                
                if error == nil {
                    isJailbroken = true
                    try? FileManager.default.removeItem(atPath: "/private/jailbreak.txt")
                }
            }
            
            if !isJailbroken {
                let suspiciousSchemes = [
                    "cydia://package/com.example.package",
                    "sileo://",
                    "zbra://",
                    "filza://"
                ]
                for scheme in suspiciousSchemes {
                    if let url = URL(string: scheme), UIApplication.shared.canOpenURL(url) {
                        isJailbroken = true
                        break
                    }
                }
            }
        #endif
        
        if isJailbroken {
            let alertController = UIAlertController(title: "", message: "Device is Jailbroken, the application will now exit", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(action)
            present(alertController, animated: true, completion: nil)
        }
        else {
            let alertController = UIAlertController(title: "", message: "Device is Not Jailbroken", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(action)
            present(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func jailbreakTest5Tapped(_ sender: Any) {
        var fontColor:Bool = false
        #if !SIMULATOR
            if FileManager.default.fileExists(atPath: o.reveal(key: Constants.everest)) {
                fontColor = true
            }
            else if FileManager.default.fileExists(atPath: o.reveal(key: Constants.k2)) {
                fontColor = true
            }
            else if FileManager.default.fileExists(atPath: o.reveal(key: Constants.Kangchenjunga)) {
                fontColor = true
            }
            else if FileManager.default.fileExists(atPath: o.reveal(key: Constants.Lhotse)) {
                fontColor = true
            }
            else if FileManager.default.fileExists(atPath: o.reveal(key: Constants.Makalu)) {
                fontColor = true
            }
            
            var error: Error?
            let stringToBeWritten = "77008hbggfhvg"
            do {
                try stringToBeWritten.write(toFile: o.reveal(key: Constants.ChoOyu), atomically: true, encoding: .utf8)
            } catch let err {
                error = err
            }
            
            if error == nil {
                //Device is jailbroken
                fontColor = true
            }
            else {
                try? FileManager.default.removeItem(atPath:o.reveal(key: Constants.ChoOyu))
            }
            if UIApplication.shared.canOpenURL((URL(string: o.reveal(key: Constants.Dhaulagiri)))!) {
                //Device is jailbroken
                fontColor = true
            }
        #endif
        
        if fontColor {
            let alertController = UIAlertController(title: "", message: "Oops, something went wrong, the application will now exit!", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(action)
            present(alertController, animated: true, completion: nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
                exit(0)
            })
            
        }
        else {
            let alertController = UIAlertController(title: "", message: "Device is Not Jailbroken", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(action)
            present(alertController, animated: true, completion: nil)
        }
    }
    
}