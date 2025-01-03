//
//  File.swift
//  swift-sdk
//
//  Created by Ravi Ranjan  Ojha on 30/12/24.
//

import Foundation

@MainActor
class EventsManager {
    static let shared = EventsManager()
    private init() {}
    
    private func track(eventName: String, data: [String: Any]) {
        var payload = data
        payload["pagepath"] = Global.shared.quinn?.pageHandle?.lowercased()
        payload["pagetype"] = Global.shared.quinn?.pageType?.lowercased()
        
        print(payload)
        
        Task {
//            await RequestManager.shared.sendEvent(eventName: "quinn_\(eventName)", payload: payload)
        }
    }
    
    func pageViewed() {
        track(eventName: "events_page_view", data: [:])
    }
    
    func productViewed(playlistId: String, mediaId: String, widgetType: WidgetType, activeIndex: Int, groupMediaIndex: Int, produdctId: String, productHandle: String, variantId: String) {
        
        track(eventName: "events_product_view", data: [
            "productid": produdctId,
            "handle": productHandle,
            "variantid": variantId,
            "playlistid": playlistId,
            "mediaid": mediaId,
            "widgettype": widgetType,
            "data": [
                "index": activeIndex,
                "subindex": groupMediaIndex
            ]
        ])
    }
    
    func widgetOverlayOpened(playlistId: String, mediaId: String, widgetType: WidgetType, activeIndex: Int, groupMediaIndex: Int, produdctId: String, productHandle: String, variantId: String) {        
        track(eventName: "events_overlay_open", data: [
            "playlistid": playlistId,
            "mediaid": mediaId,
            "widgettype": widgetType,
            "productid": produdctId,
            "handle": productHandle,
            "variantid": variantId,
            "data": [
                "loadtime": 0,
                "index": activeIndex,
                "subindex": groupMediaIndex
            ]
        ])
    }
    
    func widgetOverlayClosed(playlistId: String, widgetType: WidgetType, totalTime: String) {
        track(eventName: "events_overlay_close", data: [
            "playlistid": playlistId,
            "widgettype": widgetType,
            "data": [
                "totaltime": totalTime
            ]
        ])
    }
    
    func widgetOverlaySwiped(playlistId: String, mediaId: String, widgetType: WidgetType, activeIndex: Int, groupMediaIndex: Int,  watchDuration: Double, direction: String, videoDuration: Double?) {
        track(eventName: "events_overlay_swipe", data: [
            "playlistid": playlistId,
            "mediaid": mediaId,
            "widgettype": widgetType,
            "type": direction,
            "data": [
                "watchduration": watchDuration,
                "videoduration": videoDuration.map { $0 + 0.00001 } ?? 0,
                "index": activeIndex,
                "subindex": groupMediaIndex
            ]
        ])
    }
    
    func customActionTriggered(playlistId: String, mediaId: String, widgetType: WidgetType, groupId: String, action: String, name: String, value: String, produdctId: String, productHandle: String, variantId: String) {
        track(eventName: "events_custom_action", data: [
            "playlistid": playlistId,
            "mediaid": mediaId,
            "widgettype": widgetType,
            "mediagroupid": groupId,
            "action": action,
            "name": name,
            "value": value,
            "productid": produdctId,
            "handle": productHandle,
            "variantid": variantId
        ])
    }
    
    func systemActionEvent(playlistId: String, mediaId: String, widgetType: WidgetType, groupId: String, action: String, name: String, value: String, produdctId: String, productHandle: String, variantId: String) {
        track(eventName: "events_system_action", data: [
            "playlistid": playlistId,
            "mediaid": mediaId,
            "widgettype": widgetType,
            "mediagroupid": groupId,
            "action": action,
            "name": name,
            "value": value,
            "productid": produdctId,
            "handle": productHandle,
            "variantid": variantId
        ])
    }
    
    func ctaClicked(playlistId: String, mediaId: String, widgetType: WidgetType,ctaTitle: String, ctaLink: String, index: Int, subIndex: Int) {
        track(eventName: "events_cta_clicked", data: [
            "playlistid": playlistId,
            "mediaid": mediaId,
            "widgettype": widgetType,
            "ctatitle": ctaTitle,
            "ctalink": ctaLink,
            "index": index,
            "subindex": subIndex
        ])
    }
    
    func viewCountEvent(playlistId: String, mediaId: String, widgetType: WidgetType, groupId: String) {
        track(eventName: "events_5secview", data: [
            "playlistid": playlistId,
            "mediaid": mediaId,
            "widgettype": widgetType,
            "mediagroupid": groupId
        ])
    }
    
    func addToCart(productId: String, variantId: String, productPrice: String, sendWithoutCheck: Bool = false) async {
        if !sendWithoutCheck {
            let shouldSend = shouldAddPropertiesToATC(productId: productId, variantId: variantId)
            if !shouldSend { return }
        }
        
        track(eventName: "events_add_to_cart", data: [
            "productid": productId,
            "data": [
                "productquantity": 1,
                "productprice": productPrice
            ]
        ])
    }
    
    func externalCustomer(customerId: String) {
        track(eventName: "events_external_customer", data: [
            "customerid": customerId
        ])
    }
}
