/*
Your use of Altera Corporation's design tools, logic functions 
and other software and tools, and its AMPP partner logic 
functions, and any output files from any of the foregoing 
(including device programming or simulation files), and any 
associated documentation or information are expressly subject 
to the terms and conditions of the Altera Program License 
Subscription Agreement, Altera MegaCore Function License 
Agreement, or other applicable license agreement, including, 
without limitation, that your use is for the sole purpose of 
programming logic devices manufactured by Altera and sold by 
Altera or its authorized distributors.  Please refer to the 
applicable agreement for further details.
*/

MODEL
MODEL_VERSION "1.0";
DESIGN "arriagx_memory_register";

INPUT data[143:0];
INPUT  clk, aclr, ena;
INPUT async;
OUTPUT dataout[143:0];

/* timing arcs */

/* feedthrough arc */
t_data_dataout: DELAY (NONINVERTING, BITWISE) data dataout COND
                (async == 1);

/* clock to out timing arc */
t_clk_dataout[0]: DELAY (POSEDGE) clk dataout[0] COND
               ( (async == 0) && (data[0] != 0) && (data[0] != 1) );
t_clk_dataout[1]: DELAY (POSEDGE) clk dataout[1] COND
               ( (async == 0) && (data[1] != 0) && (data[1] != 1) );
t_clk_dataout[2]: DELAY (POSEDGE) clk dataout[2] COND
               ( (async == 0) && (data[2] != 0) && (data[2] != 1) );
t_clk_dataout[3]: DELAY (POSEDGE) clk dataout[3] COND
               ( (async == 0) && (data[3] != 0) && (data[3] != 1) );
t_clk_dataout[4]: DELAY (POSEDGE) clk dataout[4] COND
               ( (async == 0) && (data[4] != 0) && (data[4] != 1) );
t_clk_dataout[5]: DELAY (POSEDGE) clk dataout[5] COND
               ( (async == 0) && (data[5] != 0) && (data[5] != 1) );
t_clk_dataout[6]: DELAY (POSEDGE) clk dataout[6] COND
               ( (async == 0) && (data[6] != 0) && (data[6] != 1) );
t_clk_dataout[7]: DELAY (POSEDGE) clk dataout[7] COND
               ( (async == 0) && (data[7] != 0) && (data[7] != 1) );
t_clk_dataout[8]: DELAY (POSEDGE) clk dataout[8] COND
               ( (async == 0) && (data[8] != 0) && (data[8] != 1) );
t_clk_dataout[9]: DELAY (POSEDGE) clk dataout[9] COND
               ( (async == 0) && (data[9] != 0) && (data[9] != 1) );

t_clk_dataout[10]: DELAY (POSEDGE) clk dataout[10] COND
               ( (async == 0) && (data[10] != 0) && (data[10] != 1) );
t_clk_dataout[11]: DELAY (POSEDGE) clk dataout[11] COND
               ( (async == 0) && (data[11] != 0) && (data[11] != 1) );
t_clk_dataout[12]: DELAY (POSEDGE) clk dataout[12] COND
               ( (async == 0) && (data[12] != 0) && (data[12] != 1) );
t_clk_dataout[13]: DELAY (POSEDGE) clk dataout[13] COND
               ( (async == 0) && (data[13] != 0) && (data[13] != 1) );
t_clk_dataout[14]: DELAY (POSEDGE) clk dataout[14] COND
               ( (async == 0) && (data[14] != 0) && (data[14] != 1) );
t_clk_dataout[15]: DELAY (POSEDGE) clk dataout[15] COND
               ( (async == 0) && (data[15] != 0) && (data[15] != 1) );
t_clk_dataout[16]: DELAY (POSEDGE) clk dataout[16] COND
               ( (async == 0) && (data[16] != 0) && (data[16] != 1) );
t_clk_dataout[17]: DELAY (POSEDGE) clk dataout[17] COND
               ( (async == 0) && (data[17] != 0) && (data[17] != 1) );
t_clk_dataout[18]: DELAY (POSEDGE) clk dataout[18] COND
               ( (async == 0) && (data[18] != 0) && (data[18] != 1) );
t_clk_dataout[19]: DELAY (POSEDGE) clk dataout[19] COND
               ( (async == 0) && (data[19] != 0) && (data[19] != 1) );

