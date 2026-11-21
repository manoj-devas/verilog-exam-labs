// Part A: write module parking_lot here.
module parking_lot(input clk, rst_n, [5:0]sens, 
output [2:0]count, open_in, [1:0]light, fault);


//Intermediate wires
wire car_in, car_out;
wire f_in,f_out;

//entry gate sensor_vote
sensor_vote U1 ( .a(sens[0]), .b(sens[1]), .c(sens[2]),.m(car_in), .f(f_in));

//exit fate sensor_vote

sensor_vote U2 (.a(sens[3]), .b(sens[4]), .c(sens[5]), .m(car_out), .f(f_out))

//combine f_in and _f_out

or (fault, f_in, f_out);

//occupancy controller

occupancy_ctrl U3 (.clk(clk), .rst_n(rst_n),.car_in(car_in), .fault(fault), .car_out(car_out), .count(count), .open_in(open_in), .light(light));

endmodule


