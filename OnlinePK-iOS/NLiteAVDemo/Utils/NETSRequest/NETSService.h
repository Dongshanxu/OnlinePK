//
//  NETSService.h
//  NLiteAVDemo
//
//  Created by Ease on 2020/12/1.
//  Copyright © 2020 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NETSRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface NETSService : NSObject

+ (instancetype)shared;

- (void)runRequest:(NSURLRequest *)request completion:(void(^)(NSData * _Nullable data, NSError * _Nullable error))completion;

@end

NS_ASSUME_NONNULL_END