t_clk_dataout[20]: DELAY (POSEDGE) clk dataout[20] COND
               ( (async == 0) && (data[20] != 0) && (data[20] != 1) );
t_clk_dataout[21]: DELAY (POSEDGE) clk dataout[21] COND
               ( (async == 0) && (data[21] != 0) && (data[21] != 1) );
t_clk_dataout[22]: DELAY (POSEDGE) clk dataout[22] COND
               ( (async == 0) && (data[22] != 0) && (data[22] != 1) );
t_clk_dataout[23]: DELAY (POSEDGE) clk dataout[23] COND
               ( (async == 0) && (data[23] != 0) && (data[23] != 1) );
t_clk_dataout[24]: DELAY (POSEDGE) clk dataout[24] COND
               ( (async == 0) && (data[24] != 0) && (data[24] != 1) );
t_clk_dataout[25]: DELAY (POSEDGE) clk dataout[25] COND
               ( (async == 0) && (data[25] != 0) && (data[25] != 1) );
t_clk_dataout[26]: DELAY (POSEDGE) clk dataout[26] COND
               ( (async == 0) && (data[26] != 0) && (data[26] != 1) );
t_clk_dataout[27]: DELAY (POSEDGE) clk dataout[27] COND
               ( (async == 0) && (data[27] != 0) && (data[27] != 1) );
t_clk_dataout[28]: DELAY (POSEDGE) clk dataout[28] COND
               ( (async == 0) && (data[28] != 0) && (data[28] != 1) );
t_clk_dataout[29]: DELAY (POSEDGE) clk dataout[29] COND
               ( (async == 0) && (data[29] != 0) && (data[29] != 1) );

t_clk_dataout[30]: DELAY (POSEDGE) clk dataout[30] COND
               ( (async == 0) && (data[30] != 0) && (data[30] != 1) );
t_clk_dataout[31]: DELAY (POSEDGE) clk dataout[31] COND
               ( (async == 0) && (data[31] != 0) && (data[31] != 1) );
t_clk_dataout[32]: DELAY (POSEDGE) clk dataout[32] COND
               ( (async == 0) && (data[32] != 0) && (data[32] != 1) );
t_clk_dataout[33]: DELAY (POSEDGE) clk dataout[33] COND
               ( (async == 0) && (data[33] != 0) && (data[33] != 1) );
t_clk_dataout[34]: DELAY (POSEDGE) clk dataout[34] COND
               ( (async == 0) && (data[34] != 0) && (data[34] != 1) );
t_clk_dataout[35]: DELAY (POSEDGE) clk dataout[35] COND
               ( (async == 0) && (data[35] != 0) && (data[35] != 1) );
t_clk_dataout[36]: DELAY (POSEDGE) clk dataout[36] COND
               ( (async == 0) && (data[36] != 0) && (data[36] != 1) );
t_clk_dataout[37]: DELAY (POSEDGE) clk dataout[37] COND
               ( (async == 0) && (data[37] != 0) && (data[37] != 1) );
t_clk_dataout[38]: DELAY (POSEDGE) clk dataout[38] COND
               ( (async == 0) && (data[38] != 0) && (data[38] != 1) );
t_clk_dataout[39]: DELAY (POSEDGE) clk dataout[39] COND
               ( (async == 0) && (data[39] != 0) && (data[39] != 1) );

t_clk_dataout[40]: DELAY (POSEDGE) clk dataout[40] COND
               ( (async == 0) && (data[40] != 0) && (data[40] != 1) );
t_clk_dataout[41]: DELAY (POSEDGE) clk dataout[41] COND
               ( (async == 0) && (data[41] != 0) && (data[41] != 1) );
t_clk_dataout[42]: DELAY (POSEDGE) clk dataout[42] COND
               ( (async == 0) && (data[42] != 0) && (data[42] != 1) );
t_clk_dataout[43]: DELAY (POSEDGE) clk dataout[43] COND
               ( (async == 0) && (data[43] != 0) && (data[43] != 1) );
t_clk_dataout[44]: DELAY (POSEDGE) clk dataout[44] COND
               ( (async == 0) && (data[44] != 0) && (data[44] != 1) );
