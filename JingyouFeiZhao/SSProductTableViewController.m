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

#import "SSQRCode.h"
#import "SSQRCodeView.h"
#include "SSConstants.h"


@interface SSProductTableViewController () 

@property (nonatomic, strong) NSMutableArray *products;
@property (nonatomic, strong) NSMutableArray *searchProductResults;
@property (nonatomic, strong) SSProduct *pickingProduct;
@property (nonatomic, strong) UIImage *qrcodeImage;
@property (nonatomic, assign) BOOL updated;
@property (nonatomic, assign) BOOL isEdited;
@property (nonatomic, strong) SSProduct *editingProduct;

@property (nonatomic,strong) UITableViewCell *currentCell;

@property (nonatomic, strong) NSString *predicateText;

@end

@implementation SSProductTableViewController
@synthesize pickingProduct;
@synthesize productToAdd = _productToAdd;
@synthesize qrcodeImage;
@synthesize updated;
@synthesize editingProduct = _editingProduct;
@synthesize isEdited;
@synthesize searchProductResults = _searchProductResults;
@synthesize currentCell;
@synthesize predicateText = _predicateText;


#pragma mark - properties

-(NSString*)predicateText
{
    if (!_predicateText) {
        _predicateText = [[NSUserDefaults standardUserDefaults] objectForKey:@"predicateText"];
    }
    return _predicateText;
}
-(void)setPredicateText:(NSString *)predicateText
{
    _predicateText = predicateText;
    [[NSUserDefaults standardUserDefaults] setObject:_predicateText forKey:@"predicateText"];
}

-(void)setEditingProduct:(SSProduct *)editingProduct
{
    _editingProduct = editingProduct;
}

-(SSProduct*)editingProduct
{
    return _editingProduct;
}

-(void)setProductToAdd:(SSProduct *)productToAdd
{
    if (productToAdd) {
        _productToAdd = productToAdd;
    }
}

-(SSProduct*)productToAdd
{
    return _productToAdd;
}
-(NSMutableArray*)products
{
    if (!_products) {
        AppDelegate *app = [[UIApplication sharedApplication] delegate];
        _products = app.productPlistDatabase;
        updated = YES;
    }
    return _products;
}

-(NSMutableArray*)searchProductResults
{
    if (!_searchProductResults || updated ) {
        _searchProductResults = [self.products mutableCopy];
        updated = NO;
    }
    NSLog(@"self : %@", self);
    NSLog(@"getting search product result : %@", _searchProductResults);
    return _searchProductResults;
}

-(void)setSearchProductResults:(NSMutableArray *)searchProductResults
{
    _searchProductResults = [searchProductResults mutableCopy];
    updated = NO;
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

-(SSProduct*)getProductByCode:(NSString*)code
{
    SSProduct *result = nil;
    for (SSProduct *product in self.products) {
        if ([product.productCode isEqualToString:code]) {
            result = product;
            break;
        }
    }
    return result;
}
-(BOOL)updateProductInDatabase:(SSProduct*)product
{
    for (SSProduct *p in self.products) {
        if ([product.productCode isEqualToString:p.productCode]) {
            p.productName = product.productName;
            return YES;
        }
    }
    return NO;
}
- (IBAction)startEditProductName:(UITextField *)sender {
    
    self.currentCell = (UITableViewCell*)sender.superview.superview;
    
}

- (IBAction)dismissKeyboardByTap:(UITapGestureRecognizer*)sender {

    if(self.currentCell){
        UITextField *nameTextField = [self.currentCell.contentView viewWithTag:102];
        [nameTextField resignFirstResponder];
        
        UILabel* productCodeLabel = [self.currentCell.contentView viewWithTag:104];
        if ([nameTextField.text length] > 0) {
            self.editingProduct = [self getProductByCode:productCodeLabel.text];
            self.editingProduct.productName = nameTextField.text;
            [self updateProductInDatabase:self.editingProduct];
        }
    }
}

-(void)addProduct:(SSProduct*)productToAdd
{
    self.productToAdd = productToAdd;
    [self.products addObject:self.productToAdd];
    updated = YES;
    NSLog(@"add product %@", productToAdd);
}

-(void)removeProductAtIndex:(NSIndexPath*)indexPath
{
    SSProduct *product = [self.searchProductResults objectAtIndex:indexPath.row];
    SSProduct *tempProduct = [self getProductByCode:product.productCode];
    [self.searchProductResults removeObject:product];
    [self.products removeObject:tempProduct];
}

-(void)searchProduct:(NSNotification*)notification
{
    NSLog(@"search product:");
    NSString *productCodeToSearch = notification.userInfo[@"productCodeToSearch"];
    if (productCodeToSearch) {
        self.predicateText = [NSString stringWithFormat:@"productCode like[cd] %@", productCodeToSearch];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%@", self.predicateText];
        
       self.searchProductResults = [[self.products filteredArrayUsingPredicate:predicate] mutableCopy];
        
       [self.tableView reloadData];
        
        //cancel bar
        UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancelSearch:)];
        self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    }
}
- (IBAction)cancelSearch:(id)sender {
    self.searchProductResults = [self.products copy];
    [self.tableView reloadData];
    self.navigationItem.leftBarButtonItem = nil;
    
}

