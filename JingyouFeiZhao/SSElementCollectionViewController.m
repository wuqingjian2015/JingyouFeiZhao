//
//  SSElementCollectionViewController.m
//  JingyouFeiZhao
//
//  Created by caoli on 16/5/14.
//  Copyright © 2016年 QingjianWu. All rights reserved.
//

#import "SSConstants.h"
#import "SSElementCollectionViewController.h"
#import "AppDelegate+plistDatabase.h"
#import "SSElement.h"

@interface SSElementCollectionViewController ()

@property (nonatomic, strong) NSMutableArray *elements;

@end

@implementation SSElementCollectionViewController

static NSString * const reuseIdentifier = @"elementCell";

#pragma mark - operations

-(void)addELement:(NSNotification*)notification
{
    SSElement *element = notification.userInfo[@"addedElement"];
    if (element) {
        [self.elements addObject:element];
        [self.collectionView reloadData];
    }
}
- (IBAction)removeItemByLongPress:(UILongPressGestureRecognizer *)sender {
    
    UICollectionViewCell *cell = (UICollectionViewCell*)sender.view;
    
    
    CGRect viewFrame = cell.frame;
    CGPoint point = viewFrame.origin;
    point.x += viewFrame.size.width;
    CGRect frame = CGRectMake(point.x, point.y, 3, 3);
    
    UIView *view = [[UIView alloc] initWithFrame:frame];
    [cell addSubview:view];
    cell.backgroundColor = [UIColor redColor];
    
}

#pragma mark - properties

-(NSArray*)elements
{
    if (!_elements) {
        AppDelegate *app = [[UIApplication sharedApplication] delegate];
        _elements = [app elementPlistDatabase];
    }
    return _elements;
}

#pragma mark -lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    //[self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    self.navigationItem.title = @"成分表格";
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addELement:) name:kSSElementAddOperationNotification object:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kSSElementAddOperationNotification object:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.elements count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    SSElement *element = [self.elements objectAtIndex:indexPath.row];
    
    UIImageView *imageView = [cell.contentView viewWithTag:101];
    imageView.image = [UIImage imageNamed:element.elementImage];
    if ([element.elementName containsString:@"TEST"]) {
        NSLog(@"test3 %@", element.elementImage);
    }
    
    UILabel *nameLabel = [cell.contentView viewWithTag:102];
    nameLabel.text = element.elementName;
    cell.backgroundColor = [UIColor yellowColor];
    // Configure the cell
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>


/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}


@end
