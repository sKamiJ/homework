#======================================================================
#文件名称：main.s      
#功能概要：汇编编程控制小灯闪烁
#版权所有：苏州大学NXP嵌入式中心(sumcu.suda.edu.cn)
#版本更新：2013-06-05 V1.0; 2016-03-03 V2.0
#======================================================================
#include "include.S"

#start 主函数定义开始
    .section   .text.main
    .global main				@定义全局变量，在芯片初始化之后调用
    .align 2					@指令对齐
    .type main function			@定义主函数类
    .align 2
#end  主函数定义结束
main:
    cpsid i						@关闭总中断

    mov r6,#0					@灯指示标志
    #小灯初始化, r0,r3是light_init的入口参数
    #初始化蓝灯为暗
    ldr r0,=LIGHT_BLUE			@r0指明端口和引脚（用=是因为宏常数>=256,且用ldr)
    mov r3,#LIGHT_OFF			@r3指明引脚的初始状态
    bl light_init				@调用小灯初始化函数
    #初始化红灯为暗
    ldr r0,=LIGHT_RED			@r0指明端口和引脚
    bl light_init				@调用小灯初始化函数，r3已经是LIGHT_OFF
    #初始化绿灯为暗
    ldr r0,=LIGHT_GREEN			@r0指明端口和引脚
    bl light_init				@调用小灯初始化函数，r3已经是LIGHT_OFF

	cpsie  i					@开总中断
#主循环开始==================================================================
main_loop1:
    ldr r4,=RUN_COUNTER_MAX		@取延时值到r4
    mov r5,#0					@从零计数

loop:
    add r5,#1					@加1计数
    cmp r4,r5					@r4值与r5值比较
    bne loop					@不相等，则跳转loop

	#根据灯指示标志的值更改相应的灯
	cmp r6,#0
	beq red_light				@更改为红灯
	cmp r6,#1
	beq yellow_light			@更改为黄灯
	cmp r6,#2
	beq green_light				@更改为绿灯
	cmp r6,#3
	beq cyan_light				@更改为青灯
	cmp r6,#4
	beq white_light				@更改为白灯
	cmp r6,#5
	beq purple_light			@更改为紫灯
	cmp r6,#6
	beq blue_light				@更改为蓝灯

red_light:
	#先要关闭蓝灯
	ldr r0,=LIGHT_BLUE			@r0指明端口和引脚
	mov r3,#LIGHT_OFF			@r3指明引脚的控制状态
	bl light_control			@调用小灯控制函数
	#设置r0为红灯
	ldr r0,=LIGHT_RED			@r0指明端口和引脚
	b switch_end				@跳转switch_end
yellow_light:
	#设置r0为绿灯
	ldr r0,=LIGHT_GREEN			@r0指明端口和引脚
	b switch_end				@跳转switch_end
green_light:
	#设置r0为红灯
	ldr r0,=LIGHT_RED			@r0指明端口和引脚
	b switch_end				@跳转switch_end
cyan_light:
	#设置r0为蓝灯
	ldr r0,=LIGHT_BLUE			@r0指明端口和引脚
	b switch_end				@跳转switch_end
white_light:
	#设置r0为红灯
	ldr r0,=LIGHT_RED			@r0指明端口和引脚
	b switch_end				@跳转switch_end
purple_light:
	#设置r0为绿灯
	ldr r0,=LIGHT_GREEN			@r0指明端口和引脚
	b switch_end				@跳转switch_end
blue_light:
	#设置r0为红灯，因为要重置r6，所以没有跳转至switch_end
	ldr r0,=LIGHT_RED			@r0指明端口和引脚
	bl light_change				@调用小灯亮暗转变函数
	mov r6,#0					@重置灯指示标志
	b main_loop1				@跳转main_loop1

switch_end:
	bl light_change				@调用小灯亮暗转变函数，r0的设置在switch中完成
	add r6,#1					@变更灯指示标志
    b main_loop1				@跳转main_loop1

#主循环结束==================================================================
.end

