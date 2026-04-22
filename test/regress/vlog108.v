// wait with a condition already true must fall through without suspending
module vlog108;
  reg flag = 1;

  initial begin
    wait (flag);
    if ($time === 0)
      $display("PASSED");
    else
      $display("FAILED at t=%0t", $time);
    $finish;
  end
endmodule
