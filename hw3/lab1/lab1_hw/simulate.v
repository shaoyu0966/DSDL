`include "gates.v"
`include "adders.v"

module lab1_main();
	reg[2:0] a, b;
	reg c0;
	wire[2:0] s, s_gl, s_rca;
	wire c3, c3_gl, c3_rca;
	adder_rtl adder(c3, s, a, b, c0);
	cla_gl adder_gl(c3_gl, s_gl, a, b, c0);
	rca_gl adder_rca(c3_rca, s_rca, a, b, c0);
	
	// simulate
	integer i, j;
	initial begin
		
		// dump files for GTKWave to read
		$dumpfile("simulate.vcd");
		$dumpvars(0, lab1_main);
		
		// print a line if the listed variables change value
		$display("   time    a     b   c0   gl");
		$monitor("%7d / %b / %b / %b / %b%b",
			$time, a, b, c0, c3_gl, s_gl);
		
		// loop through all possible transitions
        i = 7'b1110000;
        j = 7'b0001110;
		{a, b, c0} <= 0;
        {a, b, c0} <= i;
        #100;
        {a, b, c0} <= j;
        #100;

	end
endmodule