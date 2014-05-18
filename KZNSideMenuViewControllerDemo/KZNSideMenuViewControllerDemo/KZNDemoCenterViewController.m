#import "KZNDemoCenterViewController.h"


#pragma mark - KZNDemoCenterViewController
@implementation KZNDemoCenterViewController


#pragma mark - initializer


#pragma mark - release
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - lifecycle
- (void)loadView
{
    [super loadView];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(leftViewControllerCellDidSelectedWithNotification:)
                                                 name:@"KZNDemoLeftViewControllerCellDidSelected"
                                               object:nil];

    [[self sideMenuViewController] setKZNSideMenuViewControllerDelegate:self];
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


#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return 16;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *tableViewCellIdentifier = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableViewCellIdentifier];
    if (!cell) {
        cell = [UITableViewCell new];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@", @(indexPath.row)];

    return cell;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath
                                  animated:YES];
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


#pragma mark - notification
- (void)leftViewControllerCellDidSelectedWithNotification:(NSNotification *)notification
{
    if (notification.userInfo == nil) { return; }
    if ([[notification.userInfo allKeys] containsObject:@"title"]) {
        self.title = [NSString stringWithFormat:@"%@", notification.userInfo[@"title"]];
        [self dismissSideMenuViewControllerAnimated:YES];
    }
}

@end
