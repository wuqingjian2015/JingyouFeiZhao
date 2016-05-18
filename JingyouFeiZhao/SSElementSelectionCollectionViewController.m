//
//  SSElementSelectionCollectionViewController.m
//  JingyouFeiZhao
//
//  Created by caoli on 16/5/14.
//  Copyright © 2016年 QingjianWu. All rights reserved.
//

#import "SSElementSelectionCollectionViewController.h"
#import "SSElement.h"
#import "AppDelegate+plistDatabase.h"
#import "SSProductTableViewController.h"
#import "SSElementSelectViewController.h"
@interface SSElementSelectionCollectionViewController ()


@property (nonatomic, strong) NSMutableArray *selectedElements;

@property (nonatomic, strong) SSElement *selectingElement;

@property (nonatomic, strong) NSMutableArray *selectedIndexPaths;

@end

@implementation SSElementSelectionCollectionViewController
@synthesize selectingElement;
@synthesize elements = _elements;

static NSString * const reuseIdentifier = @"elementSelectCell";

#pragma mark - operation
- (IBAction)close:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)addProduct:(UIBarButtonItem *)sender {
    if ([self.selectedElements count] > 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kSSElementAddOperationNotification object:nil userInfo:[NSDictionary dictionaryWithObject:self.selectedElements forKey:@"selectedElements"]];
    }
    [self.navigationController popViewControllerAnimated:YES];
   // [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - properties
-(NSMutableArray*)selectedIndexPaths
{
    if (!_selectedIndexPaths) {
        _selectedIndexPaths = [[NSMutableArray alloc] init];
    }
    return _selectedIndexPaths;
}

-(NSArray*)elements
{
    /*
    if (!_elements) {
        AppDelegate *app = [[UIApplication sharedApplication] delegate];
        _elements = [app elementPlistDatabase];
    }*/
    
    return _elements;
}

-(void)setElements:(NSArray *)elements
{
    _elements = elements;
}

-(NSArray*)selectedElements
{
    if (!_selectedElements) {
        _selectedElements = [[NSMutableArray alloc] init];
    }
    return _selectedElements;
}

#pragma mark - Notifications
-(void)changeElement:(NSNotification*)notification
{
    SSElement *selectedElement = notification.userInfo[@"selectedElement"];
    
    if(selectedElement){
        [self.selectedElements addObject:selectedElement];
        NSLog(@"add %@", selectedElement);
    }
}

-(void)disSelectElement:(NSNotification*)notification
{
    NSIndexPath *indexPath = notification.userInfo[@"indexPath"];
    [self.collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

#pragma mark - lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    //[self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    self.navigationItem.title = @"选择成分";
    // Do any additional setup after loading the view.
    self.collectionView.allowsMultipleSelection = YES;
    self.collectionView.allowsSelection = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeElement:) name:kSSElementChangeOperationNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(disSelectElement:) name:kSSElementDisselectOperationNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kSSElementDisselectOperationNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kSSElementChangeOperationNotification object:nil];
}


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
        NSLog(@"%@", element.elementImage);
    }
    UILabel *nameLabel = [cell.contentView viewWithTag:102];
    nameLabel.text = element.elementName;
    cell.backgroundColor = [UIColor yellowColor];
    
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    
    
    cell.selectedBackgroundView.backgroundColor = [UIColor blueColor];

    // Configure the cell
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}



// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

    SSElement *element = [self.elements objectAtIndex:indexPath.row];
    self.selectingElement = element;
}

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectingElement = nil;
    SSElement *element = [self.elements objectAtIndex:indexPath.row];
    NSArray * selecteds = [self.selectedElements copy];
    NSLog(@"%@", self.selectedElements);
    for (SSElement *item in selecteds) {
        if ([item.elementName isEqualToString:element.elementName]) {
            [self.selectedElements removeObject:item];
        }
    }
#ifdef DEBUG
    NSLog(@"%@", self.selectedIndexPaths);
#endif
    [self.selectedIndexPaths removeObject:indexPath];
#ifdef DEBUG
    NSLog(@"%@", self.selectedIndexPaths);
    NSLog(@"%@", self.selectedElements);
#endif
}

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
#pragma mark - navigation
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"toSelectElementView"]) {
        NSMutableArray *temp = [[self.collectionView indexPathsForSelectedItems] mutableCopy];
        [temp removeObjectsInArray:self.selectedIndexPaths];
        for (NSIndexPath *indexPath in temp) {
                SSElementSelectViewController *selectVC = (SSElementSelectViewController*)segue.destinationViewController;
                selectVC.element = [self.elements objectAtIndex:indexPath.row];
                selectVC.indexPath = indexPath;
                NSLog(@"passing element %@", selectVC.element);
            break;
        }
        [self.selectedIndexPaths addObjectsFromArray:temp];
    } 
}

@end
