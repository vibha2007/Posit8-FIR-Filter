
`timescale 1ns/1ps

module posit8_fir_random_tb;

    reg clk;
    reg rst;
    reg [7:0] x_in;

    wire [7:0] y_out;

    reg [7:0] h1, h2, h3;
    reg [7:0] expected;

    reg [7:0] p0, p1, p2, p3;
    reg [7:0] s01, s23;

    integer i;
    integer errors;

   fir_filter_posit DUT (
        .clk(clk),
        .rst(rst),
        .x_in(x_in),
        .y_out(y_out)
    );

    // Clock
    initial clk = 0;
    always #5 clk = ~clk;

    // ------------------------------------------------
    // Independent Posit reference functions
    // ------------------------------------------------

    function real power_of_two;
        input integer exponent;
        integer n;
        real result;
        begin
            result = 1.0;
            if (exponent >= 0) begin
                for (n = 0; n < exponent; n = n + 1)
                    result = result * 2.0;
            end
            else begin
                for (n = 0; n < -exponent; n = n + 1)
                    result = result / 2.0;
            end
            power_of_two = result;
        end
    endfunction

    function real ref_decode;
        input [7:0] p;

        reg [7:0] mag;
        reg regime_bit;
        integer idx, run_length, k, j;
        real fraction, weight, result;

        begin
            ref_decode = 0.0;

            if ((p == 8'h00) || (p == 8'h80)) begin
                ref_decode = 0.0;
            end
            else begin
                if (p[7])
                    mag = (~p) + 8'd1;
                else
                    mag = p;

                regime_bit = mag[6];
                idx = 6;
                run_length = 0;

                while ((idx >= 0) &&
                       (mag[idx] == regime_bit)) begin
                    run_length = run_length + 1;
                    idx = idx - 1;
                end

                if (idx >= 0)
                    idx = idx - 1;

                if (regime_bit)
                    k = run_length - 1;
                else
                    k = -run_length;

                fraction = 0.0;
                weight = 0.5;

                for (j = idx; j >= 0; j = j - 1) begin
                    if (mag[j])
                        fraction = fraction + weight;
                    weight = weight / 2.0;
                end

                result = power_of_two(k) * (1.0 + fraction);

                if (p[7])
                    result = -result;

                ref_decode = result;
            end
        end
    endfunction

    function [7:0] ref_encode;
        input real input_value;

        integer code, best_code;
        real magnitude, candidate;
        real distance, best_distance;
        reg negative;

        begin
            ref_encode = 8'h00;

            if (input_value == 0.0) begin
                ref_encode = 8'h00;
            end
            else begin
                negative = (input_value < 0.0);

                if (negative)
                    magnitude = -input_value;
                else
                    magnitude = input_value;

                best_code = 1;
                best_distance = 1.0e30;

                for (code = 1; code <= 127; code = code + 1) begin
                    candidate = ref_decode(code);

                    if (candidate >= magnitude)
                        distance = candidate - magnitude;
                    else
                        distance = magnitude - candidate;

                    if ((distance < best_distance) ||
                        ((distance == best_distance) &&
                         ((code % 2) == 0) &&
                         ((best_code % 2) != 0))) begin
                        best_distance = distance;
                        best_code = code;
                    end
                end

                if (negative)
                    ref_encode = (~best_code) + 8'd1;
                else
                    ref_encode = best_code;
            end
        end
    endfunction

    function [7:0] ref_add;
        input [7:0] a, b;
        real result;
        begin
            if ((a == 8'h80) || (b == 8'h80))
                ref_add = 8'h80;
            else begin
                result = ref_decode(a) + ref_decode(b);
                ref_add = ref_encode(result);
            end
        end
    endfunction

    function [7:0] ref_mul;
        input [7:0] a, b;
        real result;
        begin
            if ((a == 8'h80) || (b == 8'h80))
                ref_mul = 8'h80;
            else begin
                result = ref_decode(a) * ref_decode(b);
                ref_mul = ref_encode(result);
            end
        end
    endfunction

    // ------------------------------------------------
    // Random FIR test
    // ------------------------------------------------

    initial begin

        rst = 1;
        x_in = 8'h00;

        h1 = 8'h00;
        h2 = 8'h00;
        h3 = 8'h00;

        errors = 0;

        repeat (2) @(negedge clk);
        rst = 0;

        $display("--------------------------------");
        $display("RANDOM FIR TEST STARTED");
        $display("--------------------------------");

        for (i = 0; i < 100; i = i + 1) begin

            @(negedge clk);

            // Generate random Posit input.
            x_in = $random;

            // 8'h80 is NaR; avoid it in this test.
            if (x_in == 8'h80)
                x_in = 8'h81;

            // Reference FIR calculations.
            p0 = ref_mul(8'h40, x_in);
            p1 = ref_mul(8'h60, h1);
            p2 = ref_mul(8'h60, h2);
            p3 = ref_mul(8'h40, h3);

            s01 = ref_add(p0, p1);
            s23 = ref_add(p2, p3);

            expected = ref_add(s01, s23);

            @(posedge clk);
            #1;

            if (y_out !== expected) begin
                errors = errors + 1;

                $display(
                    "FAIL: Sample=%0d Input=%h Expected=%h Actual=%h",
                    i, x_in, expected, y_out
                );
            end
            else begin
                if ((i % 10) == 0)
                    $display(
                        "PASS: Sample=%0d Input=%h Output=%h",
                        i, x_in, y_out
                    );
            end

            // Update reference delay registers.
            h3 = h2;
            h2 = h1;
            h1 = x_in;

        end

        $display("--------------------------------");
        $display("RANDOM FIR TEST RESULTS");
        $display("Samples tested = 100");
        $display("Errors         = %0d", errors);

        if (errors == 0)
            $display("ALL RANDOM FIR TESTS PASSED");
        else
            $display("RANDOM FIR TEST FAILED");

        $display("--------------------------------");

        $finish;
    end

endmodule
