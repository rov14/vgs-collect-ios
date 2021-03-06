//
//  VGSValidation+type.swift
//  VGSCollectSDK
//
//  Created by Vitalii Obertynskyi on 9/12/19.
//  Copyright © 2019 Vitalii Obertynskyi. All rights reserved.
//

import Foundation

extension VGSValidation {
    func validateType(txt: String, for type: FieldType) -> Bool {
        switch type {
        case .expDate:
            return validateExpDate(txt: txt)
        case .cvc:
            return validateCVC(txt: txt)
        default:
            return true
        }
    }
    
    // MARK: - Validate Date expiration
    private func validateExpDate(txt: String) -> Bool {
        
        let mmChars = 2
        let yyChars = self.isLongDateFormat ? 4 : 2
        guard txt.count == mmChars + yyChars else { return false }
                
        let mm = txt.prefix(mmChars)
        let yy = txt.suffix(yyChars)
                
        let today = Date()
        let formatter = DateFormatter()
        
        formatter.dateFormat = self.isLongDateFormat ? "yyyy" : "yy"
        let todayYY = Int(formatter.string(from: today)) ?? 0
        
        formatter.dateFormat = "MM"
        let todayMM = Int(formatter.string(from: today)) ?? 0
        
        guard let inputMM = Int(mm), let inputYY = Int(yy) else {
            return false
        }
        
        if inputYY < todayYY || inputYY > (todayYY + 20) {
            return false
        }
        
        if inputYY == todayYY && inputMM < todayMM {
            return false
        }
        return true
    }
    
    private func validateCVC(txt: String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: txt)
    }
}
