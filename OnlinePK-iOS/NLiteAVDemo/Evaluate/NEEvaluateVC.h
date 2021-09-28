//
//  NEEvaluateVC.h
//  NLiteAVDemo
//
//  Created by I am Groot on 2020/11/16.
//  Copyright © 2020 Netease. All rights reserved.
//

#import "NEBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface NEEvaluateVC : NEBaseViewController
@property(strong,nonatomic)NSString *roomID;
@property(assign,nonatomic)NSInteger roomUID;

- (instancetype)initWithUnfold:(BOOL)unfold;
@end

NS_ASSUME_NONNULL_END
