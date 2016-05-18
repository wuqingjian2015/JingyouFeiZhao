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
#import "AppDelegate+plistDatabase.h"
#import <AVFoundation/AVFoundation.h>

@interface SSProductTableViewController () 

@property (nonatomic, strong) NSMutableArray *products;

@property (nonatomic, strong) SSProduct *pickingProduct;

@end

@implementation SSProductTableViewController
@synthesize pickingProduct;

#pragma mark - UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{

   NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSUUID *uuid = [NSUUID UUID];

    NSString *newName = [NSString stringWithFormat:@"Product_%@.png", [uuid UUIDString]];
    NSString *newPath = [path stringByAppendingPathComponent:newName];

    UIImage *image= info[UIImagePickerControllerEditedImage];
    NSData *imageData = UIImagePNGRepresentation(image);
    
    if ([imageData writeToFile:newPath atomically:YES]) {
        self.pickingProduct.productImage = newName;
        [self.tableView reloadData];
        NSLog(@"save file successfully to %@", newPath);
    } else {
        NSLog(@"failed to save file to %@", newPath);
    }
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - properties
-(NSMutableArray*)products
{
    if (!_products) {
        AppDelegate *app = [[UIApplication sharedApplication] delegate];
        _products = app.productPlistDatabase;
    }
    return _products;
}
- (IBAction)startChangeImageWithPicker:(UILongPressGestureRecognizer *)sender {

    
    if (sender.state == UIGestureRecognizerStateEnded) {
        CGPoint point = [sender locationInView:self.tableView];
        
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
        SSProduct *product = [self.products objectAtIndex:indexPath.row];
      
        self.pickingProduct = product;
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"选择相片还是摄影" message:@"请选择从相片库选取相片还是拍摄" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"相片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                picker.delegate = self;
                picker.allowsEditing = YES;
                picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                [self presentViewController:picker animated:YES completion:NULL];

            
        }];
        UIAlertAction *alertAction2 = [UIAlertAction actionWithTitle:@"摄影" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    
            
            AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
            if (authStatus == AVAuthorizationStatusDenied || authStatus == AVAuthorizationStatusRestricted){
                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                    if (granted) {
                        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                        picker.delegate = self;
                        picker.allowsEditing = YES;
                        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                        [self presentViewController:picker animated:YES completion:NULL];
                    }
                }];
            }
            
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                picker.delegate = self;
                picker.allowsEditing = YES;
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:picker animated:YES completion:NULL];
            } else {
                
                UIAlertController *alertController1 = [UIAlertController alertControllerWithTitle:@"没有相应设备" message:@"检查不到摄像设备。" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *warningAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:nil];
                [alertController1 addAction:warningAction];
                [self presentViewController:alertController1 animated:YES completion:nil];
            }
        }];
        [alertController addAction:alertAction];
        
        [alertController addAction:alertAction2];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
}
- (IBAction)changeEditStatus:(UIBarButtonItem *)sender {
}

#pragma mark - operation
-(void)addProduction:(NSNotification*)notification
{
    NSArray *selectedElements = notification.userInfo[@"selectedElements"];
    if (selectedElements) {
        SSProduct *product = [[SSProduct alloc] init];
        product.productName = [NSString stringWithFormat:@"精油皂＃%lui", self.products.count + 1];
        product.createdDate = [NSDate date];
        NSMutableArray *arraym = [[NSMutableArray alloc] init];
        for (SSElement *element in selectedElements) {
            [arraym addObject:[element dictionaryValue]];
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
    imageView.image = [UIImage imageNamed:product.productImage];
    
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

/*
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
*/

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [self.products removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        NSArray *insertIndexPaths = [NSArray arrayWithObjects:indexPath, nil];
        [self.products insertObject:[[SSProduct alloc] init] atIndex:indexPath.row];
        [self.tableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationRight];
        NSLog(@"editing.");
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
