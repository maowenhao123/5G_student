//
//  Tool.m
//  5G_student
//
//  Created by 毛文豪 on 2020/2/19.
//  Copyright © 2020 jiuge. All rights reserved.
//

#import <AVKit/AVKit.h>
#import <HyphenateLite/HyphenateLite.h>
#import "Tool.h"
#import "NSString+Category.h"

@implementation Tool

#pragma mark - 获取视频第一帧
+ (UIImage *)getVideoPreViewImage:(NSURL *)path
{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:path options:nil];
    AVAssetImageGenerator *assetGen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetGen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [assetGen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *videoImage = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return videoImage;
}

#pragma mark - 获取带标签的富文本
+ (NSAttributedString *)getAttributedTextWithTag:(NSString *)tag contentText:(NSString *)contentText
{
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:contentText];
    if (!MStringIsEmpty(tag)) {
        int scale = 3;
        UILabel * tagLabel = [UILabel new];
        tagLabel.text = tag;
        tagLabel.font = [UIFont boldSystemFontOfSize:12 * scale];
        tagLabel.textColor = [UIColor whiteColor];
        tagLabel.backgroundColor = MDefaultColor;
        tagLabel.clipsToBounds = YES;
        tagLabel.layer.cornerRadius = 9 * scale;
        tagLabel.textAlignment = NSTextAlignmentCenter;
        CGSize tagLabelSize = [tagLabel sizeThatFits:CGSizeMake(MScreenWidth, MScreenHeight)];
        tagLabel.frame = CGRectMake(0, 0, tagLabelSize.width + 10 * scale, 18 * scale);
        UIImage *image = [self imageWithUIView:tagLabel];
        NSTextAttachment *attach = [[NSTextAttachment alloc] init];
        attach.bounds = CGRectMake(0, -2.5, tagLabelSize.width / 3 + 10, 18);
        attach.image = image;
        NSAttributedString * imageAttStr = [NSAttributedString attributedStringWithAttachment:attach];
        [attStr insertAttributedString:imageAttStr atIndex:0];
    }
    return attStr;
}

#pragma mark - view转成image
+ (UIImage *)imageWithUIView:(UIView *)view
{
    UIGraphicsBeginImageContext(view.bounds.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:ctx];
    UIImage* tImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return tImage;
}

#pragma mark - 登录环信账号
+ (void)loginImAccount
{
    if (!Userno) return;
    //异步登录
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString * password = [[NSString stringWithFormat:@"%@0605030201", Userno] md5HexDigest];
        EMError *error = [[EMClient sharedClient] loginWithUsername:Userno password:password];
        [[EMClient sharedClient].options setIsAutoLogin:YES];
        if (!error)
        {
            MLog(@"登录成功");
            [[NSNotificationCenter defaultCenter] postNotificationName:@"hxLoginSuccess" object:nil];
            [[EMClient sharedClient] setApnsNickname:@"nickName"];
            EMPushOptions *options = [[EMClient sharedClient] pushOptions];
            options.displayStyle = EMPushDisplayStyleMessageSummary;// 显示消息内容
            EMError *pushError = [[EMClient sharedClient] updatePushOptionsToServer];
            if(!pushError) {
                MLog(@"更新成功");
            }else {
                MLog(@"更新失败");
            }
        }else
        {
            MLog(@"登录失败");
        }
    });
}

@end
