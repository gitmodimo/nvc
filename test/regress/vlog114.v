// wait (cond) stmt; - the trailing statement executes after wake-up
module vlog114;
  reg ready = 0;
  integer x = 0;

  initial begin
    #10;
    ready = 1;
  end

  initial begin
    wait (ready) x = 42;
    if (x === 42 && $time === 10)
      $display("PASSED");
    else
      $display("FAILED x=%0d t=%0t", x, $time);
    $finish;
  end
endmodule
