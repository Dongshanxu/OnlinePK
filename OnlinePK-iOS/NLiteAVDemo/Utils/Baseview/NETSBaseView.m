//
//  NETSBaseView.m
//  NLiteAVDemo
//
//  Created by 徐善栋 on 2020/12/30.
// Copyright (c) 2021 NetEase, Inc.  All rights reserved.
// Use of this source code is governed by a MIT license that can be found in the LICENSE file.

#import "NETSBaseView.h"

@interface NETSBaseView()

@property (nonatomic, readwrite, strong) id model;

@end

@implementation NETSBaseView

- (instancetype)initWithFrame:(CGRect)frame model:(id<NETSBaseViewProtocol>)model {
    self = [super initWithFrame:frame];
    if (self) {
        _model = model;
        self.backgroundColor = [UIColor whiteColor];
        [self nets_setupViews];
        [self nets_bindViewModel];
    }
    return self;
}


- (instancetype)init {
    return [self initWithFrame:CGRectZero model:nil];
}

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame model:nil];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    return [self initWithFrame:CGRectZero model:nil];
}

- (void)nets_setupViews {
    
}

- (void)nets_bindViewModel {
    
}

@end