t_clk_dataout[45]: DELAY (POSEDGE) clk dataout[45] COND
               ( (async == 0) && (data[45] != 0) && (data[45] != 1) );
t_clk_dataout[46]: DELAY (POSEDGE) clk dataout[46] COND
               ( (async == 0) && (data[46] != 0) && (data[46] != 1) );
t_clk_dataout[47]: DELAY (POSEDGE) clk dataout[47] COND
               ( (async == 0) && (data[47] != 0) && (data[47] != 1) );
t_clk_dataout[48]: DELAY (POSEDGE) clk dataout[48] COND
               ( (async == 0) && (data[48] != 0) && (data[48] != 1) );
t_clk_dataout[49]: DELAY (POSEDGE) clk dataout[49] COND
               ( (async == 0) && (data[49] != 0) && (data[49] != 1) );

t_clk_dataout[50]: DELAY (POSEDGE) clk dataout[50] COND
               ( (async == 0) && (data[50] != 0) && (data[50] != 1) );
t_clk_dataout[51]: DELAY (POSEDGE) clk dataout[51] COND
               ( (async == 0) && (data[51] != 0) && (data[51] != 1) );
t_clk_dataout[52]: DELAY (POSEDGE) clk dataout[52] COND
               ( (async == 0) && (data[52] != 0) && (data[52] != 1) );
t_clk_dataout[53]: DELAY (POSEDGE) clk dataout[53] COND
               ( (async == 0) && (data[53] != 0) && (data[53] != 1) );
t_clk_dataout[54]: DELAY (POSEDGE) clk dataout[54] COND
               ( (async == 0) && (data[54] != 0) && (data[54] != 1) );
t_clk_dataout[55]: DELAY (POSEDGE) clk dataout[55] COND
               ( (async == 0) && (data[55] != 0) && (data[55] != 1) );
t_clk_dataout[56]: DELAY (POSEDGE) clk dataout[56] COND
               ( (async == 0) && (data[56] != 0) && (data[56] != 1) );
t_clk_dataout[57]: DELAY (POSEDGE) clk dataout[57] COND
               ( (async == 0) && (data[57] != 0) && (data[57] != 1) );
t_clk_dataout[58]: DELAY (POSEDGE) clk dataout[58] COND
               ( (async == 0) && (data[58] != 0) && (data[58] != 1) );
t_clk_dataout[59]: DELAY (POSEDGE) clk dataout[59] COND
               ( (async == 0) && (data[59] != 0) && (data[59] != 1) );

t_clk_dataout[60]: DELAY (POSEDGE) clk dataout[60] COND
               ( (async == 0) && (data[60] != 0) && (data[60] != 1) );
t_clk_dataout[61]: DELAY (POSEDGE) clk dataout[61] COND
               ( (async == 0) && (data[61] != 0) && (data[61] != 1) );
t_clk_dataout[62]: DELAY (POSEDGE) clk dataout[62] COND
               ( (async == 0) && (data[62] != 0) && (data[62] != 1) );
t_clk_dataout[63]: DELAY (POSEDGE) clk dataout[63] COND
               ( (async == 0) && (data[63] != 0) && (data[63] != 1) );
t_clk_dataout[64]: DELAY (POSEDGE) clk dataout[64] COND
               ( (async == 0) && (data[64] != 0) && (data[64] != 1) );
t_clk_dataout[65]: DELAY (POSEDGE) clk dataout[65] COND
               ( (async == 0) && (data[65] != 0) && (data[65] != 1) );
t_clk_dataout[66]: DELAY (POSEDGE) clk dataout[66] COND
               ( (async == 0) && (data[66] != 0) && (data[66] != 1) );
t_clk_dataout[67]: DELAY (POSEDGE) clk dataout[67] COND
               ( (async == 0) && (data[67] != 0) && (data[67] != 1) );
t_clk_dataout[68]: DELAY (POSEDGE) clk dataout[68] COND
               ( (async == 0) && (data[68] != 0) && (data[68] != 1) );
t_clk_dataout[69]: DELAY (POSEDGE) clk dataout[69] COND
               ( (async == 0) && (data[69] != 0) && (data[69] != 1) );

t_clk_dataout[70]: DELAY (POSEDGE) clk dataout[70] COND
               ( (async == 0) && (data[70] != 0) && (data[70] != 1) );
