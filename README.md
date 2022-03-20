# riscv_core
This is a simplified RISC_V core based on E203 which is permitted for learning use only.

# 项目简介
本项目旨在设计一款基于RISC-V架构的低功耗小面积CPU，CPU原型为胡振波老师开发的蜂鸟E203，设计时参考了《手把手教你设计CPU—RISC-V处理器篇》和RISC-V基金会发布的官方文档。由于本人是在研究生阶段自学的数字电路设计，水平有限，很多超标量处理器所使用的深层次结构，例如cache，并未在本项目中实现，期待以后有机会再进一步地补充。感谢浙江米芯微电子有限公司吕尧明经理、浙江大学微纳电子学院丁勇教授以及湖南芯钛电子科技有限公司崔健工程师在技术和环境上给予的支持。本项目向所有的CPU设计初学者和爱好者开放，技术研讨欢迎邮件联系shaojiayuanic@hotmail.com.

# Introduction
This project is intended to design a low-power CPU based on RISC-V architecture with the prototype of hummingbird E203 developed by Bob Hu. Our references are the official documents published by RISC-V Foundation and the technical literature written by Mr. Hu. Due to the limitation of my experience on the field of digital circuit design, many deep-level structures used by advanced processor, such as cache, have not been implemented in this project. Thanks for the technical and environmental support from Mr. Lv, Dr. Ding and Mr. Cui. This project is open to all CPU designers and enthusiasts. Technical discussions are welcomed with the e-mail address of shaojiayuanic@hotmail.com.

# 修改记录
2022.02.13  v1.0  初始版本；  
2022.02.16  v1.1  对存储模块进行了修正，存储模块可以与core差速运行，存储和读取指令运行周期数允许不确定；  
2022.02.22  v1.2  针对外部中断进行了仿真和修正；  
2022.02.24  v1.3  修正了处理中断过程中出现的若干bug，修正了中断屏蔽失效，优化了commit及其子模块；  
2022.03.06  v1.4  完成intagent的设计与接入，修正intagent bug中；  
2020.03.15  v1.5  intagent功能通过测试，bug基本修复;  
2020.03.16  v1.6  修正了ifu对于jump和branch指令的行为，当前版本基于可异步读itcm，jump和branch指令开销1-2时钟周期;  
2020.03.20  v1.7  调整了flash模块的行为，加入了时钟信号，将原有的itcm替换为同步读itcm，重写了ifu模块，是否支持intagent还有待确认；  

# 目前在做
DM模块  

# 贡献者
Chario Shaw;  
Yakun Hu;  



