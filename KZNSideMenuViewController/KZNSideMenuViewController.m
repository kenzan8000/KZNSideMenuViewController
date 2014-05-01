#import "KZNSideMenuViewController.h"


#pragma mark - constant
/// collision detection width for pan gesture
static const CGFloat kKZNSideMenuViewControllerPanGestureCollisionDetectionWidth = 80.0f;
/// initial animation duration
static const CGFloat kKZNSideMenuViewControllerAnimationDuration = 0.5f;
/// initial sidemenu width
#define kKZNSideMenuViewControllerWidth [[UIScreen mainScreen] bounds].size.width * 0.8f
/// pan gesture is enable, if pan gesture velocity is bigger than this width
#define kKZNSideMenuPanGestureIsEnableWidth [[UIScreen mainScreen] bounds].size.width * 0.3f


#pragma mark - interface
@interface KZNSideMenuViewController () <UIGestureRecognizerDelegate> {
}


#pragma mark - properties
/// pan geture recognizer
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
/// tap geture recognizer
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;

/// position where pan gesture began
@property (nonatomic, assign) CGPoint panGestureOrigin;
/// centerView origin before pan gesture began
@property (nonatomic, assign) CGPoint centerViewOrignBeforePanGestureBegan;
/// which side pan gesture began
@property (nonatomic, assign) KZNSideMenuViewControllerSide panGestureSide;


@end


#pragma mark - implementation
@implementation KZNSideMenuViewController


#pragma mark - synthesize
@synthesize leftViewController = m_leftViewController;
@synthesize rightViewController = m_rightViewController;


#pragma mark - initializer


#pragma mark - dealloc
/**
 * release side menu viewControllers
 */
- (void)cleanupSideMenuViewControllers
{
    if (self.leftViewController) {
        [self.leftViewController.view removeFromSuperview];
    }
    if (self.rightViewController) {
        [self.rightViewController.view removeFromSuperview];
    }
    self.leftViewController = nil;
    self.rightViewController = nil;
}

/**
 * release gesture recognizers
 */
- (void)removeGestureRecognizers
{
    if (self.panGestureRecognizer) {
        [[self centerView] removeGestureRecognizer:self.panGestureRecognizer];
        self.panGestureRecognizer = nil;
    }
    if (self.tapGestureRecognizer) {
        [[self centerView] removeGestureRecognizer:self.tapGestureRecognizer];
        self.tapGestureRecognizer = nil;
    }
}

- (void)dealloc
{
    [self cleanupSideMenuViewControllers];
    [self removeGestureRecognizers];
}


#pragma mark - lifecycle
- (void)loadView
{
    [super loadView];
    self.panGestureSide = kKZNSideMenuViewControllerSideNone;
    self.isPresentSideMenuViewController = NO;
    self.animationDurationOfKZNSlideMenu = kKZNSideMenuViewControllerAnimationDuration;
    self.widthOfKZNSlideMenu = kKZNSideMenuViewControllerWidth;
    [self addGestureRecognizers];
}


#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
       shouldReceiveTouch:(UITouch *)touch
{
    return YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        return YES;
    }

    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        // if far from side, pan event cancels
        UIView *centerView = [self centerView];
        CGPoint gestureLocation = [gestureRecognizer locationInView:centerView];
        CGFloat centerViewWidth = centerView.frame.size.width;
        BOOL fromLeft = (ABS(gestureLocation.x - 0) < kKZNSideMenuViewControllerPanGestureCollisionDetectionWidth);
        BOOL fromRight = (ABS(gestureLocation.x - centerViewWidth) < kKZNSideMenuViewControllerPanGestureCollisionDetectionWidth);
        if (fromLeft == NO && fromRight == NO) { return NO; }
        self.panGestureSide = (fromLeft) ? kKZNSideMenuViewControllerSideLeft : kKZNSideMenuViewControllerSideRight;
    }

    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return NO;
}


