// Compound wait: changes to either operand re-evaluate the condition
module vlog109;
  reg a = 0;
  reg b = 0;

  initial begin
    #5  a = 1;  // b still 0, must not fall through
    #5  b = 1;  // now both true
  end

  initial begin
    wait (a && b);
    if ($time === 10)
      $display("PASSED");
    else
      $display("FAILED at t=%0t", $time);
    $finish;
  end
endmodule
