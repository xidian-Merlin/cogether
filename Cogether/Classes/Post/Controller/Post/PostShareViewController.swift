//
//  PostShareViewController.swift
//  Cogether
//
//  Created by tongho on 2017/5/20.
//  Copyright © 2017年 tongho. All rights reserved.
//
import UIKit
import SnapKit
//import YYText
import RichEditorView


class PostShareViewController: UIViewController {
    
    var PostviewTitle:String?
    
    var contentTitle:String?    //内容标题
    var cotentSig:String?       //内容标签，最后上传是将这两个与HtmlString 进行拼接
    
    var htmlString: String?
    
    var imageUrl : String?
    
    
    var keyHeight = CGFloat() //键盘的高度
    
    var compareHeight = CGFloat() //view初始的高度
    
    let titleText = UITextField()
    
    
    
    
    
    
      
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
    lazy var contentFild:RichEditorView = {[unowned self] in
        
        
        let conField = RichEditorView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.view.addSubview(conField)
        conField.snp.makeConstraints({ (make) in
            make.top.equalTo(self.sigView.snp.bottom).offset(5)
            make.left.equalTo(0)
            make.bottom.equalTo(-44)
            make.right.equalTo(0)
            
            
        })
        
        return conField
        }()
    
    
    //懒加载 富文本工具条
    lazy var toolbar: RichEditorToolbar = {
        let toolbar = RichEditorToolbar(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 44))
        toolbar.options = RichEditorDefaultOption.all
        return toolbar
    }()
    
//    //MARK:-懒加载底部的工具栏
//    lazy var toolView:UIView = {
//        let toolbar = UIView()
//        self.view.addSubview(toolbar)
//        toolbar.snp.makeConstraints({ (make) in
//            make.left.equalTo(0)
//            make.right.equalTo(0)
//            make.height.equalTo(44)
//        })
//        
//        //在toolView上添加表情与图库按钮
//        let expressionButton = UIButton()
//        toolbar.addSubview(expressionButton)
//        expressionButton.setImage(UIImage(named:"au9"),for:.normal)
//        expressionButton.snp.makeConstraints({ (make) in
//            make.left.equalTo(20)
//            make.top.equalTo(5)
//            make.width.height.equalTo(30)
//        })
//        
//        let imageButton = UIButton()
//        toolbar.addSubview(imageButton)
//        imageButton.setImage(UIImage(named:"aop.9"), for:.normal)
//        imageButton.addTarget(self, action: #selector(selectImage), for: UIControlEvents.touchUpInside)
//        imageButton.snp.makeConstraints({ (make) in
//            make.left.equalTo(70)
//            make.top.equalTo(5)
//            make.width.height.equalTo(30)
//        })
//        
//        return toolbar
//        
//        
//    }()
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentFild.delegate = self
        contentFild.inputAccessoryView = toolbar
        
        toolbar.delegate = self
        toolbar.editor = contentFild
        
        let item = RichEditorOptionItem(image: nil, title: "Clear") { toolbar in
            toolbar.editor?.html = ""
        }
        
        var options = toolbar.options
        options.append(item)
        toolbar.options = options
        
        
        compareHeight = self.view.frame.size.height
        //建立导航栏
        self.setUpNavBar()
        self.view.backgroundColor = UIColor.hexInt(0xf3f3f3)
        
        self.titleView.backgroundColor = .white
        self.sigView.backgroundColor = .white
        self.contentFild.backgroundColor = .white
        
      
        
//        self.toolView.backgroundColor = .white
        
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
            self.view.endEditing(true)
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



