//
//  VNNote.swift
//  VoiceNote
//
//  Created by 赵新 on 14-8-26.
//  Copyright (c) 2014年 souche. All rights reserved.
//

import Foundation

let kNoteIDKey = "NoteID"
let kTitleKey = "Title"
let kContentKey = "Content"
let kCreatedDate = "CreatedDate"
let kUpdatedDate = "kUpdatedDate"

class VNNote:NSObject,NSCoding{
    var noteID:String
    var title:String
    var content:String
    var createdDate:NSDate
    var updatedDate:NSDate
    

    
    init(title:String,content:String,createdDate:NSDate,updateDate:NSDate){
        
        self.noteID = NSNumber.numberWithDouble(createdDate.timeIntervalSince1970).stringValue

        self.title = title
        self.content = content
        self.createdDate = createdDate
        self.updatedDate = updateDate
        
        if title.isEmpty{
            self.title = "无标题笔记"
        }
        if content.isEmpty{
            self.content = ""
        }
    }
    
    func encodeWithCoder(aCoder: NSCoder){

        aCoder.encodeObject(title, forKey: kTitleKey)
        aCoder.encodeObject(content, forKey: kContentKey)
        aCoder.encodeObject(createdDate, forKey: kCreatedDate)
        aCoder.encodeObject(updatedDate, forKey: kUpdatedDate)
    }
   
    required init(coder aDecoder: NSCoder) {
        
        self.title = aDecoder.decodeObjectForKey(kTitleKey) as String
        self.content = aDecoder.decodeObjectForKey(kContentKey) as String
        self.createdDate = aDecoder.decodeObjectForKey(kCreatedDate) as NSDate
        self.updatedDate = aDecoder.decodeObjectForKey(kUpdatedDate) as NSDate
        self.noteID = NSNumber.numberWithDouble(createdDate.timeIntervalSince1970).stringValue
    }
    
    
    func persistence()->Bool{
        return VNNoteManager.sharedManager()!.storeNote(self)
    }
    
}