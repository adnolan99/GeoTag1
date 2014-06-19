//
//  GTASignUpViewController.m
//  GeoTag
//
//  Created by Austin Nolan on 5/27/14.
//  Copyright (c) 2014 Austin Nolan. All rights reserved.
//

#import "GTASignUpViewController.h"

#import "GTAViewController.h"

#import <Parse/Parse.h>

@interface GTASignUpViewController () <UITextFieldDelegate>

@end

@implementation GTASignUpViewController
{
    
    UIView * signUpView;
    UIButton * signUpButton;
    UIImageView * playerAvatar;
    NSArray * signUpFieldNames;
    
    NSMutableArray * signUpFields;
    
    UIButton * chooseAvatar;
    UIImagePickerController * photoLibrary;

    
    UIImageView * headerFrame;
    UIButton * backButton;
    
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
        [self.view addGestureRecognizer:tap];
        
        
        
        
        
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    headerFrame = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10, 320, 70)];
    [headerFrame setImage: [UIImage imageNamed:@"battletag"]];
    [self.view addSubview:headerFrame];
    
    backButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 420, 70, 30)];
    backButton.backgroundColor = [UIColor blackColor];
    [backButton addTarget:self action:@selector(cancelSignUp) forControlEvents:UIControlEventTouchUpInside];
    [backButton setTitle:@"Back" forState:UIControlStateNormal];
    backButton.layer.cornerRadius = 5;

    
    [self.view addSubview:backButton];

    
    
//    UIBarButtonItem * cancelSignUpButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelsignUpButton)];
//    
//    cancelSignUpButton.tintColor = [UIColor whiteColor];
//    self.navigationItem.rightBarButtonItem = cancelSignUpButton;
    
    
    
    
    signUpFieldNames = @[@"Username",@"Password",@"Call Sign",@"Email"];
    
    signUpFields = [@[] mutableCopy];
    
    for (NSString * name in signUpFieldNames)
        
    {
        NSInteger index = [signUpFieldNames indexOfObject:name];
        
        UITextField * textField = [[UITextField alloc] initWithFrame:CGRectMake(20, (index * 50) + 100, 280, 40)];
        
        textField.backgroundColor = [UIColor lightGrayColor];
        textField.layer.cornerRadius = 5;
        textField.placeholder = name;
        textField.delegate = self;
        
        [textField resignFirstResponder];
        
        [signUpFields addObject:textField];
    
        [self.view addSubview:textField];
    
        [self.view addSubview:textField];
        
        signUpButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 310, 280, 40)];
        signUpButton.backgroundColor = [UIColor blackColor];
        signUpButton.layer.cornerRadius = 8;
        [signUpButton setTitle:@"Sign Up" forState:UIControlStateNormal];

        
        [signUpButton addTarget:self action:@selector(signUp) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:signUpButton];
        
        chooseAvatar = [[UIButton alloc] initWithFrame:CGRectMake(90, 370, 150, 25)];
        chooseAvatar.layer.cornerRadius = 5;
        [chooseAvatar setTitle:@"Select Avatar" forState:UIControlStateNormal];
        chooseAvatar.backgroundColor = [UIColor blackColor];
        [chooseAvatar addTarget:self action:@selector(chooseAvatar) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:chooseAvatar];
    
    
    }
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)chooseAvatar
{
    NSLog(@"press");
    
    photoLibrary = [[UIImagePickerController alloc] init];
    
    photoLibrary.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    photoLibrary.allowsEditing = YES;
    photoLibrary.delegate = self;
    
    [self presentViewController:photoLibrary animated:YES completion:nil];
    //[self saveAvatar];
    
}

-(void)signUp
{
    PFUser * user = [PFUser user];
    
    //UIImage * avatarImage = [UIImage imageNamed:@""];
    
    //NSData * imageData = UIImagePNGRepresentation(avatarImage);
    
    //PFFile * imageFile = [PFFile fileWithName:@"avatar.png" data:imageData];

    user.username = ((UITextField *)signUpFields [0]).text;
    user.password = ((UITextField *)signUpFields [1]).text;
    user[@"callSign"] = ((UITextField *)signUpFields [2]).text;
    user.email = ((UITextField *)signUpFields [3]).text;
    //user[@"avatar"] = imageFile;
    
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error == nil)
        {
            UINavigationController * loginNavCon = (UINavigationController *)self.presentingViewController;
            
            loginNavCon.navigationBarHidden = YES;
            loginNavCon.viewControllers = @[[[GTAViewController alloc] initWithNibName:nil bundle:nil]];

            
            [self cancelSignUp];
        }
        else
        {
            NSString * errorDescription = error.userInfo[@"error"];
            
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"UsernameTaken" message:errorDescription delegate:self cancelButtonTitle:@"Try Another Username" otherButtonTitles:nil];
            
            [alertView show];
        }
    }];
}



-(void)cancelSignUp
{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}



-(void)hideKeyboard
{
    for (UITextField * textFieldItem in signUpFields)
    {
        [textFieldItem resignFirstResponder];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
