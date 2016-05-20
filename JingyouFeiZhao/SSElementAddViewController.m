//
//  SSElementAddViewController.m
//  JingyouFeiZhao
//
//  Created by caoli on 16/5/15.
//  Copyright © 2016年 QingjianWu. All rights reserved.
//

#import "SSElementAddViewController.h"
#import "SSElement.h"
#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>
#import "SSConstants.h"

@interface SSElementAddViewController()

@property (nonatomic, strong) NSString *imageFile;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *quantityTextField;
@property (weak, nonatomic) IBOutlet UITextField *costTextField;
@property (weak, nonatomic) IBOutlet UITextField *unitTextField;

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (nonatomic, assign) CGRect originFrame;

@property (nonatomic, assign) BOOL keyboardShown;

@end
@implementation SSElementAddViewController
@synthesize imageFile = _imageFile;
@synthesize nameTextField;
@synthesize quantityTextField;
@synthesize costTextField;
@synthesize unitTextField;
@synthesize originFrame = _originFrame;
@synthesize containerView;
@synthesize keyboardShown = _keyboardShown;

-(void)setOriginFrame:(CGRect)originFrame
{
    _originFrame = originFrame;
}

-(CGRect)originFrame
{
    return _originFrame;
}

-(void)setKeyboardShown:(BOOL)keyboardShown
{
    _keyboardShown = keyboardShown;
}

-(BOOL)keyboardShown
{
    return _keyboardShown;
}

- (IBAction)dismissKeyBoardByTap:(UITapGestureRecognizer *)sender {
    
    if (self.keyboardShown) {
        CGRect frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        __weak SSElementAddViewController* weakself = self;
        [UIView animateWithDuration:1.0f animations:^{
            weakself.view.frame = frame;
            [weakself.nameTextField resignFirstResponder];
            [weakself.quantityTextField resignFirstResponder];
            [weakself.costTextField resignFirstResponder];
            [weakself.unitTextField resignFirstResponder];
        }];
        
        self.keyboardShown = NO;
    }
}
- (IBAction)startKeyin:(id)sender {

}
- (IBAction)stopKeyin:(id)sender {
   // self.view.frame = self.originFrame;
}

-(void)setImageFile:(NSString *)imageFile
{
    _imageFile = imageFile;
}

-(NSString*)imageFile
{
    return _imageFile;
}

-(void)didKeyboardShow:(NSNotification*)notification
{
    self.originFrame = self.view.frame;
    self.keyboardShown = YES;
    
    CGRect frame = self.originFrame;
    frame = CGRectMake(0, -(kScreenHeight / 2 - 30), frame.size.width, frame.size.height);
    //__weak SSElementAddViewController* weakself = self;
    [UIView animateWithDuration:1.0f animations:^{
        self.view.frame = frame;
    }];
}
-(void)viewDidLoad
{
    UIImageView *imageView = [self.view viewWithTag:105];
    imageView.image = [UIImage imageNamed:@"jingyou"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didKeyboardShow:) name:UIKeyboardDidShowNotification object:nil];
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
}
-(void)viewDidLayoutSubviews
{
    float width = kScreenWidth;
    float height = kScreenHeight;
    UIImageView *imageView = [self.view viewWithTag:105];
    UIView * otherView = [self.view viewWithTag:201];
    CGRect imageFrame;
    CGRect otherFrame;
    
    if (width > height) {
        //landscape;
        imageFrame = CGRectMake(10, 20, width / 2 - 20, height - 40);
        otherFrame = CGRectMake(width/2 + 10 , 20, width / 2 - 40, height - 40);

    } else {
        //portrait;
        imageFrame = CGRectMake(10, 20, width - 20, height / 2 - 30);
        otherFrame = CGRectMake(10, height / 2 + 20, width - 20, height / 2 - 40);
    }
    imageView.frame = imageFrame;
    otherView.frame = otherFrame;
}
#pragma mark - UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSUUID *uuid = [NSUUID UUID];
    NSLog(@"%@", uuid);
    NSString *newName = [NSString stringWithFormat:@"Element_%@.png", [uuid UUIDString]];
    NSString *newPath = [path stringByAppendingPathComponent:newName];
    
    UIImage *image= info[UIImagePickerControllerEditedImage];
    NSData *imageData = UIImagePNGRepresentation(image);
    
    if ([imageData writeToFile:newPath atomically:YES]) {
        self.imageFile = newName;
        UIImageView *imageView = [self.view viewWithTag:105];
        imageView.image = [UIImage imageNamed:newPath];
        NSLog(@"save file successfully to %@", newPath);
    } else {
        NSLog(@"failed to save file to %@", newPath);
    }
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark -operations
- (IBAction)addElementImage:(UILongPressGestureRecognizer *)sender {
    
    
    if (sender.state == UIGestureRecognizerStateEnded) {
        
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
-(BOOL)validateInputs
{
    UITextField *nameField = [self.view viewWithTag:101];
//    UITextField *quantityField = [self.view viewWithTag:102];
//    UITextField *costField = [self.view viewWithTag:103];
//    UITextField *unitField = [self.view viewWithTag:104];
    UIImageView *noImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"no"]];
    UIImageView *yesImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yes"]];
    NSString *valueText = [nameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([valueText length] == 0) {

        nameField.rightView = noImage;
    } else {

        nameField.rightView = yesImage;
    }
  /*
    valueText = [quantityField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([]) {
        <#statements#>
    }
*/
    return NO;
}

- (IBAction)addElement:(UIButton *)sender {
    
    UITextField *nameField = [self.view viewWithTag:101];
    UITextField *quantityField = [self.view viewWithTag:102];
    UITextField *costField = [self.view viewWithTag:103];
    UITextField *unitField = [self.view viewWithTag:104];
   // UIImageView *imageView = [self.view viewWithTag:105];
    
    if ([quantityField.text length] == 0 || [quantityField.text floatValue] == 0) {
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    
    SSElement *element = [[SSElement alloc] initWithName:nameField.text quantity:[NSNumber numberWithFloat:[quantityField.text floatValue]]  cost:[NSNumber numberWithFloat:[costField.text floatValue]] unit:unitField.text image:self.imageFile];
    NSDictionary *userInfo = @{@"addedElement":element };
    [[NSNotificationCenter defaultCenter] postNotificationName:kSSElementAddOperationNotification object:nil userInfo:userInfo];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)cacel:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