t_clk_dataout[71]: DELAY (POSEDGE) clk dataout[71] COND
               ( (async == 0) && (data[71] != 0) && (data[71] != 1) );
t_clk_dataout[72]: DELAY (POSEDGE) clk dataout[72] COND
               ( (async == 0) && (data[72] != 0) && (data[72] != 1) );
t_clk_dataout[73]: DELAY (POSEDGE) clk dataout[73] COND
               ( (async == 0) && (data[73] != 0) && (data[73] != 1) );
t_clk_dataout[74]: DELAY (POSEDGE) clk dataout[74] COND
               ( (async == 0) && (data[74] != 0) && (data[74] != 1) );
t_clk_dataout[75]: DELAY (POSEDGE) clk dataout[75] COND
               ( (async == 0) && (data[75] != 0) && (data[75] != 1) );
t_clk_dataout[76]: DELAY (POSEDGE) clk dataout[76] COND
               ( (async == 0) && (data[76] != 0) && (data[76] != 1) );
t_clk_dataout[77]: DELAY (POSEDGE) clk dataout[77] COND
               ( (async == 0) && (data[77] != 0) && (data[77] != 1) );
t_clk_dataout[78]: DELAY (POSEDGE) clk dataout[78] COND
               ( (async == 0) && (data[78] != 0) && (data[78] != 1) );
t_clk_dataout[79]: DELAY (POSEDGE) clk dataout[79] COND
               ( (async == 0) && (data[79] != 0) && (data[79] != 1) );

t_clk_dataout[80]: DELAY (POSEDGE) clk dataout[80] COND
               ( (async == 0) && (data[80] != 0) && (data[80] != 1) );
t_clk_dataout[81]: DELAY (POSEDGE) clk dataout[81] COND
               ( (async == 0) && (data[81] != 0) && (data[81] != 1) );
t_clk_dataout[82]: DELAY (POSEDGE) clk dataout[82] COND
               ( (async == 0) && (data[82] != 0) && (data[82] != 1) );
t_clk_dataout[83]: DELAY (POSEDGE) clk dataout[83] COND
               ( (async == 0) && (data[83] != 0) && (data[83] != 1) );
t_clk_dataout[84]: DELAY (POSEDGE) clk dataout[84] COND
               ( (async == 0) && (data[84] != 0) && (data[84] != 1) );
t_clk_dataout[85]: DELAY (POSEDGE) clk dataout[85] COND
               ( (async == 0) && (data[85] != 0) && (data[85] != 1) );
t_clk_dataout[86]: DELAY (POSEDGE) clk dataout[86] COND
               ( (async == 0) && (data[86] != 0) && (data[86] != 1) );
t_clk_dataout[87]: DELAY (POSEDGE) clk dataout[87] COND
               ( (async == 0) && (data[87] != 0) && (data[87] != 1) );
t_clk_dataout[88]: DELAY (POSEDGE) clk dataout[88] COND
               ( (async == 0) && (data[88] != 0) && (data[88] != 1) );
t_clk_dataout[89]: DELAY (POSEDGE) clk dataout[89] COND
               ( (async == 0) && (data[89] != 0) && (data[89] != 1) );

t_clk_dataout[90]: DELAY (POSEDGE) clk dataout[90] COND
               ( (async == 0) && (data[90] != 0) && (data[90] != 1) );
t_clk_dataout[91]: DELAY (POSEDGE) clk dataout[91] COND
               ( (async == 0) && (data[91] != 0) && (data[91] != 1) );
t_clk_dataout[92]: DELAY (POSEDGE) clk dataout[92] COND
               ( (async == 0) && (data[92] != 0) && (data[92] != 1) );
t_clk_dataout[93]: DELAY (POSEDGE) clk dataout[93] COND
               ( (async == 0) && (data[93] != 0) && (data[93] != 1) );
t_clk_dataout[94]: DELAY (POSEDGE) clk dataout[94] COND
               ( (async == 0) && (data[94] != 0) && (data[94] != 1) );
t_clk_dataout[95]: DELAY (POSEDGE) clk dataout[95] COND
               ( (async == 0) && (data[95] != 0) && (data[95] != 1) );
t_clk_dataout[96]: DELAY (POSEDGE) clk dataout[96] COND
               ( (async == 0) && (data[96] != 0) && (data[96] != 1) );
