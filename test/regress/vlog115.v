// Bit-select inside wait: a trigger on the enclosing vector must wake us
module vlog115;
  reg [3:0] bus = 4'b0000;

  initial begin
    #5  bus = 4'b0010;  // bus[1] but not bus[3]
    #5  bus = 4'b1000;  // bus[3] now set
  end

  initial begin
    wait (bus[3]);
    if ($time === 10)
      $display("PASSED");
    else
      $display("FAILED at t=%0t", $time);
    $finish;
  end
endmodule
