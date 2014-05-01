#pragma mark - constant
/// side of KZNSideMenu
typedef NS_ENUM(NSInteger, KZNSideMenuViewControllerSide) {
    kKZNSideMenuViewControllerSideNone,
    kKZNSideMenuViewControllerSideLeft,
    kKZNSideMenuViewControllerSideRight,
};


#pragma mark - KZNSideMenuViewControllerDelegate
/// KZNSideMenuDelegate
@protocol KZNSideMenuViewControllerDelegate <NSObject>


@optional
/**
 * called before SideMenu will appear
 * @param appearViewController appearing viewController
 * @param parentViewController parent viewController
 */
- (void)sideMenuWillAppearViewController:(UIViewController *)appearViewController
                    parentViewController:(UIViewController *)parentViewController;

/**
 * called after SideMenu appears
 * @param appearViewController appearing viewController
 * @param parentViewController parent viewController
 */
- (void)sideMenuDidAppearViewController:(UIViewController *)appearViewController
                   parentViewController:(UIViewController *)parentViewController;

/**
 * called before SideMenu will disappear
 * @param disappearViewControllerppearViewController disappearing viewController
 * @param parentViewController parent viewController
 */
- (void)sideMenuWillDisappearViewController:(UIViewController *)disappearViewController
                       parentViewController:(UIViewController *)parentViewController;

/**
 * called after SideMenu disappears
 * @param disappearViewController disappearing viewController
 * @param parentViewController parent viewController
 */
- (void)sideMenuDidDisappearViewController:(UIViewController *)disappearViewController
                      parentViewController:(UIViewController *)parentViewController;


@end


#pragma mark - KZNSideMenuViewController
/// UIViewController which has Sidemenu like Facebook.app
@interface KZNSideMenuViewController : UIViewController {
}


#pragma mark - properties
/// left sidemenu
@property (nonatomic, strong) UIViewController *leftViewController;
/// right sidemenu
@property (nonatomic, strong) UIViewController *rightViewController;

/// delegate
@property (nonatomic, weak) IBOutlet id<KZNSideMenuViewControllerDelegate> KZNSideMenuViewControllerDelegate;

/// if SideMenu appears or not
@property (nonatomic, assign) BOOL isPresentSideMenuViewController;
/// animation duration
@property (nonatomic, assign) CGFloat animationDurationOfKZNSlideMenu;
/// SideMenu width
@property (nonatomic, assign) CGFloat widthOfKZNSlideMenu;


#pragma mark - api
/**
 * present SideMenu
 * @param animated YES or NO
 * @param side side of KZNSideMenu
 */
- (void)presentSideMenuViewControllerAnimated:(BOOL)animated
                                         side:(KZNSideMenuViewControllerSide)side;

/**
 * dismiss SideMenu
 * @param animated YES or NO
 * @param side side of KZNSideMenu
 */
- (void)dismissSideMenuViewControllerAnimated:(BOOL)animated;


@end
