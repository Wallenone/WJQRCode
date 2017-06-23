//
//  SJScanningView.m
//  SJQRCode
//
//  Created by Sunjie on 16/11/15.
//  Copyright © 2016年 Sunjie. All rights reserved.
//
//
// 项目还未完成，将继续更新。
//
//
// 初次封装代码，有不足的地方，请大神指教  邮箱：15220092519@163.com
//
//

#import "SJScanningView.h"

#define kSJQRCodeTipString              @"将二维码/条形码放入框内，即可自动扫描"
#define kSJQRCodeUnRestrictedTipString  @"请在%@的\"设置-隐私-相机\"选项中，\r允许%@访问你的相机。"
#define kSJQRCodeRectPaddingX           78

#define kBtnWidth                       44
#define kBtnTopMargin                   20
#define kBtnMargin                      10

static CGRect scanningRect;



@interface SJScanningView ()

/** 返回按钮 */
@property (nonatomic, strong) UIButton *returenButton;
/** 相册按钮 */
@property (nonatomic, strong) UIButton *albumButton;
/** 手电筒按钮 */
@property (nonatomic, strong) UIButton *torchButton;

@property (nonatomic, strong) UIButton *inputButton;

@property (nonatomic, assign) CGRect cleanRect;
@property (nonatomic, assign) CGRect scanningRect;
@property (nonatomic, strong) UILabel *QRCodeTipLabel;
@property (nonatomic, strong) UIImageView *scanningImageView;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *preViewLayer;

@end

@implementation SJScanningView

+ (Class)layerClass {
    return [AVCaptureVideoPreviewLayer class];
}

#pragma mark - init

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupView];
        self.cleanRect = CGRectMake(kSJQRCodeRectPaddingX, 110, CGRectGetWidth(frame) - kSJQRCodeRectPaddingX * 2, CGRectGetWidth(frame) - kSJQRCodeRectPaddingX * 2);
    }
    return self;
}

#pragma mark - Propertys

- (UIImageView *)scanningImageView {
    if (!_scanningImageView) {
        _scanningImageView = [[UIImageView alloc] initWithFrame:CGRectMake(55, 130, CGRectGetWidth(self.bounds) - 110, 3)];
        _scanningImageView.backgroundColor = [UIColor greenColor];
        scanningRect  = _scanningImageView.frame;
        _scanningImageView.hidden = YES;
    }
    return _scanningImageView;
}

- (UILabel *)QRCodeTipLabel {
    if (!_QRCodeTipLabel) {
        _QRCodeTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.cleanRect) + 30, CGRectGetWidth(self.bounds) - 20, 20)];
        _QRCodeTipLabel.font = [UIFont systemFontOfSize:12];
        _QRCodeTipLabel.backgroundColor = [UIColor clearColor];
        _QRCodeTipLabel.textAlignment = NSTextAlignmentCenter;
        _QRCodeTipLabel.textColor = [UIColor whiteColor];
        _QRCodeTipLabel.numberOfLines = 0;
    }
    return _QRCodeTipLabel;
}

#pragma mark - Public Event

- (void)setupView {
    self.isRestrict = YES;
    self.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.500];
//    [self addSubview:self.scanningImageView];
    [self addSubview:self.QRCodeTipLabel];
    [self QRCodeQRCodeTipLabelString];
    [self drawBarBottomItems];
}

- (AVCaptureSession *)session {
    return self.preViewLayer.session;
}

- (void)setSession:(AVCaptureSession *)session {
    self.preViewLayer.session = session;
}

- (AVCaptureVideoPreviewLayer *)previewLayer {
    return (AVCaptureVideoPreviewLayer *)self.layer;
}

#pragma mark - According authorized and unauthorized show different tip string

- (void )QRCodeQRCodeTipLabelString {
    if (self.isRestrict) {
        self.QRCodeTipLabel.text = kSJQRCodeTipString;
    } else {
        NSString *appName = [[NSBundle mainBundle].infoDictionary valueForKey:@"CFBundleDisplayName"];
        if (!appName) appName = [[NSBundle mainBundle].infoDictionary valueForKey:@"CFBundleName"];
        self.QRCodeTipLabel.text = [NSString stringWithFormat:kSJQRCodeUnRestrictedTipString,[UIDevice currentDevice].model,appName];;
    }
}

