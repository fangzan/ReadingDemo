//
//  FCommonTool.m
//  Demo
//
//  Created by AoChen on 2019/1/23.
//  Copyright © 2019 An. All rights reserved.
//

#import "FCommonTool.h"

@implementation FCommonTool

//MARK: - --- 中文数字字典
#define DICT_CNNUM  NSDictionary *chnNumChar = \
@{@"零":@0,@"一":@1,@"二":@2,@"两":@2,@"三":@3,@"四":@4,@"五":@5,@"六":@6,@"七":@7,@"八":@8,@"九":@9,@"0":@0,@"1":@1,@"2":@2,@"3":@3,@"4":@4,@"5":@5,@"6":@6,@"7":@7,@"8":@8,@"9":@9};\
NSDictionary *chnNameValue = @{\
@"十":@{@"value":@10, @"secUnit":@(false)},\
@"百":@{@"value":@100, @"secUnit":@(false)},\
@"千":@{@"value":@1000, @"secUnit":@(false)},\
@"万":@{@"value":@10000, @"secUnit":@(true)},\
@"亿":@{@"value":@100000000, @"secUnit":@(true)},\
};

//MARK: - --- 中文数字转阿拉伯数字
+ (NSInteger )chineseNumbersReturnArabicNumerals:(NSString *)chnStr{
    NSDictionary *chnNumChar = @{@"零":@0,@"一":@1,@"二":@2,@"两":@2,@"三":@3,@"四":@4,@"五":@5,@"六":@6,@"七":@7,@"八":@8,@"九":@9};
    NSDictionary *chnNameValue = @{
                                   @"十":@{@"value":@10, @"secUnit":@(false)},
                                   @"百":@{@"value":@100, @"secUnit":@(false)},
                                   @"千":@{@"value":@1000, @"secUnit":@(false)},
                                   @"万":@{@"value":@10000, @"secUnit":@(true)},
                                   @"亿":@{@"value":@100000000, @"secUnit":@(true)},
                                   };
    //DICT_CNNUM
    NSInteger number = 0;//用以接收下面循环遍历的数字字符的数值
    NSInteger section = 0;//用以万、亿字符节点前求和
    NSInteger rtn = 0;//若万、亿后再无如何字符，rtn便是最终结果，若有应加上section的计算值
    BOOL secUnit = false;//字符是否为万、亿
    
    //遍历字符串用数组接收单个字符
    NSMutableArray *strArrM = [NSMutableArray array];
    for (NSInteger i = 0;i < chnStr.length;i ++) {
        NSString *charStr = [chnStr substringWithRange:NSMakeRange(i, 1)];
        if (chnNumChar[charStr] != nil || chnNameValue[charStr] != nil) {
            NSString *tempStr = [chnStr substringWithRange:NSMakeRange(i - 1, 1)];
            //如果第一个字符为十则在其前面添‘一’；如果字符“十”的前一个字符为“零”或者前面没有数字字符则在其前面添“一”
            if (i == 0 && [charStr isEqual:@"十"]) {
                [strArrM addObject:@"一"];
            }else if( i > 0 && (chnNumChar[tempStr] == nil || [tempStr isEqual:@"零"]) && [charStr isEqual:@"十"]){
                [strArrM addObject:@"一"];
            }
            [strArrM addObject:charStr];
        }
    }
    
    //遍历字符数组
    for(NSInteger i = 0; i < strArrM.count; i++){
        //取出中文数字字符
        NSNumber *temNum = chnNumChar[strArrM[i]];
        NSInteger num = [temNum integerValue];
        
        if(temNum != nil){      //中文数字字符
            number = num;
            //若为最后一个字符直接相加
            if(i == strArrM.count - 1){
                section += number;
            }
        }else{      //中文单位字符
            //取出单位字符对应的数值
            NSNumber *temUnit = chnNameValue[strArrM[i]][@"value"];
            NSInteger unit = [temUnit integerValue];
            //取出单位字符对应的类型
            NSNumber *temSecUnit = chnNameValue[strArrM[i]][@"secUnit"];
            secUnit = [temSecUnit boolValue];
            if(!secUnit){
                //单位为十、百、千，拿数字值乘以单位数值，并累加
                section += (number * unit);
            }else{
                //单位为万、亿，拿前面的数值累加的结果乘以对应的单位数值
                section = (section + number) * unit;
                //累加
                rtn += section;
                //用后置零
                section = 0;
            }
            //用后置零
            number = 0;
        }
    }
    NSLog(@"中文数字：%@,阿拉伯数字：%ld",chnStr,rtn + section);
    return rtn + section;
}

