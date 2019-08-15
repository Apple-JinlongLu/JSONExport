//
//	Author.swift
//
//	Create by 卢金龙 on 23/5/2019
//	Copyright © 2019. All rights reserved.
//	

import Foundation


class Author : NSObject, NSCoding{
    
    var website : String!
    var email : String!
    var name : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: NSDictionary){
        website = dictionary["website"] as? String
        email = dictionary["email"] as? String
        name = dictionary["name"] as? String
    }
    
    /**
     * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> NSDictionary
    {
        let dictionary = NSMutableDictionary()
        if website != nil{
            dictionary["website"] = website
        }
        if email != nil{
            dictionary["email"] = email
        }
        if name != nil{
            dictionary["name"] = name
        }
        return dictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        website = aDecoder.decodeObject(forKey: "website") as? String
        email = aDecoder.decodeObject(forKey: "email") as? String
        name = aDecoder.decodeObject(forKey: "name") as? String
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if website != nil{
            aCoder.encode(website, forKey: "website")
        }
        if email != nil{
            aCoder.encode(email, forKey: "email")
        }
        if name != nil{
            aCoder.encode(name, forKey: "name")
        }
        
    }
    
}