- (IBAction)shareImage:(id)sender {
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *tempFile = [path stringByAppendingPathComponent:@"test.png"];
    NSData *date =  UIImagePNGRepresentation(self.qrcodeImage);
    NSError *error = nil;
    if([[NSFileManager defaultManager] fileExistsAtPath:tempFile]){
        [[NSFileManager defaultManager] removeItemAtPath:tempFile error:&error];
    }
    NSAssert([date writeToFile:tempFile atomically:YES], @"failed to save temp file %@", tempFile) ;
    NSArray *objectToShare = @[self.qrcodeImage];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:objectToShare applicationActivities:nil];
    
    NSArray *excludedActivities = [[NSArray alloc] initWithObjects: UIActivityTypePrint, UIActivityTypePostToVimeo, UIActivityTypeAddToReadingList, UIActivityTypeCopyToPasteboard, UIActivityTypeSaveToCameraRoll, UIActivityTypePostToTwitter, UIActivityTypePostToFacebook, UIActivityTypeAssignToContact, UIActivityTypePostToFlickr, nil];
    
    activityVC.excludedActivityTypes = excludedActivities;
    [self presentViewController:activityVC animated:YES completion:nil];
}

- (IBAction)viewErWeiMa:(id)sender {
    
    SSQRCodeView *codeView = [[[NSBundle mainBundle] loadNibNamed:@"SSQRCodeView" owner:nil options:nil] firstObject];
    [self.view.superview addSubview:codeView];
    [codeView.shareButton addTarget:self action:@selector(shareImage:) forControlEvents:UIControlEventTouchUpInside];
    
    codeView.frame = CGRectMake(0, 0, 200, 200);
    codeView.center = CGPointMake(kScreenWidth / 2, kScreenHeight / 2);
    UIButton *button = (UIButton*)sender;

    UITableViewCell *cell = (UITableViewCell *)button.superview;
    NSString *website = @"http://wuqingjian-pc/";
    NSString *productCode = [[cell viewWithTag:104] text];
    NSString *productPdf = [NSString stringWithFormat:@"%@/%@.pdf", website, productCode];
    codeView.previewImageView.image = [SSQRCode qRCodeImageFromString:productPdf withQualityLevel:@"Q" toFitFrame:codeView.previewImageView.frame];
    
    self.qrcodeImage = [codeView.previewImageView.image copy];
}


#pragma mark - lifecycle

-(void)viewWillDisappear:(BOOL)animated
{
    [self saveProducts];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
 //   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addProduction:) name:kSSProductAddOperationNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchProduct:) name:kSSProductSearchOperationNotification object:nil];
    updated = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)saveProducts
{
    if ([[[UIApplication sharedApplication] delegate] respondsToSelector:@selector(saveProducts:)]) {
        [[[UIApplication sharedApplication] delegate] performSelector:@selector(saveProducts:) withObject:self.products];
        return YES;
    }
    return NO; 
}

- (void)dealloc
{
    [self saveProducts];

//    [[NSNotificationCenter defaultCenter] removeObserver:self name:kSSProductAddOperationNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kSSProductSearchOperationNotification object:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
 //   updated = YES;
 //   [self.tableView reloadData];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.searchProductResults count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *reusedIdentifier = @"productCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusedIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusedIdentifier];
    }
    SSProduct *product = [self.searchProductResults objectAtIndex:indexPath.row];

    UIImageView *imageView = [cell viewWithTag:101];
    imageView.image = [UIImage imageNamed:product.productImage];
    
    UITextField *nameTextField = [cell viewWithTag:102];
    nameTextField.text = product.productName;
    
    UILabel *dateLable = [cell viewWithTag:103];
  
    dateLable.text = [NSDateFormatter localizedStringFromDate:product.createdDate dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterNoStyle];
    
    UILabel *codeLabel = [cell viewWithTag:104];
    codeLabel.text = product.productCode;
    // Configure the cell...
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboardByTap:)];
    [cell addGestureRecognizer:tapGesture];
    
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
        [self removeProductAtIndex:indexPath];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        NSArray *insertIndexPaths = [NSArray arrayWithObjects:indexPath, nil];
        [self.searchProductResults insertObject:[[SSProduct alloc] init] atIndex:indexPath.row];
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"showProductDetail"]) {
        SSProductDetailTableViewController *detail = (SSProductDetailTableViewController*) segue.destinationViewController;
        NSLog(@"%@", sender);
        UIButton *button = (UIButton*)sender;
        UITableViewCell *cell = (UITableViewCell *)button.superview.superview;
        UILabel* productCodeLabel = [cell viewWithTag:104];
        
        detail.product = [self getProductByCode:productCodeLabel.text];
        //[self.searchProductResults objectAtIndex:self.tableView.indexPathForSelectedRow.row];
    }
}


@end
