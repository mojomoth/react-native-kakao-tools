
#import "RNKakaoTools.h"
#import <React/RCTLog.h>

#import <KakaoLink/KakaoLink.h>
#import <KakaoMessageTemplate/KakaoMessageTemplate.h>

@implementation RNKakaoTools

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}
RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(foo:(RCTResponseSenderBlock)callback)
{
    callback(@[[NSNull null], [NSNull null]]);
}

RCT_EXPORT_METHOD(link:(NSString *)title buttonText:(NSString *)buttonText imageURI:(NSString *)imageURI webURL:(NSString *)webURL mobileWebURL:(NSString *)mobileWebURL androidExecutionParams:(NSString *)androidExecutionParams iosExecutionParams:(NSString *)iosExecutionParams callback:(RCTResponseSenderBlock)callback)
{
    KMTTemplate *template = [KMTFeedTemplate feedTemplateWithBuilderBlock:^(KMTFeedTemplateBuilder * _Nonnull feedTemplateBuilder) {

        // 콘텐츠
        feedTemplateBuilder.content = [KMTContentObject contentObjectWithBuilderBlock:^(KMTContentBuilder * _Nonnull contentBuilder) {
            contentBuilder.title = title;
            contentBuilder.imageURL = [NSURL URLWithString:imageURI];
            contentBuilder.link = [KMTLinkObject linkObjectWithBuilderBlock:^(KMTLinkBuilder * _Nonnull linkBuilder) {
                linkBuilder.webURL = [NSURL URLWithString:webURL];
                linkBuilder.mobileWebURL = [NSURL URLWithString:mobileWebURL];
                linkBuilder.iosExecutionParams = iosExecutionParams;
                linkBuilder.androidExecutionParams = androidExecutionParams;
            }];
        }];


        // 버튼
        [feedTemplateBuilder addButton:[KMTButtonObject buttonObjectWithBuilderBlock:^(KMTButtonBuilder * _Nonnull buttonBuilder) {
            buttonBuilder.title = buttonText;
            buttonBuilder.link = [KMTLinkObject linkObjectWithBuilderBlock:^(KMTLinkBuilder * _Nonnull linkBuilder) {
                linkBuilder.webURL = [NSURL URLWithString:webURL];
                linkBuilder.mobileWebURL = [NSURL URLWithString:mobileWebURL];
                linkBuilder.iosExecutionParams = iosExecutionParams;
                linkBuilder.androidExecutionParams = androidExecutionParams;
            }];
        }]];
    }];

    [[KLKTalkLinkCenter sharedCenter] sendDefaultWithTemplate:template success:^(NSDictionary<NSString *,NSString *> * _Nullable warningMsg, NSDictionary<NSString *,NSString *> * _Nullable argumentMsg) {
        // 성공
        RCTLogInfo(@"warning message: %@", warningMsg);
        RCTLogInfo(@"argument message: %@", argumentMsg);
    } failure:^(NSError * _Nonnull error) {
        // 에러
        RCTLogInfo(@"error: %@", error);
    }];
}


@end
  