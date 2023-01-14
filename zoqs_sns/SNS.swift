//
//  SNS.swift
//  zoqs_sns
//
//  Created by takumi on 2022/12/17.
//

import SwiftUI
import FirebaseFirestore

struct SNS: View {
    @State var testArr:[String] = []
    
    var body: some View {
        let users = ["user1","user2","user3"]
        
        
        List{
            ForEach(0..<testArr.count, id:\.self) { index in
                Text(testArr[index])
            }
            
        }.onAppear {
            let db = Firestore.firestore()
           
            for i in 0..<users.count {
                var temp = ""
                db.collection(users[i]).getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            print(document.data())
                            temp = "\(document.data())"
                            testArr.append(temp)
                            print(testArr)
                        }
                    }
                }
            } //for文
        
        }
        
        
        
        
    }
}

struct SNS_Previews: PreviewProvider {
    static var previews: some View {
        SNS()
    }
}
