//
//  SSElementSelectionCollectionViewController.m
//  JingyouFeiZhao
//
//  Created by caoli on 16/5/14.
//  Copyright © 2016年 QingjianWu. All rights reserved.
//

#import "SSElementSelectionCollectionViewController.h"
#import "SSElement.h"
#import "AppDelegate.h"
#import "SSProductTableViewController.h"
#import "SSElementSelectViewController.h"
@interface SSElementSelectionCollectionViewController ()
@property (nonatomic, strong) NSArray *elements;

@property (nonatomic, strong) NSMutableArray *selectedElements;

@property (nonatomic, strong) SSElement *selectingElement;

@end

@implementation SSElementSelectionCollectionViewController
@synthesize selectingElement;

static NSString * const reuseIdentifier = @"elementSelectCell";
#pragma mark - operation
- (IBAction)close:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)addProduct:(UIBarButtonItem *)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kSSProductAddOperationNotification object:nil userInfo:[NSDictionary dictionaryWithObject:self.selectedElements forKey:@"selectedElements"]];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - properties

-(NSArray*)elements
{
    if (!_elements) {
        AppDelegate *app = [[UIApplication sharedApplication] delegate];
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (NSDictionary* item in [app elementPlistDatabase]) {
            SSElement *element = [SSElement elementWithDict:item];
            [array addObject:element];
        }
        _elements = [array copy];
    }
    return _elements;
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kSSElementChangeOperationNotification object:nil];
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
    imageView.image = [UIImage imageNamed:element.elementName];
    
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
    
   // [self performSegueWithIdentifier:@"toSelectElementView" sender:self];
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
    
    NSLog(@"%@", self.selectedElements);
  //  [self.selectedElements removeObject:[self.elements objectAtIndex:indexPath.row]];
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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    static NSMutableArray *indexPaths = nil;
    if ([segue.identifier isEqualToString:@"toSelectElementView"]) {
        if(!indexPaths){
            indexPaths = [[NSMutableArray alloc] init];
        }
        
        for (NSIndexPath *indexPath in [self.collectionView indexPathsForSelectedItems]) {
            if (! [indexPaths containsObject:indexPath]) {
                SSElementSelectViewController *selectVC = (SSElementSelectViewController*)segue.destinationViewController;
                NSLog(@"%@", [self.collectionView indexPathsForSelectedItems]);
                selectVC.element = [self.elements objectAtIndex:indexPath.row];
                NSLog(@"passing element %@", selectVC.element);
            }
        }
        
        indexPaths = [[self.collectionView indexPathsForSelectedItems] mutableCopy];
        
    } else {
        segue = nil; 
    }
}

@end
