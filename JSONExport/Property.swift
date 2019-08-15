//
//  PropertyPresenter.swift
//  JSONExport
//
//  Created by 卢金龙 on 11/2/14.
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
//

import Foundation

/**
Represents all the meta data needed to export a JSON property in a valid syntax for the target language
*/
class Property : Equatable{
    
    /**
    The native name that is suitable to export the JSON property in the target language
    */
    var nativeName : String
    
    /**
    The JSON property name to fetch the value of this property from a JSON object
    */
    var jsonName : String
    
    var constName : String?
    
    /**
    The string representation for the property type
    */
    var type : String
    
    /**
    Whether the property represents a custom type
    */
    var isCustomClass : Bool
    
    /**
    Whether the property represents an array
    */
    var isArray : Bool
    
    /**
    The target language model
    */
    var lang : LangModel
    
    /**
    A sample value which this property represents
    */
    var sampleValue : AnyObject!
    
    
    /**
    If this property is an array, this property should contain the type for its elements
    */
    var elementsType  = ""
    
    /**
    For array properties, depetermines if the elements type is a custom type
    */
    var elementsAreOfCustomType = false
    
    /**
    Returns a valid property declaration using the LangModel.instanceVarDefinition value
    */
    func toString(_ forHeaderFile: Bool = false) -> String
    {
        var string : String!
        if forHeaderFile{
            if lang.headerFileData.instanceVarWithSpeicalDefinition != nil && lang.headerFileData.typesNeedSpecialDefinition.firstIndex(of: type) != nil{
                string = lang.headerFileData.instanceVarWithSpeicalDefinition
            }else{
                string = lang.headerFileData.instanceVarDefinition
            }
            
            
        }else{
            if lang.instanceVarWithSpeicalDefinition != nil && lang.typesNeedSpecialDefinition.firstIndex(of: type) != nil{
                string = lang.instanceVarWithSpeicalDefinition
            }else{
                string = lang.instanceVarDefinition
            }
        }
        
        string = string.replacingOccurrences(of: varType, with: type)
        string = string.replacingOccurrences(of: varName, with: nativeName)
        string = string.replacingOccurrences(of: jsonKeyName, with: jsonName)
        return string
    }
    
    func toConstVar(_ className: String) -> String
    {
        var string : String!
        if lang.constVarDefinition != nil {
            string = lang.constVarDefinition
        } else {
            string = ""
        }
        self.constName = "k"+className+nativeName.uppercaseFirstChar()
        
        string = string.replacingOccurrences(of: constKeyName, with: constName!)
        string = string.replacingOccurrences(of: jsonKeyName, with: jsonName)
        return string
    }
    
    
    /** 
    The designated initializer for the class
    */
    init(jsonName: String, nativeName: String, type: String, isArray: Bool, isCustomClass: Bool, lang: LangModel)
    {
        self.jsonName = jsonName.replacingOccurrences(of: " ", with: "")
        self.nativeName = nativeName.replacingOccurrences(of: " ", with: "")
        self.type = type
        self.isArray = isArray
        self.isCustomClass = isCustomClass
        self.lang = lang
    }
    
    
    /**
    Convenience initializer which calls the designated initializer with isArray = false and isCustomClass = false
    */
    convenience init(jsonName: String, nativeName: String, type: String, lang: LangModel){
        self.init(jsonName: jsonName, nativeName: nativeName, type: type, isArray: false, isCustomClass: false, lang: lang)
    }
    
    
    
    
}

//For Equatable implementation
func ==(lhs: Property, rhs: Property) -> Bool
{
    var matched = ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    if !matched{
        matched = (lhs.nativeName == rhs.nativeName && lhs.jsonName == rhs.jsonName && lhs.type == rhs.type && lhs.isCustomClass == rhs.isCustomClass && lhs.isArray == rhs.isArray && lhs.elementsType == rhs.elementsType && lhs.elementsAreOfCustomType == rhs.elementsAreOfCustomType)
    }
    return matched
}
