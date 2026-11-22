`timescale 1ns/1ps

module tb;
    reg        clk    = 0;
    reg        rst_n  = 0;
    reg        c5     = 0;
    reg        c10    = 0;
    reg        cancel = 0;
    wire [4:0] credit;
    wire       vend;

    ticket_machine dut (
        .clk    (clk),
        .rst_n  (rst_n),
        .c5     (c5),
        .c10    (c10),
        .cancel (cancel),
        .credit (credit),
        .vend   (vend)
    );

    string vcd_file;
    initial begin
        if ($value$plusargs("vcd=%s", vcd_file)) begin
            $dumpfile(vcd_file);
            $dumpvars(0, tb);
        end
    end

    always #5 clk = ~clk;

    // Reference model from specification
    reg  [4:0] exp_credit;
    wire       exp_vend = (exp_credit >= 5'd15);
    reg        fail = 0;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            exp_credit <= 5'd0;
        else if (cancel)
            exp_credit <= 5'd0;
        else
            exp_credit <= exp_credit
                        + (c5  ? 5'd5  : 5'd0)
                        + (c10 ? 5'd10 : 5'd0)
                        - (exp_vend ? 5'd15 : 5'd0);
    end

    // Compare after every rising and falling clock edge
    always @(posedge clk) begin
        #1;
        if (credit !== exp_credit || vend !== exp_vend)
            fail = 1;
    end

    always @(negedge clk) begin
        #1;
        if (credit !== exp_credit || vend !== exp_vend)
            fail = 1;
    end

    initial begin
        // Check initial asynchronous reset before first clock edge
        #1;
        if (credit !== exp_credit || vend !== exp_vend)
            fail = 1;

        #11 rst_n = 1;

        // 1. Three 5-coins -> 15 -> vend -> 0
        @(negedge clk) c5 = 1;
        @(negedge clk);
        @(negedge clk);
        @(negedge clk) c5 = 0;

        // 2. 5 + 10 -> 15 -> vend -> 0
        @(negedge clk) c5 = 1;
        @(negedge clk) c5 = 0; c10 = 1;
        @(negedge clk) c10 = 0;

        // 3. Overpay (10 + 10 = 20 -> vend -> 5) and simultaneous vend + coin (sum >= 25)
        @(negedge clk) c10 = 1;
        @(negedge clk);
        @(negedge clk) c10 = 0;
        @(negedge clk) c10 = 1;
        @(negedge clk);
        @(negedge clk) c10 = 0; c5 = 1;
        @(negedge clk) c5 = 0; c10 = 1;
        @(negedge clk);
        @(negedge clk);
        @(negedge clk) c10 = 0; c5 = 1;
        @(negedge clk) c5 = 0;

        // 4. Cancel behavior (normal credit and when vend == 1 at credit == 20)
        @(negedge clk) cancel = 1;
        @(negedge clk) cancel = 0; c10 = 1;
        @(negedge clk);
        @(negedge clk) c10 = 0; cancel = 1;
        @(negedge clk) cancel = 0;

        // 5. Mid-cycle asynchronous reset while credit > 0
        @(negedge clk) c10 = 1;
        @(negedge clk) c10 = 0;
        #2 rst_n = 0;
        #1;
        if (credit !== exp_credit || vend !== exp_vend)
            fail = 1;
        c5 = 1;
        #12 rst_n = 1;
        @(negedge clk) c5 = 0;
        @(negedge clk);

        if (!fail)
            $display("RESULT: PASS");
        else
            $display("RESULT: FAIL");

        $finish;
    end

endmodule