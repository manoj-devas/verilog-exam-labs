// Part A: write module occupancy_ctrl here.
module occupancy_ctrl(input clk, rst_n, car_in, fault,car_out,
output reg [2:0]count, reg [1:0]light, reg open_in]);


// occupancy counter
always @(posedge clk or negedge rst_n) begin 

if(!rst_n)
  count <= 3'd0;

else if ( car_in && !car_out ) begin
  
  if (count < 3'd5) 
     count <= count + 3"d1;


end 
else if ( !car_in && car_out) begin 
   if (count > 3'd0 )
     count <= count - 3'd1;
    end

end

// entry barrier and indicator light

always @(*) begin

 // Open entry only when a car is detected
 // and parking space is available
  open_in = car_in && (count < 3'd5);
  
  //Indicator light
  if(fault)
    light = 2'b11;

  else if (count == 3'd5)
    light = 2'b10;

  else 
      light = 2'b00;


end 

endmodule





endmodule