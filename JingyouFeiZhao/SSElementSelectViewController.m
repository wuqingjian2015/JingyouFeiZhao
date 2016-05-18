//
//  SSElementSelectViewController.m
//  JingyouFeiZhao
//
//  Created by caoli on 16/5/14.
//  Copyright © 2016年 QingjianWu. All rights reserved.
//

#import "SSElementSelectViewController.h"

#import "AppDelegate+plistDatabase.h"

@interface SSElementSelectViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *elementImageView;
@property (weak, nonatomic) IBOutlet UISlider *currentQuantitySlider;

@property (nonatomic, strong) NSNumber *quantity;

@property (weak, nonatomic) IBOutlet UIStepper *valueSteper;
@property (weak, nonatomic) IBOutlet UITextField *quantityTextField;

@end

@implementation SSElementSelectViewController
@synthesize quantity = _quantity;
@synthesize element = _element;
@synthesize indexPath;
@synthesize quantityTextField;

#pragma mark - properties


#pragma mark - operations


- (IBAction)dismissKeyboardByTap:(UITapGestureRecognizer *)sender {
    [self.quantityTextField resignFirstResponder];
}

- (IBAction)cancel:(id)sender {
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:self.indexPath, @"indexPath", nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kSSElementDisselectOperationNotification object:nil userInfo:userInfo];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)confirm:(UIButton *)sender {

    [self.element setQuantity:self.quantity];
   // self.element.quantity = self.quantity;
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:self.element, @"selectedElement", nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kSSElementChangeOperationNotification object:nil userInfo:userInfo];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)changeQuantity:(UISlider *)sender {
    //self.quantity = [NSNumber numberWithInt:(int)sender.value];
    self.valueSteper.value = (int)sender.value;
    self.quantityTextField.text = [NSString stringWithFormat:@"%i",(int)sender.value];
    self.quantity = [NSNumber numberWithInt:(int)sender.value];
    NSLog(@"chang slider.");
   
}
- (IBAction)changeQuantityValueBySteper:(UIStepper *)sender {
    self.currentQuantitySlider.value = (int)sender.value;
    self.quantityTextField.text = [NSString stringWithFormat:@"%i",(int)sender.value];
    self.quantity = [NSNumber numberWithInt:(int)sender.value];
    NSLog(@"change stepper");
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.elementImageView.image = [UIImage imageNamed:self.element.elementName];
    [self performSelector:@selector(changeQuantity:) withObject:self.currentQuantitySlider];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidLayoutSubviews
{
    NSLog(@"did layout");
    
    float width = kScreenWidth;
    float height = kScreenHeight;
    CGRect imageFrame;
    CGRect otherFrame;
    UIView *otherView = [self.view viewWithTag:201];
    UIImageView *imageView = [self.view viewWithTag:202];
    
    if(width > height){
        NSLog(@"lanscape");
        imageFrame = CGRectMake(10, 20, width/2 - 20, height - 30);
        otherFrame = CGRectMake(width/2 - 10, height / 2 - 50, width/2 - 20, height - 20);
        
        otherView.frame = otherFrame;
        imageView.frame = imageFrame;
    } else {
        NSLog(@"portrait");
        imageFrame = CGRectMake(10, 20, width - 20, height/2 -30);
        otherFrame = CGRectMake(10, height / 2 + 50, width - 20, height / 2 - 20);
        
        otherView.frame = otherFrame;
        imageView.frame = imageFrame;
        
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
