# 代码风格与信号命名

# 信号命名的原则
- 尽可能的简单，使得一看便可以明白信号的作用
- 不宜使用过长的命名

# 代码风格

## 关于注释
注释的原则是尽可能的**简介**，使用**英文注释**，对于代码中不确定的使用**TBD**(To Be Determine)来进行标注，***不需要的注释将其删除***，保证所写的内容是有效的，对于无用冗杂的注释同没有注释同样是可恶的。

## 其他代码风格举例总结
很难使用语言将其描述，最好的就是使用例子进行展示并进行总结
举例如下
```
always@(posedge clk or negedge rst_n) begin
	if(rst_n == 1'b0)
		rx_flag <= 1'b0;
	else if(rx_nedge == 1'b1)
	    rx_flag	<= 1'b1;
    else if(bit_cnt == 4'd9 && baud_cnt == baud_cnt_end)
	    rx_flag <= 1'b0;
end
```
需要注意的地方有这几点

### 1，always块儿的begin...end对齐
```
always@(posedge clk or negedge rst_n) begin 

end
```
使用以上的对齐方式

### 2，所有的if判断写完整
`if(rst_n == 1'b0)`不要写成`if(!rst_n)`

### 3，一个always块中只对一个信号进行操作

### 4，当有多个信号时候，举例如下:
```
always@(posedge clk or negedge rst_n) begin
    if(rst_n == 1'b0) begin 
		rx_ff1 <= 1'b0;
		rx_ff2 <= 1'b0;
		rx_ff3 <= 1'b0;
    end 
    else begin 
		rx_ff1 <= rx_data;
		rx_ff2 <= rx_ff1;
		rx_ff3 <= rx_ff2;
    end 
end 
```
这里需要注意的是begin...end的位置。begin放在开始的那一行，end与if(或者是其他begin对应的开始点的关键词)对齐