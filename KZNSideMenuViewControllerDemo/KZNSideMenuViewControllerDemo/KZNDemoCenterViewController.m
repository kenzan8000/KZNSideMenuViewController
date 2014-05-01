#import "KZNDemoCenterViewController.h"


#pragma mark - KZNDemoCenterViewController
@implementation KZNDemoCenterViewController


#pragma mark - initializer


#pragma mark - release


#pragma mark - lifecycle
- (void)loadView
{
    [super loadView];

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard"
                                                         bundle:[NSBundle mainBundle]];
    self.leftViewController = [storyboard instantiateViewControllerWithIdentifier:@"KZNDemoLeftViewController"];
    self.rightViewController = [storyboard instantiateViewControllerWithIdentifier:@"KZNDemoRightViewController"];
    [self setKZNSideMenuViewControllerDelegate:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}


#pragma mark - KZNSideMenuViewController
/**
 * called before SideMenu will appear
 * @param appearViewController appearing viewController
 * @param parentViewController parent viewController
 */
- (void)sideMenuWillAppearViewController:(UIViewController *)appearViewController
                    parentViewController:(UIViewController *)parentViewController
{
}

/**
 * called after SideMenu appears
 * @param appearViewController appearing viewController
 * @param parentViewController parent viewController
 */
- (void)sideMenuDidAppearViewController:(UIViewController *)appearViewController
                   parentViewController:(UIViewController *)parentViewController
{
}

/**
 * called before SideMenu will disappear
 * @param disappearViewControllerppearViewController disappearing viewController
 * @param parentViewController parent viewController
 */
- (void)sideMenuWillDisappearViewController:(UIViewController *)disappearViewController
                       parentViewController:(UIViewController *)parentViewController
{
}

/**
 * called after SideMenu disappears
 * @param disappearViewController disappearing viewController
 * @param parentViewController parent viewController
 */
- (void)sideMenuDidDisappearViewController:(UIViewController *)disappearViewController
                      parentViewController:(UIViewController *)parentViewController
{
}


#pragma mark - event listener
- (IBAction)touchedUpInsideWithLeftBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    if ([self isPresentSideMenuViewController]) {
        [self dismissSideMenuViewControllerAnimated:YES];
    }
    else {
        [self presentSideMenuViewControllerAnimated:YES
                                               side:kKZNSideMenuViewControllerSideLeft];
    }
}

- (IBAction)touchedUpInsideWithRightBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    if ([self isPresentSideMenuViewController]) {
        [self dismissSideMenuViewControllerAnimated:YES];
    }
    else {
        [self presentSideMenuViewControllerAnimated:YES
                                               side:kKZNSideMenuViewControllerSideRight];
    }

}


@end
