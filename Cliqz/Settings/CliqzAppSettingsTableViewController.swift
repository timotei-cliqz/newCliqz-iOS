//
//  CliqzAppSettingsTableViewController.swift
//  Client
//
//  Created by Mahmoud Adam on 3/13/18.
//  Copyright © 2018 Cliqz. All rights reserved.
//

import UIKit
import Shared

class CliqzAppSettingsTableViewController: AppSettingsTableViewController {

    override func generateSettings() -> [SettingSection] {
        var settings = [SettingSection]()
        let prefs = profile.prefs
        
        #if GHOSTERY
        // Connect is not available in Ghostery
        #elseif PAID
        // Connect is not available in Paid Product
        #else
        // Connect
        let conenctSettings = [CliqzConnectSetting(settings: self)]
        let connectSettingsTitle = NSLocalizedString("Connect", tableName: "Cliqz", comment: "[Settings] Connect section title")
        let connectSettingsFooter = NSLocalizedString("Connect Cliqz on your computer with Cliqz on your iOS device. This will allow you to send tabs from your desktop to your mobile device. You can also directly download videos from your desktop browser to your mobile device.", tableName: "Cliqz", comment: "[Settings] Connect section footer")
        settings += [ SettingSection(title: NSAttributedString(string: connectSettingsTitle), footerTitle: NSAttributedString(string: connectSettingsFooter), children: conenctSettings)]
        #endif
		
		// Account Settings
		#if PAID
		let accountSettings = generateAccountSettings(prefs: prefs)
		let accountSettingsTitle = NSLocalizedString("Lumen Account", tableName: "Cliqz" , comment: "[Settings] Account")
//NSLocalizedString("", tableName: "Cliqz", comment: "[Settings] TBD")
		settings += [SettingSection(title: NSAttributedString(string: accountSettingsTitle), children: accountSettings)]
		#endif
        // Search Settings
        let searchSettings = generateSearchSettings(prefs: prefs)
        let searchSettingsTitle = NSLocalizedString("Search", tableName: "Cliqz", comment: "[Settings] Search section title")
        settings += [ SettingSection(title: NSAttributedString(string: searchSettingsTitle), children: searchSettings)]
        
        // Cliqz Tab Settings
        let cliqzTabSettings = generateCliqzTabSettings(prefs: prefs)
        let cliqzTabTitle = NSLocalizedString("Fresh Tab", tableName: "Cliqz", comment: "[Settings] Freshtab section header")
        settings += [ SettingSection(title: NSAttributedString(string: cliqzTabTitle), children: cliqzTabSettings)]
        
        
        // Browsing & History Settings
        let browsingAndHistorySettings = generateBrowsingAndHistorySettings(prefs: prefs)
        let browsingAndHistoryTitle = NSLocalizedString("Browsing & History", tableName: "Cliqz", comment: "[Settings] Browsing & History section header")
        settings += [ SettingSection(title: NSAttributedString(string: browsingAndHistoryTitle), children: browsingAndHistorySettings)]
        
        // Privacy Settings
        let privacyTitle = NSLocalizedString("Privacy", tableName: "Cliqz", comment: "[Settings] Privacy section header")
        let privacySettings = generatePrivacySettings(prefs: prefs)
        settings += [ SettingSection(title: NSAttributedString(string: privacyTitle), children: privacySettings)]

        // Help Settings
        let helpTitle = NSLocalizedString("Help", tableName: "Cliqz", comment: "[Settings] Help section header")
        let helpSettings = generateHelpSettings(prefs: prefs)
        settings += [ SettingSection(title: NSAttributedString(string: helpTitle), children: helpSettings)]

        
        // About Settings
        let aboutTitle = NSLocalizedString("About", tableName: "Cliqz", comment: "[Settings] About section header")
        let aboutSettings = generateAboutSettings(prefs: prefs)
        settings += [ SettingSection(title: NSAttributedString(string: aboutTitle), children: aboutSettings)]

        return settings
    }

    
    // MARK:- Helper methods
    private func generateSearchSettings(prefs: Prefs) -> [Setting] {
        
        let complementarySearchSetting = ComplementarySearchSetting(settings: self)
        #if PAID
        return [complementarySearchSetting]
        #else
        let blockExplicitContentTitle = NSLocalizedString("Block Explicit Content", tableName: "Cliqz", comment: "[Settings] Block explicit content")
        let blockExplicitContentSettings = BoolSetting(prefs: prefs,
                                                       prefKey: SettingsPrefs.BlockExplicitContentPrefKey,
                                                       defaultValue: SettingsPrefs.shared.getBlockExplicitContentPref(),
                                                       titleText: blockExplicitContentTitle)
        
        let humanWebSetting = HumanWebSetting(settings: self)
        
        
        let regionalSetting = RegionalSetting(settings: self)
        let querySuggestionTitle = NSLocalizedString("Search Query Suggestions", tableName: "Cliqz", comment: "[Settings] Search Query Suggestions")
        let querySuggestionSettings = BoolSetting(prefs: prefs,
                                                  prefKey: SettingsPrefs.querySuggestionPrefKey,
                                                  defaultValue: SettingsPrefs.shared.getQuerySuggestionPref(),
                                                  titleText: querySuggestionTitle)
        let cliqzSearchTitle = NSLocalizedString("Quick Search", tableName: "Cliqz", comment: "[Settings] Quick Search")
        let cliqzSearchSetting = BoolSetting(prefs: prefs, prefKey: SettingsPrefs.CliqzSearchPrefKey, defaultValue: true, titleText: cliqzSearchTitle)
        
        if QuerySuggestions.querySuggestionEnabledForCurrentRegion() {
            return [regionalSetting, querySuggestionSettings, blockExplicitContentSettings, humanWebSetting, cliqzSearchSetting, complementarySearchSetting]
        }
        return [regionalSetting, blockExplicitContentSettings, humanWebSetting, cliqzSearchSetting, complementarySearchSetting]
        
        #endif
    }
    
