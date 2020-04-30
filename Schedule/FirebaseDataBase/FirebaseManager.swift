//
//  FirebaseManager.swift
//  Schedule
//
//  Created by Mengtao Tang on 4/29/20.
//  Copyright © 2020 Le Sun. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseCore
import FirebaseAnalytics


class FirebaseManager {
    
    // *********************************************************************************
    // function to retrieve data from, online section by online type
    //  - data
    //  - isValid
    // *********************************************************************************
    func retrieveOnlineSectionInforByCourseBySectionByOnlineType(courseTitle: String?, sectionID: String?, onlineType: String?, CompletionHandler: @escaping ([String: Any]?, Bool?) -> Void) {
        
        // check input data
        if courseTitle == nil {
            CompletionHandler(nil, false)
            return
        }
        // lower case the title
        let title = courseTitle?.lowercased()
        
        if sectionID == nil {
            CompletionHandler(nil, false)
            return
        }
        
        if onlineType == nil {
            CompletionHandler(nil, false)
            return
        }
        
        //print("\(title) \(sectionID) \(onlineType)")
        
        let db = Firestore.firestore()
        
        // get the referece of the document
        let docRef = db.collection(FirebaseConstants.CourseCollection.CollectionTitle).document(title!).collection(FirebaseConstants.CourseCollection.SectionCollection.CollectionTitle).document(sectionID!)
        
        docRef.getDocument { (sectionDoc, error) in
        
            
            // check error
            if error != nil {
                CompletionHandler(nil, false)
            }
            
            var sectionDataList : [String: Any] = [:]
            
            // extract common data
            if let sectionDoc = sectionDoc, sectionDoc.exists {
                if let sectionData = sectionDoc.data() {
                    for section in sectionData {
                        sectionDataList[section.key] = section.value
                    }
                }
            }
            
            //print(sectionDataList)
            
            
            let onlineRef = docRef.collection(FirebaseConstants.CourseCollection.SectionCollection.OnlineCollection.CollectionTitle).document(onlineType!)
            
            
            onlineRef.getDocument { (onlineDoc, error) in
                
                // check error
                if error != nil {
                    //print("check poing 7\n\(error)")
                    CompletionHandler(nil, false)
                }
                
                // extract online data
                if let onlineDoc = onlineDoc, onlineDoc.exists {
                    if let onlineData = onlineDoc.data() {
                        
                        for online in onlineData {
                            sectionDataList[online.key] = online.value
                        }
                        
                        //print(sectionDataList)
                        
                        // return the list to completion handler
                        CompletionHandler(sectionDataList, true)
                    }
                }
                else{
                    //print("doc not found")
                }
            }
        }
        
    }
    
    // *********************************************************************************
    // function to retrieve data from non-online section
    //  - data
    //  - isValid
    // *********************************************************************************
    func retrieveNormalSectionInfoByCourseBySection(courseTitle: String?, sectionID : String?, CompletionHandler: @escaping ([String: Any]?, Bool?) -> Void) {
        if courseTitle == nil {
            CompletionHandler(nil, false)
            return
        }
        // lower case the title
        let title = courseTitle?.lowercased()
        
        if sectionID == nil {
            CompletionHandler(nil, false)
            return
        }
        
        let db = Firestore.firestore()
        
        // get the referece of the document
        let docRef = db.collection(FirebaseConstants.CourseCollection.CollectionTitle).document(title!).collection(FirebaseConstants.CourseCollection.SectionCollection.CollectionTitle).document(sectionID!)
        
        docRef.getDocument { (sectionDoc, error) in
            if error != nil {
                CompletionHandler(nil, false)
            }
            
            if let sectionDoc = sectionDoc, sectionDoc.exists {
                if let sectionData = sectionDoc.data() {
                    CompletionHandler(sectionData, true)
                }
            }
        }
        
    }
    
    // *********************************************************************************
    // function to if the section is online
    //  - CompletionHandler
    //      - online type
    //      - isOnline
    //      - isValid
    // *********************************************************************************
    func checkIfOnlineSectionByCourseBySection(courseTitle: String?, sectionID : String?, CompletionHandler: @escaping ([String]?, Bool?, Bool?) -> Void) {
        
        if courseTitle == nil {
            CompletionHandler(nil, false, false)
            return
        }
        // lower case the title
        let title = courseTitle?.lowercased()
        
        if sectionID == nil {
            CompletionHandler(nil, false, false)
            return
        }
        
        let db = Firestore.firestore()
        
        // get the referece of the document
        let docRef = db.collection(FirebaseConstants.CourseCollection.CollectionTitle).document(title!).collection(FirebaseConstants.CourseCollection.SectionCollection.CollectionTitle).document(sectionID!)
        
        // check if it is an online type
        docRef.getDocument { (sectionDoc, error) in
            if error != nil {
                CompletionHandler(nil, false, false)
                return
            }
            
            if let sectionDoc = sectionDoc, sectionDoc.exists {
                if let sectionData = sectionDoc.data() {
                    
                    // get the value of the room
                    let room = sectionData[FirebaseConstants.CourseCollection.SectionCollection.Room] as! String
                    // check if room is online
                    if  room == "online" {
                        //extract online type
                        
                    docRef.collection(FirebaseConstants.CourseCollection.SectionCollection.OnlineCollection.CollectionTitle).getDocuments { (querySnapshot, error) in
                            var onlineTypeList : [String] = []
                            for type in querySnapshot!.documents {
                                onlineTypeList.append(type.documentID)
                            }
                            CompletionHandler(onlineTypeList, true, true)
                            return
                        }

                        return
                    }
                    else{
                        CompletionHandler(nil, false, true)
                        return
                    }
                }
                
            }
        }
    }
    
    // *********************************************************************************
    // function to retrieve the section list by course title
    // *********************************************************************************
    func retrieveCourseInfoByCourseTitle(courseTitle: String?, CompletionHandler: @escaping (DocumentSnapshot?, [String]?, Bool?) -> Void) {
        
        if courseTitle == nil {
            CompletionHandler(nil, nil, false)
            return
        }
        
        // lower case the title
        let title = courseTitle?.lowercased()
        
        let db = Firestore.firestore()
        
        
        
        // get the reference of the document
        let docRef = db.collection(FirebaseConstants.CourseCollection.CollectionTitle).document(title!)
        
        
        // try to retrieve the document
        docRef.getDocument { (document, error) in
            
            // catch error
            if error != nil {
                print(error as Any)
                CompletionHandler(nil, nil, false)
            }
            // fetch data
            else{
                if let document = document, document.exists {
                    
                    // try to fetch section list
                    let sectionRef = docRef.collection(FirebaseConstants.CourseCollection.SectionCollection.CollectionTitle)
                    sectionRef.getDocuments { (sections, err) in
                        if err != nil {
                            CompletionHandler(nil, nil, false)
                        }
                        else{
                            var sectionList : [String] = []
                            for section in sections!.documents {
                                sectionList.append(section.documentID)
                            }
                            CompletionHandler(document, sectionList, true)
                        }
                    }
                    
                }
                else{
                    print("FirebaseManager - func retrieveCourseInfoByCourseTitle() - course not exist")
                    CompletionHandler(nil, nil, false)
                    return
                }
            }
        }
    }
    
    // *********************************************************************************
    // function to convert weekdays patter into weekdays list
    // *********************************************************************************
    func convertWeekdayPatternIntoList(pattern: String) -> [String]{
        var rtnList:[String] = []
        return rtnList
    }
}
