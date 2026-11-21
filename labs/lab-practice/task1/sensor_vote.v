// Part A: write module sensor_vote here.
module sensor_vote(input a,b,c,
output m,f);

//implementation of three and gates and or gate using gate level modelling.
wire v,w,x,y,z;

and (v,a,b);
and (w,b,c);
and (x,a,c);

or (m,v,w,x);

//implementation of two xor gates and xor gates using gate level modelling

xor (y,a,b);
xor (z,b,c);

or (f,y,z);

endmodule