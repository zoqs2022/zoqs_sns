//
// 主にfirestore,storageのAPIを叩く場所
//
//
//  Created by 島田将太郎 on 2023/01/14.
//

import UIKit
import Foundation
import Firebase
import FirebaseFirestore
import FirebaseStorage

struct DatabaseHelper {
    
    let uid = AuthHelper().uid()
    let db = Firestore.firestore()
    let storage = Storage.storage().reference()
    
    func getUserInfo(userID:String,result:@escaping(String) -> Void){
        db.collection("user").document(userID).getDocument(completion: {
            (querySnapshot, error) in
            if error == nil {
                let data = querySnapshot?.data()
                guard let name = data?["name"] as! String? else {
                    result("")
                    return
                }
                result(name)
            } else {
                result("")
            }
        })
    }
    
    func getUserName(userID:String,result:@escaping(String) -> Void) {
        db.collection("user").document(userID).getDocument(completion: {
            (doc, error) in
            if error == nil {
                let data = doc?.data()
                guard let name = data?["name"] as! String? else { return }
                result(name)
            }
        })
    }
    
    func getUserData(userID:String,result:@escaping([String : Any]?) -> Void) {
        db.collection("user").document(userID).getDocument(completion: { (doc, error) in
            if let data = doc?.data() {
                result(data)
            } else {
                result(nil)
            }
        })
    }
    
    func getImageData(userID:String, result:@escaping(Data?) -> Void){
        let imageRef = storage.child("image/"+userID+".jpeg")
        imageRef.getData(maxSize: 10 * 1024 * 1024) { data, error in
//            if error != nil {
//                print("\(userID) don't have image")
//            }
            result(data)
        }
    }


    func resisterUserInfo(name:String,image:UIImage?,result:@escaping(Bool) -> Void){
        db.collection("user").document(uid).setData(["name":name])
//        let resized = image.resize(toWidth: 300)
        guard let imageData = image?.jpegData(compressionQuality:1) else {
            result(true)
            return
        }
        storage.child("image/\(uid).jpeg").putData(imageData, metadata: nil){ (metadata, error) in
            if error != nil {
                print("画像登録に失敗した！！！", error!)
                result(false)
            } else {
                print("画像登録に成功！")
                result(true)
            }
        }
    }
    
    func editUserInfo(name:String,image:UIImage?,result:@escaping(String?) -> Void){
        db.collection("user").document(uid).setData(["name":name], merge: true)
//        let resized = image.resize(toWidth: 300)
        guard let imageData = image?.jpegData(compressionQuality:1) else {
            result("画像が設定されていません")
            return
        }
        storage.child("image/\(uid).jpeg").putData(imageData, metadata: nil){ (metadata, error) in
            if error != nil {
                print("画像登録に失敗した！！！")
                result(nil)
            } else{
                result("画像の更新に成功！！")
            }
        }
    }
    
    func getFollowers(id:String, result:@escaping([String]) -> Void) {
        var ids = [String]()
        db.collection("user").whereField("follows", arrayContains: id).getDocuments(completion: {(querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    ids.append(document.documentID)
                }
            }
            result(ids)
        })
    }
    
    func addUserInFollows(id: String) async -> String? {
        do {
            try await db.collection("user").document(uid).updateData(["follows": FieldValue.arrayUnion([id])])
            return nil
        } catch let error {
            print("Error writing city to Firestore: \(error)")
            return "フォローに失敗しました"
        }
    }
    
    func removeUserInFollows(id: String) async -> String? {
        do {
            try await db.collection("user").document(uid).updateData(["follows": FieldValue.arrayRemove([id])])
            return nil
        } catch let error {
            print("Error writing city to Firestore: \(error)")
            return "フォロー解除に失敗しました"
        }
    }
    
    func getPostList(ids: [String],result:@escaping([String:[String: Any]]) -> Void) {
        var posts: [String:[String: Any]] = [:]
        db.collection("post").whereField("userID", in: ids).getDocuments() { querySnapshot, err in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    posts[document.documentID] = document.data()
                }
            }
            result(posts)
        }
    }
    
    func getSelfPosts(id:String, result:@escaping([String:[String: Any]]) -> Void) {
        var posts: [String:[String: Any]] = [:]
        db.collection("post").whereField("userID", isEqualTo: id).getDocuments(completion: {(querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    posts[document.documentID] = document.data()
                }
            }
            result(posts)
        })
    }
    
    func getPostImage(id: String, result:@escaping(Data?) -> Void){
        let imageRef = storage.child("image/\(id)/1.jpeg")
        imageRef.getData(maxSize: 10 * 1024 * 1024) { data, error in
//            if error == nil {
//                print("\(id) don't have image")
//            }
            result(data)
        }
    }
    
    func createPost(data: [String: Any], image:UIImage?, result:@escaping(String?) -> Void) {
        var ref: DocumentReference? = nil
        ref = db.collection("post").addDocument(data: data) { err in
            if let err = err {
                print("Error adding document: \(err)")
                result(nil)
            } else {
                print("Document added with ID: \(ref!.documentID)")
                if let image = image {
                    let imageData = image.jpegData(compressionQuality:1)
                    storage.child("image/\(ref!.documentID)/1.jpeg").putData(imageData!, metadata: nil){ (metadata, error) in
                        if error != nil {
                            result(nil)
                        } else {
                            print("画像登録に成功！")
                            result(ref!.documentID)
                        }
                    }
                } else {
                    result(ref!.documentID)
                }
            }
        }
    }
    
    func createRoom(userID:String, result:@escaping(String?) -> Void){
        var ref: DocumentReference? = nil
        ref = db.collection("room").addDocument(data: ["users":[userID,uid], "createdAt": Timestamp()]) { err in
            if let err = err {
                print("Error adding document: \(err)")
                result(nil)
            } else {
                result(ref?.documentID)
            }
        }
    }
    
    func sendChatMessage(roomID:String,text:String){
        db.collection("room").document(roomID).collection("chat").addDocument(data: ["userID":uid,"text":text,"date": Timestamp()])
    }
    
    func chatDataListener(roomID:String,result:@escaping([String:[String: Any]]) -> Void){
        var chats: [String:[String: Any]] = [:]
        db.collection("room").document(roomID).collection("chat").order(by: "date").addSnapshotListener({ (querySnapshot, error) in
            if let err = error {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    chats[document.documentID] = document.data()
                }
            }
            result(chats)
        })
    }
    
    func getMyRoomList(result:@escaping([String:[String: Any]]) -> Void){
        var rooms: [String:[String: Any]] = [:]
        db.collection("room").whereField("users", arrayContains: uid).addSnapshotListener({ (querySnapshot, error) in
            if let err = error {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    rooms[document.documentID] = document.data()
                }
            }
            result(rooms)
        })
    }
}


struct ChatText: Identifiable {
    var id = UUID()
    var text:String = ""
    var userID:String = ""
    var date: Date = Date()
}

