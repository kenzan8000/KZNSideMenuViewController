#import "KZNSideMenuViewController.h"


#pragma mark - constant
/// initial animation duration
static const CGFloat kKZNSideMenuViewControllerAnimationDuration = 0.6f;
/// initial sidemenu width
#define kKZNSideMenuViewControllerWidth [[UIScreen mainScreen] bounds].size.width * 0.8f


#pragma mark - interface
@interface KZNSideMenuViewController () <UIGestureRecognizerDelegate> {
}


#pragma mark - properties
/// left sidemenu
@property (nonatomic, strong) UIViewController *leftViewController;
/// right sidemenu
@property (nonatomic, strong) UIViewController *rightViewController;
/// pan geture recognizer
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
/// tap geture recognizer
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;


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

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
       shouldReceiveTouch:(UITouch *)touch
{
    return YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
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
}

- (void)tappedWithTapGestureRecognizer:(UITapGestureRecognizer *)gestureRecognizer
{
    [self dismissSideMenuViewControllerAnimated:YES];
}

/*
#pragma mark -
#pragma mark - UIGestureRecognizer Callbacks

// this method handles any pan event
// and sets the navigation controller's frame as needed
- (void) handlePan:(UIPanGestureRecognizer *)recognizer {
    UIView *view = [self.centerViewController view];

    if(recognizer.state == UIGestureRecognizerStateBegan) {
        // remember where the pan started
        panGestureOrigin = view.frame.origin;
        self.panDirection = MFSideMenuPanDirectionNone;
    }

    if(self.panDirection == MFSideMenuPanDirectionNone) {
        CGPoint translatedPoint = [recognizer translationInView:view];
        if(translatedPoint.x > 0) {
            self.panDirection = MFSideMenuPanDirectionRight;
            if(self.leftMenuViewController && self.menuState == MFSideMenuStateClosed) {
                [self leftMenuWillShow];
            }
        }
        else if(translatedPoint.x < 0) {
            self.panDirection = MFSideMenuPanDirectionLeft;
            if(self.rightMenuViewController && self.menuState == MFSideMenuStateClosed) {
                [self rightMenuWillShow];
            }
        }
    }

    if((self.menuState == MFSideMenuStateRightMenuOpen && self.panDirection == MFSideMenuPanDirectionLeft)
       || (self.menuState == MFSideMenuStateLeftMenuOpen && self.panDirection == MFSideMenuPanDirectionRight)) {
        self.panDirection = MFSideMenuPanDirectionNone;
        return;
    }

    if(self.panDirection == MFSideMenuPanDirectionLeft) {
        [self handleLeftPan:recognizer];
    } else if(self.panDirection == MFSideMenuPanDirectionRight) {
        [self handleRightPan:recognizer];
    }
}

- (void) handleRightPan:(UIPanGestureRecognizer *)recognizer {
    if(!self.leftMenuViewController && self.menuState == MFSideMenuStateClosed) return;

    UIView *view = [self.centerViewController view];

    CGPoint translatedPoint = [recognizer translationInView:view];
    CGPoint adjustedOrigin = panGestureOrigin;
    translatedPoint = CGPointMake(adjustedOrigin.x + translatedPoint.x,
                                  adjustedOrigin.y + translatedPoint.y);

    translatedPoint.x = MAX(translatedPoint.x, -1*self.rightMenuWidth);
    translatedPoint.x = MIN(translatedPoint.x, self.leftMenuWidth);
    if(self.menuState == MFSideMenuStateRightMenuOpen) {
        // menu is already open, the most the user can do is close it in this gesture
        translatedPoint.x = MIN(translatedPoint.x, 0);
    } else {
        // we are opening the menu
        translatedPoint.x = MAX(translatedPoint.x, 0);
    }

    if(recognizer.state == UIGestureRecognizerStateEnded) {
        CGPoint velocity = [recognizer velocityInView:view];
        CGFloat finalX = translatedPoint.x + (.35*velocity.x);
        CGFloat viewWidth = view.frame.size.width;

        if(self.menuState == MFSideMenuStateClosed) {
            BOOL showMenu = (finalX > viewWidth/2) || (finalX > self.leftMenuWidth/2);
            if(showMenu) {
                self.panGestureVelocity = velocity.x;
                [self setMenuState:MFSideMenuStateLeftMenuOpen];
            } else {
                self.panGestureVelocity = 0;
                [self setCenterViewControllerOffset:0 animated:YES completion:nil];
            }
        } else {
            BOOL hideMenu = (finalX > adjustedOrigin.x);
            if(hideMenu) {
                self.panGestureVelocity = velocity.x;
                [self setMenuState:MFSideMenuStateClosed];
            } else {
                self.panGestureVelocity = 0;
                [self setCenterViewControllerOffset:adjustedOrigin.x animated:YES completion:nil];
            }
        }

        self.panDirection = MFSideMenuPanDirectionNone;
    } else {
        [self setCenterViewControllerOffset:translatedPoint.x];
    }
}

- (void) handleLeftPan:(UIPanGestureRecognizer *)recognizer {
    if(!self.rightMenuViewController && self.menuState == MFSideMenuStateClosed) return;

    UIView *view = [self.centerViewController view];

    CGPoint translatedPoint = [recognizer translationInView:view];
    CGPoint adjustedOrigin = panGestureOrigin;
    translatedPoint = CGPointMake(adjustedOrigin.x + translatedPoint.x,
                                  adjustedOrigin.y + translatedPoint.y);

    translatedPoint.x = MAX(translatedPoint.x, -1*self.rightMenuWidth);
    translatedPoint.x = MIN(translatedPoint.x, self.leftMenuWidth);
    if(self.menuState == MFSideMenuStateLeftMenuOpen) {
        // don't let the pan go less than 0 if the menu is already open
        translatedPoint.x = MAX(translatedPoint.x, 0);
    } else {
        // we are opening the menu
        translatedPoint.x = MIN(translatedPoint.x, 0);
    }

    [self setCenterViewControllerOffset:translatedPoint.x];

    if(recognizer.state == UIGestureRecognizerStateEnded) {
        CGPoint velocity = [recognizer velocityInView:view];
        CGFloat finalX = translatedPoint.x + (.35*velocity.x);
        CGFloat viewWidth = view.frame.size.width;

        if(self.menuState == MFSideMenuStateClosed) {
            BOOL showMenu = (finalX < -1*viewWidth/2) || (finalX < -1*self.rightMenuWidth/2);
            if(showMenu) {
                self.panGestureVelocity = velocity.x;
                [self setMenuState:MFSideMenuStateRightMenuOpen];
            } else {
                self.panGestureVelocity = 0;
                [self setCenterViewControllerOffset:0 animated:YES completion:nil];
            }
        } else {
            BOOL hideMenu = (finalX < adjustedOrigin.x);
            if(hideMenu) {
                self.panGestureVelocity = velocity.x;
                [self setMenuState:MFSideMenuStateClosed];
            } else {
                self.panGestureVelocity = 0;
                [self setCenterViewControllerOffset:adjustedOrigin.x animated:YES completion:nil];
            }
        }
    } else {
        [self setCenterViewControllerOffset:translatedPoint.x];
    }
}

- (void)centerViewControllerTapped:(id)sender {
    if(self.menuState != MFSideMenuStateClosed) {
        [self setMenuState:MFSideMenuStateClosed];
    }
}

- (void)setUserInteractionStateForCenterViewController {
    // disable user interaction on the current stack of view controllers if the menu is visible
    if([self.centerViewController respondsToSelector:@selector(viewControllers)]) {
        NSArray *viewControllers = [self.centerViewController viewControllers];
        for(UIViewController* viewController in viewControllers) {
            viewController.view.userInteractionEnabled = (self.menuState == MFSideMenuStateClosed);
        }
    }
}
*/

#pragma mark - lifecycle
- (void)loadView
{
    [super loadView];
    self.animationDurationOfKZNSlideMenu = kKZNSideMenuViewControllerAnimationDuration;
    self.widthOfKZNSlideMenu = kKZNSideMenuViewControllerWidth;
    [self addGestureRecognizers];
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
    __weak __typeof(self) weakSelf = self;
    [self moveSideMenuWithCenterViewFrame:(CGRect){.origin = offset, .size=[self centerView].frame.size}
                                 animated:animated
                               completion:^ (BOOL finished) {
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
        [weakSelf cleanupSideMenuViewControllers];
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
    if ([self isPresentSideMenuViewController]) {
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
