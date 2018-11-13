//
//  WPSocketRocketUtility.m
//  WebSocketDemo
//
//  Created by dengqi on 2018/5/7.
//  Copyright © 2018年 newbike. All rights reserved.
//

#import "WPSocketRocketUtility.h"
#import <UIKit/UIKit.h>
#import "DQHeader.h"

NSString * const KWPWebSocketURL = @"https://socket.";//现在已经废用了

typedef NS_OPTIONS(NSUInteger, WPSendMessageStatus) {
    
    WPSenderStatusStarNOSend, //不去发送 相当消息不用发送
   
    WPSenderStatusStarSend,   //开始发送消息
    
    WPSenderStatusSendSuccess,//开始发送成功
    
    WPSenderStatusSendfail    //开始发送是吧
    
};

@interface WPSocketRocketUtility()<SRWebSocketDelegate> {
    
    int _index;
    
//    NSTimer * heartBeat;
    
    NSTimeInterval reConnectTime;
}

@property (nonatomic,strong) NSTimer * heartBeat;
/**
 socket
 */
@property (nonatomic,strong) SRWebSocket *socket;

/**
 socket链接的Url
 */
@property (nonatomic,copy) NSString *urlString;

/**
 消息发送的状态
 */
@property (nonatomic,assign) WPSendMessageStatus messageSendStatus;

/**
 需要发送消息内容
 */
@property (nonatomic,copy) id messageData;

/**
 网络状态
 */
@property (nonatomic,assign) BOOL netWorkStatus;

/**
 网络状态
 */
@property (nonatomic,assign) BOOL isManualclose;

@property (nonatomic,assign) NSInteger timeInt;//时间次数

@property (nonatomic,assign) BOOL isCanSendPing;//是否可以发送心跳包

@property (nonatomic,assign) BOOL isSuccessLink;//是否成功连接
@end

@implementation WPSocketRocketUtility

/**
 socket的类型
 
 @return socket 的类型
 */
- (SRReadyState)socketReadyState{
    return self.socket.readyState;
}

/**
 本类的创建方法
 
 @return self
 */
-(instancetype)init {
    
    self = [super init];
    
    if (self) {
        
        [self setBaseDataFunction];
        
        [self addNotificationFunction];
        self.isManualclose = NO;
        self.timeInt = 0;
        self.isCanSendPing = NO;
        self.isSuccessLink = NO;
        
    }
    return self;
}

/**
 获取网络变化的方式
 */
-(void)setBaseDataFunction {
    
//    self.netWorkStatus = NetWorkOcTool.wp_getNetWorkStatus;
}

/**
 注册通知的方法
 */
-(void)addNotificationFunction {
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(acceptNetWorkNotification:)
//                                                 name:kNetworkMonitor_Noti
//                                               object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wp_timeChangeFunction) name:WPGameNSTimerFlashingNotificationName object:nil];
}

/**
 网络变化 实现的方法
 */
-(void)acceptNetWorkNotification:(NSNotification *)notification {
    
    BOOL state = [notification object];
    
    if (state == YES) {
        self.netWorkStatus = YES;
    } else {
        self.netWorkStatus = NO;
    }
    
    reConnectTime = 0;
    
    [self reconnectionConnet];
}

/**
 */
+ (WPSocketRocketUtility *)instance {
    
    static WPSocketRocketUtility *instance = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        instance = [WPSocketRocketUtility new];
    });
    
    return instance;
}

/**
 开始建立连接
 */
-(void)WP_WebSocketStartConnections {
//    NSString *strPrefix  = @"https://";
//    NSString *fromStr = [NC_Host substringFromIndex:strPrefix.length];
    if (self.socketUrl) {
        NSString *urlUuidStr = [NSString stringWithFormat:@"%@%@",self.socketUrl,self.WP_GetDeviceUUIDStr];
        [self WP_WebSocketOpenWithURLStrig:urlUuidStr];
    }
   
}

/**
 根据链接 开始与服务器进行连接
 @param urlStr 需要连接的url 这里的url的格式是 ws://manage.cp138666.info:8080/websocket/UUID
 */