    private func generateCliqzTabSettings(prefs: Prefs) -> [Setting] {
        
        let showTopSitesTitle = NSLocalizedString("Show most visited websites", tableName: "Cliqz", comment: "[Settings] Show most visited websites")
        let showTopSitesSetting = BoolSetting(prefs: prefs, prefKey: SettingsPrefs.ShowTopSitesPrefKey, defaultValue: true, titleText: showTopSitesTitle)
        #if PAID
        return [showTopSitesSetting]
        #else
        let showNewsTitle = NSLocalizedString("Show News", tableName: "Cliqz", comment: "[Settings] Show News")
        let showNewsSetting = BoolSetting(prefs: prefs, prefKey: SettingsPrefs.ShowNewsPrefKey, defaultValue: true, titleText: showNewsTitle)
        return [showTopSitesSetting, showNewsSetting]
        #endif
    }
    
    private func generateBrowsingAndHistorySettings(prefs: Prefs) -> [Setting] {
        var browsingAndHistorySettings: [Setting] = [
            BoolSetting(prefs: prefs, prefKey: "blockPopups", defaultValue: true,
                        titleText: NSLocalizedString("Block Pop-up Windows", comment: "Block pop-up windows setting")),
            BoolSetting(prefs: prefs, prefKey: "saveLogins", defaultValue: true,
                        titleText: NSLocalizedString("Save Logins", comment: "Setting to enable the built-in password manager")),
            LimitMobileDataUsageSetting(settings: self)
            ]
        
        let statusText = NSLocalizedString("When Opening Ghostery", tableName: "Cliqz", comment: "Description displayed under the ”Offer to Open Copied Link” option.")
        browsingAndHistorySettings += [
            BoolSetting(prefs: prefs, prefKey: "showClipboardBar", defaultValue: false,
                        titleText: Strings.SettingsOfferClipboardBarTitle,
                        statusText: statusText)
        ]
        
        return browsingAndHistorySettings
    }
    
    private func generatePrivacySettings(prefs: Prefs) -> [Setting] {
        #if PAID
            let statusText = NSLocalizedString("When Leaving Private Mode", tableName: "Lumen", comment: "Will be displayed in Settings under 'Close Private Tabs'")
            let titleText = NSLocalizedString("Close Private Tabs", tableName: "Lumen", comment: "Setting for closing private tabs")
        #else
            let statusText = NSLocalizedString("When Leaving Forget Mode", tableName: "Ghostery", comment: "Will be displayed in Settings under 'Close Forget Tabs'")
            let titleText = NSLocalizedString("Close Forget Tabs", tableName: "Ghostery", comment: "Setting for closing forget tabs")
        #endif
        
        let privacySettings = [ LoginsSetting(settings: self, delegate: settingsDelegate),
                                TouchIDPasscodeSetting(settings: self),
                                // Hide AutoForgetTab Settings as it is not implemented yet
                                // AutoForgetTabSetting(settings: self),
                                BoolSetting(prefs: prefs,
                                            prefKey: "settings.closePrivateTabs",
                                            defaultValue: false,
                                            titleText: titleText,
                                            statusText: statusText),
                                ClearPrivateDataSetting(settings: self),
                                RestoreTopSitesSetting(settings: self)]
        
        return privacySettings
    }

    private func generateHelpSettings(prefs: Prefs) -> [Setting] {
        #if PAID
//            let lumenThemeSetting = BoolSetting(prefs: prefs,
//                                                prefKey: lumenThemeKey,
//                                                defaultValue: true,
//                                                titleText: NSLocalizedString("Dark Theme", tableName: "Lumen", comment: "[Settings] Dark Theme"),
//                                                settingDidChange: { newValue in
//                                                    NotificationCenter.default.post(name: .themeChanged, object: nil)
//                                                })
        
            let helpSettings = [
                FAQSetting(delegate: settingsDelegate),
                SupportSetting(delegate: settingsDelegate),
                //CliqzTipsAndTricksSetting(),
                //ReportWebsiteSetting(),
                SendCrashReportsSetting(settings: self),
                SendUsageDataSetting(settings: self),
//                lumenThemeSetting
            ]
        #else
            let helpSettings = [
                FAQSetting(delegate: settingsDelegate),
                SupportSetting(delegate: settingsDelegate),
                //CliqzTipsAndTricksSetting(),
                //ReportWebsiteSetting(),
                SendCrashReportsSetting(settings: self),
                SendUsageDataSetting(settings: self),
                MyOffrzSetting()
            ]
        #endif
        
        return helpSettings
    }
    
    private func generateAboutSettings(prefs: Prefs) -> [Setting] {
        
        return [RateUsSetting(), AboutSetting()]
    }
	
	#if PAID
	private func generateAccountSettings(prefs: Prefs) -> [Setting] {
		return [LumenAccountSetting()]
	}
	#endif
}
