//
//  HYAttachmentUploadViewController.m
//  KONKA_MARKET
//
//  Created by 许 玮 on 13-12-19.
//  Copyright (c) 2013年 archon. All rights reserved.
//

#import "HYAttachmentUploadViewController.h"
#import "HYUploadPic.h"
#import "SDImageView+SDWebCache.h"

@interface HYAttachmentUploadViewController ()
{
    UIImageView *preImageView;
    UIButton *selectBtn;
    UIButton *uploadBtn;
    UIButton *cameraBtn;
    UIImagePickerController *camera;
}

@end

@implementation HYAttachmentUploadViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[super someButton] addTarget:self action:@selector(backButtonAction:)
                 forControlEvents:UIControlEventTouchUpInside];
    
    //预览图像
    
    
    
    preImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 40, 300, [super screenHeight] - 134)];
    
    [[self view] addSubview:preImageView];
    
    if(self.userLogin.preimgurl != nil)
    {
        [preImageView setImageWithURL:self.userLogin.preimgurl];
    }
    
    //添加按钮
    NSLog(@"screenHeight %.2f" , [super screenHeight]);
    selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    selectBtn.frame = CGRectMake(125, [super screenHeight] - 84, 70, 30);
    [selectBtn setTitle:@"选择" forState:UIControlStateNormal];
    [selectBtn addTarget:self action:@selector(selectPicAction:) forControlEvents:UIControlEventTouchUpInside];
    [selectBtn setBackgroundColor:[UIColor colorWithRed:0.000 green:0.478 blue:0.882 alpha:1.0]];
    [selectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    
    cameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    cameraBtn.frame = CGRectMake(25, [super screenHeight] - 84, 70, 30);
    [cameraBtn setTitle:@"拍摄" forState:UIControlStateNormal];
    [cameraBtn addTarget:self action:@selector(cameraAction:) forControlEvents:UIControlEventTouchUpInside];
    [cameraBtn setBackgroundColor:[UIColor colorWithRed:0.000 green:0.478 blue:0.882 alpha:1.0]];
    [cameraBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    
    uploadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    uploadBtn.frame = CGRectMake(225, [super screenHeight] - 84, 70, 30);
    [uploadBtn setTitle:@"上传" forState:UIControlStateNormal];
    [uploadBtn addTarget:self action:@selector(uploadAction:) forControlEvents:UIControlEventTouchUpInside];
    [uploadBtn setBackgroundColor:[UIColor colorWithRed:0.000 green:0.478 blue:0.882 alpha:1.0]];
    [uploadBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    
    if(self.userLogin.preimgurl == nil)
    {
        [[self view] addSubview:selectBtn];
        [[self view] addSubview:cameraBtn];
        [[self view] addSubview:uploadBtn];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cameraAction:(id)sender {
    camera = [[UIImagePickerController alloc] init];
    camera.delegate = self;
    camera.allowsEditing = NO;
    
    //检查摄像头是否支持摄像机模式
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        camera.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else
    {
        NSLog(@"Camera not exist");
        return;
    }
    [self presentViewController:camera animated:YES completion:nil];
    
}

- (IBAction)uploadAction:(id)sender {
    HYUploadPic *uploadPic = [[HYUploadPic alloc] init];
    NSDictionary *params = nil;
    params = [[NSDictionary alloc] initWithObjectsAndKeys:self.userLogin.user_name,@"username",self.userLogin.user_id,@"user_id",@"KONKA_MOBILE_SAIL_DATA",@"link_tab",self.userLogin.link_id,@"link_id",@"",@"file_desc",nil];
    
    
    NSString *imageName = [NSString stringWithFormat:@"%@/%@", [self documentFolderPath], @"small_konkamobile.jpg"];
    
    NSDictionary *files = nil;
    
    files = [[NSDictionary alloc] initWithObjectsAndKeys:imageName, @"profile_picture",nil];
    
    
    //    test.image=[UIImage imageWithContentsOfFile:imageName];
    
    //    [uploadPic addPicWithDictionary:files Parem:params];
    
    //测试上传
    NSURL *url = [[NSURL alloc] initWithString:[BaseURL stringByAppendingFormat:UploadPic]];
    //    [self testUpload:url AndFileName:imageName AndParmes:params];
    
}

- (IBAction)selectPicAction:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = NO;
    
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (void) imagePickerController: (UIImagePickerController*) picker
 didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    
    //获得编辑过的图片
    UIImage* image = [info objectForKey: @"UIImagePickerControllerOriginalImage"];
    if(picker == camera)
    {

    }
    [preImageView setImage:image];
    
    //    UIImage *midImage = [HYAppUtily imageWithImageSimple:image scaledToSize:CGSizeMake(210.0, 210.0)];
    //    UIImage *bigImage = [HYAppUtily imageWithImageSimple:image scaledToSize:CGSizeMake(440.0, 440.0)];
    
    [self saveImage:image WithName:@"small_konkamobile.jpg"];
    //    [self saveImage:midImage WithName:@"mid_konkamobile.jpg"];
    //    [self saveImage:bigImage WithName:@"big_konkamobile.jpg"];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(NSString *)timeStampAsString
{
    NSDate *nowDate = [NSDate date];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"EEE-MMM-d"];
    NSString *locationString = [df stringFromDate:nowDate];
    return [locationString stringByAppendingFormat:@".png"];
}

-(NSString *)getFileName:(NSString *)fileName
{
    NSArray *temp = [fileName componentsSeparatedByString:@"&ext="];
    NSString *suffix = [temp lastObject];
    
    temp = [[temp objectAtIndex:0] componentsSeparatedByString:@"?id="];
    
    NSString *name = [temp lastObject];
    
    name = [name stringByAppendingFormat:@".%@",suffix];
    return name;
}

- (void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName
{
    NSData* imageData = UIImagePNGRepresentation(tempImage);
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    // Now we get the full path to the file
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
    // and then we write it out
    [imageData writeToFile:fullPathToFile atomically:NO];
}

- (NSString *)documentFolderPath
{
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
}



#pragma mark -
#pragma mark DataProcesse
- (void) requestFinished:(ASIHTTPRequest *)request
{
    NSString *responsestring = [request responseString];
    //NSLog(@"responsestring:%@",responsestring);
    [self performSelectorOnMainThread:@selector(endRequest:) withObject:responsestring waitUntilDone:YES];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSString *responsestring = @"服务器连接失败";
    [self performSelectorOnMainThread:@selector(endFailedRequest:) withObject:responsestring waitUntilDone:YES];
}

-(void) endFailedRequest:(NSString *)msg
{
    //
}
//
-(void) endRequest:(NSString *)msg
{
    NSLog(@"msg %@", msg);
}

-(void)testUpload:(NSURL *)url AndFileName:(NSString *)file AndParmes:param
{
    
    ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:url];
    NSString *imgPath = file;
    NSData *image = [[NSData alloc] initWithContentsOfFile:imgPath];
    [request setPostValue:image forKey:@"profile_picture"];
    NSArray *array = [param allKeys];
    for (int i= 0; i <[array count]; i++) {
        [request setPostValue:[param objectForKey:[array objectAtIndex:i]] forKey:[array objectAtIndex:i]];
    }
    
    [request setRequestMethod:@"POST"];
    [request buildPostBody];
    [request setDelegate:self];
    [request startAsynchronous];
}

@end