///MARK: - --- 文字处理
/*
 +(NSString *)wordsDeal:(NSString *)str{
 NSArray *arr =  [str componentsSeparatedByString:@"，"];
 
 NSString *typeStr = @"";
 NSString *allStr = @"";
 for (NSString*subStr in arr) {
 NSArray *typeArr = @[@"件数",@"毛重",@"计费重量"];
 for (NSString *type in typeArr) {
 if ([subStr rangeOfString:type].location != NSNotFound) {
 typeStr = type;
 break;
 }
 }
 
 NSString *d5 = @"";
 if ([subStr rangeOfString:typeStr].location != NSNotFound) {
 d5 = [subStr stringByReplacingOccurrencesOfString:typeStr withString:@""];
 }else{
 continue;
 }
 
 NSInteger strNum =  [d5 integerValue];
 NSInteger num = 0;
 if (strNum > 0) {
 num = strNum;
 }else{
 num = [self chineseNumbersReturnArabicNumerals:d5];
 }
 
 NSString *countStr = [NSString stringWithFormat:@"%@%ld",typeStr,num];
 
 allStr = [NSString stringWithFormat:@"%@\n%@",allStr,countStr];
 }
 
 NSLog(@"%@",allStr);
 return allStr;
 }
 */

//MARK: - --- 文字提取匹配
+ (NSString *)textMatching:(NSString *)str{
    //例：
    str = @"件数十亿零十万零十，毛重三万五千..。计费重量六千三百四十八.";
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"@/／：；（）¥「」＂、【】;“[]{}#%-*+=_\\|~＜＞$€^•'@#$%^&*()_+'\"，,.。？?"];
    //NSString *trimmedString = [str stringByTrimmingCharactersInSet:set];
    NSString *trimmedString = [[str componentsSeparatedByCharactersInSet:set] componentsJoinedByString: @""];
    NSLog(@"%@",trimmedString);
    
    NSDictionary *chnNumChar = @{@"零":@0,@"一":@1,@"二":@2,@"两":@2,@"三":@3,@"四":@4,@"五":@5,@"六":@6,@"七":@7,@"八":@8,@"九":@9,@"0":@0,@"1":@1,@"2":@2,@"3":@3,@"4":@4,@"5":@5,@"6":@6,@"7":@7,@"8":@8,@"9":@9};
    NSDictionary *chnNameValue = @{
                                   @"十":@{@"value":@10, @"secUnit":@(false)},
                                   @"百":@{@"value":@100, @"secUnit":@(false)},
                                   @"千":@{@"value":@1000, @"secUnit":@(false)},
                                   @"万":@{@"value":@10000, @"secUnit":@(true)},
                                   @"亿":@{@"value":@100000000, @"secUnit":@(true)},
                                   };
    //    DICT_CNNUM
    NSMutableArray *allDic = [NSMutableArray array];//汉字对应的数字数组
    NSMutableArray *cnArr = [NSMutableArray array];//汉字数组
    NSMutableArray *digitalArr = [NSMutableArray array];//数字数组
    BOOL isNum =  NO;//是否是数字
    for (NSInteger i = 0; i < trimmedString.length; i ++) {
        NSString *charStr = [trimmedString substringWithRange:NSMakeRange(i, 1)];
        if (chnNumChar[charStr] != nil || chnNameValue[charStr] != nil) {
            isNum = YES;
            [digitalArr addObject:charStr];
            if (i == trimmedString.length - 1) {
                [allDic addObject:@[[cnArr componentsJoinedByString:@""],[digitalArr componentsJoinedByString:@""]]];
                [cnArr removeAllObjects];
                [digitalArr removeAllObjects];
            }
        }else{
            if (i > 0 && isNum == YES) {
                [allDic addObject:@[[cnArr componentsJoinedByString:@""],[digitalArr componentsJoinedByString:@""]]];
                [cnArr removeAllObjects];
                [digitalArr removeAllObjects];
                isNum = NO;
            }
            [cnArr addObject:charStr];
        }
    }
    
    NSString *endStr = @"\n";
    for (NSArray *valu in allDic) {
        NSInteger number = 0;
        if ([valu[1] integerValue] > 0) {
            //科大讯飞识别“万”的问题。
            number = [valu[1] integerValue];
            if([valu[1] hasSuffix:@"万"]){
                number = [valu[1] integerValue] * 10000;
            }
        }else{
            //number = [self chineseNumbersReturnArabicNumerals:valu[1]];
            number = [self elseFun:valu[1]];
        }
        endStr = [endStr stringByAppendingString:[NSString stringWithFormat:@"%@ = %ld;\n",valu[0],number]];
    }
    NSLog(@"%@",endStr);
    return endStr;
}

