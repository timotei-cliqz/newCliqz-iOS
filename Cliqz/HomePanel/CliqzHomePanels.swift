//
//  CliqzHomePanels.swift
//  Client
//
//  Created by Tim Palade on 5/3/18.
//  Copyright © 2018 Cliqz. All rights reserved.
//

import UIKit

class CliqzHomePanels {

    let topSitesPanel = HomePanelDescriptor(
                        makeViewController: { profile in
                                                return FreshtabViewController(profile: profile)
                                            },
                        imageName: "panelIconFreshtab",
                        accessibilityLabel: NSLocalizedString("Top sites", comment: "Panel accessibility label"),
                        accessibilityIdentifier: "HomePanels.TopSites")
    
    let historyPanel =  HomePanelDescriptor(
                        makeViewController: { profile in
                            let history = CliqzHistoryPanel()
                            history.profile = profile
                            let controller = UINavigationController(rootViewController: history)
                            controller.setNavigationBarHidden(true, animated: false)
                            controller.interactivePopGestureRecognizer?.delegate = nil
                            return controller
                        },
                        imageName: "panelIconCliqzHistory",
                        accessibilityLabel: NSLocalizedString("History", comment: "Panel accessibility label"),
                        accessibilityIdentifier: "HomePanels.History")
    
    #if PAID
    let VPNPanel =  HomePanelDescriptor(
                        makeViewController: { profile in
                            let controller = UINavigationController(rootViewController: VPNViewController())
                            controller.setNavigationBarHidden(true, animated: false)
                            controller.interactivePopGestureRecognizer?.delegate = nil
                            return controller
                        },
                        imageName: "panelVPN",
                        accessibilityLabel: NSLocalizedString("VPN", comment: "Panel accessibility label"),
                        accessibilityIdentifier: "HomePanels.VPN")
    #endif

    let offrzPanel = HomePanelDescriptor(
                        makeViewController: { profile in
                            let controller = OffrzViewController(dataSource: OffrzDataSource.shared)
                            return controller
                        },
                        imageName: "panelIconOffrz",
                        accessibilityLabel: NSLocalizedString("Reading list", comment: "Panel accessibility label"),
                        accessibilityIdentifier: "HomePanels.ReadingList")
    
    
    let favoritePanel = HomePanelDescriptor(
                        makeViewController: { profile in
                            let bookmarks = CliqzBookmarksPanel()
                            bookmarks.profile = profile
                            let controller = UINavigationController(rootViewController: bookmarks)
                            controller.setNavigationBarHidden(true, animated: false)
                            // this re-enables the native swipe to pop gesture on UINavigationController for embedded, navigation bar-less UINavigationControllers
                            // don't ask me why it works though, I've tried to find an answer but can't.
                            // found here, along with many other places:
                            // http://luugiathuy.com/2013/11/ios7-interactivepopgesturerecognizer-for-uinavigationcontroller-with-hidden-navigation-bar/
                            controller.interactivePopGestureRecognizer?.delegate = nil
                            return controller
                        },
                        imageName: "panelIconFavorite",
                        accessibilityLabel: NSLocalizedString("Bookmarks", comment: "Panel accessibility label"),
                        accessibilityIdentifier: "HomePanels.Bookmarks")
    
    
    func getEnabledPanels() -> [HomePanelDescriptor] {
        #if PAID
            return [topSitesPanel, VPNPanel , historyPanel, favoritePanel]
        #else
            return [topSitesPanel, historyPanel, offrzPanel, favoritePanel]
        #endif
    }
    
    
}
