// wait inside forever must re-suspend on each iteration
module vlog112;
  reg ping = 0;
  integer cnt = 0;

  initial begin
    #5  ping = 1;  #1  ping = 0;
    #5  ping = 1;  #1  ping = 0;
    #5  ping = 1;  #1  ping = 0;
  end

  initial begin
    forever begin
      wait (ping);
      cnt = cnt + 1;
      if (cnt === 3) begin
        if ($time === 17)
          $display("PASSED");
        else
          $display("FAILED at t=%0t", $time);
        $finish;
      end
      wait (!ping);
    end
  end
endmodule
