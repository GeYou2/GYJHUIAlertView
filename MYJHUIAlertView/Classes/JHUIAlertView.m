//
//  JHUIAlertView.m
//  JHKit
//
// Created by 葛优 on 2020/3/12.
//  Copyright © 2020年 rangguangyu. All rights reserved.
//


#import "JHUIAlertView.h"

@interface JHUIAlertView()

@property (strong,  nonatomic) JHUIAlertConfig      *config;

@end

@implementation JHUIAlertView
#pragma mark-
#pragma mark–Init
- (instancetype)initWithFrame:(CGRect)frame config:(JHUIAlertConfig *)config
{
    frame = [UIScreen mainScreen].bounds;
    self = [super initWithFrame:frame];
    if (self) {
        _config = config;
        [self jhSetupViews:frame];
    }
    return self;
}
- (instancetype)initWithConfig:(JHUIAlertConfig *)config{
    return [self initWithFrame:CGRectZero config:config];
}

- (instancetype)initWithFrame:(CGRect)frame{
    return [self initWithFrame:CGRectZero config:[[JHUIAlertConfig alloc] init]];
}

#pragma mark-
#pragma mark–Action

- (void)jhSetupViews:(CGRect)frame
{
    
    if (_config.blackViewAlpha < 0 || _config.blackViewAlpha >0.8) {
        _config.blackViewAlpha = 0.5;
    }
    if (_config.contentViewWidth <= 0 ||
        _config.contentViewWidth > [UIScreen mainScreen].bounds.size.width) {
        _config.contentViewWidth = [UIScreen mainScreen].bounds.size.width - 100;
    }
    if (_config.contentViewCornerRadius < 0) {
        _config.contentViewCornerRadius = 10;
    }
    if (_config.buttonHeight < 0) {
        _config.buttonHeight = 40;
    }
    
    // 黑底
    UIView *blackView = [[UIView alloc] init];
    blackView.backgroundColor = _config.blackViewColor;
    blackView.frame = frame;
    blackView.alpha = _config.blackViewAlpha;
    [self addSubview:blackView];
    
    //
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = _config.contentViewColor;
    contentView.layer.cornerRadius = _config.contentViewCornerRadius;
    [self addSubview:contentView];
    _contentView = contentView;
    contentView.clipsToBounds=YES;
    CGFloat X = 0, Y = 0, W = 0, H = 0;
    CGRect sframe;
    
    // 标题
    if (_config.title.text.length > 0) {
        
        X = _config.title.leftPadding;
        Y = _config.title.topPadding;
        W = _config.contentViewWidth - X - _config.title.rightPadding;
        
        UILabel *titleLable = [self xx_setup_attributed_label:_config.title.text
                                                        color:_config.title.color
                                                         font:_config.title.font
                                                        width:W
                                                    lineSpace:_config.title.lineSpace];
        if (_config.title.labelHeight!=0) {
            titleLable.frame = CGRectMake(X, Y, W, _config.title.labelHeight);
        }else{
            sframe = titleLable.frame;
            sframe.origin.x = X;
            sframe.origin.y = Y;
            titleLable.frame = sframe;
        }
        
        titleLable.backgroundColor = _config.title.backgroundcolor;
        if (_config.title.autoHeight) {
            titleLable.numberOfLines = 0;
        }
        
        [contentView addSubview:titleLable];
        _titleLabel = titleLable;
        
        Y = CGRectGetMaxY(titleLable.frame) + _config.title.bottomPadding;
    }
    
    // 内容
    if (_config.content.text.length > 0) {
        
        //分割线
        if (_config.title.text.length > 0 && _config.titleBottomLineHidden == NO) {
            X = 0, W = _config.contentViewWidth, H = 0.5;
            sframe = CGRectMake(X,Y,W,H);
            
            UIView *line = [self xx_setup_line:sframe];
            [contentView addSubview:line];
            _titleBottomLine = line;
        }
        
        X = _config.content.leftPadding;
        Y = Y + _config.content.topPadding;
        W = _config.contentViewWidth - X - _config.content.rightPadding;
        //计算文字高度，如果文字较多，就用textView展示，不然就用UILabel展示
        // calculate size
        CGSize size = CGSizeMake(W, MAXFLOAT);
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:_config.content.lineSpace];
        paragraphStyle.alignment = NSTextAlignmentCenter; // 居中
        if ([_config.content.text containsString:@"\n"]) {
            paragraphStyle.alignment = NSTextAlignmentLeft; // 居左
        }
        NSDictionary *dic = @{NSFontAttributeName:_config.content.font,
                              NSParagraphStyleAttributeName:paragraphStyle};
        size = [_config.content.text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
        //有限制弹框高度，并且文字内容太多高于限制高度，就选用UITextView
       if (_config.alertHeight&&size.height>_config.alertHeight) {
            UITextView *contentLabel = [self xx_setup_attributed_TextView:_config.content.text
                                                              color:_config.content.color
                                                               font:_config.content.font
                                                              width:W
                                                          lineSpace:_config.content.lineSpace];
            sframe = contentLabel.frame;
            sframe.origin.x = X;
            sframe.origin.y = Y;
            contentLabel.frame = sframe;
           contentLabel.backgroundColor=[UIColor clearColor];
            
            [contentView addSubview:contentLabel];
            _contentTextView = contentLabel;
           Y = CGRectGetMaxY(contentLabel.frame) + _config.content.bottomPadding;
       }else{
           UILabel *contentLabel = [self xx_setup_attributed_label:_config.content.text
                                                             color:_config.content.color
                                                              font:_config.content.font
                                                             width:W
                                                         lineSpace:_config.content.lineSpace];
           sframe = contentLabel.frame;
           sframe.origin.x = X;
           sframe.origin.y = Y;
           contentLabel.frame = sframe;
           
           if (_config.content.autoHeight) {
               contentLabel.numberOfLines = 0;
           }
           
           [contentView addSubview:contentLabel];
           _contentLabel = contentLabel;
           
           Y = CGRectGetMaxY(contentLabel.frame) + _config.content.bottomPadding;
       }
        
        
        

    }
    
    CGFloat buttonH = _config.buttonHeight;
    //按钮
    if (_config.buttons.count == 2) {
        
        // 分割线 横
        if (_config.title.text.length > 0 || _config.content.text.length > 0) {
            X= 0, W = _config.contentViewWidth, H = 0.5;
            sframe = CGRectMake(X,Y,W,H);
            
            UIView *line = [self xx_setup_line:sframe];
            [contentView addSubview:line];
        }
        
        // 分割线 竖
        X = _config.contentViewWidth*0.5, W = 0.5, H = buttonH;
        sframe = CGRectMake(X,Y,W,H);
        UIView *line = [self xx_setup_line:sframe];
        [contentView addSubview:line];
        
        //按钮
        X = 0, W = _config.contentViewWidth*0.5;
        
        for (int i = 0; i < _config.buttons.count; ++i) {
            sframe = CGRectMake(X,Y,W,H);
            JHUIAlertButtonConfig *btnConfig = _config.buttons[i];
            [self xx_setup_button:sframe title:btnConfig.title color:btnConfig.color font:btnConfig.font image:btnConfig.image superview:contentView tag:i];
            X += W;
        }
    }else{
        X= 0, W = (CGRectGetWidth(frame) - 100), H = buttonH;
        for (int i = 0; i < _config.buttons.count; ++i) {
            sframe = CGRectMake(X,Y,W,H);
            JHUIAlertButtonConfig *btnConfig = _config.buttons[i];
            UIButton *button = [self xx_setup_button:sframe title:btnConfig.title color:btnConfig.color font:btnConfig.font image:btnConfig.image superview:contentView tag:i];
            
            // space
            if (btnConfig.imageTitleSpace > 0) {
                [button setImageEdgeInsets:UIEdgeInsetsMake(0,0,0,btnConfig.imageTitleSpace)];
                [button setTitleEdgeInsets:UIEdgeInsetsMake(0,btnConfig.imageTitleSpace,0,0)];
            }
            button.backgroundColor=btnConfig.backgroundcolor;
            //分割线
            if (i == 0 && _config.title.text.length == 0 && _config.content.text.length == 0){
                //no line
            }else{
                H = 0.5;
                sframe = CGRectMake(X,Y,W,H);
                UIView *line = [self xx_setup_line:sframe];
                [contentView addSubview:line];
            }
            H = buttonH;
            Y += H;
        }
    }
    
    if (_config.dismissWhenTapOut) {
        [blackView addGestureRecognizer:({
            [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(xx_tap)];
        })];
    }
    
    X = 50, W = _config.contentViewWidth;
    if (_config.buttons.count == 2) {
        H = Y + H;
    }else{
        H = Y;
    }
    
    if (_config.contentViewHeight > 0) {
        H = _config.contentViewHeight;
    }
    
    contentView.frame = CGRectMake(X,Y,W,H);
    contentView.center = CGPointMake(self.center.x, self.center.y-80);
    
}
//获取指定颜色、字体的自适应高度的标签
- (UILabel *)xx_setup_attributed_label:(NSString *)text
                                 color:(UIColor *)color
                                  font:(UIFont *)font
                                 width:(CGFloat)width
                             lineSpace:(CGFloat)lineSpace
{
    // set line space
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpace];
    paragraphStyle.alignment = NSTextAlignmentCenter; // 居中
    if ([text containsString:@"\n"]) {
        paragraphStyle.alignment = NSTextAlignmentLeft; // 居左
    }
    [attStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    [attStr addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, [text length])];
    [attStr addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, [text length])];
    
    // calculate size
    CGSize size = CGSizeMake(width, MAXFLOAT);
    NSDictionary *dic = @{NSFontAttributeName:font,
                          NSParagraphStyleAttributeName:paragraphStyle};
    size = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    
    // label
    UILabel *label = [[UILabel alloc] init];
    if (size.height<60) {//内容区域太小会显得跟整个弹框不协调
        size.height=60;
    }
    label.frame = CGRectMake(0, 0, width, size.height);
    label.attributedText = attStr;
    return label;
}
//获取指定颜色、字体的自适应高度的标签
- (UITextView *)xx_setup_attributed_TextView:(NSString *)text
                                 color:(UIColor *)color
                                  font:(UIFont *)font
                                 width:(CGFloat)width
                             lineSpace:(CGFloat)lineSpace
{
    // set line space
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpace];
    paragraphStyle.alignment = NSTextAlignmentCenter; // 居中
    if ([text containsString:@"\n"]) {
        paragraphStyle.alignment = NSTextAlignmentLeft; // 居左
    }
    [attStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    [attStr addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, [text length])];
    [attStr addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, [text length])];
    
    // calculate size
    CGSize size = CGSizeMake(width, MAXFLOAT);
    NSDictionary *dic = @{NSFontAttributeName:font,
                          NSParagraphStyleAttributeName:paragraphStyle};
    size = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    
    // label
    UITextView *label = [[UITextView alloc] init];
    label.editable=NO;
    if (_config.alertHeight&&size.height<_config.alertHeight) {
        label.frame = CGRectMake(0, 0, width, size.height);
    }else{
        label.frame = CGRectMake(0, 0, width, _config.alertHeight);
    }
    
    label.attributedText = attStr;
    return label;
}
//获取指定frame的分割线
- (UIView *)xx_setup_line:(CGRect)frame{
    UIView *line = [[UIView alloc] init];
    line.frame = frame;
    line.backgroundColor = [UIColor colorWithRed:0.82 green:0.82 blue:0.82 alpha:1];
    return line;
}

