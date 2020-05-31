4 (1)

```verilog
module mult_fast(
	output reg[7:0] P,  // product
	input[3:0] A, B,    // multiplicand and multiplier
	input clk		    // clock (posedge)
	);
	// stage 0 (input)
	reg[3:0] a_s0, b_s0;
	always @(posedge clk) begin
		a_s0 <= A;
		b_s0 <= B;
	end
	// stage 1
	wire[3:0] pp0 = a_s0 & {4{b_s0[0]}}; // ignore the delays of AND gates
	wire[4:1] pp1 = a_s0 & {4{b_s0[1]}}; // ignore the delays of AND gates
	wire[5:2] pp2 = a_s0 & {4{b_s0[2]}}; // ignore the delays of AND gates
	wire[6:3] pp3 = a_s0 & {4{b_s0[3]}}; // ignore the delays of AND gates
	reg[5:1] sum1;
	always @(pp0, pp1)
		sum1[5:1] <= #7 pp0[3:1] + pp1[4:1]; // delay of the 4-bit adder
	reg[7:3] sum3;
	always @(pp2, pp3)
		sum3[7:3] <= #7 pp2[5:3] + pp3[6:3]; // delay of the 4-bit adder
	reg[5:0] sum1_s1;
	reg[7:2] sum3_s1;
	always @(posedge clk) begin
		sum1_s1 <= {sum1, pp0[0]};
		sum3_s1 <= {sum3, pp2[2]};
	end
	// stage 2 (outout)
	reg[7:2] sum2;
	always @(sum1_s1, sum3_s1)
		sum2[7:2] <= #8 sum1_s1[5:2] + sum3_s1[7:2]; // delay of the 6-bit adder
	always @(posedge clk) begin
		P <= {sum2, sum1_s1[1:0]};
	end
endmodule
```



4 (2)

<img src="/Users/shaoyu/Desktop/螢幕快照 2020-05-31 上午11.09.39.png" alt="螢幕快照 2020-05-31 上午11.09.39" style="zoom:50%;" />



5(1)

The minimum clock cycle is 8 ticks.



5(2)

<img src="/Users/shaoyu/Desktop/螢幕快照 2020-05-31 下午6.07.43.png" alt="螢幕快照 2020-05-31 下午6.07.43" style="zoom:50%;" />



6(1)

Assume the clock cycle is 10 microseconds.

A logic operation can be done within 10 microseconds. That is to say $\frac{1}{10 \times 10^{-6}} = 10^5$ logic operations can be done per second.

Therefore, the throughput is $10^5$.



6(2)

With the implementation of  `mult_fast`, stage 0 can be done with no delay, stage 1 can be done with a delay of 7 microseconds, and stage 2 can be done with a delay of 8 microseconds.

Though stage 1 can be done with a delay of 7 microseconds, it still takes a clock cycle to move on to stage 2.

Therefore, the latency is $10+8=18$ microseconds.