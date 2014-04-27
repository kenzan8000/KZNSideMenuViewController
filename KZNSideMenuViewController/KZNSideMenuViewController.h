#pragma mark - constant
/// side of KZNSideMenu
typedef NS_ENUM(NSInteger, KZNSideMenuViewControllerSide) {
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
 * @return Should SideMenu appear? YES or NO
 */
- (BOOL)sideMenuShouldAppearViewController:(UIViewController *)appearViewController
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
 * @return Should SideMenu disappear? YES or NO
 */
- (BOOL)sideMenuShouldDisappearViewController:(UIViewController *)disappearViewController
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
/// animation duration
@property (nonatomic, assign) CGFloat animationDurationOfKZNSlideMenu;
/// SideMenu width
@property (nonatomic, assign) CGFloat widthOfKZNSlideMenu;


#pragma mark - api
/**
 * if SideMenu appears or not
 * @return YES or NO
 */
- (BOOL)isPresentSideMenuViewController;

/**
 * present SideMenu
 * @param viewController viewController
 * @param animated YES or NO
 * @param side side of KZNSideMenu
 */
- (void)presentSideMenuViewController:(UIViewController *)viewController
                             animated:(BOOL)animated
                                 side:(KZNSideMenuViewControllerSide)side;

/**
 * dismiss SideMenu
 * @param animated YES or NO
 * @param side side of KZNSideMenu
 */
- (void)dismissSideMenuViewControllerAnimated:(BOOL)animated;


@end