module tb_and_gate;

logic a 
logic b
logic y

and_gate_utt(
    .a(a),
    .b(b),
    .y(y)
);

initial begin

    a=0; b=0; #10;
    a=0; b=1; #10;
    a=1; b=0; #10;
    a=1; b=1; #10;
end
endmodule
