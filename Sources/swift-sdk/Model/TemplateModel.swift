//
//  File 4.swift
//  swift-sdk
//
//  Created by Ravi Ranjan  Ojha on 09/12/24.
//

import Foundation

struct Templates: Codable {
    let overlayCarouselDesktop: Template?
    let overlayCarouselMobile: Template?
    let overlayDesktop: Template?
    let overlayMobile: Template?
    let cardDesktop: Template?
    let cardMobile: Template?
    let cardCarouselDesktop: Template?
    let cardCarouselMobile: Template?
    let storyDesktop: Template?
    let bubbleMobile: Template?
    let storyCarouselDesktop: Template?
    let bubbleDesktop: Template?
    let storyCarouselMobile: Template?
    let storyMobile: Template?
    let floatingCarouselDesktop: Template?
    let floatingCarouselMobile: Template?
    let imaxVideoMobile: Template?
    let imaxVideoDesktop: Template?
    
    enum CodingKeys: String, CodingKey {
        case overlayCarouselDesktop = "OVERLAY_CAROUSEL_DESKTOP"
        case overlayCarouselMobile = "OVERLAY_CAROUSEL_MOBILE"
        case overlayDesktop = "OVERLAY_DESKTOP"
        case overlayMobile = "OVERLAY_MOBILE"
        case cardDesktop = "CARD_DESKTOP"
        case cardMobile = "CARD_MOBILE"
        case cardCarouselDesktop = "CARD_CAROUSEL_DESKTOP"
        case cardCarouselMobile = "CARD_CAROUSEL_MOBILE"
        case storyDesktop = "STORY_DESKTOP"
        case bubbleMobile = "BUBBLE_MOBILE"
        case storyCarouselDesktop = "STORY_CAROUSEL_DESKTOP"
        case bubbleDesktop = "BUBBLE_DESKTOP"
        case storyCarouselMobile = "STORY_CAROUSEL_MOBILE"
        case storyMobile = "STORY_MOBILE"
        case floatingCarouselDesktop = "FLOATING_CAROUSEL_DESKTOP"
        case floatingCarouselMobile = "FLOATING_CAROUSEL_MOBILE"
        case imaxVideoMobile = "IMAX_VIDEO_MOBILE"
        case imaxVideoDesktop = "IMAX_VIDEO_DESKTOP"
    }
}

struct Template: Codable {
    let dimensions: TemplateDimensions
    let templateCss: String
    let templateHtml: String
}

struct TemplateDimensions: Codable {
    let width: String
    let height: String
}
