//
//  StringExtension.swift
//  JSONExport
//
//  Created by 卢金龙 on 11/8/14.
//  Copyright © 2019 Apple-JinlongLu. All rights reserved.
//
//  在满足以下条件的前提下，允许以源格式和二进制格式重新分配和使用，无论是否修改：
//
//  1. 源代码的再分配必须保留上述版权声明、此条件列表和以下免责声明。
//  2. 以二进制形式进行的再分配必须复制上述版权声明、本条件列表以及随再分配提供的文档和/或其他材料中的以下免责声明。
//  3. 未经特定的事先书面许可，不得使用贡献者的名称来认可或推广从本软件派生的产品。
//
//  本软件由版权所有人和贡献者“按原样”提供，任何明示或暗示的保证，包括但不限于对适销性和特定用途适用性的暗示保证，均不予承认。
//  在任何情况下，版权持有人或贡献者对任何直接、间接、偶然、特殊、示范性或后果性损害（包括但不限于采购替代货物或服务；
//  使用、数据或利润损失；或业务中断）概不负责，但这会导致无论是合同责任、严格责任还是因使用本软件而产生的侵权行为
// （包括疏忽或其他），即使已告知此类损害的可能性。

import Foundation

extension String{
    /**
    Very simple method converts the last characters of a string to convert from plural to singular. For example "parties" will be changed to "party" and "stars" will be changed to "star"
    The method does not handle any special cases, like uncountable name i.e "people" will not be converted to "person"
    */
    func toSingular() -> String
    {
        var singular = self
        let length = self.count
        if length > 3 {
			let range = self.index(self.endIndex, offsetBy: -3)..<self.endIndex
            
            let lastThreeChars = self[range]
            if lastThreeChars == "ies" {
                singular = self.replacingOccurrences(of: lastThreeChars, with: "y", options: [], range: range)
                return singular
            }
                
        }
        if length > 2 {
			let range = self.index(self.endIndex, offsetBy: -1)..<self.endIndex
			
            let lastChar = self[range]
            if lastChar == "s" {
                singular = self.replacingOccurrences(of: lastChar, with: "", options: [], range: range)
                return singular
            }
        }
        return singular
    }
    
    /**
    Converts the first character to its lower case version
    
    - returns: the converted version
    */
    func lowercaseFirstChar() -> String{
        if self.count > 0 {
			let range = self.startIndex..<self.index(self.startIndex, offsetBy: 1)
			
            let firstLowerChar = self[range].lowercased()
            
            return self.replacingCharacters(in: range, with: firstLowerChar)
        }else{
            return self
        }
        
    }
    
    /**
    Converts the first character to its upper case version
    
    - returns: the converted version
    */
    func uppercaseFirstChar() -> String{
        if self.count > 0 {
			let range = startIndex..<self.index(startIndex, offsetBy: 1)
			
            let firstUpperChar = self[range].uppercased()
            
            return self.replacingCharacters(in: range, with: firstUpperChar)
        }else{
            return self
        }
        
    }
}
