//
//  RefreshableViewProtocol.swift
//  Random Restaurant
//
//  Created by Jaren Hamblin on 2/7/16.
//  Copyright © 2016 JHamblin. All rights reserved.
//

import Foundation

protocol RefreshableViewDelegate {
    func configureView()
    func updateView()
}