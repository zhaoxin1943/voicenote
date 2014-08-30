//
//  NoteDetailController.swift
//  VoiceNote
//
//  Created by 赵新 on 14-8-28.
//  Copyright (c) 2014年 souche. All rights reserved.
//

import UIKit

let kViewOriginY:CGFloat = 70;
let kTextFieldHeight:CGFloat = 30;
let kToolbarHeight:CGFloat = 44;
let kVoiceButtonWidth:CGFloat = 100;
let APP_ID = "540052ac"

class NoteDetailController:UIViewController,UIActionSheetDelegate,UINavigationControllerDelegate,UIAlertViewDelegate,IFlyRecognizerViewDelegate{

    var mNote:VNNote?
    var titleTextFile:UITextField?
    var contentTextView:UITextView?
    var voiceButton:UIButton?
    var isEditingTitle:Bool = true
    var iflyRecognizerView:IFlyRecognizerView?
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(note:VNNote?){
        super.init()
        self.mNote = note
    }
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor.whiteColor()
        initComps()
        setupNavigationBar()
        setupSpeechRecognizer()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
    }
    func initComps(){
        var frame = CGRectMake(kHorizontalMargin, kViewOriginY, view.frame.width - kHorizontalMargin*2, kTextFieldHeight)
        
        var doneBarButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: "hideKeyboard")
        
        doneBarButton.width = ceil(self.view.frame.size.width)/3 - 30
        
        var voiceBarButton = UIBarButtonItem(image: UIImage(named: "micro_small"), style: UIBarButtonItemStyle.Plain, target: self, action: "useVoiceInput")
        voiceBarButton.width = ceil(self.view.frame.size.width)/3
        
        var toolbar = UIToolbar(frame: CGRectMake(0, 0, self.view.frame.size.width, kToolbarHeight))
        toolbar.tintColor = UIColor.emeraldColor()
        toolbar.items = [doneBarButton,voiceBarButton]
        
        titleTextFile = UITextField(frame: frame)
        if mNote != nil{
            titleTextFile?.text = mNote?.title
        }else{
            titleTextFile?.placeholder = NSLocalizedString("标题",  comment: "")
        }
        titleTextFile?.textColor = UIColor.hollyGreenColor()
        titleTextFile?.inputAccessoryView = toolbar
        view.addSubview(titleTextFile!)
        
        var lineView = UIView(frame: CGRectMake(kHorizontalMargin, kViewOriginY + kTextFieldHeight, view.frame.width - kHorizontalMargin*2, 1))
        lineView.backgroundColor = UIColor.hollyGreenColor()
        
        view.addSubview(lineView)
        var textY = kViewOriginY + kTextFieldHeight + kVerticalMargin
        frame = CGRectMake(kHorizontalMargin, textY , view.frame.width - kHorizontalMargin*2, view.frame.height - textY - kVerticalMargin*2)
        contentTextView = UITextView(frame: frame)
        contentTextView?.textColor = UIColor.hollyGreenColor()
        contentTextView?.font = UIFont.systemFontOfSize(16)
        contentTextView?.autocapitalizationType = UITextAutocapitalizationType.None
        contentTextView?.autocorrectionType = UITextAutocorrectionType.No
        contentTextView?.scrollEnabled = true
        contentTextView?.inputAccessoryView = toolbar
        
        if mNote != nil{
            contentTextView?.text = mNote?.content
        }
        
        view.addSubview(contentTextView!)
        
    }
    
    func keyboardWillShow(notification:NSNotification){
        var userInfo:NSDictionary = notification.userInfo!


        UIView.animateWithDuration(userInfo[UIKeyboardAnimationDurationUserInfoKey] as NSTimeInterval,
            delay: 0.0,
            options : UIViewAnimationOptions.CurveLinear,
            animations : {
                var keyboardFragme = userInfo[UIKeyboardFrameBeginUserInfoKey]?.CGRectValue()
                var keyboardHeight = keyboardFragme?.size.height
                self.contentTextView!.frame.size.height = self.view.frame.size.height - kViewOriginY - kTextFieldHeight - keyboardHeight! - kVerticalMargin - kToolbarHeight
            },
            completion : nil)
    }
    
    func keyboardWillHide(notification:NSNotification){
        var userInfo:NSDictionary = notification.userInfo!
        
        
        UIView.animateWithDuration(userInfo[UIKeyboardAnimationDurationUserInfoKey] as NSTimeInterval,
            delay: 0.0,
            options : UIViewAnimationOptions.CurveLinear,
            animations : {
                self.contentTextView!.frame.size.height = self.view.frame.size.height - kViewOriginY - kTextFieldHeight  - kVerticalMargin*3
            },
            completion : nil)
        
    }
    
    func hideKeyboard(){
        if titleTextFile!.isFirstResponder(){
            isEditingTitle = true
            titleTextFile?.resignFirstResponder()
        }
        if contentTextView!.isFirstResponder(){
            isEditingTitle = false
            contentTextView?.resignFirstResponder()
        }
        
    }
    
    func useVoiceInput(){
        hideKeyboard()
        iflyRecognizerView!.start()
    }
    
    func setupNavigationBar(){
        var saveItem = UIBarButtonItem(title: "保存", style: UIBarButtonItemStyle.Plain, target: self, action: "save")
        var moreItem = UIBarButtonItem(image: UIImage(named: "ic_more_white"), style: UIBarButtonItemStyle.Plain, target: self, action: "moreActionButtonPressed")

        self.navigationItem.rightBarButtonItems = [moreItem,saveItem]
    }
    
    func save(){
        var title = titleTextFile?.text
        var content = contentTextView?.text
        if ((content == nil || content!.isEmpty) && (title == nil || title!.isEmpty)){
            SVProgressHUD.showErrorWithStatus("请输入文字")
            return
        }
        var createDate:NSDate = NSDate.date()
        if mNote != nil && mNote?.createdDate != nil{
            createDate = mNote!.createdDate
        }
        
        var note = VNNote(title: title!, content: content!, createdDate: createDate, updateDate: NSDate.date())
        mNote = note
        if note.persistence(){
            SVProgressHUD.showSuccessWithStatus("保存成功")
            NSNotificationCenter.defaultCenter().postNotificationName(kNotificationCreateFile, object: nil)
        }else{
            SVProgressHUD.showSuccessWithStatus("保存失败")
        }
        self.navigationController.popViewControllerAnimated(true)
    }
    
    func moreActionButtonPressed(){
        hideKeyboard()
        var actionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil, otherButtonTitles: "拷贝","分享到朋友圈")
        actionSheet.showInView(self.view)
    }
    
    func actionSheet(actionSheet: UIActionSheet!, clickedButtonAtIndex buttonIndex: Int) {
        NSLog("index = \(buttonIndex)")
        if buttonIndex == 1{
            var pasteboard = UIPasteboard.generalPasteboard()
            pasteboard.string = contentTextView?.text
            SVProgressHUD.showSuccessWithStatus("已复制到粘贴板")
        }else if buttonIndex == 2{
            shareToWeixin()
        }
    }
    
    
    func shareToWeixin(){
        NSLog("weixin")
    }
    
    func setupSpeechRecognizer(){
        var initString = "appid=\(APP_ID)"
        IFlySpeechUtility.createUtility(initString)
        iflyRecognizerView = IFlyRecognizerView(center: self.view.center)
        iflyRecognizerView!.delegate = self
        iflyRecognizerView!.setParameter("iat", forKey: IFlySpeechConstant.IFLY_DOMAIN())
        iflyRecognizerView!.setParameter(nil, forKey: IFlySpeechConstant.ASR_AUDIO_PATH())
        iflyRecognizerView!.setParameter("plain",forKey: IFlySpeechConstant.RESULT_TYPE())
        
    }
    
    func onResult(resultArray: [AnyObject]!, isLast: Bool) {
        var result = NSMutableString()
        var dic = resultArray[0] as NSDictionary
        for key in dic.allKeys{
            result.appendString(key as String)
        }
        if isEditingTitle{
            titleTextFile?.text = NSString(format: "%@%@",titleTextFile!.text,result)
        }else{
            contentTextView?.text = NSString(format: "%@%@",contentTextView!.text,result)
        }
    }
    
    func onError(error: IFlySpeechError!) {
        NSLog(error.errorDesc())
    }
        
}
