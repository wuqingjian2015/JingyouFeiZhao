//
//  SSQRcodeReaderViewController.m
//  JingyouFeiZhao
//
//  Created by caoli on 16/5/18.
//  Copyright © 2016年 QingjianWu. All rights reserved.
//

#import "SSQRcodeReaderViewController.h"
#import "SSConstants.h"

@interface SSQRcodeReaderViewController ()

@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;

@property (nonatomic, strong) NSString *scanedText;
@property (weak, nonatomic) IBOutlet UIView *previewView;

@property (nonatomic, assign) BOOL isScanning;
@property (weak, nonatomic) IBOutlet UIButton *startStopButton;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

@end

@implementation SSQRcodeReaderViewController
@synthesize captureSession = _captureSession;
@synthesize previewLayer = _previewLayer;
@synthesize scanedText = _scanedText;
@synthesize isScanning;

#pragma mark - operations
- (IBAction)startStopScan:(id)sender {
    if (!isScanning) {
        [self startScanning];
    } else {
        [self stopScanning];
    }
}

-(void)startScanning
{
    [self.captureSession startRunning];
    [self.startStopButton setTitle:@"停止" forState:UIControlStateNormal];
    isScanning = YES;

}
-(void)stopScanning
{
    isScanning = NO;
    [self.captureSession stopRunning];
    if (self.scanedText && [self.scanedText length] > 0 ) {
        NSDictionary *userInfo = @{@"productCodeToSearch":self.scanedText};
        NSLog(@"sent search operation notification");
        [[NSNotificationCenter defaultCenter] postNotificationName:kSSProductSearchOperationNotification object:nil userInfo:userInfo];

    }

    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -properties

-(AVCaptureSession*)captureSession
{
    if (!_captureSession) {
        _captureSession = [[AVCaptureSession alloc] init];
    }
    return _captureSession;
}

-(void)setupPreviewLayer
{
    if (!_previewLayer) {
        _previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
        [_previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
        [_previewLayer setFrame:self.previewView.bounds];
        [self.previewView.layer addSublayer:_previewLayer];
    }
}
-(void)setupCaptureSession
{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusDenied || authStatus == AVAuthorizationStatusRestricted){
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
                if (!device) {
                    NSLog(@"device is not ready");
                    return ;
                }
                
                NSError *error = nil;
                AVCaptureInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
                
                if (!input) {
                    NSLog(@"%@", [error localizedDescription]);
                    return;
                }
                
                AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
                dispatch_queue_t readQueue;
                readQueue = dispatch_queue_create("readingQueue", NULL);
                [captureMetadataOutput setMetadataObjectsDelegate:self queue:readQueue];
                [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
                
                [self.captureSession addInput:input];
                [self.captureSession addOutput:captureMetadataOutput];
                
                [self setupPreviewLayer];
            }
        }];
    } else {
        
   
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        if (!device) {
            NSLog(@"device is not ready");
            return ;
        }
        
        NSError *error = nil;
        AVCaptureInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
        
        if (!input) {
            NSLog(@"%@", [error localizedDescription]);
            return;
        }
        
        
        AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
        
        [self.captureSession addInput:input];
        [self.captureSession addOutput:captureMetadataOutput];
        dispatch_queue_t readQueue;
        readQueue = dispatch_queue_create("readingQueue", NULL);
        [captureMetadataOutput setMetadataObjectsDelegate:self queue:readQueue];
        
        [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
        
        [self setupPreviewLayer];

    }
 
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if (captureOutput != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            self.scanedText = [metadataObj stringValue];
            //[self performSelectorOnMainThread:@selector(stopScanning) withObject:nil waitUntilDone:NO];
            [self stopScanning];
            NSLog(@"%@", self.scanedText);
        }
    }
}
#pragma mark -lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupCaptureSession];
    self.infoLabel.text = @"将二维码放入框内，即可扫描";
    [self.infoLabel sizeToFit];
    
    [self startScanning];
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
