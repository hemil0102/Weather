//
//  CustomTextField.swift
//  Weather
//
//  Created by Walter J on 2022/04/18.
//

import Foundation
import UIKit

class CustomTextField: UITextField {
    private func getKeyboardLanguage() -> String? {
        return "ko-KR"
    }

    override var textInputMode: UITextInputMode? {
        if let language = getKeyboardLanguage() {
            for inputMode in UITextInputMode.activeInputModes {
                if inputMode.primaryLanguage! == language {
                    return inputMode
                }
            }
        }
        return super.textInputMode
    }
}
