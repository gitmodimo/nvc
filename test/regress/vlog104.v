// Old-style task port with inout declared in task body.
module vlog104;
    reg [7:0] x, y;

    task swap;
        inout [7:0] a;
        inout [7:0] b;
        reg [7:0] tmp;
        begin
            tmp = a;
            a = b;
            b = tmp;
        end
    endtask

    task increment;
        inout [7:0] val;
        begin
            val = val + 1;
        end
    endtask

    initial begin
        x = 8'd10;
        y = 8'd20;

        swap(x, y);
        if (x !== 8'd20 || y !== 8'd10) begin
            $display("FAILED: swap got x=%0d y=%0d", x, y);
            $finish;
        end

        increment(x);
        if (x !== 8'd21) begin
            $display("FAILED: increment got x=%0d", x);
            $finish;
        end

        $display("PASSED");
        $finish;
    end
endmodule // vlog104
