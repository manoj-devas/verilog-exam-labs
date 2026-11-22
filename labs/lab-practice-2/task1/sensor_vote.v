// Part A: write module sensor_vote here.
module sensor_vote(input a, b, c, 
output m,f);

wire ab,bc,ac;
wire x,y;

and (ab, a,b);
and (bc,b,c);
and (ac,a,c);

or (m,ab,bc,ac);

xor (x,a,b);
xor (y,b,c);

or(f,x,y);

endmodule