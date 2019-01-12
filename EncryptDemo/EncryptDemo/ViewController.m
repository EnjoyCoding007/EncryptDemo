//
//  ViewController.m
//  EncryptDemo
//
//  Created by Sharon on 2019/1/12.
//  Copyright © 2019 Sharon. All rights reserved.
//

#import "ViewController.h"
//RSA
#import "RSACryptor.h"
//对称加密
#import "EncryptTools.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //1、加载公钥
    NSString *publicKeyPath =  [[NSBundle mainBundle] pathForResource:@"rsacert" ofType:@"der"];
    [[RSACryptor sharedRSACryptor] loadPublicKeyWithPath:publicKeyPath];
    
    //2、加载私钥
    NSString *privatelicKeyPath =  [[NSBundle mainBundle] pathForResource:@"p" ofType:@"p12"];
    [[RSACryptor sharedRSACryptor] loadPrivateKeyWithPath:privatelicKeyPath password:@"123"];
}

//base64编码
- (NSString *)base64EncodeWithString:(NSString *)string
{
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    return [data base64EncodedStringWithOptions:0];
}

//base64解码
- (NSString *)base64DecodeWithEncodeString:(NSString *)encodeStr
{
    NSData *decodeData = [[NSData alloc] initWithBase64EncodedString:encodeStr options:0];
    return [[NSString alloc] initWithData:decodeData encoding:NSUTF8StringEncoding];
}

- (void)base64Test
{
    //base64 编解码
    NSString *string = @"123";
    NSString *encodeStr = [self base64DecodeWithEncodeString:string];
    NSLog(@"%@",encodeStr);
    NSLog(@"%@",[self base64DecodeWithEncodeString:encodeStr]);
}

- (void)rsaTest
{
    //用公钥对数据加密
    NSData *encryptData = [[RSACryptor sharedRSACryptor] encryptData:[@"pass word" dataUsingEncoding:NSUTF8StringEncoding]];
    NSString *base64Str = [encryptData base64EncodedStringWithOptions:0];
    NSLog(@"%@",base64Str);
    //用私钥解密
    NSData *decryptData = [[RSACryptor sharedRSACryptor] decryptData:encryptData];
    NSLog(@"%@",[[NSString alloc] initWithData:decryptData encoding:NSUTF8StringEncoding]);
}

- (void)hashTest
{
    //hash算法相关实现参考NSString+Hash文件
    
}

//AES
- (void)symmetricEncryptTest
{
    //ECB
    NSString * key = @"abcdef";
    NSString * encStr = [[EncryptTools sharedEncryptionTools] encryptString:@"hello world" keyString:key iv:nil];
    
    NSLog(@"ECB加密结果：%@",encStr);
    
    NSLog(@"ECB解密结果：%@",[[EncryptTools sharedEncryptionTools] decryptString:encStr keyString:key iv:nil]);
    
    //CBC
    uint8_t iv[8] = {8,7,6,5,4,3,2,1};
    NSData * ivData = [NSData dataWithBytes:iv length:sizeof(iv)];
    
    NSString *encString = [[EncryptTools sharedEncryptionTools] encryptString:@"world hello" keyString:key iv:ivData];
    
    NSLog(@"CBC加密：%@",encString);
    
    NSLog(@"CBC解密：%@",[[EncryptTools sharedEncryptionTools] decryptString:encString keyString:key iv:ivData]);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self symmetricEncryptTest];
}

@end