- (UIButton *)xx_setup_button:(CGRect)frame
                        title:(NSString *)title
                        color:(UIColor *)color
                         font:(UIFont *)font
                        image:(UIImage *)image
                    superview:(UIView *)view
                          tag:(NSInteger)tag
{
    UIButton *button = [UIButton buttonWithType:1];
    if (image) {
        button = [UIButton buttonWithType:0];
    }
    button.tag = tag;
    button.frame = frame;
    button.titleLabel.font = font==nil?[UIFont systemFontOfSize:18]:font;
    [button setTitle:title==nil?[NSString stringWithFormat:@"按钮%@",@(tag)]:title forState:0];
    [button setTitleColor:color==nil?[UIColor blackColor]:color forState:0];
    [button setImage:image forState:0];
    [button addTarget:self action:@selector(xx_click:) forControlEvents:1<<6];
    [view addSubview:button];
    return button;
}

- (void)xx_click:(UIButton *)button
{
    JHUIAlertButtonConfig *btnConfig = _config.buttons[button.tag];
    if (btnConfig.block) {
        btnConfig.block();
    }
    
    [self dismiss];
}

- (void)xx_tap
{
    if (_config.dismissWhenTapOut) {
        
        if (_tapOutDismissBlock) {
            _tapOutDismissBlock();
        }
        
        [self dismiss];
    }
}