//MARK: - --- 数字转换
+(NSInteger)elseFun:(NSString *)chnStr{
    //chnStr = @"十一亿一千一百一十一万一千一百一十一";
    NSDictionary *chnNumChar = @{@"零":@0,@"一":@1,@"二":@2,@"两":@2,@"三":@3,@"四":@4,@"五":@5,@"六":@6,@"七":@7,@"八":@8,@"九":@9,@"十":@10,@"百":@100,@"千":@1000,@"万":@10000,@"亿":@100000000};
    //遍历字符串用数组接收单个字符
    NSMutableArray *strArrM = [NSMutableArray array];
    for (NSInteger i = 0;i < chnStr.length;i ++) {
        NSString *charStr = [chnStr substringWithRange:NSMakeRange(i, 1)];
        if (chnNumChar[charStr] != nil) {
            NSString *tempStr = [chnStr substringWithRange:NSMakeRange(i - 1, 1)];
            //如果第一个字符为十则在其前面添‘一’；如果字符“十”的前一个字符为“零”或者前面没有数字字符则在其前面添“一”
            if (i == 0 && [charStr isEqual:@"十"]) {
                [strArrM addObject:@"一"];
            }else if( i > 0 && (chnNumChar[tempStr] == nil || [tempStr isEqual:@"零"]) && [charStr isEqual:@"十"]){
                [strArrM addObject:@"一"];
            }
            [strArrM addObject:charStr];
        }
    }
    NSArray *arr = [[strArrM reverseObjectEnumerator] allObjects];//数组倒序
    NSInteger total = 0;//总值
    NSInteger r = 1;//位权
    NSInteger u = 1;//记录单位节点
    for (NSInteger i = 0; i < arr.count; i ++) {
        NSInteger val = [chnNumChar[arr[i]] integerValue];//从右至左(从低位到高位)逐位取值 ←----
        if (val >= 10){        //单位字符
            if (val > r) {      //如果此时的字符单位值大于之前的位权
                //把单位值赋值给位权r，并记录此时的最大单位u
                r = val;
                u = val;
            }else{      //如果此时的字符单位值不大于之前的位权
                //此前的最大单位u与此时的字符单位的乘积即为此时的位权
                r = u * val;
            }
        }else{      //数字字符
            //累加计算当前的总值
            total +=  r * val;
            //NSLog(@"%ld",total);
        }
    }
    NSLog(@"\n====\n    中文数字： %@ ;\n    阿拉伯数字：%ld 。\n====",chnStr,total);
    return total;
}

