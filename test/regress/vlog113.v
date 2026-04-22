// X and Z are treated as false (IEEE 1800 §9.4.2); wait keeps suspended
// until the expression becomes a known non-zero value.
module vlog113;
  reg a;  // starts at X

  initial begin
    #5  a = 1'bz;  // still not known non-zero
    #5  a = 1'b0;  // explicit zero
    #5  a = 1'b1;  // finally true
  end

  initial begin
    wait (a);
    if ($time === 15)
      $display("PASSED");
    else
      $display("FAILED at t=%0t", $time);
    $finish;
  end
endmodule