extension PostShareViewController:UITextFieldDelegate, UITextViewDelegate {
    //MARK: UITextViewDelegate
    
    
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
//        private func imagePickerController(picker: UIImagePickerController,
//                                   didFinishPickingMediaWithInfo info: [String : AnyObject]) {
//    
//             dismiss(animated: true, completion: nil)
//    
//           print("dfdsfdfdfdafsafdsf")
//            if (info[UIImagePickerControllerOriginalImage] as? UIImage) != nil {
//              //将图片发给服务器
//    
//                print("dfdsfdfdfdafsafdsf")
//                //发送成功，将图片显示在编辑界面
//               
//    
//    
//    
//    
//            }
//    
//        }
  //   实现代理的方法
   //  注意，这里和swift3.0之前的版本实现方法都不太一样，这是唯一的写法，网上流传的其他方法都是过时的
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            let imageData = UIImagePNGRepresentation(image)
            //将图片上传给七牛云
            //生成当前时间字符串
            //当前时间的时间戳
            let timeInterval:TimeInterval = Date().timeIntervalSince1970
            let timeStamp = Int(timeInterval)
            TokenHelper.shared.put(imageData, key: "\(timeStamp)", token: THUserHelper.shared.token!, complete: { (info, serverKey, resp) in
                if (info?.statusCode == 200 && resp != nil){
                    print(info!)
                    print(serverKey!)
                    self.imageUrl = qiniuCommom + serverKey!
                    self.toolbar.editor?.insertImage(self.imageUrl!, alt: "Gravatar")
                    
                }else{
                     print("返回错误")
                }
                
                
                
            }, option: nil)
            
            //上传成功后，修改生成的json字符串
            
            //解析生成的json字符串，生成新的富文本    使用这一套在显示的时候也是适合使用的  考虑使用KVO
            
            
            
            //            // 将图片显示给UIImageView
            //            let attachment = NSMutableAttributedString.yy_attachmentString(withContent: image, contentMode: UIViewContentMode.center, attachmentSize: image.size, alignTo: font, alignment: YYTextVerticalAlignment.center)
            //                        self.contentText.append(NSAttributedString(string: "\n", attributes:nil))
            //                        self.contentText.append(attachment)
            //                        self.contentFild.attributedText = contentText;
            
            
            
        }else{
            print("pick image wrong")
        }
        // 收回图库选择界面
        self.dismiss(animated: true, completion: nil)
    }
    
    func deleteImage(sender:UIButton?) {
        print("删除一张图片")
        
    }
    
    
    //
    //        //修改对应的json
    //        let jsonString = NSString(string:"myImg=http://oopqx0v1l.bkt.clouddn.com/1496114877205.pngfenge完全不知道fengemyImg=http://oopqx0v1l.bkt.clouddn.com/1496114900850.pngfenge")
    //
    //        var stringArray = jsonString.components(separatedBy:"fenge")
    //        print(stringArray.description)
    
    //"content": "讨论讨论fengemyImg=http://oopqx0v1l.bkt.clouddn.com/1495119196689.pngfenge",
    
    //当文本发生改变时，记录下当前文本的改变
    // contentText.setAttributedString(self.contentFild.attributedText!)
    
    
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}



extension PostShareViewController: RichEditorDelegate {
    
    
    func richEditor(_ editor: RichEditorView, contentDidChange content: String) {
        if content.isEmpty {
            // htmlTextView.text = "HTML Preview"
        } else {
            htmlString = content
            print(htmlString)
            // htmlTextView.text = content
        }
    }
    
}

extension PostShareViewController: RichEditorToolbarDelegate {
    
    fileprivate func randomColor() -> UIColor {
        let colors: [UIColor] = [
            .red,
            .orange,
            .yellow,
            .green,
            .blue,
            .purple
        ]
        
        let color = colors[Int(arc4random_uniform(UInt32(colors.count)))]
        return color
    }
    
    func richEditorToolbarChangeTextColor(_ toolbar: RichEditorToolbar) {
        let color = randomColor()
        toolbar.editor?.setTextColor(color)
    }
    
    func richEditorToolbarChangeBackgroundColor(_ toolbar: RichEditorToolbar) {
        let color = randomColor()
        toolbar.editor?.setTextBackgroundColor(color)
    }
    
    func richEditorToolbarInsertImage(_ toolbar: RichEditorToolbar) {
        //此处跳转进入相片选择，将图片发送给七牛云，然后将链接加入
        self.selectImage()
        
        
        
        
    }
    
    func richEditorToolbarInsertLink(_ toolbar: RichEditorToolbar) {
        // Can only add links to selected text, so make sure there is a range selection first
        if toolbar.editor?.hasRangeSelection == true {
            toolbar.editor?.insertLink("http://github.com/cjwirth/RichEditorView", title: "Github Link")
        }
    }
}
