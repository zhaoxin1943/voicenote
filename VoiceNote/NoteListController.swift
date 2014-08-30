//
//  NoteListController.swift
//  VoiceNote
//
//  Created by 赵新 on 14-8-27.
//  Copyright (c) 2014年 souche. All rights reserved.
//

import UIKit

let reuseId = "ListCell"

class NoteListController:UITableViewController,UITableViewDataSource,UITableViewDelegate{
    var dataSource:Array<VNNote>?
    
    override func viewDidLoad() {
        setupNavigationBar()
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadData", name: kNotificationCreateFile, object: nil)
        var notes = VNNoteManager.sharedManager()?.readAllNotes()!
        dataSource = notes
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadData", name: kNotificationCreateFile, object: nil)
    }
    
    func setupNavigationBar(){
        var item = UIBarButtonItem(image: UIImage(named: "ic_add_tab"), style: UIBarButtonItemStyle.Plain, target: self, action: "addNewNote")
        navigationItem.rightBarButtonItem = item
        navigationItem.title = kAppName
    }
    
    
    func addNewNote(){
        var note:VNNote?
        var noteDetailController = NoteDetailController(note: note)
        self.navigationController.pushViewController(noteDetailController, animated: true)
    }
    
    func reloadData(){
        dataSource = VNNoteManager.sharedManager()!.readAllNotes()!
        tableView.reloadData()
    }
    
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func tableView(tableView: UITableView!, canEditRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return dataSource!.count
    }
    
    override func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        
        var note = dataSource![indexPath.row]
        return NoteListCell.heightWithNote(note)
    }
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        var cell:NoteListCell! = tableView.dequeueReusableCellWithIdentifier(reuseId) as? NoteListCell
        if cell == nil{
            cell = NoteListCell(style: UITableViewCellStyle.Default, reuseIdentifier: reuseId)
        }
        var note = dataSource![indexPath.row]
        cell.updateWithNote(note)
        return cell
    }
    
    override func tableView(tableView: UITableView!, editingStyleForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.Delete
    }
    
    override func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        var note = dataSource![indexPath.row]
        var noteDetailController = NoteDetailController(note: note)
        navigationController.pushViewController(noteDetailController, animated: true)

    }
    
}
