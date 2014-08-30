//
//  VNNoteManager.swift
//  VoiceNote
//
//  Created by 赵新 on 14-8-27.
//  Copyright (c) 2014年 souche. All rights reserved.
//

import Foundation

class VNNoteManager {
    
    var docPath:String?
    
    
    class func sharedManager()->VNNoteManager?{
        var instance:VNNoteManager?
        var onceToken:dispatch_once_t  =  0
        dispatch_once(&onceToken, { () -> Void in
             instance = VNNoteManager()
        })
        return instance
    }
    
    var documentDirectoryPath:String {
        get{
            var paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.LibraryDirectory, NSSearchPathDomainMask.UserDomainMask, true)
            var  documentsDirectory:String = paths[0] as String
            documentsDirectory.stringByAppendingPathComponent(kAppEngName)
            return documentsDirectory
        }
    }
    
    func createDataPathIfNeeded()->String{
        self.docPath = documentDirectoryPath
        if NSFileManager.defaultManager().fileExistsAtPath(docPath!){
            return docPath!
        }
        NSFileManager.defaultManager().createDirectoryAtPath(docPath!, withIntermediateDirectories: true, attributes: nil, error: nil)
        return docPath!
    }
    
    func readAllNotes()->Array<VNNote>?{
        var array:Array = [VNNote]()
        var path = createDataPathIfNeeded()
        var error:NSError?
        var files = NSFileManager.defaultManager().contentsOfDirectoryAtPath(path, error:&error) as Array<String>
        if error != nil{
            NSLog(error!.description)
            return nil
        }else{
            for f in files{
                var note = readNoteById(f)
                if let tempNote = note{
                    array.append(tempNote)
                }
                
            }
            return array
        }
        
    }

    
    func readNoteById(id:String)->VNNote?{
        var note:VNNote?
        var dataPath = docPath?.stringByAppendingPathComponent(id)
        var codeData:NSData? = NSData(contentsOfFile: dataPath!)
        if let data = codeData{
           note = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? VNNote
        }
        return note
    }
    

    func storeNote(note:VNNote)->Bool{
        createDataPathIfNeeded()
        var dataPath = docPath?.stringByAppendingPathComponent(note.noteID)
        var saveData = NSKeyedArchiver.archivedDataWithRootObject(note)
        return saveData.writeToFile(dataPath!, atomically: true)
    }
    
    func deleteNote(note:VNNote){
        var filePath = docPath?.stringByAppendingPathComponent(note.noteID)
        NSFileManager.defaultManager().removeItemAtPath(filePath, error: nil)
    }
    
}