#pragma mark - event listener
- (void)pannedWithPanGestureRecognizer:(UIPanGestureRecognizer *)gestureRecognizer
{
    UIView *centerView = [self centerView];
    CGPoint gestureLocation = [gestureRecognizer translationInView:centerView];

    // pan began
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        self.centerViewOrignBeforePanGestureBegan = centerView.frame.origin;
        self.panGestureOrigin = gestureLocation;
        return;
    }

    CGFloat screentWidth = [[UIScreen mainScreen] bounds].size.width;

    // calculate origin x
    CGSize offset = CGSizeMake(gestureLocation.x-self.panGestureOrigin.x, 0);
    CGFloat centerViewOriginX = self.centerViewOrignBeforePanGestureBegan.x + offset.width;
    if (self.panGestureSide == kKZNSideMenuViewControllerSideLeft) {
        if (centerViewOriginX < 0) { centerViewOriginX = 0; }
        else if (centerViewOriginX > screentWidth) { centerViewOriginX = screentWidth; }
    }
    else if(self.panGestureSide == kKZNSideMenuViewControllerSideRight) {
        if (centerViewOriginX < -screentWidth) { centerViewOriginX = -screentWidth; }
        else if (centerViewOriginX > 0) { centerViewOriginX = 0; }
    }

    // move
    centerView.frame = (CGRect) {
        .origin = CGPointMake(centerViewOriginX, centerView.frame.origin.y),
        .size = centerView.frame.size
    };
    if (gestureRecognizer.state == UIGestureRecognizerStateChanged) { return; }

    // pad ended
    BOOL isPresent = YES;
    CGPoint velocity = [gestureRecognizer velocityInView:centerView];
    if (self.panGestureSide == kKZNSideMenuViewControllerSideLeft) {
        if (velocity.x > kKZNSideMenuPanGestureIsEnableWidth) { isPresent = YES; }
        else if (velocity.x < -kKZNSideMenuPanGestureIsEnableWidth) { isPresent = NO; }
        else if (centerViewOriginX < screentWidth / 2) { isPresent = NO; }
        else { isPresent = YES; }
    }
    else if(self.panGestureSide == kKZNSideMenuViewControllerSideRight) {
        if (velocity.x > kKZNSideMenuPanGestureIsEnableWidth) { isPresent = NO; }
        else if (velocity.x < -kKZNSideMenuPanGestureIsEnableWidth) { isPresent = YES; }
        else if (centerViewOriginX + screentWidth > screentWidth / 2) { isPresent = NO; }
        else { isPresent = YES; }
    }
    if (isPresent) { [self presentSideMenuViewControllerAnimated:YES side:self.panGestureSide]; }
    else { [self dismissSideMenuViewControllerAnimated:YES]; }
}

- (void)tappedWithTapGestureRecognizer:(UITapGestureRecognizer *)gestureRecognizer
{
    [self dismissSideMenuViewControllerAnimated:YES];
}


#pragma mark - public api
- (void)setLeftViewController:(UIViewController *)viewController
{
    m_leftViewController = viewController;
    [self setSideMenuViewFrameWithCenterViewFrame:[self centerView].frame];
    if ([[self centerView] superview]) {
        [[self centerView] insertSubview:viewController.view
                                         atIndex:0];
    }
}

- (void)setRightViewController:(UIViewController *)viewController
{
    m_rightViewController = viewController;
    [self setSideMenuViewFrameWithCenterViewFrame:[self centerView].frame];
    if ([[self centerView] superview]) {
        [[self centerView] insertSubview:viewController.view
                                         atIndex:0];
    }
}

- (void)presentSideMenuViewControllerAnimated:(BOOL)animated
                                         side:(KZNSideMenuViewControllerSide)side
{
    if (side == kKZNSideMenuViewControllerSideLeft && self.leftViewController == nil) { return; }
    if (side == kKZNSideMenuViewControllerSideRight && self.rightViewController == nil) { return; }

    // position
    CGPoint offset = [self centerView].frame.origin;
    if (side == kKZNSideMenuViewControllerSideLeft) {
        offset.x = self.widthOfKZNSlideMenu;
    }
    else if (side == kKZNSideMenuViewControllerSideRight) {
        offset.x = -self.widthOfKZNSlideMenu;
    }

    // present
    __weak __typeof(self) weakSelf = self;
    [self moveSideMenuWithCenterViewFrame:(CGRect){.origin = offset, .size=[self centerView].frame.size}
                                 animated:animated
                               completion:^ (BOOL finished) {
        weakSelf.isPresentSideMenuViewController = YES;
        weakSelf.panGestureSide = kKZNSideMenuViewControllerSideNone;
        [weakSelf addGestureRecognizers];
    }];
}

