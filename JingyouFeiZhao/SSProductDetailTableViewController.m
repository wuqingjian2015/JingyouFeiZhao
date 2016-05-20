//
//  SSProductDetailTableViewController.m
//  JingyouFeiZhao
//
//  Created by caoli on 16/5/14.
//  Copyright © 2016年 QingjianWu. All rights reserved.
//

#import "SSProductDetailTableViewController.h"
#import "SSElement.h"
#import "AppDelegate+plistDatabase.h"
#import "SSConstants.h"
#import "SSHeaderView.h"

#import "SSConstants.h"

@interface SSProductDetailTableViewController ()

@property (nonatomic, strong) NSArray *composition;

//@property (nonatomic, strong) NSDictionary *priceDict;

@end

@implementation SSProductDetailTableViewController

static NSString *reusedIdentifier  = @"productDetailCell";

#pragma mark - operations

-(void)changeProductName:(NSNotification*)notification
{
    NSString *productName = notification.userInfo[@"changedName"];
    if (productName) {
        self.product.productName = productName;
    }
}
- (IBAction)dismissKeyBoard:(id)sender {

}

#pragma mark - properties
-(NSArray*)composition
{
    if (!_composition) {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (NSDictionary *component in [self.product composition]) {
            SSElement *element = nil;
            if ([component isKindOfClass:[SSElement class]]) {
                element = (SSElement*) component;
            } else {
                element = [SSElement elementWithDict:component];
            }
            
            [array addObject:element];
        }
        _composition = [array copy];
    }
    return _composition;
}

-(NSDictionary*)priceDict
{
    static NSDictionary* _priceDict = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        AppDelegate *app = [[UIApplication sharedApplication] delegate];
        _priceDict = [app priceList];
    });
    return _priceDict;
}

#pragma mark - lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.title = self.product.productName;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeProductName:) name:kSSProductChangeNameOperationNotification object:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.composition count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusedIdentifier forIndexPath:indexPath];
    SSElement *element = [self.composition objectAtIndex:indexPath.row];
    
    UIImageView *imageView = [cell viewWithTag:101];
    imageView.image = [UIImage imageNamed:element.elementImage];
    CGRect frame = imageView.frame;
    frame.size.width = kScreenWidth;
    frame.size.height = kScreenHeight;
    imageView.frame = frame;
    
    UILabel *nameLabel = [cell viewWithTag:102];
    nameLabel.text = element.elementName;
    float price = [[self priceDict][element.elementName] floatValue];
    float quantity = [element.quantity floatValue];
    float cost = quantity * price;
   

    
    UILabel *quantityLabel = [cell viewWithTag:103];
    quantityLabel.text = [NSString stringWithFormat:@"%@ %@ %.2f元", element.quantity, element.quantity_unit, cost];

    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 40)];
    UILabel *costLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 0, view.frame.size.width, view.frame.size.height)];
    

    float totalCost = 0;
    for (SSElement *element in self.composition) {
        float price = [[self priceDict][element.elementName] floatValue];
        float quantity = [element.quantity floatValue];
        float cost = quantity * price;
        totalCost += cost;
    }
    costLabel.text = [NSString stringWithFormat:@"小计 %.2f 元", totalCost ];
    [view addSubview:costLabel];
    return view;
}
/*
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
   // UIView * view = [[UIView alloc] init];
    SSHeaderView *headerView = [[[NSBundle mainBundle] loadNibNamed:@"SSHeaderView" owner:nil options:nil] firstObject];
    headerView.titleTextField.text = self.product.productName;
    return headerView;
}
 */
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.

}
*/

@end
