//
//  PostShareViewController.swift
//  Cogether
//
//  Created by tongho on 2017/5/20.
//  Copyright © 2017年 tongho. All rights reserved.
//

import UIKit
import SnapKit
import YYText

class PostShareViewController: UIViewController {
    
    var PostviewTitle:String?
    
    var keyHeight = CGFloat() //键盘的高度
    
    var compareHeight = CGFloat() //view初始的高度
    
    let titleText = UITextField()
    
    //定义富文本即有格式的字符串
    var contentText : NSMutableAttributedString = NSMutableAttributedString()
    let font = UIFont.systemFont(ofSize: 16)
    let imageSize = CGSize(width:120,height:120)


    
   
    
    
    
    //保存约束的引用
    var bottomConstraint:Constraint?
    
    let placeholderLabel = UILabel()
    
    //MARK:- 懒加载输入标题栏
    lazy var titleView:UIView = { [unowned self] in
        
       let temView = UIView()
        
        self.view.addSubview(temView)
        
        temView.snp.makeConstraints({ (make) in
            make.top.equalTo(69)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(30)
        })
        
        //在标题view 上添加 textfiled
        
        
        temView.addSubview(self.titleText)
        self.titleText.placeholder = "输入标题"
       self.titleText.snp.makeConstraints({ (make) in
              make.edges.equalTo(temView).inset(UIEdgeInsetsMake(5, 10, 0, 0))
        })
        
        return temView
    
    }()
    
    //MARK:- 懒加载标签View
    lazy var sigView:UIView = { [unowned self] in
        
        let temView = UIView()
        
        self.view.addSubview(temView)
        
        temView.snp.makeConstraints({ (make) in
            make.top.equalTo(self.titleView.snp.bottom).offset(5)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(100)
        })
        
        
        
       let siglable = UILabel()
        siglable.text = "标签"
        temView.addSubview(siglable)
        siglable.snp.makeConstraints({ (make) in
            make.top.equalTo(5)
            make.left.equalTo(10)
            make.height.equalTo(30)
            make.width.equalTo(100)
            
        })
        
        return temView
        
        }()
    
    //MARK:- 懒加载正文文本区域
    lazy var contentFild:YYTextView = {[unowned self] in
        
        let conFiled =  YYTextView()
        conFiled.delegate = self
        
        conFiled.isUserInteractionEnabled = true;
        conFiled.textVerticalAlignment = YYTextVerticalAlignment.top;
        
        self.view.addSubview(conFiled)
        
        conFiled.snp.makeConstraints({ (make) in
            make.top.equalTo(self.sigView.snp.bottom).offset(5)
            make.left.equalTo(0)
            make.bottom.equalTo(-44)
            make.right.equalTo(0)
            
            
        })
        
        
        self.placeholderLabel.frame =  CGRect(x: 10, y: 5, width: 100, height: 20)
        self.placeholderLabel.font = UIFont.systemFont(ofSize: 13)
        self.placeholderLabel.text = "正文"
        conFiled.addSubview(self.placeholderLabel)
        self.placeholderLabel.textColor = UIColor.init(colorLiteralRed: 72/256, green: 82/256, blue: 93/256, alpha: 1)
        return conFiled
    }()

