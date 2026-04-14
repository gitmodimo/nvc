// Test: delay on MOS switch and bidirectional gate primitives.
// IEEE 1364-2005 §7.1.6: MOS switches pass data when enabled, output Z
// when disabled.  tran/rtran are always-on bidirectional passes.
// Resistive (r-prefixed) variants reduce output drive strength; this is
// tested by competing against a pullup of known pull strength.

module vlog55;
    wire y1, y2, y3, y4, y5, y6;
    wire b1, b2;
    wire te1, te2, rte1, rte2;
    reg a, c, n, p;
    reg drv;
    reg tctrl;

    // MOS switches: (output, data, control)
    nmos  #1 g1 (y1, a, c);
    pmos  #1 g2 (y2, a, c);
    rnmos #1 g4 (y4, a, c);
    rpmos #1 g5 (y5, a, c);

    // CMOS switches: (output, data, ncontrol, pcontrol)
    cmos  #1 g3 (y3, a, n, p);
    rcmos #1 g6 (y6, a, n, p);

    // Bidirectional passes
    tran  #1 g7 (b1, b2);
    rtran #1 g8 (b1, b2);

    // Pass-enable switches: (inout, inout, control)
    // tranif1 conducts when ctrl=1; tranif0 conducts when ctrl=0
    tranif1  #1 g9  (te1, b2, tctrl);
    tranif0  #1 g10 (te2, b2, tctrl);
    rtranif1 #1 g11 (rte1, b2, tctrl);
    rtranif0 #1 g12 (rte2, b2, tctrl);

    // Drive one side of tran/rtran
    assign b2 = drv;

    // -- Strength tests --
    // Each wire has a pullup (pull strength, drives to 1).
    // A non-r gate driving 0 at strong strength should win  -> 0.
    // An r-gate driving 0 at pull strength should conflict   -> x.
    wire sn, srn;               // nmos vs rnmos
    pullup (sn);
    pullup (srn);
    nmos  gs_n  (sn,  1'b0, c);
    rnmos gs_rn (srn, 1'b0, c);

    wire sp, srp;               // pmos vs rpmos
    pulldown (sp);
    pulldown (srp);
    pmos  gs_p  (sp,  1'b1, c);
    rpmos gs_rp (srp, 1'b1, c);

    wire sc, src;               // cmos vs rcmos
    pullup (sc);
    pullup (src);
    cmos  gs_c  (sc,  1'b0, n, p);
    rcmos gs_rc (src, 1'b0, n, p);

    initial begin
        // -- nmos: passes when control=1, blocks (Z) when control=0 --
        a = 1; c = 1;
        #10;
        if (y1 !== 1'b1) begin
            $display("FAILED nmos on: y1=%b expected 1", y1);
            $finish;
        end

        c = 0;
        #10;
        if (y1 !== 1'bz) begin
            $display("FAILED nmos off: y1=%b expected z", y1);
            $finish;
        end

        // -- pmos: passes when control=0, blocks (Z) when control=1 --
        a = 1; c = 0;
        #10;
        if (y2 !== 1'b1) begin
            $display("FAILED pmos on: y2=%b expected 1", y2);
            $finish;
        end

        c = 1;
        #10;
        if (y2 !== 1'bz) begin
            $display("FAILED pmos off: y2=%b expected z", y2);
            $finish;
        end

        // -- cmos: passes when ncontrol=1 and pcontrol=0 --
        a = 1; n = 1; p = 0;
        #10;
        if (y3 !== 1'b1) begin
            $display("FAILED cmos on: y3=%b expected 1", y3);
            $finish;
        end

        n = 0; p = 1;
        #10;
        if (y3 !== 1'bz) begin
            $display("FAILED cmos off: y3=%b expected z", y3);
            $finish;
        end

        // -- rnmos: same gating as nmos --
        a = 1; c = 1;
        #10;
        if (y4 !== 1'b1) begin
            $display("FAILED rnmos on: y4=%b expected 1", y4);
            $finish;
        end

        c = 0;
        #10;
        if (y4 !== 1'bz) begin
            $display("FAILED rnmos off: y4=%b expected z", y4);
            $finish;
        end

        // -- rpmos: same gating as pmos --
        a = 1; c = 0;
        #10;
        if (y5 !== 1'b1) begin
            $display("FAILED rpmos on: y5=%b expected 1", y5);
            $finish;
        end

        c = 1;
        #10;
        if (y5 !== 1'bz) begin
            $display("FAILED rpmos off: y5=%b expected z", y5);
            $finish;
        end

        // -- rcmos: same gating as cmos --
        a = 1; n = 1; p = 0;
        #10;
        if (y6 !== 1'b1) begin
            $display("FAILED rcmos on: y6=%b expected 1", y6);
            $finish;
        end

        n = 0; p = 1;
        #10;
        if (y6 !== 1'bz) begin
            $display("FAILED rcmos off: y6=%b expected z", y6);
            $finish;
        end

        // -- tran: bidirectional pass-through --
        drv = 1;
        #10;
        if (b1 !== 1'b1) begin
            $display("FAILED tran: b1=%b expected 1", b1);
            $finish;
        end

        // -- tranif1: conducts when ctrl=1 --
        drv = 1; tctrl = 1;
        #10;
        if (te1 !== 1'b1) begin
            $display("FAILED tranif1 on: te1=%b expected 1", te1);
            $finish;
        end

        tctrl = 0;
        #10;
        if (te1 !== 1'bz) begin
            $display("FAILED tranif1 off: te1=%b expected z", te1);
            $finish;
        end

        // -- tranif0: conducts when ctrl=0 --
        drv = 1; tctrl = 0;
        #10;
        if (te2 !== 1'b1) begin
            $display("FAILED tranif0 on: te2=%b expected 1", te2);
            $finish;
        end

        tctrl = 1;
        #10;
        if (te2 !== 1'bz) begin
            $display("FAILED tranif0 off: te2=%b expected z", te2);
            $finish;
        end

        // -- rtranif1: same gating as tranif1 --
        drv = 1; tctrl = 1;
        #10;
        if (rte1 !== 1'b1) begin
            $display("FAILED rtranif1 on: rte1=%b expected 1", rte1);
            $finish;
        end

        tctrl = 0;
        #10;
        if (rte1 !== 1'bz) begin
            $display("FAILED rtranif1 off: rte1=%b expected z", rte1);
            $finish;
        end

        // -- rtranif0: same gating as tranif0 --
        drv = 1; tctrl = 0;
        #10;
        if (rte2 !== 1'b1) begin
            $display("FAILED rtranif0 on: rte2=%b expected 1", rte2);
            $finish;
        end

        tctrl = 1;
        #10;
        if (rte2 !== 1'bz) begin
            $display("FAILED rtranif0 off: rte2=%b expected z", rte2);
            $finish;
        end

        // -- Drive strength: nmos (strong) vs rnmos (pull) against pullup --
        // pullup drives 1 at pull strength; gate drives 0.
        // nmos at strong beats pull -> sn=0; rnmos at pull conflicts -> srn=x
        a = 0; c = 1;
        #10;
        if (sn !== 1'b0) begin
            $display("FAILED nmos strength: sn=%b expected 0", sn);
            $finish;
        end
        if (srn !== 1'bx) begin
            $display("FAILED rnmos strength: srn=%b expected x", srn);
            $finish;
        end

        // -- Drive strength: pmos (strong) vs rpmos (pull) against pulldown --
        // pulldown drives 0 at pull strength; gate drives 1.
        // pmos at strong beats pull -> sp=1; rpmos at pull conflicts -> srp=x
        c = 0;
        #10;
        if (sp !== 1'b1) begin
            $display("FAILED pmos strength: sp=%b expected 1", sp);
            $finish;
        end
        if (srp !== 1'bx) begin
            $display("FAILED rpmos strength: srp=%b expected x", srp);
            $finish;
        end

        // -- Drive strength: cmos (strong) vs rcmos (pull) against pullup --
        n = 1; p = 0;
        #10;
        if (sc !== 1'b0) begin
            $display("FAILED cmos strength: sc=%b expected 0", sc);
            $finish;
        end
        if (src !== 1'bx) begin
            $display("FAILED rcmos strength: src=%b expected x", src);
            $finish;
        end

        $display("PASSED");
        $finish;
    end
endmodule
