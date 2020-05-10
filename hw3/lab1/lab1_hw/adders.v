`ifndef ADDERS
`define ADDERS
`include "gates.v"

// half adder
module HA(output C, S, input A, B);
	XOR g0(S, A, B);
	AND g1(C, A, B);
endmodule

// full adder
module FA(output C, S, input A, B, CI);
	wire c0, s0, c1, s1;
	HA ha0(c0, s0, A, B);
	HA ha1(c1, s1, s0, CI);
	assign S = s1;
	OR or0(C, c0, c1);
endmodule

// adder without delay, register-transfer level modeling
module adder_rtl(
	output C3,       // carry output
	output[2:0] S,   // sum
	input[2:0] A, B, // operands
	input C0         // carry input
	);
	
	// Implement your code here.
	// Hint: should be done in 1 line.
	// You can use this adder to debug the gate-level implemented adder.
	assign {C3, S} = A + B + C0;
	// wire t;
	// assign t = 1'b1;
	// assign {C3, S} = A + t;
endmodule

//  ripple-carry adder, gate level modeling
module rca_gl(
	output C3,       // carry output
	output[2:0] S,   // sum
	input[2:0] A, B, // operands
	input C0         // carry input
	);
	wire[3:0] c;
	assign c[0] = C0;
	assign C3 = c[3];
	FA fa0(c[1], S[0], A[0], B[0], c[0]);
	FA fa1(c[2], S[1], A[1], B[1], c[1]);
	FA fa2(c[3], S[2], A[2], B[2], c[2]);
endmodule

// carry-lookahead adder, gate level modeling
module cla_gl(
	output C3,       // carry output
	output[2:0] S,   // sum
	input[2:0] A, B, // operands
	input C0         // carry input
	);
	
	// Implement your code here.
	// define wires
	wire[3:0] c;
	wire[2:0] g;
	wire[2:0] p;
	wire p0c0, g0p1, c0p0p1, g1p2, g0p1p2, c0p0p1p2;
	wire t, f;
	assign t = 1'b1;
	assign f = 1'b0;
	assign c[0] = C0;
	assign C3 = c[3];

	// g, p
	AND and_a0b0(g[0], A[0], B[0]);
	AND and_a1b1(g[1], A[1], B[1]);
	AND and_a1b2(g[2], A[2], B[2]);
	XOR xor_a0b0(p[0], A[0], B[0]);
	XOR xor_a1b1(p[1], A[1], B[1]);
	XOR xor_a2b2(p[2], A[2], B[2]);

	// c
	AND and_p0c0(p0c0, p[0], c[0]);
	AND and_g0p1(g0p1, g[0], p[1]);
	AND4 and_c0p0p1(c0p0p1, c[0], p[0], p[1], t);
	AND and_g1p2(g1p2, g[1], p[2]);
	AND4 and_g0p1p2(g0p1p2, g[0], p[1], p[2], t);
	AND4 and_c0p0p1p2(c0p0p1p2, c[0], p[0], p[1], p[2]);
	
	OR or_1(c[1], g[0], p0c0);
	OR4 or_2(c[2], g[1], g0p1, c0p0p1, f);
	OR4 or_3(c[3], g[2], g1p2, g0p1p2, c0p0p1p2);

	// S
	XOR s0(S[0], p[0], c[0]);
	XOR s1(S[1], p[1], c[1]);
	XOR s2(S[2], p[2], c[2]);

endmodule

`endif