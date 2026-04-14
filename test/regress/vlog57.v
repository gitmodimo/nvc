// Test: $realtime used in arithmetic expressions.
// IEEE 1364-2005 §17.7.1: $realtime returns a real number representing
// the current simulation time.  It must be usable in real arithmetic
// (subtraction, division, comparison).

`timescale 1ns/1ps

module vlog57;
    realtime prev;
    real     delta;
    real     acc;
    integer  count;

    initial begin
        prev = $realtime;
        #10;
        delta = $realtime - prev;

        if (delta < 9.0 || delta > 11.0) begin
            $display("FAILED: delta=%f expected ~10.0", delta);
            $finish;
        end

        // Test division on reals
        delta = delta / 2.0;
        if (delta < 4.5 || delta > 5.5) begin
            $display("FAILED: delta/2=%f expected ~5.0", delta);
            $finish;
        end

        // Test compound assignment operators on reals
        acc = 100.0;
        acc += 10.0;
        if (acc < 109.5 || acc > 110.5) begin
            $display("FAILED: acc += %f expected 110.0", acc);
            $finish;
        end

        acc -= 20.0;
        if (acc < 89.5 || acc > 90.5) begin
            $display("FAILED: acc -= %f expected 90.0", acc);
            $finish;
        end

        acc *= 2.0;
        if (acc < 179.5 || acc > 180.5) begin
            $display("FAILED: acc *= %f expected 180.0", acc);
            $finish;
        end

        acc /= 3.0;
        if (acc < 59.5 || acc > 60.5) begin
            $display("FAILED: acc /= %f expected 60.0", acc);
            $finish;
        end

        // Test unary NOT on real
        acc = 0.0;
        if (!acc)
            acc = 42.0;
        if (acc < 41.5 || acc > 42.5) begin
            $display("FAILED: !real %f expected 42.0", acc);
            $finish;
        end

        // Test real as if-condition (nonzero is true)
        acc = 5.0;
        if (acc)
            count = 1;
        else
            count = 0;
        if (count != 1) begin
            $display("FAILED: if(real) count=%0d expected 1", count);
            $finish;
        end

        // Test ternary with real operands
        acc = (count == 1) ? 3.14 : 0.0;
        if (acc < 3.0 || acc > 3.5) begin
            $display("FAILED: ternary real %f expected 3.14", acc);
            $finish;
        end

        // Test while loop with real condition
        acc = 3.0;
        count = 0;
        while (acc > 0.5) begin
            acc -= 1.0;
            count = count + 1;
        end
        if (count != 3) begin
            $display("FAILED: while(real) count=%0d expected 3", count);
            $finish;
        end

        $display("PASSED");
        $finish;
    end
endmodule
