// Basic wait: suspend until another process raises the signal
module vlog107;
  reg ready = 0;

  initial begin
    #10;
    ready = 1;
  end

  initial begin
    wait (ready);
    if ($time === 10)
      $display("PASSED");
    else
      $display("FAILED at t=%0t", $time);
    $finish;
  end
endmodule