t_clk_dataout[97]: DELAY (POSEDGE) clk dataout[97] COND
               ( (async == 0) && (data[97] != 0) && (data[97] != 1) );
t_clk_dataout[98]: DELAY (POSEDGE) clk dataout[98] COND
               ( (async == 0) && (data[98] != 0) && (data[98] != 1) );
t_clk_dataout[99]: DELAY (POSEDGE) clk dataout[99] COND
               ( (async == 0) && (data[99] != 0) && (data[99] != 1) );

t_clk_dataout[100]: DELAY (POSEDGE) clk dataout[100] COND
               ( (async == 0) && (data[100] != 0) && (data[100] != 1) );
t_clk_dataout[101]: DELAY (POSEDGE) clk dataout[101] COND
               ( (async == 0) && (data[101] != 0) && (data[101] != 1) );
t_clk_dataout[102]: DELAY (POSEDGE) clk dataout[102] COND
               ( (async == 0) && (data[102] != 0) && (data[102] != 1) );
t_clk_dataout[103]: DELAY (POSEDGE) clk dataout[103] COND
               ( (async == 0) && (data[103] != 0) && (data[103] != 1) );
t_clk_dataout[104]: DELAY (POSEDGE) clk dataout[104] COND
               ( (async == 0) && (data[104] != 0) && (data[104] != 1) );
t_clk_dataout[105]: DELAY (POSEDGE) clk dataout[105] COND
               ( (async == 0) && (data[105] != 0) && (data[105] != 1) );
t_clk_dataout[106]: DELAY (POSEDGE) clk dataout[106] COND
               ( (async == 0) && (data[106] != 0) && (data[106] != 1) );
t_clk_dataout[107]: DELAY (POSEDGE) clk dataout[107] COND
               ( (async == 0) && (data[107] != 0) && (data[107] != 1) );
t_clk_dataout[108]: DELAY (POSEDGE) clk dataout[108] COND
               ( (async == 0) && (data[108] != 0) && (data[108] != 1) );
t_clk_dataout[109]: DELAY (POSEDGE) clk dataout[109] COND
               ( (async == 0) && (data[109] != 0) && (data[109] != 1) );

t_clk_dataout[110]: DELAY (POSEDGE) clk dataout[110] COND
               ( (async == 0) && (data[110] != 0) && (data[110] != 1) );
t_clk_dataout[111]: DELAY (POSEDGE) clk dataout[111] COND
               ( (async == 0) && (data[111] != 0) && (data[111] != 1) );
t_clk_dataout[112]: DELAY (POSEDGE) clk dataout[112] COND
               ( (async == 0) && (data[112] != 0) && (data[112] != 1) );
t_clk_dataout[113]: DELAY (POSEDGE) clk dataout[113] COND
               ( (async == 0) && (data[113] != 0) && (data[113] != 1) );
t_clk_dataout[114]: DELAY (POSEDGE) clk dataout[114] COND
               ( (async == 0) && (data[114] != 0) && (data[114] != 1) );
t_clk_dataout[115]: DELAY (POSEDGE) clk dataout[115] COND
               ( (async == 0) && (data[115] != 0) && (data[115] != 1) );
t_clk_dataout[116]: DELAY (POSEDGE) clk dataout[116] COND
               ( (async == 0) && (data[116] != 0) && (data[116] != 1) );
t_clk_dataout[117]: DELAY (POSEDGE) clk dataout[117] COND
               ( (async == 0) && (data[117] != 0) && (data[117] != 1) );
t_clk_dataout[118]: DELAY (POSEDGE) clk dataout[118] COND
               ( (async == 0) && (data[118] != 0) && (data[118] != 1) );
t_clk_dataout[119]: DELAY (POSEDGE) clk dataout[119] COND
               ( (async == 0) && (data[119] != 0) && (data[119] != 1) );

t_clk_dataout[120]: DELAY (POSEDGE) clk dataout[120] COND
               ( (async == 0) && (data[120] != 0) && (data[120] != 1) );
t_clk_dataout[121]: DELAY (POSEDGE) clk dataout[121] COND
               ( (async == 0) && (data[121] != 0) && (data[121] != 1) );
