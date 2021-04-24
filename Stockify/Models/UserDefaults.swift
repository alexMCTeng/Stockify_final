//
//  UserDefaults.swift
//  Cameo
//
//  Created by Ege Çavuşoğlu on 11/8/20.
//  Copyright © 2020 Ege Çavuşoğlu. All rights reserved.
//

import Foundation


func getLoginStatus() -> Bool{
    return UserDefaults.standard.bool(forKey: "loggedIn")
}

func getUserId() -> String{
    return UserDefaults.standard.string(forKey: "userId") ?? ""}

func getChangeTargetPercent() -> Float{
    return UserDefaults.standard.float(forKey: "NotificationTarget") }