- (void)willMoveToSuperview:(nullable UIView *)newSuperview{
    if (newSuperview) {
        if (_config.showAnimation) {
            self.transform = CGAffineTransformMakeScale(1.2, 1.2);
            self.alpha = 0;
            [UIView animateWithDuration:_config.showAnimationDuration animations:^{
                self.transform = CGAffineTransformIdentity;
                self.alpha = 1;
            }];
        }
    }
}

- (void)addCustomView:(JHUIAlertViewAddCustomViewBlock)block{
    if (block) {
        block(self,_contentView.frame,_titleLabel.frame,_contentLabel.frame);
    }
}

- (void)showInView:(UIView *)view{
    [view addSubview:self];
}

- (void)dismiss{
    if (_config.showAnimation) {
        [UIView animateWithDuration:_config.showAnimationDuration animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }else{
        [self removeFromSuperview];
    }
}

+ (void)jh_show_title:(NSString *)title
              message:(NSString *)message
               inView:(UIView *)view{
    JHUIAlertConfig *config = [[JHUIAlertConfig alloc] init];
    config.title.text       = title;
    config.content.text     = message;
    JHUIAlertView *alert    = [[JHUIAlertView alloc] initWithConfig:config];
    [view addSubview:alert];
}

+ (void)jh_show_title:(NSString *)title
              message:(NSString *)message
               inView:(UIView *)view
          buttonTitle:(NSString *)buttonTitle
             andBlock:(dispatch_block_t)block{
    JHUIAlertConfig *config = [[JHUIAlertConfig alloc] init];
    config.title.text       = title;
    config.content.text     = message;
    JHUIAlertButtonConfig *btnconfig1 = [JHUIAlertButtonConfig configWithTitle:buttonTitle color:nil font:nil image:nil backgroundcolor:nil handle:^{
        if (block) {
            block();
        }
    }];
    config.buttons = @[btnconfig1];
    JHUIAlertView *alert    = [[JHUIAlertView alloc] initWithConfig:config];
    [view addSubview:alert];
}

+ (void)jh_show_title:(NSString *)title
              message:(NSString *)message
               inView:(UIView *)view
          buttonTitle:(NSString *)buttonTitle
             andBlock:(dispatch_block_t)block
         buttonTitle2:(NSString *)buttonTitle2
            andBlock2:(dispatch_block_t)block2{
    JHUIAlertConfig *config = [[JHUIAlertConfig alloc] init];
    config.title.text       = title;
    config.content.text     = message;
    JHUIAlertButtonConfig *btnconfig1 = [JHUIAlertButtonConfig configWithTitle:buttonTitle color:nil font:nil image:nil backgroundcolor:nil handle:^{
        if (block) {
            block();
        }
    }];
    JHUIAlertButtonConfig *btnconfig2 = [JHUIAlertButtonConfig configWithTitle:buttonTitle2 color:nil font:nil image:nil backgroundcolor:nil handle:^{
        if (block2) {
            block2();
        }
    }];
    config.buttons = @[btnconfig1,btnconfig2];
    JHUIAlertView *alert    = [[JHUIAlertView alloc] initWithConfig:config];
    [view addSubview:alert];
}


@end



@implementation JHUIAlertConfig
#pragma mark-
#pragma mark–Init
//设置弹框相关默认值
- (instancetype)init{
    self = [super init];
    if (self) {
        
        _title = [[JHUIAlertTextConfig alloc] init];
        _title.text = @"";
        _title.topPadding = 0;
        _title.leftPadding = 0;
        _title.bottomPadding = 0;
        _title.rightPadding = 0;
        _title.autoHeight = YES;
        _title.labelHeight =40;
        
        _content = [[JHUIAlertTextConfig alloc] init];
        _content.text = @"";
        _content.font = [UIFont systemFontOfSize:16];
        _content.topPadding = 0;
        _content.leftPadding = 5;
        _content.bottomPadding = 5;
        _content.rightPadding = _content.leftPadding;
        _content.autoHeight = YES;
        _content.lineSpace = 0;
        
        CGSize size = [UIScreen mainScreen].bounds.size;
        
        _titleBottomLineHidden = NO;
        _blackViewAlpha = 0.5;
        _showAnimation = YES;
        _blackViewColor = [UIColor blackColor];
        _showAnimationDuration = 0.25;
        _contentViewWidth = size.width - 100;
        _contentViewCornerRadius = 10;
        _contentViewColor =[UIColor whiteColor];
        _dismissWhenTapOut = YES;
        _buttonHeight = 40;
        _alertHeight = size.height*3/5;
    }
    return self;
}

@end

@implementation JHUIAlertTextConfig
#pragma mark-
#pragma mark–Init
//设置弹框中文字(标题和提示内容)默认值
- (instancetype)init{
    self = [super init];
    if (self) {
        _color = [UIColor blackColor];
        _font = [UIFont systemFontOfSize:18];
        
    }
    return self;
}

@end

@implementation JHUIAlertButtonConfig
#pragma mark-
#pragma mark–Init
//设置弹框中按钮相关属性默认值
+ (JHUIAlertButtonConfig *)configWithTitle:(NSString *)title color:(UIColor *)color font:(UIFont *)font image:(UIImage *)image backgroundcolor:(UIColor *)backgroundcolor handle:(dispatch_block_t)block{
    JHUIAlertButtonConfig *btnConfig = [[JHUIAlertButtonConfig alloc] init];
    btnConfig.title = title;
    btnConfig.color = color;
    btnConfig.font = font;
    btnConfig.image = image;
    btnConfig.block = block;
    btnConfig.backgroundcolor = backgroundcolor;
    return btnConfig;
}

@end
