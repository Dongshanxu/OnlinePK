//
//  NEEvaluateListView.h
//  NLiteAVDemo
//
//  Created by I am Groot on 2020/11/19.
// Copyright (c) 2021 NetEase, Inc.  All rights reserved.
// Use of this source code is governed by a MIT license that can be found in the LICENSE file.

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NEEvaluateListView : UIView
@property(copy,nonatomic)void(^didSelectedIndex) (NSInteger index,BOOL selected);
- (instancetype)initWithTitleArray:(NSArray *)titleArray;
@end

NS_ASSUME_NONNULL_END
