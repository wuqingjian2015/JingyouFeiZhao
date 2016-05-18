//
//  SSMakeStepsCollectionViewController.m
//  JingyouFeiZhao
//
//  Created by caoli on 16/5/18.
//  Copyright © 2016年 QingjianWu. All rights reserved.
//

#import "SSMakeStepsCollectionViewController.h"
#import "AppDelegate+plistDatabase.h"
#import "SSElementSelectionCollectionViewController.h"
#import "SSProductTableViewController.h"

#import "SSProduct.h"

@interface SSMakeStepsCollectionViewController ()

@property (nonatomic, strong)  NSArray *stepNames;
@property (nonatomic, strong)  AppDelegate *app;

@property (nonatomic, strong)  NSDictionary *stepsElementMap;

@property (nonatomic, strong) SSProduct *productToAdd;


@end

@implementation SSMakeStepsCollectionViewController
@synthesize stepNames = _stepNames;
@synthesize app = _app;
@synthesize stepsElementMap = _stepsElementMap;
@synthesize productToAdd = _productToAdd;

static NSString * const reuseIdentifier = @"makeStepCell";

-(void)addElement:(NSNotification*)notification
{
    NSMutableArray *elementsToAdd = notification.userInfo[@"selectedElements"];
    [self.productToAdd addElementsFromArray:elementsToAdd];
}

#pragma mark - properties
-(AppDelegate*)app{
    if (!_app) {
        _app = [[UIApplication sharedApplication] delegate];
    }
    return _app;
}

-(SSProduct*)productToAdd
{
    if (!_productToAdd) {
        _productToAdd = [SSProduct productWithName:@"精油皂"];
    }
    return _productToAdd;
}

-(NSArray*)stepNames
{
    if (!_stepNames) {
        _stepNames = [[self app] elementV2DatabaseNames];
    }
    return _stepNames;
}


#pragma mark - lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    //[self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addElement:) name:kSSElementAddOperationNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kSSElementAddOperationNotification object:nil];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"toElementCell"]) {
        SSElementSelectionCollectionViewController *elementVC = (SSElementSelectionCollectionViewController*)segue.destinationViewController;        NSIndexPath *indexPath = [[self.collectionView indexPathsForSelectedItems] firstObject];
        if (elementVC) {
            elementVC.elements = [[self app] getDatabaseByName:[self.stepNames objectAtIndex:indexPath.row]];
        } else {
            NSLog(@"target object is nil.");
        }
    }
    if ([segue.identifier isEqualToString:@"toProductList"]) {
        SSProductTableViewController* productVC = (SSProductTableViewController*)segue.destinationViewController;
        productVC.productToAdd = self.productToAdd;
        self.productToAdd = nil;
    }
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
   return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  return [self.stepNames count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    NSString *name = [self.stepNames objectAtIndex:indexPath.row];
    
    // Configure the cell
    UIImageView *imageView = [cell.contentView viewWithTag:101];
    imageView.image = [UIImage imageNamed:name];
    
    UILabel *nameLabel = [cell.contentView viewWithTag:102];
    nameLabel.text = [self.app localizedNamesForStep:name];
    
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

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
