#import "KZNSideMenuViewController.h"


#pragma mark - constant
/// collision detection width for pan gesture
static const CGFloat kKZNSideMenuViewControllerPanGestureCollisionDetectionWidth = 80.0f;
/// initial animation duration
static const CGFloat kKZNSideMenuViewControllerAnimationDuration = 0.45f;
/// initial sidemenu width
#define kKZNSideMenuViewControllerWidth [[UIScreen mainScreen] bounds].size.width * 0.8f
/// pan gesture is enable, if pan gesture velocity is bigger than this width
#define kKZNSideMenuPanGestureIsEnableWidth [[UIScreen mainScreen] bounds].size.width * 0.3f


#pragma mark - UIViewController+KZNSideMenuViewController
@implementation UIViewController (KZNSideMenuViewController)


#pragma mark - public api
- (UIViewController *)sideMenuViewController
{
    UIViewController *parent = (self.navigationController) ? [[self navigationController] parentViewController] : [self parentViewController];
    if (parent == nil) { return nil; }
    if ([parent isKindOfClass:[KZNSideMenuViewController class]] == NO) { return nil; }
    return parent;
}

- (BOOL)isPresentSideMenuViewController
{
    UIViewController *parent = [self sideMenuViewController];
    if (parent == nil) { return NO; }
    return [(KZNSideMenuViewController *)parent isPresentSideMenuViewController];
}

- (void)dismissSideMenuViewControllerAnimated:(BOOL)animated
{
    UIViewController *parent = [self sideMenuViewController];
    if (parent == nil) { return; }
    [(KZNSideMenuViewController *)parent dismissSideMenuViewControllerAnimated:animated];
}

- (void)presentSideMenuViewControllerAnimated:(BOOL)animated
                                         side:(KZNSideMenuViewControllerSide)side
{
    UIViewController *parent = [self sideMenuViewController];
    if (parent == nil) { return; }
    [(KZNSideMenuViewController *)parent presentSideMenuViewControllerAnimated:animated
                                                                          side:side];
}


@end


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
@synthesize centerViewController = m_centerViewController;
@synthesize leftViewController = m_leftViewController;
@synthesize rightViewController = m_rightViewController;


#pragma mark - initializer


#pragma mark - dealloc
/**
 * release side menu viewControllers
 */