- (void)dismissSideMenuViewControllerAnimated:(BOOL)animated
{
    // position
    CGPoint offset = [self centerView].frame.origin;
    offset.x = 0;

    // dismiss
    __weak __typeof(self) weakSelf = self;
    [self moveSideMenuWithCenterViewFrame:(CGRect){.origin = offset, .size=[self centerView].frame.size}
                                 animated:animated
                               completion:^ (BOOL finished) {
        weakSelf.isPresentSideMenuViewController = NO;
        weakSelf.panGestureSide = kKZNSideMenuViewControllerSideNone;
        [weakSelf addGestureRecognizers];
    }];
}


#pragma mark - private api
/**
 * center view
 * @return self.navigationController.view or self.view
 */
- (UIView *)centerView
{
    if (self.navigationController) {
        return self.navigationController.view;
    }
    return self.view;
}

/**
 * set sidemenu view frame
 * @param centerViewFrame centerViewFrame
 */
- (void)setSideMenuViewFrameWithCenterViewFrame:(CGRect)centerViewFrame
{
    if (self.leftViewController) {
        CGRect rect = self.leftViewController.view.frame;
        rect.origin.x = centerViewFrame.origin.x - self.leftViewController.view.frame.size.width;
        self.leftViewController.view.frame = rect;
    }
    if (self.rightViewController) {
        CGRect rect = self.rightViewController.view.frame;
        rect.origin.x = centerViewFrame.origin.x + centerViewFrame.size.width;
        self.rightViewController.view.frame = rect;
    }
}

/**
 * move sidemenu
 * @param centerViewFrame centerViewFrame
 * @param animated YES or NO
 * @param completion block when called completing move
 */
- (void)moveSideMenuWithCenterViewFrame:(CGRect)centerViewFrame
                               animated:(BOOL)animated
                             completion:(void (^)(BOOL))completion
{
    // calculate animation duraton
    CGFloat width = [[UIScreen mainScreen] bounds].size.width;
    CGFloat distance = ABS([self centerView].frame.origin.x - centerViewFrame.origin.x);
    CGFloat duration = (distance == 0) ? 0 : self.animationDurationOfKZNSlideMenu * distance / width;
    if (animated == NO) { duration = 0; }

    // animation
    __weak __typeof(self) weakSelf = self;
    [UIView animateWithDuration:duration
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^ () {
        [weakSelf centerView].frame = centerViewFrame;
    }
                     completion:completion];
}

/**
 * add gesture recognizers
 */
- (void)addGestureRecognizers
{
    [self removeGestureRecognizers];
    if (self.isPresentSideMenuViewController) {
        [self addGestureRecognizersWhenSideMenuViewAppeared];
    }
    else {
        [self addGestureRecognizersWhenSideMenuViewDisappeared];
    }
}

/**
 * add gesture recognizers when appeared
 */
- (void)addGestureRecognizersWhenSideMenuViewAppeared
{
    // pan
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                        action:@selector(pannedWithPanGestureRecognizer:)];
    [self.panGestureRecognizer setMaximumNumberOfTouches:1];
    [self.panGestureRecognizer setDelegate:self];
    [[self centerView] addGestureRecognizer:self.panGestureRecognizer];

    // tap
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                        action:@selector(tappedWithTapGestureRecognizer:)];
    [self.tapGestureRecognizer setDelegate:self];
    [[self centerView] addGestureRecognizer:self.tapGestureRecognizer];
}

/**
 * add gesture recognizers when disappeared
 */
- (void)addGestureRecognizersWhenSideMenuViewDisappeared
{
    // pan
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                        action:@selector(pannedWithPanGestureRecognizer:)];
    [self.panGestureRecognizer setMaximumNumberOfTouches:1];
    [self.panGestureRecognizer setDelegate:self];
    [[self centerView] addGestureRecognizer:self.panGestureRecognizer];
}


@end
