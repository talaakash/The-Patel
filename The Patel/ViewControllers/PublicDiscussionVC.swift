//
//  PublicDiscussionVC.swift
//  The Patel
//
//  Created by Akash on 12/03/24.
//

import UIKit
import Toast_Swift
import Kingfisher

class PublicDiscussionVC: UIViewController {

    @IBOutlet weak var publicDiscussiontbl: UITableView!
    var discussions: [PublicDiscussion] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        preLoading()
    }
    override func viewWillAppear(_ animated: Bool) {
        setup()
    }
    
    private func preLoading(){
        let discussionList = DataHandler.shared.getData(model: PublicDiscussion.self, key: UserSession.publicDiscussion)
        discussions = discussionList ?? []
        if discussionList == nil{
            ProgressBar.shared.show()
        }
    }
    
    private func setup(){
        publicDiscussiontbl.register(UINib(nibName: NibsKey.publicDiscussion, bundle: nil), forCellReuseIdentifier: NibsKey.publicDiscussionIdentifier)
        FirestoreManager.shared.getDocuments(collection: .publicDiscussion, complationHandler: { status, error, snapshot in
            if status == true{
                if let data = snapshot{
                    self.discussions = []
                    for discussion in data{
                        self.discussions.append(PublicDiscussion(json: discussion))
                    }
                } else {
                    self.view.makeToast(ErrorKey.errorMessage)
                }
            } else {
                self.view.makeToast(error)
            }
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 3 , execute: {
            ProgressBar.shared.hide()
            DataHandler.shared.setData(model: PublicDiscussion.self, key: UserSession.publicDiscussion, data: self.discussions)
            self.publicDiscussiontbl.reloadData()
        })
    }

    @IBAction func backButtonClicked(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func createButtonClicked(_ sender: UIButton){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: ViewControllerKey.createDiscussionScreen) as? CreateDiscussionVC
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}

extension PublicDiscussionVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return discussions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NibsKey.publicDiscussionIdentifier, for: indexPath) as! PublicDiscussions
        let discussion = discussions[indexPath.row]
        cell.discussionImage.kf.setImage(with: URL(string: discussion.image ?? ""))
        cell.title.text = discussion.topic
        cell.sender.text = ErrorKey.noValue
        if discussion.lastMessageSender != ""{
            cell.sender.text = "\(discussion.lastMessageSender ?? ""):"
            cell.message.text = discussion.lastMessage ?? ""
            cell.time.text = discussion.lastMessageTime?.timeAgo()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: ViewControllerKey.chatScreen) as? ChatScreenVC
        vc?.discussion = discussions[indexPath.row]
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}
