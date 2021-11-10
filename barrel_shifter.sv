// Barrel Shifter RTL Model
`include "mux_2x1_behavioral.sv"
module barrel_shifter (
  input logic select,  // select=0 shift operation, select=1 rotate operation
  input logic direction, // direction=0 right move, direction=1 left move
  input logic[1:0] shift_value, // number of bits to be shifted (0, 1, 2 or 3)
  input logic[3:0] din,
  output logic[3:0] dout
);

logic [3:0]Din,dout1,dout2;
inst_left M1(.shift_value(shift_value),.din(din),.dout(dout1));
inst_right M2(.shift_value(shift_value),.din(din),.dout(dout2));
always_comb begin
    if(select == 1'b1)begin//rotate
            if(direction == 1'b1)begin//left
                                    Din = din;
                                    dout = dout1;
                                end
            else begin//right
                   Din = din;
                   dout = dout2;
                end
        end
    else begin//shift
        if(direction == 1'b1)begin//left
            case(shift_value)
            2'b00:begin Din = din;
            dout = dout1;
            end
            2'b01:begin Din[2:0] = din[2:0];
                        Din[3] = 1'b0;
                        dout = dout1;
            end
            2'b10:begin Din[1:0] = din[1:0];
                        Din[3:2] = 2'b00;
                        dout = dout1;
            end
            2'b11:begin Din[0] = din[0];
                        Din[3:1] = 3'b000;
                        dout = dout1;
            end
            endcase
            end
            else begin
                case(shift_value)
            2'b00:begin Din = din;
                        dout = dout2;
            end
            2'b01:begin Din[3:1] = din[3:1];
                        Din[0] = din[3];
                        dout = dout2;
            end
            2'b10:begin Din[3:2] = din[3:2];
                        Din[1:0] = din[3];
                        dout = dout2;
            end
            2'b11:begin Din[3:0] = din[3];
                        dout = dout2;
            end
            endcase
            end
        end
end
endmodule: barrel_shifter
module inst_left(input logic[1:0] shift_value,
  input logic[3:0] din,
  output logic[3:0] dout);
logic mo1,mo2,mo3,mo4;
  mux_2x1 m0(.in0(din[3]),.in1(din[1]),.sel(shift_value[1]),.out(mo1));
  mux_2x1 m1(.in0(din[2]),.in1(din[0]),.sel(shift_value[1]),.out(mo2));
  mux_2x1 m2(.in0(din[1]),.in1(din[3]),.sel(shift_value[1]),.out(mo3));
  mux_2x1 m3(.in0(din[0]),.in1(din[2]),.sel(shift_value[1]),.out(mo4));
  mux_2x1 m4(.in0(mo1),.in1(mo2),.sel(shift_value[0]),.out(dout[0]));
  mux_2x1 m5(.in0(mo2),.in1(mo3),.sel(shift_value[0]),.out(dout[1]));
  mux_2x1 m6(.in0(mo3),.in1(mo4),.sel(shift_value[0]),.out(dout[2]));
  mux_2x1 m7(.in0(mo4),.in1(mo1),.sel(shift_value[0]),.out(dout[3]));
endmodule
module inst_right(input logic[1:0] shift_value,
  input logic[3:0] din,
  output logic[3:0] dout);
 logic mo1,mo2,mo3,mo4;
  mux_2x1 m0(.in0(din[0]),.in1(din[2]),.sel(shift_value[1]),.out(mo1));
  mux_2x1 m1(.in0(din[1]),.in1(din[3]),.sel(shift_value[1]),.out(mo2));
  mux_2x1 m2(.in0(din[2]),.in1(din[0]),.sel(shift_value[1]),.out(mo3));
  mux_2x1 m3(.in0(din[3]),.in1(din[1]),.sel(shift_value[1]),.out(mo4));
  mux_2x1 m4(.in0(mo1),.in1(mo2),.sel(shift_value[0]),.out(dout[0]));
  mux_2x1 m5(.in0(mo2),.in1(mo3),.sel(shift_value[0]),.out(dout[1]));
  mux_2x1 m6(.in0(mo3),.in1(mo4),.sel(shift_value[0]),.out(dout[2]));
  mux_2x1 m7(.in0(mo4),.in1(mo1),.sel(shift_value[0]),.out(dout[3]));
endmodule

