module counter #(
    parameter WIDTH = 8
) (
    input logic clk,
    input logic n_rst,
    input logic n_en,
    output logic [WIDTH-1:0] count,
    output logic [WIDTH-1:0] trig_out
);
    logic [WIDTH-1:0] reg_count = 0;
    logic [WIDTH-1:0] trig = 0;

    always_ff @(posedge clk) begin
        if(~n_rst) reg_count <= 0;
        else if(~n_en) reg_count <= reg_count + 1;
    end
    assign count = reg_count;

    generate
        genvar i;
        for(i=0; i<WIDTH; i++) begin: gen_trig
            always_ff @(posedge clk) begin
                if(~n_rst) trig[i] <= 1'b0;
                else trig[i] <= (~n_en) & (&reg_count[i:0]);
            end
        end
    endgenerate
    assign trig_out = trig;
endmodule