//
//  UIButton+Touch.m
//  ButtonIgnore
//
//  Created by admin on 2018/1/23.
//  Copyright © 2018年 NSLog_Zeng. All rights reserved.
//

#import "UIButton+Touch.h"
#import <objc/runtime.h>

@interface UIButton ()
/***  YES:不允许点击    NO:允许点击  ***/
@property (nonatomic, assign) BOOL ignoreEvent;
@end

@implementation UIButton (Touch)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL selA = @selector(sendAction:to:forEvent:);
        SEL selB = @selector(mySendAction:to:forEvent:);
        Method methodA = class_getInstanceMethod(self, selA);
        Method methodB = class_getInstanceMethod(self, selB);
        //将methodB的实现 添加进系统方法中
        BOOL isAdd = class_addMethod(self, selA, method_getImplementation(methodB), method_getTypeEncoding(methodB));
        if (isAdd) {
            //添加成功  将methodB的实现指针替换成methodA的  否则methodB将不实现
            class_replaceMethod(self, selB, method_getImplementation(methodA), method_getTypeEncoding(methodA));
        } else {
            //添加失败  说明本类中 已有methodB的实现  此时将methodA和methodB的IMP互换即可
            method_exchangeImplementations(methodA, methodB);
        }
    });
}

- (void)mySendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    if ([NSStringFromClass([self class]) isEqualToString:@"UIButton"]) {
        self.timeInterval = self.timeInterval == 0 ? 0.5 : self.timeInterval;
        if (self.ignoreEvent) {
            return;
        } else if (self.timeInterval > 0){
            [self performSelector:@selector(resetState) withObject:nil afterDelay:self.timeInterval];
        } else {
            [self performSelector:@selector(resetState) withObject:nil];
        }
    }
    self.ignoreEvent = YES;
    [self mySendAction:action to:target forEvent:event];
}
/**
 重置按钮点击状态
 */
- (void)resetState {
    self.ignoreEvent = NO;
}
- (NSTimeInterval)timeInterval {
    return [objc_getAssociatedObject(self, _cmd) doubleValue];
}
- (void)setTimeInterval:(NSTimeInterval)timeInterval {
    objc_setAssociatedObject(self, @selector(timeInterval), @(timeInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (BOOL)ignoreEvent {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}
- (void)setIgnoreEvent:(BOOL)ignoreEvent {
    objc_setAssociatedObject(self, @selector(ignoreEvent), @(ignoreEvent), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end








