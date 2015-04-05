//
//  RecordedAudio.swift
//  Pitch-Perfect
//
//  Created by Derrick Price on 3/22/15.
//  Copyright (c) 2015 Derrick Price. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject
{
    init (filepath: NSURL!, filetitle: String!)
    {
        self.filePathURL = filepath;
        self.title = filetitle;
    }
    var filePathURL: NSURL!
    var title:String!
}