// Wait inside a task: suspension across call boundary
module vlog110;
  reg go = 0;

  task wait_for_go;
    begin
      wait (go);
    end
  endtask

  initial begin
    #20;
    go = 1;
  end

  initial begin
    wait_for_go;
    if ($time === 20)
      $display("PASSED");
    else
      $display("FAILED at t=%0t", $time);
    $finish;
  end
endmodule
