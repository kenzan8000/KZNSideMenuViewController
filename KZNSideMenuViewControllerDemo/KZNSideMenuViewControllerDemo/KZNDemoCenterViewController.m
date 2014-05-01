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
