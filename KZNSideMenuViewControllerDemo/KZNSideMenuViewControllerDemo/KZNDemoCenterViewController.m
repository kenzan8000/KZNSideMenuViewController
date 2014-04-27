#import "KZNDemoCenterViewController.h"


#pragma mark - KZNDemoCenterViewController
@implementation KZNDemoCenterViewController


#pragma mark - initializer


#pragma mark - release


#pragma mark - lifecycle
- (void)loadView
{
    [super loadView];
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


#pragma mark - event listener
- (IBAction)touchedUpInsideWithLeftBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    if ([self isPresentSideMenuViewController]) {
        [self dismissSideMenuViewControllerAnimated:YES];
    }
    else {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard"
                                                             bundle:[NSBundle mainBundle]];
        UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"KZNDemoLeftViewController"];
        [self presentSideMenuViewController:viewController
                                   animated:YES
                                       side:kKZNSideMenuViewControllerSideLeft];
    }
}

- (IBAction)touchedUpInsideWithRightBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    if ([self isPresentSideMenuViewController]) {
        [self dismissSideMenuViewControllerAnimated:YES];
    }
    else {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard"
                                                             bundle:[NSBundle mainBundle]];
        UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"KZNDemoRightViewController"];
        [self presentSideMenuViewController:viewController
                                   animated:YES
                                       side:kKZNSideMenuViewControllerSideRight];
    }

}


@end
