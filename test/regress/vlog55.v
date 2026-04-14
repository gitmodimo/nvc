// Test: delay on MOS switch and bidirectional gate primitives.
// IEEE 1364-2005 §7.1. All gate types accept #delay.

module vlog55;
    wire y1, y2, y3, y4, y5, y6;
    wire b1, b2;
    reg a, c, n, p;

    nmos  #1 g1 (y1, a, c);
    pmos  #1 g2 (y2, a, c);
    cmos  #1 g3 (y3, a, n, p);
    rnmos #1 g4 (y4, a, c);
    rpmos #1 g5 (y5, a, c);
    rcmos #1 g6 (y6, a, n, p);
    tran  #1 g7 (b1, b2);
    rtran #1 g8 (b1, b2);

    initial begin
        a = 1; c = 1; n = 1; p = 0;
        #10;
        if (y1 !== 1'b1) begin
            $display("FAILED nmos: y1=%b", y1);
            $finish;
        end
        if (y2 !== 1'b1) begin
            $display("FAILED pmos: y2=%b", y2);
            $finish;
        end
        $display("PASSED");
        $finish;
    end
endmodule