-(void)WP_WebSocketOpenWithURLStrig:(NSString *)urlStr {
    
    if (self.socket) {
        [self reconnectionConnet];
        return;//防止同一个URl 被多次连接
    }
    
    if (!urlStr) {
        return;//urlStr为空 也返回
    }
    if (!self.urlString) {
        return;
    }
    self.urlString = urlStr;
    
    NSURL *Url = [NSURL URLWithString:urlStr];
    
    if (!Url) {
        return;//当url为非法的url也返回
    }
    NSString *schemeStr = Url.scheme.lowercaseString;
    if (!schemeStr) {
        return;
    }
    if ([schemeStr isEqualToString:@"ws"] || [schemeStr isEqualToString:@"http"] || [schemeStr isEqualToString:@"wss"] || [schemeStr isEqualToString:@"https"]) {
         NSLog(@"请求的websocket地址：%@",self.socket.url.absoluteString);
        self.socket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:Url]];
        
        self.socket.delegate = self;//SRWebSocketDelegate 协议
        self.isManualclose = NO;
        [self.socket open];//开始连接
        
        if (!self.messageData) {
            self.messageSendStatus = WPSenderStatusStarNOSend;//默认不需要发送消息
        }
    }
}

/**
 发送数据 这里内容有做重连的机制 外部不需要管是否需要重连 只管发送和接收数据
 @param data 需要发送的数据
 */
-(void)WP_WebSocketSendData:(id)data {
    
    self.messageSendStatus = WPSenderStatusStarSend;
    if ([data isKindOfClass:[NSString class]]) {
        self.messageData = data;
    } else if ([data isKindOfClass:[NSDictionary class]]) {
        NSData *dataJson = [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:nil];
        NSString *JsonStr = [[NSString alloc] initWithData:dataJson encoding:NSUTF8StringEncoding];
        self.messageData = JsonStr;
    } else if ([data isKindOfClass:[NSArray class]]) {
        NSData *dataJson = [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:nil];
        NSString *JsonStr = [[NSString alloc] initWithData:dataJson encoding:NSUTF8StringEncoding];
        self.messageData = JsonStr;
    } else {
        return;
    }
    
    NSLog(@"socketSendData --------------- %@",data);
    
    __weak __typeof(self) weakSelf = self;
    
    dispatch_queue_t queue = dispatch_queue_create("dq", NULL);
    
    dispatch_async(queue, ^{
        
        if (self.netWorkStatus == YES) {//这里要考虑网络的问题
            
            if (weakSelf.socket.readyState == SR_OPEN) {
                
                [weakSelf.socket send:self.messageData];
                
                weakSelf.messageSendStatus = WPSenderStatusSendSuccess;
                
                self.messageData = nil;
                
            } else if (weakSelf.socket.readyState == SR_CONNECTING) {
                
                [self reconnectionConnet];
                
            } else if (weakSelf.socket.readyState == SR_CLOSING ||
                       weakSelf.socket.readyState == SR_CLOSED)
            {
                //socket的断开了 socket重连
                [self reconnectionConnet];
                
            } else {
                
                //将消息不发生 改情况很小发生
                weakSelf.messageSendStatus = WPSenderStatusSendfail;
                
                self.messageData = nil;
            }
        } else {
            
            //网络不好不做处理
            NSLog(@"网络不好");
        }
    });
}

/**
 重连机制
 */
-(void)reconnectionConnet
{
    [self WP_WebSocketClose];
    
    if (self.netWorkStatus==NO) {
        return;
    }
    
    if (reConnectTime > 64) {
        
        return; //超过一分钟就相当于 重连失败发送的信息失败
    }
    if (self.socket.readyState == SR_OPEN) {//已经连接成功的 不需要去重连
        return;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(reConnectTime * NSEC_PER_SEC)), dispatch_get_main_queue(),^{
        self.socket = nil;
        [self WP_WebSocketOpenWithURLStrig:self.urlString];
    });
    
    if (reConnectTime == 0) {
        reConnectTime = 2;
    }else {
        reConnectTime *= 2;
    }
}

/**
 关闭场链接
 */
-(void)WP_WebSocketClose {
    
    if (self.socket) {
        self.isManualclose = YES;
        [self.socket close];
        
//        [self destoryHeartBeat];
        self.isCanSendPing = NO;
    }
}

/**
 发送心跳包
 */
-(void)sentHeart{
    [self WP_WebSocketSendData:@"1"];
}

