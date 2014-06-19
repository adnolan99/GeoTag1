//
//  GTALoginViewController.m
//  GeoTag
//
//  Created by Austin Nolan on 5/27/14.
//  Copyright (c) 2014 Austin Nolan. All rights reserved.
//

#import "GTALoginViewController.h"

#import "GTASignUpViewController.h"

#import "GTAViewController.h"

#import <Parse/Parse.h>

@interface GTALoginViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@end

@implementation GTALoginViewController
{
    
    UITextField * userName;
    
    UITextField * password;
    
    UIButton * loginButton;

    UIButton * signUpButton;

//    UIButton * chooseAvatar;
    
//    UIImagePickerController * photoLibrary;
    
    UIImageView * headerFrame;
    
    UIImage * headerImage;

    
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

-(void)hideKeyboard
{
    
    [userName resignFirstResponder];
    [password resignFirstResponder];
    

}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    userName = [[UITextField alloc] initWithFrame:CGRectMake(60, 120, 200, 40)];
    userName.backgroundColor = [UIColor colorWithWhite:0.1 alpha:.05];
    userName.layer.cornerRadius = 5;
    userName.placeholder = @"Username";
    userName.tintColor = [UIColor lightGrayColor];
    [userName resignFirstResponder];
    [self.view addSubview:userName];
    
    
    
    password = [[UITextField alloc] initWithFrame:CGRectMake(60, 180, 200, 40)];
    password.backgroundColor = [UIColor colorWithWhite:0.1 alpha:.05];
    password.layer.cornerRadius = 5;
    password.secureTextEntry =YES;
    password.placeholder = @"Password";
    password.tintColor = [UIColor lightGrayColor];
    [password resignFirstResponder];

    [self.view addSubview:password];
    
    loginButton = [[UIButton alloc]initWithFrame:CGRectMake(60, 275, 200, 40)];
    [loginButton addTarget:self action:@selector(loginToVC) forControlEvents:UIControlEventTouchUpInside];
    [loginButton setTitle:@"Login" forState:UIControlStateNormal];
    loginButton.layer.cornerRadius = 5;
    
    loginButton.backgroundColor = [UIColor blackColor];
    
    [self.view addSubview:loginButton];
    
    
    signUpButton = [[UIButton alloc] initWithFrame:CGRectMake(60,370, 200, 40)];
    signUpButton.layer.cornerRadius = 5;
    [signUpButton setTitle:@"Sign Up" forState:UIControlStateNormal];
    signUpButton.backgroundColor = [UIColor blackColor];
    [signUpButton addTarget:self action:@selector(showSignUp) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:signUpButton];
    
    
//    chooseAvatar = [[UIButton alloc] initWithFrame:CGRectMake(60,240, 150, 25)];
//    chooseAvatar.layer.cornerRadius = 5;
//    [chooseAvatar setTitle:@"Select Avatar" forState:UIControlStateNormal];
//    chooseAvatar.backgroundColor = [UIColor blackColor];
//    [chooseAvatar addTarget:self action:@selector(chooseAvatar) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:chooseAvatar];
    
    
    //headerImage = [[UIImage alloc]init];

    
    headerFrame = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10, 320, 70)];
    [headerFrame setImage: [UIImage imageNamed:@"battletag"]];
    [self.view addSubview:headerFrame];
    
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-(void)chooseAvatar
//{
//    NSLog(@"press");
//    
//    photoLibrary = [[UIImagePickerController alloc] init];
//    
//    photoLibrary.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//    
//    photoLibrary.allowsEditing = YES;
//    photoLibrary.delegate = self;
//    
//    [self presentViewController:photoLibrary animated:YES completion:nil];
//    //[self saveAvatar];
//
//}


//-(void)saveAvatar
//{
//    //    connect current user to newsSelfy as parent : Parse "relational data"
//    
//    NSData * imageData = UIImagePNGRepresentation(selfyFrame.image);
//
//    PFFile * imageFile = [PFFile fileWithName:@"image.png" data:imageData];
//    
//    PFObject * avatar = [PFObject objectWithClassName:@"User"];
//    
//    avatar[@"image"] = imageFile;
//    
//    avatar[@"parent"]= [PFUser currentUser];
//    
//    [avatar saveInBackground];
//    
//    [avatar saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//        NSLog(@"%hhd",succeeded);
//        
//    }];
//   
//}


-(void)loginToVC
{
    [loginButton resignFirstResponder];

    NSLog(@"Login Button Press");
    
    UIActivityIndicatorView * activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.color= [UIColor redColor];
    activityIndicator.frame = CGRectMake(0, 10, 100, 50);
    
    [self.view addSubview:activityIndicator];
    
    [activityIndicator startAnimating];
    
    [PFUser logInWithUsernameInBackground:userName.text password:password.text block:^(PFUser *user, NSError *error)
    {
        if (error == nil)
        {
            self.navigationController.navigationBarHidden = YES;
            self.navigationController.viewControllers = @[[[GTAViewController alloc] initWithNibName:nil bundle:nil ]];
            
        }
        else
        {
            password.text = nil;
            
            [activityIndicator removeFromSuperview];
            
            NSString * errorDescription = error.userInfo[@"error"];
            
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"UserName Taken" message:errorDescription delegate:self cancelButtonTitle:@"Try Another Username" otherButtonTitles:nil];
            [alertView show];
        }
    }];
}
     

-(void)showSignUp
{
    GTASignUpViewController * signUpView = [[GTASignUpViewController alloc] initWithNibName:nil bundle:nil];
    
    UINavigationController * signUpNavView = [[UINavigationController alloc] initWithRootViewController:signUpView];

    signUpNavView.navigationBarHidden = YES;
    
    
    
    [self.navigationController presentViewController:signUpNavView animated:YES completion:^{
    }];
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
