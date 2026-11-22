// tb.v -- Part B1: write your self-checking testbench for ticket_machine here.
`timescale 1ns/1ps

module tb;

reg clk = 0;
reg rst_n = 0;
reg c5 = 0;
reg c10 = 0;
reg cancel = 0;

wire [4:0] credit;
wire vend;

reg [4:0] expected_credit = 0;
wire expected_vend;

integer errors = 0;


// Instantiate ticket_machine
ticket_machine dut(
    .clk(clk),
    .rst_n(rst_n),
    .c5(c5),
    .c10(c10),
    .cancel(cancel),
    .credit(credit),
    .vend(vend)
);


// Generating clock
always #5 clk = ~clk;


// Expected vend
assign expected_vend = (expected_credit >= 5'd15);


// Reference model
always @(posedge clk or negedge rst_n) begin

    if (!rst_n)
        expected_credit <= 5'd0;

    else if (cancel)
        expected_credit <= 5'd0;

    else
        expected_credit <= expected_credit
            + (c5 ? 5'd5 : 5'd0)
            + (c10 ? 5'd10 : 5'd0)
            - (expected_vend ? 5'd15 : 5'd0);

end


// Compare actual and expected outputs
always begin

    @(posedge clk or negedge rst_n);
    #1;

    if ((credit !== expected_credit) ||
        (vend !== expected_vend))
        errors = errors + 1;

end


// Input sequence
initial begin

    errors = 0;

    #12 rst_n = 1;

    // Insert 10-value coin
    @(negedge clk) c10 = 1;
    @(negedge clk) c10 = 0;

    // Insert 5-value coin
    @(negedge clk) c5 = 1;
    @(negedge clk) c5 = 0;

    // Insert 10-value coin when credit is 15
    @(negedge clk) c10 = 1;
    @(negedge clk) c10 = 0;

    // Test cancellation
    @(negedge clk) cancel = 1;
    @(negedge clk) cancel = 0;

    // Insert another coin
    @(negedge clk) c5 = 1;
    @(negedge clk) c5 = 0;

    // Test asynchronous reset
    #2 rst_n = 0;
    #2 rst_n = 1;

    // Test vending again
    @(negedge clk) c10 = 1;
    @(negedge clk) c10 = 0;

    @(negedge clk) c5 = 1;
    @(negedge clk) c5 = 0;

    @(posedge clk);
    #2;

    if (errors == 0)
        $display("RESULT: PASS");
    else
        $display("RESULT: FAIL");

    $finish;

end


// Waveform dump for the Run button
string vcd_file;

initial begin

    if ($value$plusargs("vcd=%s", vcd_file)) begin
        $dumpfile(vcd_file);
        $dumpvars(0, tb);
    end

end

endmodule