#pragma mark -socket delegate
-(void)webSocketDidOpen:(SRWebSocket *)webSocket {
    reConnectTime = 0;
    self.isSuccessLink = YES;
    //开启心跳
//    [self initHeartBeat];
    self.isCanSendPing = YES;
    if (webSocket == self.socket) {
        NSLog(@"************************** socket 连接成功************************** ");
        if (self.messageData && self.messageSendStatus == WPSenderStatusStarSend) {
            [self WP_WebSocketSendData:self.messageData];
        }
        if ([self.WPDelegate respondsToSelector:@selector(wp_webSocketConnectionSuccess)]) {
            [self.WPDelegate wp_webSocketConnectionSuccess];
        }
    }
}
-(void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
    if (webSocket == self.socket) {
        //连接失败重连
        self.isCanSendPing = NO;
        self.isSuccessLink = NO;
        [self reconnectionConnet];
        if ([self.WPDelegate respondsToSelector:@selector(wp_webSocketConnectionFailWithError:)]) {
            [self.WPDelegate wp_webSocketConnectionFailWithError:error];
        }
    }
}

-(void)webSocket:(SRWebSocket *)webSocket
didCloseWithCode:(NSInteger)code
          reason:(NSString *)reason
        wasClean:(BOOL)wasClean {
    self.isSuccessLink = NO;
    if (webSocket == self.socket) {
        NSLog(@"************************** socket被断开连接************************** ");
        if ( self.isManualclose == YES) {//手动关闭
            [self WP_WebSocketClose];
        } else {//否则就去重连
            [self reconnectionConnet];
        }
    }
}

/*该函数是接收服务器发送的pong消息，其中最后一个是接受pong消息的，
 在这里就要提一下心跳包，一般情况下建立长连接都会建立一个心跳包，
 用于每隔一段时间通知一次服务端，客户端还是在线，这个心跳包其实就是一个ping消息
 */
-(void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload{
    NSString *reply = [[NSString alloc] initWithData:pongPayload encoding:NSUTF8StringEncoding];
    NSLog(@"reply===%@",reply);
    if ([self.WPDelegate respondsToSelector:@selector(wp_webSocketDidReceivePong:)]) {
        [self.WPDelegate wp_webSocketDidReceivePong:pongPayload];
    }
}

-(void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
    if (webSocket == self.socket) {
        NSLog(@"************************** socket收到数据了**************************");
        NSLog(@"message:%@",message);
        
//        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameWithAcceptWPWebScoketData
//                                                            object:nil
//                                                          userInfo:@{WPWebSocketKey:message}];
        
        if ([self.WPDelegate respondsToSelector:@selector(wp_webSocketDidReceiveMessage:)]) {
            [self.WPDelegate wp_webSocketDidReceiveMessage:message];
            
        }
        
    }
}
    

//取消心跳
- (void)destoryHeartBeat
{
     __weak __typeof(self) weakSelf = self;
//    dispatch_main_async_safe(^{
        if (weakSelf.heartBeat) {
            if ([weakSelf.heartBeat respondsToSelector:@selector(isValid)]){
                if ([weakSelf.heartBeat isValid]){
                    [weakSelf.heartBeat invalidate];
                    weakSelf.heartBeat = nil;
                }
            }
        }
//    })
}

//初始化心跳
- (void)initHeartBeat {
    __weak __typeof(self) weakSelf = self;
//    dispatch_main_async_safe(^{
        weakSelf.heartBeat = [NSTimer timerWithTimeInterval:10 target:self selector:@selector(sentHeart) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:weakSelf.heartBeat forMode:NSRunLoopCommonModes];
//    })
//    dispatch_main_async_safe(^{
////        [self destoryHeartBeat];
//        //心跳设置为10s
//        weakSelf.heartBeat = [NSTimer timerWithTimeInterval:10 target:self selector:@selector(sentHeart) userInfo:nil repeats:YES];
//        [[NSRunLoop currentRunLoop] addTimer:weakSelf.heartBeat forMode:NSRunLoopCommonModes];
//    })
}

- (void)wp_timeChangeFunction {
    self.timeInt += 1;
    if (self.timeInt>=10) {
        self.timeInt = 0;
        if (self.isCanSendPing == YES) {
            [self WP_WebSocketSendData:@"1"];
        }
    }
}

/**
 pingPong
 */
- (void)ping{
    if (self.socket.readyState == SR_OPEN) {
        [self.socket sendPing:nil];
    }
}

/**
 获取设备的UUID
 @return UUID字符串
 */
-(NSString *)WP_GetDeviceUUIDStr {
    NSString *uuidStr = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    return uuidStr;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end


