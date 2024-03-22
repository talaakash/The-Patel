//
//  ChatScreenVC.swift
//  The Patel
//
//  Created by Akash on 13/03/24.
//

import UIKit
import Kingfisher
import Toast_Swift

class ChatScreenVC: UIViewController{
    
    @IBOutlet weak var discussionTbl: UITableView!
    @IBOutlet weak var messageBox: UITextField!
    @IBOutlet weak var discussionName: UILabel!
    @IBOutlet weak var discussionImage: UIImageView!
    var discussion: PublicDiscussion?
    var messages: [Messages] = []
    var tempImages: [String:String] = [:]
    var userDetails: UserProfile?
    var userID = ""
    var sendingImage = UIImage()
    override func viewDidLoad() {
        super.viewDidLoad()
        preLoading()
        setup()
    }
    
    private func preLoading(){
        let messageList = DataHandler.shared.getData(model: Messages.self, key: "\(UserSession.messages)\(discussion?.id ?? "")")
        let imagesJson = DataHandler.shared.getJson(key: "\(UserSession.images)\(discussion?.id ?? "")")
        messages = messageList ?? []
        tempImages = imagesJson ?? [:]
        let numberOfRows = self.discussionTbl.numberOfRows(inSection: 0)
        if numberOfRows > 0 {
            let indexPath = IndexPath(row: numberOfRows - 1, section: 0)
            self.discussionTbl.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
        
        // Back Gesture
        let edgePanGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleEdgePanGesture(_:)))
        edgePanGesture.edges = .left
        view.addGestureRecognizer(edgePanGesture)
    }
    
    @objc func handleEdgePanGesture(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        if recognizer.state == .ended {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    private func setup(){
        discussionTbl.register(UINib(nibName: NibsKey.ourMessage, bundle: nil), forCellReuseIdentifier: NibsKey.ourMessageIdentifier)
        discussionTbl.register(UINib(nibName: NibsKey.othersMessage, bundle: nil), forCellReuseIdentifier: NibsKey.othersMessageIdentifier)
        discussionTbl.register(UINib(nibName: NibsKey.ourImage, bundle: nil), forCellReuseIdentifier: NibsKey.ourImageIdentifier)
        discussionTbl.register(UINib(nibName: NibsKey.othersImage, bundle: nil), forCellReuseIdentifier: NibsKey.othersImageIdentifier)
        discussionTbl.register(UINib(nibName: NibsKey.sendingMessage, bundle: nil), forCellReuseIdentifier: NibsKey.sendingMessageIdentifier)
        discussionTbl.register(UINib(nibName: NibsKey.sendingImage, bundle: nil), forCellReuseIdentifier: NibsKey.sendingImageIdentifier)
        self.discussionName.text = discussion?.topic ?? ""
        self.discussionImage.kf.setImage(with: URL(string: discussion?.image ?? ""))
        guard let user = UserDefaults.standard.object(forKey: UserSession.user) as? [String:Any] else { return }
        guard let userid = user[UserSession.userID] as? String else { return }
        userID = userid
        FirestoreManager.shared.getDocument(collection: .User, name: userid, complationHandler: { status, error, data in
            if status == true {
                if let user = data{
                    self.userDetails = UserProfile(json: user)
                }
            } else { self.view.makeToast(error) }
        })
        self.setListener()
    }
    
    private func setListener(){
        FirestoreManager.shared.setDocumentListner(collection: .messages, field: ModelKey.discussionId, value: discussion?.id ?? "", complationHandler: { status, error, snapShot in
            if status == true{
                if let data = snapShot{
                    self.messages.removeAll()
                    for message in data{
                        let messageobj = Messages(json: message)
                        self.messages.append(messageobj)
                    }
                    for message in self.messages {
                        self.tempImages[message.senderId] = ""
                    }
                    for key in self.tempImages.keys{
                        FirestoreManager.shared.getDocument(collection: .User, name: key, complationHandler: { status, error, data in
                            if status == true{
                                if let profilePic = data?[ModelKey.profilePic] as? String{
                                    self.tempImages.updateValue(profilePic, forKey: key)
                                }
                            }
                        })
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                        DataHandler.shared.setData(model: Messages.self, key: "\(UserSession.messages)\(self.discussion?.id ?? "")", data: self.messages)
                        DataHandler.shared.setJson(key: "\(UserSession.images)\(self.discussion?.id ?? "")", json: self.tempImages)
                        self.discussionTbl.reloadData()
                        let numberOfRows = self.discussionTbl.numberOfRows(inSection: 0)
                        if numberOfRows > 0 {
                            let indexPath = IndexPath(row: numberOfRows - 1, section: 0)
                            self.discussionTbl.scrollToRow(at: indexPath, at: .bottom, animated: true)
                        }
                    })
                }
            } else { self.view.makeToast(error) }
        })
    }
    
    private func selectedImage(image: UIImage){
        sendingImage = image
        let messageObj = Messages(json: [ModelKey.discussionId: discussion?.id ?? "",ModelKey.message: "", ModelKey.isMessage: false, ModelKey.messageTime: Date(), ModelKey.sender: "Self"])
        messages.append(messageObj)
        self.discussionTbl.reloadData()
        let numberOfRows = self.discussionTbl.numberOfRows(inSection: 0)
        if numberOfRows > 0 {
            let indexPath = IndexPath(row: numberOfRows - 1, section: 0)
            self.discussionTbl.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
        
        FirebaseStorageManager.shared.storeData(type: .Message, image: image, complationHandler: { [self] status, error, data in
            if status == true{
                if let url = data{
                    let stringUrl = String(describing: url)
                    let uniqueKey = FirestoreManager.shared.getUniqueID(collection: .messages)
                    FirestoreManager.shared.setDocument(collection: .messages, key: uniqueKey, data: [ModelKey.discussionId: discussion?.id ?? "", ModelKey.message: stringUrl , ModelKey.isMessage: false, ModelKey.messageTime: Date(), ModelKey.sender: userID], complationHandler: { status, error in
                        if status == false{ self.view.makeToast(error) }
                    })
                } else { self.view.makeToast(ErrorKey.errorMessage) }
            } else { self.view.makeToast(error) }
        })
    }
    
    @IBAction func backButtonClicked(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func attachMent(_ sender: UIButton){
        let picker = UIImagePickerController()
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    @IBAction func sendMessage(_ sender: UIButton){
        guard let message = messageBox.text else { return }
        if message == "" { return }
        let uniqueId = FirestoreManager.shared.getUniqueID(collection: .messages)
        guard let user = UserDefaults.standard.object(forKey: UserSession.user) as? [String:Any] else { return }
        guard let userid = user[UserSession.userID] as? String,let discussionId = discussion?.id else { return }
        
        let messageObj = Messages(json: [ModelKey.discussionId: discussion?.id ?? "",ModelKey.message: message, ModelKey.isMessage: true, ModelKey.messageTime: Date(), ModelKey.sender: "Self"])
        messages.append(messageObj)
        self.discussionTbl.reloadData()
        let numberOfRows = self.discussionTbl.numberOfRows(inSection: 0)
        if numberOfRows > 0 {
            let indexPath = IndexPath(row: numberOfRows - 1, section: 0)
            self.discussionTbl.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }

        FirestoreManager.shared.setDocument(collection: .messages, key: uniqueId, data: [ModelKey.discussionId: discussionId, ModelKey.message: message, ModelKey.isMessage: true, ModelKey.messageTime: Date(), ModelKey.sender: userid], complationHandler: { status, error in
            if status == true{
                self.messageBox.text = ""
                FirestoreManager.shared.setDocument(collection: .publicDiscussion, key: discussionId, data: [ModelKey.sender: self.userDetails?.name ?? "", ModelKey.isMessage: true, ModelKey.messageTime: Date(), ModelKey.lastMessage: message], merge: true, complationHandler: { status, error in
                    if status == false{ self.view.makeToast(error) }
                })
            } else { self.view.makeToast(error) }
        })
    }
}

extension ChatScreenVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        if message.senderId == "Self"{
            if message.isMessage == true{
                let cell = tableView.dequeueReusableCell(withIdentifier: NibsKey.sendingMessageIdentifier, for: indexPath) as! SendingMessage
                cell.message.text = message.message
                cell.time.text = message.messageTime.getTime()
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: NibsKey.sendingImageIdentifier, for: indexPath) as! SendingImage
                cell.messageImage.image = sendingImage
                return cell
            }
        }
        
        if userID == message.senderId{
            if message.isMessage == true{
                let cell = tableView.dequeueReusableCell(withIdentifier: NibsKey.ourMessageIdentifier, for: indexPath) as! OurMessage
                cell.message.text = message.message
                cell.time.text = message.messageTime.getTime()
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: NibsKey.ourImageIdentifier, for: indexPath) as! OurImage
                cell.messageImage.kf.setImage(with: URL(string: message.message))
                cell.time.text = message.messageTime.getTime()
                return cell
            }
        } else {
            if message.isMessage == true{
                let cell = tableView.dequeueReusableCell(withIdentifier: NibsKey.othersMessageIdentifier, for: indexPath) as! OthersMessage
                cell.message.text = message.message
                cell.time.text = message.messageTime.getTime()
                cell.setWidth(width: (tableView.frame.width - 16))
                cell.senderImage.kf.setImage(with: URL(string: tempImages[message.senderId] ?? ""))
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: NibsKey.othersImageIdentifier, for: indexPath) as! OthersImage
                cell.messageImage.kf.setImage(with: URL(string: message.message))
                cell.profilePic.kf.setImage(with: URL(string: tempImages[message.senderId] ?? ""))
                cell.time.text = message.messageTime.getTime()
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = messages[indexPath.row]
        if message.isMessage == false{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: ViewControllerKey.imagePreviewScreen) as? ImagePreviewVC
            vc?.previewImagestring = message.message
            self.navigationController?.pushViewController(vc!, animated: false)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let message = messages[indexPath.row]
        if message.isMessage == true{
            let text = message.message
            var textWidth: CGFloat
            if userID == message.senderId{
                textWidth = tableView.frame.width - 200
            } else {
                textWidth = tableView.frame.width - 110
            }
            let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)]
            let boundingRect = NSString(string: text).boundingRect(with: CGSize(width: textWidth, height: .greatestFiniteMagnitude), options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: attributes, context: nil)
            let estimatedHeight = ceil(boundingRect.height) + 8 + 8
            if estimatedHeight < 72{
                return 72
            }
            return estimatedHeight
        } else {
            return 182
        }
    }
}

extension ChatScreenVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            selectedImage(image: pickedImage)
        }
        dismiss(animated: true, completion: nil)
    }
}
