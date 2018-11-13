//
//  WPSocketRocketUtility.h
//  WebSocketDemo
//
//  Created by dengqi on 2018/5/7.
//  Copyright © 2018年 newbike. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SocketRocket/SocketRocket.h>


extern NSString * const KWPWebSocketURL;

@protocol WPSocketRocketUtilityDelegate <NSObject>

@optional

/**
 成功连接的代理方法
 */
-(void)wp_webSocketConnectionSuccess;

/**
 连接失败 或者断开连接 不用管断开去重连 已经做好了
 @param error 错误
 */
-(void)wp_webSocketConnectionFailWithError:(NSError *)error;

/**
 保持连接 接收到服务器的数据 一般不需要
 @param pongPayload 接收的数据
 */
-(void)wp_webSocketDidReceivePong:(NSData *)pongPayload;

@required
/**
 接收到服务器发送的数据
 @param message 内容
 */
-(void)wp_webSocketDidReceiveMessage:(id)message;

@end

@interface WPSocketRocketUtility : NSObject

/**
 socke的URL
 */
@property (nonatomic, strong) NSString *socketUrl;
/**
 获取连接状态
 */
@property (nonatomic,assign,readonly) SRReadyState socketReadyState;

/**
 代理 暂时不可用
 */
@property (nonatomic,weak) id <WPSocketRocketUtilityDelegate> WPDelegate;

/**
 WebScoket的单列的创建方法

 @return WPSocketRocketUtility
 */
+ (WPSocketRocketUtility *)instance;

/**
 开始建立连接
 */
-(void)WP_WebSocketStartConnections;

/**
 根据链接 开始与服务器进行连接
 @param urlStr 需要连接的url 这里的url的格式是 ws://manage.cp138666.info:8080/websocket/UUID
 */
-(void)WP_WebSocketOpenWithURLStrig:(NSString *)urlStr;

/**
 关闭连接
 */
-(void)WP_WebSocketClose;

/**
 发送数据 这里内容有做重连的机制 外部不需要管是否需要重连 只管发送和接收数据
 @param data 需要发送的数据
 */
-(void)WP_WebSocketSendData:(id)data;

/**
 获取设备的UUID

 @return UUID字符串
 */
-(NSString *)WP_GetDeviceUUIDStr;

@end
