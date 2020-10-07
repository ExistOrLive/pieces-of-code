//
//  ZMPhilosopherDemo.m
//  Test
//
//  Created by 朱猛 on 2020/10/7.
//  Copyright © 2020 朱猛. All rights reserved.
//

#import "ZMPhilosopherDemo.h"

#define num 6             // 哲学家数量 5

#define PhilosopherLeft(i) ((i-1)%num)
#define PhilosopherRight(i) ((i+1)%num)

typedef enum{
    thinking,
    eating,
    hungry,
}PhilosopherStatus;


@interface ZMPhilosopherDemo(){

    PhilosopherStatus statuss[num];
    
    dispatch_semaphore_t mutex;               // 保证互斥
    
    NSMutableArray<dispatch_semaphore_t> *sems;       // 保证同步
    
}

@end

@implementation ZMPhilosopherDemo

- (void) philosopher{
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    for(int i =0 ; i < num; i++){
        dispatch_async(queue,^{
            while(true){
                [self take_forks:i];
                NSLog(@"%d start eating",i);
                sleep(3);
                [self put_forks:i];
                NSLog(@"%d end eating",i);
                sleep(3);
            }
        });
    }
    
    
}

- (instancetype) init{
    mutex = dispatch_semaphore_create(1);
    sems = [NSMutableArray new];
    for(int i = 0; i < num; i++){
        statuss[i] = thinking;
        [sems addObject:dispatch_semaphore_create(0)];
    }
    
    return self;
}

- (void) take_forks:(int) i{
    
    dispatch_semaphore_wait(mutex, DISPATCH_TIME_FOREVER);
    
    statuss[i] = hungry;
    
    [self test:i];
    
    dispatch_semaphore_signal(mutex);
    
    dispatch_semaphore_wait(sems[i], DISPATCH_TIME_FOREVER);
}

- (void) put_forks:(int)i{
    
    dispatch_semaphore_wait(mutex, DISPATCH_TIME_FOREVER);
    
    statuss[i] = thinking;
    
    [self test:PhilosopherRight(i)];
    [self test:PhilosopherLeft(i)];
    
    dispatch_semaphore_signal(mutex);
}


- (void) test:(int) i{
    if(statuss[i] == hungry && statuss[PhilosopherLeft(i)] != eating && statuss[PhilosopherRight(i)] != eating){
        statuss[i] = eating;
        dispatch_semaphore_signal(sems[i]);
    }
}




@end