t_clk_dataout[122]: DELAY (POSEDGE) clk dataout[122] COND
               ( (async == 0) && (data[122] != 0) && (data[122] != 1) );
t_clk_dataout[123]: DELAY (POSEDGE) clk dataout[123] COND
               ( (async == 0) && (data[123] != 0) && (data[123] != 1) );
t_clk_dataout[124]: DELAY (POSEDGE) clk dataout[124] COND
               ( (async == 0) && (data[124] != 0) && (data[124] != 1) );
t_clk_dataout[125]: DELAY (POSEDGE) clk dataout[125] COND
               ( (async == 0) && (data[125] != 0) && (data[125] != 1) );
t_clk_dataout[126]: DELAY (POSEDGE) clk dataout[126] COND
               ( (async == 0) && (data[126] != 0) && (data[126] != 1) );
t_clk_dataout[127]: DELAY (POSEDGE) clk dataout[127] COND
               ( (async == 0) && (data[127] != 0) && (data[127] != 1) );
t_clk_dataout[128]: DELAY (POSEDGE) clk dataout[128] COND
               ( (async == 0) && (data[128] != 0) && (data[128] != 1) );
t_clk_dataout[129]: DELAY (POSEDGE) clk dataout[129] COND
               ( (async == 0) && (data[129] != 0) && (data[129] != 1) );

t_clk_dataout[130]: DELAY (POSEDGE) clk dataout[130] COND
               ( (async == 0) && (data[130] != 0) && (data[130] != 1) );
t_clk_dataout[131]: DELAY (POSEDGE) clk dataout[131] COND
               ( (async == 0) && (data[131] != 0) && (data[131] != 1) );
t_clk_dataout[132]: DELAY (POSEDGE) clk dataout[132] COND
               ( (async == 0) && (data[132] != 0) && (data[132] != 1) );
t_clk_dataout[133]: DELAY (POSEDGE) clk dataout[133] COND
               ( (async == 0) && (data[133] != 0) && (data[133] != 1) );
t_clk_dataout[134]: DELAY (POSEDGE) clk dataout[134] COND
               ( (async == 0) && (data[134] != 0) && (data[134] != 1) );
t_clk_dataout[135]: DELAY (POSEDGE) clk dataout[135] COND
               ( (async == 0) && (data[135] != 0) && (data[135] != 1) );
t_clk_dataout[136]: DELAY (POSEDGE) clk dataout[136] COND
               ( (async == 0) && (data[136] != 0) && (data[136] != 1) );
t_clk_dataout[137]: DELAY (POSEDGE) clk dataout[137] COND
               ( (async == 0) && (data[137] != 0) && (data[137] != 1) );
t_clk_dataout[138]: DELAY (POSEDGE) clk dataout[138] COND
               ( (async == 0) && (data[138] != 0) && (data[138] != 1) );
t_clk_dataout[139]: DELAY (POSEDGE) clk dataout[139] COND
               ( (async == 0) && (data[139] != 0) && (data[139] != 1) );

t_clk_dataout[140]: DELAY (POSEDGE) clk dataout[140] COND
               ( (async == 0) && (data[140] != 0) && (data[140] != 1) );
t_clk_dataout[141]: DELAY (POSEDGE) clk dataout[141] COND
               ( (async == 0) && (data[141] != 0) && (data[141] != 1) );
t_clk_dataout[142]: DELAY (POSEDGE) clk dataout[142] COND
               ( (async == 0) && (data[142] != 0) && (data[142] != 1) );
t_clk_dataout[143]: DELAY (POSEDGE) clk dataout[143] COND
               ( (async == 0) && (data[143] != 0) && (data[143] != 1) );

/* asynchronous clear timing arc */
t_aclr_dataout: DELAY (CLEAR_HIGH, EQUIVALENT) aclr dataout COND
               (async == 0);


/* timing checks */
t_setup_data_posedge_clk: SETUP (POSEDGE) data clk COND
               (async == 0);

t_setup_ena_posedge_clk: SETUP (POSEDGE) ena clk COND
               (async == 0);


t_hold_data_posedge_clk: HOLD (POSEDGE) data clk COND
               (async == 0);


t_hold_ena_posedge_clk: HOLD (POSEDGE) ena clk COND
               (async == 0);


ENDMODEL
