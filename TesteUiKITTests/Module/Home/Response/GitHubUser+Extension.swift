//
//  GitHubUser+Extension.swift
//  TesteUiKITTests
//
//  Created by Thiago Santos on 16/05/25.
//

import Foundation
@testable import TesteUiKIT

extension GitHubUser {
    
    static func fixture(login: String = "",
                        id: Int = .zero,
                        nodeID: String = "",
                        avatarURL: String = "",
                        gravatarID: String = "",
                        url: String = "",
                        htmlURL: String = "",
                        followersURL: String = "",
                        followingURL: String = "",
                        gistsURL: String = "",
                        starredURL: String = "",
                        subscriptionsURL: String = "",
                        organizationsURL: String = "",
                        reposURL: String = "",
                        eventsURL: String = "",
                        receivedEventsURL: String = "",
                        type: String = "",
                        userViewType: String = "",
                        siteAdmin: Bool = false) -> Self {
        
        .init(login: login,
                   id: id,
                   nodeID: nodeID,
                   avatarURL: avatarURL,
                   gravatarID: gravatarID,
                   url: url,
                   htmlURL: htmlURL,
                   followersURL: followersURL,
                   followingURL: followingURL,
                   gistsURL: gistsURL,
                   starredURL: starredURL,
                   subscriptionsURL: subscriptionsURL,
                   organizationsURL: organizationsURL,
                   reposURL: reposURL,
                   eventsURL: eventsURL,
                   receivedEventsURL: receivedEventsURL,
                   type: type,
                   userViewType: userViewType,
                   siteAdmin: siteAdmin)
    }
}
