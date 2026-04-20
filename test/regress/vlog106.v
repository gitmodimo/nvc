// Test: `timescale after (* attribute *) between modules.
// IEEE 1364-2005 §2.8: attributes can appear before module declarations.
// A `timescale directive between an attribute and a module must be
// accepted as a preprocessor directive, not rejected as a description item.

`timescale 1ns/1ps

(* synthesizable = "false" *)
module vlog106_sub(input wire clk, output reg q);
    always @(posedge clk)
        q <= ~q;
endmodule

(* category = "testbench" *)

`timescale 1ps/1ps

(* synthesizable = "false" *)
module vlog106;
    reg clk;
    wire q;

    vlog106_sub u(.clk(clk), .q(q));

    initial begin
        clk = 0;
        #10;
        clk = 1;
        #10;
        clk = 0;
        #10;
        clk = 1;
        #10;

        $display("PASSED");
        $finish;
    end
endmodule
