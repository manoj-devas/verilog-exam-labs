// Part A: write module parking_lot here.
module parking_lot(input clk, rst_n, [5:0]sens, 
output fault, [2:0] count, open_in, [1:0] light );

//Intermediate wires 
wire car_in, car_out;

wire f_in,f_out;

sensor_vote U1 (.a(sens[0]), .b(sens[1]), .c(sens[2]), .f(f_in), .m(car_in));

sensor_vote U2 (.a(sens[3]), .b(sens[4]), .c(sens[5]), .f(f_out), .m(car_out));

or (fault, f_in, f_out);

occupancy_ctrl U3 (.clk(clk), .rst_n(rst_n),.car_in(car_in), .fault(fault), .car_out(car_out), .count(count), .open_in(open_in), .light(light));

endmodule