+ (NSString *)chineseFromeArabicNum:(NSInteger)arabicNum
{
    NSString *arabicNumStr = [NSString stringWithFormat:@"%ld",(long)arabicNum];
    NSArray *arabic_numerals = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0"];
    NSArray *chinese_numerals = @[@"一",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"零"];
    NSArray *digits = @[@"个",@"十",@"百",@"千",@"万",@"十",@"百",@"千",@"亿",@"十",@"百",@"千",@"兆"];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:chinese_numerals forKeys:arabic_numerals];
    
    if (arabicNumStr.length >= digits.count)
    {
        // 科学计数法
        long double num = [[NSString stringWithFormat:@"%@",arabicNumStr] floatValue];
        NSString *aaa = [self scientificCounting:num rms:3];
        return aaa;
    }
    else
    {
        NSMutableArray *sums = [NSMutableArray array];
        for (int i = 0; i < arabicNumStr.length; i ++) {
            NSString *substr = [arabicNumStr substringWithRange:NSMakeRange(i, 1)];
            NSString *a = [dictionary objectForKey:substr];
            NSString *b = digits[arabicNumStr.length -i-1];
            NSString *sum = [a stringByAppendingString:b];
            if ([a isEqualToString:chinese_numerals[9]])
            {
                if([b isEqualToString:digits[4]] || [b isEqualToString:digits[8]])
                {
                    sum = b;
                    if ([[sums lastObject] isEqualToString:chinese_numerals[9]])
                    {
                        [sums removeLastObject];
                    }
                }
                else
                {
                    sum = chinese_numerals[9];
                }
                if ([[sums lastObject] isEqualToString:sum])
                {
                    continue;
                }
            }
            [sums addObject:sum];
        }
        
        NSString *sumStr = [sums  componentsJoinedByString:@""];
        NSString *chinese = [sumStr substringToIndex:sumStr.length-1];
        //    NSLog(@"str %@",str);
        NSLog(@"%s  %@", __func__, chinese);
        return chinese;
    }
}


/*
 科学计数法，保留n个有效值
 */
+ (NSString *)scientificCounting:(double)d rms:(NSInteger)n
{
    if(n == 0)
    {
        return nil;
    }
    //科学计算法 一般写法4.232E这种样式 这里的n代表所有数字的个数 所以这里n++
    n++;
    //判断小数的位数是否超过设定的n的值 如果超过了保留n位有效数字 如果不超过则保留默认小数位数
    //先将double转换成字符串
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSString *dbStr = [formatter stringFromNumber:[NSDecimalNumber numberWithDouble:d]];
    NSInteger length = dbStr.length;
    if ([dbStr containsString:@"."])
    {
        length = dbStr.length - 1;
    }
    if (length < n)
    {
        n = length;
    }
    
    CFLocaleRef currentLocale = CFLocaleCopyCurrent();
    CFNumberFormatterRef customCurrencyFormatter = CFNumberFormatterCreate
    (NULL, currentLocale, kCFNumberFormatterCurrencyStyle);
    NSString *s_n = @"#";
    if(n > 1)
    {
        for(int j = 0; j < n; j++)
        {
            NSString *temp = s_n;
            if(j == 0)
            {
                s_n = [temp stringByAppendingString:@"."];
            }
            else
            {
                s_n = [temp stringByAppendingString:@"0"];
            }
        }
    }
    CFNumberFormatterSetFormat(customCurrencyFormatter, (CFStringRef)s_n);
    
    double i=1;
    int exponent = 0;
    while (1)
    {
        i = i*10;
        if(d < i)
        {
            break;
        }
        exponent++;
    }
    double n1 = d * 10 / i;
    
    CFNumberRef number1 = CFNumberCreate(NULL, kCFNumberDoubleType, &n1);
    CFStringRef string1 = CFNumberFormatterCreateStringWithNumber
    (NULL, customCurrencyFormatter, number1);
    
    NSString * result = [NSString stringWithFormat:@"%@e%d",(__bridge NSString *)string1,exponent];
    
    CFRelease(currentLocale);
    CFRelease(customCurrencyFormatter);
    CFRelease(number1);
    CFRelease(string1);
    
    return result;
    
}

@end
