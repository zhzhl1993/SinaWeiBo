//
//  WBEmotionModel.h
//  微博
//
//  Created by 朱占龙 on 2016/11/5.
//  Copyright © 2016年 cuit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WBEmotionModel : NSObject

/** 表情的文字描述 */
@property(nonatomic, copy) NSString *chs;
/** 表情的png图片名 */
@property(nonatomic, copy) NSString *png;
/** emoji表情的十六进制编码 */
@property(nonatomic, copy) NSString *code;
@end