- (void)scanning {
//    self.scanningImageView.frame = scanningRect;
//    CGRect animatationRect = scanningRect;
//    animatationRect.origin.y += CGRectGetWidth(self.bounds) - CGRectGetMinX(animatationRect) * 2 - CGRectGetHeight(animatationRect);
//    
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDelay:0];
//    [UIView setAnimationDuration:1.2];
//    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
//    [UIView setAnimationRepeatCount:FLT_MAX];
//    [UIView setAnimationRepeatAutoreverses:NO];
//    
//    self.scanningImageView.frame = animatationRect;
//    [UIView commitAnimations];
}

#pragma mark - Remove ScaningImageViAnimations

- (void)removeScanningAnimations {
    [self.scanningImageView.layer removeAllAnimations];
};

#pragma mark - Setup BarBottomItem

- (void)drawBarBottomItems {
    self.returenButton = [self createButtonImageString:@"SJQRCode.bundle/qrcode_scan_back_nor" heightImageString:@"SJQRCode.bundle/qrcode_scan_back_nor" buttonType:SJButtonTypeReturn];
    self.torchButton = [self createButtonImageString:@"手电筒" heightImageString:@"手电筒" buttonType:SJButtonTypeTorch];
    self.albumButton = [self createButtonImageString:@"SJQRCode.bundle/qrcode_scan_pic_nor" heightImageString:@"SJQRCode.bundle/qrcode_scan_pic_nor" buttonType:SJButtonTypeAlbum];
    
    //定制添加button和image
    
    UIView * whiteView = [[UIView alloc] init];
    whiteView.frame = CGRectMake(0, 412*self.bounds.size.height/667, self.bounds.size.width, self.bounds.size.height-412*self.bounds.size.height/667);
    whiteView.backgroundColor = [UIColor whiteColor];
    
    self.inputButton = [[UIButton alloc] init];
    self.inputButton.frame = CGRectMake(75*self.bounds.size.width/375, 603*self.bounds.size.height/667, 224*self.bounds.size.width/375, 50*self.bounds.size.height/667);
    self.inputButton.tag = STButtonTypeInput;
    [self.inputButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.inputButton setTitle:@"手动输入注册" forState:0];
    self.inputButton.titleLabel.font = [UIFont systemFontOfSize:15];
    self.inputButton.titleLabel.textColor = [UIColor whiteColor];
    self.inputButton.backgroundColor =  [UIColor colorWithRed:60/255.0 green:209/255.0 blue:193/255.0 alpha:1/1.0];
    self.inputButton.layer.cornerRadius = 5;
    
    UILabel * tipLabel = [[UILabel alloc] init];
    tipLabel.frame = CGRectMake(0, 574*self.bounds.size.height/667, self.bounds.size.width, 21*self.bounds.size.height/667);
    tipLabel.font = [UIFont systemFontOfSize:15];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.text = @"二维码在电表侧面";
    
    UIImageView * QRimageView = [[UIImageView alloc] init];
    QRimageView.frame = CGRectMake(133*self.bounds.size.width/375, 423*self.bounds.size.height/667, 109*self.bounds.size.width/375, 142*self.bounds.size.height/667);
    [QRimageView setImage:[UIImage imageNamed:@"电表二维码示例图"]];

    
    [self addSubview:whiteView];
    [self addSubview:tipLabel];
    [self addSubview:QRimageView];
    [self addSubview:self.returenButton];
    [self addSubview:self.torchButton];
    [self addSubview:self.inputButton];
//    [self addSubview:self.albumButton];
    
    
    
    
}

