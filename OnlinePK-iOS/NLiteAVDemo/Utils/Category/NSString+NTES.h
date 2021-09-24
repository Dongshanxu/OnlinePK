//
//  NSString+NTES.h
//  NLiteAVDemo
//
//  Created by Ease on 2020/11/24.
//  Copyright © 2020 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (NTES)

- (BOOL)isChinese;

- (nullable id)jsonObject;

- (NSString *)ne_trimming;

- (BOOL)ne_isNumber;

/// md5 加密
/// @param str 所需加密字符串
+ (NSString *)md5ForLower32Bate:(NSString *)str;
@end

NS_ASSUME_NONNULL_END
