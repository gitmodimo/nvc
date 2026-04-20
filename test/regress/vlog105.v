module vlog105;
  reg [7:0] x;
  reg [31:0] y;

  initial begin
    x = 8'hff;
    y = 32'hdeadbeef;

    x <= #20 'b0;
    y <= #20 'b0;

    #1;
    if (x !== 8'hff) begin
      $display("FAILED: x changed too early, got %h", x);
      $finish;
    end
    if (y !== 32'hdeadbeef) begin
      $display("FAILED: y changed too early, got %h", y);
      $finish;
    end

    #20;
    if (x !== 8'h00) begin
      $display("FAILED: x should be 0, got %h", x);
      $finish;
    end
    if (y !== 32'h00000000) begin
      $display("FAILED: y should be 0, got %h", y);
      $finish;
    end

    $display("PASSED");
  end

endmodule // vlog105