    //MARK:-懒加载底部的工具栏
    lazy var toolView:UIView = {
      let toolbar = UIView()
        self.view.addSubview(toolbar)
        toolbar.snp.makeConstraints({ (make) in
            make.left.equalTo(0)
            make.right.equalTo(0)
              self.bottomConstraint = make.bottom.equalTo(0).constraint
            make.height.equalTo(44)
        })
        
        //在toolView上添加表情与图库按钮
        let expressionButton = UIButton()
        toolbar.addSubview(expressionButton)
        expressionButton.setImage(UIImage(named:"au9"),for:.normal)
        expressionButton.snp.makeConstraints({ (make) in
              make.left.equalTo(20)
              make.top.equalTo(5)
              make.width.height.equalTo(30)
        })
        
        let imageButton = UIButton()
        toolbar.addSubview(imageButton)
        imageButton.setImage(UIImage(named:"aop.9"), for:.normal)
        imageButton.addTarget(self, action: #selector(selectImage), for: UIControlEvents.touchUpInside)
        imageButton.snp.makeConstraints({ (make) in
            make.left.equalTo(70)
            make.top.equalTo(5)
            make.width.height.equalTo(30)
        })
        
      return toolbar
    
    
    }()
    
    
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
         compareHeight = self.view.frame.size.height
        //建立导航栏
        self.setUpNavBar()
        self.view.backgroundColor = UIColor.hexInt(0xf3f3f3)
        
        self.titleView.backgroundColor = .white
        self.sigView.backgroundColor = .white
        self.contentFild.backgroundColor = .white
        
        
//        //图片资源
//        let image = UIImage(named:"me")
//        
//        
//        //添加文本与第一张图
//        contentText.append(NSAttributedString(string: "这是第一张图片\n", attributes:nil))
//        let attachment = NSMutableAttributedString.yy_attachmentString(withContent: image, contentMode: UIViewContentMode.center, attachmentSize: (image?.size)!, alignTo: font, alignment: YYTextVerticalAlignment.center)
//        contentText.append(attachment)
//        
//        self.contentFild.attributedText = contentText
        
        
        
        
        
        self.toolView.backgroundColor = .white
        
        //取消键盘手势
        let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleTap))
         swipeLeftGesture.direction = UISwipeGestureRecognizerDirection.down //下滑手势
        
        view.addGestureRecognizer(swipeLeftGesture)
        
        //注册键盘通知
        NotificationCenter.default.addObserver(self, selector:#selector(keyBoardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(keyBoardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: nil)

        // Do any additional setup after loading the view.
    }

    
    //MARK:-设置导航栏
    func setUpNavBar(){
        
        self.title = PostviewTitle!
        // init(title: String?, style: UIBarButtonItemStyle, target: Any?, action: Selector?)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "返回", style: .plain, target: self, action: #selector(back))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发布", style: .plain, target: self, action: #selector(submit))
        
        
    }
    
    
    
    func back(){
        //返回上一层
        self.navigationController?.popViewController(animated:true)
        
    }
    
    func submit()  {
        
        //将修改信息提交到服务器
        
    }
    
    func selectImage(){
        
        //判断相机是否可用，如果可用就有拍照选项，反正则没有。
        
        let actionSheet: UIActionSheet
        // 判断相机是否可用
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            actionSheet = UIActionSheet(title: "请选择头像来源", delegate: self as? UIActionSheetDelegate,
                                        cancelButtonTitle: "取消", destructiveButtonTitle: nil,
                                        otherButtonTitles: "从相册选择", "拍照")
        } else {
            actionSheet = UIActionSheet(title: "请选择头像来源", delegate: self as? UIActionSheetDelegate,
                                        cancelButtonTitle: "取消", destructiveButtonTitle: nil,
                                        otherButtonTitles: "从相册选择")
        }
        actionSheet.show(in: view)
    
    
    }
    
    func keyBoardWillShow(aNotification: NSNotification) {
        let userinfo: NSDictionary = aNotification.userInfo! as NSDictionary
        
        let nsValue = userinfo.object(forKey: UIKeyboardFrameEndUserInfoKey)
        
        let keyboardRec = (nsValue as AnyObject).cgRectValue
        
        let height = keyboardRec?.size.height
        
        self.keyHeight = height!
        
        UIView.animate(withDuration: 0.5, animations: {
            
            var frame = self.view.frame
            
            
            if( frame.size.height == self.compareHeight){
            frame.size.height -= self.keyHeight
            
           // frame.origin.y = -self.keyHeight
            }
            
            self.view.frame = frame
            
        }, completion: nil)
        
    }
    
    
    func keyBoardWillHide(aNotification: NSNotification){
        
        UIView.animate(withDuration: 0.5, animations: {
            
            var frame = self.view.frame
            
            frame.size.height += self.keyHeight
            
            // frame.origin.y = -self.keyHeight
            
            self.view.frame = frame
            
        }, completion: nil)
    
    
    }
   
    func handleTap(sender: UISwipeGestureRecognizer) {
        if sender.state == .ended {
            print("收回键盘")
            self.titleText.resignFirstResponder()
            contentFild.resignFirstResponder()
        }
        sender.cancelsTouchesInView = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}



