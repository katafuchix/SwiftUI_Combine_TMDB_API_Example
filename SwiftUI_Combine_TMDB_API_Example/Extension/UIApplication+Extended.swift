//
//  UIApplication+Extended.swift
//  SwiftUI_Combine_TMDB_API_Example
//
//  Created by cano on 2023/05/27.
//

import UIKit

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