- (UIButton *)createButtonImageString:(NSString *)imageString heightImageString:(NSString *)hImageString buttonType:(SJButtonType)btnType{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = btnType;
    [button setBackgroundImage:[UIImage imageNamed:@"button"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:imageString] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:hImageString] forState:UIControlStateSelected];
    [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    
    if (btnType == SJButtonTypeReturn) {
        button.frame = CGRectMake(kBtnMargin, kBtnTopMargin, kBtnWidth, kBtnWidth);
    }else if (btnType == SJButtonTypeTorch) {
        button.frame = CGRectMake(CGRectGetWidth(self.bounds) - kBtnMargin - kBtnWidth, kBtnTopMargin, kBtnWidth, kBtnWidth);
    }else if (btnType == SJButtonTypeAlbum) {
        button.frame = CGRectMake(CGRectGetWidth(self.bounds) - (kBtnMargin + kBtnWidth) * 2, kBtnTopMargin, kBtnWidth, kBtnWidth);
    }
    
    return button;
}

#pragma mark - Button Action

- (void)clickButton:(UIButton *)btn {
    [self.scanningDelegate clickBarButtonItemSJButtonType:btn.tag];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(contextRef, self.backgroundColor.CGColor);
    CGContextFillRect(contextRef, rect);
    CGRect clearRect;
//    CGFloat paddingX = kSJQRCodeRectPaddingX;
    CGFloat tipLabelPadding = 30.0f;
    clearRect = CGRectMake(78*self.bounds.size.width/375, 110*self.bounds.size.height/667, 220.5*self.bounds.size.width/375,220.5*self.bounds.size.height/667);
    self.cleanRect = clearRect;
    
    CGRect QRCodeTipLabelFrame = self.QRCodeTipLabel.frame;
    QRCodeTipLabelFrame.origin.y = CGRectGetMaxY(self.cleanRect) + tipLabelPadding;
    self.QRCodeTipLabel.frame = QRCodeTipLabelFrame;
    
    CGContextClearRect(contextRef, self.cleanRect);
    CGContextSaveGState(contextRef);
    
    UIImage *topLeftImage = [UIImage imageNamed:@"SJQRCode.bundle/ScanQR1"];
    UIImage *topRightImage = [UIImage imageNamed:@"SJQRCode.bundle/ScanQR2"];
    UIImage *bottomLeftImage = [UIImage imageNamed:@"SJQRCode.bundle/ScanQR3"];
    UIImage *bottomRightImage = [UIImage imageNamed:@"SJQRCode.bundle/ScanQR4"];
    
    [topLeftImage drawInRect:CGRectMake(_cleanRect.origin.x, _cleanRect.origin.y, topLeftImage.size.width, topLeftImage.size.height)];
    [topRightImage drawInRect:CGRectMake(CGRectGetMaxX(_cleanRect) - topRightImage.size.width, _cleanRect.origin.y, topRightImage.size.width, topRightImage.size.height)];
    [bottomLeftImage drawInRect:CGRectMake(_cleanRect.origin.x, CGRectGetMaxY(_cleanRect) - bottomLeftImage.size.height, bottomLeftImage.size.width, bottomLeftImage.size.height)];
    [bottomRightImage drawInRect:CGRectMake(CGRectGetMaxX(_cleanRect) - bottomRightImage.size.width, CGRectGetMaxY(_cleanRect) - bottomRightImage.size.height, bottomRightImage.size.width, bottomRightImage.size.height)];
    
    CGFloat padding = 0.5;
    CGContextMoveToPoint(contextRef, CGRectGetMinX(_cleanRect) - padding, CGRectGetMinY(_cleanRect) - padding);
    CGContextAddLineToPoint(contextRef, CGRectGetMaxX(_cleanRect) + padding, CGRectGetMinY(_cleanRect) + padding);
    CGContextAddLineToPoint(contextRef, CGRectGetMaxX(_cleanRect) + padding, CGRectGetMaxY(_cleanRect) + padding);
    CGContextAddLineToPoint(contextRef, CGRectGetMinX(_cleanRect) - padding, CGRectGetMaxY(_cleanRect) + padding);
    CGContextAddLineToPoint(contextRef, CGRectGetMinX(_cleanRect) - padding, CGRectGetMinY(_cleanRect) - padding);
    CGContextSetLineWidth(contextRef, padding);
    CGContextSetStrokeColorWithColor(contextRef, [UIColor whiteColor].CGColor);
    CGContextStrokePath(contextRef);
}
@end
