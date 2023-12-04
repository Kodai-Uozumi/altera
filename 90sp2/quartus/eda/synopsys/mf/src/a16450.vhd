-- Your use of Altera Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Altera Program License 
-- Subscription Agreement, Altera MegaCore Function License 
-- Agreement, or other applicable license agreement, including, 
-- without limitation, that your use is for the sole purpose of 
-- programming logic devices manufactured by Altera and sold by 
-- Altera or its authorized distributors.  Please refer to the 
-- applicable agreement for further details.


LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY TRIBUF_a16450 IS
    PORT (
        in1 : IN std_logic;
        oe  : IN std_logic;
        y   : OUT std_logic);
END TRIBUF_a16450;

ARCHITECTURE behavior OF TRIBUF_a16450 IS
BEGIN
    PROCESS (in1, oe)
    BEGIN
        IF oe'EVENT THEN
            IF oe = '0' THEN
                y <= TRANSPORT 'Z'  ;
            ELSIF oe = '1' THEN
                y <= TRANSPORT in1  ;
            END IF;
        ELSIF oe = '1' THEN
            y <= TRANSPORT in1  ;
        END IF;
    END PROCESS;
END behavior;

LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY DFF_a16450 IS
    PORT (
      	 d   : IN std_logic;
      	 clk : IN std_logic;
      	 clrn: IN std_logic;
      	 prn : IN std_logic;
      	 q   : OUT std_logic := '0');
END DFF_a16450;

ARCHITECTURE behavior OF DFF_a16450 IS
BEGIN

    PROCESS (clk, clrn, prn)
        VARIABLE result : std_logic := '0';
    BEGIN
        ASSERT NOT (prn = '0' AND clrn = '0')
            REPORT " prn and clrn both '0' on DFF"
            SEVERITY Warning;

        IF prn = '0' AND clrn = '1' THEN
            result := '1';
        ELSIF prn = '1' AND clrn = '0' THEN
            result := '0';
        ELSIF rising_edge(clk) THEN
            IF d = '1' OR d = '0' THEN
                result := d;
            END IF;
        END IF;

        IF result /= 'X' THEN
            q <= TRANSPORT result  ;
        END IF;

    END PROCESS;
END behavior;

LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY FILTER_a16450 IS
    PORT (
        in1 : IN std_logic;
        y: OUT std_logic);
END FILTER_a16450;

ARCHITECTURE behavior OF FILTER_a16450 IS
BEGIN

    y <= in1;
END behavior;

LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE work.tribuf_a16450;
USE work.dff_a16450;
USE work.filter_a16450;

ENTITY a16450 IS
    PORT (
      A : IN std_logic_vector(2 downto 0);
      DIN : IN std_logic_vector(7 downto 0);
      DOUT : OUT std_logic_vector(7 downto 0);
      CLK : IN std_logic;
      CS0 : IN std_logic;
      CS1 : IN std_logic;
      MR : IN std_logic;
      nADS : IN std_logic;
      nCS2 : IN std_logic;
      nCTS : IN std_logic;
      nDCD : IN std_logic;
      nDSR : IN std_logic;
      nRD : IN std_logic;
      nRI : IN std_logic;
      nWR : IN std_logic;
      RCLK : IN std_logic;
      RD : IN std_logic;
      SIN : IN std_logic;
      WR : IN std_logic;
      CSOUT : OUT std_logic;
      DDIS : OUT std_logic;
      INTR : OUT std_logic;
      nBAUDOUT : OUT std_logic;
      nDTR : OUT std_logic;
      nOUT1 : OUT std_logic;
      nOUT2 : OUT std_logic;
      nRTS : OUT std_logic;
      SOUT : OUT std_logic);
END a16450;

ARCHITECTURE Version_1_0 OF a16450 IS

SIGNAL gnd : std_logic := '0';
SIGNAL vcc : std_logic := '1';
SIGNAL
    n_88, n_89, n_90, n_91, n_92, a_G161, n_94, n_95, n_96, n_97, n_98, n_99,
          a_LC4_B9, n_101, n_102, n_103, n_104, n_105, n_106, a_G513, n_108,
          n_109, n_110, n_111, n_112, n_113, a_G103, n_115, n_116, n_117,
          n_118, n_119, n_120, a_G764, n_122, n_123, n_124, n_125, n_126,
          n_127, a_LC6_C8, n_129, n_130, n_131, n_132, n_133, n_134, a_G770,
          n_136, n_137, n_138, n_139, n_140, n_141, a_LC1_C14, n_143, n_144,
          n_145, n_146, n_147, n_148, a_SSOUT, n_150, n_151, n_152, n_153,
          n_154, n_155, a_SMCNTL_DAT_F1_G, n_157, n_158, n_159, n_160, n_161,
          n_162, a_SMCNTL_DAT_F3_G, n_164, n_165, n_166, n_167, n_168, n_169,
          a_SMCNTL_DAT_F2_G, n_171, n_172, n_173, n_174, n_175, n_176, a_SINTR,
          n_178, n_179, n_180, n_181, n_182, n_183, a_SMCNTL_DAT_F0_G, n_185,
          n_186, n_187, n_188, n_189, n_190, a_N805, n_192, n_193, n_194,
          n_195, n_196, n_197, a_SCSOUT, n_199, n_200, n_201, n_202, n_203,
          n_204, a_SBAUDOUT_N, n_206, a_N7, a_N7_aCLRN, a_N7_aD, n_215, n_216,
          n_217, a_N5, n_219, n_220, a_N7_aCLK, a_N10, a_N10_aCLRN, a_EQ058,
          n_230, n_231, n_232, a_N797, n_234, a_LC1_A19, n_236, n_237, n_238,
          n_239, n_240, a_N10_aCLK, a_EQ242, n_244, n_245, n_246, n_247, n_249,
          n_250, n_251, n_253, a_N33, a_N33_aIN, n_256, n_257, n_258, a_N1310,
          n_260, a_N1311, n_262, a_N1312, n_264, a_N351, a_N351_aCLRN, a_EQ171,
          n_272, n_273, n_274, n_275, n_276, n_277, n_278, n_279, n_280, n_281,
          n_282, a_N351_aCLK, a_N783_aNOT, a_EQ219, n_286, n_287, n_288, n_289,
          n_290, n_291, n_292, a_LC2_B2, a_LC2_B2_aIN, n_295, n_296, n_297,
          a_SLCNTL_DOUT_F3_G, n_299, a_N792_aNOT, n_301, a_LC5_A6, a_EQ206,
          n_304, n_305, n_306, a_N51, n_308, a_N49, n_310, a_N48, n_312, a_N60,
          n_314, n_315, n_316, n_317, n_318, n_319, n_320, n_321, n_322, n_323,
          n_324, n_325, n_326, n_327, n_328, n_329, n_330, n_331, n_332, n_333,
          n_334, n_335, n_336, n_337, n_338, n_339, n_340, n_341, n_342, n_343,
          n_344, n_345, n_346, n_347, n_348, n_349, a_LC3_A12, a_EQ205, n_352,
          n_353, n_354, a_N53, n_356, a_N59, n_358, a_N55, n_360, n_361, n_362,
          n_363, n_364, n_365, n_366, n_367, n_368, n_369, n_370, n_371, n_372,
          a_N548, a_EQ207, n_375, n_376, n_377, a_N58, n_379, n_380, n_381,
          n_382, n_383, n_384, n_385, n_386, n_387, n_388, n_389, n_390, n_391,
          n_392, n_393, a_N524, a_EQ196, n_396, n_397, n_398, a_N1369, n_400,
          n_401, a_SLCNTL_DOUT_F4_G, n_403, a_SLCNTL_DOUT_F5_G, n_405, n_406,
          n_407, n_408, n_409, n_410, n_411, n_412, n_413, n_414, n_415, n_416,
          n_417, n_418, n_419, n_420, n_421, n_422, n_423, n_424, n_425, n_426,
          a_SLSTAT_DAT_F2_G, a_SLSTAT_DAT_F2_G_aCLRN, a_EQ337, n_434, n_435,
          n_436, n_437, n_438, n_439, n_440, n_441, n_442, n_443, a_SLSTAT_DAT_F2_G_aCLK,
          a_SLSTAT_DAT_F3_G, a_SLSTAT_DAT_F3_G_aCLRN, a_EQ338, n_452, n_453,
          n_454, n_455, n_456, n_457, a_N16_aNOT, n_459, n_460, n_461, n_462,
          a_SLSTAT_DAT_F3_G_aCLK, a_LC8_A9, a_LC8_A9_aIN, n_466, n_467, n_468,
          a_N346, n_470, a_N347, n_472, a_N348, n_474, a_SLSTAT_DAT_F4_G,
          a_SLSTAT_DAT_F4_G_aCLRN, a_EQ339, n_482, n_483, n_484, n_485, n_486,
          n_487, a_N349, n_489, n_490, n_491, n_492, a_SLSTAT_DAT_F4_G_aCLK,
          a_SLSTAT_DAT_F1_G, a_SLSTAT_DAT_F1_G_aCLRN, a_EQ336, n_501, n_502,
          n_503, n_504, n_505, n_506, n_507, n_508, a_SLSTAT_DAT_F0_G, n_510,
          n_511, a_SLSTAT_DAT_F1_G_aCLK, a_N1310_aCLRN, a_EQ277, n_521, n_522,
          n_523, n_524, n_525, n_526, n_527, n_528, n_529, a_N1310_aCLK, a_N1313,
          a_N1313_aCLRN, a_EQ280, n_538, n_539, n_540, a_N32, n_542, n_543,
          n_544, a_N804, n_546, n_547, n_548, n_549, n_550, n_552, n_553,
          a_N1313_aCLK, a_SINTEN_DAT_F0_G, a_SINTEN_DAT_F0_G_aCLRN, a_EQ318,
          n_562, n_563, n_564, a_N796_aNOT, n_566, n_568, n_569, n_570, n_571,
          n_572, a_SINTEN_DAT_F0_G_aCLK, rbuff_rd, rbuff_rd_aIN, n_576, n_577,
          n_578, a_N21, n_580, a_SLCNTL_DOUT_F7_G, n_582, n_583, a_N350, a_N350_aCLRN,
          a_N350_aD, n_591, n_592, n_593, n_594, n_595, n_596, n_597, a_N350_aCLK,
          a_SLSTAT_DAT_F0_G_aCLRN, a_EQ335, n_605, n_606, n_607, n_608, n_609,
          n_610, n_611, n_612, n_613, n_614, n_615, n_616, n_617, n_618, n_619,
          a_SLSTAT_DAT_F0_G_aCLK, a_N1125, a_N1125_aCLRN, a_N1125_aD, n_628,
          n_629, n_630, a_N1123, n_632, n_633, a_N1125_aCLK, a_N1123_aCLRN,
          a_EQ257, n_643, n_644, n_645, n_646, n_647, n_648, n_649, a_N1123_aCLK,
          a_SDLSB_DAT_F0_G, a_SDLSB_DAT_F0_G_aCLRN, a_EQ302, n_658, n_659,
          n_660, a_N795_aNOT, n_662, n_663, n_664, n_665, n_666, n_667, a_SDLSB_DAT_F0_G_aCLK,
          a_SDLSB_DAT_F1_G, a_SDLSB_DAT_F1_G_aCLRN, a_EQ303, n_676, n_677,
          n_678, n_679, n_680, n_681, n_682, n_684, n_685, a_SDLSB_DAT_F1_G_aCLK,
          a_SDLSB_DAT_F2_G, a_SDLSB_DAT_F2_G_aCLRN, a_EQ304, n_694, n_695,
          n_696, n_697, n_699, n_700, n_701, n_702, n_703, a_SDLSB_DAT_F2_G_aCLK,
          a_SDLSB_DAT_F3_G, a_SDLSB_DAT_F3_G_aCLRN, a_EQ305, n_712, n_713,
          n_714, n_715, n_716, n_717, n_718, n_720, n_721, a_SDLSB_DAT_F3_G_aCLK,
          a_SLCNTL_DOUT_F4_G_aCLRN, a_EQ331, n_729, n_730, n_731, a_N35, n_733,
          n_734, n_735, n_736, n_737, n_738, n_739, n_740, n_742, n_743, a_SLCNTL_DOUT_F4_G_aCLK,
          a_SLCNTL_DOUT_F5_G_aCLRN, a_EQ332, n_751, n_752, n_753, n_754, n_755,
          n_756, n_757, n_758, n_759, n_760, n_761, n_763, n_764, a_SLCNTL_DOUT_F5_G_aCLK,
          a_N1311_aCLRN, a_EQ278, n_773, n_774, n_775, n_776, n_777, n_778,
          n_779, n_780, n_781, a_N1311_aCLK, a_N1312_aCLRN, a_EQ279, n_790,
          n_791, n_792, n_793, n_794, n_795, n_796, n_797, n_798, a_N1312_aCLK,
          a_N29_aNOT, a_EQ071, n_802, n_803, n_804, n_805, n_806, n_807, n_808,
          n_809, en_lpbk, en_lpbk_aCLRN, a_EQ002, n_817, n_818, n_819, n_820,
          n_821, n_822, n_823, n_824, n_825, n_826, n_827, n_828, n_829, en_lpbk_aCLK,
          a_N39, a_N39_aIN, n_833, n_834, n_835, a_N705, n_837, a_N704, n_839,
          a_LC8_C4, a_EQ159, n_842, n_843, n_844, n_845, n_846, n_847, a_N702,
          n_849, n_850, n_851, a_N1354_aNOT, n_853, n_854, lpbk_sin, a_EQ003,
          n_861, n_862, n_863, a_N1353, n_865, a_SLCNTL_DOUT_F6_G, n_867,
          n_868, n_869, n_870, n_871, n_872, n_873, lpbk_sin_aCLK, a_SINTEN_DAT_F2_G,
          a_SINTEN_DAT_F2_G_aCLRN, a_EQ320, n_882, n_883, n_884, n_885, n_886,
          n_887, n_888, n_889, n_890, a_SINTEN_DAT_F2_G_aCLK, a_SMCNTL_DAT_F1_G_aCLRN,
          a_EQ342, n_901, n_902, n_903, n_904, n_905, n_906, n_907, n_908,
          n_909, n_910, n_911, n_912, n_913, a_SMCNTL_DAT_F1_G_aCLK, a_SMCNTL_DAT_F3_G_aCLRN,
          a_EQ344, n_921, n_922, n_923, n_924, n_925, n_926, n_927, n_928,
          n_929, n_930, n_931, n_932, n_933, a_SMCNTL_DAT_F3_G_aCLK, a_SMCNTL_DAT_F2_G_aCLRN,
          a_EQ343, n_941, n_942, n_943, n_944, n_945, n_946, n_947, n_948,
          n_949, n_950, n_951, n_952, n_953, a_SMCNTL_DAT_F2_G_aCLK, a_SMCNTL_DAT_F0_G_aCLRN,
          a_EQ341, n_961, n_962, n_963, n_964, n_965, n_966, n_967, n_968,
          n_969, n_970, n_971, n_972, n_973, a_SMCNTL_DAT_F0_G_aCLK, a_LC4_B19,
          a_EQ034, n_977, n_978, n_979, n_980, n_981, n_982, a_SINTID_DAT_F0_G_aNOT,
          n_984, a_N31, n_986, a_LC5_B19, a_EQ035, n_989, n_990, n_991, n_992,
          n_993, a_N30, n_995, a_SMSTAT_DAT_F0_G, n_997, a_LC6_B19, a_EQ036,
          n_1000, n_1001, n_1002, n_1003, n_1004, n_1005, n_1006, a_N1320,
          n_1008, a_LC3_B19, a_EQ037, n_1011, n_1012, n_1013, n_1014, n_1015,
          n_1016, n_1017, n_1018, a_SLCNTL_DOUT_F0_G, n_1020, a_LC4_B13, a_EQ038,
          n_1023, n_1024, n_1025, n_1026, a_SREC_DAT_F0_G, n_1028, n_1029,
          n_1030, n_1031, n_1032, n_1033, a_LC3_B13, a_EQ033, n_1036, n_1037,
          n_1038, a_SDMSB_DAT_F0_G, n_1040, n_1041, n_1042, n_1043, n_1044,
          a_EQ039, n_1046, n_1047, n_1048, n_1049, n_1050, n_1051, n_1052,
          a_N34_aNOT, n_1054, n_1055, a_LC3_B9, a_EQ014, n_1058, n_1059, n_1060,
          n_1061, a_SLCNTL_DOUT_F1_G, n_1063, n_1064, n_1065, n_1066, a_LC2_B9,
          a_EQ015, n_1069, n_1070, n_1071, n_1072, n_1073, n_1074, a_N1319,
          n_1076, a_LC4_B2, a_EQ016, n_1079, n_1080, n_1081, n_1082, n_1083,
          n_1084, n_1085, a_SINTID_DAT_F1_G, n_1087, a_LC1_B9, a_EQ017, n_1090,
          n_1091, n_1092, n_1093, n_1094, n_1095, n_1096, n_1097, a_SMSTAT_DAT_F1_G,
          n_1099, a_N837_aNOT, a_EQ250, n_1102, n_1103, n_1104, n_1105, a_SREC_DAT_F1_G,
          n_1107, n_1108, n_1109, n_1110, n_1111, n_1112, a_N469, a_EQ191,
          n_1115, n_1116, n_1117, a_SDMSB_DAT_F1_G, n_1119, n_1120, n_1121,
          n_1122, a_SINTEN_DAT_F1_G, n_1124, a_EQ013, n_1126, n_1127, n_1128,
          n_1129, n_1130, n_1131, n_1132, n_1133, n_1134, a_LC7_B20, a_EQ041,
          n_1137, n_1138, n_1139, n_1140, n_1141, n_1142, a_SINTID_DAT_F2_G,
          n_1144, n_1145, a_LC6_B20, a_EQ042, n_1148, n_1149, n_1150, n_1151,
          n_1152, n_1153, a_SMSTAT_DAT_F2_G, n_1155, a_LC4_B20, a_EQ043, n_1158,
          n_1159, n_1160, n_1161, n_1162, n_1163, n_1164, a_N1318, n_1166,
          a_LC5_B20, a_EQ044, n_1169, n_1170, n_1171, n_1172, n_1173, n_1174,
          n_1175, n_1176, a_SLCNTL_DOUT_F2_G, n_1178, a_LC2_B14, a_EQ045,
          n_1181, n_1182, n_1183, n_1184, n_1185, n_1186, n_1187, n_1188,
          a_SREC_DAT_F2_G, n_1190, n_1191, a_LC4_B14, a_EQ040, n_1194, n_1195,
          n_1196, a_SDMSB_DAT_F2_G, n_1198, n_1199, n_1200, n_1201, n_1202,
          a_EQ046, n_1204, n_1205, n_1206, n_1207, n_1208, n_1209, n_1210,
          n_1211, n_1212, a_LC5_B5, a_EQ028, n_1215, n_1216, n_1217, n_1218,
          a_SMSTAT_DAT_F3_G, n_1220, n_1221, n_1222, n_1223, a_LC3_B5, a_EQ029,
          n_1226, n_1227, n_1228, n_1229, n_1230, n_1231, a_N1317, n_1233,
          a_LC2_B5, a_EQ030, n_1236, n_1237, n_1238, n_1239, n_1240, n_1241,
          n_1242, a_LC4_B5, a_EQ031, n_1245, n_1246, n_1247, n_1248, n_1249,
          n_1250, n_1251, a_LC2_B13, a_EQ027, n_1254, n_1255, n_1256, n_1257,
          a_SREC_DAT_F3_G, n_1259, n_1260, n_1261, n_1262, n_1263, n_1264,
          a_LC1_B13, a_EQ026, n_1267, n_1268, n_1269, n_1270, a_SINTEN_DAT_F3_G,
          n_1272, n_1273, a_SDMSB_DAT_F3_G, n_1275, n_1276, a_EQ032, n_1278,
          n_1279, n_1280, n_1281, n_1282, n_1283, n_1284, n_1285, n_1286,
          a_LC6_C7, a_EQ050, n_1289, n_1290, n_1291, a_LC1_B18, n_1293, a_SDMSB_DAT_F4_G,
          n_1295, n_1296, n_1297, n_1298, a_LC5_A12, a_EQ047, n_1301, n_1302,
          n_1303, n_1304, a_SREC_DAT_F4_G, n_1306, n_1307, n_1308, n_1309,
          a_SDLSB_DAT_F4_G, n_1311, n_1312, a_LC3_C7, a_EQ048, n_1315, n_1316,
          n_1317, n_1318, a_N1316, n_1320, n_1321, n_1322, n_1323, a_SMSTAT_DAT_F4_G,
          a_SMSTAT_DAT_F4_G_aCLRN, a_EQ246, n_1331, n_1332, n_1333, n_1334,
          n_1335, n_1336, n_1338, n_1339, n_1340, a_SMSTAT_DAT_F4_G_aCLK,
          a_LC1_C7, a_EQ049, n_1344, n_1345, n_1346, n_1347, n_1348, n_1349,
          n_1350, n_1351, n_1352, a_EQ051, n_1354, n_1355, n_1356, n_1357,
          n_1358, n_1359, n_1360, n_1361, n_1362, a_LC3_C8, a_EQ022, n_1365,
          n_1366, n_1367, n_1368, a_SDMSB_DAT_F5_G, n_1370, n_1371, n_1372,
          a_N1315, n_1374, a_SMSTAT_DAT_F5_G, a_SMSTAT_DAT_F5_G_aCLRN, a_EQ247,
          n_1382, n_1383, n_1384, n_1385, n_1386, n_1387, n_1389, n_1390,
          n_1391, a_SMSTAT_DAT_F5_G_aCLK, a_LC2_C8, a_EQ024, n_1395, n_1396,
          n_1397, a_SLSTAT_DAT_F5_G_aNOT, n_1399, n_1400, n_1401, n_1402,
          n_1403, a_LC8_A6, a_EQ023, n_1406, n_1407, n_1408, a_SREC_DAT_F5_G,
          n_1410, n_1411, n_1412, a_SDLSB_DAT_F5_G, n_1414, n_1415, a_LC4_C8,
          a_EQ025, n_1418, n_1419, n_1420, n_1421, n_1422, n_1423, n_1424,
          a_EQ021, n_1426, n_1427, n_1428, n_1429, n_1430, n_1431, n_1432,
          n_1433, n_1434, a_LC5_B12, a_EQ052, n_1437, n_1438, n_1439, a_SDMSB_DAT_F6_G,
          n_1441, n_1442, n_1443, a_SDLSB_DAT_F6_G, n_1445, n_1446, a_LC4_B12,
          a_EQ053, n_1449, n_1450, n_1451, n_1452, n_1453, n_1454, a_SREC_DAT_F6_G,
          n_1456, n_1457, n_1458, a_LC2_C18, a_LC2_C18_aIN, n_1461, n_1462,
          n_1463, n_1464, n_1465, n_1466, a_LC4_C18, a_EQ054, n_1469, n_1470,
          n_1471, n_1472, n_1473, n_1474, a_N20_aNOT, n_1476, n_1477, a_N292_aNOT,
          a_EQ158, n_1480, n_1481, n_1482, a_N1314, n_1484, n_1485, n_1486,
          n_1487, n_1488, a_SMSTAT_DAT_F6_G, a_SMSTAT_DAT_F6_G_aCLRN, a_EQ248,
          n_1496, n_1497, n_1498, n_1499, n_1500, n_1501, n_1503, n_1504,
          n_1505, a_SMSTAT_DAT_F6_G_aCLK, a_LC3_C18, a_EQ055, n_1509, n_1510,
          n_1511, n_1512, n_1513, n_1514, n_1515, n_1516, n_1517, a_EQ056,
          n_1519, n_1520, n_1521, n_1522, n_1523, n_1524, n_1525, n_1526,
          a_LC3_A11, a_EQ019, n_1529, n_1530, n_1531, a_SREC_DAT_F7_G, n_1533,
          n_1534, n_1535, a_SDLSB_DAT_F7_G, n_1537, n_1538, a_SMSTAT_DAT_F7_G,
          a_SMSTAT_DAT_F7_G_aCLRN, a_EQ249, n_1546, n_1547, n_1548, n_1549,
          n_1550, n_1551, n_1553, n_1554, n_1555, a_SMSTAT_DAT_F7_G_aCLK,
          a_LC3_C14, a_EQ020, n_1559, n_1560, n_1561, n_1562, n_1563, n_1564,
          n_1565, n_1566, n_1567, n_1568, a_LC8_C14, a_EQ157, n_1571, n_1572,
          n_1573, n_1574, n_1575, n_1576, n_1577, n_1578, a_SDMSB_DAT_F7_G,
          n_1580, n_1581, a_LC7_C14, a_LC7_C14_aIN, n_1584, n_1585, n_1586,
          n_1587, n_1588, n_1589, a_EQ018, n_1591, n_1592, n_1593, n_1594,
          n_1595, n_1596, n_1597, n_1598, n_1599, n_1600, n_1601, a_EQ361,
          n_1603, n_1604, n_1605, n_1606, n_1607, n_1608, a_LC6_B10, a_LC6_B10_aIN,
          n_1611, n_1612, n_1613, n_1614, n_1615, n_1616, n_1617, a_LC5_B10,
          a_LC5_B10_aIN, n_1620, n_1621, n_1622, n_1623, n_1624, n_1625, a_LC4_B17,
          a_LC4_B17_aIN, n_1628, n_1629, n_1630, n_1631, n_1632, n_1633, n_1634,
          a_N166_aNOT, a_N166_aNOT_aIN, n_1637, n_1638, n_1639, n_1640, n_1641,
          n_1642, n_1643, a_N170, a_EQ133, n_1646, n_1647, n_1648, n_1649,
          n_1650, n_1651, n_1652, n_1653, n_1654, n_1655, a_LC2_B1, a_EQ059,
          n_1658, n_1659, n_1660, a_N1283, n_1662, n_1663, a_N1279, n_1665,
          n_1666, a_N1289_aNOT, n_1668, n_1669, a_N1281, n_1671, a_LC6_B4,
          a_EQ060, n_1674, n_1675, n_1676, a_N1288, n_1678, n_1679, a_N1274,
          n_1681, n_1682, a_N1275, n_1684, n_1685, a_N1287, n_1687, a_LC7_B16,
          a_EQ061, n_1690, n_1691, n_1692, a_N1276, n_1694, n_1695, a_N1286,
          n_1697, n_1698, a_N1282, n_1700, n_1701, a_N1285, n_1703, a_LC3_B1,
          a_EQ062, n_1706, n_1707, n_1708, a_N1278, n_1710, n_1711, a_N1280,
          n_1713, n_1714, a_N1284, n_1716, n_1717, a_N1277, n_1719, a_N11_aNOT,
          a_EQ063, n_1722, n_1723, n_1724, n_1725, n_1726, n_1727, n_1728,
          n_1729, n_1730, n_1731, a_N159_aNOT, a_EQ127, n_1734, n_1735, n_1736,
          a_N788, n_1738, n_1739, n_1740, n_1741, n_1742, n_1743, a_N162,
          a_EQ128, n_1746, n_1747, n_1748, n_1749, n_1750, n_1751, n_1752,
          a_LC8_B10, a_LC8_B10_aIN, n_1755, n_1756, n_1757, n_1758, n_1759,
          n_1760, n_1761, a_EQ300, n_1763, n_1764, n_1765, n_1766, n_1767,
          n_1768, n_1769, n_1770, n_1771, a_EQ068, n_1773, n_1774, n_1775,
          n_1776, n_1777, n_1778, n_1779, n_1780, a_N37_aNOT, a_EQ079, n_1783,
          n_1784, n_1785, n_1786, n_1787, n_1788, n_1789, n_1790, a_N36_aNOT,
          a_EQ078, n_1793, n_1794, n_1795, n_1796, n_1797, n_1798, n_1799,
          n_1800, a_LC3_C5, a_EQ143, n_1803, n_1804, n_1805, n_1806, n_1807,
          n_1808, n_1809, a_N1349, n_1811, a_N61, a_EQ115, n_1814, n_1815,
          n_1816, n_1817, n_1818, n_1819, a_LC2_C11, a_EQ065, n_1822, n_1823,
          n_1824, n_1825, n_1826, n_1827, n_1828, n_1829, n_1830, a_N18, a_EQ067,
          n_1833, n_1834, n_1835, n_1836, n_1837, n_1838, n_1839, n_1840,
          baud_en, n_1842, a_N214, a_N214_aIN, n_1845, n_1846, n_1847, n_1848,
          n_1849, a_N785, a_N785_aIN, n_1852, n_1853, n_1854, n_1855, n_1856,
          n_1857, a_N528_aNOT, a_N528_aNOT_aCLRN, a_EQ198, n_1865, n_1866,
          n_1867, n_1868, a_N1355, n_1870, n_1871, n_1872, n_1873, n_1874,
          n_1875, n_1876, n_1877, a_N528_aNOT_aCLK, a_LC2_A14, a_EQ251, n_1881,
          n_1882, n_1883, n_1884, a_N1356, n_1886, n_1887, n_1888, a_N530_aNOT,
          n_1890, n_1891, n_1892, n_1893, a_N530_aNOT_aCLRN, a_EQ199, n_1900,
          n_1901, n_1902, n_1903, n_1904, n_1905, n_1906, n_1907, n_1908,
          a_N530_aNOT_aCLK, a_LC1_A14, a_EQ252, n_1912, n_1913, n_1914, n_1915,
          a_N1357, n_1917, n_1918, n_1919, a_N531_aNOT, n_1921, n_1922, n_1923,
          n_1924, a_N531_aNOT_aCLRN, a_EQ200, n_1931, n_1932, n_1933, n_1934,
          n_1935, n_1936, n_1937, n_1938, n_1939, a_N531_aNOT_aCLK, a_LC1_A1,
          a_EQ253, n_1943, n_1944, n_1945, n_1946, a_N1358, n_1948, n_1949,
          n_1950, a_N532_aNOT, n_1952, n_1953, n_1954, n_1955, a_N532_aNOT_aCLRN,
          a_EQ201, n_1962, n_1963, n_1964, n_1965, n_1966, n_1967, n_1968,
          n_1969, n_1970, a_N532_aNOT_aCLK, a_N191_aNOT, a_N191_aNOT_aIN,
          n_1974, n_1975, n_1976, n_1977, a_N682, n_1979, a_N681, n_1981,
          a_N493_aNOT, a_EQ193, n_1984, n_1985, n_1986, a_N680, n_1988, n_1989,
          a_N679, n_1991, n_1992, n_1993, a_N41_aNOT, a_EQ083, n_1996, n_1997,
          n_1998, n_1999, n_2000, n_2001, a_LC3_C20, a_EQ144, n_2004, n_2005,
          n_2006, n_2007, n_2008, n_2009, n_2010, n_2011, n_2012, n_2013,
          a_LC5_C20, a_EQ194, n_2016, n_2017, n_2018, n_2019, n_2020, n_2021,
          n_2022, n_2023, n_2024, n_2025, n_2026, n_2027, n_2028, n_2029,
          n_2030, n_2031, n_2032, a_LC2_C20, a_EQ149, n_2035, n_2036, n_2037,
          n_2038, n_2039, n_2040, n_2041, n_2042, a_LC1_C20, a_EQ142, n_2045,
          n_2046, n_2047, n_2048, n_2049, n_2050, n_2051, n_2052, n_2053,
          n_2054, n_2055, a_N199, a_EQ145, n_2058, n_2059, n_2060, n_2061,
          n_2062, n_2063, n_2064, a_N680_aCLRN, a_EQ211, n_2071, n_2072, n_2073,
          n_2074, n_2075, n_2076, n_2077, n_2078, n_2079, n_2080, n_2081,
          a_N680_aCLK, a_N679_aCLRN, a_EQ210, n_2089, n_2090, n_2091, n_2092,
          n_2093, n_2094, n_2095, n_2096, n_2097, n_2098, n_2099, n_2100,
          n_2101, n_2102, n_2103, n_2104, a_N679_aCLK, a_LC3_C12, a_EQ070,
          n_2108, n_2109, n_2110, a_N431, n_2112, n_2113, n_2114, n_2115,
          n_2116, n_2117, a_N432, n_2119, n_2120, n_2121, n_2122, n_2123,
          a_N44, a_N44_aIN, n_2126, n_2127, n_2128, a_N409, n_2130, a_N410,
          n_2132, a_N411, n_2134, a_N412, n_2136, a_N782, a_N782_aIN, n_2139,
          n_2140, n_2141, n_2142, a_N57, n_2144, a_N56, n_2146, a_N215_aNOT,
          a_EQ153, n_2149, n_2150, n_2151, a_N430, n_2153, n_2154, n_2155,
          n_2156, n_2157, a_N431_aCLRN, a_EQ187, n_2164, n_2165, n_2166, n_2167,
          n_2168, n_2169, n_2170, n_2171, n_2172, n_2173, n_2174, n_2175,
          n_2176, n_2177, n_2178, n_2179, a_N431_aCLK, a_N432_aCLRN, a_EQ188,
          n_2187, n_2188, n_2189, n_2190, n_2191, n_2192, n_2193, n_2194,
          n_2195, n_2196, n_2197, a_N432_aCLK, a_N108, a_N108_aCLRN, a_EQ123,
          n_2206, n_2207, n_2208, n_2209, a_N107, n_2211, n_2212, n_2213,
          n_2214, n_2215, n_2216, n_2217, n_2218, n_2219, a_N108_aCLK, a_N102,
          a_N102_aCLRN, a_EQ117, n_2228, n_2229, n_2230, n_2231, a_N101, n_2233,
          n_2234, n_2235, n_2236, n_2237, n_2238, n_2239, n_2240, n_2241,
          a_N102_aCLK, a_N209_aNOT, a_EQ148, n_2245, n_2246, n_2247, n_2248,
          n_2249, n_2250, n_2251, a_N533_aNOT, n_2253, a_N533_aNOT_aCLRN,
          a_EQ202, n_2260, n_2261, n_2262, n_2263, n_2264, n_2265, n_2266,
          a_N1359, n_2268, n_2269, a_N533_aNOT_aCLK, a_N42, a_N42_aIN, n_2273,
          n_2274, n_2275, n_2276, n_2277, a_SCSOUT_aIN, n_2279, n_2280, n_2281,
          n_2282, n_2283, n_2284, a_N804_aIN, n_2286, n_2287, n_2288, n_2289,
          n_2290, n_2291, a_N21_aIN, n_2293, n_2294, n_2295, n_2296, n_2297,
          n_2298, a_N797_aIN, n_2300, n_2301, n_2302, n_2303, n_2304, n_2305,
          a_EQ291, n_2311, n_2312, n_2313, n_2314, n_2315, n_2316, n_2317,
          n_2318, n_2319, n_2320, a_N1355_aCLK, a_LC1_A10, a_LC1_A10_aIN,
          n_2324, n_2325, n_2326, n_2327, n_2328, n_2329, a_EQ292, n_2335,
          n_2336, n_2337, n_2338, n_2340, n_2341, n_2342, n_2343, n_2344,
          a_N1356_aCLK, a_N1361, a_EQ297, n_2352, n_2353, n_2354, n_2355,
          n_2356, n_2357, n_2358, n_2359, n_2360, a_N1361_aCLK, a_EQ294, n_2367,
          n_2368, n_2369, n_2370, n_2371, n_2372, n_2373, n_2374, n_2375,
          a_N1358_aCLK, a_EQ293, n_2382, n_2383, n_2384, n_2385, n_2386, n_2387,
          n_2388, n_2389, n_2390, n_2391, a_N1357_aCLK, a_EQ295, n_2398, n_2399,
          n_2400, n_2401, n_2402, n_2403, n_2404, n_2405, n_2406, a_N1359_aCLK,
          a_N682_aCLRN, a_EQ213, n_2414, n_2415, n_2416, n_2417, n_2418, n_2419,
          n_2420, n_2421, n_2422, n_2423, a_N682_aCLK, a_N681_aCLRN, a_EQ212,
          n_2431, n_2432, n_2433, n_2434, n_2435, n_2436, n_2437, n_2438,
          n_2439, n_2440, n_2441, n_2442, n_2443, n_2444, n_2445, n_2446,
          a_N681_aCLK, a_N179, a_N179_aIN, n_2450, n_2451, n_2452, n_2453,
          n_2454, a_N430_aCLRN, a_EQ186, n_2461, n_2462, n_2463, n_2464, n_2465,
          n_2466, n_2467, n_2468, n_2469, n_2470, n_2471, n_2472, n_2473,
          n_2474, n_2475, n_2476, a_N430_aCLK, a_N106, a_N106_aCLRN, a_EQ121,
          n_2485, n_2486, n_2487, n_2488, a_N105, n_2490, n_2491, n_2492,
          n_2493, n_2494, n_2495, n_2496, n_2497, n_2498, a_N106_aCLK, a_N103,
          a_N103_aCLRN, a_EQ118, n_2507, n_2508, n_2509, n_2510, n_2511, n_2512,
          n_2513, n_2514, n_2515, n_2516, n_2517, n_2518, n_2519, a_N103_aCLK,
          a_N101_aCLRN, a_EQ116, n_2527, n_2528, n_2529, n_2530, n_2531, n_2532,
          n_2533, n_2534, n_2535, n_2536, n_2537, n_2538, n_2539, a_N101_aCLK,
          a_LC2_A3, a_EQ254, n_2543, n_2544, n_2545, n_2546, a_N1360, n_2548,
          n_2549, n_2550, a_N534_aNOT, n_2552, n_2553, n_2554, n_2555, a_N534_aNOT_aCLRN,
          a_EQ203, n_2562, n_2563, n_2564, n_2565, n_2566, n_2567, n_2568,
          n_2569, n_2570, a_N534_aNOT_aCLK, a_LC2_B4, a_EQ226, n_2574, n_2575,
          n_2576, n_2577, n_2578, n_2579, n_2580, n_2581, n_2582, n_2583,
          n_2584, n_2585, n_2586, n_2587, n_2588, n_2589, n_2590, n_2591,
          n_2592, n_2593, n_2594, n_2595, a_LC2_B21, a_EQ231, n_2598, n_2599,
          n_2600, n_2601, n_2602, n_2603, n_2604, n_2605, n_2606, n_2607,
          n_2608, n_2609, n_2610, n_2611, n_2612, n_2613, n_2614, n_2615,
          n_2616, n_2617, n_2618, n_2619, a_LC5_B16, a_EQ227, n_2622, n_2623,
          n_2624, n_2625, n_2626, n_2627, n_2628, n_2629, n_2630, n_2631,
          n_2632, n_2633, n_2634, n_2635, n_2636, n_2637, n_2638, n_2639,
          n_2640, n_2641, n_2642, n_2643, a_LC4_B16, a_EQ228, n_2646, n_2647,
          n_2648, n_2649, n_2650, n_2651, n_2652, n_2653, n_2654, n_2655,
          n_2656, n_2657, n_2658, n_2659, n_2660, n_2661, n_2662, n_2663,
          n_2664, n_2665, n_2666, n_2667, a_LC3_B16, a_EQ229, n_2670, n_2671,
          n_2672, n_2673, n_2674, n_2675, n_2676, n_2677, n_2678, n_2679,
          n_2680, n_2681, n_2682, n_2683, n_2684, n_2685, n_2686, n_2687,
          n_2688, n_2689, n_2690, n_2691, a_LC8_B16, a_LC8_B16_aIN, n_2694,
          n_2695, n_2696, n_2697, n_2698, n_2699, a_LC6_B21, a_EQ222, n_2702,
          n_2703, n_2704, n_2705, n_2706, n_2707, n_2708, n_2709, n_2710,
          n_2711, n_2712, n_2713, n_2714, n_2715, n_2716, n_2717, n_2718,
          n_2719, n_2720, n_2721, n_2722, n_2723, a_LC5_B21, a_EQ223, n_2726,
          n_2727, n_2728, n_2729, n_2730, n_2731, n_2732, n_2733, n_2734,
          n_2735, n_2736, n_2737, n_2738, n_2739, n_2740, n_2741, n_2742,
          n_2743, n_2744, n_2745, n_2746, n_2747, a_LC4_B21, a_EQ224, n_2750,
          n_2751, n_2752, n_2753, n_2754, n_2755, n_2756, n_2757, n_2758,
          n_2759, n_2760, n_2761, n_2762, n_2763, n_2764, n_2765, n_2766,
          n_2767, n_2768, n_2769, n_2770, n_2771, a_LC3_B21, a_LC3_B21_aIN,
          n_2774, n_2775, n_2776, n_2777, n_2778, n_2779, a_N788_aIN, n_2781,
          n_2782, n_2783, n_2784, n_2785, n_2786, n_2787, a_N1293, a_N1293_aCLRN,
          a_EQ276, n_2795, n_2796, n_2797, n_2798, n_2799, n_2800, n_2801,
          n_2802, n_2803, a_N1293_aCLK, a_N1292, a_N1292_aCLRN, a_EQ275, n_2812,
          n_2813, n_2814, n_2815, n_2816, n_2817, n_2818, n_2819, n_2820,
          n_2821, n_2822, n_2823, n_2824, a_N1292_aCLK, a_N1291, a_N1291_aCLRN,
          a_EQ274, n_2833, n_2834, n_2835, n_2836, n_2837, n_2838, n_2839,
          n_2840, n_2841, n_2842, n_2843, n_2844, n_2845, n_2846, n_2847,
          n_2848, n_2849, a_N1291_aCLK, a_EQ296, n_2856, n_2857, n_2858, n_2859,
          n_2860, n_2861, n_2862, n_2863, n_2864, a_N1360_aCLK, a_N1362, a_EQ298,
          n_2872, n_2873, n_2874, n_2875, n_2876, n_2877, n_2878, n_2879,
          n_2880, a_N1362_aCLK, baud_en_aCLRN, baud_en_aD, n_2888, n_2889,
          n_2890, n_2891, n_2892, n_2893, n_2894, n_2895, baud_en_aCLK, a_LC4_C11,
          a_EQ208, n_2899, n_2900, n_2901, n_2902, n_2903, n_2904, n_2905,
          n_2906, a_LC3_C11, a_EQ209, n_2909, n_2910, n_2911, n_2912, n_2913,
          n_2914, n_2915, n_2916, n_2917, a_N1349_aCLRN, a_N1349_aD, n_2924,
          n_2925, n_2926, n_2927, n_2928, n_2929, a_N1349_aCLK, a_LC6_C9_aNOT,
          a_EQ234, n_2933, n_2934, n_2935, n_2936, n_2937, n_2938, a_EQ064,
          n_2940, n_2941, n_2942, n_2943, n_2944, n_2945, n_2947, n_2948,
          a_N52_aNOT, a_N52_aNOT_aCLRN, a_N52_aNOT_aD, n_2956, n_2957, n_2958,
          n_2959, n_2960, a_N52_aNOT_aCLK, a_N50_aNOT, a_N50_aNOT_aCLRN, a_N50_aNOT_aD,
          n_2969, n_2970, n_2971, n_2972, n_2973, a_N50_aNOT_aCLK, a_N791_aNOT,
          a_EQ233, n_2977, n_2978, n_2979, n_2980, n_2981, a_N54, n_2983,
          n_2984, n_2985, n_2986, n_2987, a_N462_aNOT, a_N462_aNOT_aIN, n_2990,
          n_2991, n_2992, n_2993, n_2994, a_N409_aCLRN, a_EQ179, n_3001, n_3002,
          n_3003, n_3004, n_3005, n_3006, n_3007, n_3008, n_3009, n_3010,
          n_3011, n_3012, n_3013, n_3014, n_3015, n_3016, a_N409_aCLK, a_N410_aCLRN,
          a_EQ180, n_3024, n_3025, n_3026, n_3027, n_3028, n_3029, n_3030,
          n_3031, n_3032, n_3033, n_3034, n_3035, n_3036, n_3037, n_3038,
          n_3039, a_N410_aCLK, a_N411_aCLRN, a_EQ181, n_3047, n_3048, n_3049,
          n_3050, n_3051, n_3052, n_3053, n_3054, n_3055, n_3056, n_3057,
          a_N411_aCLK, a_N412_aCLRN, a_N412_aD, n_3065, n_3066, n_3067, n_3068,
          n_3069, n_3070, a_N412_aCLK, a_N309, a_EQ164, n_3074, n_3075, n_3076,
          n_3077, n_3078, n_3079, n_3080, n_3081, n_3082, n_3083, a_LC3_B15,
          a_EQ326, n_3086, n_3087, n_3088, n_3089, n_3090, n_3091, n_3092,
          n_3093, a_N153_aNOT, a_N153_aNOT_aIN, n_3096, n_3097, n_3098, n_3099,
          n_3100, a_N525, a_EQ197, n_3103, n_3104, n_3105, n_3106, n_3107,
          n_3108, n_3109, n_3110, n_3111, n_3112, a_EQ325, n_3114, n_3115,
          n_3116, n_3117, n_3118, n_3119, n_3120, n_3121, n_3122, a_N806,
          a_N806_aIN, n_3125, n_3126, n_3127, a_N9, n_3129, a_N8, n_3131,
          a_SINTID_DAT_F0_G_aNOT_aCLRN, a_EQ322, n_3138, n_3139, n_3140, n_3141,
          n_3142, n_3143, n_3144, n_3145, n_3146, a_SINTID_DAT_F0_G_aNOT_aCLK,
          a_N105_aCLRN, a_EQ120, n_3154, n_3155, n_3156, n_3157, a_N104, n_3159,
          n_3160, n_3161, n_3162, n_3163, n_3164, n_3165, n_3166, n_3167,
          a_N105_aCLK, a_N35_aIN, n_3170, n_3171, n_3172, n_3173, n_3174,
          n_3175, a_SLCNTL_DOUT_F1_G_aCLRN, a_EQ328, n_3182, n_3183, n_3184,
          n_3185, n_3186, n_3187, n_3188, n_3189, n_3190, n_3191, n_3192,
          n_3193, n_3194, a_SLCNTL_DOUT_F1_G_aCLK, a_N107_aCLRN, a_EQ122,
          n_3202, n_3203, n_3204, n_3205, n_3206, n_3207, n_3208, n_3209,
          n_3210, n_3211, n_3212, n_3213, n_3214, a_N107_aCLK, a_LC2_B15,
          a_EQ244, n_3218, n_3219, n_3220, n_3221, n_3222, n_3223, n_3224,
          a_SINTID_DAT_F2_G_aCLRN, a_EQ324, n_3231, n_3232, n_3233, n_3234,
          n_3235, n_3236, n_3237, n_3238, n_3239, n_3240, n_3241, n_3242,
          n_3243, n_3244, n_3245, a_SINTID_DAT_F2_G_aCLK, a_N32_aIN, n_3248,
          n_3249, n_3250, n_3251, n_3252, n_3253, a_N1317_aCLRN, a_EQ284,
          n_3260, n_3261, n_3262, n_3263, n_3264, n_3265, n_3266, n_3267,
          n_3268, n_3269, n_3270, n_3271, n_3272, a_N1317_aCLK, a_N104_aCLRN,
          a_EQ119, n_3280, n_3281, n_3282, n_3283, n_3284, n_3285, n_3286,
          n_3287, n_3288, n_3289, n_3290, n_3291, n_3292, a_N104_aCLK, a_LC1_A3,
          a_EQ255, n_3296, n_3297, n_3298, n_3299, n_3300, n_3301, n_3302,
          a_N535_aNOT, n_3304, n_3305, n_3306, n_3307, a_N535_aNOT_aCLRN,
          a_EQ204, n_3314, n_3315, n_3316, n_3317, n_3318, n_3319, n_3320,
          n_3321, n_3322, a_N535_aNOT_aCLK, a_N9_aCLRN, a_N9_aD, n_3330, n_3331,
          n_3332, n_3333, n_3334, a_N9_aCLK, a_N31_aIN, n_3337, n_3338, n_3339,
          n_3340, n_3341, n_3342, a_N8_aCLRN, a_EQ057, n_3349, n_3350, n_3351,
          n_3352, n_3353, n_3354, n_3355, n_3356, n_3357, n_3358, n_3359,
          a_N8_aCLK, a_N1369_aCLRN, a_EQ299, n_3367, n_3368, n_3369, n_3370,
          n_3371, n_3372, n_3373, n_3374, n_3375, n_3376, n_3377, n_3378,
          n_3379, a_N1369_aCLK, a_N435, a_N435_aIN, n_3383, n_3384, n_3385,
          n_3386, n_3387, n_3388, n_3389, a_N57_aCLRN, a_EQ102, n_3396, n_3397,
          n_3398, n_3399, n_3400, n_3401, n_3402, n_3403, n_3404, n_3405,
          a_N57_aCLK, a_LC7_C12, a_EQ185, n_3409, n_3410, n_3411, n_3412,
          n_3413, n_3414, n_3415, n_3416, a_N56_aCLRN, a_EQ101, n_3423, n_3424,
          n_3425, n_3426, n_3427, n_3428, n_3429, n_3430, n_3431, n_3432,
          n_3433, n_3434, n_3435, n_3436, a_N56_aCLK, a_LC7_C9, a_EQ184, n_3440,
          n_3441, n_3442, n_3443, n_3444, n_3445, n_3446, n_3447, n_3448,
          n_3449, a_N54_aCLRN, a_EQ096, n_3456, n_3457, n_3458, n_3459, n_3460,
          n_3461, n_3462, n_3463, n_3464, a_N54_aCLK, a_SLCNTL_DOUT_F3_G_aCLRN,
          a_EQ330, n_3472, n_3473, n_3474, n_3475, n_3476, n_3477, n_3478,
          n_3479, n_3480, n_3481, n_3482, n_3483, n_3484, a_SLCNTL_DOUT_F3_G_aCLK,
          a_N418_aNOT, a_N418_aNOT_aIN, n_3488, n_3489, n_3490, n_3491, n_3492,
          n_3493, a_N346_aCLRN, a_EQ166, n_3500, n_3501, n_3502, n_3503, n_3504,
          n_3505, n_3506, n_3507, n_3508, n_3509, n_3510, n_3511, n_3512,
          n_3513, n_3514, a_N346_aCLK, a_N407, a_EQ178, n_3518, n_3519, n_3520,
          n_3521, n_3522, n_3523, a_N347_aCLRN, a_EQ167, n_3530, n_3531, n_3532,
          n_3533, n_3534, n_3535, n_3536, n_3537, n_3538, n_3539, n_3540,
          n_3541, n_3542, n_3543, n_3544, a_N347_aCLK, a_N348_aCLRN, a_EQ168,
          n_3552, n_3553, n_3554, n_3555, n_3556, n_3557, n_3558, n_3559,
          n_3560, n_3561, n_3562, n_3563, n_3564, n_3565, n_3566, a_N348_aCLK,
          a_LC1_B16, a_LC1_B16_aIN, n_3570, n_3571, n_3572, n_3573, n_3574,
          n_3575, n_3576, a_LC6_B16, a_LC6_B16_aIN, n_3579, n_3580, n_3581,
          n_3582, n_3583, a_LC5_B11, a_LC5_B11_aIN, n_3586, n_3587, n_3588,
          n_3589, n_3590, n_3591, a_LC1_B11, a_LC1_B11_aIN, n_3594, n_3595,
          n_3596, n_3597, n_3598, n_3599, n_3600, a_LC3_B4, a_LC3_B4_aIN,
          n_3603, n_3604, n_3605, n_3606, n_3607, n_3608, a_EQ238, n_3610,
          n_3611, n_3612, n_3613, n_3614, n_3615, n_3616, n_3617, a_EQ076,
          n_3619, n_3620, n_3621, n_3622, n_3623, n_3624, n_3625, n_3626,
          a_EQ236, n_3628, n_3629, n_3630, n_3631, n_3632, n_3633, a_N794_aNOT,
          a_EQ237, n_3636, n_3637, n_3638, n_3639, n_3640, n_3641, a_LC3_B18,
          a_LC3_B18_aIN, n_3644, n_3645, n_3646, n_3647, n_3648, n_3649, a_N1277_aCLRN,
          a_EQ261, n_3656, n_3657, n_3658, n_3659, n_3660, n_3661, n_3662,
          n_3663, n_3664, n_3665, n_3666, a_N1277_aCLK, a_N1285_aCLRN, a_EQ269,
          n_3674, n_3675, n_3676, n_3677, n_3678, n_3679, n_3680, n_3681,
          n_3682, n_3683, n_3684, a_N1285_aCLK, a_SDLSB_DAT_F6_G_aCLRN, a_EQ308,
          n_3692, n_3693, n_3694, n_3695, n_3696, n_3697, n_3698, n_3699,
          n_3700, a_SDLSB_DAT_F6_G_aCLK, a_N1282_aCLRN, a_EQ266, n_3708, n_3709,
          n_3710, n_3711, n_3712, n_3713, n_3714, n_3715, n_3716, n_3717,
          n_3718, a_N1282_aCLK, a_N1283_aCLRN, a_EQ267, n_3726, n_3727, n_3728,
          n_3729, n_3730, n_3731, n_3732, n_3733, n_3734, n_3735, n_3736,
          n_3737, n_3738, n_3739, n_3740, n_3741, a_N1283_aCLK, a_N1284_aCLRN,
          a_EQ268, n_3749, n_3750, n_3751, n_3752, n_3753, n_3754, n_3755,
          n_3756, n_3757, n_3758, n_3759, a_N1284_aCLK, a_N1279_aCLRN, a_EQ263,
          n_3767, n_3768, n_3769, n_3770, n_3771, n_3772, n_3773, n_3774,
          n_3775, n_3776, n_3777, a_N1279_aCLK, a_LC6_B11, a_LC6_B11_aIN,
          n_3781, n_3782, n_3783, n_3784, n_3785, a_N1280_aCLRN, a_EQ264,
          n_3792, n_3793, n_3794, n_3795, n_3796, n_3797, n_3798, n_3799,
          n_3800, n_3801, n_3802, n_3803, n_3804, n_3805, n_3806, n_3807,
          a_N1280_aCLK, a_N1278_aCLRN, a_EQ262, n_3815, n_3816, n_3817, n_3818,
          n_3819, n_3820, n_3821, n_3822, n_3823, n_3824, n_3825, n_3826,
          n_3827, n_3828, n_3829, n_3830, a_N1278_aCLK, a_LC2_B6, a_LC2_B6_aIN,
          n_3834, n_3835, n_3836, n_3837, n_3838, a_N1286_aCLRN, a_EQ270,
          n_3845, n_3846, n_3847, n_3848, n_3849, n_3850, n_3851, n_3852,
          n_3853, n_3854, n_3855, n_3856, n_3857, n_3858, n_3859, n_3860,
          a_N1286_aCLK, a_N1281_aCLRN, a_EQ265, n_3868, n_3869, n_3870, n_3871,
          n_3872, n_3873, n_3874, n_3875, n_3876, n_3877, n_3878, n_3879,
          n_3880, n_3881, n_3882, n_3883, a_N1281_aCLK, a_N1276_aCLRN, a_EQ260,
          n_3891, n_3892, n_3893, n_3894, n_3895, n_3896, n_3897, n_3898,
          n_3899, n_3900, n_3901, n_3902, n_3903, n_3904, n_3905, n_3906,
          a_N1276_aCLK, a_N1287_aCLRN, a_EQ271, n_3914, n_3915, n_3916, n_3917,
          n_3918, n_3919, n_3920, n_3921, n_3922, n_3923, n_3924, n_3925,
          n_3926, n_3927, n_3928, n_3929, a_N1287_aCLK, a_N1320_aCLRN, a_EQ287,
          n_3937, n_3938, n_3939, n_3940, n_3941, n_3942, n_3943, n_3944,
          n_3945, n_3946, n_3947, n_3948, n_3949, a_N1320_aCLK, a_N1319_aCLRN,
          a_EQ286, n_3957, n_3958, n_3959, n_3960, n_3961, n_3962, n_3963,
          n_3964, n_3965, n_3966, n_3967, n_3968, n_3969, a_N1319_aCLK, a_N152_aNOT,
          a_EQ125, n_3973, n_3974, n_3975, n_3976, n_3977, n_3978, n_3979,
          n_3980, n_3981, n_3982, a_SINTID_DAT_F1_G_aCLRN, a_EQ323, n_3989,
          n_3990, n_3991, n_3992, n_3993, n_3994, n_3995, n_3996, n_3997,
          n_3998, n_3999, n_4000, n_4001, n_4002, n_4003, a_SINTID_DAT_F1_G_aCLK,
          a_N1318_aCLRN, a_EQ285, n_4011, n_4012, n_4013, n_4014, n_4015,
          n_4016, n_4017, n_4018, n_4019, n_4020, n_4021, n_4022, n_4023,
          a_N1318_aCLK, a_N319, a_N319_aIN, n_4027, n_4028, n_4029, n_4030,
          n_4031, a_N393, a_EQ175, n_4034, n_4035, n_4036, n_4037, n_4038,
          n_4039, n_4040, n_4041, n_4042, n_4043, a_LC2_A12, a_EQ092, n_4046,
          n_4047, n_4048, n_4049, n_4050, n_4051, n_4052, n_4053, a_N375,
          a_N375_aIN, n_4056, n_4057, n_4058, n_4059, n_4060, n_4061, a_LC4_A12,
          a_EQ093, n_4064, n_4065, n_4066, n_4067, n_4068, n_4069, n_4070,
          a_N390, a_EQ173, n_4073, n_4074, n_4075, n_4076, n_4077, n_4078,
          n_4079, n_4080, n_4081, a_LC1_A12, a_EQ094, n_4084, n_4085, n_4086,
          n_4087, n_4088, n_4089, n_4090, a_N394, a_EQ176, n_4093, n_4094,
          n_4095, n_4096, n_4097, n_4098, n_4099, n_4100, n_4101, n_4102,
          a_EQ095, n_4104, n_4105, n_4106, n_4107, n_4108, n_4109, n_4110,
          a_EQ235, n_4112, n_4113, n_4114, n_4115, n_4116, n_4117, n_4118,
          n_4119, n_4120, n_4121, a_EQ357, n_4127, n_4128, n_4129, n_4130,
          n_4131, n_4132, n_4133, n_4134, n_4135, a_SREC_DAT_F4_G_aCLK, a_SDLSB_DAT_F4_G_aCLRN,
          a_EQ306, n_4143, n_4144, n_4145, n_4146, n_4147, n_4148, n_4149,
          n_4150, n_4151, a_SDLSB_DAT_F4_G_aCLK, a_N1316_aCLRN, a_EQ283, n_4159,
          n_4160, n_4161, n_4162, n_4163, n_4164, n_4165, n_4166, n_4167,
          n_4168, n_4169, n_4170, n_4171, a_N1316_aCLK, a_N392, a_N392_aIN,
          n_4175, n_4176, n_4177, n_4178, n_4179, a_LC6_A15, a_EQ089, n_4182,
          n_4183, n_4184, n_4185, n_4186, n_4187, n_4188, n_4189, a_LC5_A15,
          a_EQ090, n_4192, n_4193, n_4194, n_4195, n_4196, n_4197, n_4198,
          n_4199, a_EQ091, n_4201, n_4202, n_4203, n_4204, n_4205, n_4206,
          n_4207, a_EQ358, n_4213, n_4214, n_4215, n_4216, n_4217, n_4218,
          n_4219, n_4220, n_4221, a_SREC_DAT_F5_G_aCLK, a_SDLSB_DAT_F5_G_aCLRN,
          a_EQ307, n_4229, n_4230, n_4231, n_4232, n_4233, n_4234, n_4235,
          n_4236, n_4237, a_SDLSB_DAT_F5_G_aCLK, a_N40, a_N40_aIN, n_4241,
          n_4242, n_4243, n_4244, n_4245, a_LC7_A15, a_EQ087, n_4248, n_4249,
          n_4250, n_4251, n_4252, n_4253, n_4254, n_4255, a_EQ088, n_4257,
          n_4258, n_4259, n_4260, n_4261, n_4262, n_4263, a_EQ359, n_4269,
          n_4270, n_4271, n_4272, n_4273, n_4274, n_4275, n_4276, n_4277,
          a_SREC_DAT_F6_G_aCLK, a_N1314_aCLRN, a_EQ281, n_4285, n_4286, n_4287,
          n_4288, n_4289, n_4290, n_4291, n_4292, n_4293, n_4294, n_4295,
          n_4296, n_4297, a_N1314_aCLK, a_EQ086, n_4300, n_4301, n_4302, n_4303,
          n_4304, n_4305, n_4306, n_4307, n_4308, a_EQ360, n_4314, n_4315,
          n_4316, n_4317, n_4318, n_4319, n_4320, n_4321, n_4322, a_SREC_DAT_F7_G_aCLK,
          a_SDLSB_DAT_F7_G_aCLRN, a_EQ309, n_4330, n_4331, n_4332, n_4333,
          n_4334, n_4335, n_4336, n_4337, n_4338, a_SDLSB_DAT_F7_G_aCLK, a_N208,
          a_EQ147, n_4342, n_4343, n_4344, n_4345, n_4346, n_4347, n_4348,
          n_4349, n_4350, n_4351, a_LC6_C19, a_EQ150, n_4354, n_4355, n_4356,
          n_4357, n_4358, n_4359, n_4360, n_4361, n_4362, n_4363, n_4364,
          a_LC4_C19, a_LC4_C19_aIN, n_4367, n_4368, n_4369, n_4370, n_4371,
          n_4372, a_N203_aNOT, a_EQ146, n_4375, n_4376, n_4377, n_4378, n_4379,
          n_4380, n_4381, n_4382, a_N702_aCLRN, a_EQ214, n_4389, n_4390, n_4391,
          n_4392, n_4393, n_4394, n_4395, n_4396, n_4397, n_4398, a_N702_aCLK,
          a_LC4_A3, a_EQ256, n_4402, n_4403, n_4404, n_4405, n_4406, n_4407,
          n_4408, n_4409, n_4410, n_4411, n_4412, a_N1354_aNOT_aCLRN, a_EQ290,
          n_4419, n_4420, n_4421, n_4422, n_4423, n_4424, n_4425, n_4426,
          n_4427, a_N1354_aNOT_aCLK, a_N30_aIN, n_4430, n_4431, n_4432, n_4433,
          n_4434, n_4435, a_N810, a_N810_aCLRN, a_EQ245, n_4443, n_4444, n_4445,
          n_4446, n_4447, n_4448, n_4449, n_4450, n_4451, n_4452, n_4453,
          a_N810_aCLK, a_N816, a_N816_aCLRN, a_N816_aD, n_4462, n_4463, n_4464,
          n_4465, n_4466, a_N816_aCLK, a_N786_aNOT, a_EQ221, n_4470, n_4471,
          n_4472, n_4473, n_4474, n_4475, a_N815, a_N815_aCLRN, a_N815_aD,
          n_4483, n_4484, n_4485, n_4486, n_4487, n_4488, n_4489, n_4490,
          n_4491, a_N815_aCLK, a_N820, a_N820_aCLRN, a_N820_aD, n_4500, n_4501,
          n_4502, n_4503, n_4504, a_N820_aCLK, a_SMSTAT_DAT_F3_G_aCLRN, a_EQ348,
          n_4512, n_4513, n_4514, n_4515, n_4516, n_4517, n_4518, n_4519,
          n_4520, n_4521, n_4522, n_4523, n_4524, n_4525, a_SMSTAT_DAT_F3_G_aCLK,
          a_N814, a_N814_aCLRN, a_N814_aD, n_4534, n_4535, n_4536, n_4537,
          n_4538, n_4539, n_4540, n_4541, n_4542, a_N814_aCLK, a_N819, a_N819_aCLRN,
          a_N819_aD, n_4551, n_4552, n_4553, n_4554, n_4555, a_N819_aCLK,
          a_SMSTAT_DAT_F2_G_aCLRN, a_EQ347, n_4563, n_4564, n_4565, n_4566,
          n_4567, n_4568, n_4569, n_4570, n_4571, n_4572, a_SMSTAT_DAT_F2_G_aCLK,
          a_N812, a_N812_aCLRN, a_N812_aD, n_4581, n_4582, n_4583, n_4584,
          n_4585, n_4586, n_4587, n_4588, n_4589, a_N812_aCLK, a_N817, a_N817_aCLRN,
          a_N817_aD, n_4598, n_4599, n_4600, n_4601, n_4602, a_N817_aCLK,
          a_SMSTAT_DAT_F0_G_aCLRN, a_EQ345, n_4610, n_4611, n_4612, n_4613,
          n_4614, n_4615, n_4616, n_4617, n_4618, n_4619, n_4620, n_4621,
          n_4622, n_4623, a_SMSTAT_DAT_F0_G_aCLK, a_N349_aCLRN, a_EQ169, n_4631,
          n_4632, n_4633, n_4634, n_4635, n_4636, n_4637, n_4638, n_4639,
          n_4640, a_N349_aCLK, a_SLSTAT_DAT_F5_G_aNOT_aCLRN, a_EQ340, n_4648,
          n_4649, n_4650, n_4651, n_4652, n_4653, n_4654, n_4655, n_4656,
          a_SLSTAT_DAT_F5_G_aNOT_aCLK, a_LC7_C5, a_EQ138, n_4660, n_4661,
          n_4662, n_4663, n_4664, n_4665, n_4666, n_4667, a_LC8_C5, a_EQ137,
          n_4670, n_4671, n_4672, n_4673, n_4674, n_4675, n_4676, n_4677,
          n_4678, n_4679, a_LC6_C5, a_EQ139, n_4682, n_4683, n_4684, n_4685,
          n_4686, n_4687, n_4688, n_4689, a_LC5_C5, a_EQ140, n_4692, n_4693,
          n_4694, n_4695, n_4696, n_4697, n_4698, n_4699, n_4700, a_N187_aNOT,
          a_N187_aNOT_aIN, n_4703, n_4704, n_4705, n_4706, n_4707, n_4708,
          a_N705_aCLRN, a_EQ216, n_4715, n_4716, n_4717, n_4718, n_4719, n_4720,
          n_4721, n_4722, n_4723, n_4724, a_N705_aCLK, a_LC3_C19, a_EQ154,
          n_4728, n_4729, n_4730, n_4731, n_4732, n_4733, n_4734, n_4735,
          n_4736, n_4737, n_4738, a_N38, a_N38_aIN, n_4741, n_4742, n_4743,
          n_4744, n_4745, n_4746, a_N704_aCLRN, a_EQ215, n_4753, n_4754, n_4755,
          n_4756, n_4757, n_4758, n_4759, n_4760, n_4761, a_N704_aCLK, a_LC4_B4,
          a_LC4_B4_aIN, n_4765, n_4766, n_4767, n_4768, n_4769, n_4770, a_N1274_aCLRN,
          a_EQ258, n_4777, n_4778, n_4779, n_4780, n_4781, n_4782, n_4783,
          n_4784, n_4785, n_4786, n_4787, n_4788, n_4789, n_4790, n_4791,
          n_4792, a_N1274_aCLK, a_N1275_aCLRN, a_EQ259, n_4800, n_4801, n_4802,
          n_4803, n_4804, n_4805, n_4806, n_4807, n_4808, n_4809, n_4810,
          a_N1275_aCLK, a_SDMSB_DAT_F6_G_aCLRN, a_EQ316, n_4818, n_4819, n_4820,
          n_4821, n_4822, n_4823, n_4824, n_4825, n_4826, a_SDMSB_DAT_F6_G_aCLK,
          a_N1288_aCLRN, a_EQ272, n_4834, n_4835, n_4836, n_4837, n_4838,
          n_4839, n_4840, n_4841, n_4842, n_4843, n_4844, a_N1288_aCLK, a_N1289_aNOT_aCLRN,
          a_N1289_aNOT_aD, n_4852, n_4853, n_4854, n_4855, n_4856, n_4857,
          n_4858, n_4859, a_N1289_aNOT_aCLK, a_SLCNTL_DOUT_F0_G_aCLRN, a_EQ327,
          n_4867, n_4868, n_4869, n_4870, n_4871, n_4872, n_4873, n_4874,
          n_4875, n_4876, n_4877, n_4878, n_4879, a_SLCNTL_DOUT_F0_G_aCLK,
          a_LC4_A2, a_EQ111, n_4883, n_4884, n_4885, n_4886, n_4887, n_4888,
          n_4889, n_4890, a_LC3_A2, a_EQ112, n_4893, n_4894, n_4895, n_4896,
          n_4897, n_4898, n_4899, n_4900, a_LC1_A2, a_EQ113, n_4903, n_4904,
          n_4905, n_4906, n_4907, n_4908, n_4909, a_EQ114, n_4911, n_4912,
          n_4913, n_4914, n_4915, n_4916, n_4917, a_EQ353, n_4923, n_4924,
          n_4925, n_4926, n_4927, n_4928, n_4929, n_4930, n_4931, a_SREC_DAT_F0_G_aCLK,
          a_SDMSB_DAT_F0_G_aCLRN, a_EQ310, n_4939, n_4940, n_4941, n_4942,
          n_4943, n_4944, n_4945, n_4946, n_4947, n_4948, n_4949, n_4950,
          n_4951, a_SDMSB_DAT_F0_G_aCLK, a_N813, a_N813_aCLRN, a_N813_aD,
          n_4960, n_4961, n_4962, n_4963, n_4964, n_4965, n_4966, n_4967,
          n_4968, a_N813_aCLK, a_N818, a_N818_aCLRN, a_N818_aD, n_4977, n_4978,
          n_4979, n_4980, n_4981, a_N818_aCLK, a_SMSTAT_DAT_F1_G_aCLRN, a_EQ346,
          n_4989, n_4990, n_4991, n_4992, n_4993, n_4994, n_4995, n_4996,
          n_4997, n_4998, n_4999, n_5000, n_5001, n_5002, a_SMSTAT_DAT_F1_G_aCLK,
          a_LC7_A7, a_EQ107, n_5006, n_5007, n_5008, n_5009, n_5010, n_5011,
          n_5012, n_5013, a_LC6_A7, a_EQ108, n_5016, n_5017, n_5018, n_5019,
          n_5020, n_5021, n_5022, a_LC5_A7, a_EQ109, n_5025, n_5026, n_5027,
          n_5028, n_5029, n_5030, n_5031, a_EQ110, n_5033, n_5034, n_5035,
          n_5036, n_5037, n_5038, n_5039, a_EQ354, n_5045, n_5046, n_5047,
          n_5048, n_5049, n_5050, n_5051, n_5052, n_5053, a_SREC_DAT_F1_G_aCLK,
          a_SDMSB_DAT_F1_G_aCLRN, a_EQ311, n_5061, n_5062, n_5063, n_5064,
          n_5065, n_5066, n_5067, n_5068, n_5069, a_SDMSB_DAT_F1_G_aCLK, a_SLCNTL_DOUT_F2_G_aCLRN,
          a_EQ329, n_5077, n_5078, n_5079, n_5080, n_5081, n_5082, n_5083,
          n_5084, n_5085, n_5086, n_5087, n_5088, n_5089, a_SLCNTL_DOUT_F2_G_aCLK,
          a_LC4_A7, a_EQ103, n_5093, n_5094, n_5095, n_5096, n_5097, n_5098,
          n_5099, n_5100, a_LC3_A7, a_EQ104, n_5103, n_5104, n_5105, n_5106,
          n_5107, n_5108, n_5109, a_LC2_A7, a_EQ105, n_5112, n_5113, n_5114,
          n_5115, n_5116, n_5117, n_5118, a_EQ106, n_5120, n_5121, n_5122,
          n_5123, n_5124, n_5125, n_5126, a_EQ355, n_5132, n_5133, n_5134,
          n_5135, n_5136, n_5137, n_5138, n_5139, n_5140, a_SREC_DAT_F2_G_aCLK,
          a_SDMSB_DAT_F2_G_aCLRN, a_EQ312, n_5148, n_5149, n_5150, n_5151,
          n_5152, n_5153, n_5154, n_5155, n_5156, a_SDMSB_DAT_F2_G_aCLK, a_LC8_A20,
          a_EQ097, n_5160, n_5161, n_5162, n_5163, n_5164, n_5165, n_5166,
          n_5167, a_LC2_A13, a_EQ098, n_5170, n_5171, n_5172, n_5173, n_5174,
          n_5175, n_5176, a_LC1_A13, a_EQ099, n_5179, n_5180, n_5181, n_5182,
          n_5183, n_5184, n_5185, a_EQ100, n_5187, n_5188, n_5189, n_5190,
          n_5191, n_5192, n_5193, a_EQ356, n_5199, n_5200, n_5201, n_5202,
          n_5203, n_5204, n_5205, n_5206, n_5207, a_SREC_DAT_F3_G_aCLK, a_SDMSB_DAT_F3_G_aCLRN,
          a_EQ313, n_5215, n_5216, n_5217, n_5218, n_5219, n_5220, n_5221,
          n_5222, n_5223, n_5224, n_5225, n_5226, n_5227, a_SDMSB_DAT_F3_G_aCLK,
          a_SDMSB_DAT_F4_G_aCLRN, a_EQ314, n_5235, n_5236, n_5237, n_5238,
          n_5239, n_5240, n_5241, n_5242, n_5243, n_5244, n_5245, n_5246,
          n_5247, a_SDMSB_DAT_F4_G_aCLK, a_SDMSB_DAT_F5_G_aCLRN, a_EQ315,
          n_5255, n_5256, n_5257, n_5258, n_5259, n_5260, n_5261, n_5262,
          n_5263, n_5264, n_5265, n_5266, n_5267, a_SDMSB_DAT_F5_G_aCLK, a_N1315_aCLRN,
          a_EQ282, n_5275, n_5276, n_5277, n_5278, n_5279, n_5280, n_5281,
          n_5282, n_5283, n_5284, n_5285, n_5286, n_5287, a_N1315_aCLK, a_SLCNTL_DOUT_F7_G_aCLRN,
          a_EQ334, n_5295, n_5296, n_5297, n_5298, n_5299, n_5300, n_5301,
          n_5302, n_5303, n_5304, n_5305, n_5306, n_5307, a_SLCNTL_DOUT_F7_G_aCLK,
          a_SDMSB_DAT_F7_G_aCLRN, a_EQ317, n_5315, n_5316, n_5317, n_5318,
          n_5319, n_5320, n_5321, n_5322, n_5323, n_5324, n_5325, n_5326,
          n_5327, a_SDMSB_DAT_F7_G_aCLK, a_LC5_A14, a_EQ161, n_5331, n_5332,
          n_5333, n_5334, n_5335, n_5336, n_5337, n_5338, n_5339, n_5340,
          n_5341, n_5342, n_5343, n_5344, n_5345, n_5346, n_5347, n_5348,
          a_LC7_A1, a_EQ162, n_5351, n_5352, n_5353, n_5354, n_5355, n_5356,
          n_5357, n_5358, n_5359, n_5360, n_5361, n_5362, n_5363, n_5364,
          n_5365, n_5366, n_5367, n_5368, a_N296, a_EQ163, n_5371, n_5372,
          n_5373, n_5374, n_5375, n_5376, n_5377, n_5378, n_5379, n_5380,
          n_5381, n_5382, n_5383, n_5384, n_5385, n_5386, n_5387, n_5388,
          n_5389, n_5390, n_5391, n_5392, n_5393, n_5394, n_5395, n_5396,
          n_5397, n_5398, n_5399, n_5400, n_5401, n_5402, n_5403, n_5404,
          n_5405, n_5406, n_5407, n_5408, n_5409, n_5410, n_5411, n_5412,
          a_LC4_A4, a_EQ160, n_5415, n_5416, n_5417, n_5418, n_5419, n_5420,
          n_5421, n_5422, n_5423, a_LC1_A4, a_LC1_A4_aIN, n_5426, n_5427,
          n_5428, n_5429, n_5430, a_N1353_aCLRN, a_EQ289, n_5437, n_5438,
          n_5439, n_5440, n_5441, n_5442, n_5443, n_5444, n_5445, n_5446,
          n_5447, n_5448, a_N1353_aCLK, a_SLCNTL_DOUT_F6_G_aCLRN, a_EQ333,
          n_5456, n_5457, n_5458, n_5459, n_5460, n_5461, n_5462, n_5463,
          n_5464, n_5465, n_5466, n_5467, n_5468, a_SLCNTL_DOUT_F6_G_aCLK,
          a_EQ239, n_5471, n_5472, n_5473, n_5474, n_5475, n_5476, n_5477,
          n_5478, a_SINTEN_DAT_F3_G_aCLRN, a_EQ321, n_5485, n_5486, n_5487,
          n_5488, n_5489, n_5490, n_5491, n_5492, n_5493, a_SINTEN_DAT_F3_G_aCLK,
          a_SINTEN_DAT_F1_G_aCLRN, a_EQ319, n_5501, n_5502, n_5503, n_5504,
          n_5505, n_5506, n_5507, n_5508, n_5509, a_SINTEN_DAT_F1_G_aCLK,
          a_EQ124, n_5512, n_5513, n_5514, n_5515, n_5516, n_5517, n_5518,
          n_5519, a_N5_aCLRN, a_N5_aD, n_5526, n_5527, n_5528, n_5529, n_5530,
          a_N5_aCLK : std_logic;

COMPONENT TRIBUF_a16450
    PORT (in1, oe  : IN std_logic; y : OUT std_logic);
END COMPONENT;

COMPONENT DFF_a16450
    PORT (d, clk, clrn, prn : IN std_logic; q : OUT std_logic);
END COMPONENT;

COMPONENT FILTER_a16450
    PORT (in1 : IN std_logic; y : OUT std_logic);
END COMPONENT;

BEGIN

PROCESS(A(0), A(1), A(2), CLK, CS0, CS1, DIN(0), DIN(1), DIN(2), DIN(3), DIN(4),
          DIN(5), DIN(6), DIN(7), MR, nADS, nCS2, nCTS, nDCD, nDSR, nRD, nRI,
          nWR, RCLK, RD, SIN, WR)
BEGIN
    ASSERT A(0) /= 'X' OR Now = 0 ns
        REPORT "Unknown value on A(0)"
        SEVERITY Warning;
    ASSERT A(1) /= 'X' OR Now = 0 ns
        REPORT "Unknown value on A(1)"
        SEVERITY Warning;
    ASSERT A(2) /= 'X' OR Now = 0 ns
        REPORT "Unknown value on A(2)"
        SEVERITY Warning;
    ASSERT CLK /= 'X' OR Now = 0 ns
        REPORT "Unknown value on CLK"
        SEVERITY Warning;
    ASSERT CS0 /= 'X' OR Now = 0 ns
        REPORT "Unknown value on CS0"
        SEVERITY Warning;
    ASSERT CS1 /= 'X' OR Now = 0 ns
        REPORT "Unknown value on CS1"
        SEVERITY Warning;
    ASSERT DIN(0) /= 'X' OR Now = 0 ns
        REPORT "Unknown value on DIN(0)"
        SEVERITY Warning;
    ASSERT DIN(1) /= 'X' OR Now = 0 ns
        REPORT "Unknown value on DIN(1)"
        SEVERITY Warning;
    ASSERT DIN(2) /= 'X' OR Now = 0 ns
        REPORT "Unknown value on DIN(2)"
        SEVERITY Warning;
    ASSERT DIN(3) /= 'X' OR Now = 0 ns
        REPORT "Unknown value on DIN(3)"
        SEVERITY Warning;
    ASSERT DIN(4) /= 'X' OR Now = 0 ns
        REPORT "Unknown value on DIN(4)"
        SEVERITY Warning;
    ASSERT DIN(5) /= 'X' OR Now = 0 ns
        REPORT "Unknown value on DIN(5)"
        SEVERITY Warning;
    ASSERT DIN(6) /= 'X' OR Now = 0 ns
        REPORT "Unknown value on DIN(6)"
        SEVERITY Warning;
    ASSERT DIN(7) /= 'X' OR Now = 0 ns
        REPORT "Unknown value on DIN(7)"
        SEVERITY Warning;
    ASSERT MR /= 'X' OR Now = 0 ns
        REPORT "Unknown value on MR"
        SEVERITY Warning;
    ASSERT nADS /= 'X' OR Now = 0 ns
        REPORT "Unknown value on nADS"
        SEVERITY Warning;
    ASSERT nCS2 /= 'X' OR Now = 0 ns
        REPORT "Unknown value on nCS2"
        SEVERITY Warning;
    ASSERT nCTS /= 'X' OR Now = 0 ns
        REPORT "Unknown value on nCTS"
        SEVERITY Warning;
    ASSERT nDCD /= 'X' OR Now = 0 ns
        REPORT "Unknown value on nDCD"
        SEVERITY Warning;
    ASSERT nDSR /= 'X' OR Now = 0 ns
        REPORT "Unknown value on nDSR"
        SEVERITY Warning;
    ASSERT nRD /= 'X' OR Now = 0 ns
        REPORT "Unknown value on nRD"
        SEVERITY Warning;
    ASSERT nRI /= 'X' OR Now = 0 ns
        REPORT "Unknown value on nRI"
        SEVERITY Warning;
    ASSERT nWR /= 'X' OR Now = 0 ns
        REPORT "Unknown value on nWR"
        SEVERITY Warning;
    ASSERT RCLK /= 'X' OR Now = 0 ns
        REPORT "Unknown value on RCLK"
        SEVERITY Warning;
    ASSERT RD /= 'X' OR Now = 0 ns
        REPORT "Unknown value on RD"
        SEVERITY Warning;
    ASSERT SIN /= 'X' OR Now = 0 ns
        REPORT "Unknown value on SIN"
        SEVERITY Warning;
    ASSERT WR /= 'X' OR Now = 0 ns
        REPORT "Unknown value on WR"
        SEVERITY Warning;
END PROCESS;

tribuf_2: TRIBUF_a16450

    PORT MAP (IN1 => n_88, OE => vcc, Y => DOUT(0));
tribuf_4: TRIBUF_a16450

    PORT MAP (IN1 => n_95, OE => vcc, Y => DOUT(1));
tribuf_6: TRIBUF_a16450

    PORT MAP (IN1 => n_102, OE => vcc, Y => DOUT(2));
tribuf_8: TRIBUF_a16450

    PORT MAP (IN1 => n_109, OE => vcc, Y => DOUT(3));
tribuf_10: TRIBUF_a16450

    PORT MAP (IN1 => n_116, OE => vcc, Y => DOUT(4));
tribuf_12: TRIBUF_a16450

    PORT MAP (IN1 => n_123, OE => vcc, Y => DOUT(5));
tribuf_14: TRIBUF_a16450

    PORT MAP (IN1 => n_130, OE => vcc, Y => DOUT(6));
tribuf_16: TRIBUF_a16450

    PORT MAP (IN1 => n_137, OE => vcc, Y => DOUT(7));
tribuf_18: TRIBUF_a16450

    PORT MAP (IN1 => n_144, OE => vcc, Y => SOUT);
tribuf_20: TRIBUF_a16450

    PORT MAP (IN1 => n_151, OE => vcc, Y => nRTS);
tribuf_22: TRIBUF_a16450

    PORT MAP (IN1 => n_158, OE => vcc, Y => nOUT2);
tribuf_24: TRIBUF_a16450

    PORT MAP (IN1 => n_165, OE => vcc, Y => nOUT1);
tribuf_26: TRIBUF_a16450

    PORT MAP (IN1 => n_172, OE => vcc, Y => INTR);
tribuf_28: TRIBUF_a16450

    PORT MAP (IN1 => n_179, OE => vcc, Y => nDTR);
tribuf_30: TRIBUF_a16450

    PORT MAP (IN1 => n_186, OE => vcc, Y => DDIS);
tribuf_32: TRIBUF_a16450

    PORT MAP (IN1 => n_193, OE => vcc, Y => CSOUT);
tribuf_34: TRIBUF_a16450

    PORT MAP (IN1 => n_200, OE => vcc, Y => nBAUDOUT);
delay_35: n_88  <= TRANSPORT n_89;
xor2_36: n_89 <=  n_90  XOR n_94;
or1_37: n_90 <=  n_91;
and1_38: n_91 <=  n_92;
delay_39: n_92  <= TRANSPORT a_G161  ;
and1_40: n_94 <=  gnd;
delay_41: n_95  <= TRANSPORT n_96;
xor2_42: n_96 <=  n_97  XOR n_101;
or1_43: n_97 <=  n_98;
and1_44: n_98 <=  n_99;
delay_45: n_99  <= TRANSPORT a_LC4_B9  ;
and1_46: n_101 <=  gnd;
delay_47: n_102  <= TRANSPORT n_103;
xor2_48: n_103 <=  n_104  XOR n_108;
or1_49: n_104 <=  n_105;
and1_50: n_105 <=  n_106;
delay_51: n_106  <= TRANSPORT a_G513  ;
and1_52: n_108 <=  gnd;
delay_53: n_109  <= TRANSPORT n_110;
xor2_54: n_110 <=  n_111  XOR n_115;
or1_55: n_111 <=  n_112;
and1_56: n_112 <=  n_113;
delay_57: n_113  <= TRANSPORT a_G103  ;
and1_58: n_115 <=  gnd;
delay_59: n_116  <= TRANSPORT n_117;
xor2_60: n_117 <=  n_118  XOR n_122;
or1_61: n_118 <=  n_119;
and1_62: n_119 <=  n_120;
delay_63: n_120  <= TRANSPORT a_G764  ;
and1_64: n_122 <=  gnd;
delay_65: n_123  <= TRANSPORT n_124;
xor2_66: n_124 <=  n_125  XOR n_129;
or1_67: n_125 <=  n_126;
and1_68: n_126 <=  n_127;
delay_69: n_127  <= TRANSPORT a_LC6_C8  ;
and1_70: n_129 <=  gnd;
delay_71: n_130  <= TRANSPORT n_131;
xor2_72: n_131 <=  n_132  XOR n_136;
or1_73: n_132 <=  n_133;
and1_74: n_133 <=  n_134;
delay_75: n_134  <= TRANSPORT a_G770  ;
and1_76: n_136 <=  gnd;
delay_77: n_137  <= TRANSPORT n_138;
xor2_78: n_138 <=  n_139  XOR n_143;
or1_79: n_139 <=  n_140;
and1_80: n_140 <=  n_141;
delay_81: n_141  <= TRANSPORT a_LC1_C14  ;
and1_82: n_143 <=  gnd;
delay_83: n_144  <= TRANSPORT n_145;
xor2_84: n_145 <=  n_146  XOR n_150;
or1_85: n_146 <=  n_147;
and1_86: n_147 <=  n_148;
delay_87: n_148  <= TRANSPORT a_SSOUT  ;
and1_88: n_150 <=  gnd;
delay_89: n_151  <= TRANSPORT n_152;
xor2_90: n_152 <=  n_153  XOR n_157;
or1_91: n_153 <=  n_154;
and1_92: n_154 <=  n_155;
inv_93: n_155  <= TRANSPORT NOT a_SMCNTL_DAT_F1_G  ;
and1_94: n_157 <=  gnd;
delay_95: n_158  <= TRANSPORT n_159;
xor2_96: n_159 <=  n_160  XOR n_164;
or1_97: n_160 <=  n_161;
and1_98: n_161 <=  n_162;
inv_99: n_162  <= TRANSPORT NOT a_SMCNTL_DAT_F3_G  ;
and1_100: n_164 <=  gnd;
delay_101: n_165  <= TRANSPORT n_166;
xor2_102: n_166 <=  n_167  XOR n_171;
or1_103: n_167 <=  n_168;
and1_104: n_168 <=  n_169;
inv_105: n_169  <= TRANSPORT NOT a_SMCNTL_DAT_F2_G  ;
and1_106: n_171 <=  gnd;
delay_107: n_172  <= TRANSPORT n_173;
xor2_108: n_173 <=  n_174  XOR n_178;
or1_109: n_174 <=  n_175;
and1_110: n_175 <=  n_176;
delay_111: n_176  <= TRANSPORT a_SINTR  ;
and1_112: n_178 <=  gnd;
delay_113: n_179  <= TRANSPORT n_180;
xor2_114: n_180 <=  n_181  XOR n_185;
or1_115: n_181 <=  n_182;
and1_116: n_182 <=  n_183;
inv_117: n_183  <= TRANSPORT NOT a_SMCNTL_DAT_F0_G  ;
and1_118: n_185 <=  gnd;
delay_119: n_186  <= TRANSPORT n_187;
xor2_120: n_187 <=  n_188  XOR n_192;
or1_121: n_188 <=  n_189;
and1_122: n_189 <=  n_190;
inv_123: n_190  <= TRANSPORT NOT a_N805  ;
and1_124: n_192 <=  gnd;
delay_125: n_193  <= TRANSPORT n_194;
xor2_126: n_194 <=  n_195  XOR n_199;
or1_127: n_195 <=  n_196;
and1_128: n_196 <=  n_197;
delay_129: n_197  <= TRANSPORT a_SCSOUT  ;
and1_130: n_199 <=  gnd;
delay_131: n_200  <= TRANSPORT n_201;
xor2_132: n_201 <=  n_202  XOR n_206;
or1_133: n_202 <=  n_203;
and1_134: n_203 <=  n_204;
delay_135: n_204  <= TRANSPORT a_SBAUDOUT_N  ;
and1_136: n_206 <=  gnd;
dff_137: DFF_a16450

    PORT MAP ( D => a_N7_aD, CLK => a_N7_aCLK, CLRN => a_N7_aCLRN, PRN => vcc,
          Q => a_N7);
inv_138: a_N7_aCLRN  <= TRANSPORT NOT MR  ;
xor2_139: a_N7_aD <=  n_215  XOR n_219;
or1_140: n_215 <=  n_216;
and1_141: n_216 <=  n_217;
delay_142: n_217  <= TRANSPORT a_N5  ;
and1_143: n_219 <=  gnd;
inv_144: n_220  <= TRANSPORT NOT CLK  ;
filter_145: FILTER_a16450

    PORT MAP (IN1 => n_220, Y => a_N7_aCLK);
dff_146: DFF_a16450

    PORT MAP ( D => a_EQ058, CLK => a_N10_aCLK, CLRN => a_N10_aCLRN, PRN => vcc,
          Q => a_N10);
inv_147: a_N10_aCLRN  <= TRANSPORT NOT MR  ;
xor2_148: a_EQ058 <=  n_230  XOR n_239;
or2_149: n_230 <=  n_231  OR n_236;
and2_150: n_231 <=  n_232  AND n_234;
inv_151: n_232  <= TRANSPORT NOT a_N797  ;
delay_152: n_234  <= TRANSPORT a_LC1_A19  ;
and2_153: n_236 <=  n_237  AND n_238;
delay_154: n_237  <= TRANSPORT a_N5  ;
inv_155: n_238  <= TRANSPORT NOT a_N7  ;
and1_156: n_239 <=  gnd;
delay_157: n_240  <= TRANSPORT CLK  ;
filter_158: FILTER_a16450

    PORT MAP (IN1 => n_240, Y => a_N10_aCLK);
delay_159: a_N805  <= TRANSPORT a_EQ242  ;
xor2_160: a_EQ242 <=  n_244  XOR n_253;
or2_161: n_244 <=  n_245  OR n_249;
and2_162: n_245 <=  n_246  AND n_247;
delay_163: n_246  <= TRANSPORT a_SCSOUT  ;
inv_164: n_247  <= TRANSPORT NOT nRD  ;
and2_165: n_249 <=  n_250  AND n_251;
delay_166: n_250  <= TRANSPORT a_SCSOUT  ;
delay_167: n_251  <= TRANSPORT RD  ;
and1_168: n_253 <=  gnd;
delay_169: a_N33  <= TRANSPORT a_N33_aIN  ;
xor2_170: a_N33_aIN <=  n_256  XOR n_264;
or1_171: n_256 <=  n_257;
and3_172: n_257 <=  n_258  AND n_260  AND n_262;
delay_173: n_258  <= TRANSPORT a_N1310  ;
inv_174: n_260  <= TRANSPORT NOT a_N1311  ;
delay_175: n_262  <= TRANSPORT a_N1312  ;
and1_176: n_264 <=  gnd;
dff_177: DFF_a16450

    PORT MAP ( D => a_EQ171, CLK => a_N351_aCLK, CLRN => a_N351_aCLRN, PRN => vcc,
          Q => a_N351);
inv_178: a_N351_aCLRN  <= TRANSPORT NOT MR  ;
xor2_179: a_EQ171 <=  n_272  XOR n_281;
or2_180: n_272 <=  n_273  OR n_277;
and3_181: n_273 <=  n_274  AND n_275  AND n_276;
delay_182: n_274  <= TRANSPORT a_SCSOUT  ;
delay_183: n_275  <= TRANSPORT a_N33  ;
inv_184: n_276  <= TRANSPORT NOT nRD  ;
and3_185: n_277 <=  n_278  AND n_279  AND n_280;
delay_186: n_278  <= TRANSPORT a_SCSOUT  ;
delay_187: n_279  <= TRANSPORT a_N33  ;
delay_188: n_280  <= TRANSPORT RD  ;
and1_189: n_281 <=  gnd;
delay_190: n_282  <= TRANSPORT CLK  ;
filter_191: FILTER_a16450

    PORT MAP (IN1 => n_282, Y => a_N351_aCLK);
delay_192: a_N783_aNOT  <= TRANSPORT a_EQ219  ;
xor2_193: a_EQ219 <=  n_286  XOR n_292;
or2_194: n_286 <=  n_287  OR n_290;
and2_195: n_287 <=  n_288  AND n_289;
delay_196: n_288  <= TRANSPORT a_N805  ;
delay_197: n_289  <= TRANSPORT a_N33  ;
and1_198: n_290 <=  n_291;
inv_199: n_291  <= TRANSPORT NOT a_N351  ;
and1_200: n_292 <=  gnd;
delay_201: a_LC2_B2  <= TRANSPORT a_LC2_B2_aIN  ;
xor2_202: a_LC2_B2_aIN <=  n_295  XOR n_301;
or1_203: n_295 <=  n_296;
and2_204: n_296 <=  n_297  AND n_299;
delay_205: n_297  <= TRANSPORT a_SLCNTL_DOUT_F3_G  ;
inv_206: n_299  <= TRANSPORT NOT a_N792_aNOT  ;
and1_207: n_301 <=  gnd;
delay_208: a_LC5_A6  <= TRANSPORT a_EQ206  ;
xor2_209: a_EQ206 <=  n_304  XOR n_349;
or8_210: n_304 <=  n_305  OR n_314  OR n_319  OR n_324  OR n_329  OR n_334
           OR n_339  OR n_344;
and4_211: n_305 <=  n_306  AND n_308  AND n_310  AND n_312;
delay_212: n_306  <= TRANSPORT a_N51  ;
delay_213: n_308  <= TRANSPORT a_N49  ;
inv_214: n_310  <= TRANSPORT NOT a_N48  ;
delay_215: n_312  <= TRANSPORT a_N60  ;
and4_216: n_314 <=  n_315  AND n_316  AND n_317  AND n_318;
inv_217: n_315  <= TRANSPORT NOT a_N51  ;
delay_218: n_316  <= TRANSPORT a_N49  ;
delay_219: n_317  <= TRANSPORT a_N48  ;
delay_220: n_318  <= TRANSPORT a_N60  ;
and4_221: n_319 <=  n_320  AND n_321  AND n_322  AND n_323;
inv_222: n_320  <= TRANSPORT NOT a_N51  ;
inv_223: n_321  <= TRANSPORT NOT a_N49  ;
inv_224: n_322  <= TRANSPORT NOT a_N48  ;
delay_225: n_323  <= TRANSPORT a_N60  ;
and4_226: n_324 <=  n_325  AND n_326  AND n_327  AND n_328;
delay_227: n_325  <= TRANSPORT a_N51  ;
inv_228: n_326  <= TRANSPORT NOT a_N49  ;
delay_229: n_327  <= TRANSPORT a_N48  ;
delay_230: n_328  <= TRANSPORT a_N60  ;
and4_231: n_329 <=  n_330  AND n_331  AND n_332  AND n_333;
delay_232: n_330  <= TRANSPORT a_N51  ;
inv_233: n_331  <= TRANSPORT NOT a_N49  ;
inv_234: n_332  <= TRANSPORT NOT a_N48  ;
inv_235: n_333  <= TRANSPORT NOT a_N60  ;
and4_236: n_334 <=  n_335  AND n_336  AND n_337  AND n_338;
inv_237: n_335  <= TRANSPORT NOT a_N51  ;
inv_238: n_336  <= TRANSPORT NOT a_N49  ;
delay_239: n_337  <= TRANSPORT a_N48  ;
inv_240: n_338  <= TRANSPORT NOT a_N60  ;
and4_241: n_339 <=  n_340  AND n_341  AND n_342  AND n_343;
inv_242: n_340  <= TRANSPORT NOT a_N51  ;
delay_243: n_341  <= TRANSPORT a_N49  ;
inv_244: n_342  <= TRANSPORT NOT a_N48  ;
inv_245: n_343  <= TRANSPORT NOT a_N60  ;
and4_246: n_344 <=  n_345  AND n_346  AND n_347  AND n_348;
delay_247: n_345  <= TRANSPORT a_N51  ;
delay_248: n_346  <= TRANSPORT a_N49  ;
delay_249: n_347  <= TRANSPORT a_N48  ;
inv_250: n_348  <= TRANSPORT NOT a_N60  ;
and1_251: n_349 <=  gnd;
delay_252: a_LC3_A12  <= TRANSPORT a_EQ205  ;
xor2_253: a_EQ205 <=  n_352  XOR n_372;
or4_254: n_352 <=  n_353  OR n_360  OR n_364  OR n_368;
and3_255: n_353 <=  n_354  AND n_356  AND n_358;
inv_256: n_354  <= TRANSPORT NOT a_N53  ;
delay_257: n_356  <= TRANSPORT a_N59  ;
inv_258: n_358  <= TRANSPORT NOT a_N55  ;
and3_259: n_360 <=  n_361  AND n_362  AND n_363;
delay_260: n_361  <= TRANSPORT a_N53  ;
delay_261: n_362  <= TRANSPORT a_N59  ;
delay_262: n_363  <= TRANSPORT a_N55  ;
and3_263: n_364 <=  n_365  AND n_366  AND n_367;
delay_264: n_365  <= TRANSPORT a_N53  ;
inv_265: n_366  <= TRANSPORT NOT a_N59  ;
inv_266: n_367  <= TRANSPORT NOT a_N55  ;
and3_267: n_368 <=  n_369  AND n_370  AND n_371;
inv_268: n_369  <= TRANSPORT NOT a_N53  ;
inv_269: n_370  <= TRANSPORT NOT a_N59  ;
delay_270: n_371  <= TRANSPORT a_N55  ;
and1_271: n_372 <=  gnd;
delay_272: a_N548  <= TRANSPORT a_EQ207  ;
xor2_273: a_EQ207 <=  n_375  XOR n_393;
or4_274: n_375 <=  n_376  OR n_381  OR n_385  OR n_389;
and3_275: n_376 <=  n_377  AND n_379  AND n_380;
inv_276: n_377  <= TRANSPORT NOT a_N58  ;
inv_277: n_379  <= TRANSPORT NOT a_LC5_A6  ;
delay_278: n_380  <= TRANSPORT a_LC3_A12  ;
and3_279: n_381 <=  n_382  AND n_383  AND n_384;
delay_280: n_382  <= TRANSPORT a_N58  ;
delay_281: n_383  <= TRANSPORT a_LC5_A6  ;
delay_282: n_384  <= TRANSPORT a_LC3_A12  ;
and3_283: n_385 <=  n_386  AND n_387  AND n_388;
delay_284: n_386  <= TRANSPORT a_N58  ;
inv_285: n_387  <= TRANSPORT NOT a_LC5_A6  ;
inv_286: n_388  <= TRANSPORT NOT a_LC3_A12  ;
and3_287: n_389 <=  n_390  AND n_391  AND n_392;
inv_288: n_390  <= TRANSPORT NOT a_N58  ;
delay_289: n_391  <= TRANSPORT a_LC5_A6  ;
inv_290: n_392  <= TRANSPORT NOT a_LC3_A12  ;
and1_291: n_393 <=  gnd;
delay_292: a_N524  <= TRANSPORT a_EQ196  ;
xor2_293: a_EQ196 <=  n_396  XOR n_426;
or6_294: n_396 <=  n_397  OR n_405  OR n_410  OR n_414  OR n_418  OR n_422;
and4_295: n_397 <=  n_398  AND n_400  AND n_401  AND n_403;
inv_296: n_398  <= TRANSPORT NOT a_N1369  ;
delay_297: n_400  <= TRANSPORT a_N548  ;
delay_298: n_401  <= TRANSPORT a_SLCNTL_DOUT_F4_G  ;
inv_299: n_403  <= TRANSPORT NOT a_SLCNTL_DOUT_F5_G  ;
and4_300: n_405 <=  n_406  AND n_407  AND n_408  AND n_409;
delay_301: n_406  <= TRANSPORT a_N1369  ;
delay_302: n_407  <= TRANSPORT a_N548  ;
inv_303: n_408  <= TRANSPORT NOT a_SLCNTL_DOUT_F4_G  ;
inv_304: n_409  <= TRANSPORT NOT a_SLCNTL_DOUT_F5_G  ;
and3_305: n_410 <=  n_411  AND n_412  AND n_413;
delay_306: n_411  <= TRANSPORT a_N1369  ;
delay_307: n_412  <= TRANSPORT a_SLCNTL_DOUT_F4_G  ;
delay_308: n_413  <= TRANSPORT a_SLCNTL_DOUT_F5_G  ;
and3_309: n_414 <=  n_415  AND n_416  AND n_417;
delay_310: n_415  <= TRANSPORT a_N1369  ;
inv_311: n_416  <= TRANSPORT NOT a_N548  ;
delay_312: n_417  <= TRANSPORT a_SLCNTL_DOUT_F4_G  ;
and3_313: n_418 <=  n_419  AND n_420  AND n_421;
inv_314: n_419  <= TRANSPORT NOT a_N1369  ;
inv_315: n_420  <= TRANSPORT NOT a_SLCNTL_DOUT_F4_G  ;
delay_316: n_421  <= TRANSPORT a_SLCNTL_DOUT_F5_G  ;
and3_317: n_422 <=  n_423  AND n_424  AND n_425;
inv_318: n_423  <= TRANSPORT NOT a_N1369  ;
inv_319: n_424  <= TRANSPORT NOT a_N548  ;
inv_320: n_425  <= TRANSPORT NOT a_SLCNTL_DOUT_F4_G  ;
and1_321: n_426 <=  gnd;
dff_322: DFF_a16450

    PORT MAP ( D => a_EQ337, CLK => a_SLSTAT_DAT_F2_G_aCLK, CLRN => a_SLSTAT_DAT_F2_G_aCLRN,
          PRN => vcc, Q => a_SLSTAT_DAT_F2_G);
inv_323: a_SLSTAT_DAT_F2_G_aCLRN  <= TRANSPORT NOT MR  ;
xor2_324: a_EQ337 <=  n_434  XOR n_442;
or2_325: n_434 <=  n_435  OR n_438;
and2_326: n_435 <=  n_436  AND n_437;
delay_327: n_436  <= TRANSPORT a_N783_aNOT  ;
delay_328: n_437  <= TRANSPORT a_SLSTAT_DAT_F2_G  ;
and3_329: n_438 <=  n_439  AND n_440  AND n_441;
delay_330: n_439  <= TRANSPORT a_N783_aNOT  ;
delay_331: n_440  <= TRANSPORT a_LC2_B2  ;
delay_332: n_441  <= TRANSPORT a_N524  ;
and1_333: n_442 <=  gnd;
delay_334: n_443  <= TRANSPORT RCLK  ;
filter_335: FILTER_a16450

    PORT MAP (IN1 => n_443, Y => a_SLSTAT_DAT_F2_G_aCLK);
dff_336: DFF_a16450

    PORT MAP ( D => a_EQ338, CLK => a_SLSTAT_DAT_F3_G_aCLK, CLRN => a_SLSTAT_DAT_F3_G_aCLRN,
          PRN => vcc, Q => a_SLSTAT_DAT_F3_G);
inv_337: a_SLSTAT_DAT_F3_G_aCLRN  <= TRANSPORT NOT MR  ;
xor2_338: a_EQ338 <=  n_452  XOR n_461;
or2_339: n_452 <=  n_453  OR n_456;
and2_340: n_453 <=  n_454  AND n_455;
delay_341: n_454  <= TRANSPORT a_N783_aNOT  ;
delay_342: n_455  <= TRANSPORT a_SLSTAT_DAT_F3_G  ;
and3_343: n_456 <=  n_457  AND n_459  AND n_460;
inv_344: n_457  <= TRANSPORT NOT a_N16_aNOT  ;
inv_345: n_459  <= TRANSPORT NOT a_N792_aNOT  ;
delay_346: n_460  <= TRANSPORT a_N783_aNOT  ;
and1_347: n_461 <=  gnd;
delay_348: n_462  <= TRANSPORT RCLK  ;
filter_349: FILTER_a16450

    PORT MAP (IN1 => n_462, Y => a_SLSTAT_DAT_F3_G_aCLK);
delay_350: a_LC8_A9  <= TRANSPORT a_LC8_A9_aIN  ;
xor2_351: a_LC8_A9_aIN <=  n_466  XOR n_474;
or1_352: n_466 <=  n_467;
and3_353: n_467 <=  n_468  AND n_470  AND n_472;
delay_354: n_468  <= TRANSPORT a_N346  ;
delay_355: n_470  <= TRANSPORT a_N347  ;
inv_356: n_472  <= TRANSPORT NOT a_N348  ;
and1_357: n_474 <=  gnd;
dff_358: DFF_a16450

    PORT MAP ( D => a_EQ339, CLK => a_SLSTAT_DAT_F4_G_aCLK, CLRN => a_SLSTAT_DAT_F4_G_aCLRN,
          PRN => vcc, Q => a_SLSTAT_DAT_F4_G);
inv_359: a_SLSTAT_DAT_F4_G_aCLRN  <= TRANSPORT NOT MR  ;
xor2_360: a_EQ339 <=  n_482  XOR n_491;
or2_361: n_482 <=  n_483  OR n_486;
and2_362: n_483 <=  n_484  AND n_485;
delay_363: n_484  <= TRANSPORT a_N783_aNOT  ;
delay_364: n_485  <= TRANSPORT a_SLSTAT_DAT_F4_G  ;
and3_365: n_486 <=  n_487  AND n_489  AND n_490;
inv_366: n_487  <= TRANSPORT NOT a_N349  ;
delay_367: n_489  <= TRANSPORT a_N783_aNOT  ;
delay_368: n_490  <= TRANSPORT a_LC8_A9  ;
and1_369: n_491 <=  gnd;
delay_370: n_492  <= TRANSPORT RCLK  ;
filter_371: FILTER_a16450

    PORT MAP (IN1 => n_492, Y => a_SLSTAT_DAT_F4_G_aCLK);
dff_372: DFF_a16450

    PORT MAP ( D => a_EQ336, CLK => a_SLSTAT_DAT_F1_G_aCLK, CLRN => a_SLSTAT_DAT_F1_G_aCLRN,
          PRN => vcc, Q => a_SLSTAT_DAT_F1_G);
inv_373: a_SLSTAT_DAT_F1_G_aCLRN  <= TRANSPORT NOT MR  ;
xor2_374: a_EQ336 <=  n_501  XOR n_510;
or2_375: n_501 <=  n_502  OR n_505;
and2_376: n_502 <=  n_503  AND n_504;
delay_377: n_503  <= TRANSPORT a_N783_aNOT  ;
delay_378: n_504  <= TRANSPORT a_SLSTAT_DAT_F1_G  ;
and3_379: n_505 <=  n_506  AND n_507  AND n_508;
inv_380: n_506  <= TRANSPORT NOT a_N792_aNOT  ;
delay_381: n_507  <= TRANSPORT a_N783_aNOT  ;
delay_382: n_508  <= TRANSPORT a_SLSTAT_DAT_F0_G  ;
and1_383: n_510 <=  gnd;
delay_384: n_511  <= TRANSPORT RCLK  ;
filter_385: FILTER_a16450

    PORT MAP (IN1 => n_511, Y => a_SLSTAT_DAT_F1_G_aCLK);
dff_386: DFF_a16450

    PORT MAP ( D => a_EQ277, CLK => a_N1310_aCLK, CLRN => a_N1310_aCLRN, PRN => vcc,
          Q => a_N1310);
inv_387: a_N1310_aCLRN  <= TRANSPORT NOT MR  ;
xor2_388: a_EQ277 <=  n_521  XOR n_528;
or2_389: n_521 <=  n_522  OR n_525;
and2_390: n_522 <=  n_523  AND n_524;
delay_391: n_523  <= TRANSPORT nADS  ;
delay_392: n_524  <= TRANSPORT a_N1310  ;
and2_393: n_525 <=  n_526  AND n_527;
inv_394: n_526  <= TRANSPORT NOT nADS  ;
delay_395: n_527  <= TRANSPORT A(2)  ;
and1_396: n_528 <=  gnd;
delay_397: n_529  <= TRANSPORT CLK  ;
filter_398: FILTER_a16450

    PORT MAP (IN1 => n_529, Y => a_N1310_aCLK);
dff_399: DFF_a16450

    PORT MAP ( D => a_EQ280, CLK => a_N1313_aCLK, CLRN => a_N1313_aCLRN, PRN => vcc,
          Q => a_N1313);
inv_400: a_N1313_aCLRN  <= TRANSPORT NOT MR  ;
xor2_401: a_EQ280 <=  n_538  XOR n_552;
or3_402: n_538 <=  n_539  OR n_543  OR n_547;
and2_403: n_539 <=  n_540  AND n_542;
inv_404: n_540  <= TRANSPORT NOT a_N32  ;
delay_405: n_542  <= TRANSPORT a_N1313  ;
and2_406: n_543 <=  n_544  AND n_546;
inv_407: n_544  <= TRANSPORT NOT a_N804  ;
delay_408: n_546  <= TRANSPORT a_N1313  ;
and3_409: n_547 <=  n_548  AND n_549  AND n_550;
delay_410: n_548  <= TRANSPORT a_N804  ;
delay_411: n_549  <= TRANSPORT a_N32  ;
delay_412: n_550  <= TRANSPORT DIN(7)  ;
and1_413: n_552 <=  gnd;
inv_414: n_553  <= TRANSPORT NOT CLK  ;
filter_415: FILTER_a16450

    PORT MAP (IN1 => n_553, Y => a_N1313_aCLK);
dff_416: DFF_a16450

    PORT MAP ( D => a_EQ318, CLK => a_SINTEN_DAT_F0_G_aCLK, CLRN => a_SINTEN_DAT_F0_G_aCLRN,
          PRN => vcc, Q => a_SINTEN_DAT_F0_G);
inv_417: a_SINTEN_DAT_F0_G_aCLRN  <= TRANSPORT NOT MR  ;
xor2_418: a_EQ318 <=  n_562  XOR n_571;
or2_419: n_562 <=  n_563  OR n_568;
and2_420: n_563 <=  n_564  AND n_566;
inv_421: n_564  <= TRANSPORT NOT a_N796_aNOT  ;
delay_422: n_566  <= TRANSPORT DIN(0)  ;
and2_423: n_568 <=  n_569  AND n_570;
delay_424: n_569  <= TRANSPORT a_N796_aNOT  ;
delay_425: n_570  <= TRANSPORT a_SINTEN_DAT_F0_G  ;
and1_426: n_571 <=  gnd;
delay_427: n_572  <= TRANSPORT CLK  ;
filter_428: FILTER_a16450

    PORT MAP (IN1 => n_572, Y => a_SINTEN_DAT_F0_G_aCLK);
delay_429: rbuff_rd  <= TRANSPORT rbuff_rd_aIN  ;
xor2_430: rbuff_rd_aIN <=  n_576  XOR n_583;
or1_431: n_576 <=  n_577;
and3_432: n_577 <=  n_578  AND n_580  AND n_582;
delay_433: n_578  <= TRANSPORT a_N21  ;
inv_434: n_580  <= TRANSPORT NOT a_SLCNTL_DOUT_F7_G  ;
delay_435: n_582  <= TRANSPORT a_N805  ;
and1_436: n_583 <=  gnd;
dff_437: DFF_a16450

    PORT MAP ( D => a_N350_aD, CLK => a_N350_aCLK, CLRN => a_N350_aCLRN, PRN => vcc,
          Q => a_N350);
inv_438: a_N350_aCLRN  <= TRANSPORT NOT MR  ;
xor2_439: a_N350_aD <=  n_591  XOR n_596;
or1_440: n_591 <=  n_592;
and3_441: n_592 <=  n_593  AND n_594  AND n_595;
delay_442: n_593  <= TRANSPORT a_N21  ;
inv_443: n_594  <= TRANSPORT NOT a_SLCNTL_DOUT_F7_G  ;
delay_444: n_595  <= TRANSPORT a_N805  ;
and1_445: n_596 <=  gnd;
delay_446: n_597  <= TRANSPORT CLK  ;
filter_447: FILTER_a16450

    PORT MAP (IN1 => n_597, Y => a_N350_aCLK);
dff_448: DFF_a16450

    PORT MAP ( D => a_EQ335, CLK => a_SLSTAT_DAT_F0_G_aCLK, CLRN => a_SLSTAT_DAT_F0_G_aCLRN,
          PRN => vcc, Q => a_SLSTAT_DAT_F0_G);
inv_449: a_SLSTAT_DAT_F0_G_aCLRN  <= TRANSPORT NOT MR  ;
xor2_450: a_EQ335 <=  n_605  XOR n_618;
or4_451: n_605 <=  n_606  OR n_609  OR n_612  OR n_615;
and2_452: n_606 <=  n_607  AND n_608;
delay_453: n_607  <= TRANSPORT rbuff_rd  ;
delay_454: n_608  <= TRANSPORT a_SLSTAT_DAT_F0_G  ;
and2_455: n_609 <=  n_610  AND n_611;
inv_456: n_610  <= TRANSPORT NOT a_N792_aNOT  ;
delay_457: n_611  <= TRANSPORT rbuff_rd  ;
and2_458: n_612 <=  n_613  AND n_614;
inv_459: n_613  <= TRANSPORT NOT a_N350  ;
delay_460: n_614  <= TRANSPORT a_SLSTAT_DAT_F0_G  ;
and2_461: n_615 <=  n_616  AND n_617;
inv_462: n_616  <= TRANSPORT NOT a_N792_aNOT  ;
inv_463: n_617  <= TRANSPORT NOT a_N350  ;
and1_464: n_618 <=  gnd;
delay_465: n_619  <= TRANSPORT RCLK  ;
filter_466: FILTER_a16450

    PORT MAP (IN1 => n_619, Y => a_SLSTAT_DAT_F0_G_aCLK);
dff_467: DFF_a16450

    PORT MAP ( D => a_N1125_aD, CLK => a_N1125_aCLK, CLRN => a_N1125_aCLRN,
          PRN => vcc, Q => a_N1125);
inv_468: a_N1125_aCLRN  <= TRANSPORT NOT MR  ;
xor2_469: a_N1125_aD <=  n_628  XOR n_632;
or1_470: n_628 <=  n_629;
and1_471: n_629 <=  n_630;
delay_472: n_630  <= TRANSPORT a_N1123  ;
and1_473: n_632 <=  gnd;
delay_474: n_633  <= TRANSPORT CLK  ;
filter_475: FILTER_a16450

    PORT MAP (IN1 => n_633, Y => a_N1125_aCLK);
dff_476: DFF_a16450

    PORT MAP ( D => a_EQ257, CLK => a_N1123_aCLK, CLRN => a_N1123_aCLRN, PRN => vcc,
          Q => a_N1123);
inv_477: a_N1123_aCLRN  <= TRANSPORT NOT MR  ;
xor2_478: a_EQ257 <=  n_643  XOR n_648;
or2_479: n_643 <=  n_644  OR n_646;
and1_480: n_644 <=  n_645;
delay_481: n_645  <= TRANSPORT WR  ;
and1_482: n_646 <=  n_647;
inv_483: n_647  <= TRANSPORT NOT nWR  ;
and1_484: n_648 <=  gnd;
delay_485: n_649  <= TRANSPORT CLK  ;
filter_486: FILTER_a16450

    PORT MAP (IN1 => n_649, Y => a_N1123_aCLK);
dff_487: DFF_a16450

    PORT MAP ( D => a_EQ302, CLK => a_SDLSB_DAT_F0_G_aCLK, CLRN => a_SDLSB_DAT_F0_G_aCLRN,
          PRN => vcc, Q => a_SDLSB_DAT_F0_G);
inv_488: a_SDLSB_DAT_F0_G_aCLRN  <= TRANSPORT NOT MR  ;
xor2_489: a_EQ302 <=  n_658  XOR n_666;
or2_490: n_658 <=  n_659  OR n_663;
and2_491: n_659 <=  n_660  AND n_662;
inv_492: n_660  <= TRANSPORT NOT a_N795_aNOT  ;
delay_493: n_662  <= TRANSPORT DIN(0)  ;
and2_494: n_663 <=  n_664  AND n_665;
delay_495: n_664  <= TRANSPORT a_N795_aNOT  ;
delay_496: n_665  <= TRANSPORT a_SDLSB_DAT_F0_G  ;
and1_497: n_666 <=  gnd;
delay_498: n_667  <= TRANSPORT CLK  ;
filter_499: FILTER_a16450

    PORT MAP (IN1 => n_667, Y => a_SDLSB_DAT_F0_G_aCLK);
dff_500: DFF_a16450

    PORT MAP ( D => a_EQ303, CLK => a_SDLSB_DAT_F1_G_aCLK, CLRN => a_SDLSB_DAT_F1_G_aCLRN,
          PRN => vcc, Q => a_SDLSB_DAT_F1_G);
inv_501: a_SDLSB_DAT_F1_G_aCLRN  <= TRANSPORT NOT MR  ;
xor2_502: a_EQ303 <=  n_676  XOR n_684;
or2_503: n_676 <=  n_677  OR n_680;
and2_504: n_677 <=  n_678  AND n_679;
delay_505: n_678  <= TRANSPORT a_N795_aNOT  ;
delay_506: n_679  <= TRANSPORT a_SDLSB_DAT_F1_G  ;
and2_507: n_680 <=  n_681  AND n_682;
inv_508: n_681  <= TRANSPORT NOT a_N795_aNOT  ;
delay_509: n_682  <= TRANSPORT DIN(1)  ;
and1_510: n_684 <=  gnd;
delay_511: n_685  <= TRANSPORT CLK  ;
filter_512: FILTER_a16450

    PORT MAP (IN1 => n_685, Y => a_SDLSB_DAT_F1_G_aCLK);
dff_513: DFF_a16450

    PORT MAP ( D => a_EQ304, CLK => a_SDLSB_DAT_F2_G_aCLK, CLRN => a_SDLSB_DAT_F2_G_aCLRN,
          PRN => vcc, Q => a_SDLSB_DAT_F2_G);
inv_514: a_SDLSB_DAT_F2_G_aCLRN  <= TRANSPORT NOT MR  ;
xor2_515: a_EQ304 <=  n_694  XOR n_702;
or2_516: n_694 <=  n_695  OR n_699;
and2_517: n_695 <=  n_696  AND n_697;
inv_518: n_696  <= TRANSPORT NOT a_N795_aNOT  ;
delay_519: n_697  <= TRANSPORT DIN(2)  ;
and2_520: n_699 <=  n_700  AND n_701;
delay_521: n_700  <= TRANSPORT a_N795_aNOT  ;
delay_522: n_701  <= TRANSPORT a_SDLSB_DAT_F2_G  ;
and1_523: n_702 <=  gnd;
delay_524: n_703  <= TRANSPORT CLK  ;
filter_525: FILTER_a16450

    PORT MAP (IN1 => n_703, Y => a_SDLSB_DAT_F2_G_aCLK);
dff_526: DFF_a16450

    PORT MAP ( D => a_EQ305, CLK => a_SDLSB_DAT_F3_G_aCLK, CLRN => a_SDLSB_DAT_F3_G_aCLRN,
          PRN => vcc, Q => a_SDLSB_DAT_F3_G);
inv_527: a_SDLSB_DAT_F3_G_aCLRN  <= TRANSPORT NOT MR  ;
xor2_528: a_EQ305 <=  n_712  XOR n_720;
or2_529: n_712 <=  n_713  OR n_716;
and2_530: n_713 <=  n_714  AND n_715;
delay_531: n_714  <= TRANSPORT a_N795_aNOT  ;
delay_532: n_715  <= TRANSPORT a_SDLSB_DAT_F3_G  ;
and2_533: n_716 <=  n_717  AND n_718;
inv_534: n_717  <= TRANSPORT NOT a_N795_aNOT  ;
delay_535: n_718  <= TRANSPORT DIN(3)  ;
and1_536: n_720 <=  gnd;
delay_537: n_721  <= TRANSPORT CLK  ;
filter_538: FILTER_a16450

    PORT MAP (IN1 => n_721, Y => a_SDLSB_DAT_F3_G_aCLK);
dff_539: DFF_a16450

    PORT MAP ( D => a_EQ331, CLK => a_SLCNTL_DOUT_F4_G_aCLK, CLRN => a_SLCNTL_DOUT_F4_G_aCLRN,
          PRN => vcc, Q => a_SLCNTL_DOUT_F4_G);
inv_540: a_SLCNTL_DOUT_F4_G_aCLRN  <= TRANSPORT NOT MR  ;
xor2_541: a_EQ331 <=  n_729  XOR n_742;
or3_542: n_729 <=  n_730  OR n_734  OR n_737;
and2_543: n_730 <=  n_731  AND n_733;
inv_544: n_731  <= TRANSPORT NOT a_N35  ;
delay_545: n_733  <= TRANSPORT a_SLCNTL_DOUT_F4_G  ;
and2_546: n_734 <=  n_735  AND n_736;
inv_547: n_735  <= TRANSPORT NOT a_N804  ;
delay_548: n_736  <= TRANSPORT a_SLCNTL_DOUT_F4_G  ;
and3_549: n_737 <=  n_738  AND n_739  AND n_740;
delay_550: n_738  <= TRANSPORT a_N804  ;
delay_551: n_739  <= TRANSPORT a_N35  ;
delay_552: n_740  <= TRANSPORT DIN(4)  ;
and1_553: n_742 <=  gnd;
inv_554: n_743  <= TRANSPORT NOT CLK  ;
filter_555: FILTER_a16450

    PORT MAP (IN1 => n_743, Y => a_SLCNTL_DOUT_F4_G_aCLK);
dff_556: DFF_a16450

    PORT MAP ( D => a_EQ332, CLK => a_SLCNTL_DOUT_F5_G_aCLK, CLRN => a_SLCNTL_DOUT_F5_G_aCLRN,
          PRN => vcc, Q => a_SLCNTL_DOUT_F5_G);
inv_557: a_SLCNTL_DOUT_F5_G_aCLRN  <= TRANSPORT NOT MR  ;
xor2_558: a_EQ332 <=  n_751  XOR n_763;
or3_559: n_751 <=  n_752  OR n_755  OR n_758;
and2_560: n_752 <=  n_753  AND n_754;
inv_561: n_753  <= TRANSPORT NOT a_N35  ;
delay_562: n_754  <= TRANSPORT a_SLCNTL_DOUT_F5_G  ;
and2_563: n_755 <=  n_756  AND n_757;
inv_564: n_756  <= TRANSPORT NOT a_N804  ;
delay_565: n_757  <= TRANSPORT a_SLCNTL_DOUT_F5_G  ;
and3_566: n_758 <=  n_759  AND n_760  AND n_761;
delay_567: n_759  <= TRANSPORT a_N804  ;
delay_568: n_760  <= TRANSPORT a_N35  ;
delay_569: n_761  <= TRANSPORT DIN(5)  ;
and1_570: n_763 <=  gnd;
inv_571: n_764  <= TRANSPORT NOT CLK  ;
filter_572: FILTER_a16450

    PORT MAP (IN1 => n_764, Y => a_SLCNTL_DOUT_F5_G_aCLK);
dff_573: DFF_a16450

    PORT MAP ( D => a_EQ278, CLK => a_N1311_aCLK, CLRN => a_N1311_aCLRN, PRN => vcc,
          Q => a_N1311);
inv_574: a_N1311_aCLRN  <= TRANSPORT NOT MR  ;
xor2_575: a_EQ278 <=  n_773  XOR n_780;
or2_576: n_773 <=  n_774  OR n_777;
and2_577: n_774 <=  n_775  AND n_776;
delay_578: n_775  <= TRANSPORT nADS  ;
delay_579: n_776  <= TRANSPORT a_N1311  ;
and2_580: n_777 <=  n_778  AND n_779;
inv_581: n_778  <= TRANSPORT NOT nADS  ;
delay_582: n_779  <= TRANSPORT A(1)  ;
and1_583: n_780 <=  gnd;
delay_584: n_781  <= TRANSPORT CLK  ;
filter_585: FILTER_a16450

    PORT MAP (IN1 => n_781, Y => a_N1311_aCLK);
dff_586: DFF_a16450

    PORT MAP ( D => a_EQ279, CLK => a_N1312_aCLK, CLRN => a_N1312_aCLRN, PRN => vcc,
          Q => a_N1312);
inv_587: a_N1312_aCLRN  <= TRANSPORT NOT MR  ;
xor2_588: a_EQ279 <=  n_790  XOR n_797;
or2_589: n_790 <=  n_791  OR n_794;
and2_590: n_791 <=  n_792  AND n_793;
delay_591: n_792  <= TRANSPORT nADS  ;
delay_592: n_793  <= TRANSPORT a_N1312  ;
and2_593: n_794 <=  n_795  AND n_796;
inv_594: n_795  <= TRANSPORT NOT nADS  ;
delay_595: n_796  <= TRANSPORT A(0)  ;
and1_596: n_797 <=  gnd;
delay_597: n_798  <= TRANSPORT CLK  ;
filter_598: FILTER_a16450

    PORT MAP (IN1 => n_798, Y => a_N1312_aCLK);
delay_599: a_N29_aNOT  <= TRANSPORT a_EQ071  ;
xor2_600: a_EQ071 <=  n_802  XOR n_809;
or3_601: n_802 <=  n_803  OR n_805  OR n_807;
and1_602: n_803 <=  n_804;
delay_603: n_804  <= TRANSPORT a_N1312  ;
and1_604: n_805 <=  n_806;
inv_605: n_806  <= TRANSPORT NOT a_N1310  ;
and1_606: n_807 <=  n_808;
delay_607: n_808  <= TRANSPORT a_N1311  ;
and1_608: n_809 <=  gnd;
dff_609: DFF_a16450

    PORT MAP ( D => a_EQ002, CLK => en_lpbk_aCLK, CLRN => en_lpbk_aCLRN, PRN => vcc,
          Q => en_lpbk);
inv_610: en_lpbk_aCLRN  <= TRANSPORT NOT MR  ;
xor2_611: a_EQ002 <=  n_817  XOR n_828;
or3_612: n_817 <=  n_818  OR n_821  OR n_824;
and2_613: n_818 <=  n_819  AND n_820;
delay_614: n_819  <= TRANSPORT a_N29_aNOT  ;
delay_615: n_820  <= TRANSPORT en_lpbk  ;
and2_616: n_821 <=  n_822  AND n_823;
inv_617: n_822  <= TRANSPORT NOT a_N804  ;
delay_618: n_823  <= TRANSPORT en_lpbk  ;
and3_619: n_824 <=  n_825  AND n_826  AND n_827;
delay_620: n_825  <= TRANSPORT a_N804  ;
delay_621: n_826  <= TRANSPORT DIN(4)  ;
inv_622: n_827  <= TRANSPORT NOT a_N29_aNOT  ;
and1_623: n_828 <=  gnd;
delay_624: n_829  <= TRANSPORT CLK  ;
filter_625: FILTER_a16450

    PORT MAP (IN1 => n_829, Y => en_lpbk_aCLK);
delay_626: a_N39  <= TRANSPORT a_N39_aIN  ;
xor2_627: a_N39_aIN <=  n_833  XOR n_839;
or1_628: n_833 <=  n_834;
and2_629: n_834 <=  n_835  AND n_837;
delay_630: n_835  <= TRANSPORT a_N705  ;
delay_631: n_837  <= TRANSPORT a_N704  ;
and1_632: n_839 <=  gnd;
delay_633: a_LC8_C4  <= TRANSPORT a_EQ159  ;
xor2_634: a_EQ159 <=  n_842  XOR n_854;
or3_635: n_842 <=  n_843  OR n_846  OR n_850;
and2_636: n_843 <=  n_844  AND n_845;
inv_637: n_844  <= TRANSPORT NOT a_N705  ;
inv_638: n_845  <= TRANSPORT NOT a_N704  ;
and2_639: n_846 <=  n_847  AND n_849;
delay_640: n_847  <= TRANSPORT a_N702  ;
inv_641: n_849  <= TRANSPORT NOT a_N704  ;
and2_642: n_850 <=  n_851  AND n_853;
inv_643: n_851  <= TRANSPORT NOT a_N1354_aNOT  ;
delay_644: n_853  <= TRANSPORT a_N704  ;
and1_645: n_854 <=  gnd;
dff_646: DFF_a16450

    PORT MAP ( D => a_EQ003, CLK => lpbk_sin_aCLK, CLRN => vcc, PRN => vcc,
          Q => lpbk_sin);
xor2_647: a_EQ003 <=  n_861  XOR n_872;
or2_648: n_861 <=  n_862  OR n_868;
and3_649: n_862 <=  n_863  AND n_865  AND n_867;
delay_650: n_863  <= TRANSPORT a_N1353  ;
inv_651: n_865  <= TRANSPORT NOT a_SLCNTL_DOUT_F6_G  ;
delay_652: n_867  <= TRANSPORT a_N39  ;
and3_653: n_868 <=  n_869  AND n_870  AND n_871;
inv_654: n_869  <= TRANSPORT NOT a_SLCNTL_DOUT_F6_G  ;
inv_655: n_870  <= TRANSPORT NOT a_N39  ;
delay_656: n_871  <= TRANSPORT a_LC8_C4  ;
and1_657: n_872 <=  gnd;
delay_658: n_873  <= TRANSPORT CLK  ;
filter_659: FILTER_a16450

    PORT MAP (IN1 => n_873, Y => lpbk_sin_aCLK);
dff_660: DFF_a16450

    PORT MAP ( D => a_EQ320, CLK => a_SINTEN_DAT_F2_G_aCLK, CLRN => a_SINTEN_DAT_F2_G_aCLRN,
          PRN => vcc, Q => a_SINTEN_DAT_F2_G);
inv_661: a_SINTEN_DAT_F2_G_aCLRN  <= TRANSPORT NOT MR  ;
xor2_662: a_EQ320 <=  n_882  XOR n_889;
or2_663: n_882 <=  n_883  OR n_886;
and2_664: n_883 <=  n_884  AND n_885;
inv_665: n_884  <= TRANSPORT NOT a_N796_aNOT  ;
delay_666: n_885  <= TRANSPORT DIN(2)  ;
and2_667: n_886 <=  n_887  AND n_888;
delay_668: n_887  <= TRANSPORT a_N796_aNOT  ;
delay_669: n_888  <= TRANSPORT a_SINTEN_DAT_F2_G  ;
and1_670: n_889 <=  gnd;
delay_671: n_890  <= TRANSPORT CLK  ;
filter_672: FILTER_a16450

    PORT MAP (IN1 => n_890, Y => a_SINTEN_DAT_F2_G_aCLK);
dff_673: DFF_a16450

    PORT MAP ( D => a_EQ342, CLK => a_SMCNTL_DAT_F1_G_aCLK, CLRN => a_SMCNTL_DAT_F1_G_aCLRN,
          PRN => vcc, Q => a_SMCNTL_DAT_F1_G);
inv_674: a_SMCNTL_DAT_F1_G_aCLRN  <= TRANSPORT NOT MR  ;
xor2_675: a_EQ342 <=  n_901  XOR n_912;
or3_676: n_901 <=  n_902  OR n_905  OR n_908;
and2_677: n_902 <=  n_903  AND n_904;
delay_678: n_903  <= TRANSPORT a_N29_aNOT  ;
delay_679: n_904  <= TRANSPORT a_SMCNTL_DAT_F1_G  ;
and2_680: n_905 <=  n_906  AND n_907;
inv_681: n_906  <= TRANSPORT NOT a_N804  ;
delay_682: n_907  <= TRANSPORT a_SMCNTL_DAT_F1_G  ;
and3_683: n_908 <=  n_909  AND n_910  AND n_911;
delay_684: n_909  <= TRANSPORT a_N804  ;
inv_685: n_910  <= TRANSPORT NOT a_N29_aNOT  ;
delay_686: n_911  <= TRANSPORT DIN(1)  ;
and1_687: n_912 <=  gnd;
delay_688: n_913  <= TRANSPORT CLK  ;
filter_689: FILTER_a16450

    PORT MAP (IN1 => n_913, Y => a_SMCNTL_DAT_F1_G_aCLK);
dff_690: DFF_a16450

    PORT MAP ( D => a_EQ344, CLK => a_SMCNTL_DAT_F3_G_aCLK, CLRN => a_SMCNTL_DAT_F3_G_aCLRN,
          PRN => vcc, Q => a_SMCNTL_DAT_F3_G);
inv_691: a_SMCNTL_DAT_F3_G_aCLRN  <= TRANSPORT NOT MR  ;
xor2_692: a_EQ344 <=  n_921  XOR n_932;
or3_693: n_921 <=  n_922  OR n_925  OR n_928;
and2_694: n_922 <=  n_923  AND n_924;
delay_695: n_923  <= TRANSPORT a_N29_aNOT  ;
delay_696: n_924  <= TRANSPORT a_SMCNTL_DAT_F3_G  ;
and2_697: n_925 <=  n_926  AND n_927;
inv_698: n_926  <= TRANSPORT NOT a_N804  ;
delay_699: n_927  <= TRANSPORT a_SMCNTL_DAT_F3_G  ;
and3_700: n_928 <=  n_929  AND n_930  AND n_931;
delay_701: n_929  <= TRANSPORT a_N804  ;
inv_702: n_930  <= TRANSPORT NOT a_N29_aNOT  ;
delay_703: n_931  <= TRANSPORT DIN(3)  ;
and1_704: n_932 <=  gnd;
delay_705: n_933  <= TRANSPORT CLK  ;
filter_706: FILTER_a16450

    PORT MAP (IN1 => n_933, Y => a_SMCNTL_DAT_F3_G_aCLK);
dff_707: DFF_a16450

    PORT MAP ( D => a_EQ343, CLK => a_SMCNTL_DAT_F2_G_aCLK, CLRN => a_SMCNTL_DAT_F2_G_aCLRN,
          PRN => vcc, Q => a_SMCNTL_DAT_F2_G);
inv_708: a_SMCNTL_DAT_F2_G_aCLRN  <= TRANSPORT NOT MR  ;
xor2_709: a_EQ343 <=  n_941  XOR n_952;
or3_710: n_941 <=  n_942  OR n_945  OR n_948;
and2_711: n_942 <=  n_943  AND n_944;
delay_712: n_943  <= TRANSPORT a_N29_aNOT  ;
delay_713: n_944  <= TRANSPORT a_SMCNTL_DAT_F2_G  ;
and2_714: n_945 <=  n_946  AND n_947;
inv_715: n_946  <= TRANSPORT NOT a_N804  ;
delay_716: n_947  <= TRANSPORT a_SMCNTL_DAT_F2_G  ;
and3_717: n_948 <=  n_949  AND n_950  AND n_951;
delay_718: n_949  <= TRANSPORT a_N804  ;
inv_719: n_950  <= TRANSPORT NOT a_N29_aNOT  ;
delay_720: n_951  <= TRANSPORT DIN(2)  ;
and1_721: n_952 <=  gnd;
delay_722: n_953  <= TRANSPORT CLK  ;
filter_723: FILTER_a16450

    PORT MAP (IN1 => n_953, Y => a_SMCNTL_DAT_F2_G_aCLK);
dff_724: DFF_a16450

    PORT MAP ( D => a_EQ341, CLK => a_SMCNTL_DAT_F0_G_aCLK, CLRN => a_SMCNTL_DAT_F0_G_aCLRN,
          PRN => vcc, Q => a_SMCNTL_DAT_F0_G);
inv_725: a_SMCNTL_DAT_F0_G_aCLRN  <= TRANSPORT NOT MR  ;
xor2_726: a_EQ341 <=  n_961  XOR n_972;
or3_727: n_961 <=  n_962  OR n_965  OR n_968;
and2_728: n_962 <=  n_963  AND n_964;
delay_729: n_963  <= TRANSPORT a_N29_aNOT  ;
delay_730: n_964  <= TRANSPORT a_SMCNTL_DAT_F0_G  ;
and2_731: n_965 <=  n_966  AND n_967;
inv_732: n_966  <= TRANSPORT NOT a_N804  ;
delay_733: n_967  <= TRANSPORT a_SMCNTL_DAT_F0_G  ;
and3_734: n_968 <=  n_969  AND n_970  AND n_971;
delay_735: n_969  <= TRANSPORT a_N804  ;
inv_736: n_970  <= TRANSPORT NOT a_N29_aNOT  ;
delay_737: n_971  <= TRANSPORT DIN(0)  ;
and1_738: n_972 <=  gnd;
delay_739: n_973  <= TRANSPORT CLK  ;
filter_740: FILTER_a16450

    PORT MAP (IN1 => n_973, Y => a_SMCNTL_DAT_F0_G_aCLK);
delay_741: a_LC4_B19  <= TRANSPORT a_EQ034  ;
xor2_742: a_EQ034 <=  n_977  XOR n_986;
or2_743: n_977 <=  n_978  OR n_981;
and2_744: n_978 <=  n_979  AND n_980;
inv_745: n_979  <= TRANSPORT NOT a_N29_aNOT  ;
delay_746: n_980  <= TRANSPORT a_SMCNTL_DAT_F0_G  ;
and2_747: n_981 <=  n_982  AND n_984;
inv_748: n_982  <= TRANSPORT NOT a_SINTID_DAT_F0_G_aNOT  ;
delay_749: n_984  <= TRANSPORT a_N31  ;
and1_750: n_986 <=  gnd;
delay_751: a_LC5_B19  <= TRANSPORT a_EQ035  ;
xor2_752: a_EQ035 <=  n_989  XOR n_997;
or2_753: n_989 <=  n_990  OR n_992;
and1_754: n_990 <=  n_991;
delay_755: n_991  <= TRANSPORT a_LC4_B19  ;
and2_756: n_992 <=  n_993  AND n_995;
delay_757: n_993  <= TRANSPORT a_N30  ;
delay_758: n_995  <= TRANSPORT a_SMSTAT_DAT_F0_G  ;
and1_759: n_997 <=  gnd;
delay_760: a_LC6_B19  <= TRANSPORT a_EQ036  ;
xor2_761: a_EQ036 <=  n_1000  XOR n_1008;
or2_762: n_1000 <=  n_1001  OR n_1004;
and2_763: n_1001 <=  n_1002  AND n_1003;
delay_764: n_1002  <= TRANSPORT a_N33  ;
delay_765: n_1003  <= TRANSPORT a_SLSTAT_DAT_F0_G  ;
and2_766: n_1004 <=  n_1005  AND n_1006;
delay_767: n_1005  <= TRANSPORT a_N32  ;
delay_768: n_1006  <= TRANSPORT a_N1320  ;
and1_769: n_1008 <=  gnd;
delay_770: a_LC3_B19  <= TRANSPORT a_EQ037  ;
xor2_771: a_EQ037 <=  n_1011  XOR n_1020;
or3_772: n_1011 <=  n_1012  OR n_1014  OR n_1016;
and1_773: n_1012 <=  n_1013;
delay_774: n_1013  <= TRANSPORT a_LC5_B19  ;
and1_775: n_1014 <=  n_1015;
delay_776: n_1015  <= TRANSPORT a_LC6_B19  ;
and2_777: n_1016 <=  n_1017  AND n_1018;
delay_778: n_1017  <= TRANSPORT a_N35  ;
delay_779: n_1018  <= TRANSPORT a_SLCNTL_DOUT_F0_G  ;
and1_780: n_1020 <=  gnd;
delay_781: a_LC4_B13  <= TRANSPORT a_EQ038  ;
xor2_782: a_EQ038 <=  n_1023  XOR n_1033;
or2_783: n_1023 <=  n_1024  OR n_1029;
and3_784: n_1024 <=  n_1025  AND n_1026  AND n_1028;
delay_785: n_1025  <= TRANSPORT a_N21  ;
delay_786: n_1026  <= TRANSPORT a_SREC_DAT_F0_G  ;
inv_787: n_1028  <= TRANSPORT NOT a_SLCNTL_DOUT_F7_G  ;
and3_788: n_1029 <=  n_1030  AND n_1031  AND n_1032;
delay_789: n_1030  <= TRANSPORT a_N21  ;
delay_790: n_1031  <= TRANSPORT a_SLCNTL_DOUT_F7_G  ;
delay_791: n_1032  <= TRANSPORT a_SDLSB_DAT_F0_G  ;
and1_792: n_1033 <=  gnd;
delay_793: a_LC3_B13  <= TRANSPORT a_EQ033  ;
xor2_794: a_EQ033 <=  n_1036  XOR n_1044;
or2_795: n_1036 <=  n_1037  OR n_1041;
and2_796: n_1037 <=  n_1038  AND n_1040;
delay_797: n_1038  <= TRANSPORT a_SDMSB_DAT_F0_G  ;
delay_798: n_1040  <= TRANSPORT a_SLCNTL_DOUT_F7_G  ;
and2_799: n_1041 <=  n_1042  AND n_1043;
inv_800: n_1042  <= TRANSPORT NOT a_SLCNTL_DOUT_F7_G  ;
delay_801: n_1043  <= TRANSPORT a_SINTEN_DAT_F0_G  ;
and1_802: n_1044 <=  gnd;
delay_803: a_G161  <= TRANSPORT a_EQ039  ;
xor2_804: a_EQ039 <=  n_1046  XOR n_1055;
or3_805: n_1046 <=  n_1047  OR n_1049  OR n_1051;
and1_806: n_1047 <=  n_1048;
delay_807: n_1048  <= TRANSPORT a_LC3_B19  ;
and1_808: n_1049 <=  n_1050;
delay_809: n_1050  <= TRANSPORT a_LC4_B13  ;
and2_810: n_1051 <=  n_1052  AND n_1054;
inv_811: n_1052  <= TRANSPORT NOT a_N34_aNOT  ;
delay_812: n_1054  <= TRANSPORT a_LC3_B13  ;
and1_813: n_1055 <=  gnd;
delay_814: a_LC3_B9  <= TRANSPORT a_EQ014  ;
xor2_815: a_EQ014 <=  n_1058  XOR n_1066;
or2_816: n_1058 <=  n_1059  OR n_1063;
and2_817: n_1059 <=  n_1060  AND n_1061;
delay_818: n_1060  <= TRANSPORT a_N35  ;
delay_819: n_1061  <= TRANSPORT a_SLCNTL_DOUT_F1_G  ;
and2_820: n_1063 <=  n_1064  AND n_1065;
inv_821: n_1064  <= TRANSPORT NOT a_N29_aNOT  ;
delay_822: n_1065  <= TRANSPORT a_SMCNTL_DAT_F1_G  ;
and1_823: n_1066 <=  gnd;
delay_824: a_LC2_B9  <= TRANSPORT a_EQ015  ;
xor2_825: a_EQ015 <=  n_1069  XOR n_1076;
or2_826: n_1069 <=  n_1070  OR n_1072;
and1_827: n_1070 <=  n_1071;
delay_828: n_1071  <= TRANSPORT a_LC3_B9  ;
and2_829: n_1072 <=  n_1073  AND n_1074;
delay_830: n_1073  <= TRANSPORT a_N32  ;
delay_831: n_1074  <= TRANSPORT a_N1319  ;
and1_832: n_1076 <=  gnd;
delay_833: a_LC4_B2  <= TRANSPORT a_EQ016  ;
xor2_834: a_EQ016 <=  n_1079  XOR n_1087;
or2_835: n_1079 <=  n_1080  OR n_1083;
and2_836: n_1080 <=  n_1081  AND n_1082;
delay_837: n_1081  <= TRANSPORT a_N33  ;
delay_838: n_1082  <= TRANSPORT a_SLSTAT_DAT_F1_G  ;
and2_839: n_1083 <=  n_1084  AND n_1085;
delay_840: n_1084  <= TRANSPORT a_N31  ;
delay_841: n_1085  <= TRANSPORT a_SINTID_DAT_F1_G  ;
and1_842: n_1087 <=  gnd;
delay_843: a_LC1_B9  <= TRANSPORT a_EQ017  ;
xor2_844: a_EQ017 <=  n_1090  XOR n_1099;
or3_845: n_1090 <=  n_1091  OR n_1093  OR n_1095;
and1_846: n_1091 <=  n_1092;
delay_847: n_1092  <= TRANSPORT a_LC2_B9  ;
and1_848: n_1093 <=  n_1094;
delay_849: n_1094  <= TRANSPORT a_LC4_B2  ;
and2_850: n_1095 <=  n_1096  AND n_1097;
delay_851: n_1096  <= TRANSPORT a_N30  ;
delay_852: n_1097  <= TRANSPORT a_SMSTAT_DAT_F1_G  ;
and1_853: n_1099 <=  gnd;
delay_854: a_N837_aNOT  <= TRANSPORT a_EQ250  ;
xor2_855: a_EQ250 <=  n_1102  XOR n_1112;
or2_856: n_1102 <=  n_1103  OR n_1108;
and3_857: n_1103 <=  n_1104  AND n_1105  AND n_1107;
delay_858: n_1104  <= TRANSPORT a_N21  ;
delay_859: n_1105  <= TRANSPORT a_SREC_DAT_F1_G  ;
inv_860: n_1107  <= TRANSPORT NOT a_SLCNTL_DOUT_F7_G  ;
and3_861: n_1108 <=  n_1109  AND n_1110  AND n_1111;
delay_862: n_1109  <= TRANSPORT a_N21  ;
delay_863: n_1110  <= TRANSPORT a_SLCNTL_DOUT_F7_G  ;
delay_864: n_1111  <= TRANSPORT a_SDLSB_DAT_F1_G  ;
and1_865: n_1112 <=  gnd;
delay_866: a_N469  <= TRANSPORT a_EQ191  ;
xor2_867: a_EQ191 <=  n_1115  XOR n_1124;
or2_868: n_1115 <=  n_1116  OR n_1120;
and2_869: n_1116 <=  n_1117  AND n_1119;
delay_870: n_1117  <= TRANSPORT a_SDMSB_DAT_F1_G  ;
delay_871: n_1119  <= TRANSPORT a_SLCNTL_DOUT_F7_G  ;
and2_872: n_1120 <=  n_1121  AND n_1122;
inv_873: n_1121  <= TRANSPORT NOT a_SLCNTL_DOUT_F7_G  ;
delay_874: n_1122  <= TRANSPORT a_SINTEN_DAT_F1_G  ;
and1_875: n_1124 <=  gnd;
delay_876: a_LC4_B9  <= TRANSPORT a_EQ013  ;
xor2_877: a_EQ013 <=  n_1126  XOR n_1134;
or3_878: n_1126 <=  n_1127  OR n_1129  OR n_1131;
and1_879: n_1127 <=  n_1128;
delay_880: n_1128  <= TRANSPORT a_LC1_B9  ;
and1_881: n_1129 <=  n_1130;
delay_882: n_1130  <= TRANSPORT a_N837_aNOT  ;
and2_883: n_1131 <=  n_1132  AND n_1133;
inv_884: n_1132  <= TRANSPORT NOT a_N34_aNOT  ;
delay_885: n_1133  <= TRANSPORT a_N469  ;
and1_886: n_1134 <=  gnd;
delay_887: a_LC7_B20  <= TRANSPORT a_EQ041  ;
xor2_888: a_EQ041 <=  n_1137  XOR n_1145;
or2_889: n_1137 <=  n_1138  OR n_1141;
and2_890: n_1138 <=  n_1139  AND n_1140;
inv_891: n_1139  <= TRANSPORT NOT a_N29_aNOT  ;
delay_892: n_1140  <= TRANSPORT a_SMCNTL_DAT_F2_G  ;
and2_893: n_1141 <=  n_1142  AND n_1144;
delay_894: n_1142  <= TRANSPORT a_SINTID_DAT_F2_G  ;
delay_895: n_1144  <= TRANSPORT a_N31  ;
and1_896: n_1145 <=  gnd;
delay_897: a_LC6_B20  <= TRANSPORT a_EQ042  ;
xor2_898: a_EQ042 <=  n_1148  XOR n_1155;
or2_899: n_1148 <=  n_1149  OR n_1151;
and1_900: n_1149 <=  n_1150;
delay_901: n_1150  <= TRANSPORT a_LC7_B20  ;
and2_902: n_1151 <=  n_1152  AND n_1153;
delay_903: n_1152  <= TRANSPORT a_N30  ;
delay_904: n_1153  <= TRANSPORT a_SMSTAT_DAT_F2_G  ;
and1_905: n_1155 <=  gnd;
delay_906: a_LC4_B20  <= TRANSPORT a_EQ043  ;
xor2_907: a_EQ043 <=  n_1158  XOR n_1166;
or2_908: n_1158 <=  n_1159  OR n_1162;
and2_909: n_1159 <=  n_1160  AND n_1161;
delay_910: n_1160  <= TRANSPORT a_N33  ;
delay_911: n_1161  <= TRANSPORT a_SLSTAT_DAT_F2_G  ;
and2_912: n_1162 <=  n_1163  AND n_1164;
delay_913: n_1163  <= TRANSPORT a_N32  ;
delay_914: n_1164  <= TRANSPORT a_N1318  ;
and1_915: n_1166 <=  gnd;
delay_916: a_LC5_B20  <= TRANSPORT a_EQ044  ;
xor2_917: a_EQ044 <=  n_1169  XOR n_1178;
or3_918: n_1169 <=  n_1170  OR n_1172  OR n_1174;
and1_919: n_1170 <=  n_1171;
delay_920: n_1171  <= TRANSPORT a_LC6_B20  ;
and1_921: n_1172 <=  n_1173;
delay_922: n_1173  <= TRANSPORT a_LC4_B20  ;
and2_923: n_1174 <=  n_1175  AND n_1176;
delay_924: n_1175  <= TRANSPORT a_N35  ;
delay_925: n_1176  <= TRANSPORT a_SLCNTL_DOUT_F2_G  ;
and1_926: n_1178 <=  gnd;
delay_927: a_LC2_B14  <= TRANSPORT a_EQ045  ;
xor2_928: a_EQ045 <=  n_1181  XOR n_1191;
or2_929: n_1181 <=  n_1182  OR n_1186;
and3_930: n_1182 <=  n_1183  AND n_1184  AND n_1185;
delay_931: n_1183  <= TRANSPORT a_N21  ;
delay_932: n_1184  <= TRANSPORT a_SLCNTL_DOUT_F7_G  ;
delay_933: n_1185  <= TRANSPORT a_SDLSB_DAT_F2_G  ;
and3_934: n_1186 <=  n_1187  AND n_1188  AND n_1190;
delay_935: n_1187  <= TRANSPORT a_N21  ;
delay_936: n_1188  <= TRANSPORT a_SREC_DAT_F2_G  ;
inv_937: n_1190  <= TRANSPORT NOT a_SLCNTL_DOUT_F7_G  ;
and1_938: n_1191 <=  gnd;
delay_939: a_LC4_B14  <= TRANSPORT a_EQ040  ;
xor2_940: a_EQ040 <=  n_1194  XOR n_1202;
or2_941: n_1194 <=  n_1195  OR n_1199;
and2_942: n_1195 <=  n_1196  AND n_1198;
delay_943: n_1196  <= TRANSPORT a_SDMSB_DAT_F2_G  ;
delay_944: n_1198  <= TRANSPORT a_SLCNTL_DOUT_F7_G  ;
and2_945: n_1199 <=  n_1200  AND n_1201;
inv_946: n_1200  <= TRANSPORT NOT a_SLCNTL_DOUT_F7_G  ;
delay_947: n_1201  <= TRANSPORT a_SINTEN_DAT_F2_G  ;
and1_948: n_1202 <=  gnd;
delay_949: a_G513  <= TRANSPORT a_EQ046  ;
xor2_950: a_EQ046 <=  n_1204  XOR n_1212;
or3_951: n_1204 <=  n_1205  OR n_1207  OR n_1209;
and1_952: n_1205 <=  n_1206;
delay_953: n_1206  <= TRANSPORT a_LC5_B20  ;
and1_954: n_1207 <=  n_1208;
delay_955: n_1208  <= TRANSPORT a_LC2_B14  ;
and2_956: n_1209 <=  n_1210  AND n_1211;
inv_957: n_1210  <= TRANSPORT NOT a_N34_aNOT  ;
delay_958: n_1211  <= TRANSPORT a_LC4_B14  ;
and1_959: n_1212 <=  gnd;
delay_960: a_LC5_B5  <= TRANSPORT a_EQ028  ;
xor2_961: a_EQ028 <=  n_1215  XOR n_1223;
or2_962: n_1215 <=  n_1216  OR n_1220;
and2_963: n_1216 <=  n_1217  AND n_1218;
delay_964: n_1217  <= TRANSPORT a_N30  ;
delay_965: n_1218  <= TRANSPORT a_SMSTAT_DAT_F3_G  ;
and2_966: n_1220 <=  n_1221  AND n_1222;
delay_967: n_1221  <= TRANSPORT a_N35  ;
delay_968: n_1222  <= TRANSPORT a_SLCNTL_DOUT_F3_G  ;
and1_969: n_1223 <=  gnd;
delay_970: a_LC3_B5  <= TRANSPORT a_EQ029  ;
xor2_971: a_EQ029 <=  n_1226  XOR n_1233;
or2_972: n_1226 <=  n_1227  OR n_1229;
and1_973: n_1227 <=  n_1228;
delay_974: n_1228  <= TRANSPORT a_LC5_B5  ;
and2_975: n_1229 <=  n_1230  AND n_1231;
delay_976: n_1230  <= TRANSPORT a_N32  ;
delay_977: n_1231  <= TRANSPORT a_N1317  ;
and1_978: n_1233 <=  gnd;
delay_979: a_LC2_B5  <= TRANSPORT a_EQ030  ;
xor2_980: a_EQ030 <=  n_1236  XOR n_1242;
or2_981: n_1236 <=  n_1237  OR n_1239;
and1_982: n_1237 <=  n_1238;
delay_983: n_1238  <= TRANSPORT a_LC3_B5  ;
and2_984: n_1239 <=  n_1240  AND n_1241;
delay_985: n_1240  <= TRANSPORT a_N33  ;
delay_986: n_1241  <= TRANSPORT a_SLSTAT_DAT_F3_G  ;
and1_987: n_1242 <=  gnd;
delay_988: a_LC4_B5  <= TRANSPORT a_EQ031  ;
xor2_989: a_EQ031 <=  n_1245  XOR n_1251;
or2_990: n_1245 <=  n_1246  OR n_1248;
and1_991: n_1246 <=  n_1247;
delay_992: n_1247  <= TRANSPORT a_LC2_B5  ;
and2_993: n_1248 <=  n_1249  AND n_1250;
inv_994: n_1249  <= TRANSPORT NOT a_N29_aNOT  ;
delay_995: n_1250  <= TRANSPORT a_SMCNTL_DAT_F3_G  ;
and1_996: n_1251 <=  gnd;
delay_997: a_LC2_B13  <= TRANSPORT a_EQ027  ;
xor2_998: a_EQ027 <=  n_1254  XOR n_1264;
or2_999: n_1254 <=  n_1255  OR n_1260;
and3_1000: n_1255 <=  n_1256  AND n_1257  AND n_1259;
delay_1001: n_1256  <= TRANSPORT a_N21  ;
delay_1002: n_1257  <= TRANSPORT a_SREC_DAT_F3_G  ;
inv_1003: n_1259  <= TRANSPORT NOT a_SLCNTL_DOUT_F7_G  ;
and3_1004: n_1260 <=  n_1261  AND n_1262  AND n_1263;
delay_1005: n_1261  <= TRANSPORT a_N21  ;
delay_1006: n_1262  <= TRANSPORT a_SLCNTL_DOUT_F7_G  ;
delay_1007: n_1263  <= TRANSPORT a_SDLSB_DAT_F3_G  ;
and1_1008: n_1264 <=  gnd;
delay_1009: a_LC1_B13  <= TRANSPORT a_EQ026  ;
xor2_1010: a_EQ026 <=  n_1267  XOR n_1276;
or2_1011: n_1267 <=  n_1268  OR n_1272;
and2_1012: n_1268 <=  n_1269  AND n_1270;
inv_1013: n_1269  <= TRANSPORT NOT a_SLCNTL_DOUT_F7_G  ;
delay_1014: n_1270  <= TRANSPORT a_SINTEN_DAT_F3_G  ;
and2_1015: n_1272 <=  n_1273  AND n_1275;
delay_1016: n_1273  <= TRANSPORT a_SDMSB_DAT_F3_G  ;
delay_1017: n_1275  <= TRANSPORT a_SLCNTL_DOUT_F7_G  ;
and1_1018: n_1276 <=  gnd;
delay_1019: a_G103  <= TRANSPORT a_EQ032  ;
xor2_1020: a_EQ032 <=  n_1278  XOR n_1286;
or3_1021: n_1278 <=  n_1279  OR n_1281  OR n_1283;
and1_1022: n_1279 <=  n_1280;
delay_1023: n_1280  <= TRANSPORT a_LC4_B5  ;
and1_1024: n_1281 <=  n_1282;
delay_1025: n_1282  <= TRANSPORT a_LC2_B13  ;
and2_1026: n_1283 <=  n_1284  AND n_1285;
inv_1027: n_1284  <= TRANSPORT NOT a_N34_aNOT  ;
delay_1028: n_1285  <= TRANSPORT a_LC1_B13  ;
and1_1029: n_1286 <=  gnd;
delay_1030: a_LC6_C7  <= TRANSPORT a_EQ050  ;
xor2_1031: a_EQ050 <=  n_1289  XOR n_1298;
or2_1032: n_1289 <=  n_1290  OR n_1295;
and2_1033: n_1290 <=  n_1291  AND n_1293;
inv_1034: n_1291  <= TRANSPORT NOT a_LC1_B18  ;
delay_1035: n_1293  <= TRANSPORT a_SDMSB_DAT_F4_G  ;
and2_1036: n_1295 <=  n_1296  AND n_1297;
delay_1037: n_1296  <= TRANSPORT a_N33  ;
delay_1038: n_1297  <= TRANSPORT a_SLSTAT_DAT_F4_G  ;
and1_1039: n_1298 <=  gnd;
delay_1040: a_LC5_A12  <= TRANSPORT a_EQ047  ;
xor2_1041: a_EQ047 <=  n_1301  XOR n_1312;
or2_1042: n_1301 <=  n_1302  OR n_1307;
and3_1043: n_1302 <=  n_1303  AND n_1304  AND n_1306;
delay_1044: n_1303  <= TRANSPORT a_N21  ;
delay_1045: n_1304  <= TRANSPORT a_SREC_DAT_F4_G  ;
inv_1046: n_1306  <= TRANSPORT NOT a_SLCNTL_DOUT_F7_G  ;
and3_1047: n_1307 <=  n_1308  AND n_1309  AND n_1311;
delay_1048: n_1308  <= TRANSPORT a_N21  ;
delay_1049: n_1309  <= TRANSPORT a_SDLSB_DAT_F4_G  ;
delay_1050: n_1311  <= TRANSPORT a_SLCNTL_DOUT_F7_G  ;
and1_1051: n_1312 <=  gnd;
delay_1052: a_LC3_C7  <= TRANSPORT a_EQ048  ;
xor2_1053: a_EQ048 <=  n_1315  XOR n_1323;
or2_1054: n_1315 <=  n_1316  OR n_1320;
and2_1055: n_1316 <=  n_1317  AND n_1318;
delay_1056: n_1317  <= TRANSPORT a_N32  ;
delay_1057: n_1318  <= TRANSPORT a_N1316  ;
and2_1058: n_1320 <=  n_1321  AND n_1322;
inv_1059: n_1321  <= TRANSPORT NOT a_N29_aNOT  ;
delay_1060: n_1322  <= TRANSPORT en_lpbk  ;
and1_1061: n_1323 <=  gnd;
dff_1062: DFF_a16450

    PORT MAP ( D => a_EQ246, CLK => a_SMSTAT_DAT_F4_G_aCLK, CLRN => a_SMSTAT_DAT_F4_G_aCLRN,
          PRN => vcc, Q => a_SMSTAT_DAT_F4_G);
inv_1063: a_SMSTAT_DAT_F4_G_aCLRN  <= TRANSPORT NOT MR  ;
xor2_1064: a_EQ246 <=  n_1331  XOR n_1339;
or2_1065: n_1331 <=  n_1332  OR n_1335;
and2_1066: n_1332 <=  n_1333  AND n_1334;
delay_1067: n_1333  <= TRANSPORT en_lpbk  ;
delay_1068: n_1334  <= TRANSPORT a_SMCNTL_DAT_F0_G  ;
and2_1069: n_1335 <=  n_1336  AND n_1338;
inv_1070: n_1336  <= TRANSPORT NOT nCTS  ;
inv_1071: n_1338  <= TRANSPORT NOT en_lpbk  ;
and1_1072: n_1339 <=  gnd;
delay_1073: n_1340  <= TRANSPORT CLK  ;
filter_1074: FILTER_a16450

    PORT MAP (IN1 => n_1340, Y => a_SMSTAT_DAT_F4_G_aCLK);
delay_1075: a_LC1_C7  <= TRANSPORT a_EQ049  ;
xor2_1076: a_EQ049 <=  n_1344  XOR n_1352;
or3_1077: n_1344 <=  n_1345  OR n_1347  OR n_1349;
and1_1078: n_1345 <=  n_1346;
delay_1079: n_1346  <= TRANSPORT a_LC5_A12  ;
and1_1080: n_1347 <=  n_1348;
delay_1081: n_1348  <= TRANSPORT a_LC3_C7  ;
and2_1082: n_1349 <=  n_1350  AND n_1351;
delay_1083: n_1350  <= TRANSPORT a_N30  ;
delay_1084: n_1351  <= TRANSPORT a_SMSTAT_DAT_F4_G  ;
and1_1085: n_1352 <=  gnd;
delay_1086: a_G764  <= TRANSPORT a_EQ051  ;
xor2_1087: a_EQ051 <=  n_1354  XOR n_1362;
or3_1088: n_1354 <=  n_1355  OR n_1357  OR n_1359;
and1_1089: n_1355 <=  n_1356;
delay_1090: n_1356  <= TRANSPORT a_LC6_C7  ;
and1_1091: n_1357 <=  n_1358;
delay_1092: n_1358  <= TRANSPORT a_LC1_C7  ;
and2_1093: n_1359 <=  n_1360  AND n_1361;
delay_1094: n_1360  <= TRANSPORT a_N35  ;
delay_1095: n_1361  <= TRANSPORT a_SLCNTL_DOUT_F4_G  ;
and1_1096: n_1362 <=  gnd;
delay_1097: a_LC3_C8  <= TRANSPORT a_EQ022  ;
xor2_1098: a_EQ022 <=  n_1365  XOR n_1374;
or2_1099: n_1365 <=  n_1366  OR n_1370;
and2_1100: n_1366 <=  n_1367  AND n_1368;
inv_1101: n_1367  <= TRANSPORT NOT a_LC1_B18  ;
delay_1102: n_1368  <= TRANSPORT a_SDMSB_DAT_F5_G  ;
and2_1103: n_1370 <=  n_1371  AND n_1372;
delay_1104: n_1371  <= TRANSPORT a_N32  ;
delay_1105: n_1372  <= TRANSPORT a_N1315  ;
and1_1106: n_1374 <=  gnd;
dff_1107: DFF_a16450

    PORT MAP ( D => a_EQ247, CLK => a_SMSTAT_DAT_F5_G_aCLK, CLRN => a_SMSTAT_DAT_F5_G_aCLRN,
          PRN => vcc, Q => a_SMSTAT_DAT_F5_G);
inv_1108: a_SMSTAT_DAT_F5_G_aCLRN  <= TRANSPORT NOT MR  ;
xor2_1109: a_EQ247 <=  n_1382  XOR n_1390;
or2_1110: n_1382 <=  n_1383  OR n_1386;
and2_1111: n_1383 <=  n_1384  AND n_1385;
delay_1112: n_1384  <= TRANSPORT en_lpbk  ;
delay_1113: n_1385  <= TRANSPORT a_SMCNTL_DAT_F1_G  ;
and2_1114: n_1386 <=  n_1387  AND n_1389;
inv_1115: n_1387  <= TRANSPORT NOT nDSR  ;
inv_1116: n_1389  <= TRANSPORT NOT en_lpbk  ;
and1_1117: n_1390 <=  gnd;
delay_1118: n_1391  <= TRANSPORT CLK  ;
filter_1119: FILTER_a16450

    PORT MAP (IN1 => n_1391, Y => a_SMSTAT_DAT_F5_G_aCLK);
delay_1120: a_LC2_C8  <= TRANSPORT a_EQ024  ;
xor2_1121: a_EQ024 <=  n_1395  XOR n_1403;
or2_1122: n_1395 <=  n_1396  OR n_1400;
and2_1123: n_1396 <=  n_1397  AND n_1399;
inv_1124: n_1397  <= TRANSPORT NOT a_SLSTAT_DAT_F5_G_aNOT  ;
delay_1125: n_1399  <= TRANSPORT a_N33  ;
and2_1126: n_1400 <=  n_1401  AND n_1402;
delay_1127: n_1401  <= TRANSPORT a_N30  ;
delay_1128: n_1402  <= TRANSPORT a_SMSTAT_DAT_F5_G  ;
and1_1129: n_1403 <=  gnd;
delay_1130: a_LC8_A6  <= TRANSPORT a_EQ023  ;
xor2_1131: a_EQ023 <=  n_1406  XOR n_1415;
or2_1132: n_1406 <=  n_1407  OR n_1411;
and2_1133: n_1407 <=  n_1408  AND n_1410;
delay_1134: n_1408  <= TRANSPORT a_SREC_DAT_F5_G  ;
inv_1135: n_1410  <= TRANSPORT NOT a_SLCNTL_DOUT_F7_G  ;
and2_1136: n_1411 <=  n_1412  AND n_1414;
delay_1137: n_1412  <= TRANSPORT a_SDLSB_DAT_F5_G  ;
delay_1138: n_1414  <= TRANSPORT a_SLCNTL_DOUT_F7_G  ;
and1_1139: n_1415 <=  gnd;
delay_1140: a_LC4_C8  <= TRANSPORT a_EQ025  ;
xor2_1141: a_EQ025 <=  n_1418  XOR n_1424;
or2_1142: n_1418 <=  n_1419  OR n_1421;
and1_1143: n_1419 <=  n_1420;
delay_1144: n_1420  <= TRANSPORT a_LC2_C8  ;
and2_1145: n_1421 <=  n_1422  AND n_1423;
delay_1146: n_1422  <= TRANSPORT a_N21  ;
delay_1147: n_1423  <= TRANSPORT a_LC8_A6  ;
and1_1148: n_1424 <=  gnd;
delay_1149: a_LC6_C8  <= TRANSPORT a_EQ021  ;
xor2_1150: a_EQ021 <=  n_1426  XOR n_1434;
or3_1151: n_1426 <=  n_1427  OR n_1429  OR n_1431;
and1_1152: n_1427 <=  n_1428;
delay_1153: n_1428  <= TRANSPORT a_LC3_C8  ;
and1_1154: n_1429 <=  n_1430;
delay_1155: n_1430  <= TRANSPORT a_LC4_C8  ;
and2_1156: n_1431 <=  n_1432  AND n_1433;
delay_1157: n_1432  <= TRANSPORT a_N35  ;
delay_1158: n_1433  <= TRANSPORT a_SLCNTL_DOUT_F5_G  ;
and1_1159: n_1434 <=  gnd;
delay_1160: a_LC5_B12  <= TRANSPORT a_EQ052  ;
xor2_1161: a_EQ052 <=  n_1437  XOR n_1446;
or2_1162: n_1437 <=  n_1438  OR n_1442;
and2_1163: n_1438 <=  n_1439  AND n_1441;
delay_1164: n_1439  <= TRANSPORT a_SDMSB_DAT_F6_G  ;
delay_1165: n_1441  <= TRANSPORT a_N1312  ;
and2_1166: n_1442 <=  n_1443  AND n_1445;
delay_1167: n_1443  <= TRANSPORT a_SDLSB_DAT_F6_G  ;
inv_1168: n_1445  <= TRANSPORT NOT a_N1312  ;
and1_1169: n_1446 <=  gnd;
delay_1170: a_LC4_B12  <= TRANSPORT a_EQ053  ;
xor2_1171: a_EQ053 <=  n_1449  XOR n_1458;
or2_1172: n_1449 <=  n_1450  OR n_1453;
and2_1173: n_1450 <=  n_1451  AND n_1452;
delay_1174: n_1451  <= TRANSPORT a_SLCNTL_DOUT_F7_G  ;
delay_1175: n_1452  <= TRANSPORT a_LC5_B12  ;
and3_1176: n_1453 <=  n_1454  AND n_1456  AND n_1457;
delay_1177: n_1454  <= TRANSPORT a_SREC_DAT_F6_G  ;
inv_1178: n_1456  <= TRANSPORT NOT a_SLCNTL_DOUT_F7_G  ;
inv_1179: n_1457  <= TRANSPORT NOT a_N1312  ;
and1_1180: n_1458 <=  gnd;
delay_1181: a_LC2_C18  <= TRANSPORT a_LC2_C18_aIN  ;
xor2_1182: a_LC2_C18_aIN <=  n_1461  XOR n_1466;
or1_1183: n_1461 <=  n_1462;
and3_1184: n_1462 <=  n_1463  AND n_1464  AND n_1465;
inv_1185: n_1463  <= TRANSPORT NOT a_SLSTAT_DAT_F5_G_aNOT  ;
delay_1186: n_1464  <= TRANSPORT a_N1310  ;
delay_1187: n_1465  <= TRANSPORT a_N1312  ;
and1_1188: n_1466 <=  gnd;
delay_1189: a_LC4_C18  <= TRANSPORT a_EQ054  ;
xor2_1190: a_EQ054 <=  n_1469  XOR n_1477;
or2_1191: n_1469 <=  n_1470  OR n_1473;
and2_1192: n_1470 <=  n_1471  AND n_1472;
inv_1193: n_1471  <= TRANSPORT NOT a_N1310  ;
delay_1194: n_1472  <= TRANSPORT a_LC4_B12  ;
and2_1195: n_1473 <=  n_1474  AND n_1476;
inv_1196: n_1474  <= TRANSPORT NOT a_N20_aNOT  ;
delay_1197: n_1476  <= TRANSPORT a_LC2_C18  ;
and1_1198: n_1477 <=  gnd;
delay_1199: a_N292_aNOT  <= TRANSPORT a_EQ158  ;
xor2_1200: a_EQ158 <=  n_1480  XOR n_1488;
or2_1201: n_1480 <=  n_1481  OR n_1485;
and2_1202: n_1481 <=  n_1482  AND n_1484;
delay_1203: n_1482  <= TRANSPORT a_N1314  ;
delay_1204: n_1484  <= TRANSPORT a_N1310  ;
and2_1205: n_1485 <=  n_1486  AND n_1487;
delay_1206: n_1486  <= TRANSPORT a_SLCNTL_DOUT_F6_G  ;
inv_1207: n_1487  <= TRANSPORT NOT a_N1310  ;
and1_1208: n_1488 <=  gnd;
dff_1209: DFF_a16450

    PORT MAP ( D => a_EQ248, CLK => a_SMSTAT_DAT_F6_G_aCLK, CLRN => a_SMSTAT_DAT_F6_G_aCLRN,
          PRN => vcc, Q => a_SMSTAT_DAT_F6_G);
inv_1210: a_SMSTAT_DAT_F6_G_aCLRN  <= TRANSPORT NOT MR  ;
xor2_1211: a_EQ248 <=  n_1496  XOR n_1504;
or2_1212: n_1496 <=  n_1497  OR n_1500;
and2_1213: n_1497 <=  n_1498  AND n_1499;
delay_1214: n_1498  <= TRANSPORT en_lpbk  ;
delay_1215: n_1499  <= TRANSPORT a_SMCNTL_DAT_F2_G  ;
and2_1216: n_1500 <=  n_1501  AND n_1503;
inv_1217: n_1501  <= TRANSPORT NOT nRI  ;
inv_1218: n_1503  <= TRANSPORT NOT en_lpbk  ;
and1_1219: n_1504 <=  gnd;
delay_1220: n_1505  <= TRANSPORT CLK  ;
filter_1221: FILTER_a16450

    PORT MAP (IN1 => n_1505, Y => a_SMSTAT_DAT_F6_G_aCLK);
delay_1222: a_LC3_C18  <= TRANSPORT a_EQ055  ;
xor2_1223: a_EQ055 <=  n_1509  XOR n_1517;
or2_1224: n_1509 <=  n_1510  OR n_1513;
and2_1225: n_1510 <=  n_1511  AND n_1512;
delay_1226: n_1511  <= TRANSPORT a_N1312  ;
delay_1227: n_1512  <= TRANSPORT a_N292_aNOT  ;
and3_1228: n_1513 <=  n_1514  AND n_1515  AND n_1516;
delay_1229: n_1514  <= TRANSPORT a_N1310  ;
inv_1230: n_1515  <= TRANSPORT NOT a_N1312  ;
delay_1231: n_1516  <= TRANSPORT a_SMSTAT_DAT_F6_G  ;
and1_1232: n_1517 <=  gnd;
delay_1233: a_G770  <= TRANSPORT a_EQ056  ;
xor2_1234: a_EQ056 <=  n_1519  XOR n_1526;
or2_1235: n_1519 <=  n_1520  OR n_1523;
and2_1236: n_1520 <=  n_1521  AND n_1522;
inv_1237: n_1521  <= TRANSPORT NOT a_N1311  ;
delay_1238: n_1522  <= TRANSPORT a_LC4_C18  ;
and2_1239: n_1523 <=  n_1524  AND n_1525;
delay_1240: n_1524  <= TRANSPORT a_N1311  ;
delay_1241: n_1525  <= TRANSPORT a_LC3_C18  ;
and1_1242: n_1526 <=  gnd;
delay_1243: a_LC3_A11  <= TRANSPORT a_EQ019  ;
xor2_1244: a_EQ019 <=  n_1529  XOR n_1538;
or2_1245: n_1529 <=  n_1530  OR n_1534;
and2_1246: n_1530 <=  n_1531  AND n_1533;
delay_1247: n_1531  <= TRANSPORT a_SREC_DAT_F7_G  ;
inv_1248: n_1533  <= TRANSPORT NOT a_SLCNTL_DOUT_F7_G  ;
and2_1249: n_1534 <=  n_1535  AND n_1537;
delay_1250: n_1535  <= TRANSPORT a_SDLSB_DAT_F7_G  ;
delay_1251: n_1537  <= TRANSPORT a_SLCNTL_DOUT_F7_G  ;
and1_1252: n_1538 <=  gnd;
dff_1253: DFF_a16450

    PORT MAP ( D => a_EQ249, CLK => a_SMSTAT_DAT_F7_G_aCLK, CLRN => a_SMSTAT_DAT_F7_G_aCLRN,
          PRN => vcc, Q => a_SMSTAT_DAT_F7_G);
inv_1254: a_SMSTAT_DAT_F7_G_aCLRN  <= TRANSPORT NOT MR  ;
xor2_1255: a_EQ249 <=  n_1546  XOR n_1554;
or2_1256: n_1546 <=  n_1547  OR n_1550;
and2_1257: n_1547 <=  n_1548  AND n_1549;
delay_1258: n_1548  <= TRANSPORT en_lpbk  ;
delay_1259: n_1549  <= TRANSPORT a_SMCNTL_DAT_F3_G  ;
and2_1260: n_1550 <=  n_1551  AND n_1553;
inv_1261: n_1551  <= TRANSPORT NOT nDCD  ;
inv_1262: n_1553  <= TRANSPORT NOT en_lpbk  ;
and1_1263: n_1554 <=  gnd;
delay_1264: n_1555  <= TRANSPORT CLK  ;
filter_1265: FILTER_a16450

    PORT MAP (IN1 => n_1555, Y => a_SMSTAT_DAT_F7_G_aCLK);
delay_1266: a_LC3_C14  <= TRANSPORT a_EQ020  ;
xor2_1267: a_EQ020 <=  n_1559  XOR n_1568;
or2_1268: n_1559 <=  n_1560  OR n_1564;
and3_1269: n_1560 <=  n_1561  AND n_1562  AND n_1563;
inv_1270: n_1561  <= TRANSPORT NOT a_N1310  ;
inv_1271: n_1562  <= TRANSPORT NOT a_N1311  ;
delay_1272: n_1563  <= TRANSPORT a_LC3_A11  ;
and3_1273: n_1564 <=  n_1565  AND n_1566  AND n_1567;
delay_1274: n_1565  <= TRANSPORT a_N1310  ;
delay_1275: n_1566  <= TRANSPORT a_N1311  ;
delay_1276: n_1567  <= TRANSPORT a_SMSTAT_DAT_F7_G  ;
and1_1277: n_1568 <=  gnd;
delay_1278: a_LC8_C14  <= TRANSPORT a_EQ157  ;
xor2_1279: a_EQ157 <=  n_1571  XOR n_1581;
or2_1280: n_1571 <=  n_1572  OR n_1576;
and3_1281: n_1572 <=  n_1573  AND n_1574  AND n_1575;
delay_1282: n_1573  <= TRANSPORT a_SLCNTL_DOUT_F7_G  ;
inv_1283: n_1574  <= TRANSPORT NOT a_N1310  ;
delay_1284: n_1575  <= TRANSPORT a_N1311  ;
and3_1285: n_1576 <=  n_1577  AND n_1578  AND n_1580;
delay_1286: n_1577  <= TRANSPORT a_SLCNTL_DOUT_F7_G  ;
delay_1287: n_1578  <= TRANSPORT a_SDMSB_DAT_F7_G  ;
inv_1288: n_1580  <= TRANSPORT NOT a_N1310  ;
and1_1289: n_1581 <=  gnd;
delay_1290: a_LC7_C14  <= TRANSPORT a_LC7_C14_aIN  ;
xor2_1291: a_LC7_C14_aIN <=  n_1584  XOR n_1589;
or1_1292: n_1584 <=  n_1585;
and3_1293: n_1585 <=  n_1586  AND n_1587  AND n_1588;
delay_1294: n_1586  <= TRANSPORT a_N1310  ;
delay_1295: n_1587  <= TRANSPORT a_N1313  ;
delay_1296: n_1588  <= TRANSPORT a_N1311  ;
and1_1297: n_1589 <=  gnd;
delay_1298: a_LC1_C14  <= TRANSPORT a_EQ018  ;
xor2_1299: a_EQ018 <=  n_1591  XOR n_1601;
or3_1300: n_1591 <=  n_1592  OR n_1595  OR n_1598;
and2_1301: n_1592 <=  n_1593  AND n_1594;
inv_1302: n_1593  <= TRANSPORT NOT a_N1312  ;
delay_1303: n_1594  <= TRANSPORT a_LC3_C14  ;
and2_1304: n_1595 <=  n_1596  AND n_1597;
delay_1305: n_1596  <= TRANSPORT a_N1312  ;
delay_1306: n_1597  <= TRANSPORT a_LC8_C14  ;
and2_1307: n_1598 <=  n_1599  AND n_1600;
delay_1308: n_1599  <= TRANSPORT a_N1312  ;
delay_1309: n_1600  <= TRANSPORT a_LC7_C14  ;
and1_1310: n_1601 <=  gnd;
delay_1311: a_SSOUT  <= TRANSPORT a_EQ361  ;
xor2_1312: a_EQ361 <=  n_1603  XOR n_1608;
or2_1313: n_1603 <=  n_1604  OR n_1606;
and1_1314: n_1604 <=  n_1605;
delay_1315: n_1605  <= TRANSPORT en_lpbk  ;
and1_1316: n_1606 <=  n_1607;
delay_1317: n_1607  <= TRANSPORT lpbk_sin  ;
and1_1318: n_1608 <=  gnd;
delay_1319: a_LC6_B10  <= TRANSPORT a_LC6_B10_aIN  ;
xor2_1320: a_LC6_B10_aIN <=  n_1611  XOR n_1617;
or1_1321: n_1611 <=  n_1612;
and4_1322: n_1612 <=  n_1613  AND n_1614  AND n_1615  AND n_1616;
inv_1323: n_1613  <= TRANSPORT NOT a_SDLSB_DAT_F6_G  ;
inv_1324: n_1614  <= TRANSPORT NOT a_SDLSB_DAT_F7_G  ;
inv_1325: n_1615  <= TRANSPORT NOT a_SDMSB_DAT_F2_G  ;
inv_1326: n_1616  <= TRANSPORT NOT a_SDMSB_DAT_F7_G  ;
and1_1327: n_1617 <=  gnd;
delay_1328: a_LC5_B10  <= TRANSPORT a_LC5_B10_aIN  ;
xor2_1329: a_LC5_B10_aIN <=  n_1620  XOR n_1625;
or1_1330: n_1620 <=  n_1621;
and3_1331: n_1621 <=  n_1622  AND n_1623  AND n_1624;
inv_1332: n_1622  <= TRANSPORT NOT a_SDLSB_DAT_F4_G  ;
inv_1333: n_1623  <= TRANSPORT NOT a_SDMSB_DAT_F6_G  ;
inv_1334: n_1624  <= TRANSPORT NOT a_SDMSB_DAT_F0_G  ;
and1_1335: n_1625 <=  gnd;
delay_1336: a_LC4_B17  <= TRANSPORT a_LC4_B17_aIN  ;
xor2_1337: a_LC4_B17_aIN <=  n_1628  XOR n_1634;
or1_1338: n_1628 <=  n_1629;
and4_1339: n_1629 <=  n_1630  AND n_1631  AND n_1632  AND n_1633;
inv_1340: n_1630  <= TRANSPORT NOT a_SDLSB_DAT_F5_G  ;
inv_1341: n_1631  <= TRANSPORT NOT a_SDMSB_DAT_F1_G  ;
inv_1342: n_1632  <= TRANSPORT NOT a_SDMSB_DAT_F4_G  ;
inv_1343: n_1633  <= TRANSPORT NOT a_SDMSB_DAT_F5_G  ;
and1_1344: n_1634 <=  gnd;
delay_1345: a_N166_aNOT  <= TRANSPORT a_N166_aNOT_aIN  ;
xor2_1346: a_N166_aNOT_aIN <=  n_1637  XOR n_1643;
or1_1347: n_1637 <=  n_1638;
and4_1348: n_1638 <=  n_1639  AND n_1640  AND n_1641  AND n_1642;
inv_1349: n_1639  <= TRANSPORT NOT a_SDMSB_DAT_F3_G  ;
delay_1350: n_1640  <= TRANSPORT a_LC6_B10  ;
delay_1351: n_1641  <= TRANSPORT a_LC5_B10  ;
delay_1352: n_1642  <= TRANSPORT a_LC4_B17  ;
and1_1353: n_1643 <=  gnd;
delay_1354: a_N170  <= TRANSPORT a_EQ133  ;
xor2_1355: a_EQ133 <=  n_1646  XOR n_1655;
or4_1356: n_1646 <=  n_1647  OR n_1649  OR n_1651  OR n_1653;
and1_1357: n_1647 <=  n_1648;
inv_1358: n_1648  <= TRANSPORT NOT a_N166_aNOT  ;
and1_1359: n_1649 <=  n_1650;
delay_1360: n_1650  <= TRANSPORT a_SDLSB_DAT_F3_G  ;
and1_1361: n_1651 <=  n_1652;
delay_1362: n_1652  <= TRANSPORT a_SDLSB_DAT_F2_G  ;
and1_1363: n_1653 <=  n_1654;
delay_1364: n_1654  <= TRANSPORT a_SDLSB_DAT_F1_G  ;
and1_1365: n_1655 <=  gnd;
delay_1366: a_LC2_B1  <= TRANSPORT a_EQ059  ;
xor2_1367: a_EQ059 <=  n_1658  XOR n_1671;
or4_1368: n_1658 <=  n_1659  OR n_1662  OR n_1665  OR n_1668;
and1_1369: n_1659 <=  n_1660;
delay_1370: n_1660  <= TRANSPORT a_N1283  ;
and1_1371: n_1662 <=  n_1663;
delay_1372: n_1663  <= TRANSPORT a_N1279  ;
and1_1373: n_1665 <=  n_1666;
delay_1374: n_1666  <= TRANSPORT a_N1289_aNOT  ;
and1_1375: n_1668 <=  n_1669;
delay_1376: n_1669  <= TRANSPORT a_N1281  ;
and1_1377: n_1671 <=  gnd;
delay_1378: a_LC6_B4  <= TRANSPORT a_EQ060  ;
xor2_1379: a_EQ060 <=  n_1674  XOR n_1687;
or4_1380: n_1674 <=  n_1675  OR n_1678  OR n_1681  OR n_1684;
and1_1381: n_1675 <=  n_1676;
delay_1382: n_1676  <= TRANSPORT a_N1288  ;
and1_1383: n_1678 <=  n_1679;
delay_1384: n_1679  <= TRANSPORT a_N1274  ;
and1_1385: n_1681 <=  n_1682;
delay_1386: n_1682  <= TRANSPORT a_N1275  ;
and1_1387: n_1684 <=  n_1685;
delay_1388: n_1685  <= TRANSPORT a_N1287  ;
and1_1389: n_1687 <=  gnd;
delay_1390: a_LC7_B16  <= TRANSPORT a_EQ061  ;
xor2_1391: a_EQ061 <=  n_1690  XOR n_1703;
or4_1392: n_1690 <=  n_1691  OR n_1694  OR n_1697  OR n_1700;
and1_1393: n_1691 <=  n_1692;
delay_1394: n_1692  <= TRANSPORT a_N1276  ;
and1_1395: n_1694 <=  n_1695;
delay_1396: n_1695  <= TRANSPORT a_N1286  ;
and1_1397: n_1697 <=  n_1698;
delay_1398: n_1698  <= TRANSPORT a_N1282  ;
and1_1399: n_1700 <=  n_1701;
delay_1400: n_1701  <= TRANSPORT a_N1285  ;
and1_1401: n_1703 <=  gnd;
delay_1402: a_LC3_B1  <= TRANSPORT a_EQ062  ;
xor2_1403: a_EQ062 <=  n_1706  XOR n_1719;
or4_1404: n_1706 <=  n_1707  OR n_1710  OR n_1713  OR n_1716;
and1_1405: n_1707 <=  n_1708;
delay_1406: n_1708  <= TRANSPORT a_N1278  ;
and1_1407: n_1710 <=  n_1711;
delay_1408: n_1711  <= TRANSPORT a_N1280  ;
and1_1409: n_1713 <=  n_1714;
delay_1410: n_1714  <= TRANSPORT a_N1284  ;
and1_1411: n_1716 <=  n_1717;
delay_1412: n_1717  <= TRANSPORT a_N1277  ;
and1_1413: n_1719 <=  gnd;
delay_1414: a_N11_aNOT  <= TRANSPORT a_EQ063  ;
xor2_1415: a_EQ063 <=  n_1722  XOR n_1731;
or4_1416: n_1722 <=  n_1723  OR n_1725  OR n_1727  OR n_1729;
and1_1417: n_1723 <=  n_1724;
delay_1418: n_1724  <= TRANSPORT a_LC2_B1  ;
and1_1419: n_1725 <=  n_1726;
delay_1420: n_1726  <= TRANSPORT a_LC6_B4  ;
and1_1421: n_1727 <=  n_1728;
delay_1422: n_1728  <= TRANSPORT a_LC7_B16  ;
and1_1423: n_1729 <=  n_1730;
delay_1424: n_1730  <= TRANSPORT a_LC3_B1  ;
and1_1425: n_1731 <=  gnd;
delay_1426: a_N159_aNOT  <= TRANSPORT a_EQ127  ;
xor2_1427: a_EQ127 <=  n_1734  XOR n_1743;
or2_1428: n_1734 <=  n_1735  OR n_1740;
and3_1429: n_1735 <=  n_1736  AND n_1738  AND n_1739;
inv_1430: n_1736  <= TRANSPORT NOT a_N788  ;
delay_1431: n_1738  <= TRANSPORT a_N170  ;
delay_1432: n_1739  <= TRANSPORT a_N11_aNOT  ;
and2_1433: n_1740 <=  n_1741  AND n_1742;
delay_1434: n_1741  <= TRANSPORT CLK  ;
inv_1435: n_1742  <= TRANSPORT NOT a_N170  ;
and1_1436: n_1743 <=  gnd;
delay_1437: a_N162  <= TRANSPORT a_EQ128  ;
xor2_1438: a_EQ128 <=  n_1746  XOR n_1752;
or2_1439: n_1746 <=  n_1747  OR n_1750;
and2_1440: n_1747 <=  n_1748  AND n_1749;
inv_1441: n_1748  <= TRANSPORT NOT a_N788  ;
delay_1442: n_1749  <= TRANSPORT a_N11_aNOT  ;
and1_1443: n_1750 <=  n_1751;
delay_1444: n_1751  <= TRANSPORT a_N166_aNOT  ;
and1_1445: n_1752 <=  gnd;
delay_1446: a_LC8_B10  <= TRANSPORT a_LC8_B10_aIN  ;
xor2_1447: a_LC8_B10_aIN <=  n_1755  XOR n_1761;
or1_1448: n_1755 <=  n_1756;
and4_1449: n_1756 <=  n_1757  AND n_1758  AND n_1759  AND n_1760;
inv_1450: n_1757  <= TRANSPORT NOT a_SDLSB_DAT_F0_G  ;
delay_1451: n_1758  <= TRANSPORT a_SDLSB_DAT_F1_G  ;
inv_1452: n_1759  <= TRANSPORT NOT a_SDLSB_DAT_F2_G  ;
inv_1453: n_1760  <= TRANSPORT NOT a_SDLSB_DAT_F3_G  ;
and1_1454: n_1761 <=  gnd;
delay_1455: a_SBAUDOUT_N  <= TRANSPORT a_EQ300  ;
xor2_1456: a_EQ300 <=  n_1763  XOR n_1771;
or2_1457: n_1763 <=  n_1764  OR n_1767;
and2_1458: n_1764 <=  n_1765  AND n_1766;
delay_1459: n_1765  <= TRANSPORT a_N159_aNOT  ;
delay_1460: n_1766  <= TRANSPORT a_N162  ;
and3_1461: n_1767 <=  n_1768  AND n_1769  AND n_1770;
inv_1462: n_1768  <= TRANSPORT NOT a_N788  ;
delay_1463: n_1769  <= TRANSPORT a_N162  ;
delay_1464: n_1770  <= TRANSPORT a_LC8_B10  ;
and1_1465: n_1771 <=  gnd;
delay_1466: a_N20_aNOT  <= TRANSPORT a_EQ068  ;
xor2_1467: a_EQ068 <=  n_1773  XOR n_1780;
or3_1468: n_1773 <=  n_1774  OR n_1776  OR n_1778;
and1_1469: n_1774 <=  n_1775;
delay_1470: n_1775  <= TRANSPORT a_N705  ;
and1_1471: n_1776 <=  n_1777;
delay_1472: n_1777  <= TRANSPORT a_N704  ;
and1_1473: n_1778 <=  n_1779;
delay_1474: n_1779  <= TRANSPORT a_N702  ;
and1_1475: n_1780 <=  gnd;
delay_1476: a_N37_aNOT  <= TRANSPORT a_EQ079  ;
xor2_1477: a_EQ079 <=  n_1783  XOR n_1790;
or3_1478: n_1783 <=  n_1784  OR n_1786  OR n_1788;
and1_1479: n_1784 <=  n_1785;
inv_1480: n_1785  <= TRANSPORT NOT a_N705  ;
and1_1481: n_1786 <=  n_1787;
delay_1482: n_1787  <= TRANSPORT a_N704  ;
and1_1483: n_1788 <=  n_1789;
inv_1484: n_1789  <= TRANSPORT NOT a_N702  ;
and1_1485: n_1790 <=  gnd;
delay_1486: a_N36_aNOT  <= TRANSPORT a_EQ078  ;
xor2_1487: a_EQ078 <=  n_1793  XOR n_1800;
or3_1488: n_1793 <=  n_1794  OR n_1796  OR n_1798;
and1_1489: n_1794 <=  n_1795;
delay_1490: n_1795  <= TRANSPORT a_N705  ;
and1_1491: n_1796 <=  n_1797;
delay_1492: n_1797  <= TRANSPORT a_N704  ;
and1_1493: n_1798 <=  n_1799;
inv_1494: n_1799  <= TRANSPORT NOT a_N702  ;
and1_1495: n_1800 <=  gnd;
delay_1496: a_LC3_C5  <= TRANSPORT a_EQ143  ;
xor2_1497: a_EQ143 <=  n_1803  XOR n_1811;
or3_1498: n_1803 <=  n_1804  OR n_1806  OR n_1808;
and1_1499: n_1804 <=  n_1805;
delay_1500: n_1805  <= TRANSPORT a_N36_aNOT  ;
and1_1501: n_1806 <=  n_1807;
delay_1502: n_1807  <= TRANSPORT a_SLCNTL_DOUT_F2_G  ;
and1_1503: n_1808 <=  n_1809;
inv_1504: n_1809  <= TRANSPORT NOT a_N1349  ;
and1_1505: n_1811 <=  gnd;
delay_1506: a_N61  <= TRANSPORT a_EQ115  ;
xor2_1507: a_EQ115 <=  n_1814  XOR n_1819;
or2_1508: n_1814 <=  n_1815  OR n_1817;
and1_1509: n_1815 <=  n_1816;
delay_1510: n_1816  <= TRANSPORT a_SLCNTL_DOUT_F0_G  ;
and1_1511: n_1817 <=  n_1818;
delay_1512: n_1818  <= TRANSPORT a_SLCNTL_DOUT_F1_G  ;
and1_1513: n_1819 <=  gnd;
delay_1514: a_LC2_C11  <= TRANSPORT a_EQ065  ;
xor2_1515: a_EQ065 <=  n_1822  XOR n_1830;
or2_1516: n_1822 <=  n_1823  OR n_1826;
and2_1517: n_1823 <=  n_1824  AND n_1825;
delay_1518: n_1824  <= TRANSPORT a_N37_aNOT  ;
delay_1519: n_1825  <= TRANSPORT a_LC3_C5  ;
and3_1520: n_1826 <=  n_1827  AND n_1828  AND n_1829;
delay_1521: n_1827  <= TRANSPORT a_LC3_C5  ;
delay_1522: n_1828  <= TRANSPORT a_N61  ;
inv_1523: n_1829  <= TRANSPORT NOT a_N1349  ;
and1_1524: n_1830 <=  gnd;
delay_1525: a_N18  <= TRANSPORT a_EQ067  ;
xor2_1526: a_EQ067 <=  n_1833  XOR n_1842;
or3_1527: n_1833 <=  n_1834  OR n_1837  OR n_1839;
and2_1528: n_1834 <=  n_1835  AND n_1836;
delay_1529: n_1835  <= TRANSPORT a_N20_aNOT  ;
delay_1530: n_1836  <= TRANSPORT a_LC2_C11  ;
and1_1531: n_1837 <=  n_1838;
inv_1532: n_1838  <= TRANSPORT NOT a_SLSTAT_DAT_F5_G_aNOT  ;
and1_1533: n_1839 <=  n_1840;
inv_1534: n_1840  <= TRANSPORT NOT baud_en  ;
and1_1535: n_1842 <=  gnd;
delay_1536: a_N214  <= TRANSPORT a_N214_aIN  ;
xor2_1537: a_N214_aIN <=  n_1845  XOR n_1849;
or1_1538: n_1845 <=  n_1846;
and2_1539: n_1846 <=  n_1847  AND n_1848;
delay_1540: n_1847  <= TRANSPORT baud_en  ;
delay_1541: n_1848  <= TRANSPORT a_N1349  ;
and1_1542: n_1849 <=  gnd;
delay_1543: a_N785  <= TRANSPORT a_N785_aIN  ;
xor2_1544: a_N785_aIN <=  n_1852  XOR n_1857;
or1_1545: n_1852 <=  n_1853;
and3_1546: n_1853 <=  n_1854  AND n_1855  AND n_1856;
delay_1547: n_1854  <= TRANSPORT a_N214  ;
inv_1548: n_1855  <= TRANSPORT NOT a_N705  ;
delay_1549: n_1856  <= TRANSPORT a_N704  ;
and1_1550: n_1857 <=  gnd;
dff_1551: DFF_a16450

    PORT MAP ( D => a_EQ198, CLK => a_N528_aNOT_aCLK, CLRN => a_N528_aNOT_aCLRN,
          PRN => vcc, Q => a_N528_aNOT);
inv_1552: a_N528_aNOT_aCLRN  <= TRANSPORT NOT MR  ;
xor2_1553: a_EQ198 <=  n_1865  XOR n_1876;
or3_1554: n_1865 <=  n_1866  OR n_1870  OR n_1873;
and2_1555: n_1866 <=  n_1867  AND n_1868;
inv_1556: n_1867  <= TRANSPORT NOT a_N18  ;
inv_1557: n_1868  <= TRANSPORT NOT a_N1355  ;
and2_1558: n_1870 <=  n_1871  AND n_1872;
delay_1559: n_1871  <= TRANSPORT a_N18  ;
delay_1560: n_1872  <= TRANSPORT a_N528_aNOT  ;
and2_1561: n_1873 <=  n_1874  AND n_1875;
delay_1562: n_1874  <= TRANSPORT a_N18  ;
delay_1563: n_1875  <= TRANSPORT a_N785  ;
and1_1564: n_1876 <=  gnd;
delay_1565: n_1877  <= TRANSPORT CLK  ;
filter_1566: FILTER_a16450

    PORT MAP (IN1 => n_1877, Y => a_N528_aNOT_aCLK);
delay_1567: a_LC2_A14  <= TRANSPORT a_EQ251  ;
xor2_1568: a_EQ251 <=  n_1881  XOR n_1893;
or3_1569: n_1881 <=  n_1882  OR n_1886  OR n_1890;
and2_1570: n_1882 <=  n_1883  AND n_1884;
inv_1571: n_1883  <= TRANSPORT NOT a_N18  ;
inv_1572: n_1884  <= TRANSPORT NOT a_N1356  ;
and2_1573: n_1886 <=  n_1887  AND n_1888;
delay_1574: n_1887  <= TRANSPORT a_N18  ;
delay_1575: n_1888  <= TRANSPORT a_N530_aNOT  ;
and2_1576: n_1890 <=  n_1891  AND n_1892;
delay_1577: n_1891  <= TRANSPORT a_N18  ;
delay_1578: n_1892  <= TRANSPORT a_N785  ;
and1_1579: n_1893 <=  gnd;
dff_1580: DFF_a16450

    PORT MAP ( D => a_EQ199, CLK => a_N530_aNOT_aCLK, CLRN => a_N530_aNOT_aCLRN,
          PRN => vcc, Q => a_N530_aNOT);
inv_1581: a_N530_aNOT_aCLRN  <= TRANSPORT NOT MR  ;
xor2_1582: a_EQ199 <=  n_1900  XOR n_1907;
or2_1583: n_1900 <=  n_1901  OR n_1904;
and2_1584: n_1901 <=  n_1902  AND n_1903;
delay_1585: n_1902  <= TRANSPORT a_N528_aNOT  ;
delay_1586: n_1903  <= TRANSPORT a_LC2_A14  ;
and2_1587: n_1904 <=  n_1905  AND n_1906;
inv_1588: n_1905  <= TRANSPORT NOT a_N785  ;
delay_1589: n_1906  <= TRANSPORT a_LC2_A14  ;
and1_1590: n_1907 <=  gnd;
delay_1591: n_1908  <= TRANSPORT CLK  ;
filter_1592: FILTER_a16450

    PORT MAP (IN1 => n_1908, Y => a_N530_aNOT_aCLK);
delay_1593: a_LC1_A14  <= TRANSPORT a_EQ252  ;
xor2_1594: a_EQ252 <=  n_1912  XOR n_1924;
or3_1595: n_1912 <=  n_1913  OR n_1917  OR n_1921;
and2_1596: n_1913 <=  n_1914  AND n_1915;
inv_1597: n_1914  <= TRANSPORT NOT a_N18  ;
inv_1598: n_1915  <= TRANSPORT NOT a_N1357  ;
and2_1599: n_1917 <=  n_1918  AND n_1919;
delay_1600: n_1918  <= TRANSPORT a_N18  ;
delay_1601: n_1919  <= TRANSPORT a_N531_aNOT  ;
and2_1602: n_1921 <=  n_1922  AND n_1923;
delay_1603: n_1922  <= TRANSPORT a_N18  ;
delay_1604: n_1923  <= TRANSPORT a_N785  ;
and1_1605: n_1924 <=  gnd;
dff_1606: DFF_a16450

    PORT MAP ( D => a_EQ200, CLK => a_N531_aNOT_aCLK, CLRN => a_N531_aNOT_aCLRN,
          PRN => vcc, Q => a_N531_aNOT);
inv_1607: a_N531_aNOT_aCLRN  <= TRANSPORT NOT MR  ;
xor2_1608: a_EQ200 <=  n_1931  XOR n_1938;
or2_1609: n_1931 <=  n_1932  OR n_1935;
and2_1610: n_1932 <=  n_1933  AND n_1934;
delay_1611: n_1933  <= TRANSPORT a_N530_aNOT  ;
delay_1612: n_1934  <= TRANSPORT a_LC1_A14  ;
and2_1613: n_1935 <=  n_1936  AND n_1937;
inv_1614: n_1936  <= TRANSPORT NOT a_N785  ;
delay_1615: n_1937  <= TRANSPORT a_LC1_A14  ;
and1_1616: n_1938 <=  gnd;
delay_1617: n_1939  <= TRANSPORT CLK  ;
filter_1618: FILTER_a16450

    PORT MAP (IN1 => n_1939, Y => a_N531_aNOT_aCLK);
delay_1619: a_LC1_A1  <= TRANSPORT a_EQ253  ;
xor2_1620: a_EQ253 <=  n_1943  XOR n_1955;
or3_1621: n_1943 <=  n_1944  OR n_1948  OR n_1952;
and2_1622: n_1944 <=  n_1945  AND n_1946;
inv_1623: n_1945  <= TRANSPORT NOT a_N18  ;
inv_1624: n_1946  <= TRANSPORT NOT a_N1358  ;
and2_1625: n_1948 <=  n_1949  AND n_1950;
delay_1626: n_1949  <= TRANSPORT a_N18  ;
delay_1627: n_1950  <= TRANSPORT a_N532_aNOT  ;
and2_1628: n_1952 <=  n_1953  AND n_1954;
delay_1629: n_1953  <= TRANSPORT a_N18  ;
delay_1630: n_1954  <= TRANSPORT a_N785  ;
and1_1631: n_1955 <=  gnd;
dff_1632: DFF_a16450

    PORT MAP ( D => a_EQ201, CLK => a_N532_aNOT_aCLK, CLRN => a_N532_aNOT_aCLRN,
          PRN => vcc, Q => a_N532_aNOT);
inv_1633: a_N532_aNOT_aCLRN  <= TRANSPORT NOT MR  ;
xor2_1634: a_EQ201 <=  n_1962  XOR n_1969;
or2_1635: n_1962 <=  n_1963  OR n_1966;
and2_1636: n_1963 <=  n_1964  AND n_1965;
delay_1637: n_1964  <= TRANSPORT a_N531_aNOT  ;
delay_1638: n_1965  <= TRANSPORT a_LC1_A1  ;
and2_1639: n_1966 <=  n_1967  AND n_1968;
inv_1640: n_1967  <= TRANSPORT NOT a_N785  ;
delay_1641: n_1968  <= TRANSPORT a_LC1_A1  ;
and1_1642: n_1969 <=  gnd;
delay_1643: n_1970  <= TRANSPORT CLK  ;
filter_1644: FILTER_a16450

    PORT MAP (IN1 => n_1970, Y => a_N532_aNOT_aCLK);
delay_1645: a_N191_aNOT  <= TRANSPORT a_N191_aNOT_aIN  ;
xor2_1646: a_N191_aNOT_aIN <=  n_1974  XOR n_1981;
or1_1647: n_1974 <=  n_1975;
and3_1648: n_1975 <=  n_1976  AND n_1977  AND n_1979;
delay_1649: n_1976  <= TRANSPORT a_N785  ;
delay_1650: n_1977  <= TRANSPORT a_N682  ;
delay_1651: n_1979  <= TRANSPORT a_N681  ;
and1_1652: n_1981 <=  gnd;
delay_1653: a_N493_aNOT  <= TRANSPORT a_EQ193  ;
xor2_1654: a_EQ193 <=  n_1984  XOR n_1993;
or3_1655: n_1984 <=  n_1985  OR n_1988  OR n_1991;
and1_1656: n_1985 <=  n_1986;
inv_1657: n_1986  <= TRANSPORT NOT a_N680  ;
and1_1658: n_1988 <=  n_1989;
delay_1659: n_1989  <= TRANSPORT a_N679  ;
and1_1660: n_1991 <=  n_1992;
inv_1661: n_1992  <= TRANSPORT NOT a_N61  ;
and1_1662: n_1993 <=  gnd;
delay_1663: a_N41_aNOT  <= TRANSPORT a_EQ083  ;
xor2_1664: a_EQ083 <=  n_1996  XOR n_2001;
or2_1665: n_1996 <=  n_1997  OR n_1999;
and1_1666: n_1997 <=  n_1998;
inv_1667: n_1998  <= TRANSPORT NOT a_SLCNTL_DOUT_F0_G  ;
and1_1668: n_1999 <=  n_2000;
delay_1669: n_2000  <= TRANSPORT a_SLCNTL_DOUT_F1_G  ;
and1_1670: n_2001 <=  gnd;
delay_1671: a_LC3_C20  <= TRANSPORT a_EQ144  ;
xor2_1672: a_EQ144 <=  n_2004  XOR n_2013;
or4_1673: n_2004 <=  n_2005  OR n_2007  OR n_2009  OR n_2011;
and1_1674: n_2005 <=  n_2006;
delay_1675: n_2006  <= TRANSPORT a_N493_aNOT  ;
and1_1676: n_2007 <=  n_2008;
delay_1677: n_2008  <= TRANSPORT a_N41_aNOT  ;
and1_1678: n_2009 <=  n_2010;
delay_1679: n_2010  <= TRANSPORT a_N681  ;
and1_1680: n_2011 <=  n_2012;
inv_1681: n_2012  <= TRANSPORT NOT a_N682  ;
and1_1682: n_2013 <=  gnd;
delay_1683: a_LC5_C20  <= TRANSPORT a_EQ194  ;
xor2_1684: a_EQ194 <=  n_2016  XOR n_2032;
or5_1685: n_2016 <=  n_2017  OR n_2021  OR n_2024  OR n_2027  OR n_2030;
and3_1686: n_2017 <=  n_2018  AND n_2019  AND n_2020;
delay_1687: n_2018  <= TRANSPORT a_N682  ;
delay_1688: n_2019  <= TRANSPORT a_SLCNTL_DOUT_F1_G  ;
inv_1689: n_2020  <= TRANSPORT NOT a_SLCNTL_DOUT_F0_G  ;
and2_1690: n_2021 <=  n_2022  AND n_2023;
inv_1691: n_2022  <= TRANSPORT NOT a_N682  ;
delay_1692: n_2023  <= TRANSPORT a_SLCNTL_DOUT_F0_G  ;
and2_1693: n_2024 <=  n_2025  AND n_2026;
inv_1694: n_2025  <= TRANSPORT NOT a_N682  ;
inv_1695: n_2026  <= TRANSPORT NOT a_SLCNTL_DOUT_F1_G  ;
and2_1696: n_2027 <=  n_2028  AND n_2029;
inv_1697: n_2028  <= TRANSPORT NOT a_SLCNTL_DOUT_F1_G  ;
delay_1698: n_2029  <= TRANSPORT a_SLCNTL_DOUT_F0_G  ;
and1_1699: n_2030 <=  n_2031;
delay_1700: n_2031  <= TRANSPORT a_N493_aNOT  ;
and1_1701: n_2032 <=  gnd;
delay_1702: a_LC2_C20  <= TRANSPORT a_EQ149  ;
xor2_1703: a_EQ149 <=  n_2035  XOR n_2042;
or3_1704: n_2035 <=  n_2036  OR n_2038  OR n_2040;
and1_1705: n_2036 <=  n_2037;
delay_1706: n_2037  <= TRANSPORT a_N682  ;
and1_1707: n_2038 <=  n_2039;
inv_1708: n_2039  <= TRANSPORT NOT a_N680  ;
and1_1709: n_2040 <=  n_2041;
delay_1710: n_2041  <= TRANSPORT a_N679  ;
and1_1711: n_2042 <=  gnd;
delay_1712: a_LC1_C20  <= TRANSPORT a_EQ142  ;
xor2_1713: a_EQ142 <=  n_2045  XOR n_2055;
or3_1714: n_2045 <=  n_2046  OR n_2049  OR n_2052;
and2_1715: n_2046 <=  n_2047  AND n_2048;
delay_1716: n_2047  <= TRANSPORT a_LC5_C20  ;
delay_1717: n_2048  <= TRANSPORT a_N681  ;
and2_1718: n_2049 <=  n_2050  AND n_2051;
delay_1719: n_2050  <= TRANSPORT a_LC2_C20  ;
inv_1720: n_2051  <= TRANSPORT NOT a_N681  ;
and2_1721: n_2052 <=  n_2053  AND n_2054;
delay_1722: n_2053  <= TRANSPORT a_N61  ;
inv_1723: n_2054  <= TRANSPORT NOT a_N681  ;
and1_1724: n_2055 <=  gnd;
delay_1725: a_N199  <= TRANSPORT a_EQ145  ;
xor2_1726: a_EQ145 <=  n_2058  XOR n_2064;
or2_1727: n_2058 <=  n_2059  OR n_2062;
and2_1728: n_2059 <=  n_2060  AND n_2061;
delay_1729: n_2060  <= TRANSPORT a_LC3_C20  ;
delay_1730: n_2061  <= TRANSPORT a_LC1_C20  ;
and1_1731: n_2062 <=  n_2063;
inv_1732: n_2063  <= TRANSPORT NOT a_N785  ;
and1_1733: n_2064 <=  gnd;
dff_1734: DFF_a16450

    PORT MAP ( D => a_EQ211, CLK => a_N680_aCLK, CLRN => a_N680_aCLRN, PRN => vcc,
          Q => a_N680);
inv_1735: a_N680_aCLRN  <= TRANSPORT NOT MR  ;
xor2_1736: a_EQ211 <=  n_2071  XOR n_2080;
or2_1737: n_2071 <=  n_2072  OR n_2076;
and3_1738: n_2072 <=  n_2073  AND n_2074  AND n_2075;
inv_1739: n_2073  <= TRANSPORT NOT a_N191_aNOT  ;
delay_1740: n_2074  <= TRANSPORT a_N199  ;
delay_1741: n_2075  <= TRANSPORT a_N680  ;
and3_1742: n_2076 <=  n_2077  AND n_2078  AND n_2079;
delay_1743: n_2077  <= TRANSPORT a_N191_aNOT  ;
delay_1744: n_2078  <= TRANSPORT a_N199  ;
inv_1745: n_2079  <= TRANSPORT NOT a_N680  ;
and1_1746: n_2080 <=  gnd;
delay_1747: n_2081  <= TRANSPORT CLK  ;
filter_1748: FILTER_a16450

    PORT MAP (IN1 => n_2081, Y => a_N680_aCLK);
dff_1749: DFF_a16450

    PORT MAP ( D => a_EQ210, CLK => a_N679_aCLK, CLRN => a_N679_aCLRN, PRN => vcc,
          Q => a_N679);
inv_1750: a_N679_aCLRN  <= TRANSPORT NOT MR  ;
xor2_1751: a_EQ210 <=  n_2089  XOR n_2103;
or3_1752: n_2089 <=  n_2090  OR n_2094  OR n_2098;
and3_1753: n_2090 <=  n_2091  AND n_2092  AND n_2093;
delay_1754: n_2091  <= TRANSPORT a_N199  ;
inv_1755: n_2092  <= TRANSPORT NOT a_N680  ;
delay_1756: n_2093  <= TRANSPORT a_N679  ;
and3_1757: n_2094 <=  n_2095  AND n_2096  AND n_2097;
inv_1758: n_2095  <= TRANSPORT NOT a_N191_aNOT  ;
delay_1759: n_2096  <= TRANSPORT a_N199  ;
delay_1760: n_2097  <= TRANSPORT a_N679  ;
and4_1761: n_2098 <=  n_2099  AND n_2100  AND n_2101  AND n_2102;
delay_1762: n_2099  <= TRANSPORT a_N191_aNOT  ;
delay_1763: n_2100  <= TRANSPORT a_N199  ;
delay_1764: n_2101  <= TRANSPORT a_N680  ;
inv_1765: n_2102  <= TRANSPORT NOT a_N679  ;
and1_1766: n_2103 <=  gnd;
delay_1767: n_2104  <= TRANSPORT CLK  ;
filter_1768: FILTER_a16450

    PORT MAP (IN1 => n_2104, Y => a_N679_aCLK);
delay_1769: a_LC3_C12  <= TRANSPORT a_EQ070  ;
xor2_1770: a_EQ070 <=  n_2108  XOR n_2123;
or4_1771: n_2108 <=  n_2109  OR n_2113  OR n_2116  OR n_2120;
and2_1772: n_2109 <=  n_2110  AND n_2112;
delay_1773: n_2110  <= TRANSPORT a_N431  ;
inv_1774: n_2112  <= TRANSPORT NOT a_SLCNTL_DOUT_F1_G  ;
and2_1775: n_2113 <=  n_2114  AND n_2115;
inv_1776: n_2114  <= TRANSPORT NOT a_N431  ;
delay_1777: n_2115  <= TRANSPORT a_SLCNTL_DOUT_F1_G  ;
and2_1778: n_2116 <=  n_2117  AND n_2119;
delay_1779: n_2117  <= TRANSPORT a_N432  ;
inv_1780: n_2119  <= TRANSPORT NOT a_SLCNTL_DOUT_F0_G  ;
and2_1781: n_2120 <=  n_2121  AND n_2122;
inv_1782: n_2121  <= TRANSPORT NOT a_N432  ;
delay_1783: n_2122  <= TRANSPORT a_SLCNTL_DOUT_F0_G  ;
and1_1784: n_2123 <=  gnd;
delay_1785: a_N44  <= TRANSPORT a_N44_aIN  ;
xor2_1786: a_N44_aIN <=  n_2126  XOR n_2136;
or1_1787: n_2126 <=  n_2127;
and4_1788: n_2127 <=  n_2128  AND n_2130  AND n_2132  AND n_2134;
inv_1789: n_2128  <= TRANSPORT NOT a_N409  ;
delay_1790: n_2130  <= TRANSPORT a_N410  ;
delay_1791: n_2132  <= TRANSPORT a_N411  ;
inv_1792: n_2134  <= TRANSPORT NOT a_N412  ;
and1_1793: n_2136 <=  gnd;
delay_1794: a_N782  <= TRANSPORT a_N782_aIN  ;
xor2_1795: a_N782_aIN <=  n_2139  XOR n_2146;
or1_1796: n_2139 <=  n_2140;
and3_1797: n_2140 <=  n_2141  AND n_2142  AND n_2144;
delay_1798: n_2141  <= TRANSPORT a_N44  ;
inv_1799: n_2142  <= TRANSPORT NOT a_N57  ;
delay_1800: n_2144  <= TRANSPORT a_N56  ;
and1_1801: n_2146 <=  gnd;
delay_1802: a_N215_aNOT  <= TRANSPORT a_EQ153  ;
xor2_1803: a_EQ153 <=  n_2149  XOR n_2157;
or3_1804: n_2149 <=  n_2150  OR n_2153  OR n_2155;
and1_1805: n_2150 <=  n_2151;
inv_1806: n_2151  <= TRANSPORT NOT a_N430  ;
and1_1807: n_2153 <=  n_2154;
delay_1808: n_2154  <= TRANSPORT a_LC3_C12  ;
and1_1809: n_2155 <=  n_2156;
inv_1810: n_2156  <= TRANSPORT NOT a_N782  ;
and1_1811: n_2157 <=  gnd;
dff_1812: DFF_a16450

    PORT MAP ( D => a_EQ187, CLK => a_N431_aCLK, CLRN => a_N431_aCLRN, PRN => vcc,
          Q => a_N431);
inv_1813: a_N431_aCLRN  <= TRANSPORT NOT MR  ;
xor2_1814: a_EQ187 <=  n_2164  XOR n_2178;
or3_1815: n_2164 <=  n_2165  OR n_2169  OR n_2173;
and3_1816: n_2165 <=  n_2166  AND n_2167  AND n_2168;
delay_1817: n_2166  <= TRANSPORT a_N215_aNOT  ;
delay_1818: n_2167  <= TRANSPORT a_N431  ;
inv_1819: n_2168  <= TRANSPORT NOT a_N432  ;
and3_1820: n_2169 <=  n_2170  AND n_2171  AND n_2172;
inv_1821: n_2170  <= TRANSPORT NOT a_N782  ;
delay_1822: n_2171  <= TRANSPORT a_N215_aNOT  ;
delay_1823: n_2172  <= TRANSPORT a_N431  ;
and4_1824: n_2173 <=  n_2174  AND n_2175  AND n_2176  AND n_2177;
delay_1825: n_2174  <= TRANSPORT a_N782  ;
delay_1826: n_2175  <= TRANSPORT a_N215_aNOT  ;
inv_1827: n_2176  <= TRANSPORT NOT a_N431  ;
delay_1828: n_2177  <= TRANSPORT a_N432  ;
and1_1829: n_2178 <=  gnd;
delay_1830: n_2179  <= TRANSPORT RCLK  ;
filter_1831: FILTER_a16450

    PORT MAP (IN1 => n_2179, Y => a_N431_aCLK);
dff_1832: DFF_a16450

    PORT MAP ( D => a_EQ188, CLK => a_N432_aCLK, CLRN => a_N432_aCLRN, PRN => vcc,
          Q => a_N432);
inv_1833: a_N432_aCLRN  <= TRANSPORT NOT MR  ;
xor2_1834: a_EQ188 <=  n_2187  XOR n_2196;
or2_1835: n_2187 <=  n_2188  OR n_2192;
and3_1836: n_2188 <=  n_2189  AND n_2190  AND n_2191;
delay_1837: n_2189  <= TRANSPORT a_N782  ;
delay_1838: n_2190  <= TRANSPORT a_N215_aNOT  ;
inv_1839: n_2191  <= TRANSPORT NOT a_N432  ;
and3_1840: n_2192 <=  n_2193  AND n_2194  AND n_2195;
inv_1841: n_2193  <= TRANSPORT NOT a_N782  ;
delay_1842: n_2194  <= TRANSPORT a_N215_aNOT  ;
delay_1843: n_2195  <= TRANSPORT a_N432  ;
and1_1844: n_2196 <=  gnd;
delay_1845: n_2197  <= TRANSPORT RCLK  ;
filter_1846: FILTER_a16450

    PORT MAP (IN1 => n_2197, Y => a_N432_aCLK);
dff_1847: DFF_a16450

    PORT MAP ( D => a_EQ123, CLK => a_N108_aCLK, CLRN => a_N108_aCLRN, PRN => vcc,
          Q => a_N108);
inv_1848: a_N108_aCLRN  <= TRANSPORT NOT MR  ;
xor2_1849: a_EQ123 <=  n_2206  XOR n_2218;
or3_1850: n_2206 <=  n_2207  OR n_2212  OR n_2215;
and3_1851: n_2207 <=  n_2208  AND n_2209  AND n_2211;
delay_1852: n_2208  <= TRANSPORT a_N44  ;
delay_1853: n_2209  <= TRANSPORT a_N107  ;
delay_1854: n_2211  <= TRANSPORT a_N56  ;
and2_1855: n_2212 <=  n_2213  AND n_2214;
delay_1856: n_2213  <= TRANSPORT a_N108  ;
inv_1857: n_2214  <= TRANSPORT NOT a_N56  ;
and2_1858: n_2215 <=  n_2216  AND n_2217;
inv_1859: n_2216  <= TRANSPORT NOT a_N44  ;
delay_1860: n_2217  <= TRANSPORT a_N108  ;
and1_1861: n_2218 <=  gnd;
delay_1862: n_2219  <= TRANSPORT RCLK  ;
filter_1863: FILTER_a16450

    PORT MAP (IN1 => n_2219, Y => a_N108_aCLK);
dff_1864: DFF_a16450

    PORT MAP ( D => a_EQ117, CLK => a_N102_aCLK, CLRN => a_N102_aCLRN, PRN => vcc,
          Q => a_N102);
inv_1865: a_N102_aCLRN  <= TRANSPORT NOT MR  ;
xor2_1866: a_EQ117 <=  n_2228  XOR n_2240;
or3_1867: n_2228 <=  n_2229  OR n_2234  OR n_2237;
and3_1868: n_2229 <=  n_2230  AND n_2231  AND n_2233;
delay_1869: n_2230  <= TRANSPORT a_N44  ;
delay_1870: n_2231  <= TRANSPORT a_N101  ;
delay_1871: n_2233  <= TRANSPORT a_N56  ;
and2_1872: n_2234 <=  n_2235  AND n_2236;
delay_1873: n_2235  <= TRANSPORT a_N102  ;
inv_1874: n_2236  <= TRANSPORT NOT a_N56  ;
and2_1875: n_2237 <=  n_2238  AND n_2239;
inv_1876: n_2238  <= TRANSPORT NOT a_N44  ;
delay_1877: n_2239  <= TRANSPORT a_N102  ;
and1_1878: n_2240 <=  gnd;
delay_1879: n_2241  <= TRANSPORT RCLK  ;
filter_1880: FILTER_a16450

    PORT MAP (IN1 => n_2241, Y => a_N102_aCLK);
delay_1881: a_N209_aNOT  <= TRANSPORT a_EQ148  ;
xor2_1882: a_EQ148 <=  n_2245  XOR n_2253;
or2_1883: n_2245 <=  n_2246  OR n_2249;
and2_1884: n_2246 <=  n_2247  AND n_2248;
delay_1885: n_2247  <= TRANSPORT a_N785  ;
delay_1886: n_2248  <= TRANSPORT a_N532_aNOT  ;
and2_1887: n_2249 <=  n_2250  AND n_2251;
inv_1888: n_2250  <= TRANSPORT NOT a_N785  ;
delay_1889: n_2251  <= TRANSPORT a_N533_aNOT  ;
and1_1890: n_2253 <=  gnd;
dff_1891: DFF_a16450

    PORT MAP ( D => a_EQ202, CLK => a_N533_aNOT_aCLK, CLRN => a_N533_aNOT_aCLRN,
          PRN => vcc, Q => a_N533_aNOT);
inv_1892: a_N533_aNOT_aCLRN  <= TRANSPORT NOT MR  ;
xor2_1893: a_EQ202 <=  n_2260  XOR n_2268;
or2_1894: n_2260 <=  n_2261  OR n_2264;
and2_1895: n_2261 <=  n_2262  AND n_2263;
delay_1896: n_2262  <= TRANSPORT a_N18  ;
delay_1897: n_2263  <= TRANSPORT a_N209_aNOT  ;
and2_1898: n_2264 <=  n_2265  AND n_2266;
inv_1899: n_2265  <= TRANSPORT NOT a_N18  ;
inv_1900: n_2266  <= TRANSPORT NOT a_N1359  ;
and1_1901: n_2268 <=  gnd;
delay_1902: n_2269  <= TRANSPORT CLK  ;
filter_1903: FILTER_a16450

    PORT MAP (IN1 => n_2269, Y => a_N533_aNOT_aCLK);
delay_1904: a_N42  <= TRANSPORT a_N42_aIN  ;
xor2_1905: a_N42_aIN <=  n_2273  XOR n_2277;
or1_1906: n_2273 <=  n_2274;
and2_1907: n_2274 <=  n_2275  AND n_2276;
delay_1908: n_2275  <= TRANSPORT a_SLCNTL_DOUT_F1_G  ;
delay_1909: n_2276  <= TRANSPORT a_SLCNTL_DOUT_F0_G  ;
and1_1910: n_2277 <=  gnd;
delay_1911: a_SCSOUT  <= TRANSPORT a_SCSOUT_aIN  ;
xor2_1912: a_SCSOUT_aIN <=  n_2279  XOR n_2284;
or1_1913: n_2279 <=  n_2280;
and3_1914: n_2280 <=  n_2281  AND n_2282  AND n_2283;
delay_1915: n_2281  <= TRANSPORT CS1  ;
delay_1916: n_2282  <= TRANSPORT CS0  ;
inv_1917: n_2283  <= TRANSPORT NOT nCS2  ;
and1_1918: n_2284 <=  gnd;
delay_1919: a_N804  <= TRANSPORT a_N804_aIN  ;
xor2_1920: a_N804_aIN <=  n_2286  XOR n_2291;
or1_1921: n_2286 <=  n_2287;
and3_1922: n_2287 <=  n_2288  AND n_2289  AND n_2290;
delay_1923: n_2288  <= TRANSPORT a_SCSOUT  ;
inv_1924: n_2289  <= TRANSPORT NOT a_N1125  ;
delay_1925: n_2290  <= TRANSPORT a_N1123  ;
and1_1926: n_2291 <=  gnd;
delay_1927: a_N21  <= TRANSPORT a_N21_aIN  ;
xor2_1928: a_N21_aIN <=  n_2293  XOR n_2298;
or1_1929: n_2293 <=  n_2294;
and3_1930: n_2294 <=  n_2295  AND n_2296  AND n_2297;
inv_1931: n_2295  <= TRANSPORT NOT a_N1310  ;
inv_1932: n_2296  <= TRANSPORT NOT a_N1311  ;
inv_1933: n_2297  <= TRANSPORT NOT a_N1312  ;
and1_1934: n_2298 <=  gnd;
delay_1935: a_N797  <= TRANSPORT a_N797_aIN  ;
xor2_1936: a_N797_aIN <=  n_2300  XOR n_2305;
or1_1937: n_2300 <=  n_2301;
and3_1938: n_2301 <=  n_2302  AND n_2303  AND n_2304;
delay_1939: n_2302  <= TRANSPORT a_N804  ;
delay_1940: n_2303  <= TRANSPORT a_N21  ;
inv_1941: n_2304  <= TRANSPORT NOT a_SLCNTL_DOUT_F7_G  ;
and1_1942: n_2305 <=  gnd;
dff_1943: DFF_a16450

    PORT MAP ( D => a_EQ291, CLK => a_N1355_aCLK, CLRN => vcc, PRN => vcc,
          Q => a_N1355);
xor2_1944: a_EQ291 <=  n_2311  XOR n_2319;
or2_1945: n_2311 <=  n_2312  OR n_2316;
and3_1946: n_2312 <=  n_2313  AND n_2314  AND n_2315;
delay_1947: n_2313  <= TRANSPORT a_N42  ;
delay_1948: n_2314  <= TRANSPORT a_N797  ;
delay_1949: n_2315  <= TRANSPORT DIN(7)  ;
and2_1950: n_2316 <=  n_2317  AND n_2318;
inv_1951: n_2317  <= TRANSPORT NOT a_N797  ;
delay_1952: n_2318  <= TRANSPORT a_N1355  ;
and1_1953: n_2319 <=  gnd;
delay_1954: n_2320  <= TRANSPORT CLK  ;
filter_1955: FILTER_a16450

    PORT MAP (IN1 => n_2320, Y => a_N1355_aCLK);
delay_1956: a_LC1_A10  <= TRANSPORT a_LC1_A10_aIN  ;
xor2_1957: a_LC1_A10_aIN <=  n_2324  XOR n_2329;
or1_1958: n_2324 <=  n_2325;
and3_1959: n_2325 <=  n_2326  AND n_2327  AND n_2328;
delay_1960: n_2326  <= TRANSPORT a_N61  ;
delay_1961: n_2327  <= TRANSPORT a_N41_aNOT  ;
delay_1962: n_2328  <= TRANSPORT a_N797  ;
and1_1963: n_2329 <=  gnd;
dff_1964: DFF_a16450

    PORT MAP ( D => a_EQ292, CLK => a_N1356_aCLK, CLRN => vcc, PRN => vcc,
          Q => a_N1356);
xor2_1965: a_EQ292 <=  n_2335  XOR n_2343;
or2_1966: n_2335 <=  n_2336  OR n_2340;
and2_1967: n_2336 <=  n_2337  AND n_2338;
delay_1968: n_2337  <= TRANSPORT a_LC1_A10  ;
delay_1969: n_2338  <= TRANSPORT DIN(6)  ;
and2_1970: n_2340 <=  n_2341  AND n_2342;
inv_1971: n_2341  <= TRANSPORT NOT a_N797  ;
delay_1972: n_2342  <= TRANSPORT a_N1356  ;
and1_1973: n_2343 <=  gnd;
delay_1974: n_2344  <= TRANSPORT CLK  ;
filter_1975: FILTER_a16450

    PORT MAP (IN1 => n_2344, Y => a_N1356_aCLK);
dff_1976: DFF_a16450

    PORT MAP ( D => a_EQ297, CLK => a_N1361_aCLK, CLRN => vcc, PRN => vcc,
          Q => a_N1361);
xor2_1977: a_EQ297 <=  n_2352  XOR n_2359;
or2_1978: n_2352 <=  n_2353  OR n_2356;
and2_1979: n_2353 <=  n_2354  AND n_2355;
delay_1980: n_2354  <= TRANSPORT a_N797  ;
delay_1981: n_2355  <= TRANSPORT DIN(1)  ;
and2_1982: n_2356 <=  n_2357  AND n_2358;
inv_1983: n_2357  <= TRANSPORT NOT a_N797  ;
delay_1984: n_2358  <= TRANSPORT a_N1361  ;
and1_1985: n_2359 <=  gnd;
delay_1986: n_2360  <= TRANSPORT CLK  ;
filter_1987: FILTER_a16450

    PORT MAP (IN1 => n_2360, Y => a_N1361_aCLK);
dff_1988: DFF_a16450

    PORT MAP ( D => a_EQ294, CLK => a_N1358_aCLK, CLRN => vcc, PRN => vcc,
          Q => a_N1358);
xor2_1989: a_EQ294 <=  n_2367  XOR n_2374;
or2_1990: n_2367 <=  n_2368  OR n_2371;
and2_1991: n_2368 <=  n_2369  AND n_2370;
delay_1992: n_2369  <= TRANSPORT a_N797  ;
delay_1993: n_2370  <= TRANSPORT DIN(4)  ;
and2_1994: n_2371 <=  n_2372  AND n_2373;
inv_1995: n_2372  <= TRANSPORT NOT a_N797  ;
delay_1996: n_2373  <= TRANSPORT a_N1358  ;
and1_1997: n_2374 <=  gnd;
delay_1998: n_2375  <= TRANSPORT CLK  ;
filter_1999: FILTER_a16450

    PORT MAP (IN1 => n_2375, Y => a_N1358_aCLK);
dff_2000: DFF_a16450

    PORT MAP ( D => a_EQ293, CLK => a_N1357_aCLK, CLRN => vcc, PRN => vcc,
          Q => a_N1357);
xor2_2001: a_EQ293 <=  n_2382  XOR n_2390;
or2_2002: n_2382 <=  n_2383  OR n_2386;
and2_2003: n_2383 <=  n_2384  AND n_2385;
inv_2004: n_2384  <= TRANSPORT NOT a_N797  ;
delay_2005: n_2385  <= TRANSPORT a_N1357  ;
and3_2006: n_2386 <=  n_2387  AND n_2388  AND n_2389;
delay_2007: n_2387  <= TRANSPORT a_N61  ;
delay_2008: n_2388  <= TRANSPORT a_N797  ;
delay_2009: n_2389  <= TRANSPORT DIN(5)  ;
and1_2010: n_2390 <=  gnd;
delay_2011: n_2391  <= TRANSPORT CLK  ;
filter_2012: FILTER_a16450

    PORT MAP (IN1 => n_2391, Y => a_N1357_aCLK);
dff_2013: DFF_a16450

    PORT MAP ( D => a_EQ295, CLK => a_N1359_aCLK, CLRN => vcc, PRN => vcc,
          Q => a_N1359);
xor2_2014: a_EQ295 <=  n_2398  XOR n_2405;
or2_2015: n_2398 <=  n_2399  OR n_2402;
and2_2016: n_2399 <=  n_2400  AND n_2401;
delay_2017: n_2400  <= TRANSPORT a_N797  ;
delay_2018: n_2401  <= TRANSPORT DIN(3)  ;
and2_2019: n_2402 <=  n_2403  AND n_2404;
inv_2020: n_2403  <= TRANSPORT NOT a_N797  ;
delay_2021: n_2404  <= TRANSPORT a_N1359  ;
and1_2022: n_2405 <=  gnd;
delay_2023: n_2406  <= TRANSPORT CLK  ;
filter_2024: FILTER_a16450

    PORT MAP (IN1 => n_2406, Y => a_N1359_aCLK);
dff_2025: DFF_a16450

    PORT MAP ( D => a_EQ213, CLK => a_N682_aCLK, CLRN => a_N682_aCLRN, PRN => vcc,
          Q => a_N682);
inv_2026: a_N682_aCLRN  <= TRANSPORT NOT MR  ;
xor2_2027: a_EQ213 <=  n_2414  XOR n_2422;
or2_2028: n_2414 <=  n_2415  OR n_2419;
and3_2029: n_2415 <=  n_2416  AND n_2417  AND n_2418;
delay_2030: n_2416  <= TRANSPORT a_N785  ;
delay_2031: n_2417  <= TRANSPORT a_LC1_C20  ;
inv_2032: n_2418  <= TRANSPORT NOT a_N682  ;
and2_2033: n_2419 <=  n_2420  AND n_2421;
inv_2034: n_2420  <= TRANSPORT NOT a_N785  ;
delay_2035: n_2421  <= TRANSPORT a_N682  ;
and1_2036: n_2422 <=  gnd;
delay_2037: n_2423  <= TRANSPORT CLK  ;
filter_2038: FILTER_a16450

    PORT MAP (IN1 => n_2423, Y => a_N682_aCLK);
dff_2039: DFF_a16450

    PORT MAP ( D => a_EQ212, CLK => a_N681_aCLK, CLRN => a_N681_aCLRN, PRN => vcc,
          Q => a_N681);
inv_2040: a_N681_aCLRN  <= TRANSPORT NOT MR  ;
xor2_2041: a_EQ212 <=  n_2431  XOR n_2445;
or3_2042: n_2431 <=  n_2432  OR n_2436  OR n_2440;
and3_2043: n_2432 <=  n_2433  AND n_2434  AND n_2435;
delay_2044: n_2433  <= TRANSPORT a_N199  ;
inv_2045: n_2434  <= TRANSPORT NOT a_N682  ;
delay_2046: n_2435  <= TRANSPORT a_N681  ;
and3_2047: n_2436 <=  n_2437  AND n_2438  AND n_2439;
inv_2048: n_2437  <= TRANSPORT NOT a_N785  ;
delay_2049: n_2438  <= TRANSPORT a_N199  ;
delay_2050: n_2439  <= TRANSPORT a_N681  ;
and4_2051: n_2440 <=  n_2441  AND n_2442  AND n_2443  AND n_2444;
delay_2052: n_2441  <= TRANSPORT a_N785  ;
delay_2053: n_2442  <= TRANSPORT a_N199  ;
delay_2054: n_2443  <= TRANSPORT a_N682  ;
inv_2055: n_2444  <= TRANSPORT NOT a_N681  ;
and1_2056: n_2445 <=  gnd;
delay_2057: n_2446  <= TRANSPORT CLK  ;
filter_2058: FILTER_a16450

    PORT MAP (IN1 => n_2446, Y => a_N681_aCLK);
delay_2059: a_N179  <= TRANSPORT a_N179_aIN  ;
xor2_2060: a_N179_aIN <=  n_2450  XOR n_2454;
or1_2061: n_2450 <=  n_2451;
and2_2062: n_2451 <=  n_2452  AND n_2453;
delay_2063: n_2452  <= TRANSPORT a_N782  ;
delay_2064: n_2453  <= TRANSPORT a_N432  ;
and1_2065: n_2454 <=  gnd;
dff_2066: DFF_a16450

    PORT MAP ( D => a_EQ186, CLK => a_N430_aCLK, CLRN => a_N430_aCLRN, PRN => vcc,
          Q => a_N430);
inv_2067: a_N430_aCLRN  <= TRANSPORT NOT MR  ;
xor2_2068: a_EQ186 <=  n_2461  XOR n_2475;
or3_2069: n_2461 <=  n_2462  OR n_2466  OR n_2470;
and3_2070: n_2462 <=  n_2463  AND n_2464  AND n_2465;
delay_2071: n_2463  <= TRANSPORT a_N215_aNOT  ;
inv_2072: n_2464  <= TRANSPORT NOT a_N179  ;
delay_2073: n_2465  <= TRANSPORT a_N430  ;
and3_2074: n_2466 <=  n_2467  AND n_2468  AND n_2469;
delay_2075: n_2467  <= TRANSPORT a_N215_aNOT  ;
inv_2076: n_2468  <= TRANSPORT NOT a_N431  ;
delay_2077: n_2469  <= TRANSPORT a_N430  ;
and4_2078: n_2470 <=  n_2471  AND n_2472  AND n_2473  AND n_2474;
delay_2079: n_2471  <= TRANSPORT a_N215_aNOT  ;
delay_2080: n_2472  <= TRANSPORT a_N431  ;
delay_2081: n_2473  <= TRANSPORT a_N179  ;
inv_2082: n_2474  <= TRANSPORT NOT a_N430  ;
and1_2083: n_2475 <=  gnd;
delay_2084: n_2476  <= TRANSPORT RCLK  ;
filter_2085: FILTER_a16450

    PORT MAP (IN1 => n_2476, Y => a_N430_aCLK);
dff_2086: DFF_a16450

    PORT MAP ( D => a_EQ121, CLK => a_N106_aCLK, CLRN => a_N106_aCLRN, PRN => vcc,
          Q => a_N106);
inv_2087: a_N106_aCLRN  <= TRANSPORT NOT MR  ;
xor2_2088: a_EQ121 <=  n_2485  XOR n_2497;
or3_2089: n_2485 <=  n_2486  OR n_2491  OR n_2494;
and3_2090: n_2486 <=  n_2487  AND n_2488  AND n_2490;
delay_2091: n_2487  <= TRANSPORT a_N44  ;
delay_2092: n_2488  <= TRANSPORT a_N105  ;
delay_2093: n_2490  <= TRANSPORT a_N56  ;
and2_2094: n_2491 <=  n_2492  AND n_2493;
delay_2095: n_2492  <= TRANSPORT a_N106  ;
inv_2096: n_2493  <= TRANSPORT NOT a_N56  ;
and2_2097: n_2494 <=  n_2495  AND n_2496;
inv_2098: n_2495  <= TRANSPORT NOT a_N44  ;
delay_2099: n_2496  <= TRANSPORT a_N106  ;
and1_2100: n_2497 <=  gnd;
delay_2101: n_2498  <= TRANSPORT RCLK  ;
filter_2102: FILTER_a16450

    PORT MAP (IN1 => n_2498, Y => a_N106_aCLK);
dff_2103: DFF_a16450

    PORT MAP ( D => a_EQ118, CLK => a_N103_aCLK, CLRN => a_N103_aCLRN, PRN => vcc,
          Q => a_N103);
inv_2104: a_N103_aCLRN  <= TRANSPORT NOT MR  ;
xor2_2105: a_EQ118 <=  n_2507  XOR n_2518;
or3_2106: n_2507 <=  n_2508  OR n_2512  OR n_2515;
and3_2107: n_2508 <=  n_2509  AND n_2510  AND n_2511;
delay_2108: n_2509  <= TRANSPORT a_N44  ;
delay_2109: n_2510  <= TRANSPORT a_N102  ;
delay_2110: n_2511  <= TRANSPORT a_N56  ;
and2_2111: n_2512 <=  n_2513  AND n_2514;
delay_2112: n_2513  <= TRANSPORT a_N103  ;
inv_2113: n_2514  <= TRANSPORT NOT a_N56  ;
and2_2114: n_2515 <=  n_2516  AND n_2517;
inv_2115: n_2516  <= TRANSPORT NOT a_N44  ;
delay_2116: n_2517  <= TRANSPORT a_N103  ;
and1_2117: n_2518 <=  gnd;
delay_2118: n_2519  <= TRANSPORT RCLK  ;
filter_2119: FILTER_a16450

    PORT MAP (IN1 => n_2519, Y => a_N103_aCLK);
dff_2120: DFF_a16450

    PORT MAP ( D => a_EQ116, CLK => a_N101_aCLK, CLRN => a_N101_aCLRN, PRN => vcc,
          Q => a_N101);
inv_2121: a_N101_aCLRN  <= TRANSPORT NOT MR  ;
xor2_2122: a_EQ116 <=  n_2527  XOR n_2538;
or3_2123: n_2527 <=  n_2528  OR n_2532  OR n_2535;
and3_2124: n_2528 <=  n_2529  AND n_2530  AND n_2531;
delay_2125: n_2529  <= TRANSPORT a_N44  ;
delay_2126: n_2530  <= TRANSPORT a_N1369  ;
delay_2127: n_2531  <= TRANSPORT a_N56  ;
and2_2128: n_2532 <=  n_2533  AND n_2534;
delay_2129: n_2533  <= TRANSPORT a_N101  ;
inv_2130: n_2534  <= TRANSPORT NOT a_N56  ;
and2_2131: n_2535 <=  n_2536  AND n_2537;
inv_2132: n_2536  <= TRANSPORT NOT a_N44  ;
delay_2133: n_2537  <= TRANSPORT a_N101  ;
and1_2134: n_2538 <=  gnd;
delay_2135: n_2539  <= TRANSPORT RCLK  ;
filter_2136: FILTER_a16450

    PORT MAP (IN1 => n_2539, Y => a_N101_aCLK);
delay_2137: a_LC2_A3  <= TRANSPORT a_EQ254  ;
xor2_2138: a_EQ254 <=  n_2543  XOR n_2555;
or3_2139: n_2543 <=  n_2544  OR n_2548  OR n_2552;
and2_2140: n_2544 <=  n_2545  AND n_2546;
inv_2141: n_2545  <= TRANSPORT NOT a_N18  ;
inv_2142: n_2546  <= TRANSPORT NOT a_N1360  ;
and2_2143: n_2548 <=  n_2549  AND n_2550;
delay_2144: n_2549  <= TRANSPORT a_N18  ;
delay_2145: n_2550  <= TRANSPORT a_N534_aNOT  ;
and2_2146: n_2552 <=  n_2553  AND n_2554;
delay_2147: n_2553  <= TRANSPORT a_N18  ;
delay_2148: n_2554  <= TRANSPORT a_N785  ;
and1_2149: n_2555 <=  gnd;
dff_2150: DFF_a16450

    PORT MAP ( D => a_EQ203, CLK => a_N534_aNOT_aCLK, CLRN => a_N534_aNOT_aCLRN,
          PRN => vcc, Q => a_N534_aNOT);
inv_2151: a_N534_aNOT_aCLRN  <= TRANSPORT NOT MR  ;
xor2_2152: a_EQ203 <=  n_2562  XOR n_2569;
or2_2153: n_2562 <=  n_2563  OR n_2566;
and2_2154: n_2563 <=  n_2564  AND n_2565;
delay_2155: n_2564  <= TRANSPORT a_N533_aNOT  ;
delay_2156: n_2565  <= TRANSPORT a_LC2_A3  ;
and2_2157: n_2566 <=  n_2567  AND n_2568;
inv_2158: n_2567  <= TRANSPORT NOT a_N785  ;
delay_2159: n_2568  <= TRANSPORT a_LC2_A3  ;
and1_2160: n_2569 <=  gnd;
delay_2161: n_2570  <= TRANSPORT CLK  ;
filter_2162: FILTER_a16450

    PORT MAP (IN1 => n_2570, Y => a_N534_aNOT_aCLK);
delay_2163: a_LC2_B4  <= TRANSPORT a_EQ226  ;
xor2_2164: a_EQ226 <=  n_2574  XOR n_2595;
or4_2165: n_2574 <=  n_2575  OR n_2580  OR n_2585  OR n_2590;
and4_2166: n_2575 <=  n_2576  AND n_2577  AND n_2578  AND n_2579;
delay_2167: n_2576  <= TRANSPORT a_N1274  ;
delay_2168: n_2577  <= TRANSPORT a_N1275  ;
delay_2169: n_2578  <= TRANSPORT a_SDMSB_DAT_F6_G  ;
delay_2170: n_2579  <= TRANSPORT a_SDMSB_DAT_F7_G  ;
and4_2171: n_2580 <=  n_2581  AND n_2582  AND n_2583  AND n_2584;
inv_2172: n_2581  <= TRANSPORT NOT a_N1274  ;
delay_2173: n_2582  <= TRANSPORT a_N1275  ;
delay_2174: n_2583  <= TRANSPORT a_SDMSB_DAT_F6_G  ;
inv_2175: n_2584  <= TRANSPORT NOT a_SDMSB_DAT_F7_G  ;
and4_2176: n_2585 <=  n_2586  AND n_2587  AND n_2588  AND n_2589;
delay_2177: n_2586  <= TRANSPORT a_N1274  ;
inv_2178: n_2587  <= TRANSPORT NOT a_N1275  ;
inv_2179: n_2588  <= TRANSPORT NOT a_SDMSB_DAT_F6_G  ;
delay_2180: n_2589  <= TRANSPORT a_SDMSB_DAT_F7_G  ;
and4_2181: n_2590 <=  n_2591  AND n_2592  AND n_2593  AND n_2594;
inv_2182: n_2591  <= TRANSPORT NOT a_N1274  ;
inv_2183: n_2592  <= TRANSPORT NOT a_N1275  ;
inv_2184: n_2593  <= TRANSPORT NOT a_SDMSB_DAT_F6_G  ;
inv_2185: n_2594  <= TRANSPORT NOT a_SDMSB_DAT_F7_G  ;
and1_2186: n_2595 <=  gnd;
delay_2187: a_LC2_B21  <= TRANSPORT a_EQ231  ;
xor2_2188: a_EQ231 <=  n_2598  XOR n_2619;
or4_2189: n_2598 <=  n_2599  OR n_2604  OR n_2609  OR n_2614;
and4_2190: n_2599 <=  n_2600  AND n_2601  AND n_2602  AND n_2603;
delay_2191: n_2600  <= TRANSPORT a_N1288  ;
inv_2192: n_2601  <= TRANSPORT NOT a_N1289_aNOT  ;
delay_2193: n_2602  <= TRANSPORT a_SDLSB_DAT_F0_G  ;
delay_2194: n_2603  <= TRANSPORT a_SDLSB_DAT_F1_G  ;
and4_2195: n_2604 <=  n_2605  AND n_2606  AND n_2607  AND n_2608;
inv_2196: n_2605  <= TRANSPORT NOT a_N1288  ;
inv_2197: n_2606  <= TRANSPORT NOT a_N1289_aNOT  ;
delay_2198: n_2607  <= TRANSPORT a_SDLSB_DAT_F0_G  ;
inv_2199: n_2608  <= TRANSPORT NOT a_SDLSB_DAT_F1_G  ;
and4_2200: n_2609 <=  n_2610  AND n_2611  AND n_2612  AND n_2613;
delay_2201: n_2610  <= TRANSPORT a_N1288  ;
delay_2202: n_2611  <= TRANSPORT a_N1289_aNOT  ;
inv_2203: n_2612  <= TRANSPORT NOT a_SDLSB_DAT_F0_G  ;
delay_2204: n_2613  <= TRANSPORT a_SDLSB_DAT_F1_G  ;
and4_2205: n_2614 <=  n_2615  AND n_2616  AND n_2617  AND n_2618;
inv_2206: n_2615  <= TRANSPORT NOT a_N1288  ;
delay_2207: n_2616  <= TRANSPORT a_N1289_aNOT  ;
inv_2208: n_2617  <= TRANSPORT NOT a_SDLSB_DAT_F0_G  ;
inv_2209: n_2618  <= TRANSPORT NOT a_SDLSB_DAT_F1_G  ;
and1_2210: n_2619 <=  gnd;
delay_2211: a_LC5_B16  <= TRANSPORT a_EQ227  ;
xor2_2212: a_EQ227 <=  n_2622  XOR n_2643;
or4_2213: n_2622 <=  n_2623  OR n_2628  OR n_2633  OR n_2638;
and4_2214: n_2623 <=  n_2624  AND n_2625  AND n_2626  AND n_2627;
delay_2215: n_2624  <= TRANSPORT a_N1277  ;
delay_2216: n_2625  <= TRANSPORT a_N1285  ;
delay_2217: n_2626  <= TRANSPORT a_SDLSB_DAT_F4_G  ;
delay_2218: n_2627  <= TRANSPORT a_SDMSB_DAT_F4_G  ;
and4_2219: n_2628 <=  n_2629  AND n_2630  AND n_2631  AND n_2632;
delay_2220: n_2629  <= TRANSPORT a_N1277  ;
inv_2221: n_2630  <= TRANSPORT NOT a_N1285  ;
inv_2222: n_2631  <= TRANSPORT NOT a_SDLSB_DAT_F4_G  ;
delay_2223: n_2632  <= TRANSPORT a_SDMSB_DAT_F4_G  ;
and4_2224: n_2633 <=  n_2634  AND n_2635  AND n_2636  AND n_2637;
inv_2225: n_2634  <= TRANSPORT NOT a_N1277  ;
delay_2226: n_2635  <= TRANSPORT a_N1285  ;
delay_2227: n_2636  <= TRANSPORT a_SDLSB_DAT_F4_G  ;
inv_2228: n_2637  <= TRANSPORT NOT a_SDMSB_DAT_F4_G  ;
and4_2229: n_2638 <=  n_2639  AND n_2640  AND n_2641  AND n_2642;
inv_2230: n_2639  <= TRANSPORT NOT a_N1277  ;
inv_2231: n_2640  <= TRANSPORT NOT a_N1285  ;
inv_2232: n_2641  <= TRANSPORT NOT a_SDLSB_DAT_F4_G  ;
inv_2233: n_2642  <= TRANSPORT NOT a_SDMSB_DAT_F4_G  ;
and1_2234: n_2643 <=  gnd;
delay_2235: a_LC4_B16  <= TRANSPORT a_EQ228  ;
xor2_2236: a_EQ228 <=  n_2646  XOR n_2667;
or4_2237: n_2646 <=  n_2647  OR n_2652  OR n_2657  OR n_2662;
and4_2238: n_2647 <=  n_2648  AND n_2649  AND n_2650  AND n_2651;
inv_2239: n_2648  <= TRANSPORT NOT a_SDLSB_DAT_F6_G  ;
delay_2240: n_2649  <= TRANSPORT a_N1282  ;
inv_2241: n_2650  <= TRANSPORT NOT a_N1283  ;
delay_2242: n_2651  <= TRANSPORT a_SDLSB_DAT_F7_G  ;
and4_2243: n_2652 <=  n_2653  AND n_2654  AND n_2655  AND n_2656;
delay_2244: n_2653  <= TRANSPORT a_SDLSB_DAT_F6_G  ;
delay_2245: n_2654  <= TRANSPORT a_N1282  ;
delay_2246: n_2655  <= TRANSPORT a_N1283  ;
delay_2247: n_2656  <= TRANSPORT a_SDLSB_DAT_F7_G  ;
and4_2248: n_2657 <=  n_2658  AND n_2659  AND n_2660  AND n_2661;
inv_2249: n_2658  <= TRANSPORT NOT a_SDLSB_DAT_F6_G  ;
inv_2250: n_2659  <= TRANSPORT NOT a_N1282  ;
inv_2251: n_2660  <= TRANSPORT NOT a_N1283  ;
inv_2252: n_2661  <= TRANSPORT NOT a_SDLSB_DAT_F7_G  ;
and4_2253: n_2662 <=  n_2663  AND n_2664  AND n_2665  AND n_2666;
delay_2254: n_2663  <= TRANSPORT a_SDLSB_DAT_F6_G  ;
inv_2255: n_2664  <= TRANSPORT NOT a_N1282  ;
delay_2256: n_2665  <= TRANSPORT a_N1283  ;
inv_2257: n_2666  <= TRANSPORT NOT a_SDLSB_DAT_F7_G  ;
and1_2258: n_2667 <=  gnd;
delay_2259: a_LC3_B16  <= TRANSPORT a_EQ229  ;
xor2_2260: a_EQ229 <=  n_2670  XOR n_2691;
or4_2261: n_2670 <=  n_2671  OR n_2676  OR n_2681  OR n_2686;
and4_2262: n_2671 <=  n_2672  AND n_2673  AND n_2674  AND n_2675;
delay_2263: n_2672  <= TRANSPORT a_N1284  ;
delay_2264: n_2673  <= TRANSPORT a_N1279  ;
delay_2265: n_2674  <= TRANSPORT a_SDLSB_DAT_F5_G  ;
delay_2266: n_2675  <= TRANSPORT a_SDMSB_DAT_F2_G  ;
and4_2267: n_2676 <=  n_2677  AND n_2678  AND n_2679  AND n_2680;
delay_2268: n_2677  <= TRANSPORT a_N1284  ;
inv_2269: n_2678  <= TRANSPORT NOT a_N1279  ;
delay_2270: n_2679  <= TRANSPORT a_SDLSB_DAT_F5_G  ;
inv_2271: n_2680  <= TRANSPORT NOT a_SDMSB_DAT_F2_G  ;
and4_2272: n_2681 <=  n_2682  AND n_2683  AND n_2684  AND n_2685;
inv_2273: n_2682  <= TRANSPORT NOT a_N1284  ;
delay_2274: n_2683  <= TRANSPORT a_N1279  ;
inv_2275: n_2684  <= TRANSPORT NOT a_SDLSB_DAT_F5_G  ;
delay_2276: n_2685  <= TRANSPORT a_SDMSB_DAT_F2_G  ;
and4_2277: n_2686 <=  n_2687  AND n_2688  AND n_2689  AND n_2690;
inv_2278: n_2687  <= TRANSPORT NOT a_N1284  ;
inv_2279: n_2688  <= TRANSPORT NOT a_N1279  ;
inv_2280: n_2689  <= TRANSPORT NOT a_SDLSB_DAT_F5_G  ;
inv_2281: n_2690  <= TRANSPORT NOT a_SDMSB_DAT_F2_G  ;
and1_2282: n_2691 <=  gnd;
delay_2283: a_LC8_B16  <= TRANSPORT a_LC8_B16_aIN  ;
xor2_2284: a_LC8_B16_aIN <=  n_2694  XOR n_2699;
or1_2285: n_2694 <=  n_2695;
and3_2286: n_2695 <=  n_2696  AND n_2697  AND n_2698;
delay_2287: n_2696  <= TRANSPORT a_LC5_B16  ;
delay_2288: n_2697  <= TRANSPORT a_LC4_B16  ;
delay_2289: n_2698  <= TRANSPORT a_LC3_B16  ;
and1_2290: n_2699 <=  gnd;
delay_2291: a_LC6_B21  <= TRANSPORT a_EQ222  ;
xor2_2292: a_EQ222 <=  n_2702  XOR n_2723;
or4_2293: n_2702 <=  n_2703  OR n_2708  OR n_2713  OR n_2718;
and4_2294: n_2703 <=  n_2704  AND n_2705  AND n_2706  AND n_2707;
delay_2295: n_2704  <= TRANSPORT a_N1280  ;
delay_2296: n_2705  <= TRANSPORT a_N1278  ;
delay_2297: n_2706  <= TRANSPORT a_SDMSB_DAT_F1_G  ;
delay_2298: n_2707  <= TRANSPORT a_SDMSB_DAT_F3_G  ;
and4_2299: n_2708 <=  n_2709  AND n_2710  AND n_2711  AND n_2712;
delay_2300: n_2709  <= TRANSPORT a_N1280  ;
inv_2301: n_2710  <= TRANSPORT NOT a_N1278  ;
delay_2302: n_2711  <= TRANSPORT a_SDMSB_DAT_F1_G  ;
inv_2303: n_2712  <= TRANSPORT NOT a_SDMSB_DAT_F3_G  ;
and4_2304: n_2713 <=  n_2714  AND n_2715  AND n_2716  AND n_2717;
inv_2305: n_2714  <= TRANSPORT NOT a_N1280  ;
delay_2306: n_2715  <= TRANSPORT a_N1278  ;
inv_2307: n_2716  <= TRANSPORT NOT a_SDMSB_DAT_F1_G  ;
delay_2308: n_2717  <= TRANSPORT a_SDMSB_DAT_F3_G  ;
and4_2309: n_2718 <=  n_2719  AND n_2720  AND n_2721  AND n_2722;
inv_2310: n_2719  <= TRANSPORT NOT a_N1280  ;
inv_2311: n_2720  <= TRANSPORT NOT a_N1278  ;
inv_2312: n_2721  <= TRANSPORT NOT a_SDMSB_DAT_F1_G  ;
inv_2313: n_2722  <= TRANSPORT NOT a_SDMSB_DAT_F3_G  ;
and1_2314: n_2723 <=  gnd;
delay_2315: a_LC5_B21  <= TRANSPORT a_EQ223  ;
xor2_2316: a_EQ223 <=  n_2726  XOR n_2747;
or4_2317: n_2726 <=  n_2727  OR n_2732  OR n_2737  OR n_2742;
and4_2318: n_2727 <=  n_2728  AND n_2729  AND n_2730  AND n_2731;
delay_2319: n_2728  <= TRANSPORT a_N1286  ;
delay_2320: n_2729  <= TRANSPORT a_N1281  ;
delay_2321: n_2730  <= TRANSPORT a_SDMSB_DAT_F0_G  ;
delay_2322: n_2731  <= TRANSPORT a_SDLSB_DAT_F3_G  ;
and4_2323: n_2732 <=  n_2733  AND n_2734  AND n_2735  AND n_2736;
delay_2324: n_2733  <= TRANSPORT a_N1286  ;
inv_2325: n_2734  <= TRANSPORT NOT a_N1281  ;
inv_2326: n_2735  <= TRANSPORT NOT a_SDMSB_DAT_F0_G  ;
delay_2327: n_2736  <= TRANSPORT a_SDLSB_DAT_F3_G  ;
and4_2328: n_2737 <=  n_2738  AND n_2739  AND n_2740  AND n_2741;
inv_2329: n_2738  <= TRANSPORT NOT a_N1286  ;
delay_2330: n_2739  <= TRANSPORT a_N1281  ;
delay_2331: n_2740  <= TRANSPORT a_SDMSB_DAT_F0_G  ;
inv_2332: n_2741  <= TRANSPORT NOT a_SDLSB_DAT_F3_G  ;
and4_2333: n_2742 <=  n_2743  AND n_2744  AND n_2745  AND n_2746;
inv_2334: n_2743  <= TRANSPORT NOT a_N1286  ;
inv_2335: n_2744  <= TRANSPORT NOT a_N1281  ;
inv_2336: n_2745  <= TRANSPORT NOT a_SDMSB_DAT_F0_G  ;
inv_2337: n_2746  <= TRANSPORT NOT a_SDLSB_DAT_F3_G  ;
and1_2338: n_2747 <=  gnd;
delay_2339: a_LC4_B21  <= TRANSPORT a_EQ224  ;
xor2_2340: a_EQ224 <=  n_2750  XOR n_2771;
or4_2341: n_2750 <=  n_2751  OR n_2756  OR n_2761  OR n_2766;
and4_2342: n_2751 <=  n_2752  AND n_2753  AND n_2754  AND n_2755;
delay_2343: n_2752  <= TRANSPORT a_N1276  ;
delay_2344: n_2753  <= TRANSPORT a_N1287  ;
delay_2345: n_2754  <= TRANSPORT a_SDMSB_DAT_F5_G  ;
delay_2346: n_2755  <= TRANSPORT a_SDLSB_DAT_F2_G  ;
and4_2347: n_2756 <=  n_2757  AND n_2758  AND n_2759  AND n_2760;
delay_2348: n_2757  <= TRANSPORT a_N1276  ;
inv_2349: n_2758  <= TRANSPORT NOT a_N1287  ;
delay_2350: n_2759  <= TRANSPORT a_SDMSB_DAT_F5_G  ;
inv_2351: n_2760  <= TRANSPORT NOT a_SDLSB_DAT_F2_G  ;
and4_2352: n_2761 <=  n_2762  AND n_2763  AND n_2764  AND n_2765;
inv_2353: n_2762  <= TRANSPORT NOT a_N1276  ;
delay_2354: n_2763  <= TRANSPORT a_N1287  ;
inv_2355: n_2764  <= TRANSPORT NOT a_SDMSB_DAT_F5_G  ;
delay_2356: n_2765  <= TRANSPORT a_SDLSB_DAT_F2_G  ;
and4_2357: n_2766 <=  n_2767  AND n_2768  AND n_2769  AND n_2770;
inv_2358: n_2767  <= TRANSPORT NOT a_N1276  ;
inv_2359: n_2768  <= TRANSPORT NOT a_N1287  ;
inv_2360: n_2769  <= TRANSPORT NOT a_SDMSB_DAT_F5_G  ;
inv_2361: n_2770  <= TRANSPORT NOT a_SDLSB_DAT_F2_G  ;
and1_2362: n_2771 <=  gnd;
delay_2363: a_LC3_B21  <= TRANSPORT a_LC3_B21_aIN  ;
xor2_2364: a_LC3_B21_aIN <=  n_2774  XOR n_2779;
or1_2365: n_2774 <=  n_2775;
and3_2366: n_2775 <=  n_2776  AND n_2777  AND n_2778;
delay_2367: n_2776  <= TRANSPORT a_LC6_B21  ;
delay_2368: n_2777  <= TRANSPORT a_LC5_B21  ;
delay_2369: n_2778  <= TRANSPORT a_LC4_B21  ;
and1_2370: n_2779 <=  gnd;
delay_2371: a_N788  <= TRANSPORT a_N788_aIN  ;
xor2_2372: a_N788_aIN <=  n_2781  XOR n_2787;
or1_2373: n_2781 <=  n_2782;
and4_2374: n_2782 <=  n_2783  AND n_2784  AND n_2785  AND n_2786;
delay_2375: n_2783  <= TRANSPORT a_LC2_B4  ;
delay_2376: n_2784  <= TRANSPORT a_LC2_B21  ;
delay_2377: n_2785  <= TRANSPORT a_LC8_B16  ;
delay_2378: n_2786  <= TRANSPORT a_LC3_B21  ;
and1_2379: n_2787 <=  gnd;
dff_2380: DFF_a16450

    PORT MAP ( D => a_EQ276, CLK => a_N1293_aCLK, CLRN => a_N1293_aCLRN, PRN => vcc,
          Q => a_N1293);
inv_2381: a_N1293_aCLRN  <= TRANSPORT NOT MR  ;
xor2_2382: a_EQ276 <=  n_2795  XOR n_2802;
or2_2383: n_2795 <=  n_2796  OR n_2799;
and2_2384: n_2796 <=  n_2797  AND n_2798;
inv_2385: n_2797  <= TRANSPORT NOT a_N788  ;
delay_2386: n_2798  <= TRANSPORT a_N1293  ;
and2_2387: n_2799 <=  n_2800  AND n_2801;
delay_2388: n_2800  <= TRANSPORT a_N788  ;
inv_2389: n_2801  <= TRANSPORT NOT a_N1293  ;
and1_2390: n_2802 <=  gnd;
delay_2391: n_2803  <= TRANSPORT CLK  ;
filter_2392: FILTER_a16450

    PORT MAP (IN1 => n_2803, Y => a_N1293_aCLK);
dff_2393: DFF_a16450

    PORT MAP ( D => a_EQ275, CLK => a_N1292_aCLK, CLRN => a_N1292_aCLRN, PRN => vcc,
          Q => a_N1292);
inv_2394: a_N1292_aCLRN  <= TRANSPORT NOT MR  ;
xor2_2395: a_EQ275 <=  n_2812  XOR n_2823;
or3_2396: n_2812 <=  n_2813  OR n_2816  OR n_2819;
and2_2397: n_2813 <=  n_2814  AND n_2815;
inv_2398: n_2814  <= TRANSPORT NOT a_N1293  ;
delay_2399: n_2815  <= TRANSPORT a_N1292  ;
and2_2400: n_2816 <=  n_2817  AND n_2818;
inv_2401: n_2817  <= TRANSPORT NOT a_N788  ;
delay_2402: n_2818  <= TRANSPORT a_N1292  ;
and3_2403: n_2819 <=  n_2820  AND n_2821  AND n_2822;
delay_2404: n_2820  <= TRANSPORT a_N788  ;
delay_2405: n_2821  <= TRANSPORT a_N1293  ;
inv_2406: n_2822  <= TRANSPORT NOT a_N1292  ;
and1_2407: n_2823 <=  gnd;
delay_2408: n_2824  <= TRANSPORT CLK  ;
filter_2409: FILTER_a16450

    PORT MAP (IN1 => n_2824, Y => a_N1292_aCLK);
dff_2410: DFF_a16450

    PORT MAP ( D => a_EQ274, CLK => a_N1291_aCLK, CLRN => a_N1291_aCLRN, PRN => vcc,
          Q => a_N1291);
inv_2411: a_N1291_aCLRN  <= TRANSPORT NOT MR  ;
xor2_2412: a_EQ274 <=  n_2833  XOR n_2848;
or4_2413: n_2833 <=  n_2834  OR n_2837  OR n_2840  OR n_2843;
and2_2414: n_2834 <=  n_2835  AND n_2836;
inv_2415: n_2835  <= TRANSPORT NOT a_N1293  ;
delay_2416: n_2836  <= TRANSPORT a_N1291  ;
and2_2417: n_2837 <=  n_2838  AND n_2839;
inv_2418: n_2838  <= TRANSPORT NOT a_N788  ;
delay_2419: n_2839  <= TRANSPORT a_N1291  ;
and2_2420: n_2840 <=  n_2841  AND n_2842;
inv_2421: n_2841  <= TRANSPORT NOT a_N1292  ;
delay_2422: n_2842  <= TRANSPORT a_N1291  ;
and4_2423: n_2843 <=  n_2844  AND n_2845  AND n_2846  AND n_2847;
delay_2424: n_2844  <= TRANSPORT a_N788  ;
delay_2425: n_2845  <= TRANSPORT a_N1293  ;
delay_2426: n_2846  <= TRANSPORT a_N1292  ;
inv_2427: n_2847  <= TRANSPORT NOT a_N1291  ;
and1_2428: n_2848 <=  gnd;
delay_2429: n_2849  <= TRANSPORT CLK  ;
filter_2430: FILTER_a16450

    PORT MAP (IN1 => n_2849, Y => a_N1291_aCLK);
dff_2431: DFF_a16450

    PORT MAP ( D => a_EQ296, CLK => a_N1360_aCLK, CLRN => vcc, PRN => vcc,
          Q => a_N1360);
xor2_2432: a_EQ296 <=  n_2856  XOR n_2863;
or2_2433: n_2856 <=  n_2857  OR n_2860;
and2_2434: n_2857 <=  n_2858  AND n_2859;
delay_2435: n_2858  <= TRANSPORT a_N797  ;
delay_2436: n_2859  <= TRANSPORT DIN(2)  ;
and2_2437: n_2860 <=  n_2861  AND n_2862;
inv_2438: n_2861  <= TRANSPORT NOT a_N797  ;
delay_2439: n_2862  <= TRANSPORT a_N1360  ;
and1_2440: n_2863 <=  gnd;
delay_2441: n_2864  <= TRANSPORT CLK  ;
filter_2442: FILTER_a16450

    PORT MAP (IN1 => n_2864, Y => a_N1360_aCLK);
dff_2443: DFF_a16450

    PORT MAP ( D => a_EQ298, CLK => a_N1362_aCLK, CLRN => vcc, PRN => vcc,
          Q => a_N1362);
xor2_2444: a_EQ298 <=  n_2872  XOR n_2879;
or2_2445: n_2872 <=  n_2873  OR n_2876;
and2_2446: n_2873 <=  n_2874  AND n_2875;
inv_2447: n_2874  <= TRANSPORT NOT a_N797  ;
delay_2448: n_2875  <= TRANSPORT a_N1362  ;
and2_2449: n_2876 <=  n_2877  AND n_2878;
delay_2450: n_2877  <= TRANSPORT a_N797  ;
delay_2451: n_2878  <= TRANSPORT DIN(0)  ;
and1_2452: n_2879 <=  gnd;
delay_2453: n_2880  <= TRANSPORT CLK  ;
filter_2454: FILTER_a16450

    PORT MAP (IN1 => n_2880, Y => a_N1362_aCLK);
dff_2455: DFF_a16450

    PORT MAP ( D => baud_en_aD, CLK => baud_en_aCLK, CLRN => baud_en_aCLRN,
          PRN => vcc, Q => baud_en);
inv_2456: baud_en_aCLRN  <= TRANSPORT NOT MR  ;
xor2_2457: baud_en_aD <=  n_2888  XOR n_2894;
or1_2458: n_2888 <=  n_2889;
and4_2459: n_2889 <=  n_2890  AND n_2891  AND n_2892  AND n_2893;
delay_2460: n_2890  <= TRANSPORT a_N788  ;
delay_2461: n_2891  <= TRANSPORT a_N1293  ;
delay_2462: n_2892  <= TRANSPORT a_N1292  ;
delay_2463: n_2893  <= TRANSPORT a_N1291  ;
and1_2464: n_2894 <=  gnd;
delay_2465: n_2895  <= TRANSPORT CLK  ;
filter_2466: FILTER_a16450

    PORT MAP (IN1 => n_2895, Y => baud_en_aCLK);
delay_2467: a_LC4_C11  <= TRANSPORT a_EQ208  ;
xor2_2468: a_EQ208 <=  n_2899  XOR n_2906;
or3_2469: n_2899 <=  n_2900  OR n_2902  OR n_2904;
and1_2470: n_2900 <=  n_2901;
delay_2471: n_2901  <= TRANSPORT a_SLCNTL_DOUT_F0_G  ;
and1_2472: n_2902 <=  n_2903;
delay_2473: n_2903  <= TRANSPORT a_SLCNTL_DOUT_F1_G  ;
and1_2474: n_2904 <=  n_2905;
delay_2475: n_2905  <= TRANSPORT a_N37_aNOT  ;
and1_2476: n_2906 <=  gnd;
delay_2477: a_LC3_C11  <= TRANSPORT a_EQ209  ;
xor2_2478: a_EQ209 <=  n_2909  XOR n_2917;
or2_2479: n_2909 <=  n_2910  OR n_2913;
and2_2480: n_2910 <=  n_2911  AND n_2912;
inv_2481: n_2911  <= TRANSPORT NOT a_N214  ;
delay_2482: n_2912  <= TRANSPORT a_N1349  ;
and3_2483: n_2913 <=  n_2914  AND n_2915  AND n_2916;
inv_2484: n_2914  <= TRANSPORT NOT a_N214  ;
delay_2485: n_2915  <= TRANSPORT baud_en  ;
delay_2486: n_2916  <= TRANSPORT a_LC4_C11  ;
and1_2487: n_2917 <=  gnd;
dff_2488: DFF_a16450

    PORT MAP ( D => a_N1349_aD, CLK => a_N1349_aCLK, CLRN => a_N1349_aCLRN,
          PRN => vcc, Q => a_N1349);
inv_2489: a_N1349_aCLRN  <= TRANSPORT NOT MR  ;
xor2_2490: a_N1349_aD <=  n_2924  XOR n_2928;
or1_2491: n_2924 <=  n_2925;
and2_2492: n_2925 <=  n_2926  AND n_2927;
delay_2493: n_2926  <= TRANSPORT a_N20_aNOT  ;
delay_2494: n_2927  <= TRANSPORT a_LC3_C11  ;
and1_2495: n_2928 <=  gnd;
delay_2496: n_2929  <= TRANSPORT CLK  ;
filter_2497: FILTER_a16450

    PORT MAP (IN1 => n_2929, Y => a_N1349_aCLK);
delay_2498: a_LC6_C9_aNOT  <= TRANSPORT a_EQ234  ;
xor2_2499: a_EQ234 <=  n_2933  XOR n_2938;
or2_2500: n_2933 <=  n_2934  OR n_2936;
and1_2501: n_2934 <=  n_2935;
delay_2502: n_2935  <= TRANSPORT a_N57  ;
and1_2503: n_2936 <=  n_2937;
delay_2504: n_2937  <= TRANSPORT a_N56  ;
and1_2505: n_2938 <=  gnd;
delay_2506: a_N16_aNOT  <= TRANSPORT a_EQ064  ;
xor2_2507: a_EQ064 <=  n_2940  XOR n_2948;
or2_2508: n_2940 <=  n_2941  OR n_2944;
and2_2509: n_2941 <=  n_2942  AND n_2943;
delay_2510: n_2942  <= TRANSPORT en_lpbk  ;
delay_2511: n_2943  <= TRANSPORT lpbk_sin  ;
and2_2512: n_2944 <=  n_2945  AND n_2947;
delay_2513: n_2945  <= TRANSPORT SIN  ;
inv_2514: n_2947  <= TRANSPORT NOT en_lpbk  ;
and1_2515: n_2948 <=  gnd;
dff_2516: DFF_a16450

    PORT MAP ( D => a_N52_aNOT_aD, CLK => a_N52_aNOT_aCLK, CLRN => a_N52_aNOT_aCLRN,
          PRN => vcc, Q => a_N52_aNOT);
inv_2517: a_N52_aNOT_aCLRN  <= TRANSPORT NOT MR  ;
xor2_2518: a_N52_aNOT_aD <=  n_2956  XOR n_2959;
or1_2519: n_2956 <=  n_2957;
and1_2520: n_2957 <=  n_2958;
inv_2521: n_2958  <= TRANSPORT NOT a_N16_aNOT  ;
and1_2522: n_2959 <=  gnd;
delay_2523: n_2960  <= TRANSPORT RCLK  ;
filter_2524: FILTER_a16450

    PORT MAP (IN1 => n_2960, Y => a_N52_aNOT_aCLK);
dff_2525: DFF_a16450

    PORT MAP ( D => a_N50_aNOT_aD, CLK => a_N50_aNOT_aCLK, CLRN => a_N50_aNOT_aCLRN,
          PRN => vcc, Q => a_N50_aNOT);
inv_2526: a_N50_aNOT_aCLRN  <= TRANSPORT NOT MR  ;
xor2_2527: a_N50_aNOT_aD <=  n_2969  XOR n_2972;
or1_2528: n_2969 <=  n_2970;
and1_2529: n_2970 <=  n_2971;
delay_2530: n_2971  <= TRANSPORT a_N52_aNOT  ;
and1_2531: n_2972 <=  gnd;
delay_2532: n_2973  <= TRANSPORT RCLK  ;
filter_2533: FILTER_a16450

    PORT MAP (IN1 => n_2973, Y => a_N50_aNOT_aCLK);
delay_2534: a_N791_aNOT  <= TRANSPORT a_EQ233  ;
xor2_2535: a_EQ233 <=  n_2977  XOR n_2987;
or4_2536: n_2977 <=  n_2978  OR n_2980  OR n_2983  OR n_2985;
and1_2537: n_2978 <=  n_2979;
delay_2538: n_2979  <= TRANSPORT a_LC6_C9_aNOT  ;
and1_2539: n_2980 <=  n_2981;
delay_2540: n_2981  <= TRANSPORT a_N54  ;
and1_2541: n_2983 <=  n_2984;
delay_2542: n_2984  <= TRANSPORT a_N50_aNOT  ;
and1_2543: n_2985 <=  n_2986;
inv_2544: n_2986  <= TRANSPORT NOT a_N52_aNOT  ;
and1_2545: n_2987 <=  gnd;
delay_2546: a_N462_aNOT  <= TRANSPORT a_N462_aNOT_aIN  ;
xor2_2547: a_N462_aNOT_aIN <=  n_2990  XOR n_2994;
or1_2548: n_2990 <=  n_2991;
and2_2549: n_2991 <=  n_2992  AND n_2993;
delay_2550: n_2992  <= TRANSPORT a_N411  ;
delay_2551: n_2993  <= TRANSPORT a_N412  ;
and1_2552: n_2994 <=  gnd;
dff_2553: DFF_a16450

    PORT MAP ( D => a_EQ179, CLK => a_N409_aCLK, CLRN => a_N409_aCLRN, PRN => vcc,
          Q => a_N409);
inv_2554: a_N409_aCLRN  <= TRANSPORT NOT MR  ;
xor2_2555: a_EQ179 <=  n_3001  XOR n_3015;
or3_2556: n_3001 <=  n_3002  OR n_3006  OR n_3010;
and3_2557: n_3002 <=  n_3003  AND n_3004  AND n_3005;
delay_2558: n_3003  <= TRANSPORT a_N791_aNOT  ;
delay_2559: n_3004  <= TRANSPORT a_N409  ;
inv_2560: n_3005  <= TRANSPORT NOT a_N410  ;
and3_2561: n_3006 <=  n_3007  AND n_3008  AND n_3009;
delay_2562: n_3007  <= TRANSPORT a_N791_aNOT  ;
inv_2563: n_3008  <= TRANSPORT NOT a_N462_aNOT  ;
delay_2564: n_3009  <= TRANSPORT a_N409  ;
and4_2565: n_3010 <=  n_3011  AND n_3012  AND n_3013  AND n_3014;
delay_2566: n_3011  <= TRANSPORT a_N791_aNOT  ;
delay_2567: n_3012  <= TRANSPORT a_N462_aNOT  ;
inv_2568: n_3013  <= TRANSPORT NOT a_N409  ;
delay_2569: n_3014  <= TRANSPORT a_N410  ;
and1_2570: n_3015 <=  gnd;
delay_2571: n_3016  <= TRANSPORT RCLK  ;
filter_2572: FILTER_a16450

    PORT MAP (IN1 => n_3016, Y => a_N409_aCLK);
dff_2573: DFF_a16450

    PORT MAP ( D => a_EQ180, CLK => a_N410_aCLK, CLRN => a_N410_aCLRN, PRN => vcc,
          Q => a_N410);
inv_2574: a_N410_aCLRN  <= TRANSPORT NOT MR  ;
xor2_2575: a_EQ180 <=  n_3024  XOR n_3038;
or3_2576: n_3024 <=  n_3025  OR n_3029  OR n_3033;
and3_2577: n_3025 <=  n_3026  AND n_3027  AND n_3028;
delay_2578: n_3026  <= TRANSPORT a_N791_aNOT  ;
delay_2579: n_3027  <= TRANSPORT a_N410  ;
inv_2580: n_3028  <= TRANSPORT NOT a_N412  ;
and3_2581: n_3029 <=  n_3030  AND n_3031  AND n_3032;
delay_2582: n_3030  <= TRANSPORT a_N791_aNOT  ;
delay_2583: n_3031  <= TRANSPORT a_N410  ;
inv_2584: n_3032  <= TRANSPORT NOT a_N411  ;
and4_2585: n_3033 <=  n_3034  AND n_3035  AND n_3036  AND n_3037;
delay_2586: n_3034  <= TRANSPORT a_N791_aNOT  ;
inv_2587: n_3035  <= TRANSPORT NOT a_N410  ;
delay_2588: n_3036  <= TRANSPORT a_N411  ;
delay_2589: n_3037  <= TRANSPORT a_N412  ;
and1_2590: n_3038 <=  gnd;
delay_2591: n_3039  <= TRANSPORT RCLK  ;
filter_2592: FILTER_a16450

    PORT MAP (IN1 => n_3039, Y => a_N410_aCLK);
dff_2593: DFF_a16450

    PORT MAP ( D => a_EQ181, CLK => a_N411_aCLK, CLRN => a_N411_aCLRN, PRN => vcc,
          Q => a_N411);
inv_2594: a_N411_aCLRN  <= TRANSPORT NOT MR  ;
xor2_2595: a_EQ181 <=  n_3047  XOR n_3056;
or2_2596: n_3047 <=  n_3048  OR n_3052;
and3_2597: n_3048 <=  n_3049  AND n_3050  AND n_3051;
delay_2598: n_3049  <= TRANSPORT a_N791_aNOT  ;
inv_2599: n_3050  <= TRANSPORT NOT a_N411  ;
delay_2600: n_3051  <= TRANSPORT a_N412  ;
and3_2601: n_3052 <=  n_3053  AND n_3054  AND n_3055;
delay_2602: n_3053  <= TRANSPORT a_N791_aNOT  ;
delay_2603: n_3054  <= TRANSPORT a_N411  ;
inv_2604: n_3055  <= TRANSPORT NOT a_N412  ;
and1_2605: n_3056 <=  gnd;
delay_2606: n_3057  <= TRANSPORT RCLK  ;
filter_2607: FILTER_a16450

    PORT MAP (IN1 => n_3057, Y => a_N411_aCLK);
dff_2608: DFF_a16450

    PORT MAP ( D => a_N412_aD, CLK => a_N412_aCLK, CLRN => a_N412_aCLRN, PRN => vcc,
          Q => a_N412);
inv_2609: a_N412_aCLRN  <= TRANSPORT NOT MR  ;
xor2_2610: a_N412_aD <=  n_3065  XOR n_3069;
or1_2611: n_3065 <=  n_3066;
and2_2612: n_3066 <=  n_3067  AND n_3068;
delay_2613: n_3067  <= TRANSPORT a_N791_aNOT  ;
inv_2614: n_3068  <= TRANSPORT NOT a_N412  ;
and1_2615: n_3069 <=  gnd;
delay_2616: n_3070  <= TRANSPORT RCLK  ;
filter_2617: FILTER_a16450

    PORT MAP (IN1 => n_3070, Y => a_N412_aCLK);
delay_2618: a_N309  <= TRANSPORT a_EQ164  ;
xor2_2619: a_EQ164 <=  n_3074  XOR n_3083;
or4_2620: n_3074 <=  n_3075  OR n_3077  OR n_3079  OR n_3081;
and1_2621: n_3075 <=  n_3076;
delay_2622: n_3076  <= TRANSPORT a_SMSTAT_DAT_F1_G  ;
and1_2623: n_3077 <=  n_3078;
delay_2624: n_3078  <= TRANSPORT a_SMSTAT_DAT_F3_G  ;
and1_2625: n_3079 <=  n_3080;
delay_2626: n_3080  <= TRANSPORT a_SMSTAT_DAT_F2_G  ;
and1_2627: n_3081 <=  n_3082;
delay_2628: n_3082  <= TRANSPORT a_SMSTAT_DAT_F0_G  ;
and1_2629: n_3083 <=  gnd;
delay_2630: a_LC3_B15  <= TRANSPORT a_EQ326  ;
xor2_2631: a_EQ326 <=  n_3086  XOR n_3093;
or2_2632: n_3086 <=  n_3087  OR n_3090;
and2_2633: n_3087 <=  n_3088  AND n_3089;
delay_2634: n_3088  <= TRANSPORT a_N309  ;
delay_2635: n_3089  <= TRANSPORT a_SINTEN_DAT_F3_G  ;
and2_2636: n_3090 <=  n_3091  AND n_3092;
delay_2637: n_3091  <= TRANSPORT a_SINTEN_DAT_F1_G  ;
delay_2638: n_3092  <= TRANSPORT a_N10  ;
and1_2639: n_3093 <=  gnd;
delay_2640: a_N153_aNOT  <= TRANSPORT a_N153_aNOT_aIN  ;
xor2_2641: a_N153_aNOT_aIN <=  n_3096  XOR n_3100;
or1_2642: n_3096 <=  n_3097;
and2_2643: n_3097 <=  n_3098  AND n_3099;
delay_2644: n_3098  <= TRANSPORT a_SINTEN_DAT_F0_G  ;
delay_2645: n_3099  <= TRANSPORT a_SLSTAT_DAT_F0_G  ;
and1_2646: n_3100 <=  gnd;
delay_2647: a_N525  <= TRANSPORT a_EQ197  ;
xor2_2648: a_EQ197 <=  n_3103  XOR n_3112;
or4_2649: n_3103 <=  n_3104  OR n_3106  OR n_3108  OR n_3110;
and1_2650: n_3104 <=  n_3105;
delay_2651: n_3105  <= TRANSPORT a_SLSTAT_DAT_F2_G  ;
and1_2652: n_3106 <=  n_3107;
delay_2653: n_3107  <= TRANSPORT a_SLSTAT_DAT_F3_G  ;
and1_2654: n_3108 <=  n_3109;
delay_2655: n_3109  <= TRANSPORT a_SLSTAT_DAT_F4_G  ;
and1_2656: n_3110 <=  n_3111;
delay_2657: n_3111  <= TRANSPORT a_SLSTAT_DAT_F1_G  ;
and1_2658: n_3112 <=  gnd;
delay_2659: a_SINTR  <= TRANSPORT a_EQ325  ;
xor2_2660: a_EQ325 <=  n_3114  XOR n_3122;
or3_2661: n_3114 <=  n_3115  OR n_3117  OR n_3119;
and1_2662: n_3115 <=  n_3116;
delay_2663: n_3116  <= TRANSPORT a_LC3_B15  ;
and1_2664: n_3117 <=  n_3118;
delay_2665: n_3118  <= TRANSPORT a_N153_aNOT  ;
and2_2666: n_3119 <=  n_3120  AND n_3121;
delay_2667: n_3120  <= TRANSPORT a_N525  ;
delay_2668: n_3121  <= TRANSPORT a_SINTEN_DAT_F2_G  ;
and1_2669: n_3122 <=  gnd;
delay_2670: a_N806  <= TRANSPORT a_N806_aIN  ;
xor2_2671: a_N806_aIN <=  n_3125  XOR n_3131;
or1_2672: n_3125 <=  n_3126;
and2_2673: n_3126 <=  n_3127  AND n_3129;
inv_2674: n_3127  <= TRANSPORT NOT a_N9  ;
delay_2675: n_3129  <= TRANSPORT a_N8  ;
and1_2676: n_3131 <=  gnd;
dff_2677: DFF_a16450

    PORT MAP ( D => a_EQ322, CLK => a_SINTID_DAT_F0_G_aNOT_aCLK, CLRN => a_SINTID_DAT_F0_G_aNOT_aCLRN,
          PRN => vcc, Q => a_SINTID_DAT_F0_G_aNOT);
inv_2678: a_SINTID_DAT_F0_G_aNOT_aCLRN  <= TRANSPORT NOT MR  ;
xor2_2679: a_EQ322 <=  n_3138  XOR n_3145;
or2_2680: n_3138 <=  n_3139  OR n_3142;
and2_2681: n_3139 <=  n_3140  AND n_3141;
delay_2682: n_3140  <= TRANSPORT a_SINTR  ;
delay_2683: n_3141  <= TRANSPORT a_N806  ;
and2_2684: n_3142 <=  n_3143  AND n_3144;
inv_2685: n_3143  <= TRANSPORT NOT a_N806  ;
delay_2686: n_3144  <= TRANSPORT a_SINTID_DAT_F0_G_aNOT  ;
and1_2687: n_3145 <=  gnd;
delay_2688: n_3146  <= TRANSPORT CLK  ;
filter_2689: FILTER_a16450

    PORT MAP (IN1 => n_3146, Y => a_SINTID_DAT_F0_G_aNOT_aCLK);
dff_2690: DFF_a16450

    PORT MAP ( D => a_EQ120, CLK => a_N105_aCLK, CLRN => a_N105_aCLRN, PRN => vcc,
          Q => a_N105);
inv_2691: a_N105_aCLRN  <= TRANSPORT NOT MR  ;
xor2_2692: a_EQ120 <=  n_3154  XOR n_3166;
or3_2693: n_3154 <=  n_3155  OR n_3160  OR n_3163;
and3_2694: n_3155 <=  n_3156  AND n_3157  AND n_3159;
delay_2695: n_3156  <= TRANSPORT a_N44  ;
delay_2696: n_3157  <= TRANSPORT a_N104  ;
delay_2697: n_3159  <= TRANSPORT a_N56  ;
and2_2698: n_3160 <=  n_3161  AND n_3162;
delay_2699: n_3161  <= TRANSPORT a_N105  ;
inv_2700: n_3162  <= TRANSPORT NOT a_N56  ;
and2_2701: n_3163 <=  n_3164  AND n_3165;
inv_2702: n_3164  <= TRANSPORT NOT a_N44  ;
delay_2703: n_3165  <= TRANSPORT a_N105  ;
and1_2704: n_3166 <=  gnd;
delay_2705: n_3167  <= TRANSPORT RCLK  ;
filter_2706: FILTER_a16450

    PORT MAP (IN1 => n_3167, Y => a_N105_aCLK);
delay_2707: a_N35  <= TRANSPORT a_N35_aIN  ;
xor2_2708: a_N35_aIN <=  n_3170  XOR n_3175;
or1_2709: n_3170 <=  n_3171;
and3_2710: n_3171 <=  n_3172  AND n_3173  AND n_3174;
inv_2711: n_3172  <= TRANSPORT NOT a_N1310  ;
delay_2712: n_3173  <= TRANSPORT a_N1311  ;
delay_2713: n_3174  <= TRANSPORT a_N1312  ;
and1_2714: n_3175 <=  gnd;
dff_2715: DFF_a16450

    PORT MAP ( D => a_EQ328, CLK => a_SLCNTL_DOUT_F1_G_aCLK, CLRN => a_SLCNTL_DOUT_F1_G_aCLRN,
          PRN => vcc, Q => a_SLCNTL_DOUT_F1_G);
inv_2716: a_SLCNTL_DOUT_F1_G_aCLRN  <= TRANSPORT NOT MR  ;
xor2_2717: a_EQ328 <=  n_3182  XOR n_3193;
or3_2718: n_3182 <=  n_3183  OR n_3187  OR n_3190;
and3_2719: n_3183 <=  n_3184  AND n_3185  AND n_3186;
delay_2720: n_3184  <= TRANSPORT a_N804  ;
delay_2721: n_3185  <= TRANSPORT a_N35  ;
delay_2722: n_3186  <= TRANSPORT DIN(1)  ;
and2_2723: n_3187 <=  n_3188  AND n_3189;
inv_2724: n_3188  <= TRANSPORT NOT a_N35  ;
delay_2725: n_3189  <= TRANSPORT a_SLCNTL_DOUT_F1_G  ;
and2_2726: n_3190 <=  n_3191  AND n_3192;
inv_2727: n_3191  <= TRANSPORT NOT a_N804  ;
delay_2728: n_3192  <= TRANSPORT a_SLCNTL_DOUT_F1_G  ;
and1_2729: n_3193 <=  gnd;
inv_2730: n_3194  <= TRANSPORT NOT CLK  ;
filter_2731: FILTER_a16450

    PORT MAP (IN1 => n_3194, Y => a_SLCNTL_DOUT_F1_G_aCLK);
dff_2732: DFF_a16450

    PORT MAP ( D => a_EQ122, CLK => a_N107_aCLK, CLRN => a_N107_aCLRN, PRN => vcc,
          Q => a_N107);
inv_2733: a_N107_aCLRN  <= TRANSPORT NOT MR  ;
xor2_2734: a_EQ122 <=  n_3202  XOR n_3213;
or3_2735: n_3202 <=  n_3203  OR n_3207  OR n_3210;
and3_2736: n_3203 <=  n_3204  AND n_3205  AND n_3206;
delay_2737: n_3204  <= TRANSPORT a_N44  ;
delay_2738: n_3205  <= TRANSPORT a_N106  ;
delay_2739: n_3206  <= TRANSPORT a_N56  ;
and2_2740: n_3207 <=  n_3208  AND n_3209;
delay_2741: n_3208  <= TRANSPORT a_N107  ;
inv_2742: n_3209  <= TRANSPORT NOT a_N56  ;
and2_2743: n_3210 <=  n_3211  AND n_3212;
inv_2744: n_3211  <= TRANSPORT NOT a_N44  ;
delay_2745: n_3212  <= TRANSPORT a_N107  ;
and1_2746: n_3213 <=  gnd;
delay_2747: n_3214  <= TRANSPORT RCLK  ;
filter_2748: FILTER_a16450

    PORT MAP (IN1 => n_3214, Y => a_N107_aCLK);
delay_2749: a_LC2_B15  <= TRANSPORT a_EQ244  ;
xor2_2750: a_EQ244 <=  n_3218  XOR n_3224;
or2_2751: n_3218 <=  n_3219  OR n_3222;
and2_2752: n_3219 <=  n_3220  AND n_3221;
delay_2753: n_3220  <= TRANSPORT a_N525  ;
delay_2754: n_3221  <= TRANSPORT a_SINTEN_DAT_F2_G  ;
and1_2755: n_3222 <=  n_3223;
inv_2756: n_3223  <= TRANSPORT NOT a_N806  ;
and1_2757: n_3224 <=  gnd;
dff_2758: DFF_a16450

    PORT MAP ( D => a_EQ324, CLK => a_SINTID_DAT_F2_G_aCLK, CLRN => a_SINTID_DAT_F2_G_aCLRN,
          PRN => vcc, Q => a_SINTID_DAT_F2_G);
inv_2759: a_SINTID_DAT_F2_G_aCLRN  <= TRANSPORT NOT MR  ;
xor2_2760: a_EQ324 <=  n_3231  XOR n_3244;
or4_2761: n_3231 <=  n_3232  OR n_3235  OR n_3238  OR n_3241;
and2_2762: n_3232 <=  n_3233  AND n_3234;
delay_2763: n_3233  <= TRANSPORT a_LC2_B15  ;
delay_2764: n_3234  <= TRANSPORT a_SINTID_DAT_F2_G  ;
and2_2765: n_3235 <=  n_3236  AND n_3237;
delay_2766: n_3236  <= TRANSPORT a_N153_aNOT  ;
delay_2767: n_3237  <= TRANSPORT a_SINTID_DAT_F2_G  ;
and2_2768: n_3238 <=  n_3239  AND n_3240;
delay_2769: n_3239  <= TRANSPORT a_N806  ;
delay_2770: n_3240  <= TRANSPORT a_LC2_B15  ;
and2_2771: n_3241 <=  n_3242  AND n_3243;
delay_2772: n_3242  <= TRANSPORT a_N153_aNOT  ;
delay_2773: n_3243  <= TRANSPORT a_N806  ;
and1_2774: n_3244 <=  gnd;
delay_2775: n_3245  <= TRANSPORT CLK  ;
filter_2776: FILTER_a16450

    PORT MAP (IN1 => n_3245, Y => a_SINTID_DAT_F2_G_aCLK);
delay_2777: a_N32  <= TRANSPORT a_N32_aIN  ;
xor2_2778: a_N32_aIN <=  n_3248  XOR n_3253;
or1_2779: n_3248 <=  n_3249;
and3_2780: n_3249 <=  n_3250  AND n_3251  AND n_3252;
delay_2781: n_3250  <= TRANSPORT a_N1310  ;
delay_2782: n_3251  <= TRANSPORT a_N1311  ;
delay_2783: n_3252  <= TRANSPORT a_N1312  ;
and1_2784: n_3253 <=  gnd;
dff_2785: DFF_a16450

    PORT MAP ( D => a_EQ284, CLK => a_N1317_aCLK, CLRN => a_N1317_aCLRN, PRN => vcc,
          Q => a_N1317);
inv_2786: a_N1317_aCLRN  <= TRANSPORT NOT MR  ;
xor2_2787: a_EQ284 <=  n_3260  XOR n_3271;
or3_2788: n_3260 <=  n_3261  OR n_3265  OR n_3268;
and3_2789: n_3261 <=  n_3262  AND n_3263  AND n_3264;
delay_2790: n_3262  <= TRANSPORT a_N804  ;
delay_2791: n_3263  <= TRANSPORT a_N32  ;
delay_2792: n_3264  <= TRANSPORT DIN(3)  ;
and2_2793: n_3265 <=  n_3266  AND n_3267;
inv_2794: n_3266  <= TRANSPORT NOT a_N32  ;
delay_2795: n_3267  <= TRANSPORT a_N1317  ;
and2_2796: n_3268 <=  n_3269  AND n_3270;
inv_2797: n_3269  <= TRANSPORT NOT a_N804  ;
delay_2798: n_3270  <= TRANSPORT a_N1317  ;
and1_2799: n_3271 <=  gnd;
inv_2800: n_3272  <= TRANSPORT NOT CLK  ;
filter_2801: FILTER_a16450

    PORT MAP (IN1 => n_3272, Y => a_N1317_aCLK);
dff_2802: DFF_a16450

    PORT MAP ( D => a_EQ119, CLK => a_N104_aCLK, CLRN => a_N104_aCLRN, PRN => vcc,
          Q => a_N104);
inv_2803: a_N104_aCLRN  <= TRANSPORT NOT MR  ;
xor2_2804: a_EQ119 <=  n_3280  XOR n_3291;
or3_2805: n_3280 <=  n_3281  OR n_3285  OR n_3288;
and3_2806: n_3281 <=  n_3282  AND n_3283  AND n_3284;
delay_2807: n_3282  <= TRANSPORT a_N44  ;
delay_2808: n_3283  <= TRANSPORT a_N103  ;
delay_2809: n_3284  <= TRANSPORT a_N56  ;
and2_2810: n_3285 <=  n_3286  AND n_3287;
delay_2811: n_3286  <= TRANSPORT a_N104  ;
inv_2812: n_3287  <= TRANSPORT NOT a_N56  ;
and2_2813: n_3288 <=  n_3289  AND n_3290;
inv_2814: n_3289  <= TRANSPORT NOT a_N44  ;
delay_2815: n_3290  <= TRANSPORT a_N104  ;
and1_2816: n_3291 <=  gnd;
delay_2817: n_3292  <= TRANSPORT RCLK  ;
filter_2818: FILTER_a16450

    PORT MAP (IN1 => n_3292, Y => a_N104_aCLK);
delay_2819: a_LC1_A3  <= TRANSPORT a_EQ255  ;
xor2_2820: a_EQ255 <=  n_3296  XOR n_3307;
or3_2821: n_3296 <=  n_3297  OR n_3300  OR n_3304;
and2_2822: n_3297 <=  n_3298  AND n_3299;
inv_2823: n_3298  <= TRANSPORT NOT a_N18  ;
inv_2824: n_3299  <= TRANSPORT NOT a_N1361  ;
and2_2825: n_3300 <=  n_3301  AND n_3302;
delay_2826: n_3301  <= TRANSPORT a_N18  ;
delay_2827: n_3302  <= TRANSPORT a_N535_aNOT  ;
and2_2828: n_3304 <=  n_3305  AND n_3306;
delay_2829: n_3305  <= TRANSPORT a_N18  ;
delay_2830: n_3306  <= TRANSPORT a_N785  ;
and1_2831: n_3307 <=  gnd;
dff_2832: DFF_a16450

    PORT MAP ( D => a_EQ204, CLK => a_N535_aNOT_aCLK, CLRN => a_N535_aNOT_aCLRN,
          PRN => vcc, Q => a_N535_aNOT);
inv_2833: a_N535_aNOT_aCLRN  <= TRANSPORT NOT MR  ;
xor2_2834: a_EQ204 <=  n_3314  XOR n_3321;
or2_2835: n_3314 <=  n_3315  OR n_3318;
and2_2836: n_3315 <=  n_3316  AND n_3317;
delay_2837: n_3316  <= TRANSPORT a_N534_aNOT  ;
delay_2838: n_3317  <= TRANSPORT a_LC1_A3  ;
and2_2839: n_3318 <=  n_3319  AND n_3320;
inv_2840: n_3319  <= TRANSPORT NOT a_N785  ;
delay_2841: n_3320  <= TRANSPORT a_LC1_A3  ;
and1_2842: n_3321 <=  gnd;
delay_2843: n_3322  <= TRANSPORT CLK  ;
filter_2844: FILTER_a16450

    PORT MAP (IN1 => n_3322, Y => a_N535_aNOT_aCLK);
dff_2845: DFF_a16450

    PORT MAP ( D => a_N9_aD, CLK => a_N9_aCLK, CLRN => a_N9_aCLRN, PRN => vcc,
          Q => a_N9);
inv_2846: a_N9_aCLRN  <= TRANSPORT NOT MR  ;
xor2_2847: a_N9_aD <=  n_3330  XOR n_3333;
or1_2848: n_3330 <=  n_3331;
and1_2849: n_3331 <=  n_3332;
delay_2850: n_3332  <= TRANSPORT a_N8  ;
and1_2851: n_3333 <=  gnd;
inv_2852: n_3334  <= TRANSPORT NOT CLK  ;
filter_2853: FILTER_a16450

    PORT MAP (IN1 => n_3334, Y => a_N9_aCLK);
delay_2854: a_N31  <= TRANSPORT a_N31_aIN  ;
xor2_2855: a_N31_aIN <=  n_3337  XOR n_3342;
or1_2856: n_3337 <=  n_3338;
and3_2857: n_3338 <=  n_3339  AND n_3340  AND n_3341;
inv_2858: n_3339  <= TRANSPORT NOT a_N1310  ;
delay_2859: n_3340  <= TRANSPORT a_N1311  ;
inv_2860: n_3341  <= TRANSPORT NOT a_N1312  ;
and1_2861: n_3342 <=  gnd;
dff_2862: DFF_a16450

    PORT MAP ( D => a_EQ057, CLK => a_N8_aCLK, CLRN => a_N8_aCLRN, PRN => vcc,
          Q => a_N8);
inv_2863: a_N8_aCLRN  <= TRANSPORT NOT MR  ;
xor2_2864: a_EQ057 <=  n_3349  XOR n_3358;
or2_2865: n_3349 <=  n_3350  OR n_3354;
and3_2866: n_3350 <=  n_3351  AND n_3352  AND n_3353;
delay_2867: n_3351  <= TRANSPORT a_SCSOUT  ;
delay_2868: n_3352  <= TRANSPORT a_N31  ;
inv_2869: n_3353  <= TRANSPORT NOT nRD  ;
and3_2870: n_3354 <=  n_3355  AND n_3356  AND n_3357;
delay_2871: n_3355  <= TRANSPORT a_SCSOUT  ;
delay_2872: n_3356  <= TRANSPORT a_N31  ;
delay_2873: n_3357  <= TRANSPORT RD  ;
and1_2874: n_3358 <=  gnd;
inv_2875: n_3359  <= TRANSPORT NOT CLK  ;
filter_2876: FILTER_a16450

    PORT MAP (IN1 => n_3359, Y => a_N8_aCLK);
dff_2877: DFF_a16450

    PORT MAP ( D => a_EQ299, CLK => a_N1369_aCLK, CLRN => a_N1369_aCLRN, PRN => vcc,
          Q => a_N1369);
inv_2878: a_N1369_aCLRN  <= TRANSPORT NOT MR  ;
xor2_2879: a_EQ299 <=  n_3367  XOR n_3378;
or3_2880: n_3367 <=  n_3368  OR n_3372  OR n_3375;
and3_2881: n_3368 <=  n_3369  AND n_3370  AND n_3371;
delay_2882: n_3369  <= TRANSPORT a_N44  ;
delay_2883: n_3370  <= TRANSPORT a_N16_aNOT  ;
delay_2884: n_3371  <= TRANSPORT a_N56  ;
and2_2885: n_3372 <=  n_3373  AND n_3374;
delay_2886: n_3373  <= TRANSPORT a_N1369  ;
inv_2887: n_3374  <= TRANSPORT NOT a_N56  ;
and2_2888: n_3375 <=  n_3376  AND n_3377;
inv_2889: n_3376  <= TRANSPORT NOT a_N44  ;
delay_2890: n_3377  <= TRANSPORT a_N1369  ;
and1_2891: n_3378 <=  gnd;
delay_2892: n_3379  <= TRANSPORT RCLK  ;
filter_2893: FILTER_a16450

    PORT MAP (IN1 => n_3379, Y => a_N1369_aCLK);
delay_2894: a_N435  <= TRANSPORT a_N435_aIN  ;
xor2_2895: a_N435_aIN <=  n_3383  XOR n_3389;
or1_2896: n_3383 <=  n_3384;
and4_2897: n_3384 <=  n_3385  AND n_3386  AND n_3387  AND n_3388;
inv_2898: n_3385  <= TRANSPORT NOT a_LC3_C12  ;
delay_2899: n_3386  <= TRANSPORT a_N782  ;
delay_2900: n_3387  <= TRANSPORT a_N430  ;
delay_2901: n_3388  <= TRANSPORT a_SLCNTL_DOUT_F3_G  ;
and1_2902: n_3389 <=  gnd;
dff_2903: DFF_a16450

    PORT MAP ( D => a_EQ102, CLK => a_N57_aCLK, CLRN => a_N57_aCLRN, PRN => vcc,
          Q => a_N57);
inv_2904: a_N57_aCLRN  <= TRANSPORT NOT MR  ;
xor2_2905: a_EQ102 <=  n_3396  XOR n_3404;
or3_2906: n_3396 <=  n_3397  OR n_3399  OR n_3402;
and1_2907: n_3397 <=  n_3398;
delay_2908: n_3398  <= TRANSPORT a_N435  ;
and2_2909: n_3399 <=  n_3400  AND n_3401;
inv_2910: n_3400  <= TRANSPORT NOT a_N44  ;
delay_2911: n_3401  <= TRANSPORT a_N57  ;
and1_2912: n_3402 <=  n_3403;
inv_2913: n_3403  <= TRANSPORT NOT a_N791_aNOT  ;
and1_2914: n_3404 <=  gnd;
delay_2915: n_3405  <= TRANSPORT RCLK  ;
filter_2916: FILTER_a16450

    PORT MAP (IN1 => n_3405, Y => a_N57_aCLK);
delay_2917: a_LC7_C12  <= TRANSPORT a_EQ185  ;
xor2_2918: a_EQ185 <=  n_3409  XOR n_3416;
or3_2919: n_3409 <=  n_3410  OR n_3412  OR n_3414;
and1_2920: n_3410 <=  n_3411;
delay_2921: n_3411  <= TRANSPORT a_SLCNTL_DOUT_F3_G  ;
and1_2922: n_3412 <=  n_3413;
inv_2923: n_3413  <= TRANSPORT NOT a_N430  ;
and1_2924: n_3414 <=  n_3415;
delay_2925: n_3415  <= TRANSPORT a_LC3_C12  ;
and1_2926: n_3416 <=  gnd;
dff_2927: DFF_a16450

    PORT MAP ( D => a_EQ101, CLK => a_N56_aCLK, CLRN => a_N56_aCLRN, PRN => vcc,
          Q => a_N56);
inv_2928: a_N56_aCLRN  <= TRANSPORT NOT MR  ;
xor2_2929: a_EQ101 <=  n_3423  XOR n_3435;
or3_2930: n_3423 <=  n_3424  OR n_3428  OR n_3431;
and3_2931: n_3424 <=  n_3425  AND n_3426  AND n_3427;
inv_2932: n_3425  <= TRANSPORT NOT a_N57  ;
delay_2933: n_3426  <= TRANSPORT a_LC7_C12  ;
delay_2934: n_3427  <= TRANSPORT a_N56  ;
and2_2935: n_3428 <=  n_3429  AND n_3430;
inv_2936: n_3429  <= TRANSPORT NOT a_N44  ;
delay_2937: n_3430  <= TRANSPORT a_N56  ;
and3_2938: n_3431 <=  n_3432  AND n_3433  AND n_3434;
delay_2939: n_3432  <= TRANSPORT a_N44  ;
delay_2940: n_3433  <= TRANSPORT a_N57  ;
inv_2941: n_3434  <= TRANSPORT NOT a_N56  ;
and1_2942: n_3435 <=  gnd;
delay_2943: n_3436  <= TRANSPORT RCLK  ;
filter_2944: FILTER_a16450

    PORT MAP (IN1 => n_3436, Y => a_N56_aCLK);
delay_2945: a_LC7_C9  <= TRANSPORT a_EQ184  ;
xor2_2946: a_EQ184 <=  n_3440  XOR n_3449;
or2_2947: n_3440 <=  n_3441  OR n_3445;
and3_2948: n_3441 <=  n_3442  AND n_3443  AND n_3444;
delay_2949: n_3442  <= TRANSPORT a_N44  ;
delay_2950: n_3443  <= TRANSPORT a_N57  ;
delay_2951: n_3444  <= TRANSPORT a_N56  ;
and3_2952: n_3445 <=  n_3446  AND n_3447  AND n_3448;
delay_2953: n_3446  <= TRANSPORT a_N44  ;
inv_2954: n_3447  <= TRANSPORT NOT a_LC7_C12  ;
delay_2955: n_3448  <= TRANSPORT a_N56  ;
and1_2956: n_3449 <=  gnd;
dff_2957: DFF_a16450

    PORT MAP ( D => a_EQ096, CLK => a_N54_aCLK, CLRN => a_N54_aCLRN, PRN => vcc,
          Q => a_N54);
inv_2958: a_N54_aCLRN  <= TRANSPORT NOT MR  ;
xor2_2959: a_EQ096 <=  n_3456  XOR n_3463;
or2_2960: n_3456 <=  n_3457  OR n_3459;
and1_2961: n_3457 <=  n_3458;
delay_2962: n_3458  <= TRANSPORT a_LC7_C9  ;
and3_2963: n_3459 <=  n_3460  AND n_3461  AND n_3462;
inv_2964: n_3460  <= TRANSPORT NOT a_N44  ;
inv_2965: n_3461  <= TRANSPORT NOT a_LC6_C9_aNOT  ;
delay_2966: n_3462  <= TRANSPORT a_N54  ;
and1_2967: n_3463 <=  gnd;
delay_2968: n_3464  <= TRANSPORT RCLK  ;
filter_2969: FILTER_a16450

    PORT MAP (IN1 => n_3464, Y => a_N54_aCLK);
dff_2970: DFF_a16450

    PORT MAP ( D => a_EQ330, CLK => a_SLCNTL_DOUT_F3_G_aCLK, CLRN => a_SLCNTL_DOUT_F3_G_aCLRN,
          PRN => vcc, Q => a_SLCNTL_DOUT_F3_G);
inv_2971: a_SLCNTL_DOUT_F3_G_aCLRN  <= TRANSPORT NOT MR  ;
xor2_2972: a_EQ330 <=  n_3472  XOR n_3483;
or3_2973: n_3472 <=  n_3473  OR n_3477  OR n_3480;
and3_2974: n_3473 <=  n_3474  AND n_3475  AND n_3476;
delay_2975: n_3474  <= TRANSPORT a_N804  ;
delay_2976: n_3475  <= TRANSPORT a_N35  ;
delay_2977: n_3476  <= TRANSPORT DIN(3)  ;
and2_2978: n_3477 <=  n_3478  AND n_3479;
inv_2979: n_3478  <= TRANSPORT NOT a_N35  ;
delay_2980: n_3479  <= TRANSPORT a_SLCNTL_DOUT_F3_G  ;
and2_2981: n_3480 <=  n_3481  AND n_3482;
inv_2982: n_3481  <= TRANSPORT NOT a_N804  ;
delay_2983: n_3482  <= TRANSPORT a_SLCNTL_DOUT_F3_G  ;
and1_2984: n_3483 <=  gnd;
inv_2985: n_3484  <= TRANSPORT NOT CLK  ;
filter_2986: FILTER_a16450

    PORT MAP (IN1 => n_3484, Y => a_SLCNTL_DOUT_F3_G_aCLK);
delay_2987: a_N418_aNOT  <= TRANSPORT a_N418_aNOT_aIN  ;
xor2_2988: a_N418_aNOT_aIN <=  n_3488  XOR n_3493;
or1_2989: n_3488 <=  n_3489;
and3_2990: n_3489 <=  n_3490  AND n_3491  AND n_3492;
delay_2991: n_3490  <= TRANSPORT a_N347  ;
delay_2992: n_3491  <= TRANSPORT a_N348  ;
delay_2993: n_3492  <= TRANSPORT a_N349  ;
and1_2994: n_3493 <=  gnd;
dff_2995: DFF_a16450

    PORT MAP ( D => a_EQ166, CLK => a_N346_aCLK, CLRN => a_N346_aCLRN, PRN => vcc,
          Q => a_N346);
inv_2996: a_N346_aCLRN  <= TRANSPORT NOT MR  ;
xor2_2997: a_EQ166 <=  n_3500  XOR n_3513;
or3_2998: n_3500 <=  n_3501  OR n_3506  OR n_3510;
and4_2999: n_3501 <=  n_3502  AND n_3503  AND n_3504  AND n_3505;
delay_3000: n_3502  <= TRANSPORT a_N44  ;
inv_3001: n_3503  <= TRANSPORT NOT a_N16_aNOT  ;
delay_3002: n_3504  <= TRANSPORT a_N418_aNOT  ;
inv_3003: n_3505  <= TRANSPORT NOT a_N346  ;
and3_3004: n_3506 <=  n_3507  AND n_3508  AND n_3509;
inv_3005: n_3507  <= TRANSPORT NOT a_N16_aNOT  ;
inv_3006: n_3508  <= TRANSPORT NOT a_N418_aNOT  ;
delay_3007: n_3509  <= TRANSPORT a_N346  ;
and2_3008: n_3510 <=  n_3511  AND n_3512;
inv_3009: n_3511  <= TRANSPORT NOT a_N44  ;
delay_3010: n_3512  <= TRANSPORT a_N346  ;
and1_3011: n_3513 <=  gnd;
delay_3012: n_3514  <= TRANSPORT RCLK  ;
filter_3013: FILTER_a16450

    PORT MAP (IN1 => n_3514, Y => a_N346_aCLK);
delay_3014: a_N407  <= TRANSPORT a_EQ178  ;
xor2_3015: a_EQ178 <=  n_3518  XOR n_3523;
or2_3016: n_3518 <=  n_3519  OR n_3521;
and1_3017: n_3519 <=  n_3520;
inv_3018: n_3520  <= TRANSPORT NOT a_N349  ;
and1_3019: n_3521 <=  n_3522;
inv_3020: n_3522  <= TRANSPORT NOT a_N348  ;
and1_3021: n_3523 <=  gnd;
dff_3022: DFF_a16450

    PORT MAP ( D => a_EQ167, CLK => a_N347_aCLK, CLRN => a_N347_aCLRN, PRN => vcc,
          Q => a_N347);
inv_3023: a_N347_aCLRN  <= TRANSPORT NOT MR  ;
xor2_3024: a_EQ167 <=  n_3530  XOR n_3543;
or3_3025: n_3530 <=  n_3531  OR n_3536  OR n_3540;
and4_3026: n_3531 <=  n_3532  AND n_3533  AND n_3534  AND n_3535;
delay_3027: n_3532  <= TRANSPORT a_N44  ;
inv_3028: n_3533  <= TRANSPORT NOT a_N16_aNOT  ;
inv_3029: n_3534  <= TRANSPORT NOT a_N407  ;
inv_3030: n_3535  <= TRANSPORT NOT a_N347  ;
and3_3031: n_3536 <=  n_3537  AND n_3538  AND n_3539;
inv_3032: n_3537  <= TRANSPORT NOT a_N16_aNOT  ;
delay_3033: n_3538  <= TRANSPORT a_N407  ;
delay_3034: n_3539  <= TRANSPORT a_N347  ;
and2_3035: n_3540 <=  n_3541  AND n_3542;
inv_3036: n_3541  <= TRANSPORT NOT a_N44  ;
delay_3037: n_3542  <= TRANSPORT a_N347  ;
and1_3038: n_3543 <=  gnd;
delay_3039: n_3544  <= TRANSPORT RCLK  ;
filter_3040: FILTER_a16450

    PORT MAP (IN1 => n_3544, Y => a_N347_aCLK);
dff_3041: DFF_a16450

    PORT MAP ( D => a_EQ168, CLK => a_N348_aCLK, CLRN => a_N348_aCLRN, PRN => vcc,
          Q => a_N348);
inv_3042: a_N348_aCLRN  <= TRANSPORT NOT MR  ;
xor2_3043: a_EQ168 <=  n_3552  XOR n_3565;
or3_3044: n_3552 <=  n_3553  OR n_3558  OR n_3562;
and4_3045: n_3553 <=  n_3554  AND n_3555  AND n_3556  AND n_3557;
delay_3046: n_3554  <= TRANSPORT a_N44  ;
inv_3047: n_3555  <= TRANSPORT NOT a_N16_aNOT  ;
inv_3048: n_3556  <= TRANSPORT NOT a_N348  ;
delay_3049: n_3557  <= TRANSPORT a_N349  ;
and3_3050: n_3558 <=  n_3559  AND n_3560  AND n_3561;
inv_3051: n_3559  <= TRANSPORT NOT a_N16_aNOT  ;
delay_3052: n_3560  <= TRANSPORT a_N348  ;
inv_3053: n_3561  <= TRANSPORT NOT a_N349  ;
and2_3054: n_3562 <=  n_3563  AND n_3564;
inv_3055: n_3563  <= TRANSPORT NOT a_N44  ;
delay_3056: n_3564  <= TRANSPORT a_N348  ;
and1_3057: n_3565 <=  gnd;
delay_3058: n_3566  <= TRANSPORT RCLK  ;
filter_3059: FILTER_a16450

    PORT MAP (IN1 => n_3566, Y => a_N348_aCLK);
delay_3060: a_LC1_B16  <= TRANSPORT a_LC1_B16_aIN  ;
xor2_3061: a_LC1_B16_aIN <=  n_3570  XOR n_3576;
or1_3062: n_3570 <=  n_3571;
and4_3063: n_3571 <=  n_3572  AND n_3573  AND n_3574  AND n_3575;
delay_3064: n_3572  <= TRANSPORT a_N1286  ;
delay_3065: n_3573  <= TRANSPORT a_N1287  ;
delay_3066: n_3574  <= TRANSPORT a_N1288  ;
inv_3067: n_3575  <= TRANSPORT NOT a_N1289_aNOT  ;
and1_3068: n_3576 <=  gnd;
delay_3069: a_LC6_B16  <= TRANSPORT a_LC6_B16_aIN  ;
xor2_3070: a_LC6_B16_aIN <=  n_3579  XOR n_3583;
or1_3071: n_3579 <=  n_3580;
and2_3072: n_3580 <=  n_3581  AND n_3582;
delay_3073: n_3581  <= TRANSPORT a_LC1_B16  ;
delay_3074: n_3582  <= TRANSPORT a_N1285  ;
and1_3075: n_3583 <=  gnd;
delay_3076: a_LC5_B11  <= TRANSPORT a_LC5_B11_aIN  ;
xor2_3077: a_LC5_B11_aIN <=  n_3586  XOR n_3591;
or1_3078: n_3586 <=  n_3587;
and3_3079: n_3587 <=  n_3588  AND n_3589  AND n_3590;
delay_3080: n_3588  <= TRANSPORT a_LC6_B16  ;
delay_3081: n_3589  <= TRANSPORT a_N1283  ;
delay_3082: n_3590  <= TRANSPORT a_N1284  ;
and1_3083: n_3591 <=  gnd;
delay_3084: a_LC1_B11  <= TRANSPORT a_LC1_B11_aIN  ;
xor2_3085: a_LC1_B11_aIN <=  n_3594  XOR n_3600;
or1_3086: n_3594 <=  n_3595;
and4_3087: n_3595 <=  n_3596  AND n_3597  AND n_3598  AND n_3599;
delay_3088: n_3596  <= TRANSPORT a_LC5_B11  ;
delay_3089: n_3597  <= TRANSPORT a_N1282  ;
delay_3090: n_3598  <= TRANSPORT a_N1280  ;
delay_3091: n_3599  <= TRANSPORT a_N1281  ;
and1_3092: n_3600 <=  gnd;
delay_3093: a_LC3_B4  <= TRANSPORT a_LC3_B4_aIN  ;
xor2_3094: a_LC3_B4_aIN <=  n_3603  XOR n_3608;
or1_3095: n_3603 <=  n_3604;
and3_3096: n_3604 <=  n_3605  AND n_3606  AND n_3607;
delay_3097: n_3605  <= TRANSPORT a_LC1_B11  ;
delay_3098: n_3606  <= TRANSPORT a_N1279  ;
delay_3099: n_3607  <= TRANSPORT a_N1278  ;
and1_3100: n_3608 <=  gnd;
delay_3101: a_N795_aNOT  <= TRANSPORT a_EQ238  ;
xor2_3102: a_EQ238 <=  n_3610  XOR n_3617;
or3_3103: n_3610 <=  n_3611  OR n_3613  OR n_3615;
and1_3104: n_3611 <=  n_3612;
inv_3105: n_3612  <= TRANSPORT NOT a_SLCNTL_DOUT_F7_G  ;
and1_3106: n_3613 <=  n_3614;
inv_3107: n_3614  <= TRANSPORT NOT a_N21  ;
and1_3108: n_3615 <=  n_3616;
inv_3109: n_3616  <= TRANSPORT NOT a_N804  ;
and1_3110: n_3617 <=  gnd;
delay_3111: a_N34_aNOT  <= TRANSPORT a_EQ076  ;
xor2_3112: a_EQ076 <=  n_3619  XOR n_3626;
or3_3113: n_3619 <=  n_3620  OR n_3622  OR n_3624;
and1_3114: n_3620 <=  n_3621;
inv_3115: n_3621  <= TRANSPORT NOT a_N1312  ;
and1_3116: n_3622 <=  n_3623;
delay_3117: n_3623  <= TRANSPORT a_N1311  ;
and1_3118: n_3624 <=  n_3625;
delay_3119: n_3625  <= TRANSPORT a_N1310  ;
and1_3120: n_3626 <=  gnd;
delay_3121: a_LC1_B18  <= TRANSPORT a_EQ236  ;
xor2_3122: a_EQ236 <=  n_3628  XOR n_3633;
or2_3123: n_3628 <=  n_3629  OR n_3631;
and1_3124: n_3629 <=  n_3630;
inv_3125: n_3630  <= TRANSPORT NOT a_SLCNTL_DOUT_F7_G  ;
and1_3126: n_3631 <=  n_3632;
delay_3127: n_3632  <= TRANSPORT a_N34_aNOT  ;
and1_3128: n_3633 <=  gnd;
delay_3129: a_N794_aNOT  <= TRANSPORT a_EQ237  ;
xor2_3130: a_EQ237 <=  n_3636  XOR n_3641;
or2_3131: n_3636 <=  n_3637  OR n_3639;
and1_3132: n_3637 <=  n_3638;
delay_3133: n_3638  <= TRANSPORT a_LC1_B18  ;
and1_3134: n_3639 <=  n_3640;
inv_3135: n_3640  <= TRANSPORT NOT a_N804  ;
and1_3136: n_3641 <=  gnd;
delay_3137: a_LC3_B18  <= TRANSPORT a_LC3_B18_aIN  ;
xor2_3138: a_LC3_B18_aIN <=  n_3644  XOR n_3649;
or1_3139: n_3644 <=  n_3645;
and3_3140: n_3645 <=  n_3646  AND n_3647  AND n_3648;
inv_3141: n_3646  <= TRANSPORT NOT a_N788  ;
delay_3142: n_3647  <= TRANSPORT a_N795_aNOT  ;
delay_3143: n_3648  <= TRANSPORT a_N794_aNOT  ;
and1_3144: n_3649 <=  gnd;
dff_3145: DFF_a16450

    PORT MAP ( D => a_EQ261, CLK => a_N1277_aCLK, CLRN => a_N1277_aCLRN, PRN => vcc,
          Q => a_N1277);
inv_3146: a_N1277_aCLRN  <= TRANSPORT NOT MR  ;
xor2_3147: a_EQ261 <=  n_3656  XOR n_3665;
or2_3148: n_3656 <=  n_3657  OR n_3661;
and3_3149: n_3657 <=  n_3658  AND n_3659  AND n_3660;
inv_3150: n_3658  <= TRANSPORT NOT a_LC3_B4  ;
delay_3151: n_3659  <= TRANSPORT a_LC3_B18  ;
delay_3152: n_3660  <= TRANSPORT a_N1277  ;
and3_3153: n_3661 <=  n_3662  AND n_3663  AND n_3664;
delay_3154: n_3662  <= TRANSPORT a_LC3_B4  ;
delay_3155: n_3663  <= TRANSPORT a_LC3_B18  ;
inv_3156: n_3664  <= TRANSPORT NOT a_N1277  ;
and1_3157: n_3665 <=  gnd;
delay_3158: n_3666  <= TRANSPORT CLK  ;
filter_3159: FILTER_a16450

    PORT MAP (IN1 => n_3666, Y => a_N1277_aCLK);
dff_3160: DFF_a16450

    PORT MAP ( D => a_EQ269, CLK => a_N1285_aCLK, CLRN => a_N1285_aCLRN, PRN => vcc,
          Q => a_N1285);
inv_3161: a_N1285_aCLRN  <= TRANSPORT NOT MR  ;
xor2_3162: a_EQ269 <=  n_3674  XOR n_3683;
or2_3163: n_3674 <=  n_3675  OR n_3679;
and3_3164: n_3675 <=  n_3676  AND n_3677  AND n_3678;
inv_3165: n_3676  <= TRANSPORT NOT a_LC1_B16  ;
delay_3166: n_3677  <= TRANSPORT a_LC3_B18  ;
delay_3167: n_3678  <= TRANSPORT a_N1285  ;
and3_3168: n_3679 <=  n_3680  AND n_3681  AND n_3682;
delay_3169: n_3680  <= TRANSPORT a_LC1_B16  ;
delay_3170: n_3681  <= TRANSPORT a_LC3_B18  ;
inv_3171: n_3682  <= TRANSPORT NOT a_N1285  ;
and1_3172: n_3683 <=  gnd;
delay_3173: n_3684  <= TRANSPORT CLK  ;
filter_3174: FILTER_a16450

    PORT MAP (IN1 => n_3684, Y => a_N1285_aCLK);
dff_3175: DFF_a16450

    PORT MAP ( D => a_EQ308, CLK => a_SDLSB_DAT_F6_G_aCLK, CLRN => a_SDLSB_DAT_F6_G_aCLRN,
          PRN => vcc, Q => a_SDLSB_DAT_F6_G);
inv_3176: a_SDLSB_DAT_F6_G_aCLRN  <= TRANSPORT NOT MR  ;
xor2_3177: a_EQ308 <=  n_3692  XOR n_3699;
or2_3178: n_3692 <=  n_3693  OR n_3696;
and2_3179: n_3693 <=  n_3694  AND n_3695;
delay_3180: n_3694  <= TRANSPORT a_N795_aNOT  ;
delay_3181: n_3695  <= TRANSPORT a_SDLSB_DAT_F6_G  ;
and2_3182: n_3696 <=  n_3697  AND n_3698;
inv_3183: n_3697  <= TRANSPORT NOT a_N795_aNOT  ;
delay_3184: n_3698  <= TRANSPORT DIN(6)  ;
and1_3185: n_3699 <=  gnd;
delay_3186: n_3700  <= TRANSPORT CLK  ;
filter_3187: FILTER_a16450

    PORT MAP (IN1 => n_3700, Y => a_SDLSB_DAT_F6_G_aCLK);
dff_3188: DFF_a16450

    PORT MAP ( D => a_EQ266, CLK => a_N1282_aCLK, CLRN => a_N1282_aCLRN, PRN => vcc,
          Q => a_N1282);
inv_3189: a_N1282_aCLRN  <= TRANSPORT NOT MR  ;
xor2_3190: a_EQ266 <=  n_3708  XOR n_3717;
or2_3191: n_3708 <=  n_3709  OR n_3713;
and3_3192: n_3709 <=  n_3710  AND n_3711  AND n_3712;
inv_3193: n_3710  <= TRANSPORT NOT a_LC5_B11  ;
delay_3194: n_3711  <= TRANSPORT a_LC3_B18  ;
delay_3195: n_3712  <= TRANSPORT a_N1282  ;
and3_3196: n_3713 <=  n_3714  AND n_3715  AND n_3716;
delay_3197: n_3714  <= TRANSPORT a_LC5_B11  ;
delay_3198: n_3715  <= TRANSPORT a_LC3_B18  ;
inv_3199: n_3716  <= TRANSPORT NOT a_N1282  ;
and1_3200: n_3717 <=  gnd;
delay_3201: n_3718  <= TRANSPORT CLK  ;
filter_3202: FILTER_a16450

    PORT MAP (IN1 => n_3718, Y => a_N1282_aCLK);
dff_3203: DFF_a16450

    PORT MAP ( D => a_EQ267, CLK => a_N1283_aCLK, CLRN => a_N1283_aCLRN, PRN => vcc,
          Q => a_N1283);
inv_3204: a_N1283_aCLRN  <= TRANSPORT NOT MR  ;
xor2_3205: a_EQ267 <=  n_3726  XOR n_3740;
or3_3206: n_3726 <=  n_3727  OR n_3731  OR n_3735;
and3_3207: n_3727 <=  n_3728  AND n_3729  AND n_3730;
delay_3208: n_3728  <= TRANSPORT a_LC3_B18  ;
delay_3209: n_3729  <= TRANSPORT a_N1283  ;
inv_3210: n_3730  <= TRANSPORT NOT a_N1284  ;
and3_3211: n_3731 <=  n_3732  AND n_3733  AND n_3734;
inv_3212: n_3732  <= TRANSPORT NOT a_LC6_B16  ;
delay_3213: n_3733  <= TRANSPORT a_LC3_B18  ;
delay_3214: n_3734  <= TRANSPORT a_N1283  ;
and4_3215: n_3735 <=  n_3736  AND n_3737  AND n_3738  AND n_3739;
delay_3216: n_3736  <= TRANSPORT a_LC6_B16  ;
delay_3217: n_3737  <= TRANSPORT a_LC3_B18  ;
inv_3218: n_3738  <= TRANSPORT NOT a_N1283  ;
delay_3219: n_3739  <= TRANSPORT a_N1284  ;
and1_3220: n_3740 <=  gnd;
delay_3221: n_3741  <= TRANSPORT CLK  ;
filter_3222: FILTER_a16450

    PORT MAP (IN1 => n_3741, Y => a_N1283_aCLK);
dff_3223: DFF_a16450

    PORT MAP ( D => a_EQ268, CLK => a_N1284_aCLK, CLRN => a_N1284_aCLRN, PRN => vcc,
          Q => a_N1284);
inv_3224: a_N1284_aCLRN  <= TRANSPORT NOT MR  ;
xor2_3225: a_EQ268 <=  n_3749  XOR n_3758;
or2_3226: n_3749 <=  n_3750  OR n_3754;
and3_3227: n_3750 <=  n_3751  AND n_3752  AND n_3753;
inv_3228: n_3751  <= TRANSPORT NOT a_LC6_B16  ;
delay_3229: n_3752  <= TRANSPORT a_LC3_B18  ;
delay_3230: n_3753  <= TRANSPORT a_N1284  ;
and3_3231: n_3754 <=  n_3755  AND n_3756  AND n_3757;
delay_3232: n_3755  <= TRANSPORT a_LC6_B16  ;
delay_3233: n_3756  <= TRANSPORT a_LC3_B18  ;
inv_3234: n_3757  <= TRANSPORT NOT a_N1284  ;
and1_3235: n_3758 <=  gnd;
delay_3236: n_3759  <= TRANSPORT CLK  ;
filter_3237: FILTER_a16450

    PORT MAP (IN1 => n_3759, Y => a_N1284_aCLK);
dff_3238: DFF_a16450

    PORT MAP ( D => a_EQ263, CLK => a_N1279_aCLK, CLRN => a_N1279_aCLRN, PRN => vcc,
          Q => a_N1279);
inv_3239: a_N1279_aCLRN  <= TRANSPORT NOT MR  ;
xor2_3240: a_EQ263 <=  n_3767  XOR n_3776;
or2_3241: n_3767 <=  n_3768  OR n_3772;
and3_3242: n_3768 <=  n_3769  AND n_3770  AND n_3771;
inv_3243: n_3769  <= TRANSPORT NOT a_LC1_B11  ;
delay_3244: n_3770  <= TRANSPORT a_LC3_B18  ;
delay_3245: n_3771  <= TRANSPORT a_N1279  ;
and3_3246: n_3772 <=  n_3773  AND n_3774  AND n_3775;
delay_3247: n_3773  <= TRANSPORT a_LC1_B11  ;
delay_3248: n_3774  <= TRANSPORT a_LC3_B18  ;
inv_3249: n_3775  <= TRANSPORT NOT a_N1279  ;
and1_3250: n_3776 <=  gnd;
delay_3251: n_3777  <= TRANSPORT CLK  ;
filter_3252: FILTER_a16450

    PORT MAP (IN1 => n_3777, Y => a_N1279_aCLK);
delay_3253: a_LC6_B11  <= TRANSPORT a_LC6_B11_aIN  ;
xor2_3254: a_LC6_B11_aIN <=  n_3781  XOR n_3785;
or1_3255: n_3781 <=  n_3782;
and2_3256: n_3782 <=  n_3783  AND n_3784;
delay_3257: n_3783  <= TRANSPORT a_LC5_B11  ;
delay_3258: n_3784  <= TRANSPORT a_N1282  ;
and1_3259: n_3785 <=  gnd;
dff_3260: DFF_a16450

    PORT MAP ( D => a_EQ264, CLK => a_N1280_aCLK, CLRN => a_N1280_aCLRN, PRN => vcc,
          Q => a_N1280);
inv_3261: a_N1280_aCLRN  <= TRANSPORT NOT MR  ;
xor2_3262: a_EQ264 <=  n_3792  XOR n_3806;
or3_3263: n_3792 <=  n_3793  OR n_3797  OR n_3801;
and3_3264: n_3793 <=  n_3794  AND n_3795  AND n_3796;
delay_3265: n_3794  <= TRANSPORT a_LC3_B18  ;
delay_3266: n_3795  <= TRANSPORT a_N1280  ;
inv_3267: n_3796  <= TRANSPORT NOT a_N1281  ;
and3_3268: n_3797 <=  n_3798  AND n_3799  AND n_3800;
delay_3269: n_3798  <= TRANSPORT a_LC3_B18  ;
inv_3270: n_3799  <= TRANSPORT NOT a_LC6_B11  ;
delay_3271: n_3800  <= TRANSPORT a_N1280  ;
and4_3272: n_3801 <=  n_3802  AND n_3803  AND n_3804  AND n_3805;
delay_3273: n_3802  <= TRANSPORT a_LC3_B18  ;
delay_3274: n_3803  <= TRANSPORT a_LC6_B11  ;
inv_3275: n_3804  <= TRANSPORT NOT a_N1280  ;
delay_3276: n_3805  <= TRANSPORT a_N1281  ;
and1_3277: n_3806 <=  gnd;
delay_3278: n_3807  <= TRANSPORT CLK  ;
filter_3279: FILTER_a16450

    PORT MAP (IN1 => n_3807, Y => a_N1280_aCLK);
dff_3280: DFF_a16450

    PORT MAP ( D => a_EQ262, CLK => a_N1278_aCLK, CLRN => a_N1278_aCLRN, PRN => vcc,
          Q => a_N1278);
inv_3281: a_N1278_aCLRN  <= TRANSPORT NOT MR  ;
xor2_3282: a_EQ262 <=  n_3815  XOR n_3829;
or3_3283: n_3815 <=  n_3816  OR n_3820  OR n_3824;
and3_3284: n_3816 <=  n_3817  AND n_3818  AND n_3819;
delay_3285: n_3817  <= TRANSPORT a_LC3_B18  ;
inv_3286: n_3818  <= TRANSPORT NOT a_N1279  ;
delay_3287: n_3819  <= TRANSPORT a_N1278  ;
and3_3288: n_3820 <=  n_3821  AND n_3822  AND n_3823;
inv_3289: n_3821  <= TRANSPORT NOT a_LC1_B11  ;
delay_3290: n_3822  <= TRANSPORT a_LC3_B18  ;
delay_3291: n_3823  <= TRANSPORT a_N1278  ;
and4_3292: n_3824 <=  n_3825  AND n_3826  AND n_3827  AND n_3828;
delay_3293: n_3825  <= TRANSPORT a_LC1_B11  ;
delay_3294: n_3826  <= TRANSPORT a_LC3_B18  ;
delay_3295: n_3827  <= TRANSPORT a_N1279  ;
inv_3296: n_3828  <= TRANSPORT NOT a_N1278  ;
and1_3297: n_3829 <=  gnd;
delay_3298: n_3830  <= TRANSPORT CLK  ;
filter_3299: FILTER_a16450

    PORT MAP (IN1 => n_3830, Y => a_N1278_aCLK);
delay_3300: a_LC2_B6  <= TRANSPORT a_LC2_B6_aIN  ;
xor2_3301: a_LC2_B6_aIN <=  n_3834  XOR n_3838;
or1_3302: n_3834 <=  n_3835;
and2_3303: n_3835 <=  n_3836  AND n_3837;
delay_3304: n_3836  <= TRANSPORT a_N1288  ;
inv_3305: n_3837  <= TRANSPORT NOT a_N1289_aNOT  ;
and1_3306: n_3838 <=  gnd;
dff_3307: DFF_a16450

    PORT MAP ( D => a_EQ270, CLK => a_N1286_aCLK, CLRN => a_N1286_aCLRN, PRN => vcc,
          Q => a_N1286);
inv_3308: a_N1286_aCLRN  <= TRANSPORT NOT MR  ;
xor2_3309: a_EQ270 <=  n_3845  XOR n_3859;
or3_3310: n_3845 <=  n_3846  OR n_3850  OR n_3854;
and3_3311: n_3846 <=  n_3847  AND n_3848  AND n_3849;
delay_3312: n_3847  <= TRANSPORT a_LC3_B18  ;
delay_3313: n_3848  <= TRANSPORT a_N1286  ;
inv_3314: n_3849  <= TRANSPORT NOT a_N1287  ;
and3_3315: n_3850 <=  n_3851  AND n_3852  AND n_3853;
delay_3316: n_3851  <= TRANSPORT a_LC3_B18  ;
inv_3317: n_3852  <= TRANSPORT NOT a_LC2_B6  ;
delay_3318: n_3853  <= TRANSPORT a_N1286  ;
and4_3319: n_3854 <=  n_3855  AND n_3856  AND n_3857  AND n_3858;
delay_3320: n_3855  <= TRANSPORT a_LC3_B18  ;
delay_3321: n_3856  <= TRANSPORT a_LC2_B6  ;
inv_3322: n_3857  <= TRANSPORT NOT a_N1286  ;
delay_3323: n_3858  <= TRANSPORT a_N1287  ;
and1_3324: n_3859 <=  gnd;
delay_3325: n_3860  <= TRANSPORT CLK  ;
filter_3326: FILTER_a16450

    PORT MAP (IN1 => n_3860, Y => a_N1286_aCLK);
dff_3327: DFF_a16450

    PORT MAP ( D => a_EQ265, CLK => a_N1281_aCLK, CLRN => a_N1281_aCLRN, PRN => vcc,
          Q => a_N1281);
inv_3328: a_N1281_aCLRN  <= TRANSPORT NOT MR  ;
xor2_3329: a_EQ265 <=  n_3868  XOR n_3882;
or3_3330: n_3868 <=  n_3869  OR n_3873  OR n_3877;
and3_3331: n_3869 <=  n_3870  AND n_3871  AND n_3872;
delay_3332: n_3870  <= TRANSPORT a_LC3_B18  ;
inv_3333: n_3871  <= TRANSPORT NOT a_N1282  ;
delay_3334: n_3872  <= TRANSPORT a_N1281  ;
and3_3335: n_3873 <=  n_3874  AND n_3875  AND n_3876;
inv_3336: n_3874  <= TRANSPORT NOT a_LC5_B11  ;
delay_3337: n_3875  <= TRANSPORT a_LC3_B18  ;
delay_3338: n_3876  <= TRANSPORT a_N1281  ;
and4_3339: n_3877 <=  n_3878  AND n_3879  AND n_3880  AND n_3881;
delay_3340: n_3878  <= TRANSPORT a_LC5_B11  ;
delay_3341: n_3879  <= TRANSPORT a_LC3_B18  ;
delay_3342: n_3880  <= TRANSPORT a_N1282  ;
inv_3343: n_3881  <= TRANSPORT NOT a_N1281  ;
and1_3344: n_3882 <=  gnd;
delay_3345: n_3883  <= TRANSPORT CLK  ;
filter_3346: FILTER_a16450

    PORT MAP (IN1 => n_3883, Y => a_N1281_aCLK);
dff_3347: DFF_a16450

    PORT MAP ( D => a_EQ260, CLK => a_N1276_aCLK, CLRN => a_N1276_aCLRN, PRN => vcc,
          Q => a_N1276);
inv_3348: a_N1276_aCLRN  <= TRANSPORT NOT MR  ;
xor2_3349: a_EQ260 <=  n_3891  XOR n_3905;
or3_3350: n_3891 <=  n_3892  OR n_3896  OR n_3900;
and3_3351: n_3892 <=  n_3893  AND n_3894  AND n_3895;
delay_3352: n_3893  <= TRANSPORT a_LC3_B18  ;
inv_3353: n_3894  <= TRANSPORT NOT a_N1277  ;
delay_3354: n_3895  <= TRANSPORT a_N1276  ;
and3_3355: n_3896 <=  n_3897  AND n_3898  AND n_3899;
inv_3356: n_3897  <= TRANSPORT NOT a_LC3_B4  ;
delay_3357: n_3898  <= TRANSPORT a_LC3_B18  ;
delay_3358: n_3899  <= TRANSPORT a_N1276  ;
and4_3359: n_3900 <=  n_3901  AND n_3902  AND n_3903  AND n_3904;
delay_3360: n_3901  <= TRANSPORT a_LC3_B4  ;
delay_3361: n_3902  <= TRANSPORT a_LC3_B18  ;
delay_3362: n_3903  <= TRANSPORT a_N1277  ;
inv_3363: n_3904  <= TRANSPORT NOT a_N1276  ;
and1_3364: n_3905 <=  gnd;
delay_3365: n_3906  <= TRANSPORT CLK  ;
filter_3366: FILTER_a16450

    PORT MAP (IN1 => n_3906, Y => a_N1276_aCLK);
dff_3367: DFF_a16450

    PORT MAP ( D => a_EQ271, CLK => a_N1287_aCLK, CLRN => a_N1287_aCLRN, PRN => vcc,
          Q => a_N1287);
inv_3368: a_N1287_aCLRN  <= TRANSPORT NOT MR  ;
xor2_3369: a_EQ271 <=  n_3914  XOR n_3928;
or3_3370: n_3914 <=  n_3915  OR n_3919  OR n_3923;
and3_3371: n_3915 <=  n_3916  AND n_3917  AND n_3918;
delay_3372: n_3916  <= TRANSPORT a_LC3_B18  ;
delay_3373: n_3917  <= TRANSPORT a_N1287  ;
delay_3374: n_3918  <= TRANSPORT a_N1289_aNOT  ;
and3_3375: n_3919 <=  n_3920  AND n_3921  AND n_3922;
delay_3376: n_3920  <= TRANSPORT a_LC3_B18  ;
delay_3377: n_3921  <= TRANSPORT a_N1287  ;
inv_3378: n_3922  <= TRANSPORT NOT a_N1288  ;
and4_3379: n_3923 <=  n_3924  AND n_3925  AND n_3926  AND n_3927;
delay_3380: n_3924  <= TRANSPORT a_LC3_B18  ;
inv_3381: n_3925  <= TRANSPORT NOT a_N1287  ;
delay_3382: n_3926  <= TRANSPORT a_N1288  ;
inv_3383: n_3927  <= TRANSPORT NOT a_N1289_aNOT  ;
and1_3384: n_3928 <=  gnd;
delay_3385: n_3929  <= TRANSPORT CLK  ;
filter_3386: FILTER_a16450

    PORT MAP (IN1 => n_3929, Y => a_N1287_aCLK);
dff_3387: DFF_a16450

    PORT MAP ( D => a_EQ287, CLK => a_N1320_aCLK, CLRN => a_N1320_aCLRN, PRN => vcc,
          Q => a_N1320);
inv_3388: a_N1320_aCLRN  <= TRANSPORT NOT MR  ;
xor2_3389: a_EQ287 <=  n_3937  XOR n_3948;
or3_3390: n_3937 <=  n_3938  OR n_3942  OR n_3945;
and3_3391: n_3938 <=  n_3939  AND n_3940  AND n_3941;
delay_3392: n_3939  <= TRANSPORT a_N804  ;
delay_3393: n_3940  <= TRANSPORT a_N32  ;
delay_3394: n_3941  <= TRANSPORT DIN(0)  ;
and2_3395: n_3942 <=  n_3943  AND n_3944;
inv_3396: n_3943  <= TRANSPORT NOT a_N32  ;
delay_3397: n_3944  <= TRANSPORT a_N1320  ;
and2_3398: n_3945 <=  n_3946  AND n_3947;
inv_3399: n_3946  <= TRANSPORT NOT a_N804  ;
delay_3400: n_3947  <= TRANSPORT a_N1320  ;
and1_3401: n_3948 <=  gnd;
inv_3402: n_3949  <= TRANSPORT NOT CLK  ;
filter_3403: FILTER_a16450

    PORT MAP (IN1 => n_3949, Y => a_N1320_aCLK);
dff_3404: DFF_a16450

    PORT MAP ( D => a_EQ286, CLK => a_N1319_aCLK, CLRN => a_N1319_aCLRN, PRN => vcc,
          Q => a_N1319);
inv_3405: a_N1319_aCLRN  <= TRANSPORT NOT MR  ;
xor2_3406: a_EQ286 <=  n_3957  XOR n_3968;
or3_3407: n_3957 <=  n_3958  OR n_3962  OR n_3965;
and3_3408: n_3958 <=  n_3959  AND n_3960  AND n_3961;
delay_3409: n_3959  <= TRANSPORT a_N804  ;
delay_3410: n_3960  <= TRANSPORT a_N32  ;
delay_3411: n_3961  <= TRANSPORT DIN(1)  ;
and2_3412: n_3962 <=  n_3963  AND n_3964;
inv_3413: n_3963  <= TRANSPORT NOT a_N32  ;
delay_3414: n_3964  <= TRANSPORT a_N1319  ;
and2_3415: n_3965 <=  n_3966  AND n_3967;
inv_3416: n_3966  <= TRANSPORT NOT a_N804  ;
delay_3417: n_3967  <= TRANSPORT a_N1319  ;
and1_3418: n_3968 <=  gnd;
inv_3419: n_3969  <= TRANSPORT NOT CLK  ;
filter_3420: FILTER_a16450

    PORT MAP (IN1 => n_3969, Y => a_N1319_aCLK);
delay_3421: a_N152_aNOT  <= TRANSPORT a_EQ125  ;
xor2_3422: a_EQ125 <=  n_3973  XOR n_3982;
or2_3423: n_3973 <=  n_3974  OR n_3978;
and3_3424: n_3974 <=  n_3975  AND n_3976  AND n_3977;
delay_3425: n_3975  <= TRANSPORT a_SINTEN_DAT_F1_G  ;
delay_3426: n_3976  <= TRANSPORT a_N10  ;
inv_3427: n_3977  <= TRANSPORT NOT a_SLSTAT_DAT_F0_G  ;
and3_3428: n_3978 <=  n_3979  AND n_3980  AND n_3981;
delay_3429: n_3979  <= TRANSPORT a_SINTEN_DAT_F1_G  ;
delay_3430: n_3980  <= TRANSPORT a_N10  ;
inv_3431: n_3981  <= TRANSPORT NOT a_SINTEN_DAT_F0_G  ;
and1_3432: n_3982 <=  gnd;
dff_3433: DFF_a16450

    PORT MAP ( D => a_EQ323, CLK => a_SINTID_DAT_F1_G_aCLK, CLRN => a_SINTID_DAT_F1_G_aCLRN,
          PRN => vcc, Q => a_SINTID_DAT_F1_G);
inv_3434: a_SINTID_DAT_F1_G_aCLRN  <= TRANSPORT NOT MR  ;
xor2_3435: a_EQ323 <=  n_3989  XOR n_4002;
or4_3436: n_3989 <=  n_3990  OR n_3993  OR n_3996  OR n_3999;
and2_3437: n_3990 <=  n_3991  AND n_3992;
delay_3438: n_3991  <= TRANSPORT a_N152_aNOT  ;
delay_3439: n_3992  <= TRANSPORT a_SINTID_DAT_F1_G  ;
and2_3440: n_3993 <=  n_3994  AND n_3995;
delay_3441: n_3994  <= TRANSPORT a_LC2_B15  ;
delay_3442: n_3995  <= TRANSPORT a_SINTID_DAT_F1_G  ;
and2_3443: n_3996 <=  n_3997  AND n_3998;
delay_3444: n_3997  <= TRANSPORT a_N806  ;
delay_3445: n_3998  <= TRANSPORT a_N152_aNOT  ;
and2_3446: n_3999 <=  n_4000  AND n_4001;
delay_3447: n_4000  <= TRANSPORT a_N806  ;
delay_3448: n_4001  <= TRANSPORT a_LC2_B15  ;
and1_3449: n_4002 <=  gnd;
delay_3450: n_4003  <= TRANSPORT CLK  ;
filter_3451: FILTER_a16450

    PORT MAP (IN1 => n_4003, Y => a_SINTID_DAT_F1_G_aCLK);
dff_3452: DFF_a16450

    PORT MAP ( D => a_EQ285, CLK => a_N1318_aCLK, CLRN => a_N1318_aCLRN, PRN => vcc,
          Q => a_N1318);
inv_3453: a_N1318_aCLRN  <= TRANSPORT NOT MR  ;
xor2_3454: a_EQ285 <=  n_4011  XOR n_4022;
or3_3455: n_4011 <=  n_4012  OR n_4016  OR n_4019;
and3_3456: n_4012 <=  n_4013  AND n_4014  AND n_4015;
delay_3457: n_4013  <= TRANSPORT a_N804  ;
delay_3458: n_4014  <= TRANSPORT a_N32  ;
delay_3459: n_4015  <= TRANSPORT DIN(2)  ;
and2_3460: n_4016 <=  n_4017  AND n_4018;
inv_3461: n_4017  <= TRANSPORT NOT a_N32  ;
delay_3462: n_4018  <= TRANSPORT a_N1318  ;
and2_3463: n_4019 <=  n_4020  AND n_4021;
inv_3464: n_4020  <= TRANSPORT NOT a_N804  ;
delay_3465: n_4021  <= TRANSPORT a_N1318  ;
and1_3466: n_4022 <=  gnd;
inv_3467: n_4023  <= TRANSPORT NOT CLK  ;
filter_3468: FILTER_a16450

    PORT MAP (IN1 => n_4023, Y => a_N1318_aCLK);
delay_3469: a_N319  <= TRANSPORT a_N319_aIN  ;
xor2_3470: a_N319_aIN <=  n_4027  XOR n_4031;
or1_3471: n_4027 <=  n_4028;
and2_3472: n_4028 <=  n_4029  AND n_4030;
delay_3473: n_4029  <= TRANSPORT a_N42  ;
delay_3474: n_4030  <= TRANSPORT a_SLCNTL_DOUT_F3_G  ;
and1_3475: n_4031 <=  gnd;
delay_3476: a_N393  <= TRANSPORT a_EQ175  ;
xor2_3477: a_EQ175 <=  n_4034  XOR n_4043;
or2_3478: n_4034 <=  n_4035  OR n_4039;
and3_3479: n_4035 <=  n_4036  AND n_4037  AND n_4038;
inv_3480: n_4036  <= TRANSPORT NOT a_SLCNTL_DOUT_F1_G  ;
inv_3481: n_4037  <= TRANSPORT NOT a_SLCNTL_DOUT_F3_G  ;
delay_3482: n_4038  <= TRANSPORT a_SLCNTL_DOUT_F0_G  ;
and3_3483: n_4039 <=  n_4040  AND n_4041  AND n_4042;
inv_3484: n_4040  <= TRANSPORT NOT a_SLCNTL_DOUT_F1_G  ;
delay_3485: n_4041  <= TRANSPORT a_SLCNTL_DOUT_F3_G  ;
inv_3486: n_4042  <= TRANSPORT NOT a_SLCNTL_DOUT_F0_G  ;
and1_3487: n_4043 <=  gnd;
delay_3488: a_LC2_A12  <= TRANSPORT a_EQ092  ;
xor2_3489: a_EQ092 <=  n_4046  XOR n_4053;
or2_3490: n_4046 <=  n_4047  OR n_4050;
and2_3491: n_4047 <=  n_4048  AND n_4049;
delay_3492: n_4048  <= TRANSPORT a_N104  ;
delay_3493: n_4049  <= TRANSPORT a_N319  ;
and2_3494: n_4050 <=  n_4051  AND n_4052;
delay_3495: n_4051  <= TRANSPORT a_N101  ;
delay_3496: n_4052  <= TRANSPORT a_N393  ;
and1_3497: n_4053 <=  gnd;
delay_3498: a_N375  <= TRANSPORT a_N375_aIN  ;
xor2_3499: a_N375_aIN <=  n_4056  XOR n_4061;
or1_3500: n_4056 <=  n_4057;
and3_3501: n_4057 <=  n_4058  AND n_4059  AND n_4060;
inv_3502: n_4058  <= TRANSPORT NOT a_SLCNTL_DOUT_F1_G  ;
inv_3503: n_4059  <= TRANSPORT NOT a_SLCNTL_DOUT_F3_G  ;
inv_3504: n_4060  <= TRANSPORT NOT a_SLCNTL_DOUT_F0_G  ;
and1_3505: n_4061 <=  gnd;
delay_3506: a_LC4_A12  <= TRANSPORT a_EQ093  ;
xor2_3507: a_EQ093 <=  n_4064  XOR n_4070;
or2_3508: n_4064 <=  n_4065  OR n_4067;
and1_3509: n_4065 <=  n_4066;
delay_3510: n_4066  <= TRANSPORT a_LC2_A12  ;
and2_3511: n_4067 <=  n_4068  AND n_4069;
delay_3512: n_4068  <= TRANSPORT a_N1369  ;
delay_3513: n_4069  <= TRANSPORT a_N375  ;
and1_3514: n_4070 <=  gnd;
delay_3515: a_N390  <= TRANSPORT a_EQ173  ;
xor2_3516: a_EQ173 <=  n_4073  XOR n_4081;
or2_3517: n_4073 <=  n_4074  OR n_4077;
and2_3518: n_4074 <=  n_4075  AND n_4076;
inv_3519: n_4075  <= TRANSPORT NOT a_N41_aNOT  ;
delay_3520: n_4076  <= TRANSPORT a_SLCNTL_DOUT_F3_G  ;
and3_3521: n_4077 <=  n_4078  AND n_4079  AND n_4080;
delay_3522: n_4078  <= TRANSPORT a_SLCNTL_DOUT_F1_G  ;
inv_3523: n_4079  <= TRANSPORT NOT a_SLCNTL_DOUT_F3_G  ;
inv_3524: n_4080  <= TRANSPORT NOT a_SLCNTL_DOUT_F0_G  ;
and1_3525: n_4081 <=  gnd;
delay_3526: a_LC1_A12  <= TRANSPORT a_EQ094  ;
xor2_3527: a_EQ094 <=  n_4084  XOR n_4090;
or2_3528: n_4084 <=  n_4085  OR n_4087;
and1_3529: n_4085 <=  n_4086;
delay_3530: n_4086  <= TRANSPORT a_LC4_A12  ;
and2_3531: n_4087 <=  n_4088  AND n_4089;
delay_3532: n_4088  <= TRANSPORT a_N102  ;
delay_3533: n_4089  <= TRANSPORT a_N390  ;
and1_3534: n_4090 <=  gnd;
delay_3535: a_N394  <= TRANSPORT a_EQ176  ;
xor2_3536: a_EQ176 <=  n_4093  XOR n_4102;
or2_3537: n_4093 <=  n_4094  OR n_4098;
and3_3538: n_4094 <=  n_4095  AND n_4096  AND n_4097;
delay_3539: n_4095  <= TRANSPORT a_SLCNTL_DOUT_F1_G  ;
inv_3540: n_4096  <= TRANSPORT NOT a_SLCNTL_DOUT_F3_G  ;
delay_3541: n_4097  <= TRANSPORT a_SLCNTL_DOUT_F0_G  ;
and3_3542: n_4098 <=  n_4099  AND n_4100  AND n_4101;
delay_3543: n_4099  <= TRANSPORT a_SLCNTL_DOUT_F1_G  ;
delay_3544: n_4100  <= TRANSPORT a_SLCNTL_DOUT_F3_G  ;
inv_3545: n_4101  <= TRANSPORT NOT a_SLCNTL_DOUT_F0_G  ;
and1_3546: n_4102 <=  gnd;
delay_3547: a_N53  <= TRANSPORT a_EQ095  ;
xor2_3548: a_EQ095 <=  n_4104  XOR n_4110;
or2_3549: n_4104 <=  n_4105  OR n_4107;
and1_3550: n_4105 <=  n_4106;
delay_3551: n_4106  <= TRANSPORT a_LC1_A12  ;
and2_3552: n_4107 <=  n_4108  AND n_4109;
delay_3553: n_4108  <= TRANSPORT a_N103  ;
delay_3554: n_4109  <= TRANSPORT a_N394  ;
and1_3555: n_4110 <=  gnd;
delay_3556: a_N792_aNOT  <= TRANSPORT a_EQ235  ;
xor2_3557: a_EQ235 <=  n_4112  XOR n_4121;
or4_3558: n_4112 <=  n_4113  OR n_4115  OR n_4117  OR n_4119;
and1_3559: n_4113 <=  n_4114;
delay_3560: n_4114  <= TRANSPORT a_N57  ;
and1_3561: n_4115 <=  n_4116;
delay_3562: n_4116  <= TRANSPORT a_N56  ;
and1_3563: n_4117 <=  n_4118;
inv_3564: n_4118  <= TRANSPORT NOT a_N54  ;
and1_3565: n_4119 <=  n_4120;
inv_3566: n_4120  <= TRANSPORT NOT a_N44  ;
and1_3567: n_4121 <=  gnd;
dff_3568: DFF_a16450

    PORT MAP ( D => a_EQ357, CLK => a_SREC_DAT_F4_G_aCLK, CLRN => vcc, PRN => vcc,
          Q => a_SREC_DAT_F4_G);
xor2_3569: a_EQ357 <=  n_4127  XOR n_4134;
or2_3570: n_4127 <=  n_4128  OR n_4131;
and2_3571: n_4128 <=  n_4129  AND n_4130;
delay_3572: n_4129  <= TRANSPORT a_N53  ;
inv_3573: n_4130  <= TRANSPORT NOT a_N792_aNOT  ;
and2_3574: n_4131 <=  n_4132  AND n_4133;
delay_3575: n_4132  <= TRANSPORT a_N792_aNOT  ;
delay_3576: n_4133  <= TRANSPORT a_SREC_DAT_F4_G  ;
and1_3577: n_4134 <=  gnd;
delay_3578: n_4135  <= TRANSPORT RCLK  ;
filter_3579: FILTER_a16450

    PORT MAP (IN1 => n_4135, Y => a_SREC_DAT_F4_G_aCLK);
dff_3580: DFF_a16450

    PORT MAP ( D => a_EQ306, CLK => a_SDLSB_DAT_F4_G_aCLK, CLRN => a_SDLSB_DAT_F4_G_aCLRN,
          PRN => vcc, Q => a_SDLSB_DAT_F4_G);
inv_3581: a_SDLSB_DAT_F4_G_aCLRN  <= TRANSPORT NOT MR  ;
xor2_3582: a_EQ306 <=  n_4143  XOR n_4150;
or2_3583: n_4143 <=  n_4144  OR n_4147;
and2_3584: n_4144 <=  n_4145  AND n_4146;
delay_3585: n_4145  <= TRANSPORT a_N795_aNOT  ;
delay_3586: n_4146  <= TRANSPORT a_SDLSB_DAT_F4_G  ;
and2_3587: n_4147 <=  n_4148  AND n_4149;
inv_3588: n_4148  <= TRANSPORT NOT a_N795_aNOT  ;
delay_3589: n_4149  <= TRANSPORT DIN(4)  ;
and1_3590: n_4150 <=  gnd;
delay_3591: n_4151  <= TRANSPORT CLK  ;
filter_3592: FILTER_a16450

    PORT MAP (IN1 => n_4151, Y => a_SDLSB_DAT_F4_G_aCLK);
dff_3593: DFF_a16450

    PORT MAP ( D => a_EQ283, CLK => a_N1316_aCLK, CLRN => a_N1316_aCLRN, PRN => vcc,
          Q => a_N1316);
inv_3594: a_N1316_aCLRN  <= TRANSPORT NOT MR  ;
xor2_3595: a_EQ283 <=  n_4159  XOR n_4170;
or3_3596: n_4159 <=  n_4160  OR n_4164  OR n_4167;
and3_3597: n_4160 <=  n_4161  AND n_4162  AND n_4163;
delay_3598: n_4161  <= TRANSPORT a_N804  ;
delay_3599: n_4162  <= TRANSPORT a_N32  ;
delay_3600: n_4163  <= TRANSPORT DIN(4)  ;
and2_3601: n_4164 <=  n_4165  AND n_4166;
inv_3602: n_4165  <= TRANSPORT NOT a_N32  ;
delay_3603: n_4166  <= TRANSPORT a_N1316  ;
and2_3604: n_4167 <=  n_4168  AND n_4169;
inv_3605: n_4168  <= TRANSPORT NOT a_N804  ;
delay_3606: n_4169  <= TRANSPORT a_N1316  ;
and1_3607: n_4170 <=  gnd;
inv_3608: n_4171  <= TRANSPORT NOT CLK  ;
filter_3609: FILTER_a16450

    PORT MAP (IN1 => n_4171, Y => a_N1316_aCLK);
delay_3610: a_N392  <= TRANSPORT a_N392_aIN  ;
xor2_3611: a_N392_aIN <=  n_4175  XOR n_4179;
or1_3612: n_4175 <=  n_4176;
and2_3613: n_4176 <=  n_4177  AND n_4178;
delay_3614: n_4177  <= TRANSPORT a_N1369  ;
inv_3615: n_4178  <= TRANSPORT NOT a_SLCNTL_DOUT_F3_G  ;
and1_3616: n_4179 <=  gnd;
delay_3617: a_LC6_A15  <= TRANSPORT a_EQ089  ;
xor2_3618: a_EQ089 <=  n_4182  XOR n_4189;
or2_3619: n_4182 <=  n_4183  OR n_4186;
and2_3620: n_4183 <=  n_4184  AND n_4185;
delay_3621: n_4184  <= TRANSPORT a_N102  ;
delay_3622: n_4185  <= TRANSPORT a_N394  ;
and2_3623: n_4186 <=  n_4187  AND n_4188;
inv_3624: n_4187  <= TRANSPORT NOT a_N41_aNOT  ;
delay_3625: n_4188  <= TRANSPORT a_N392  ;
and1_3626: n_4189 <=  gnd;
delay_3627: a_LC5_A15  <= TRANSPORT a_EQ090  ;
xor2_3628: a_EQ090 <=  n_4192  XOR n_4199;
or2_3629: n_4192 <=  n_4193  OR n_4195;
and1_3630: n_4193 <=  n_4194;
delay_3631: n_4194  <= TRANSPORT a_LC6_A15  ;
and3_3632: n_4195 <=  n_4196  AND n_4197  AND n_4198;
delay_3633: n_4196  <= TRANSPORT a_N42  ;
delay_3634: n_4197  <= TRANSPORT a_N103  ;
delay_3635: n_4198  <= TRANSPORT a_SLCNTL_DOUT_F3_G  ;
and1_3636: n_4199 <=  gnd;
delay_3637: a_N51  <= TRANSPORT a_EQ091  ;
xor2_3638: a_EQ091 <=  n_4201  XOR n_4207;
or2_3639: n_4201 <=  n_4202  OR n_4204;
and1_3640: n_4202 <=  n_4203;
delay_3641: n_4203  <= TRANSPORT a_LC5_A15  ;
and2_3642: n_4204 <=  n_4205  AND n_4206;
delay_3643: n_4205  <= TRANSPORT a_N101  ;
delay_3644: n_4206  <= TRANSPORT a_N390  ;
and1_3645: n_4207 <=  gnd;
dff_3646: DFF_a16450

    PORT MAP ( D => a_EQ358, CLK => a_SREC_DAT_F5_G_aCLK, CLRN => vcc, PRN => vcc,
          Q => a_SREC_DAT_F5_G);
xor2_3647: a_EQ358 <=  n_4213  XOR n_4220;
or2_3648: n_4213 <=  n_4214  OR n_4217;
and2_3649: n_4214 <=  n_4215  AND n_4216;
inv_3650: n_4215  <= TRANSPORT NOT a_N792_aNOT  ;
delay_3651: n_4216  <= TRANSPORT a_N51  ;
and2_3652: n_4217 <=  n_4218  AND n_4219;
delay_3653: n_4218  <= TRANSPORT a_N792_aNOT  ;
delay_3654: n_4219  <= TRANSPORT a_SREC_DAT_F5_G  ;
and1_3655: n_4220 <=  gnd;
delay_3656: n_4221  <= TRANSPORT RCLK  ;
filter_3657: FILTER_a16450

    PORT MAP (IN1 => n_4221, Y => a_SREC_DAT_F5_G_aCLK);
dff_3658: DFF_a16450

    PORT MAP ( D => a_EQ307, CLK => a_SDLSB_DAT_F5_G_aCLK, CLRN => a_SDLSB_DAT_F5_G_aCLRN,
          PRN => vcc, Q => a_SDLSB_DAT_F5_G);
inv_3659: a_SDLSB_DAT_F5_G_aCLRN  <= TRANSPORT NOT MR  ;
xor2_3660: a_EQ307 <=  n_4229  XOR n_4236;
or2_3661: n_4229 <=  n_4230  OR n_4233;
and2_3662: n_4230 <=  n_4231  AND n_4232;
delay_3663: n_4231  <= TRANSPORT a_N795_aNOT  ;
delay_3664: n_4232  <= TRANSPORT a_SDLSB_DAT_F5_G  ;
and2_3665: n_4233 <=  n_4234  AND n_4235;
inv_3666: n_4234  <= TRANSPORT NOT a_N795_aNOT  ;
delay_3667: n_4235  <= TRANSPORT DIN(5)  ;
and1_3668: n_4236 <=  gnd;
delay_3669: n_4237  <= TRANSPORT CLK  ;
filter_3670: FILTER_a16450

    PORT MAP (IN1 => n_4237, Y => a_SDLSB_DAT_F5_G_aCLK);
delay_3671: a_N40  <= TRANSPORT a_N40_aIN  ;
xor2_3672: a_N40_aIN <=  n_4241  XOR n_4245;
or1_3673: n_4241 <=  n_4242;
and2_3674: n_4242 <=  n_4243  AND n_4244;
delay_3675: n_4243  <= TRANSPORT a_SLCNTL_DOUT_F1_G  ;
inv_3676: n_4244  <= TRANSPORT NOT a_SLCNTL_DOUT_F0_G  ;
and1_3677: n_4245 <=  gnd;
delay_3678: a_LC7_A15  <= TRANSPORT a_EQ087  ;
xor2_3679: a_EQ087 <=  n_4248  XOR n_4255;
or2_3680: n_4248 <=  n_4249  OR n_4252;
and2_3681: n_4249 <=  n_4250  AND n_4251;
delay_3682: n_4250  <= TRANSPORT a_N102  ;
delay_3683: n_4251  <= TRANSPORT a_N319  ;
and2_3684: n_4252 <=  n_4253  AND n_4254;
delay_3685: n_4253  <= TRANSPORT a_N392  ;
delay_3686: n_4254  <= TRANSPORT a_N40  ;
and1_3687: n_4255 <=  gnd;
delay_3688: a_N49  <= TRANSPORT a_EQ088  ;
xor2_3689: a_EQ088 <=  n_4257  XOR n_4263;
or2_3690: n_4257 <=  n_4258  OR n_4260;
and1_3691: n_4258 <=  n_4259;
delay_3692: n_4259  <= TRANSPORT a_LC7_A15  ;
and2_3693: n_4260 <=  n_4261  AND n_4262;
delay_3694: n_4261  <= TRANSPORT a_N101  ;
delay_3695: n_4262  <= TRANSPORT a_N394  ;
and1_3696: n_4263 <=  gnd;
dff_3697: DFF_a16450

    PORT MAP ( D => a_EQ359, CLK => a_SREC_DAT_F6_G_aCLK, CLRN => vcc, PRN => vcc,
          Q => a_SREC_DAT_F6_G);
xor2_3698: a_EQ359 <=  n_4269  XOR n_4276;
or2_3699: n_4269 <=  n_4270  OR n_4273;
and2_3700: n_4270 <=  n_4271  AND n_4272;
inv_3701: n_4271  <= TRANSPORT NOT a_N792_aNOT  ;
delay_3702: n_4272  <= TRANSPORT a_N49  ;
and2_3703: n_4273 <=  n_4274  AND n_4275;
delay_3704: n_4274  <= TRANSPORT a_N792_aNOT  ;
delay_3705: n_4275  <= TRANSPORT a_SREC_DAT_F6_G  ;
and1_3706: n_4276 <=  gnd;
delay_3707: n_4277  <= TRANSPORT RCLK  ;
filter_3708: FILTER_a16450

    PORT MAP (IN1 => n_4277, Y => a_SREC_DAT_F6_G_aCLK);
dff_3709: DFF_a16450

    PORT MAP ( D => a_EQ281, CLK => a_N1314_aCLK, CLRN => a_N1314_aCLRN, PRN => vcc,
          Q => a_N1314);
inv_3710: a_N1314_aCLRN  <= TRANSPORT NOT MR  ;
xor2_3711: a_EQ281 <=  n_4285  XOR n_4296;
or3_3712: n_4285 <=  n_4286  OR n_4290  OR n_4293;
and3_3713: n_4286 <=  n_4287  AND n_4288  AND n_4289;
delay_3714: n_4287  <= TRANSPORT a_N804  ;
delay_3715: n_4288  <= TRANSPORT a_N32  ;
delay_3716: n_4289  <= TRANSPORT DIN(6)  ;
and2_3717: n_4290 <=  n_4291  AND n_4292;
inv_3718: n_4291  <= TRANSPORT NOT a_N32  ;
delay_3719: n_4292  <= TRANSPORT a_N1314  ;
and2_3720: n_4293 <=  n_4294  AND n_4295;
inv_3721: n_4294  <= TRANSPORT NOT a_N804  ;
delay_3722: n_4295  <= TRANSPORT a_N1314  ;
and1_3723: n_4296 <=  gnd;
inv_3724: n_4297  <= TRANSPORT NOT CLK  ;
filter_3725: FILTER_a16450

    PORT MAP (IN1 => n_4297, Y => a_N1314_aCLK);
delay_3726: a_N48  <= TRANSPORT a_EQ086  ;
xor2_3727: a_EQ086 <=  n_4300  XOR n_4308;
or2_3728: n_4300 <=  n_4301  OR n_4305;
and3_3729: n_4301 <=  n_4302  AND n_4303  AND n_4304;
delay_3730: n_4302  <= TRANSPORT a_N42  ;
delay_3731: n_4303  <= TRANSPORT a_N101  ;
delay_3732: n_4304  <= TRANSPORT a_SLCNTL_DOUT_F3_G  ;
and2_3733: n_4305 <=  n_4306  AND n_4307;
delay_3734: n_4306  <= TRANSPORT a_N42  ;
delay_3735: n_4307  <= TRANSPORT a_N392  ;
and1_3736: n_4308 <=  gnd;
dff_3737: DFF_a16450

    PORT MAP ( D => a_EQ360, CLK => a_SREC_DAT_F7_G_aCLK, CLRN => vcc, PRN => vcc,
          Q => a_SREC_DAT_F7_G);
xor2_3738: a_EQ360 <=  n_4314  XOR n_4321;
or2_3739: n_4314 <=  n_4315  OR n_4318;
and2_3740: n_4315 <=  n_4316  AND n_4317;
inv_3741: n_4316  <= TRANSPORT NOT a_N792_aNOT  ;
delay_3742: n_4317  <= TRANSPORT a_N48  ;
and2_3743: n_4318 <=  n_4319  AND n_4320;
delay_3744: n_4319  <= TRANSPORT a_N792_aNOT  ;
delay_3745: n_4320  <= TRANSPORT a_SREC_DAT_F7_G  ;
and1_3746: n_4321 <=  gnd;
delay_3747: n_4322  <= TRANSPORT RCLK  ;
filter_3748: FILTER_a16450

    PORT MAP (IN1 => n_4322, Y => a_SREC_DAT_F7_G_aCLK);
dff_3749: DFF_a16450

    PORT MAP ( D => a_EQ309, CLK => a_SDLSB_DAT_F7_G_aCLK, CLRN => a_SDLSB_DAT_F7_G_aCLRN,
          PRN => vcc, Q => a_SDLSB_DAT_F7_G);
inv_3750: a_SDLSB_DAT_F7_G_aCLRN  <= TRANSPORT NOT MR  ;
xor2_3751: a_EQ309 <=  n_4330  XOR n_4337;
or2_3752: n_4330 <=  n_4331  OR n_4334;
and2_3753: n_4331 <=  n_4332  AND n_4333;
delay_3754: n_4332  <= TRANSPORT a_N795_aNOT  ;
delay_3755: n_4333  <= TRANSPORT a_SDLSB_DAT_F7_G  ;
and2_3756: n_4334 <=  n_4335  AND n_4336;
inv_3757: n_4335  <= TRANSPORT NOT a_N795_aNOT  ;
delay_3758: n_4336  <= TRANSPORT DIN(7)  ;
and1_3759: n_4337 <=  gnd;
delay_3760: n_4338  <= TRANSPORT CLK  ;
filter_3761: FILTER_a16450

    PORT MAP (IN1 => n_4338, Y => a_SDLSB_DAT_F7_G_aCLK);
delay_3762: a_N208  <= TRANSPORT a_EQ147  ;
xor2_3763: a_EQ147 <=  n_4342  XOR n_4351;
or3_3764: n_4342 <=  n_4343  OR n_4346  OR n_4349;
and2_3765: n_4343 <=  n_4344  AND n_4345;
inv_3766: n_4344  <= TRANSPORT NOT a_N1349  ;
delay_3767: n_4345  <= TRANSPORT a_SLCNTL_DOUT_F0_G  ;
and2_3768: n_4346 <=  n_4347  AND n_4348;
inv_3769: n_4347  <= TRANSPORT NOT a_N1349  ;
delay_3770: n_4348  <= TRANSPORT a_SLCNTL_DOUT_F1_G  ;
and1_3771: n_4349 <=  n_4350;
inv_3772: n_4350  <= TRANSPORT NOT baud_en  ;
and1_3773: n_4351 <=  gnd;
delay_3774: a_LC6_C19  <= TRANSPORT a_EQ150  ;
xor2_3775: a_EQ150 <=  n_4354  XOR n_4364;
or3_3776: n_4354 <=  n_4355  OR n_4358  OR n_4361;
and2_3777: n_4355 <=  n_4356  AND n_4357;
inv_3778: n_4356  <= TRANSPORT NOT a_N705  ;
delay_3779: n_4357  <= TRANSPORT a_SLCNTL_DOUT_F2_G  ;
and2_3780: n_4358 <=  n_4359  AND n_4360;
inv_3781: n_4359  <= TRANSPORT NOT a_N214  ;
inv_3782: n_4360  <= TRANSPORT NOT a_N705  ;
and2_3783: n_4361 <=  n_4362  AND n_4363;
delay_3784: n_4362  <= TRANSPORT a_N208  ;
delay_3785: n_4363  <= TRANSPORT a_N705  ;
and1_3786: n_4364 <=  gnd;
delay_3787: a_LC4_C19  <= TRANSPORT a_LC4_C19_aIN  ;
xor2_3788: a_LC4_C19_aIN <=  n_4367  XOR n_4372;
or1_3789: n_4367 <=  n_4368;
and3_3790: n_4368 <=  n_4369  AND n_4370  AND n_4371;
delay_3791: n_4369  <= TRANSPORT a_LC6_C19  ;
delay_3792: n_4370  <= TRANSPORT a_N702  ;
inv_3793: n_4371  <= TRANSPORT NOT a_N704  ;
and1_3794: n_4372 <=  gnd;
delay_3795: a_N203_aNOT  <= TRANSPORT a_EQ146  ;
xor2_3796: a_EQ146 <=  n_4375  XOR n_4382;
or3_3797: n_4375 <=  n_4376  OR n_4378  OR n_4380;
and1_3798: n_4376 <=  n_4377;
inv_3799: n_4377  <= TRANSPORT NOT a_N704  ;
and1_3800: n_4378 <=  n_4379;
inv_3801: n_4379  <= TRANSPORT NOT a_N705  ;
and1_3802: n_4380 <=  n_4381;
inv_3803: n_4381  <= TRANSPORT NOT a_N214  ;
and1_3804: n_4382 <=  gnd;
dff_3805: DFF_a16450

    PORT MAP ( D => a_EQ214, CLK => a_N702_aCLK, CLRN => a_N702_aCLRN, PRN => vcc,
          Q => a_N702);
inv_3806: a_N702_aCLRN  <= TRANSPORT NOT MR  ;
xor2_3807: a_EQ214 <=  n_4389  XOR n_4397;
or3_3808: n_4389 <=  n_4390  OR n_4393  OR n_4395;
and2_3809: n_4390 <=  n_4391  AND n_4392;
inv_3810: n_4391  <= TRANSPORT NOT a_N199  ;
inv_3811: n_4392  <= TRANSPORT NOT a_SLCNTL_DOUT_F3_G  ;
and1_3812: n_4393 <=  n_4394;
delay_3813: n_4394  <= TRANSPORT a_LC4_C19  ;
and1_3814: n_4395 <=  n_4396;
inv_3815: n_4396  <= TRANSPORT NOT a_N203_aNOT  ;
and1_3816: n_4397 <=  gnd;
delay_3817: n_4398  <= TRANSPORT CLK  ;
filter_3818: FILTER_a16450

    PORT MAP (IN1 => n_4398, Y => a_N702_aCLK);
delay_3819: a_LC4_A3  <= TRANSPORT a_EQ256  ;
xor2_3820: a_EQ256 <=  n_4402  XOR n_4412;
or3_3821: n_4402 <=  n_4403  OR n_4406  OR n_4409;
and2_3822: n_4403 <=  n_4404  AND n_4405;
inv_3823: n_4404  <= TRANSPORT NOT a_N18  ;
inv_3824: n_4405  <= TRANSPORT NOT a_N1362  ;
and2_3825: n_4406 <=  n_4407  AND n_4408;
delay_3826: n_4407  <= TRANSPORT a_N18  ;
delay_3827: n_4408  <= TRANSPORT a_N1354_aNOT  ;
and2_3828: n_4409 <=  n_4410  AND n_4411;
delay_3829: n_4410  <= TRANSPORT a_N18  ;
delay_3830: n_4411  <= TRANSPORT a_N785  ;
and1_3831: n_4412 <=  gnd;
dff_3832: DFF_a16450

    PORT MAP ( D => a_EQ290, CLK => a_N1354_aNOT_aCLK, CLRN => a_N1354_aNOT_aCLRN,
          PRN => vcc, Q => a_N1354_aNOT);
inv_3833: a_N1354_aNOT_aCLRN  <= TRANSPORT NOT MR  ;
xor2_3834: a_EQ290 <=  n_4419  XOR n_4426;
or2_3835: n_4419 <=  n_4420  OR n_4423;
and2_3836: n_4420 <=  n_4421  AND n_4422;
delay_3837: n_4421  <= TRANSPORT a_N535_aNOT  ;
delay_3838: n_4422  <= TRANSPORT a_LC4_A3  ;
and2_3839: n_4423 <=  n_4424  AND n_4425;
inv_3840: n_4424  <= TRANSPORT NOT a_N785  ;
delay_3841: n_4425  <= TRANSPORT a_LC4_A3  ;
and1_3842: n_4426 <=  gnd;
delay_3843: n_4427  <= TRANSPORT CLK  ;
filter_3844: FILTER_a16450

    PORT MAP (IN1 => n_4427, Y => a_N1354_aNOT_aCLK);
delay_3845: a_N30  <= TRANSPORT a_N30_aIN  ;
xor2_3846: a_N30_aIN <=  n_4430  XOR n_4435;
or1_3847: n_4430 <=  n_4431;
and3_3848: n_4431 <=  n_4432  AND n_4433  AND n_4434;
delay_3849: n_4432  <= TRANSPORT a_N1310  ;
delay_3850: n_4433  <= TRANSPORT a_N1311  ;
inv_3851: n_4434  <= TRANSPORT NOT a_N1312  ;
and1_3852: n_4435 <=  gnd;
dff_3853: DFF_a16450

    PORT MAP ( D => a_EQ245, CLK => a_N810_aCLK, CLRN => a_N810_aCLRN, PRN => vcc,
          Q => a_N810);
inv_3854: a_N810_aCLRN  <= TRANSPORT NOT MR  ;
xor2_3855: a_EQ245 <=  n_4443  XOR n_4452;
or2_3856: n_4443 <=  n_4444  OR n_4448;
and3_3857: n_4444 <=  n_4445  AND n_4446  AND n_4447;
delay_3858: n_4445  <= TRANSPORT a_SCSOUT  ;
delay_3859: n_4446  <= TRANSPORT a_N30  ;
inv_3860: n_4447  <= TRANSPORT NOT nRD  ;
and3_3861: n_4448 <=  n_4449  AND n_4450  AND n_4451;
delay_3862: n_4449  <= TRANSPORT a_SCSOUT  ;
delay_3863: n_4450  <= TRANSPORT a_N30  ;
delay_3864: n_4451  <= TRANSPORT RD  ;
and1_3865: n_4452 <=  gnd;
inv_3866: n_4453  <= TRANSPORT NOT CLK  ;
filter_3867: FILTER_a16450

    PORT MAP (IN1 => n_4453, Y => a_N810_aCLK);
dff_3868: DFF_a16450

    PORT MAP ( D => a_N816_aD, CLK => a_N816_aCLK, CLRN => a_N816_aCLRN, PRN => vcc,
          Q => a_N816);
inv_3869: a_N816_aCLRN  <= TRANSPORT NOT MR  ;
xor2_3870: a_N816_aD <=  n_4462  XOR n_4465;
or1_3871: n_4462 <=  n_4463;
and1_3872: n_4463 <=  n_4464;
delay_3873: n_4464  <= TRANSPORT a_N810  ;
and1_3874: n_4465 <=  gnd;
inv_3875: n_4466  <= TRANSPORT NOT CLK  ;
filter_3876: FILTER_a16450

    PORT MAP (IN1 => n_4466, Y => a_N816_aCLK);
delay_3877: a_N786_aNOT  <= TRANSPORT a_EQ221  ;
xor2_3878: a_EQ221 <=  n_4470  XOR n_4475;
or2_3879: n_4470 <=  n_4471  OR n_4473;
and1_3880: n_4471 <=  n_4472;
inv_3881: n_4472  <= TRANSPORT NOT a_N816  ;
and1_3882: n_4473 <=  n_4474;
delay_3883: n_4474  <= TRANSPORT a_N810  ;
and1_3884: n_4475 <=  gnd;
dff_3885: DFF_a16450

    PORT MAP ( D => a_N815_aD, CLK => a_N815_aCLK, CLRN => a_N815_aCLRN, PRN => vcc,
          Q => a_N815);
inv_3886: a_N815_aCLRN  <= TRANSPORT NOT MR  ;
xor2_3887: a_N815_aD <=  n_4483  XOR n_4490;
or2_3888: n_4483 <=  n_4484  OR n_4487;
and2_3889: n_4484 <=  n_4485  AND n_4486;
delay_3890: n_4485  <= TRANSPORT en_lpbk  ;
delay_3891: n_4486  <= TRANSPORT a_SMCNTL_DAT_F3_G  ;
and2_3892: n_4487 <=  n_4488  AND n_4489;
inv_3893: n_4488  <= TRANSPORT NOT nDCD  ;
inv_3894: n_4489  <= TRANSPORT NOT en_lpbk  ;
and1_3895: n_4490 <=  gnd;
inv_3896: n_4491  <= TRANSPORT NOT CLK  ;
filter_3897: FILTER_a16450

    PORT MAP (IN1 => n_4491, Y => a_N815_aCLK);
dff_3898: DFF_a16450

    PORT MAP ( D => a_N820_aD, CLK => a_N820_aCLK, CLRN => a_N820_aCLRN, PRN => vcc,
          Q => a_N820);
inv_3899: a_N820_aCLRN  <= TRANSPORT NOT MR  ;
xor2_3900: a_N820_aD <=  n_4500  XOR n_4503;
or1_3901: n_4500 <=  n_4501;
and1_3902: n_4501 <=  n_4502;
delay_3903: n_4502  <= TRANSPORT a_N815  ;
and1_3904: n_4503 <=  gnd;
inv_3905: n_4504  <= TRANSPORT NOT CLK  ;
filter_3906: FILTER_a16450

    PORT MAP (IN1 => n_4504, Y => a_N820_aCLK);
dff_3907: DFF_a16450

    PORT MAP ( D => a_EQ348, CLK => a_SMSTAT_DAT_F3_G_aCLK, CLRN => a_SMSTAT_DAT_F3_G_aCLRN,
          PRN => vcc, Q => a_SMSTAT_DAT_F3_G);
inv_3908: a_SMSTAT_DAT_F3_G_aCLRN  <= TRANSPORT NOT MR  ;
xor2_3909: a_EQ348 <=  n_4512  XOR n_4524;
or3_3910: n_4512 <=  n_4513  OR n_4516  OR n_4520;
and2_3911: n_4513 <=  n_4514  AND n_4515;
delay_3912: n_4514  <= TRANSPORT a_N786_aNOT  ;
delay_3913: n_4515  <= TRANSPORT a_SMSTAT_DAT_F3_G  ;
and3_3914: n_4516 <=  n_4517  AND n_4518  AND n_4519;
delay_3915: n_4517  <= TRANSPORT a_N786_aNOT  ;
delay_3916: n_4518  <= TRANSPORT a_N815  ;
inv_3917: n_4519  <= TRANSPORT NOT a_N820  ;
and3_3918: n_4520 <=  n_4521  AND n_4522  AND n_4523;
delay_3919: n_4521  <= TRANSPORT a_N786_aNOT  ;
inv_3920: n_4522  <= TRANSPORT NOT a_N815  ;
delay_3921: n_4523  <= TRANSPORT a_N820  ;
and1_3922: n_4524 <=  gnd;
delay_3923: n_4525  <= TRANSPORT CLK  ;
filter_3924: FILTER_a16450

    PORT MAP (IN1 => n_4525, Y => a_SMSTAT_DAT_F3_G_aCLK);
dff_3925: DFF_a16450

    PORT MAP ( D => a_N814_aD, CLK => a_N814_aCLK, CLRN => a_N814_aCLRN, PRN => vcc,
          Q => a_N814);
inv_3926: a_N814_aCLRN  <= TRANSPORT NOT MR  ;
xor2_3927: a_N814_aD <=  n_4534  XOR n_4541;
or2_3928: n_4534 <=  n_4535  OR n_4538;
and2_3929: n_4535 <=  n_4536  AND n_4537;
delay_3930: n_4536  <= TRANSPORT en_lpbk  ;
delay_3931: n_4537  <= TRANSPORT a_SMCNTL_DAT_F2_G  ;
and2_3932: n_4538 <=  n_4539  AND n_4540;
inv_3933: n_4539  <= TRANSPORT NOT nRI  ;
inv_3934: n_4540  <= TRANSPORT NOT en_lpbk  ;
and1_3935: n_4541 <=  gnd;
inv_3936: n_4542  <= TRANSPORT NOT CLK  ;
filter_3937: FILTER_a16450

    PORT MAP (IN1 => n_4542, Y => a_N814_aCLK);
dff_3938: DFF_a16450

    PORT MAP ( D => a_N819_aD, CLK => a_N819_aCLK, CLRN => a_N819_aCLRN, PRN => vcc,
          Q => a_N819);
inv_3939: a_N819_aCLRN  <= TRANSPORT NOT MR  ;
xor2_3940: a_N819_aD <=  n_4551  XOR n_4554;
or1_3941: n_4551 <=  n_4552;
and1_3942: n_4552 <=  n_4553;
delay_3943: n_4553  <= TRANSPORT a_N814  ;
and1_3944: n_4554 <=  gnd;
inv_3945: n_4555  <= TRANSPORT NOT CLK  ;
filter_3946: FILTER_a16450

    PORT MAP (IN1 => n_4555, Y => a_N819_aCLK);
dff_3947: DFF_a16450

    PORT MAP ( D => a_EQ347, CLK => a_SMSTAT_DAT_F2_G_aCLK, CLRN => a_SMSTAT_DAT_F2_G_aCLRN,
          PRN => vcc, Q => a_SMSTAT_DAT_F2_G);
inv_3948: a_SMSTAT_DAT_F2_G_aCLRN  <= TRANSPORT NOT MR  ;
xor2_3949: a_EQ347 <=  n_4563  XOR n_4571;
or2_3950: n_4563 <=  n_4564  OR n_4567;
and2_3951: n_4564 <=  n_4565  AND n_4566;
delay_3952: n_4565  <= TRANSPORT a_N786_aNOT  ;
delay_3953: n_4566  <= TRANSPORT a_SMSTAT_DAT_F2_G  ;
and3_3954: n_4567 <=  n_4568  AND n_4569  AND n_4570;
delay_3955: n_4568  <= TRANSPORT a_N786_aNOT  ;
inv_3956: n_4569  <= TRANSPORT NOT a_N814  ;
delay_3957: n_4570  <= TRANSPORT a_N819  ;
and1_3958: n_4571 <=  gnd;
delay_3959: n_4572  <= TRANSPORT CLK  ;
filter_3960: FILTER_a16450

    PORT MAP (IN1 => n_4572, Y => a_SMSTAT_DAT_F2_G_aCLK);
dff_3961: DFF_a16450

    PORT MAP ( D => a_N812_aD, CLK => a_N812_aCLK, CLRN => a_N812_aCLRN, PRN => vcc,
          Q => a_N812);
inv_3962: a_N812_aCLRN  <= TRANSPORT NOT MR  ;
xor2_3963: a_N812_aD <=  n_4581  XOR n_4588;
or2_3964: n_4581 <=  n_4582  OR n_4585;
and2_3965: n_4582 <=  n_4583  AND n_4584;
delay_3966: n_4583  <= TRANSPORT en_lpbk  ;
delay_3967: n_4584  <= TRANSPORT a_SMCNTL_DAT_F0_G  ;
and2_3968: n_4585 <=  n_4586  AND n_4587;
inv_3969: n_4586  <= TRANSPORT NOT nCTS  ;
inv_3970: n_4587  <= TRANSPORT NOT en_lpbk  ;
and1_3971: n_4588 <=  gnd;
inv_3972: n_4589  <= TRANSPORT NOT CLK  ;
filter_3973: FILTER_a16450

    PORT MAP (IN1 => n_4589, Y => a_N812_aCLK);
dff_3974: DFF_a16450

    PORT MAP ( D => a_N817_aD, CLK => a_N817_aCLK, CLRN => a_N817_aCLRN, PRN => vcc,
          Q => a_N817);
inv_3975: a_N817_aCLRN  <= TRANSPORT NOT MR  ;
xor2_3976: a_N817_aD <=  n_4598  XOR n_4601;
or1_3977: n_4598 <=  n_4599;
and1_3978: n_4599 <=  n_4600;
delay_3979: n_4600  <= TRANSPORT a_N812  ;
and1_3980: n_4601 <=  gnd;
inv_3981: n_4602  <= TRANSPORT NOT CLK  ;
filter_3982: FILTER_a16450

    PORT MAP (IN1 => n_4602, Y => a_N817_aCLK);
dff_3983: DFF_a16450

    PORT MAP ( D => a_EQ345, CLK => a_SMSTAT_DAT_F0_G_aCLK, CLRN => a_SMSTAT_DAT_F0_G_aCLRN,
          PRN => vcc, Q => a_SMSTAT_DAT_F0_G);
inv_3984: a_SMSTAT_DAT_F0_G_aCLRN  <= TRANSPORT NOT MR  ;
xor2_3985: a_EQ345 <=  n_4610  XOR n_4622;
or3_3986: n_4610 <=  n_4611  OR n_4614  OR n_4618;
and2_3987: n_4611 <=  n_4612  AND n_4613;
delay_3988: n_4612  <= TRANSPORT a_N786_aNOT  ;
delay_3989: n_4613  <= TRANSPORT a_SMSTAT_DAT_F0_G  ;
and3_3990: n_4614 <=  n_4615  AND n_4616  AND n_4617;
delay_3991: n_4615  <= TRANSPORT a_N786_aNOT  ;
delay_3992: n_4616  <= TRANSPORT a_N812  ;
inv_3993: n_4617  <= TRANSPORT NOT a_N817  ;
and3_3994: n_4618 <=  n_4619  AND n_4620  AND n_4621;
delay_3995: n_4619  <= TRANSPORT a_N786_aNOT  ;
inv_3996: n_4620  <= TRANSPORT NOT a_N812  ;
delay_3997: n_4621  <= TRANSPORT a_N817  ;
and1_3998: n_4622 <=  gnd;
delay_3999: n_4623  <= TRANSPORT CLK  ;
filter_4000: FILTER_a16450

    PORT MAP (IN1 => n_4623, Y => a_SMSTAT_DAT_F0_G_aCLK);
dff_4001: DFF_a16450

    PORT MAP ( D => a_EQ169, CLK => a_N349_aCLK, CLRN => a_N349_aCLRN, PRN => vcc,
          Q => a_N349);
inv_4002: a_N349_aCLRN  <= TRANSPORT NOT MR  ;
xor2_4003: a_EQ169 <=  n_4631  XOR n_4639;
or2_4004: n_4631 <=  n_4632  OR n_4636;
and3_4005: n_4632 <=  n_4633  AND n_4634  AND n_4635;
delay_4006: n_4633  <= TRANSPORT a_N44  ;
inv_4007: n_4634  <= TRANSPORT NOT a_N16_aNOT  ;
inv_4008: n_4635  <= TRANSPORT NOT a_N349  ;
and2_4009: n_4636 <=  n_4637  AND n_4638;
inv_4010: n_4637  <= TRANSPORT NOT a_N44  ;
delay_4011: n_4638  <= TRANSPORT a_N349  ;
and1_4012: n_4639 <=  gnd;
delay_4013: n_4640  <= TRANSPORT RCLK  ;
filter_4014: FILTER_a16450

    PORT MAP (IN1 => n_4640, Y => a_N349_aCLK);
dff_4015: DFF_a16450

    PORT MAP ( D => a_EQ340, CLK => a_SLSTAT_DAT_F5_G_aNOT_aCLK, CLRN => a_SLSTAT_DAT_F5_G_aNOT_aCLRN,
          PRN => vcc, Q => a_SLSTAT_DAT_F5_G_aNOT);
inv_4016: a_SLSTAT_DAT_F5_G_aNOT_aCLRN  <= TRANSPORT NOT MR  ;
xor2_4017: a_EQ340 <=  n_4648  XOR n_4655;
or2_4018: n_4648 <=  n_4649  OR n_4652;
and2_4019: n_4649 <=  n_4650  AND n_4651;
delay_4020: n_4650  <= TRANSPORT a_N18  ;
delay_4021: n_4651  <= TRANSPORT a_SLSTAT_DAT_F5_G_aNOT  ;
and2_4022: n_4652 <=  n_4653  AND n_4654;
delay_4023: n_4653  <= TRANSPORT a_N18  ;
delay_4024: n_4654  <= TRANSPORT a_N797  ;
and1_4025: n_4655 <=  gnd;
delay_4026: n_4656  <= TRANSPORT CLK  ;
filter_4027: FILTER_a16450

    PORT MAP (IN1 => n_4656, Y => a_SLSTAT_DAT_F5_G_aNOT_aCLK);
delay_4028: a_LC7_C5  <= TRANSPORT a_EQ138  ;
xor2_4029: a_EQ138 <=  n_4660  XOR n_4667;
or2_4030: n_4660 <=  n_4661  OR n_4664;
and2_4031: n_4661 <=  n_4662  AND n_4663;
inv_4032: n_4662  <= TRANSPORT NOT a_N37_aNOT  ;
delay_4033: n_4663  <= TRANSPORT a_SLSTAT_DAT_F5_G_aNOT  ;
and2_4034: n_4664 <=  n_4665  AND n_4666;
inv_4035: n_4665  <= TRANSPORT NOT a_N37_aNOT  ;
delay_4036: n_4666  <= TRANSPORT a_N208  ;
and1_4037: n_4667 <=  gnd;
delay_4038: a_LC8_C5  <= TRANSPORT a_EQ137  ;
xor2_4039: a_EQ137 <=  n_4670  XOR n_4679;
or2_4040: n_4670 <=  n_4671  OR n_4675;
and3_4041: n_4671 <=  n_4672  AND n_4673  AND n_4674;
inv_4042: n_4672  <= TRANSPORT NOT a_N214  ;
delay_4043: n_4673  <= TRANSPORT a_N705  ;
delay_4044: n_4674  <= TRANSPORT a_N704  ;
and3_4045: n_4675 <=  n_4676  AND n_4677  AND n_4678;
inv_4046: n_4676  <= TRANSPORT NOT a_N214  ;
inv_4047: n_4677  <= TRANSPORT NOT a_N702  ;
delay_4048: n_4678  <= TRANSPORT a_N705  ;
and1_4049: n_4679 <=  gnd;
delay_4050: a_LC6_C5  <= TRANSPORT a_EQ139  ;
xor2_4051: a_EQ139 <=  n_4682  XOR n_4689;
or2_4052: n_4682 <=  n_4683  OR n_4686;
and2_4053: n_4683 <=  n_4684  AND n_4685;
delay_4054: n_4684  <= TRANSPORT a_N214  ;
delay_4055: n_4685  <= TRANSPORT a_SLCNTL_DOUT_F2_G  ;
and2_4056: n_4686 <=  n_4687  AND n_4688;
delay_4057: n_4687  <= TRANSPORT a_N214  ;
delay_4058: n_4688  <= TRANSPORT a_SLSTAT_DAT_F5_G_aNOT  ;
and1_4059: n_4689 <=  gnd;
delay_4060: a_LC5_C5  <= TRANSPORT a_EQ140  ;
xor2_4061: a_EQ140 <=  n_4692  XOR n_4700;
or3_4062: n_4692 <=  n_4693  OR n_4695  OR n_4697;
and1_4063: n_4693 <=  n_4694;
delay_4064: n_4694  <= TRANSPORT a_LC7_C5  ;
and1_4065: n_4695 <=  n_4696;
delay_4066: n_4696  <= TRANSPORT a_LC8_C5  ;
and2_4067: n_4697 <=  n_4698  AND n_4699;
inv_4068: n_4698  <= TRANSPORT NOT a_N36_aNOT  ;
delay_4069: n_4699  <= TRANSPORT a_LC6_C5  ;
and1_4070: n_4700 <=  gnd;
delay_4071: a_N187_aNOT  <= TRANSPORT a_N187_aNOT_aIN  ;
xor2_4072: a_N187_aNOT_aIN <=  n_4703  XOR n_4708;
or1_4073: n_4703 <=  n_4704;
and3_4074: n_4704 <=  n_4705  AND n_4706  AND n_4707;
inv_4075: n_4705  <= TRANSPORT NOT a_N20_aNOT  ;
delay_4076: n_4706  <= TRANSPORT baud_en  ;
delay_4077: n_4707  <= TRANSPORT a_SLSTAT_DAT_F5_G_aNOT  ;
and1_4078: n_4708 <=  gnd;
dff_4079: DFF_a16450

    PORT MAP ( D => a_EQ216, CLK => a_N705_aCLK, CLRN => a_N705_aCLRN, PRN => vcc,
          Q => a_N705);
inv_4080: a_N705_aCLRN  <= TRANSPORT NOT MR  ;
xor2_4081: a_EQ216 <=  n_4715  XOR n_4723;
or3_4082: n_4715 <=  n_4716  OR n_4719  OR n_4721;
and2_4083: n_4716 <=  n_4717  AND n_4718;
inv_4084: n_4717  <= TRANSPORT NOT a_N199  ;
delay_4085: n_4718  <= TRANSPORT a_SLCNTL_DOUT_F3_G  ;
and1_4086: n_4719 <=  n_4720;
delay_4087: n_4720  <= TRANSPORT a_LC5_C5  ;
and1_4088: n_4721 <=  n_4722;
delay_4089: n_4722  <= TRANSPORT a_N187_aNOT  ;
and1_4090: n_4723 <=  gnd;
delay_4091: n_4724  <= TRANSPORT CLK  ;
filter_4092: FILTER_a16450

    PORT MAP (IN1 => n_4724, Y => a_N705_aCLK);
delay_4093: a_LC3_C19  <= TRANSPORT a_EQ154  ;
xor2_4094: a_EQ154 <=  n_4728  XOR n_4738;
or3_4095: n_4728 <=  n_4729  OR n_4732  OR n_4735;
and2_4096: n_4729 <=  n_4730  AND n_4731;
delay_4097: n_4730  <= TRANSPORT a_SLCNTL_DOUT_F3_G  ;
inv_4098: n_4731  <= TRANSPORT NOT a_N705  ;
and2_4099: n_4732 <=  n_4733  AND n_4734;
delay_4100: n_4733  <= TRANSPORT a_N199  ;
inv_4101: n_4734  <= TRANSPORT NOT a_N705  ;
and2_4102: n_4735 <=  n_4736  AND n_4737;
delay_4103: n_4736  <= TRANSPORT a_N203_aNOT  ;
delay_4104: n_4737  <= TRANSPORT a_N705  ;
and1_4105: n_4738 <=  gnd;
delay_4106: a_N38  <= TRANSPORT a_N38_aIN  ;
xor2_4107: a_N38_aIN <=  n_4741  XOR n_4746;
or1_4108: n_4741 <=  n_4742;
and3_4109: n_4742 <=  n_4743  AND n_4744  AND n_4745;
inv_4110: n_4743  <= TRANSPORT NOT a_N702  ;
delay_4111: n_4744  <= TRANSPORT a_N705  ;
inv_4112: n_4745  <= TRANSPORT NOT a_N704  ;
and1_4113: n_4746 <=  gnd;
dff_4114: DFF_a16450

    PORT MAP ( D => a_EQ215, CLK => a_N704_aCLK, CLRN => a_N704_aCLRN, PRN => vcc,
          Q => a_N704);
inv_4115: a_N704_aCLRN  <= TRANSPORT NOT MR  ;
xor2_4116: a_EQ215 <=  n_4753  XOR n_4760;
or2_4117: n_4753 <=  n_4754  OR n_4757;
and2_4118: n_4754 <=  n_4755  AND n_4756;
delay_4119: n_4755  <= TRANSPORT a_LC3_C19  ;
delay_4120: n_4756  <= TRANSPORT a_N704  ;
and2_4121: n_4757 <=  n_4758  AND n_4759;
delay_4122: n_4758  <= TRANSPORT a_N214  ;
delay_4123: n_4759  <= TRANSPORT a_N38  ;
and1_4124: n_4760 <=  gnd;
delay_4125: n_4761  <= TRANSPORT CLK  ;
filter_4126: FILTER_a16450

    PORT MAP (IN1 => n_4761, Y => a_N704_aCLK);
delay_4127: a_LC4_B4  <= TRANSPORT a_LC4_B4_aIN  ;
xor2_4128: a_LC4_B4_aIN <=  n_4765  XOR n_4770;
or1_4129: n_4765 <=  n_4766;
and3_4130: n_4766 <=  n_4767  AND n_4768  AND n_4769;
delay_4131: n_4767  <= TRANSPORT a_LC3_B4  ;
delay_4132: n_4768  <= TRANSPORT a_N1277  ;
delay_4133: n_4769  <= TRANSPORT a_N1276  ;
and1_4134: n_4770 <=  gnd;
dff_4135: DFF_a16450

    PORT MAP ( D => a_EQ258, CLK => a_N1274_aCLK, CLRN => a_N1274_aCLRN, PRN => vcc,
          Q => a_N1274);
inv_4136: a_N1274_aCLRN  <= TRANSPORT NOT MR  ;
xor2_4137: a_EQ258 <=  n_4777  XOR n_4791;
or3_4138: n_4777 <=  n_4778  OR n_4782  OR n_4786;
and3_4139: n_4778 <=  n_4779  AND n_4780  AND n_4781;
delay_4140: n_4779  <= TRANSPORT a_LC3_B18  ;
delay_4141: n_4780  <= TRANSPORT a_N1274  ;
inv_4142: n_4781  <= TRANSPORT NOT a_N1275  ;
and3_4143: n_4782 <=  n_4783  AND n_4784  AND n_4785;
delay_4144: n_4783  <= TRANSPORT a_LC3_B18  ;
inv_4145: n_4784  <= TRANSPORT NOT a_LC4_B4  ;
delay_4146: n_4785  <= TRANSPORT a_N1274  ;
and4_4147: n_4786 <=  n_4787  AND n_4788  AND n_4789  AND n_4790;
delay_4148: n_4787  <= TRANSPORT a_LC3_B18  ;
delay_4149: n_4788  <= TRANSPORT a_LC4_B4  ;
inv_4150: n_4789  <= TRANSPORT NOT a_N1274  ;
delay_4151: n_4790  <= TRANSPORT a_N1275  ;
and1_4152: n_4791 <=  gnd;
delay_4153: n_4792  <= TRANSPORT CLK  ;
filter_4154: FILTER_a16450

    PORT MAP (IN1 => n_4792, Y => a_N1274_aCLK);
dff_4155: DFF_a16450

    PORT MAP ( D => a_EQ259, CLK => a_N1275_aCLK, CLRN => a_N1275_aCLRN, PRN => vcc,
          Q => a_N1275);
inv_4156: a_N1275_aCLRN  <= TRANSPORT NOT MR  ;
xor2_4157: a_EQ259 <=  n_4800  XOR n_4809;
or2_4158: n_4800 <=  n_4801  OR n_4805;
and3_4159: n_4801 <=  n_4802  AND n_4803  AND n_4804;
delay_4160: n_4802  <= TRANSPORT a_LC3_B18  ;
inv_4161: n_4803  <= TRANSPORT NOT a_LC4_B4  ;
delay_4162: n_4804  <= TRANSPORT a_N1275  ;
and3_4163: n_4805 <=  n_4806  AND n_4807  AND n_4808;
delay_4164: n_4806  <= TRANSPORT a_LC3_B18  ;
delay_4165: n_4807  <= TRANSPORT a_LC4_B4  ;
inv_4166: n_4808  <= TRANSPORT NOT a_N1275  ;
and1_4167: n_4809 <=  gnd;
delay_4168: n_4810  <= TRANSPORT CLK  ;
filter_4169: FILTER_a16450

    PORT MAP (IN1 => n_4810, Y => a_N1275_aCLK);
dff_4170: DFF_a16450

    PORT MAP ( D => a_EQ316, CLK => a_SDMSB_DAT_F6_G_aCLK, CLRN => a_SDMSB_DAT_F6_G_aCLRN,
          PRN => vcc, Q => a_SDMSB_DAT_F6_G);
inv_4171: a_SDMSB_DAT_F6_G_aCLRN  <= TRANSPORT NOT MR  ;
xor2_4172: a_EQ316 <=  n_4818  XOR n_4825;
or2_4173: n_4818 <=  n_4819  OR n_4822;
and2_4174: n_4819 <=  n_4820  AND n_4821;
delay_4175: n_4820  <= TRANSPORT a_N794_aNOT  ;
delay_4176: n_4821  <= TRANSPORT a_SDMSB_DAT_F6_G  ;
and2_4177: n_4822 <=  n_4823  AND n_4824;
inv_4178: n_4823  <= TRANSPORT NOT a_N794_aNOT  ;
delay_4179: n_4824  <= TRANSPORT DIN(6)  ;
and1_4180: n_4825 <=  gnd;
delay_4181: n_4826  <= TRANSPORT CLK  ;
filter_4182: FILTER_a16450

    PORT MAP (IN1 => n_4826, Y => a_SDMSB_DAT_F6_G_aCLK);
dff_4183: DFF_a16450

    PORT MAP ( D => a_EQ272, CLK => a_N1288_aCLK, CLRN => a_N1288_aCLRN, PRN => vcc,
          Q => a_N1288);
inv_4184: a_N1288_aCLRN  <= TRANSPORT NOT MR  ;
xor2_4185: a_EQ272 <=  n_4834  XOR n_4843;
or2_4186: n_4834 <=  n_4835  OR n_4839;
and3_4187: n_4835 <=  n_4836  AND n_4837  AND n_4838;
delay_4188: n_4836  <= TRANSPORT a_LC3_B18  ;
delay_4189: n_4837  <= TRANSPORT a_N1288  ;
delay_4190: n_4838  <= TRANSPORT a_N1289_aNOT  ;
and3_4191: n_4839 <=  n_4840  AND n_4841  AND n_4842;
delay_4192: n_4840  <= TRANSPORT a_LC3_B18  ;
inv_4193: n_4841  <= TRANSPORT NOT a_N1288  ;
inv_4194: n_4842  <= TRANSPORT NOT a_N1289_aNOT  ;
and1_4195: n_4843 <=  gnd;
delay_4196: n_4844  <= TRANSPORT CLK  ;
filter_4197: FILTER_a16450

    PORT MAP (IN1 => n_4844, Y => a_N1288_aCLK);
dff_4198: DFF_a16450

    PORT MAP ( D => a_N1289_aNOT_aD, CLK => a_N1289_aNOT_aCLK, CLRN => a_N1289_aNOT_aCLRN,
          PRN => vcc, Q => a_N1289_aNOT);
inv_4199: a_N1289_aNOT_aCLRN  <= TRANSPORT NOT MR  ;
xor2_4200: a_N1289_aNOT_aD <=  n_4852  XOR n_4858;
or1_4201: n_4852 <=  n_4853;
and4_4202: n_4853 <=  n_4854  AND n_4855  AND n_4856  AND n_4857;
inv_4203: n_4854  <= TRANSPORT NOT a_N788  ;
delay_4204: n_4855  <= TRANSPORT a_N795_aNOT  ;
delay_4205: n_4856  <= TRANSPORT a_N794_aNOT  ;
inv_4206: n_4857  <= TRANSPORT NOT a_N1289_aNOT  ;
and1_4207: n_4858 <=  gnd;
delay_4208: n_4859  <= TRANSPORT CLK  ;
filter_4209: FILTER_a16450

    PORT MAP (IN1 => n_4859, Y => a_N1289_aNOT_aCLK);
dff_4210: DFF_a16450

    PORT MAP ( D => a_EQ327, CLK => a_SLCNTL_DOUT_F0_G_aCLK, CLRN => a_SLCNTL_DOUT_F0_G_aCLRN,
          PRN => vcc, Q => a_SLCNTL_DOUT_F0_G);
inv_4211: a_SLCNTL_DOUT_F0_G_aCLRN  <= TRANSPORT NOT MR  ;
xor2_4212: a_EQ327 <=  n_4867  XOR n_4878;
or3_4213: n_4867 <=  n_4868  OR n_4872  OR n_4875;
and3_4214: n_4868 <=  n_4869  AND n_4870  AND n_4871;
delay_4215: n_4869  <= TRANSPORT a_N804  ;
delay_4216: n_4870  <= TRANSPORT a_N35  ;
delay_4217: n_4871  <= TRANSPORT DIN(0)  ;
and2_4218: n_4872 <=  n_4873  AND n_4874;
inv_4219: n_4873  <= TRANSPORT NOT a_N35  ;
delay_4220: n_4874  <= TRANSPORT a_SLCNTL_DOUT_F0_G  ;
and2_4221: n_4875 <=  n_4876  AND n_4877;
inv_4222: n_4876  <= TRANSPORT NOT a_N804  ;
delay_4223: n_4877  <= TRANSPORT a_SLCNTL_DOUT_F0_G  ;
and1_4224: n_4878 <=  gnd;
inv_4225: n_4879  <= TRANSPORT NOT CLK  ;
filter_4226: FILTER_a16450

    PORT MAP (IN1 => n_4879, Y => a_SLCNTL_DOUT_F0_G_aCLK);
delay_4227: a_LC4_A2  <= TRANSPORT a_EQ111  ;
xor2_4228: a_EQ111 <=  n_4883  XOR n_4890;
or2_4229: n_4883 <=  n_4884  OR n_4887;
and2_4230: n_4884 <=  n_4885  AND n_4886;
delay_4231: n_4885  <= TRANSPORT a_N107  ;
delay_4232: n_4886  <= TRANSPORT a_N394  ;
and2_4233: n_4887 <=  n_4888  AND n_4889;
delay_4234: n_4888  <= TRANSPORT a_N104  ;
delay_4235: n_4889  <= TRANSPORT a_N375  ;
and1_4236: n_4890 <=  gnd;
delay_4237: a_LC3_A2  <= TRANSPORT a_EQ112  ;
xor2_4238: a_EQ112 <=  n_4893  XOR n_4900;
or2_4239: n_4893 <=  n_4894  OR n_4896;
and1_4240: n_4894 <=  n_4895;
delay_4241: n_4895  <= TRANSPORT a_LC4_A2  ;
and3_4242: n_4896 <=  n_4897  AND n_4898  AND n_4899;
delay_4243: n_4897  <= TRANSPORT a_N108  ;
delay_4244: n_4898  <= TRANSPORT a_N42  ;
delay_4245: n_4899  <= TRANSPORT a_SLCNTL_DOUT_F3_G  ;
and1_4246: n_4900 <=  gnd;
delay_4247: a_LC1_A2  <= TRANSPORT a_EQ113  ;
xor2_4248: a_EQ113 <=  n_4903  XOR n_4909;
or2_4249: n_4903 <=  n_4904  OR n_4906;
and1_4250: n_4904 <=  n_4905;
delay_4251: n_4905  <= TRANSPORT a_LC3_A2  ;
and2_4252: n_4906 <=  n_4907  AND n_4908;
delay_4253: n_4907  <= TRANSPORT a_N106  ;
delay_4254: n_4908  <= TRANSPORT a_N390  ;
and1_4255: n_4909 <=  gnd;
delay_4256: a_N60  <= TRANSPORT a_EQ114  ;
xor2_4257: a_EQ114 <=  n_4911  XOR n_4917;
or2_4258: n_4911 <=  n_4912  OR n_4914;
and1_4259: n_4912 <=  n_4913;
delay_4260: n_4913  <= TRANSPORT a_LC1_A2  ;
and2_4261: n_4914 <=  n_4915  AND n_4916;
delay_4262: n_4915  <= TRANSPORT a_N105  ;
delay_4263: n_4916  <= TRANSPORT a_N393  ;
and1_4264: n_4917 <=  gnd;
dff_4265: DFF_a16450

    PORT MAP ( D => a_EQ353, CLK => a_SREC_DAT_F0_G_aCLK, CLRN => vcc, PRN => vcc,
          Q => a_SREC_DAT_F0_G);
xor2_4266: a_EQ353 <=  n_4923  XOR n_4930;
or2_4267: n_4923 <=  n_4924  OR n_4927;
and2_4268: n_4924 <=  n_4925  AND n_4926;
inv_4269: n_4925  <= TRANSPORT NOT a_N792_aNOT  ;
delay_4270: n_4926  <= TRANSPORT a_N60  ;
and2_4271: n_4927 <=  n_4928  AND n_4929;
delay_4272: n_4928  <= TRANSPORT a_N792_aNOT  ;
delay_4273: n_4929  <= TRANSPORT a_SREC_DAT_F0_G  ;
and1_4274: n_4930 <=  gnd;
delay_4275: n_4931  <= TRANSPORT RCLK  ;
filter_4276: FILTER_a16450

    PORT MAP (IN1 => n_4931, Y => a_SREC_DAT_F0_G_aCLK);
dff_4277: DFF_a16450

    PORT MAP ( D => a_EQ310, CLK => a_SDMSB_DAT_F0_G_aCLK, CLRN => a_SDMSB_DAT_F0_G_aCLRN,
          PRN => vcc, Q => a_SDMSB_DAT_F0_G);
inv_4278: a_SDMSB_DAT_F0_G_aCLRN  <= TRANSPORT NOT MR  ;
xor2_4279: a_EQ310 <=  n_4939  XOR n_4950;
or3_4280: n_4939 <=  n_4940  OR n_4944  OR n_4947;
and3_4281: n_4940 <=  n_4941  AND n_4942  AND n_4943;
delay_4282: n_4941  <= TRANSPORT a_N804  ;
inv_4283: n_4942  <= TRANSPORT NOT a_LC1_B18  ;
delay_4284: n_4943  <= TRANSPORT DIN(0)  ;
and2_4285: n_4944 <=  n_4945  AND n_4946;
delay_4286: n_4945  <= TRANSPORT a_LC1_B18  ;
delay_4287: n_4946  <= TRANSPORT a_SDMSB_DAT_F0_G  ;
and2_4288: n_4947 <=  n_4948  AND n_4949;
inv_4289: n_4948  <= TRANSPORT NOT a_N804  ;
delay_4290: n_4949  <= TRANSPORT a_SDMSB_DAT_F0_G  ;
and1_4291: n_4950 <=  gnd;
delay_4292: n_4951  <= TRANSPORT CLK  ;
filter_4293: FILTER_a16450

    PORT MAP (IN1 => n_4951, Y => a_SDMSB_DAT_F0_G_aCLK);
dff_4294: DFF_a16450

    PORT MAP ( D => a_N813_aD, CLK => a_N813_aCLK, CLRN => a_N813_aCLRN, PRN => vcc,
          Q => a_N813);
inv_4295: a_N813_aCLRN  <= TRANSPORT NOT MR  ;
xor2_4296: a_N813_aD <=  n_4960  XOR n_4967;
or2_4297: n_4960 <=  n_4961  OR n_4964;
and2_4298: n_4961 <=  n_4962  AND n_4963;
delay_4299: n_4962  <= TRANSPORT en_lpbk  ;
delay_4300: n_4963  <= TRANSPORT a_SMCNTL_DAT_F1_G  ;
and2_4301: n_4964 <=  n_4965  AND n_4966;
inv_4302: n_4965  <= TRANSPORT NOT nDSR  ;
inv_4303: n_4966  <= TRANSPORT NOT en_lpbk  ;
and1_4304: n_4967 <=  gnd;
inv_4305: n_4968  <= TRANSPORT NOT CLK  ;
filter_4306: FILTER_a16450

    PORT MAP (IN1 => n_4968, Y => a_N813_aCLK);
dff_4307: DFF_a16450

    PORT MAP ( D => a_N818_aD, CLK => a_N818_aCLK, CLRN => a_N818_aCLRN, PRN => vcc,
          Q => a_N818);
inv_4308: a_N818_aCLRN  <= TRANSPORT NOT MR  ;
xor2_4309: a_N818_aD <=  n_4977  XOR n_4980;
or1_4310: n_4977 <=  n_4978;
and1_4311: n_4978 <=  n_4979;
delay_4312: n_4979  <= TRANSPORT a_N813  ;
and1_4313: n_4980 <=  gnd;
inv_4314: n_4981  <= TRANSPORT NOT CLK  ;
filter_4315: FILTER_a16450

    PORT MAP (IN1 => n_4981, Y => a_N818_aCLK);
dff_4316: DFF_a16450

    PORT MAP ( D => a_EQ346, CLK => a_SMSTAT_DAT_F1_G_aCLK, CLRN => a_SMSTAT_DAT_F1_G_aCLRN,
          PRN => vcc, Q => a_SMSTAT_DAT_F1_G);
inv_4317: a_SMSTAT_DAT_F1_G_aCLRN  <= TRANSPORT NOT MR  ;
xor2_4318: a_EQ346 <=  n_4989  XOR n_5001;
or3_4319: n_4989 <=  n_4990  OR n_4993  OR n_4997;
and2_4320: n_4990 <=  n_4991  AND n_4992;
delay_4321: n_4991  <= TRANSPORT a_N786_aNOT  ;
delay_4322: n_4992  <= TRANSPORT a_SMSTAT_DAT_F1_G  ;
and3_4323: n_4993 <=  n_4994  AND n_4995  AND n_4996;
delay_4324: n_4994  <= TRANSPORT a_N786_aNOT  ;
delay_4325: n_4995  <= TRANSPORT a_N813  ;
inv_4326: n_4996  <= TRANSPORT NOT a_N818  ;
and3_4327: n_4997 <=  n_4998  AND n_4999  AND n_5000;
delay_4328: n_4998  <= TRANSPORT a_N786_aNOT  ;
inv_4329: n_4999  <= TRANSPORT NOT a_N813  ;
delay_4330: n_5000  <= TRANSPORT a_N818  ;
and1_4331: n_5001 <=  gnd;
delay_4332: n_5002  <= TRANSPORT CLK  ;
filter_4333: FILTER_a16450

    PORT MAP (IN1 => n_5002, Y => a_SMSTAT_DAT_F1_G_aCLK);
delay_4334: a_LC7_A7  <= TRANSPORT a_EQ107  ;
xor2_4335: a_EQ107 <=  n_5006  XOR n_5013;
or2_4336: n_5006 <=  n_5007  OR n_5010;
and2_4337: n_5007 <=  n_5008  AND n_5009;
delay_4338: n_5008  <= TRANSPORT a_N105  ;
delay_4339: n_5009  <= TRANSPORT a_N390  ;
and2_4340: n_5010 <=  n_5011  AND n_5012;
delay_4341: n_5011  <= TRANSPORT a_N103  ;
delay_4342: n_5012  <= TRANSPORT a_N375  ;
and1_4343: n_5013 <=  gnd;
delay_4344: a_LC6_A7  <= TRANSPORT a_EQ108  ;
xor2_4345: a_EQ108 <=  n_5016  XOR n_5022;
or2_4346: n_5016 <=  n_5017  OR n_5019;
and1_4347: n_5017 <=  n_5018;
delay_4348: n_5018  <= TRANSPORT a_LC7_A7  ;
and2_4349: n_5019 <=  n_5020  AND n_5021;
delay_4350: n_5020  <= TRANSPORT a_N106  ;
delay_4351: n_5021  <= TRANSPORT a_N394  ;
and1_4352: n_5022 <=  gnd;
delay_4353: a_LC5_A7  <= TRANSPORT a_EQ109  ;
xor2_4354: a_EQ109 <=  n_5025  XOR n_5031;
or2_4355: n_5025 <=  n_5026  OR n_5028;
and1_4356: n_5026 <=  n_5027;
delay_4357: n_5027  <= TRANSPORT a_LC6_A7  ;
and2_4358: n_5028 <=  n_5029  AND n_5030;
delay_4359: n_5029  <= TRANSPORT a_N104  ;
delay_4360: n_5030  <= TRANSPORT a_N393  ;
and1_4361: n_5031 <=  gnd;
delay_4362: a_N59  <= TRANSPORT a_EQ110  ;
xor2_4363: a_EQ110 <=  n_5033  XOR n_5039;
or2_4364: n_5033 <=  n_5034  OR n_5036;
and1_4365: n_5034 <=  n_5035;
delay_4366: n_5035  <= TRANSPORT a_LC5_A7  ;
and2_4367: n_5036 <=  n_5037  AND n_5038;
delay_4368: n_5037  <= TRANSPORT a_N107  ;
delay_4369: n_5038  <= TRANSPORT a_N319  ;
and1_4370: n_5039 <=  gnd;
dff_4371: DFF_a16450

    PORT MAP ( D => a_EQ354, CLK => a_SREC_DAT_F1_G_aCLK, CLRN => vcc, PRN => vcc,
          Q => a_SREC_DAT_F1_G);
xor2_4372: a_EQ354 <=  n_5045  XOR n_5052;
or2_4373: n_5045 <=  n_5046  OR n_5049;
and2_4374: n_5046 <=  n_5047  AND n_5048;
inv_4375: n_5047  <= TRANSPORT NOT a_N792_aNOT  ;
delay_4376: n_5048  <= TRANSPORT a_N59  ;
and2_4377: n_5049 <=  n_5050  AND n_5051;
delay_4378: n_5050  <= TRANSPORT a_N792_aNOT  ;
delay_4379: n_5051  <= TRANSPORT a_SREC_DAT_F1_G  ;
and1_4380: n_5052 <=  gnd;
delay_4381: n_5053  <= TRANSPORT RCLK  ;
filter_4382: FILTER_a16450

    PORT MAP (IN1 => n_5053, Y => a_SREC_DAT_F1_G_aCLK);
dff_4383: DFF_a16450

    PORT MAP ( D => a_EQ311, CLK => a_SDMSB_DAT_F1_G_aCLK, CLRN => a_SDMSB_DAT_F1_G_aCLRN,
          PRN => vcc, Q => a_SDMSB_DAT_F1_G);
inv_4384: a_SDMSB_DAT_F1_G_aCLRN  <= TRANSPORT NOT MR  ;
xor2_4385: a_EQ311 <=  n_5061  XOR n_5068;
or2_4386: n_5061 <=  n_5062  OR n_5065;
and2_4387: n_5062 <=  n_5063  AND n_5064;
delay_4388: n_5063  <= TRANSPORT a_N794_aNOT  ;
delay_4389: n_5064  <= TRANSPORT a_SDMSB_DAT_F1_G  ;
and2_4390: n_5065 <=  n_5066  AND n_5067;
inv_4391: n_5066  <= TRANSPORT NOT a_N794_aNOT  ;
delay_4392: n_5067  <= TRANSPORT DIN(1)  ;
and1_4393: n_5068 <=  gnd;
delay_4394: n_5069  <= TRANSPORT CLK  ;
filter_4395: FILTER_a16450

    PORT MAP (IN1 => n_5069, Y => a_SDMSB_DAT_F1_G_aCLK);
dff_4396: DFF_a16450

    PORT MAP ( D => a_EQ329, CLK => a_SLCNTL_DOUT_F2_G_aCLK, CLRN => a_SLCNTL_DOUT_F2_G_aCLRN,
          PRN => vcc, Q => a_SLCNTL_DOUT_F2_G);
inv_4397: a_SLCNTL_DOUT_F2_G_aCLRN  <= TRANSPORT NOT MR  ;
xor2_4398: a_EQ329 <=  n_5077  XOR n_5088;
or3_4399: n_5077 <=  n_5078  OR n_5082  OR n_5085;
and3_4400: n_5078 <=  n_5079  AND n_5080  AND n_5081;
delay_4401: n_5079  <= TRANSPORT a_N804  ;
delay_4402: n_5080  <= TRANSPORT a_N35  ;
delay_4403: n_5081  <= TRANSPORT DIN(2)  ;
and2_4404: n_5082 <=  n_5083  AND n_5084;
inv_4405: n_5083  <= TRANSPORT NOT a_N35  ;
delay_4406: n_5084  <= TRANSPORT a_SLCNTL_DOUT_F2_G  ;
and2_4407: n_5085 <=  n_5086  AND n_5087;
inv_4408: n_5086  <= TRANSPORT NOT a_N804  ;
delay_4409: n_5087  <= TRANSPORT a_SLCNTL_DOUT_F2_G  ;
and1_4410: n_5088 <=  gnd;
inv_4411: n_5089  <= TRANSPORT NOT CLK  ;
filter_4412: FILTER_a16450

    PORT MAP (IN1 => n_5089, Y => a_SLCNTL_DOUT_F2_G_aCLK);
delay_4413: a_LC4_A7  <= TRANSPORT a_EQ103  ;
xor2_4414: a_EQ103 <=  n_5093  XOR n_5100;
or2_4415: n_5093 <=  n_5094  OR n_5097;
and2_4416: n_5094 <=  n_5095  AND n_5096;
delay_4417: n_5095  <= TRANSPORT a_N105  ;
delay_4418: n_5096  <= TRANSPORT a_N394  ;
and2_4419: n_5097 <=  n_5098  AND n_5099;
delay_4420: n_5098  <= TRANSPORT a_N103  ;
delay_4421: n_5099  <= TRANSPORT a_N393  ;
and1_4422: n_5100 <=  gnd;
delay_4423: a_LC3_A7  <= TRANSPORT a_EQ104  ;
xor2_4424: a_EQ104 <=  n_5103  XOR n_5109;
or2_4425: n_5103 <=  n_5104  OR n_5106;
and1_4426: n_5104 <=  n_5105;
delay_4427: n_5105  <= TRANSPORT a_LC4_A7  ;
and2_4428: n_5106 <=  n_5107  AND n_5108;
delay_4429: n_5107  <= TRANSPORT a_N102  ;
delay_4430: n_5108  <= TRANSPORT a_N375  ;
and1_4431: n_5109 <=  gnd;
delay_4432: a_LC2_A7  <= TRANSPORT a_EQ105  ;
xor2_4433: a_EQ105 <=  n_5112  XOR n_5118;
or2_4434: n_5112 <=  n_5113  OR n_5115;
and1_4435: n_5113 <=  n_5114;
delay_4436: n_5114  <= TRANSPORT a_LC3_A7  ;
and2_4437: n_5115 <=  n_5116  AND n_5117;
delay_4438: n_5116  <= TRANSPORT a_N106  ;
delay_4439: n_5117  <= TRANSPORT a_N319  ;
and1_4440: n_5118 <=  gnd;
delay_4441: a_N58  <= TRANSPORT a_EQ106  ;
xor2_4442: a_EQ106 <=  n_5120  XOR n_5126;
or2_4443: n_5120 <=  n_5121  OR n_5123;
and1_4444: n_5121 <=  n_5122;
delay_4445: n_5122  <= TRANSPORT a_LC2_A7  ;
and2_4446: n_5123 <=  n_5124  AND n_5125;
delay_4447: n_5124  <= TRANSPORT a_N104  ;
delay_4448: n_5125  <= TRANSPORT a_N390  ;
and1_4449: n_5126 <=  gnd;
dff_4450: DFF_a16450

    PORT MAP ( D => a_EQ355, CLK => a_SREC_DAT_F2_G_aCLK, CLRN => vcc, PRN => vcc,
          Q => a_SREC_DAT_F2_G);
xor2_4451: a_EQ355 <=  n_5132  XOR n_5139;
or2_4452: n_5132 <=  n_5133  OR n_5136;
and2_4453: n_5133 <=  n_5134  AND n_5135;
inv_4454: n_5134  <= TRANSPORT NOT a_N792_aNOT  ;
delay_4455: n_5135  <= TRANSPORT a_N58  ;
and2_4456: n_5136 <=  n_5137  AND n_5138;
delay_4457: n_5137  <= TRANSPORT a_N792_aNOT  ;
delay_4458: n_5138  <= TRANSPORT a_SREC_DAT_F2_G  ;
and1_4459: n_5139 <=  gnd;
delay_4460: n_5140  <= TRANSPORT RCLK  ;
filter_4461: FILTER_a16450

    PORT MAP (IN1 => n_5140, Y => a_SREC_DAT_F2_G_aCLK);
dff_4462: DFF_a16450

    PORT MAP ( D => a_EQ312, CLK => a_SDMSB_DAT_F2_G_aCLK, CLRN => a_SDMSB_DAT_F2_G_aCLRN,
          PRN => vcc, Q => a_SDMSB_DAT_F2_G);
inv_4463: a_SDMSB_DAT_F2_G_aCLRN  <= TRANSPORT NOT MR  ;
xor2_4464: a_EQ312 <=  n_5148  XOR n_5155;
or2_4465: n_5148 <=  n_5149  OR n_5152;
and2_4466: n_5149 <=  n_5150  AND n_5151;
inv_4467: n_5150  <= TRANSPORT NOT a_N794_aNOT  ;
delay_4468: n_5151  <= TRANSPORT DIN(2)  ;
and2_4469: n_5152 <=  n_5153  AND n_5154;
delay_4470: n_5153  <= TRANSPORT a_N794_aNOT  ;
delay_4471: n_5154  <= TRANSPORT a_SDMSB_DAT_F2_G  ;
and1_4472: n_5155 <=  gnd;
delay_4473: n_5156  <= TRANSPORT CLK  ;
filter_4474: FILTER_a16450

    PORT MAP (IN1 => n_5156, Y => a_SDMSB_DAT_F2_G_aCLK);
delay_4475: a_LC8_A20  <= TRANSPORT a_EQ097  ;
xor2_4476: a_EQ097 <=  n_5160  XOR n_5167;
or2_4477: n_5160 <=  n_5161  OR n_5164;
and2_4478: n_5161 <=  n_5162  AND n_5163;
delay_4479: n_5162  <= TRANSPORT a_N105  ;
delay_4480: n_5163  <= TRANSPORT a_N319  ;
and2_4481: n_5164 <=  n_5165  AND n_5166;
delay_4482: n_5165  <= TRANSPORT a_N101  ;
delay_4483: n_5166  <= TRANSPORT a_N375  ;
and1_4484: n_5167 <=  gnd;
delay_4485: a_LC2_A13  <= TRANSPORT a_EQ098  ;
xor2_4486: a_EQ098 <=  n_5170  XOR n_5176;
or2_4487: n_5170 <=  n_5171  OR n_5173;
and1_4488: n_5171 <=  n_5172;
delay_4489: n_5172  <= TRANSPORT a_LC8_A20  ;
and2_4490: n_5173 <=  n_5174  AND n_5175;
delay_4491: n_5174  <= TRANSPORT a_N102  ;
delay_4492: n_5175  <= TRANSPORT a_N393  ;
and1_4493: n_5176 <=  gnd;
delay_4494: a_LC1_A13  <= TRANSPORT a_EQ099  ;
xor2_4495: a_EQ099 <=  n_5179  XOR n_5185;
or2_4496: n_5179 <=  n_5180  OR n_5182;
and1_4497: n_5180 <=  n_5181;
delay_4498: n_5181  <= TRANSPORT a_LC2_A13  ;
and2_4499: n_5182 <=  n_5183  AND n_5184;
delay_4500: n_5183  <= TRANSPORT a_N103  ;
delay_4501: n_5184  <= TRANSPORT a_N390  ;
and1_4502: n_5185 <=  gnd;
delay_4503: a_N55  <= TRANSPORT a_EQ100  ;
xor2_4504: a_EQ100 <=  n_5187  XOR n_5193;
or2_4505: n_5187 <=  n_5188  OR n_5190;
and1_4506: n_5188 <=  n_5189;
delay_4507: n_5189  <= TRANSPORT a_LC1_A13  ;
and2_4508: n_5190 <=  n_5191  AND n_5192;
delay_4509: n_5191  <= TRANSPORT a_N104  ;
delay_4510: n_5192  <= TRANSPORT a_N394  ;
and1_4511: n_5193 <=  gnd;
dff_4512: DFF_a16450

    PORT MAP ( D => a_EQ356, CLK => a_SREC_DAT_F3_G_aCLK, CLRN => vcc, PRN => vcc,
          Q => a_SREC_DAT_F3_G);
xor2_4513: a_EQ356 <=  n_5199  XOR n_5206;
or2_4514: n_5199 <=  n_5200  OR n_5203;
and2_4515: n_5200 <=  n_5201  AND n_5202;
inv_4516: n_5201  <= TRANSPORT NOT a_N792_aNOT  ;
delay_4517: n_5202  <= TRANSPORT a_N55  ;
and2_4518: n_5203 <=  n_5204  AND n_5205;
delay_4519: n_5204  <= TRANSPORT a_N792_aNOT  ;
delay_4520: n_5205  <= TRANSPORT a_SREC_DAT_F3_G  ;
and1_4521: n_5206 <=  gnd;
delay_4522: n_5207  <= TRANSPORT RCLK  ;
filter_4523: FILTER_a16450

    PORT MAP (IN1 => n_5207, Y => a_SREC_DAT_F3_G_aCLK);
dff_4524: DFF_a16450

    PORT MAP ( D => a_EQ313, CLK => a_SDMSB_DAT_F3_G_aCLK, CLRN => a_SDMSB_DAT_F3_G_aCLRN,
          PRN => vcc, Q => a_SDMSB_DAT_F3_G);
inv_4525: a_SDMSB_DAT_F3_G_aCLRN  <= TRANSPORT NOT MR  ;
xor2_4526: a_EQ313 <=  n_5215  XOR n_5226;
or3_4527: n_5215 <=  n_5216  OR n_5220  OR n_5223;
and3_4528: n_5216 <=  n_5217  AND n_5218  AND n_5219;
delay_4529: n_5217  <= TRANSPORT a_N804  ;
inv_4530: n_5218  <= TRANSPORT NOT a_LC1_B18  ;
delay_4531: n_5219  <= TRANSPORT DIN(3)  ;
and2_4532: n_5220 <=  n_5221  AND n_5222;
delay_4533: n_5221  <= TRANSPORT a_LC1_B18  ;
delay_4534: n_5222  <= TRANSPORT a_SDMSB_DAT_F3_G  ;
and2_4535: n_5223 <=  n_5224  AND n_5225;
inv_4536: n_5224  <= TRANSPORT NOT a_N804  ;
delay_4537: n_5225  <= TRANSPORT a_SDMSB_DAT_F3_G  ;
and1_4538: n_5226 <=  gnd;
delay_4539: n_5227  <= TRANSPORT CLK  ;
filter_4540: FILTER_a16450

    PORT MAP (IN1 => n_5227, Y => a_SDMSB_DAT_F3_G_aCLK);
dff_4541: DFF_a16450

    PORT MAP ( D => a_EQ314, CLK => a_SDMSB_DAT_F4_G_aCLK, CLRN => a_SDMSB_DAT_F4_G_aCLRN,
          PRN => vcc, Q => a_SDMSB_DAT_F4_G);
inv_4542: a_SDMSB_DAT_F4_G_aCLRN  <= TRANSPORT NOT MR  ;
xor2_4543: a_EQ314 <=  n_5235  XOR n_5246;
or3_4544: n_5235 <=  n_5236  OR n_5239  OR n_5242;
and2_4545: n_5236 <=  n_5237  AND n_5238;
delay_4546: n_5237  <= TRANSPORT a_LC1_B18  ;
delay_4547: n_5238  <= TRANSPORT a_SDMSB_DAT_F4_G  ;
and2_4548: n_5239 <=  n_5240  AND n_5241;
inv_4549: n_5240  <= TRANSPORT NOT a_N804  ;
delay_4550: n_5241  <= TRANSPORT a_SDMSB_DAT_F4_G  ;
and3_4551: n_5242 <=  n_5243  AND n_5244  AND n_5245;
delay_4552: n_5243  <= TRANSPORT a_N804  ;
inv_4553: n_5244  <= TRANSPORT NOT a_LC1_B18  ;
delay_4554: n_5245  <= TRANSPORT DIN(4)  ;
and1_4555: n_5246 <=  gnd;
delay_4556: n_5247  <= TRANSPORT CLK  ;
filter_4557: FILTER_a16450

    PORT MAP (IN1 => n_5247, Y => a_SDMSB_DAT_F4_G_aCLK);
dff_4558: DFF_a16450

    PORT MAP ( D => a_EQ315, CLK => a_SDMSB_DAT_F5_G_aCLK, CLRN => a_SDMSB_DAT_F5_G_aCLRN,
          PRN => vcc, Q => a_SDMSB_DAT_F5_G);
inv_4559: a_SDMSB_DAT_F5_G_aCLRN  <= TRANSPORT NOT MR  ;
xor2_4560: a_EQ315 <=  n_5255  XOR n_5266;
or3_4561: n_5255 <=  n_5256  OR n_5259  OR n_5262;
and2_4562: n_5256 <=  n_5257  AND n_5258;
delay_4563: n_5257  <= TRANSPORT a_LC1_B18  ;
delay_4564: n_5258  <= TRANSPORT a_SDMSB_DAT_F5_G  ;
and2_4565: n_5259 <=  n_5260  AND n_5261;
inv_4566: n_5260  <= TRANSPORT NOT a_N804  ;
delay_4567: n_5261  <= TRANSPORT a_SDMSB_DAT_F5_G  ;
and3_4568: n_5262 <=  n_5263  AND n_5264  AND n_5265;
delay_4569: n_5263  <= TRANSPORT a_N804  ;
inv_4570: n_5264  <= TRANSPORT NOT a_LC1_B18  ;
delay_4571: n_5265  <= TRANSPORT DIN(5)  ;
and1_4572: n_5266 <=  gnd;
delay_4573: n_5267  <= TRANSPORT CLK  ;
filter_4574: FILTER_a16450

    PORT MAP (IN1 => n_5267, Y => a_SDMSB_DAT_F5_G_aCLK);
dff_4575: DFF_a16450

    PORT MAP ( D => a_EQ282, CLK => a_N1315_aCLK, CLRN => a_N1315_aCLRN, PRN => vcc,
          Q => a_N1315);
inv_4576: a_N1315_aCLRN  <= TRANSPORT NOT MR  ;
xor2_4577: a_EQ282 <=  n_5275  XOR n_5286;
or3_4578: n_5275 <=  n_5276  OR n_5279  OR n_5282;
and2_4579: n_5276 <=  n_5277  AND n_5278;
inv_4580: n_5277  <= TRANSPORT NOT a_N32  ;
delay_4581: n_5278  <= TRANSPORT a_N1315  ;
and2_4582: n_5279 <=  n_5280  AND n_5281;
inv_4583: n_5280  <= TRANSPORT NOT a_N804  ;
delay_4584: n_5281  <= TRANSPORT a_N1315  ;
and3_4585: n_5282 <=  n_5283  AND n_5284  AND n_5285;
delay_4586: n_5283  <= TRANSPORT a_N804  ;
delay_4587: n_5284  <= TRANSPORT a_N32  ;
delay_4588: n_5285  <= TRANSPORT DIN(5)  ;
and1_4589: n_5286 <=  gnd;
inv_4590: n_5287  <= TRANSPORT NOT CLK  ;
filter_4591: FILTER_a16450

    PORT MAP (IN1 => n_5287, Y => a_N1315_aCLK);
dff_4592: DFF_a16450

    PORT MAP ( D => a_EQ334, CLK => a_SLCNTL_DOUT_F7_G_aCLK, CLRN => a_SLCNTL_DOUT_F7_G_aCLRN,
          PRN => vcc, Q => a_SLCNTL_DOUT_F7_G);
inv_4593: a_SLCNTL_DOUT_F7_G_aCLRN  <= TRANSPORT NOT MR  ;
xor2_4594: a_EQ334 <=  n_5295  XOR n_5306;
or3_4595: n_5295 <=  n_5296  OR n_5299  OR n_5302;
and2_4596: n_5296 <=  n_5297  AND n_5298;
inv_4597: n_5297  <= TRANSPORT NOT a_N35  ;
delay_4598: n_5298  <= TRANSPORT a_SLCNTL_DOUT_F7_G  ;
and2_4599: n_5299 <=  n_5300  AND n_5301;
inv_4600: n_5300  <= TRANSPORT NOT a_N804  ;
delay_4601: n_5301  <= TRANSPORT a_SLCNTL_DOUT_F7_G  ;
and3_4602: n_5302 <=  n_5303  AND n_5304  AND n_5305;
delay_4603: n_5303  <= TRANSPORT a_N804  ;
delay_4604: n_5304  <= TRANSPORT a_N35  ;
delay_4605: n_5305  <= TRANSPORT DIN(7)  ;
and1_4606: n_5306 <=  gnd;
inv_4607: n_5307  <= TRANSPORT NOT CLK  ;
filter_4608: FILTER_a16450

    PORT MAP (IN1 => n_5307, Y => a_SLCNTL_DOUT_F7_G_aCLK);
dff_4609: DFF_a16450

    PORT MAP ( D => a_EQ317, CLK => a_SDMSB_DAT_F7_G_aCLK, CLRN => a_SDMSB_DAT_F7_G_aCLRN,
          PRN => vcc, Q => a_SDMSB_DAT_F7_G);
inv_4610: a_SDMSB_DAT_F7_G_aCLRN  <= TRANSPORT NOT MR  ;
xor2_4611: a_EQ317 <=  n_5315  XOR n_5326;
or3_4612: n_5315 <=  n_5316  OR n_5319  OR n_5322;
and2_4613: n_5316 <=  n_5317  AND n_5318;
delay_4614: n_5317  <= TRANSPORT a_LC1_B18  ;
delay_4615: n_5318  <= TRANSPORT a_SDMSB_DAT_F7_G  ;
and2_4616: n_5319 <=  n_5320  AND n_5321;
inv_4617: n_5320  <= TRANSPORT NOT a_N804  ;
delay_4618: n_5321  <= TRANSPORT a_SDMSB_DAT_F7_G  ;
and3_4619: n_5322 <=  n_5323  AND n_5324  AND n_5325;
delay_4620: n_5323  <= TRANSPORT a_N804  ;
inv_4621: n_5324  <= TRANSPORT NOT a_LC1_B18  ;
delay_4622: n_5325  <= TRANSPORT DIN(7)  ;
and1_4623: n_5326 <=  gnd;
delay_4624: n_5327  <= TRANSPORT CLK  ;
filter_4625: FILTER_a16450

    PORT MAP (IN1 => n_5327, Y => a_SDMSB_DAT_F7_G_aCLK);
delay_4626: a_LC5_A14  <= TRANSPORT a_EQ161  ;
xor2_4627: a_EQ161 <=  n_5331  XOR n_5348;
or4_4628: n_5331 <=  n_5332  OR n_5336  OR n_5340  OR n_5344;
and3_4629: n_5332 <=  n_5333  AND n_5334  AND n_5335;
delay_4630: n_5333  <= TRANSPORT a_N1355  ;
inv_4631: n_5334  <= TRANSPORT NOT a_N1356  ;
delay_4632: n_5335  <= TRANSPORT a_N1361  ;
and3_4633: n_5336 <=  n_5337  AND n_5338  AND n_5339;
inv_4634: n_5337  <= TRANSPORT NOT a_N1355  ;
delay_4635: n_5338  <= TRANSPORT a_N1356  ;
delay_4636: n_5339  <= TRANSPORT a_N1361  ;
and3_4637: n_5340 <=  n_5341  AND n_5342  AND n_5343;
inv_4638: n_5341  <= TRANSPORT NOT a_N1355  ;
inv_4639: n_5342  <= TRANSPORT NOT a_N1356  ;
inv_4640: n_5343  <= TRANSPORT NOT a_N1361  ;
and3_4641: n_5344 <=  n_5345  AND n_5346  AND n_5347;
delay_4642: n_5345  <= TRANSPORT a_N1355  ;
delay_4643: n_5346  <= TRANSPORT a_N1356  ;
inv_4644: n_5347  <= TRANSPORT NOT a_N1361  ;
and1_4645: n_5348 <=  gnd;
delay_4646: a_LC7_A1  <= TRANSPORT a_EQ162  ;
xor2_4647: a_EQ162 <=  n_5351  XOR n_5368;
or4_4648: n_5351 <=  n_5352  OR n_5356  OR n_5360  OR n_5364;
and3_4649: n_5352 <=  n_5353  AND n_5354  AND n_5355;
inv_4650: n_5353  <= TRANSPORT NOT a_N1358  ;
inv_4651: n_5354  <= TRANSPORT NOT a_N1357  ;
delay_4652: n_5355  <= TRANSPORT a_N1359  ;
and3_4653: n_5356 <=  n_5357  AND n_5358  AND n_5359;
delay_4654: n_5357  <= TRANSPORT a_N1358  ;
delay_4655: n_5358  <= TRANSPORT a_N1357  ;
delay_4656: n_5359  <= TRANSPORT a_N1359  ;
and3_4657: n_5360 <=  n_5361  AND n_5362  AND n_5363;
delay_4658: n_5361  <= TRANSPORT a_N1358  ;
inv_4659: n_5362  <= TRANSPORT NOT a_N1357  ;
inv_4660: n_5363  <= TRANSPORT NOT a_N1359  ;
and3_4661: n_5364 <=  n_5365  AND n_5366  AND n_5367;
inv_4662: n_5365  <= TRANSPORT NOT a_N1358  ;
delay_4663: n_5366  <= TRANSPORT a_N1357  ;
inv_4664: n_5367  <= TRANSPORT NOT a_N1359  ;
and1_4665: n_5368 <=  gnd;
delay_4666: a_N296  <= TRANSPORT a_EQ163  ;
xor2_4667: a_EQ163 <=  n_5371  XOR n_5412;
or8_4668: n_5371 <=  n_5372  OR n_5377  OR n_5382  OR n_5387  OR n_5392  OR n_5397
           OR n_5402  OR n_5407;
and4_4669: n_5372 <=  n_5373  AND n_5374  AND n_5375  AND n_5376;
delay_4670: n_5373  <= TRANSPORT a_N1360  ;
inv_4671: n_5374  <= TRANSPORT NOT a_N1362  ;
delay_4672: n_5375  <= TRANSPORT a_LC5_A14  ;
inv_4673: n_5376  <= TRANSPORT NOT a_LC7_A1  ;
and4_4674: n_5377 <=  n_5378  AND n_5379  AND n_5380  AND n_5381;
inv_4675: n_5378  <= TRANSPORT NOT a_N1360  ;
delay_4676: n_5379  <= TRANSPORT a_N1362  ;
delay_4677: n_5380  <= TRANSPORT a_LC5_A14  ;
inv_4678: n_5381  <= TRANSPORT NOT a_LC7_A1  ;
and4_4679: n_5382 <=  n_5383  AND n_5384  AND n_5385  AND n_5386;
inv_4680: n_5383  <= TRANSPORT NOT a_N1360  ;
inv_4681: n_5384  <= TRANSPORT NOT a_N1362  ;
inv_4682: n_5385  <= TRANSPORT NOT a_LC5_A14  ;
inv_4683: n_5386  <= TRANSPORT NOT a_LC7_A1  ;
and4_4684: n_5387 <=  n_5388  AND n_5389  AND n_5390  AND n_5391;
delay_4685: n_5388  <= TRANSPORT a_N1360  ;
delay_4686: n_5389  <= TRANSPORT a_N1362  ;
inv_4687: n_5390  <= TRANSPORT NOT a_LC5_A14  ;
inv_4688: n_5391  <= TRANSPORT NOT a_LC7_A1  ;
and4_4689: n_5392 <=  n_5393  AND n_5394  AND n_5395  AND n_5396;
inv_4690: n_5393  <= TRANSPORT NOT a_N1360  ;
inv_4691: n_5394  <= TRANSPORT NOT a_N1362  ;
delay_4692: n_5395  <= TRANSPORT a_LC5_A14  ;
delay_4693: n_5396  <= TRANSPORT a_LC7_A1  ;
and4_4694: n_5397 <=  n_5398  AND n_5399  AND n_5400  AND n_5401;
delay_4695: n_5398  <= TRANSPORT a_N1360  ;
delay_4696: n_5399  <= TRANSPORT a_N1362  ;
delay_4697: n_5400  <= TRANSPORT a_LC5_A14  ;
delay_4698: n_5401  <= TRANSPORT a_LC7_A1  ;
and4_4699: n_5402 <=  n_5403  AND n_5404  AND n_5405  AND n_5406;
delay_4700: n_5403  <= TRANSPORT a_N1360  ;
inv_4701: n_5404  <= TRANSPORT NOT a_N1362  ;
inv_4702: n_5405  <= TRANSPORT NOT a_LC5_A14  ;
delay_4703: n_5406  <= TRANSPORT a_LC7_A1  ;
and4_4704: n_5407 <=  n_5408  AND n_5409  AND n_5410  AND n_5411;
inv_4705: n_5408  <= TRANSPORT NOT a_N1360  ;
delay_4706: n_5409  <= TRANSPORT a_N1362  ;
inv_4707: n_5410  <= TRANSPORT NOT a_LC5_A14  ;
delay_4708: n_5411  <= TRANSPORT a_LC7_A1  ;
and1_4709: n_5412 <=  gnd;
delay_4710: a_LC4_A4  <= TRANSPORT a_EQ160  ;
xor2_4711: a_EQ160 <=  n_5415  XOR n_5423;
or2_4712: n_5415 <=  n_5416  OR n_5420;
and3_4713: n_5416 <=  n_5417  AND n_5418  AND n_5419;
inv_4714: n_5417  <= TRANSPORT NOT a_N18  ;
delay_4715: n_5418  <= TRANSPORT a_N296  ;
delay_4716: n_5419  <= TRANSPORT a_SLCNTL_DOUT_F4_G  ;
and2_4717: n_5420 <=  n_5421  AND n_5422;
delay_4718: n_5421  <= TRANSPORT a_N18  ;
delay_4719: n_5422  <= TRANSPORT a_N1353  ;
and1_4720: n_5423 <=  gnd;
delay_4721: a_LC1_A4  <= TRANSPORT a_LC1_A4_aIN  ;
xor2_4722: a_LC1_A4_aIN <=  n_5426  XOR n_5430;
or1_4723: n_5426 <=  n_5427;
and2_4724: n_5427 <=  n_5428  AND n_5429;
inv_4725: n_5428  <= TRANSPORT NOT a_N18  ;
inv_4726: n_5429  <= TRANSPORT NOT a_N296  ;
and1_4727: n_5430 <=  gnd;
dff_4728: DFF_a16450

    PORT MAP ( D => a_EQ289, CLK => a_N1353_aCLK, CLRN => a_N1353_aCLRN, PRN => vcc,
          Q => a_N1353);
inv_4729: a_N1353_aCLRN  <= TRANSPORT NOT MR  ;
xor2_4730: a_EQ289 <=  n_5437  XOR n_5447;
or3_4731: n_5437 <=  n_5438  OR n_5441  OR n_5444;
and2_4732: n_5438 <=  n_5439  AND n_5440;
delay_4733: n_5439  <= TRANSPORT a_LC4_A4  ;
inv_4734: n_5440  <= TRANSPORT NOT a_SLCNTL_DOUT_F5_G  ;
and2_4735: n_5441 <=  n_5442  AND n_5443;
inv_4736: n_5442  <= TRANSPORT NOT a_SLCNTL_DOUT_F4_G  ;
delay_4737: n_5443  <= TRANSPORT a_SLCNTL_DOUT_F5_G  ;
and2_4738: n_5444 <=  n_5445  AND n_5446;
delay_4739: n_5445  <= TRANSPORT a_LC1_A4  ;
inv_4740: n_5446  <= TRANSPORT NOT a_SLCNTL_DOUT_F4_G  ;
and1_4741: n_5447 <=  gnd;
delay_4742: n_5448  <= TRANSPORT CLK  ;
filter_4743: FILTER_a16450

    PORT MAP (IN1 => n_5448, Y => a_N1353_aCLK);
dff_4744: DFF_a16450

    PORT MAP ( D => a_EQ333, CLK => a_SLCNTL_DOUT_F6_G_aCLK, CLRN => a_SLCNTL_DOUT_F6_G_aCLRN,
          PRN => vcc, Q => a_SLCNTL_DOUT_F6_G);
inv_4745: a_SLCNTL_DOUT_F6_G_aCLRN  <= TRANSPORT NOT MR  ;
xor2_4746: a_EQ333 <=  n_5456  XOR n_5467;
or3_4747: n_5456 <=  n_5457  OR n_5460  OR n_5463;
and2_4748: n_5457 <=  n_5458  AND n_5459;
inv_4749: n_5458  <= TRANSPORT NOT a_N35  ;
delay_4750: n_5459  <= TRANSPORT a_SLCNTL_DOUT_F6_G  ;
and2_4751: n_5460 <=  n_5461  AND n_5462;
inv_4752: n_5461  <= TRANSPORT NOT a_N804  ;
delay_4753: n_5462  <= TRANSPORT a_SLCNTL_DOUT_F6_G  ;
and3_4754: n_5463 <=  n_5464  AND n_5465  AND n_5466;
delay_4755: n_5464  <= TRANSPORT a_N804  ;
delay_4756: n_5465  <= TRANSPORT a_N35  ;
delay_4757: n_5466  <= TRANSPORT DIN(6)  ;
and1_4758: n_5467 <=  gnd;
inv_4759: n_5468  <= TRANSPORT NOT CLK  ;
filter_4760: FILTER_a16450

    PORT MAP (IN1 => n_5468, Y => a_SLCNTL_DOUT_F6_G_aCLK);
delay_4761: a_N796_aNOT  <= TRANSPORT a_EQ239  ;
xor2_4762: a_EQ239 <=  n_5471  XOR n_5478;
or3_4763: n_5471 <=  n_5472  OR n_5474  OR n_5476;
and1_4764: n_5472 <=  n_5473;
delay_4765: n_5473  <= TRANSPORT a_SLCNTL_DOUT_F7_G  ;
and1_4766: n_5474 <=  n_5475;
inv_4767: n_5475  <= TRANSPORT NOT a_N804  ;
and1_4768: n_5476 <=  n_5477;
delay_4769: n_5477  <= TRANSPORT a_N34_aNOT  ;
and1_4770: n_5478 <=  gnd;
dff_4771: DFF_a16450

    PORT MAP ( D => a_EQ321, CLK => a_SINTEN_DAT_F3_G_aCLK, CLRN => a_SINTEN_DAT_F3_G_aCLRN,
          PRN => vcc, Q => a_SINTEN_DAT_F3_G);
inv_4772: a_SINTEN_DAT_F3_G_aCLRN  <= TRANSPORT NOT MR  ;
xor2_4773: a_EQ321 <=  n_5485  XOR n_5492;
or2_4774: n_5485 <=  n_5486  OR n_5489;
and2_4775: n_5486 <=  n_5487  AND n_5488;
inv_4776: n_5487  <= TRANSPORT NOT a_N796_aNOT  ;
delay_4777: n_5488  <= TRANSPORT DIN(3)  ;
and2_4778: n_5489 <=  n_5490  AND n_5491;
delay_4779: n_5490  <= TRANSPORT a_N796_aNOT  ;
delay_4780: n_5491  <= TRANSPORT a_SINTEN_DAT_F3_G  ;
and1_4781: n_5492 <=  gnd;
delay_4782: n_5493  <= TRANSPORT CLK  ;
filter_4783: FILTER_a16450

    PORT MAP (IN1 => n_5493, Y => a_SINTEN_DAT_F3_G_aCLK);
dff_4784: DFF_a16450

    PORT MAP ( D => a_EQ319, CLK => a_SINTEN_DAT_F1_G_aCLK, CLRN => a_SINTEN_DAT_F1_G_aCLRN,
          PRN => vcc, Q => a_SINTEN_DAT_F1_G);
inv_4785: a_SINTEN_DAT_F1_G_aCLRN  <= TRANSPORT NOT MR  ;
xor2_4786: a_EQ319 <=  n_5501  XOR n_5508;
or2_4787: n_5501 <=  n_5502  OR n_5505;
and2_4788: n_5502 <=  n_5503  AND n_5504;
inv_4789: n_5503  <= TRANSPORT NOT a_N796_aNOT  ;
delay_4790: n_5504  <= TRANSPORT DIN(1)  ;
and2_4791: n_5505 <=  n_5506  AND n_5507;
delay_4792: n_5506  <= TRANSPORT a_N796_aNOT  ;
delay_4793: n_5507  <= TRANSPORT a_SINTEN_DAT_F1_G  ;
and1_4794: n_5508 <=  gnd;
delay_4795: n_5509  <= TRANSPORT CLK  ;
filter_4796: FILTER_a16450

    PORT MAP (IN1 => n_5509, Y => a_SINTEN_DAT_F1_G_aCLK);
delay_4797: a_LC1_A19  <= TRANSPORT a_EQ124  ;
xor2_4798: a_EQ124 <=  n_5512  XOR n_5519;
or2_4799: n_5512 <=  n_5513  OR n_5516;
and2_4800: n_5513 <=  n_5514  AND n_5515;
inv_4801: n_5514  <= TRANSPORT NOT a_N9  ;
delay_4802: n_5515  <= TRANSPORT a_N10  ;
and2_4803: n_5516 <=  n_5517  AND n_5518;
delay_4804: n_5517  <= TRANSPORT a_N8  ;
delay_4805: n_5518  <= TRANSPORT a_N10  ;
and1_4806: n_5519 <=  gnd;
dff_4807: DFF_a16450

    PORT MAP ( D => a_N5_aD, CLK => a_N5_aCLK, CLRN => a_N5_aCLRN, PRN => vcc,
          Q => a_N5);
inv_4808: a_N5_aCLRN  <= TRANSPORT NOT MR  ;
xor2_4809: a_N5_aD <=  n_5526  XOR n_5529;
or1_4810: n_5526 <=  n_5527;
and1_4811: n_5527 <=  n_5528;
inv_4812: n_5528  <= TRANSPORT NOT a_SLSTAT_DAT_F5_G_aNOT  ;
and1_4813: n_5529 <=  gnd;
inv_4814: n_5530  <= TRANSPORT NOT CLK  ;
filter_4815: FILTER_a16450

    PORT MAP (IN1 => n_5530, Y => a_N5_aCLK);

END Version_1_0;
