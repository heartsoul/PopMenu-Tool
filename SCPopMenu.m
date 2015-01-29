
#import "SCPopMenu.h"

@interface UIView (Extension)
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGPoint origin;
@end


@implementation SCPopMenu

static UIButton *_cover;
static UIImageView *_container;
static void(^_dismiss)();
static UIViewController *_contentVc;

+ (void)popFromRect:(CGRect)rect inView:(UIView *)view contentVc:(UIViewController *)contentVc dismiss:(void(^)())dismiss {
    _contentVc = contentVc;
    
    [self popFromRect:rect inView:view content:contentVc.view dismiss:dismiss];
}

+ (void)popFromView:(UIView *)view contentVc:(UIViewController *)contentVc dismiss:(void(^)())dismiss {
    _contentVc = contentVc;
    
    [self popFromView:view content:contentVc.view dismiss:dismiss];
}

+ (void)popFromRect:(CGRect)rect inView:(UIView *)view content:(UIView *)content dismiss:(void(^)())dismiss {
    // block需要进行copy才能保住性命
    // block的copy作用:将block的内存从桟空间移动到堆空间
    _dismiss = [dismiss copy];
    
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    window.windowLevel = UIWindowLevelStatusBar;
    
    // 遮盖
    UIButton *cover = [[UIButton alloc] init];
    cover.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    [cover addTarget:self action:@selector(coverClick) forControlEvents:UIControlEventTouchDown];
    cover.frame = [UIScreen mainScreen].bounds;
    [window addSubview:cover];
    _cover = cover;
    
    // 容器
    UIImageView *container = [[UIImageView alloc] init];
    container.userInteractionEnabled = YES;
    container.image = [UIImage imageNamed:@"bottleSignLabelBkg"];
    
    [window addSubview:container];
    _container = container;
    
    // 添加内容到容器中
    content.x = 10;
    content.y = 10;
    [container addSubview:content];
    
    // 计算容器的尺寸
    container.width = CGRectGetMaxX(content.frame) + content.x;
    container.height = CGRectGetMaxY(content.frame) + content.x;
    container.centerX = CGRectGetMidX(rect);
    container.y = CGRectGetMaxY(rect);
    
    // 转换位置
    container.center = [view convertPoint:container.center toView:window];
}

/**
 *  弹出一个菜单
 *
 *  @param view    菜单的箭头指向谁
 *  @param content 菜单里面的内容
 */
+ (void)popFromView:(UIView *)view content:(UIView *)content dismiss:(void(^)())dismiss {
    [self popFromRect:view.bounds inView:view content:content dismiss:dismiss];
//    [self popFromRect:view.frame inView:view.superview content:content dismiss:dismiss];
}

/**
 *  点击遮盖
 */
+ (void)coverClick {
    [UIView animateWithDuration:0.2 animations:^{
        _cover.alpha = 0.0;
        _container.alpha = 0.0;
    } completion:^(BOOL finished) {
        [_cover removeFromSuperview];
        [_container removeFromSuperview];
        _cover = nil;
        _container = nil;
        _contentVc = nil;
        if (_dismiss) {
            _dismiss(); // 调用nil的block,直接报内存错误
            _dismiss = nil;
        }
    }];
}

@end


@implementation UIView (Extension)
- (void)setX:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}
- (CGFloat)x {
    return self.frame.origin.x;
}
- (void)setY:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}
- (CGFloat)y {
    return self.frame.origin.y;
}
- (void)setCenterX:(CGFloat)centerX {
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}
- (CGFloat)centerX {
    return self.center.x;
}
- (void)setCenterY:(CGFloat)centerY {
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}
- (CGFloat)centerY {
    return self.center.y;
}
- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}
- (CGFloat)width {
    return self.frame.size.width;
}
- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}
- (CGFloat)height {
    return self.frame.size.height;
}
- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}
- (CGSize)size {
    return self.frame.size;
}
- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}
- (CGPoint)origin {
    return self.frame.origin;
}
@end