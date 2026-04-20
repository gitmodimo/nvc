module vlog103;
  reg [7:0] q, a;
  reg [1:0] sel;
  reg       clk;

  always @(posedge clk) begin
    case (sel)
      2'b00: assign q = 8'haa;
      2'b01: assign q = 8'hbb;
      2'b10: begin
        assign q = 8'hcc;
        deassign q;
      end
      default: assign q = a;
    endcase
  end

  initial begin
    clk = 0;
    sel = 2'b00;
    a = 8'h00;

    // Test 1: basic assign with constant
    #1 clk = 1;
    #1 clk = 0;
    #1;
    if (q !== 8'haa) begin
      $display("FAILED test1: sel=00, expected aa, got %h", q);
      $finish;
    end

    // Test 2: switch to different assign
    sel = 2'b01;
    #1 clk = 1;
    #1 clk = 0;
    #1;
    if (q !== 8'hbb) begin
      $display("FAILED test2: sel=01, expected bb, got %h", q);
      $finish;
    end

    // Test 3: assign overrides normal procedural assignment
    q = 8'h00;
    #1;
    if (q !== 8'hbb) begin
      $display("FAILED test3: expected bb (assign override), got %h", q);
      $finish;
    end

    // Test 4: assign then deassign retains value
    sel = 2'b10;
    #1 clk = 1;
    #1 clk = 0;
    #1;
    if (q !== 8'hcc) begin
      $display("FAILED test4: sel=10, expected cc, got %h", q);
      $finish;
    end

    // Test 5: after deassign, normal assignment works
    q = 8'h42;
    #1;
    if (q !== 8'h42) begin
      $display("FAILED test5: expected 42, got %h", q);
      $finish;
    end

    // Test 6: assign with non-constant RHS, continuous re-evaluation
    sel = 2'b11;
    a = 8'hee;
    #1 clk = 1;
    #1 clk = 0;
    #1;
    if (q !== 8'hee) begin
      $display("FAILED test6: expected ee, got %h", q);
      $finish;
    end

    // Test 7: RHS changes -> q should update (continuous)
    a = 8'hff;
    #1;
    if (q !== 8'hff) begin
      $display("FAILED test7: expected ff, got %h", q);
      $finish;
    end

    // Test 8: assign still overrides normal procedural assignment
    q = 8'h00;
    #1;
    if (q !== 8'hff) begin
      $display("FAILED test8: expected ff (assign override), got %h", q);
      $finish;
    end

    $display("PASSED");
  end
endmodule
