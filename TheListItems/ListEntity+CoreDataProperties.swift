//
//  ListEntity+CoreDataProperties.swift
//  TheList
//
//  Created by Eva Sira Madarasz on 20/03/2022.
//
//

import Foundation
import CoreData


extension ListEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ListEntity> {
        return NSFetchRequest<ListEntity>(entityName: "ListEntity")
    }

    @NSManaged public var title: String?
    @NSManaged public var isCompleted: Bool
    @NSManaged public var creationDate: Date?
    @NSManaged public var achievedDate: Date?

}

extension ListEntity : Identifiable {

}
