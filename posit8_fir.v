`timescale 1ns/1ps

// ============================================================
// POSIT<8,0> FOUR-TAP FIR FILTER
// ============================================================
// Posit encodings:
//   8'h00 = Zero
//   8'h80 = NaR
//   8'h40 = +1
//   8'h60 = +2
//   8'h70 = +4
//   8'hC0 = -1
//   8'hA0 = -2
//
// Internal representation: signed Q16
// Multiplication result: Q32
// Rounding: nearest Posit, ties to even
// ============================================================


// ============================================================
// POSIT DECODER
// ============================================================

module posit8_decode_q16(
    input wire [7:0] p,
    output reg signed [63:0] q16
);

    reg [7:0] mag;

    always @(*) begin
        q16 = 64'sd0;
        mag = 8'h00;

        if (p[7])
            mag = (~p) + 8'd1;
        else
            mag = p;

        case (mag)
            8'h01: q16 = 64'sd1024;
            8'h02: q16 = 64'sd2048;
            8'h03: q16 = 64'sd3072;
            8'h04: q16 = 64'sd4096;
            8'h05: q16 = 64'sd5120;
            8'h06: q16 = 64'sd6144;
            8'h07: q16 = 64'sd7168;
            8'h08: q16 = 64'sd8192;
            8'h09: q16 = 64'sd9216;
            8'h0A: q16 = 64'sd10240;
            8'h0B: q16 = 64'sd11264;
            8'h0C: q16 = 64'sd12288;
            8'h0D: q16 = 64'sd13312;
            8'h0E: q16 = 64'sd14336;
            8'h0F: q16 = 64'sd15360;

            8'h10: q16 = 64'sd16384;
            8'h11: q16 = 64'sd17408;
            8'h12: q16 = 64'sd18432;
            8'h13: q16 = 64'sd19456;
            8'h14: q16 = 64'sd20480;
            8'h15: q16 = 64'sd21504;
            8'h16: q16 = 64'sd22528;
            8'h17: q16 = 64'sd23552;
            8'h18: q16 = 64'sd24576;
            8'h19: q16 = 64'sd25600;
            8'h1A: q16 = 64'sd26624;
            8'h1B: q16 = 64'sd27648;
            8'h1C: q16 = 64'sd28672;
            8'h1D: q16 = 64'sd29696;
            8'h1E: q16 = 64'sd30720;
            8'h1F: q16 = 64'sd31744;

            8'h20: q16 = 64'sd32768;
            8'h21: q16 = 64'sd33792;
            8'h22: q16 = 64'sd34816;
            8'h23: q16 = 64'sd35840;
            8'h24: q16 = 64'sd36864;
            8'h25: q16 = 64'sd37888;
            8'h26: q16 = 64'sd38912;
            8'h27: q16 = 64'sd39936;
            8'h28: q16 = 64'sd40960;
            8'h29: q16 = 64'sd41984;
            8'h2A: q16 = 64'sd43008;
            8'h2B: q16 = 64'sd44032;
            8'h2C: q16 = 64'sd45056;
            8'h2D: q16 = 64'sd46080;
            8'h2E: q16 = 64'sd47104;
            8'h2F: q16 = 64'sd48128;

            8'h30: q16 = 64'sd49152;
            8'h31: q16 = 64'sd50176;
            8'h32: q16 = 64'sd51200;
            8'h33: q16 = 64'sd52224;
            8'h34: q16 = 64'sd53248;
            8'h35: q16 = 64'sd54272;
            8'h36: q16 = 64'sd55296;
            8'h37: q16 = 64'sd56320;
            8'h38: q16 = 64'sd57344;
            8'h39: q16 = 64'sd58368;
            8'h3A: q16 = 64'sd59392;
            8'h3B: q16 = 64'sd60416;
            8'h3C: q16 = 64'sd61440;
            8'h3D: q16 = 64'sd62464;
            8'h3E: q16 = 64'sd63488;
            8'h3F: q16 = 64'sd64512;

            8'h40: q16 = 64'sd65536;
            8'h41: q16 = 64'sd67584;
            8'h42: q16 = 64'sd69632;
            8'h43: q16 = 64'sd71680;
            8'h44: q16 = 64'sd73728;
            8'h45: q16 = 64'sd75776;
            8'h46: q16 = 64'sd77824;
            8'h47: q16 = 64'sd79872;
            8'h48: q16 = 64'sd81920;
            8'h49: q16 = 64'sd83968;
            8'h4A: q16 = 64'sd86016;
            8'h4B: q16 = 64'sd88064;
            8'h4C: q16 = 64'sd90112;
            8'h4D: q16 = 64'sd92160;
            8'h4E: q16 = 64'sd94208;
            8'h4F: q16 = 64'sd96256;

            8'h50: q16 = 64'sd98304;
            8'h51: q16 = 64'sd100352;
            8'h52: q16 = 64'sd102400;
            8'h53: q16 = 64'sd104448;
            8'h54: q16 = 64'sd106496;
            8'h55: q16 = 64'sd108544;
            8'h56: q16 = 64'sd110592;
            8'h57: q16 = 64'sd112640;
            8'h58: q16 = 64'sd114688;
            8'h59: q16 = 64'sd116736;
            8'h5A: q16 = 64'sd118784;
            8'h5B: q16 = 64'sd120832;
            8'h5C: q16 = 64'sd122880;
            8'h5D: q16 = 64'sd124928;
            8'h5E: q16 = 64'sd126976;
            8'h5F: q16 = 64'sd129024;

            8'h60: q16 = 64'sd131072;
            8'h61: q16 = 64'sd139264;
            8'h62: q16 = 64'sd147456;
            8'h63: q16 = 64'sd155648;
            8'h64: q16 = 64'sd163840;
            8'h65: q16 = 64'sd172032;
            8'h66: q16 = 64'sd180224;
            8'h67: q16 = 64'sd188416;
            8'h68: q16 = 64'sd196608;
            8'h69: q16 = 64'sd204800;
            8'h6A: q16 = 64'sd212992;
            8'h6B: q16 = 64'sd221184;
            8'h6C: q16 = 64'sd229376;
            8'h6D: q16 = 64'sd237568;
            8'h6E: q16 = 64'sd245760;
            8'h6F: q16 = 64'sd253952;

            8'h70: q16 = 64'sd262144;
            8'h71: q16 = 64'sd294912;
            8'h72: q16 = 64'sd327680;
            8'h73: q16 = 64'sd360448;
            8'h74: q16 = 64'sd393216;
            8'h75: q16 = 64'sd425984;
            8'h76: q16 = 64'sd458752;
            8'h77: q16 = 64'sd491520;
            8'h78: q16 = 64'sd524288;
            8'h79: q16 = 64'sd655360;
            8'h7A: q16 = 64'sd786432;
            8'h7B: q16 = 64'sd917504;
            8'h7C: q16 = 64'sd1048576;
            8'h7D: q16 = 64'sd1572864;
            8'h7E: q16 = 64'sd2097152;
            8'h7F: q16 = 64'sd4194304;

            default: q16 = 64'sd0;
        endcase

        if (p[7] && (p != 8'h80))
            q16 = -q16;

        if (p == 8'h80)
            q16 = 64'sd0;
    end
endmodule


// ============================================================
// POSIT ENCODER
// ============================================================

module posit8_encode_q32(
    input wire signed [63:0] value,
    output reg [7:0] code
);

    reg signed [63:0] magnitude_value;
    reg signed [63:0] candidate_value;

    reg [63:0] distance;
    reg [63:0] best_distance;

    reg [7:0] best_code;
    reg negative;

    integer i;

    always @(*) begin

        i = 0;
        code = 8'h00;

        magnitude_value = 64'sd0;
        candidate_value = 64'sd0;

        distance = 64'd0;
        best_distance = 64'hFFFFFFFFFFFFFFFF;

        best_code = 8'h01;
        negative = value[63];

        if (value != 64'sd0) begin

            if (negative)
                magnitude_value = -value;
            else
                magnitude_value = value;

            // CORRECTION: Include zero as a rounding candidate.
            best_code = 8'h00;
            best_distance = magnitude_value;

            for (i = 1; i <= 127; i = i + 1) begin

                candidate_value = 64'sd0;

                case (i)

                    1: candidate_value = 64'sd1024 <<< 16;
                    2: candidate_value = 64'sd2048 <<< 16;
                    3: candidate_value = 64'sd3072 <<< 16;
                    4: candidate_value = 64'sd4096 <<< 16;
                    5: candidate_value = 64'sd5120 <<< 16;
                    6: candidate_value = 64'sd6144 <<< 16;
                    7: candidate_value = 64'sd7168 <<< 16;
                    8: candidate_value = 64'sd8192 <<< 16;
                    9: candidate_value = 64'sd9216 <<< 16;
                    10: candidate_value = 64'sd10240 <<< 16;
                    11: candidate_value = 64'sd11264 <<< 16;
                    12: candidate_value = 64'sd12288 <<< 16;
                    13: candidate_value = 64'sd13312 <<< 16;
                    14: candidate_value = 64'sd14336 <<< 16;
                    15: candidate_value = 64'sd15360 <<< 16;

                    16: candidate_value = 64'sd16384 <<< 16;
                    17: candidate_value = 64'sd17408 <<< 16;
                    18: candidate_value = 64'sd18432 <<< 16;
                    19: candidate_value = 64'sd19456 <<< 16;
                    20: candidate_value = 64'sd20480 <<< 16;
                    21: candidate_value = 64'sd21504 <<< 16;
                    22: candidate_value = 64'sd22528 <<< 16;
                    23: candidate_value = 64'sd23552 <<< 16;
                    24: candidate_value = 64'sd24576 <<< 16;
                    25: candidate_value = 64'sd25600 <<< 16;
                    26: candidate_value = 64'sd26624 <<< 16;
                    27: candidate_value = 64'sd27648 <<< 16;
                    28: candidate_value = 64'sd28672 <<< 16;
                    29: candidate_value = 64'sd29696 <<< 16;
                    30: candidate_value = 64'sd30720 <<< 16;
                    31: candidate_value = 64'sd31744 <<< 16;

                    32: candidate_value = 64'sd32768 <<< 16;
                    33: candidate_value = 64'sd33792 <<< 16;
                    34: candidate_value = 64'sd34816 <<< 16;
                    35: candidate_value = 64'sd35840 <<< 16;
                    36: candidate_value = 64'sd36864 <<< 16;
                    37: candidate_value = 64'sd37888 <<< 16;
                    38: candidate_value = 64'sd38912 <<< 16;
                    39: candidate_value = 64'sd39936 <<< 16;
                    40: candidate_value = 64'sd40960 <<< 16;
                    41: candidate_value = 64'sd41984 <<< 16;
                    42: candidate_value = 64'sd43008 <<< 16;
                    43: candidate_value = 64'sd44032 <<< 16;
                    44: candidate_value = 64'sd45056 <<< 16;
                    45: candidate_value = 64'sd46080 <<< 16;
                    46: candidate_value = 64'sd47104 <<< 16;
                    47: candidate_value = 64'sd48128 <<< 16;

                    48: candidate_value = 64'sd49152 <<< 16;
                    49: candidate_value = 64'sd50176 <<< 16;
                    50: candidate_value = 64'sd51200 <<< 16;
                    51: candidate_value = 64'sd52224 <<< 16;
                    52: candidate_value = 64'sd53248 <<< 16;
                    53: candidate_value = 64'sd54272 <<< 16;
                    54: candidate_value = 64'sd55296 <<< 16;
                    55: candidate_value = 64'sd56320 <<< 16;
                    56: candidate_value = 64'sd57344 <<< 16;
                    57: candidate_value = 64'sd58368 <<< 16;
                    58: candidate_value = 64'sd59392 <<< 16;
                    59: candidate_value = 64'sd60416 <<< 16;
                    60: candidate_value = 64'sd61440 <<< 16;
                    61: candidate_value = 64'sd62464 <<< 16;
                    62: candidate_value = 64'sd63488 <<< 16;
                    63: candidate_value = 64'sd64512 <<< 16;

                    64: candidate_value = 64'sd65536 <<< 16;
                    65: candidate_value = 64'sd67584 <<< 16;
                    66: candidate_value = 64'sd69632 <<< 16;
                    67: candidate_value = 64'sd71680 <<< 16;
                    68: candidate_value = 64'sd73728 <<< 16;
                    69: candidate_value = 64'sd75776 <<< 16;
                    70: candidate_value = 64'sd77824 <<< 16;
                    71: candidate_value = 64'sd79872 <<< 16;
                    72: candidate_value = 64'sd81920 <<< 16;
                    73: candidate_value = 64'sd83968 <<< 16;
                    74: candidate_value = 64'sd86016 <<< 16;
                    75: candidate_value = 64'sd88064 <<< 16;
                    76: candidate_value = 64'sd90112 <<< 16;
                    77: candidate_value = 64'sd92160 <<< 16;
                    78: candidate_value = 64'sd94208 <<< 16;
                    79: candidate_value = 64'sd96256 <<< 16;

                    80: candidate_value = 64'sd98304 <<< 16;
                    81: candidate_value = 64'sd100352 <<< 16;
                    82: candidate_value = 64'sd102400 <<< 16;
                    83: candidate_value = 64'sd104448 <<< 16;
                    84: candidate_value = 64'sd106496 <<< 16;
                    85: candidate_value = 64'sd108544 <<< 16;
                    86: candidate_value = 64'sd110592 <<< 16;
                    87: candidate_value = 64'sd112640 <<< 16;
                    88: candidate_value = 64'sd114688 <<< 16;
                    89: candidate_value = 64'sd116736 <<< 16;
                    90: candidate_value = 64'sd118784 <<< 16;
                    91: candidate_value = 64'sd120832 <<< 16;
                    92: candidate_value = 64'sd122880 <<< 16;
                    93: candidate_value = 64'sd124928 <<< 16;
                    94: candidate_value = 64'sd126976 <<< 16;
                    95: candidate_value = 64'sd129024 <<< 16;

                    96: candidate_value = 64'sd131072 <<< 16;
                    97: candidate_value = 64'sd139264 <<< 16;
                    98: candidate_value = 64'sd147456 <<< 16;
                    99: candidate_value = 64'sd155648 <<< 16;
                    100: candidate_value = 64'sd163840 <<< 16;
                    101: candidate_value = 64'sd172032 <<< 16;
                    102: candidate_value = 64'sd180224 <<< 16;
                    103: candidate_value = 64'sd188416 <<< 16;
                    104: candidate_value = 64'sd196608 <<< 16;
                    105: candidate_value = 64'sd204800 <<< 16;
                    106: candidate_value = 64'sd212992 <<< 16;
                    107: candidate_value = 64'sd221184 <<< 16;
                    108: candidate_value = 64'sd229376 <<< 16;
                    109: candidate_value = 64'sd237568 <<< 16;
                    110: candidate_value = 64'sd245760 <<< 16;
                    111: candidate_value = 64'sd253952 <<< 16;

                    112: candidate_value = 64'sd262144 <<< 16;
                    113: candidate_value = 64'sd294912 <<< 16;
                    114: candidate_value = 64'sd327680 <<< 16;
                    115: candidate_value = 64'sd360448 <<< 16;
                    116: candidate_value = 64'sd393216 <<< 16;
                    117: candidate_value = 64'sd425984 <<< 16;
                    118: candidate_value = 64'sd458752 <<< 16;
                    119: candidate_value = 64'sd491520 <<< 16;
                    120: candidate_value = 64'sd524288 <<< 16;
                    121: candidate_value = 64'sd655360 <<< 16;
                    122: candidate_value = 64'sd786432 <<< 16;
                    123: candidate_value = 64'sd917504 <<< 16;
                    124: candidate_value = 64'sd1048576 <<< 16;
                    125: candidate_value = 64'sd1572864 <<< 16;
                    126: candidate_value = 64'sd2097152 <<< 16;
                    127: candidate_value = 64'sd4194304 <<< 16;

                    default:
                        candidate_value = 64'sd4194304 <<< 16;

                endcase

                if (candidate_value >= magnitude_value)
                    distance = candidate_value - magnitude_value;
                else
                    distance = magnitude_value - candidate_value;

                if ((distance < best_distance) ||
                    ((distance == best_distance) &&
                     ((i % 2) == 0) && best_code[0])) begin

                    best_distance = distance;
                    best_code = i[7:0];

                end

            end

            if (negative)
                code = (~best_code) + 8'd1;
            else
                code = best_code;

        end

    end

endmodule


// ============================================================
// POSIT ADDER
// ============================================================

module posit8_add(
    input wire [7:0] a,
    input wire [7:0] b,
    output wire [7:0] y
);

    wire signed [63:0] a_q16;
    wire signed [63:0] b_q16;
    wire signed [63:0] sum_q32;

    wire [7:0] encoded_sum;

    posit8_decode_q16 DA(.p(a), .q16(a_q16));
    posit8_decode_q16 DB(.p(b), .q16(b_q16));

    assign sum_q32 = (a_q16 + b_q16) <<< 16;

    posit8_encode_q32 E(
        .value(sum_q32),
        .code(encoded_sum)
    );

    assign y = ((a == 8'h80) || (b == 8'h80))
             ? 8'h80 : encoded_sum;

endmodule


// ============================================================
// POSIT MULTIPLIER
// ============================================================

module posit8_mul(
    input wire [7:0] a,
    input wire [7:0] b,
    output wire [7:0] y
);

    wire signed [63:0] a_q16;
    wire signed [63:0] b_q16;
    wire signed [63:0] product_q32;

    wire [7:0] encoded_product;

    posit8_decode_q16 DA(.p(a), .q16(a_q16));
    posit8_decode_q16 DB(.p(b), .q16(b_q16));

    assign product_q32 = a_q16 * b_q16;

    posit8_encode_q32 E(
        .value(product_q32),
        .code(encoded_product)
    );

    assign y = ((a == 8'h80) || (b == 8'h80))
             ? 8'h80 : encoded_product;

endmodule


// ============================================================
// POSIT ARITHMETIC CORE
// ============================================================

module posit8_arith_core(
    input wire [7:0] a,
    input wire [7:0] b,
    output wire [7:0] add_y,
    output wire [7:0] mul_y
);

    posit8_add ADDER(
        .a(a),
        .b(b),
        .y(add_y)
    );

    posit8_mul MULTIPLIER(
        .a(a),
        .b(b),
        .y(mul_y)
    );

endmodule


// ============================================================
// FOUR-TAP POSIT FIR FILTER
// Coefficients: [1, 2, 2, 1]
// ============================================================

module fir_filter_posit #(
    parameter [7:0] B0 = 8'h40,
    parameter [7:0] B1 = 8'h60,
    parameter [7:0] B2 = 8'h60,
    parameter [7:0] B3 = 8'h40
)(
    input wire clk,
    input wire rst,
    input wire [7:0] x_in,
    output reg [7:0] y_out
);

    reg [7:0] x1;
    reg [7:0] x2;
    reg [7:0] x3;

    wire [7:0] p0;
    wire [7:0] p1;
    wire [7:0] p2;
    wire [7:0] p3;

    wire [7:0] s0;
    wire [7:0] s1;
    wire [7:0] s2;

    // Multiplication stages

    posit8_mul M0(
        .a(x_in),
        .b(B0),
        .y(p0)
    );

    posit8_mul M1(
        .a(x1),
        .b(B1),
        .y(p1)
    );

    posit8_mul M2(
        .a(x2),
        .b(B2),
        .y(p2)
    );

    posit8_mul M3(
        .a(x3),
        .b(B3),
        .y(p3)
    );

    // Addition stages

    posit8_add A0(
        .a(p0),
        .b(p1),
        .y(s0)
    );

    posit8_add A1(
        .a(s0),
        .b(p2),
        .y(s1)
    );

    posit8_add A2(
        .a(s1),
        .b(p3),
        .y(s2)
    );

    // Sequential delay registers and output

    always @(posedge clk or posedge rst) begin

        if (rst) begin

            x1 <= 8'h00;
            x2 <= 8'h00;
            x3 <= 8'h00;

            y_out <= 8'h00;

        end else begin

            x3 <= x2;
            x2 <= x1;
            x1 <= x_in;

            y_out <= s2;

        end

    end

endmodule