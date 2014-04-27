#import "KZNSideMenuViewController.h"


#pragma mark - constant
/// initial animation duration
static const CGFloat kKZNSideMenuViewControllerAnimationDuration = 0.6f;
/// initial sidemenu width
#define kKZNSideMenuViewControllerWidth [[UIScreen mainScreen] bounds].size.width * 0.8f


#pragma mark - interface
@interface KZNSideMenuViewController () {
}


#pragma mark - properties
/// left sidemenu
@property (nonatomic, strong) UIViewController *leftViewController;
/// right sidemenu
@property (nonatomic, strong) UIViewController *rightViewController;


@end


#pragma mark - implementation
@implementation KZNSideMenuViewController


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

- (void)dealloc
{
    [self cleanupSideMenuViewControllers];
}


#pragma mark - lifecycle
- (void)loadView
{
    [super loadView];
    self.animationDurationOfKZNSlideMenu = kKZNSideMenuViewControllerAnimationDuration;
    self.widthOfKZNSlideMenu = kKZNSideMenuViewControllerWidth;
}


#pragma mark - public api
- (BOOL)isPresentSideMenuViewController
{
    return (self.leftViewController || self.rightViewController);
}

- (void)presentSideMenuViewController:(UIViewController *)viewController
                             animated:(BOOL)animated
                                 side:(KZNSideMenuViewControllerSide)side
{
    if ([self isPresentSideMenuViewController]) { return; }
    if (viewController == nil) { return; }

    // position
    CGPoint offset = [self centerView].frame.origin;
    if (side == kKZNSideMenuViewControllerSideLeft) {
        offset.x = self.widthOfKZNSlideMenu;
    }
    else if (side == kKZNSideMenuViewControllerSideRight) {
        offset.x = -self.widthOfKZNSlideMenu;
    }

    // viewController
    if (side == kKZNSideMenuViewControllerSideLeft) {
        self.leftViewController = viewController;
    }
    else if (side == kKZNSideMenuViewControllerSideRight) {
        self.rightViewController = viewController;
    }
    [self setSideMenuViewFrameWithCenterViewFrame:[self centerView].frame];
    if ([[self centerView] superview]) {
        [[self centerView] insertSubview:viewController.view
                                         atIndex:0];
    }

    // present
    [self moveSideMenuWithCenterViewFrame:(CGRect){.origin = offset, .size=[self centerView].frame.size}
                                 animated:animated
                               completion:^ (BOOL finished) {
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
        [weakSelf cleanupSideMenuViewControllers];
    }];
}


#pragma mark - private api
- (UIView *)centerView
{
    if (self.navigationController) {
        return self.navigationController.view;
    }
    return self.view;
}

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


@end
