//
//  NoteListCell.swift
//  VoiceNote
//
//  Created by 赵新 on 14-8-26.
//  Copyright (c) 2014年 souche. All rights reserved.
//

import UIKit

let kCellHorizontalMargin:CGFloat = 4;
let kCellPadding:CGFloat = 8;
let kVerticalPadding:CGFloat = 4;
let kLabelHeight:CGFloat = 15;

let kMaxTitleHeight:CGFloat = 100;


class NoteListCell:UITableViewCell{
    var _backgroundView:UIView?
    var titleLabel:UILabel?
    var timeLable:UILabel?
    var colorArray = [UIColor]()
    
    func getColorArray()->Array<UIColor>{
        if colorArray.count == 0{
            colorArray += [UIColor.emeraldColor(),UIColor.fadedBlueColor(),UIColor.cantaloupeColor(),
                UIColor.oliveColor(),UIColor.salmonColor(),UIColor.easterPinkColor(),UIColor.blueberryColor(),
                UIColor.turquoiseColor(),UIColor.warmGrayColor(),UIColor.tealColor(),UIColor.lavenderColor(),
                UIColor.bananaColor(),UIColor.cornflowerColor(),UIColor.skyBlueColor(),UIColor.coralColor(),
                UIColor.plumColor(),UIColor.hollyGreenColor(),UIColor.coolGrayColor(),UIColor.violetColor(),
                UIColor.maroonColor(),UIColor.orangeColor(),UIColor.waveColor()]
        }
        return colorArray
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        var tempFrame = CGRectMake(kCellHorizontalMargin,kVerticalMargin,self.frame.size.width - kCellHorizontalMargin * 2,0)
        _backgroundView = UIView(frame:tempFrame)
        _backgroundView?.layer.cornerRadius = 6
        _backgroundView?.layer.masksToBounds = true
        self.contentView.addSubview(_backgroundView!)
        
        titleLabel = UILabel(frame: CGRectMake(kCellPadding, kCellPadding, _backgroundView!.frame.size.width - kCellPadding*2, 0))
        titleLabel?.textColor = UIColor.whiteColor()
        titleLabel?.font = UIFont.boldSystemFontOfSize(17)
        titleLabel?.numberOfLines = 0
        _backgroundView?.addSubview(titleLabel!)
        
        timeLable = UILabel(frame: CGRectMake(kCellPadding, kCellPadding,_backgroundView!.frame.size.width - kCellPadding*2, kLabelHeight))
        timeLable?.textColor = UIColor.whiteColor()
        timeLable?.font = UIFont.boldSystemFontOfSize(10)
        timeLable?.textAlignment = NSTextAlignment.Right
        _backgroundView?.addSubview(timeLable!)
        
        selectionStyle = UITableViewCellSelectionStyle.None
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func heightWithNote(note:VNNote)->CGFloat{
        var screenWidth = UIScreen.mainScreen().bounds.width
        var title = note.title
        if title.isEmpty{
            title = note.content
        }
        var titleHeight = heightwithString(title, width: screenWidth - kCellHorizontalMargin*2 - kCellPadding*2)

        return titleHeight + kCellPadding*2 + kLabelHeight + kVerticalPadding
    }
    
    class func heightwithString(str:String,width:CGFloat)->CGFloat{
        var attr = [NSFontAttributeName:UIFont.boldSystemFontOfSize(17)]
        var tempStr = NSString(string: str)
        var size = tempStr.boundingRectWithSize(CGSizeMake(width, kMaxTitleHeight), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: attr, context: nil).size
        return ceil(size.height)
    }
    
    func updateWithNote(note:VNNote){
        var str = note.title
        if str.isEmpty{
            str = note.content
        }
        self.titleLabel?.text = str
        var titleHeight = NoteListCell.heightwithString(str, width: _backgroundView!.frame.width - kCellPadding*2)
        
        titleLabel!.frame.size.height = titleHeight
        
        timeLable!.frame.origin.y = kCellPadding + titleHeight
        
        _backgroundView?.frame.size.height = NoteListCell.heightWithNote(note) - kVerticalPadding*2
        
        var interval = note.createdDate.timeIntervalSince1970
        var index = Int(interval) % getColorArray().count
        var bgcolor = colorArray[index]
        _backgroundView?.backgroundColor = bgcolor
        
        var formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        timeLable?.text = formatter.stringFromDate(note.createdDate)


    }
}

