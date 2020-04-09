//
//  GameSetupVC+UIPickerViewDelegate.swift
//  Stop
//
//  Created by Marcos Vicente on 09.04.2020.
//  Copyright © 2020 Antares Software Group. All rights reserved.
//

import UIKit

extension GameSetupViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedLetter = letters[row]
        chooseLetter.text = selectedLetter
    }
}