extension PostShareViewController:UITextFieldDelegate, YYTextViewDelegate {
    //MARK: UITextViewDelegate
     func textViewShouldBeginEditing(_ textView: YYTextView) -> Bool {
        print("textViewShouldBeginEditing")
        self.placeholderLabel.isHidden = true // 隐藏
        return true
    }
     func textViewDidBeginEditing(_ textView: YYTextView) {
        
    }
     func textViewShouldEndEditing(_ textView: YYTextView) -> Bool {
                return true
    }
     func textViewDidEndEditing(_ textView: YYTextView) {
        if textView.text.isEmpty {
            self.placeholderLabel.isHidden = false  // 显示
        }
        else{
            self.placeholderLabel.isHidden = true  // 隐藏
        }
        print("textViewDidEndEditing")
    }
     func textViewDidChange(_ textView: YYTextView) {
        
       //当文本发生改变时，记录下当前文本的改变
        contentText.setAttributedString(self.contentFild.attributedText!)
        
        
       

    }
     func textView(_ textView: YYTextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        print("shouldChangeTextInRange")
//        if text == "\n"{ // 输入换行符时收起键盘
//            textView.resignFirstResponder() // 收起键盘
//        }
        return true
    }


}

//实现UIActionSheetDelegate，判断所选择的项

// MARK: - UIActionSheetDelegate
extension PostShareViewController: UIActionSheetDelegate {
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int) {
        print(buttonIndex)
        var sourceType: UIImagePickerControllerSourceType = .photoLibrary
        switch buttonIndex {
        case 1: // 从相册选择
            sourceType = .photoLibrary
        case 2: // 拍照
            sourceType = .camera
        default:
            return
        }
        let pickerVC = UIImagePickerController()
        pickerVC.view.backgroundColor = UIColor.white
        pickerVC.delegate = self
        pickerVC.allowsEditing = true
        pickerVC.sourceType = sourceType
        present(pickerVC, animated: true, completion: nil)
    }
}


extension PostShareViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//    private func imagePickerController(picker: UIImagePickerController,
//                               didFinishPickingMediaWithInfo info: [String : AnyObject]) {
//        
//         dismiss(animated: true, completion: nil)
//        
//       print("dfdsfdfdfdafsafdsf")
//        if (info[UIImagePickerControllerOriginalImage] as? UIImage) != nil {
//          //将图片发给服务器
//            
//            print("dfdsfdfdfdafsafdsf")
//            //发送成功，将图片显示在编辑界面
//            let image = info[UIImagePickerControllerOriginalImage] as? UIImage
//            let image1 = UIImage(named:"me")
//            
//            let attachment = NSMutableAttributedString.yy_attachmentString(withContent: image, contentMode: UIViewContentMode.center, attachmentSize: (image?.size)!, alignTo: font, alignment: YYTextVerticalAlignment.center)
//            self.contentText.append(NSAttributedString(string: "\n", attributes:nil))
//            self.contentText.append(attachment)
//            self.contentFild.attributedText = contentText;
//
//            
//            
//            
//        }
//        
//    }
    // 实现代理的方法
    // 注意，这里和swift3.0之前的版本实现方法都不太一样，这是唯一的写法，网上流传的其他方法都是过时的
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            //将图片上传给七牛云
            
            //上传成功后，修改生成的json字符串
            
            //解析生成的json字符串，生成新的富文本    使用这一套在显示的时候也是适合使用的  考虑使用KVO
            
            
            
