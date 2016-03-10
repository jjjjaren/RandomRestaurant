//
//  CetegoryManager.swift
//  Random Restaurant
//
//  Created by Jaren Hamblin on 2/10/16.
//  Copyright © 2016 JHamblin. All rights reserved.
//

import Foundation

class CategoryManager: Manager {

    func getAllCategories() -> [Category] {
        return fetch(Category.entityName, sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)]) as? [Category] ?? [Category]()
    }

    func addCategory(withName name: String) -> Category? {
        let c = Category(context: context)
        c.uuid = NSUUID().UUIDString
        c.name = name
        c.createDate = NSDate()
        do {
            try c.validateForInsert()
            try context.save()
            return c
        } catch let e as NSError {
            log.error(e.userInfo)
            context.deleteObject(c)
            return nil
        }
    }

    func deleteCategory(category: Category) -> Bool {
        do {
            // try category.validateForDelete()
            context.deleteObject(category)
            try context.save()
            return true
        } catch let e as NSError {
            log.error(e.userInfo)
            return false
        }
    }

    func deleteCategory(withName name: String) -> Bool {
        guard let category = fetch(Category.entityName, predicate: NSPredicate(format: "name = %@", name), limit: 1).first as? Category else {
            return false
        }
        return deleteCategory(category)
    }

    func deleteAllCategories() -> Bool {
        let entities = fetch(Category.entityName)
        guard entities.count > 0 else {
            return true
        }
        guard let categories = entities as? [Category] else {
            return false
        }
        let names = categories.map { category -> String in
            return category.name
        }
        for name in names {
            if !deleteCategory(withName: name) {
                return false
            }
        }
        return true
    }
}