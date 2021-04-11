`include "vunit_defines.svh"

`define CUT CUT

module counter%WIDTH%_tb;
    timeunit 1ns;
    timeprecision 1ps;

    parameter WIDTH = %WIDTH%;

    logic clk;
    logic n_rst;
    logic n_en;
    logic [WIDTH-1:0] count;
    logic [WIDTH-1:0] prev_count;
    logic [WIDTH-1:0] trig_out;

    default clocking cb @(posedge clk);
    endclocking

    `TEST_SUITE begin

        `TEST_SUITE_SETUP begin
        end

        `TEST_CASE_SETUP begin
            clk = 1'b1;
            n_rst = 1'b0;
            n_en = 1'b0;
            ##5 n_rst <= ~n_rst;
        end

        `TEST_CASE("normal_operation_test") begin
            int i;

            for(i=0; i<2**WIDTH; i++) begin
                `CHECK_EQUAL(count, i);
                ##1;
                `CHECK_EQUAL(trig_out, i & (~count))
            end
            `CHECK_EQUAL(trig_out, '1);
            n_en <= ~n_en;
            ##1;
            `CHECK_EQUAL(count, 0);
            `CHECK_EQUAL(trig_out, 0);
            ##1;
            `CHECK_EQUAL(count, 0);
            `CHECK_EQUAL(trig_out, 0);
            n_en <= ~n_en;
            ##1;
            `CHECK_EQUAL(count, 1);
            ##1;
            `CHECK_EQUAL(count, 2);
            `CHECK_EQUAL(trig_out, 1);
            ##1;
        end

        `TEST_CASE_CLEANUP begin
        end

        `TEST_SUITE_CLEANUP begin
        end
    end;

    `WATCHDOG(1ms);

    counter #(
        .WIDTH(WIDTH)
    )
    `CUT (
        .clk(clk),
        .n_rst(n_rst),
        .n_en(n_en),
        .count(count),
        .trig_out(trig_out)
    );

    always #5 clk = ~clk;

    always_ff @(posedge clk) prev_count <= count;

endmodule
