// Test: macro expanding to sized literal via nested macro.
// `W expands to 5, `Z expands to `W'd0, final value is 5'd0.

`define W 5
`define Z `W'd0

module vlog54;
    reg [`W-1:0] v;

    initial begin
        v = `Z;
        if (v !== 5'd0) begin
            $display("FAILED: v=%0d", v);
            $finish;
        end
        $display("PASSED");
        $finish;
    end
endmodule
