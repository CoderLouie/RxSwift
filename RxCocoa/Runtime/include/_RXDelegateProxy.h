//
//  _RXDelegateProxy.h
//  RxCocoa
//
//  Created by Krunoslav Zaher on 7/4/15.
//  Copyright © 2015 Krunoslav Zaher. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


/*
 1. 为什么在Rx中包装一个具有返回类型的委托是一件困难的事情？

 带有返回类型的委托方法并不用于观察，而是用于自定义行为
 定义一个在任何情况下都可以工作的自动默认值不是一项简单的任务
 */
@interface _RXDelegateProxy : NSObject

@property (nonatomic, weak, readonly) id _forwardToDelegate;

-(void)_setForwardToDelegate:(id __nullable)forwardToDelegate retainDelegate:(BOOL)retainDelegate NS_SWIFT_NAME(_setForwardToDelegate(_:retainDelegate:)) ;

-(BOOL)hasWiredImplementationForSelector:(SEL)selector;
-(BOOL)voidDelegateMethodsContain:(SEL)selector;

-(void)_sentMessage:(SEL)selector withArguments:(NSArray*)arguments;
-(void)_methodInvoked:(SEL)selector withArguments:(NSArray*)arguments;

@end

NS_ASSUME_NONNULL_END
