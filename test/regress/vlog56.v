// Test: block comment inside `define body should be ignored.
// IEEE 1364-2005 §16.3.1: the replacement text of a macro is the
// remainder of the line after the macro name, with comments removed.

`define EMPTY_MACRO /* null */
`define VAL_WITH_COMMENT 42 /* the answer */

module vlog56;
    integer x;

    initial begin
        x = `VAL_WITH_COMMENT;
        if (x !== 42) begin
            $display("FAILED: x=%0d expected 42", x);
            $finish;
        end

        $display("PASSED");
        $finish;
    end
endmodule