//            // 将图片显示给UIImageView
//            let attachment = NSMutableAttributedString.yy_attachmentString(withContent: image, contentMode: UIViewContentMode.center, attachmentSize: image.size, alignTo: font, alignment: YYTextVerticalAlignment.center)
//                        self.contentText.append(NSAttributedString(string: "\n", attributes:nil))
//                        self.contentText.append(attachment)
//                        self.contentFild.attributedText = contentText;
            
            //记录下tView的坐标
            
            
            let tView = UIView()
            tView.size = CGSize(width:kScreenW,height:200)
            
            //在右上角添加一个按钮，可以用来删除该视图
            let deButton = UIButton()
            deButton.setImage(UIImage(named:"ap7"), for: .normal)
            deButton.addTarget(self, action: #selector(deleteImage(sender:)), for: UIControlEvents.touchUpInside)
            tView.addSubview(deButton)
            
            deButton.snp.makeConstraints({ (make) in
                make.top.equalTo(5)
                make.right.equalTo(-5)
                make.width.height.equalTo(30)
                
            })

            //在tview上添加button 与 imageview
            let imageView = UIImageView()
            imageView.image = image
            tView.addSubview(imageView)
            imageView.snp.makeConstraints({ (make) in
                make.top.equalTo(0)
                make.left.equalTo(0)
                make.width.height.equalTo(200)
                
            })
            
            
            tView.backgroundColor = .white
            let attachment1 = NSMutableAttributedString.yy_attachmentString(withContent: tView, contentMode: UIViewContentMode.center, attachmentSize: tView.size , alignTo: font, alignment: YYTextVerticalAlignment.center)
                  self.contentText.append(NSAttributedString(string: "\n", attributes:nil))
            
            
            
            
            
            
             self.contentText.append(attachment1)
        
            self.contentFild.attributedText = contentText;
            
            print(contentText.string)
           
           
        }else{
            print("pick image wrong")
        }
        // 收回图库选择界面
        self.dismiss(animated: true, completion: nil)
    }
    
    func deleteImage(sender:UIButton?) {
            print("删除一张图片")
        
        
        print(sender?.superview)
       // sender?.superview?.removeFromSuperview()
        let attachment1 = NSMutableAttributedString.yy_attachmentString(withContent: sender?.superview, contentMode: UIViewContentMode.center, attachmentSize: (sender?.superview?.size)! , alignTo: font, alignment: YYTextVerticalAlignment.center)
        var index = 0
        var sub = NSAttributedString()
        while !(sub.hashValue == attachment1.hashValue)  {
           sub = self.contentText.attributedSubstring(from: NSRange(location:index ,length: 1))
            index += 1
            print(sub.hashValue)
            print(sub.description)
            print(sub.length)
            print("fdfdsfdfdsfsdfsdfds")
        }
        
        
        //计算该图片前面文字的个数
        self.contentText.deleteCharacters(in: NSRange(location: index-1,length: 1))
        self.contentFild.attributedText = contentText
        
//        
//        //修改对应的json
//        let jsonString = NSString(string:"myImg=http://oopqx0v1l.bkt.clouddn.com/1496114877205.pngfenge完全不知道fengemyImg=http://oopqx0v1l.bkt.clouddn.com/1496114900850.pngfenge")
//        
//        var stringArray = jsonString.components(separatedBy:"fenge")
//        print(stringArray.description)
        
        //"content": "讨论讨论fengemyImg=http://oopqx0v1l.bkt.clouddn.com/1495119196689.pngfenge",
        
        //当文本发生改变时，记录下当前文本的改变
       // contentText.setAttributedString(self.contentFild.attributedText!)

        
        
    
        
    
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
