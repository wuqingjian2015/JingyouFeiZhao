//
//  SSElementSelectViewController.m
//  JingyouFeiZhao
//
//  Created by caoli on 16/5/14.
//  Copyright © 2016年 QingjianWu. All rights reserved.
//

#import "SSElementSelectViewController.h"

#import "AppDelegate.h"

@interface SSElementSelectViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *elementImageView;
@property (weak, nonatomic) IBOutlet UISlider *currentQuantitySlider;

@property (nonatomic, strong) NSNumber *quantity;

@property (weak, nonatomic) IBOutlet UITextField *statusTextField;

@property (weak, nonatomic) IBOutlet UIStepper *valueSteper;

@end

@implementation SSElementSelectViewController
@synthesize quantity = _quantity;
@synthesize element = _element;


#pragma mark - properties
/*
-(NSNumber*)quantity
{
    if (!_quantity) {
        _quantity = [NSNumber numberWithInt:0];
    }
    return _quantity;
}
-(void)setQuantity:(NSNumber *)quantity
{
    _quantity = quantity;
}*/

#pragma mark - operations

/*
-(void)setElement:(SSElement *)element
{
    if (element) {
        _element = [[SSElement alloc] initWithElement:element];
    }
}

-(SSElement*)element
{
    return _element;
}
 */

- (IBAction)cancel:(id)sender {
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
    self.statusTextField.text = [NSString stringWithFormat:@"%i",(int)sender.value];
           self.quantity = [NSNumber numberWithInt:(int)sender.value];
    NSLog(@"chang slider.");
   
}
- (IBAction)changeQuantityValueBySteper:(UIStepper *)sender {
    self.currentQuantitySlider.value = (int)sender.value;
    self.statusTextField.text = [NSString stringWithFormat:@"%i",(int)sender.value];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
