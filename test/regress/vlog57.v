// Test: $realtime used in arithmetic expressions.
// IEEE 1364-2005 §17.7.1: $realtime returns a real number representing
// the current simulation time.  It must be usable in real arithmetic
// (subtraction, division, comparison).

`timescale 1ns/1ps

module vlog57;
    realtime prev;
    real     delta;

    initial begin
        prev = $realtime;
        #10;
        delta = $realtime - prev;

        if (delta < 9.0 || delta > 11.0) begin
            $display("FAILED: delta=%f expected ~10.0", delta);
            $finish;
        end

        $display("PASSED");
        $finish;
    end
endmodule