- (void)cleanupSideMenuViewControllers
{
    if (self.centerViewController) {
        [self.centerViewController removeFromParentViewController];
        [self.centerViewController.view removeFromSuperview];
    }
    if (self.leftViewController) {
        [self.leftViewController removeFromParentViewController];
        [self.leftViewController.view removeFromSuperview];
    }
    if (self.rightViewController) {
        [self.rightViewController removeFromParentViewController];
        [self.rightViewController.view removeFromSuperview];
    }
    self.centerViewController = nil;
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

    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [self centerView]) {
        // if far from side or no sideMenu viewController, pan event cancels
        CGPoint gestureLocation = [gestureRecognizer locationInView:[self centerView]];
        CGFloat centerViewWidth = [self centerView].frame.size.width;
        BOOL fromLeft = (ABS(gestureLocation.x - 0) < kKZNSideMenuViewControllerPanGestureCollisionDetectionWidth);
        BOOL fromRight = (ABS(gestureLocation.x - centerViewWidth) < kKZNSideMenuViewControllerPanGestureCollisionDetectionWidth);
        if (fromLeft == NO && fromRight == NO) { return NO; }
        if (fromLeft && self.leftViewController == nil) { return NO; }
        if (fromRight && self.rightViewController == nil) { return NO; }

        self.panGestureSide = (fromLeft) ? kKZNSideMenuViewControllerSideLeft : kKZNSideMenuViewControllerSideRight;

        UIViewController *appearViewController = (fromLeft) ? self.leftViewController : self.rightViewController;
        [self.view bringSubviewToFront:[appearViewController view]];
        [self.view bringSubviewToFront:[self centerView]];
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
    if ([self centerView] == nil) { return; }

    CGPoint gestureLocation = [gestureRecognizer translationInView:self.centerView];

    // pan began
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        self.centerViewOrignBeforePanGestureBegan = self.centerView.frame.origin;
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
    self.centerView.frame = (CGRect) {
        .origin = CGPointMake(centerViewOriginX, self.centerView.frame.origin.y),
        .size = self.centerView.frame.size
    };
    if (gestureRecognizer.state == UIGestureRecognizerStateChanged) { return; }

    // pad ended
    BOOL isPresent = YES;
    CGPoint velocity = [gestureRecognizer velocityInView:self.centerView];
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
- (void)setCenterViewController:(UIViewController *)viewController
{
    m_centerViewController = viewController;
    viewController.view.frame = self.centerView.bounds;
    [self.view addSubview:viewController.view];
    [self addChildViewController:viewController];
    [viewController didMoveToParentViewController:self];
}

- (void)setLeftViewController:(UIViewController *)viewController
{
    m_leftViewController = viewController;
    [self setSideMenuViewFrameWithCenterViewFrame:[self centerView].frame];
    [self.view addSubview:viewController.view];
    [self.view bringSubviewToFront:[self centerView]];
    [self addChildViewController:viewController];
    [viewController didMoveToParentViewController:self];
}

- (void)setRightViewController:(UIViewController *)viewController
{
    m_rightViewController = viewController;
    [self setSideMenuViewFrameWithCenterViewFrame:[self centerView].frame];
    [self.view addSubview:viewController.view];
    [self.view bringSubviewToFront:[self centerView]];
    [self addChildViewController:viewController];
    [viewController didMoveToParentViewController:self];
}

- (void)presentSideMenuViewControllerAnimated:(BOOL)animated
                                         side:(KZNSideMenuViewControllerSide)side
{
    UIViewController *appearViewController = nil;
    if (side == kKZNSideMenuViewControllerSideLeft) {
        appearViewController = self.leftViewController;
    }
    if (side == kKZNSideMenuViewControllerSideRight) {
        appearViewController = self.rightViewController;
    }
    if (appearViewController == nil) { return; }
    [self.view bringSubviewToFront:[appearViewController view]];
    [self.view bringSubviewToFront:[self centerView]];

    // delegate
    if (self.KZNSideMenuViewControllerDelegate &&
        [self.KZNSideMenuViewControllerDelegate respondsToSelector:@selector(sideMenuWillAppearViewController:parentViewController:)]) {
        [self.KZNSideMenuViewControllerDelegate sideMenuWillAppearViewController:appearViewController parentViewController:self];
    }

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

        // delegate
        if (weakSelf.KZNSideMenuViewControllerDelegate &&
            [weakSelf.KZNSideMenuViewControllerDelegate respondsToSelector:@selector(sideMenuDidAppearViewController:parentViewController:)]) {
            [weakSelf.KZNSideMenuViewControllerDelegate sideMenuDidAppearViewController:appearViewController parentViewController:self];
        }
    }];
}

- (void)dismissSideMenuViewControllerAnimated:(BOOL)animated
{
    CGFloat centerViewOriginX = [self centerView].frame.origin.x;
    UIViewController *disappearViewController = nil;
    if (centerViewOriginX > 0) { disappearViewController = self.leftViewController; }
    if (centerViewOriginX < 0) { disappearViewController = self.rightViewController; }

    [self.view bringSubviewToFront:[disappearViewController view]];
    [self.view bringSubviewToFront:[self centerView]];

    // delegate
    if (self.KZNSideMenuViewControllerDelegate &&
        [self.KZNSideMenuViewControllerDelegate respondsToSelector:@selector(sideMenuWillDisappearViewController:parentViewController:)]) {
        [self.KZNSideMenuViewControllerDelegate sideMenuWillDisappearViewController:disappearViewController parentViewController:self];
    }

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

        // delegate
        if (weakSelf.KZNSideMenuViewControllerDelegate &&
            [weakSelf.KZNSideMenuViewControllerDelegate respondsToSelector:@selector(sideMenuDidDisappearViewController:parentViewController:)]) {
            [weakSelf.KZNSideMenuViewControllerDelegate sideMenuDidDisappearViewController:disappearViewController parentViewController:self];
        }
    }];
}


#pragma mark - private api
/**
 * center view
 * @return centerViewController.view
 */
- (UIView *)centerView
{
    if (self.centerViewController) { return self.centerViewController.view; }
    return nil;
}

/**
 * set sidemenu view frame
 * @param centerViewFrame centerViewFrame
 */
- (void)setSideMenuViewFrameWithCenterViewFrame:(CGRect)centerViewFrame
{
    if (self.leftViewController) {
        CGRect rect = self.leftViewController.view.frame;
        rect.origin.x = 0;
        rect.size.width = self.widthOfKZNSlideMenu;
        self.leftViewController.view.frame = rect;
    }
    if (self.rightViewController) {
        CGRect rect = self.rightViewController.view.frame;
        rect.origin.x = centerViewFrame.size.width - self.widthOfKZNSlideMenu;
        rect.size.width = self.widthOfKZNSlideMenu;
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
