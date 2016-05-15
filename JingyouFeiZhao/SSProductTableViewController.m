//
//  SSProductTableViewController.m
//  JingyouFeiZhao
//
//  Created by caoli on 16/5/14.
//  Copyright © 2016年 QingjianWu. All rights reserved.
//

#import "SSProductTableViewController.h"
#import "SSProduct.h"
#import "SSProductDetailTableViewController.h"
#import "AppDelegate.h"
@interface SSProductTableViewController ()

@property (nonatomic, strong) NSMutableArray *products;


@end

@implementation SSProductTableViewController

#pragma mark - properties
-(NSMutableArray*)products
{
    if (!_products) {
        AppDelegate *app = [[UIApplication sharedApplication] delegate];
        NSMutableArray *arrayModle = [[NSMutableArray alloc] init];
        for (NSDictionary* prodcutDict  in app.productPlistDatabase) {
            SSProduct* product = [SSProduct productWithDict:prodcutDict];
            [arrayModle addObject:product];
        }
        _products = [arrayModle mutableCopy];
        
    }
    return _products;
}

#pragma mark - operation
-(void)addProduction:(NSNotification*)notification
{
    NSArray *selectedElements = notification.userInfo[@"selectedElements"];
    if (selectedElements) {
        SSProduct *product = [[SSProduct alloc] init];
        product.productName = @"new product";
        product.createdDate = [NSDate date];
        NSMutableArray *arraym = [[NSMutableArray alloc] init];
        for (SSElement *element in selectedElements) {
            NSDictionary* dic = [[NSDictionary alloc] initWithObjectsAndKeys:element.elementName, @"elementName", element.quantity, @"quantity", element.cost, @"cost", element.quantity_unit, @"quantity_unit", nil];
            [arraym addObject:dic];
        }
        product.composition = [arraym copy];
        [self.products addObject:product];
        [self.tableView reloadData];
    }
}

#pragma mark - lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addProduction:) name:kSSProductAddOperationNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)saveProducts
{
    if ([[[UIApplication sharedApplication] delegate] respondsToSelector:@selector(saveProducts:)]) {
        [[[UIApplication sharedApplication] delegate] performSelector:@selector(saveProducts:) withObject:self.products];
    }
}

- (void)dealloc
{
    [self saveProducts];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:kSSProductAddOperationNotification object:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.products count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *reusedIdentifier = @"productCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusedIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusedIdentifier];
    }
    SSProduct *product = [self.products objectAtIndex:indexPath.row];
    
    UIImageView *imageView = [cell viewWithTag:101];
    imageView.image = [UIImage imageNamed:@"product.png"];
    
    UILabel *nameLable = [cell viewWithTag:102];
    nameLable.text = product.productName;
    
    UILabel *dateLable = [cell viewWithTag:103];
  
    dateLable.text = [NSDateFormatter localizedStringFromDate:product.createdDate dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterNoStyle];
    [dateLable sizeToFit];
    
    // Configure the cell...
    
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [self.products removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"showProductDetail"]) {
        SSProductDetailTableViewController *detail = (SSProductDetailTableViewController*) segue.destinationViewController;
        detail.product = [self.products objectAtIndex:self.tableView.indexPathForSelectedRow.row];
    }
}


@end
