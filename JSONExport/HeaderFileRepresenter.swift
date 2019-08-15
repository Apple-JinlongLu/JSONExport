//
//  HeaderFileRepresenter.swift
//  JSONExport
//  Created by 卢金龙 on 11/23/14.
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
import AddressBook

class HeaderFileRepresenter : FileRepresenter{
    /**
    Generates the header file content and stores it in the fileContent property
    */
    override func toString() -> String{
        fileContent = ""
        appendCopyrights()
        appendStaticImports()
        appendImportParentHeader()
        appendCustomImports()
        
        //start the model defination
        var definition = ""
        if lang.headerFileData.modelDefinitionWithParent != nil && parentClassName.count > 0{
            definition = lang.headerFileData.modelDefinitionWithParent.replacingOccurrences(of: modelName, with: className)
            definition = definition.replacingOccurrences(of: modelWithParentClassName, with: parentClassName)
        }else if includeUtilities && lang.defaultParentWithUtilityMethods != nil{
            definition = lang.headerFileData.modelDefinitionWithParent.replacingOccurrences(of: modelName, with: className)
            definition = definition.replacingOccurrences(of: modelWithParentClassName, with: lang.headerFileData.defaultParentWithUtilityMethods)
        }else{
            definition = lang.headerFileData.modelDefinition.replacingOccurrences(of: modelName, with: className)
        }
        
        fileContent += definition
        //start the model content body
        fileContent += "\(lang.modelStart)"
        
        appendProperties()
        appendInitializers()
        appendUtilityMethods()
        fileContent += lang.modelEnd
        return fileContent
    }
    
  
    
    /**
    Appends the lang.headerFileData.staticImports if any
    */
    override func appendStaticImports()
    {
        if lang.headerFileData.staticImports != nil{
            fileContent += lang.headerFileData.staticImports
            fileContent += "\n"
        }
    }
    
    func appendImportParentHeader()
    {
        if lang.headerFileData.importParentHeaderFile != nil && parentClassName.count > 0{
            fileContent += lang.headerFileData.importParentHeaderFile.replacingOccurrences(of: modelWithParentClassName, with: parentClassName)
        }
    }
    
    /**
    Tries to access the address book in order to fetch basic information about the author so it can include a nice copyright statment
    */
    override func appendCopyrights()
    {
        fileContent += "//\n//\t\(self.className).\(lang.headerFileData.headerFileExtension!)\n"
        let shared = ABAddressBook.shared()
        if let me = shared?.me(){
            
            if let firstName = me.value(forProperty: kABFirstNameProperty as String) as? String{
                fileContent += "//\n//\tCreate by \(firstName)"
                if let lastName = me.value(forProperty: kABLastNameProperty as String) as? String{
                    fileContent += " \(lastName)"
                }
            }
            fileContent += " on \(getTodayFormattedDay())\n//\tCopyright © \(getYear())"
            
            if let organization = me.value(forProperty: kABOrganizationProperty as String) as? String{
                fileContent += " \(organization)"
            }
            fileContent += ". All rights reserved.\n//\n"
        }
        
        fileContent += "//\tModel file Generated using JSONExport: https://github.com/Apple-JinlongLu/JSONExport\n\n"
    }
    
    
    /**
    Loops on all properties which has a custom type and appends the custom import from the lang.headerFileData's importForEachCustomType property
    
    */
    override func appendCustomImports()
    {
        if lang.importForEachCustomType != nil{
            for property in properties{
                if property.isCustomClass{
                    fileContent += lang.headerFileData.importForEachCustomType.replacingOccurrences(of: modelName, with: property.type)
                }else if property.isArray{
                    //if it is an array of custom types
                    if(property.elementsType != lang.genericType){
                        let basicTypes = lang.dataTypes.toDictionary().allValues as! [String]
                        if basicTypes.firstIndex(of: property.elementsType) == nil{
                            fileContent += lang.headerFileData.importForEachCustomType.replacingOccurrences(of: modelName, with: property.elementsType)
                        }
                    }
                    
                }
            }
        }
    }
    
    /**
    Appends all the properties using the Property.stringPresentation method
    */
    override func appendProperties()
    {
        fileContent += "\n"
        for property in properties{
            fileContent += property.toString(true)
        }
    }
    
    /**
    Appends all the defined constructors (aka initializers) in lang.constructors to the fileContent
    */
    override func appendInitializers()
    {
        if !includeConstructors{
            return
        }
        fileContent += "\n"
        for constructorSignature in lang.headerFileData.constructorSignatures{
           
            fileContent += constructorSignature
            
            fileContent = fileContent.replacingOccurrences(of: modelName, with: className)
        }
    }
    
    
    /**
    Appends all the defined utility methods in lang.utilityMethods to the fileContent
    */
    override func appendUtilityMethods()
    {
        if !includeUtilities{
            return
        }
        fileContent += "\n"
        for methodSignature in lang.headerFileData.utilityMethodSignatures{
            fileContent += methodSignature
        }
    }
}
