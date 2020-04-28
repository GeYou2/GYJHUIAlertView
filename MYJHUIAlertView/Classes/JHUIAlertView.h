//
//  JHUIAlertView.h
//  JHKit
//
//  Created by 葛优 on 2020/3/12.
//  Copyright © 2020年 rangguangyu. All rights reserved.
//
//

#import <UIKit/UIKit.h>
/**这是个自定义的alert弹框，用于弹出提示语或自定义弹出框*/
@class JHUIAlertView,JHUIAlertConfig,JHUIAlertTextConfig,JHUIAlertButtonConfig;

typedef void(^JHUIAlertViewAddCustomViewBlock)(JHUIAlertView *alertView, CGRect contentViewRect, CGRect titleLabelRect, CGRect contentLabelRect);

@interface JHUIAlertView : UIView

@property (nonatomic,  strong,  readonly) UIView        *contentView;
@property (nonatomic,  strong,  readonly) UILabel       *titleLabel;
@property (nonatomic,  strong,  readonly) UILabel       *contentLabel;
@property (nonatomic,  strong,  readonly) UITextView       *contentTextView;
@property (nonatomic,  strong,  readonly) NSArray       *buttonArray;
@property (nonatomic,  strong,  readonly) UIView        *titleBottomLine;

@property (nonatomic,    copy) dispatch_block_t tapOutDismissBlock;

+ (void)jh_show_title:(NSString *)title
              message:(NSString *)message
               inView:(UIView *)view;

+ (void)jh_show_title:(NSString *)title
              message:(NSString *)message
               inView:(UIView *)view
          buttonTitle:(NSString *)buttonTitle
             andBlock:(dispatch_block_t)block;

+ (void)jh_show_title:(NSString *)title
              message:(NSString *)message
               inView:(UIView *)view
          buttonTitle:(NSString *)buttonTitle
             andBlock:(dispatch_block_t)block
         buttonTitle2:(NSString *)buttonTitle2
            andBlock2:(dispatch_block_t)block2;

- (instancetype)initWithConfig:(JHUIAlertConfig *)config;


- (void)addCustomView:(JHUIAlertViewAddCustomViewBlock)block;

- (void)showInView:(UIView *)view;
//弹框消失
- (void)dismiss;

@end

/**这是整个弹出框（包括蒙层和弹框）功能配置类，可以设置蒙层和弹框的样式*/
@interface JHUIAlertConfig : NSObject

/// title
@property (nonatomic,  strong,  readonly) JHUIAlertTextConfig      *title;
/// content
@property (nonatomic,  strong,  readonly) JHUIAlertTextConfig      *content;
/// the line between title and content, default is NO.
@property (assign,  nonatomic) BOOL              titleBottomLineHidden;
/// buttons
@property (strong,  nonatomic) NSArray<JHUIAlertButtonConfig *> *buttons;
/// 蒙层颜色，默认黑色
@property (assign,  nonatomic) UIColor           *blackViewColor;
/// the alpha of black mask view, default is 0.5
@property (assign,  nonatomic) CGFloat           blackViewAlpha;
/// show animation, default is YES
@property (nonatomic,  assign) BOOL              showAnimation;
/// show animation duration, default is 0.25s
@property (nonatomic,  assign) CGFloat           showAnimationDuration;
/// Default is: [UIScreen mainScreen].bounds.size.width - 100
@property (nonatomic,  assign) CGFloat           contentViewWidth;
//提示框颜色，默认是白色
@property (assign,  nonatomic) UIColor           *contentViewColor;

/// Height for a fully custom view
@property (nonatomic,  assign) CGFloat           contentViewHeight;
/// Default is 10
@property (nonatomic,  assign) CGFloat           contentViewCornerRadius;
/// Default is YES
@property (nonatomic,  assign) BOOL              dismissWhenTapOut;
/// Button height
@property (nonatomic,  assign) CGFloat           buttonHeight;
/// 弹出框的高度
@property (nonatomic,  assign) CGFloat           alertHeight;

@end

/**这是弹框内文字配置类，用于设置弹框的标题和内容的颜色大小和内容，以及文字与弹框的边距**/
@interface JHUIAlertTextConfig : NSObject

/// text
@property (copy,    nonatomic) NSString         *text;
/// text color
@property (strong,  nonatomic) UIColor          *color;
/// 背景颜色
@property (strong,  nonatomic) UIColor          *backgroundcolor;
/// text font, default is 18
@property (strong,  nonatomic) UIFont           *font;
/// top padding
@property (nonatomic,  assign) CGFloat           topPadding;
/// left padding
@property (nonatomic,  assign) CGFloat           leftPadding;
/// bottom padding
@property (nonatomic,  assign) CGFloat           bottomPadding;
/// right padding
@property (nonatomic,  assign) CGFloat           rightPadding;
/// auto height
@property (nonatomic,  assign) BOOL              autoHeight;
/// line space
@property (nonatomic,  assign) CGFloat           lineSpace;
//文字标签高度
@property (nonatomic,  assign) CGFloat           labelHeight;

@end
/**这是弹框内按钮配置类，用于设置弹框按钮样式**/
@interface JHUIAlertButtonConfig : NSObject

/// title
@property (copy,    nonatomic) NSString         *title;
/// title color
@property (strong,  nonatomic) UIColor          *color;
/// 背景颜色
@property (strong,  nonatomic) UIColor          *backgroundcolor;
/// title font, default is 18
@property (strong,  nonatomic) UIFont           *font;
/// image
@property (strong,  nonatomic) UIImage          *image;
/// the space between image and title
@property (nonatomic,  assign) CGFloat           imageTitleSpace;
/// block
@property (copy,    nonatomic) dispatch_block_t  block;

+ (JHUIAlertButtonConfig *)configWithTitle:(NSString *)title color:(UIColor *)color font:(UIFont *)font image:(UIImage *)image backgroundcolor:(UIColor *)backgroundcolor handle:(dispatch_block_t)block;

@end
