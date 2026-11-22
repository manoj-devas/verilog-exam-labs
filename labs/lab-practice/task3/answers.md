## Bug 1
time_ns: 85ns
instance: U1
signal: sum
value: 9 (expected 25)
corrected_line: reg [4:0] sum;

## Bug 2
time_ns: 121 ns
instance: U2
signal: q
value: 10 (expected 0)
corrected_line: always @(posedge clk or negedge rst_n)