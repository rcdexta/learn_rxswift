//
//  IssueEntity.swift
//  LearnRxSwift
//
//  Created by RC on 19/05/16.
//  Copyright © 2016 com.rcdexta. All rights reserved.
//

import Mapper

struct Issue: Mappable {

    let identifier: Int
    let number: Int
    let title: String
    let body: String

    init(map: Mapper) throws {
        try identifier = map.from("id")
        try number = map.from("number")
        try title = map.from("title")
        try body = map.from("body")
    }
}
