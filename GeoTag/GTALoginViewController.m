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

@interface GTALoginViewController ()

@end

@implementation GTALoginViewController
{
    
    UITextField * userName;
    
    UITextField * password;
    
    UIButton * loginButton;

    UIButton * signUpButton;

    
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
    
    userName = [[UITextField alloc] initWithFrame:CGRectMake(85, 120, 150, 50)];
    userName.backgroundColor = [UIColor colorWithWhite:0.1 alpha:.05];
    userName.layer.cornerRadius = 10;
    userName.placeholder = @"Username";
    userName.tintColor = [UIColor lightGrayColor];
    [userName resignFirstResponder];
    [self.view addSubview:userName];
    
    
    
    password = [[UITextField alloc] initWithFrame:CGRectMake(85, 180, 150, 50)];
    password.backgroundColor = [UIColor colorWithWhite:0.1 alpha:.05];
    password.layer.cornerRadius = 15;
    password.secureTextEntry =YES;
    password.placeholder = @"Password";
    password.tintColor = [UIColor lightGrayColor];
    [self.view addSubview:password];
    
    loginButton = [[UIButton alloc]initWithFrame:CGRectMake(85, 240, 150, 50)];
    [loginButton addTarget:self action:@selector(loginToVC) forControlEvents:UIControlEventTouchUpInside];
    [loginButton setTitle:@"Login" forState:UIControlStateNormal];
    loginButton.layer.cornerRadius = 15;
    
    loginButton.backgroundColor = [UIColor blackColor];
    
    [self.view addSubview:loginButton];
    
    
    signUpButton = [[UIButton alloc] initWithFrame:CGRectMake(85,300, 150, 50)];
    signUpButton.layer.cornerRadius = 15;
    [signUpButton setTitle:@"Sign Up" forState:UIControlStateNormal];
    signUpButton.backgroundColor = [UIColor blackColor];
    [signUpButton addTarget:self action:@selector(showSignUp) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:signUpButton];
    
    
    
    
    
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


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
