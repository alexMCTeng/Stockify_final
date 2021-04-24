//
//  UserDefaults.swift
//  Cameo
//
//  Created by Alex Teng on 11/8/20.
//  Copyright © 2020 Alex Teng. All rights reserved.
//

import Foundation


func getLoginStatus() -> Bool{
    return UserDefaults.standard.bool(forKey: "loggedIn")
}

func getUserId() -> String{
    return UserDefaults.standard.string(forKey: "userId") ?? ""}

func getChangeTargetPercent() -> Float{
    return UserDefaults.standard.float(forKey: "NotificationTarget") }
