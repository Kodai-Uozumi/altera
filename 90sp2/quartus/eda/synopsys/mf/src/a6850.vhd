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

ENTITY TRIBUF_a6850 IS
    PORT (
        in1 : IN std_logic;
        oe  : IN std_logic;
        y   : OUT std_logic);
END TRIBUF_a6850;

ARCHITECTURE behavior OF TRIBUF_a6850 IS
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

ENTITY DFF_a6850 IS
    PORT (
      	 d   : IN std_logic;
      	 clk : IN std_logic;
      	 clrn: IN std_logic;
      	 prn : IN std_logic;
      	 q   : OUT std_logic := '0');
END DFF_a6850;

ARCHITECTURE behavior OF DFF_a6850 IS
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

ENTITY FILTER_a6850 IS
    PORT (
        in1 : IN std_logic;
        y: OUT std_logic);
END FILTER_a6850;

ARCHITECTURE behavior OF FILTER_a6850 IS
BEGIN

    y <= in1;
END behavior;

LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE work.tribuf_a6850;
USE work.dff_a6850;
USE work.filter_a6850;

ENTITY a6850 IS
    PORT (
      CS : IN std_logic_vector(2 downto 0);
      DI : IN std_logic_vector(7 downto 0);
      DO : OUT std_logic_vector(7 downto 0);
      E : IN std_logic;
      nCTS : IN std_logic;
      nDCD : IN std_logic;
      nRESET : IN std_logic;
      RnW : IN std_logic;
      RS : IN std_logic;
      RXCLK : IN std_logic;
      RXDATA : IN std_logic;
      TXCLK : IN std_logic;
      nIRQ : OUT std_logic;
      nRTS : OUT std_logic;
      TXDATA : OUT std_logic);
END a6850;

ARCHITECTURE Version_1_0 OF a6850 IS

SIGNAL gnd : std_logic := '0';
SIGNAL vcc : std_logic := '1';
SIGNAL
    n_58, n_59, n_60, n_61, n_62, a_G57, n_64, n_65, n_66, n_67, n_68, n_69,
          a_G211, n_71, n_72, n_73, n_74, n_75, n_76, a_G345, n_78, n_79,
          n_80, n_81, n_82, n_83, a_G207, n_85, n_86, n_87, n_88, n_89, n_90,
          a_G54, n_92, n_93, n_94, n_95, n_96, n_97, a_G209, n_99, n_100,
          n_101, n_102, n_103, n_104, a_G76, n_106, n_107, n_108, n_109, n_110,
          n_111, a_G266, n_113, n_114, n_115, n_116, n_117, n_118, a_STXDATA,
          n_120, n_121, n_122, n_123, n_124, n_125, a_SRTS, n_127, n_128,
          n_129, n_130, n_131, n_132, a_SIRQ_N_aNOT, n_134, a_SINT_DI_F0_G,
          a_SINT_DI_F0_G_aCLRN, a_EQ200, n_143, n_144, n_145, n_146, n_148,
          n_149, n_151, n_152, n_153, a_SINT_DI_F0_G_aCLK, a_SINT_DI_F7_G,
          a_SINT_DI_F7_G_aCLRN, a_EQ207, n_167, n_168, n_169, n_170, n_171,
          n_172, n_173, n_174, n_175, a_SINT_DI_F7_G_aCLK, a_LC6_A12, a_EQ018,
          n_180, n_181, n_182, a_STX_REG_DATA_F6_G, n_184, a_STX_REG_DATA_F5_G,
          n_186, a_STX_REG_DATA_F3_G, n_188, a_STX_REG_DATA_F4_G, n_190, n_191,
          n_192, n_193, n_194, n_195, n_196, n_197, n_198, n_199, n_200, n_201,
          n_202, n_203, n_204, n_205, n_206, n_207, n_208, n_209, n_210, n_211,
          n_212, n_213, n_214, n_215, n_216, n_217, n_218, n_219, n_220, n_221,
          n_222, n_223, n_224, n_225, a_LC2_A2, a_EQ019, n_228, n_229, n_230,
          a_STX_REG_DATA_F2_G, n_232, a_STX_REG_DATA_F0_G, n_234, a_STX_REG_DATA_F1_G,
          n_236, n_237, n_238, n_239, n_240, n_241, n_242, n_243, n_244, n_245,
          n_246, n_247, n_248, n_249, n_250, n_251, n_252, n_253, n_254, n_255,
          n_256, n_257, n_258, n_259, n_260, n_261, n_262, n_263, n_264, n_265,
          n_266, n_267, n_268, n_269, n_270, n_271, n_272, a_LC3_A16, a_EQ017,
          n_275, n_276, n_277, a_N892, n_279, a_STX_REG_DATA_F7_G, n_281,
          word_lngth, n_283, n_284, a_N893, n_286, n_287, n_288, n_289, n_290,
          n_291, n_292, n_293, n_294, n_295, a_N1015, a_N1015_aCLRN, a_EQ198,
          n_303, n_304, n_305, a_N597, n_307, n_308, n_309, n_310, n_311,
          n_312, n_313, n_314, n_315, n_316, n_317, a_N1015_aCLK, a_LC4_A13,
          a_EQ076, n_321, n_322, n_323, a_N221, n_325, a_N222, n_327, n_328,
          a_N606_aNOT, n_330, n_331, a_N226_aNOT, a_EQ081, n_334, n_335, n_336,
          a_N640_aNOT, n_338, a_N591, n_340, n_341, a_N587_aNOT, n_343, n_344,
          n_345, a_N632, a_N632_aIN, n_348, n_349, n_350, n_351, a_N219, n_353,
          n_354, n_355, a_N221_aCLRN, a_EQ077, n_362, n_363, n_364, a_N627_aNOT,
          n_366, n_367, n_368, n_369, n_370, n_371, n_372, a_N221_aCLK, a_N229,
          a_N229_aIN, n_376, n_377, n_378, n_379, n_380, n_381, a_N218_aNOT,
          a_EQ074, n_384, n_385, n_386, n_387, n_388, n_389, n_390, n_391,
          n_392, n_393, a_LC2_A17, a_EQ079, n_396, n_397, n_398, n_399, n_400,
          n_401, n_402, a_SSTS_REG_F1_G_aNOT, n_404, n_405, n_406, a_N593,
          n_408, n_409, a_LC4_A17, a_EQ080, n_412, n_413, n_414, n_415, n_416,
          a_N604, n_418, n_419, n_420, a_N633, n_422, a_N222_aCLRN, a_EQ078,
          n_429, n_430, n_431, n_432, n_433, n_434, n_435, n_436, n_437, a_N222_aCLK,
          a_N894, a_N894_aCLRN, a_EQ192, n_446, n_447, n_448, n_449, a_N951,
          n_451, n_452, n_453, a_N949, n_455, n_456, a_SINT_DI_F1_G, n_458,
          n_459, n_460, n_461, a_N894_aCLK, a_N895, a_N895_aCLRN, a_EQ193,
          n_471, n_472, n_473, n_474, n_475, n_476, n_477, n_478, n_479, n_480,
          n_481, n_482, n_483, a_N895_aCLK, rx_irq_en, rx_irq_en_aCLRN, a_EQ001,
          n_492, n_493, n_494, n_495, n_496, n_497, n_498, n_499, n_500, n_501,
          n_502, n_503, n_504, rx_irq_en_aCLK, a_SINT_DI_F6_G, a_SINT_DI_F6_G_aCLRN,
          a_EQ206, n_514, n_515, n_516, n_517, n_518, n_519, n_520, n_521,
          n_522, a_SINT_DI_F6_G_aCLK, a_N951_aCLRN, a_N951_aD, n_530, n_531,
          n_532, a_LC7_A21, n_534, n_535, n_537, n_538, a_N951_aCLK, a_N949_aCLRN,
          a_N949_aD, n_546, n_547, n_548, n_549, n_550, a_N949_aCLK, a_SINT_DI_F5_G,
          a_SINT_DI_F5_G_aCLRN, a_EQ205, n_560, n_561, n_562, n_563, n_564,
          n_565, n_566, n_567, n_568, a_SINT_DI_F5_G_aCLK, a_LC7_B16, a_EQ085,
          n_572, n_573, n_574, a_N498, n_576, a_N499, n_578, n_579, n_580,
          n_581, n_582, n_583, n_584, a_N497, n_586, a_N260_aNOT, a_EQ086,
          n_589, n_590, n_591, a_N261_aNOT, n_593, n_594, n_595, a_N495, n_597,
          n_598, a_N315, a_EQ096, n_601, n_602, n_603, n_604, a_N57_aNOT,
          n_606, a_SSTS_REG_F0_G, n_608, n_609, n_610, n_611, n_612, a_SSTS_REG_F0_G_aCLRN,
          a_SSTS_REG_F0_G_aD, n_619, n_620, n_621, n_622, n_623, a_SSTS_REG_F0_G_aCLK,
          a_N595_aNOT, a_EQ146, n_627, n_628, n_629, n_630, n_631, n_632,
          n_633, n_634, a_N304, a_EQ092, n_637, n_638, n_639, n_640, a_N778,
          n_642, n_643, n_644, a_N777, n_646, n_647, n_648, n_649, n_650,
          a_SREG_RXDATA_F0_G, a_SREG_RXDATA_F0_G_aCLRN, a_EQ209, n_658, n_659,
          n_660, n_661, n_662, n_663, n_664, n_665, n_666, n_667, n_668, a_SREG_RXDATA_F0_G_aCLK,
          a_N256, a_EQ084, n_673, n_674, n_675, a_N379_aNOT, n_677, n_678,
          n_679, n_680, n_681, a_N618_aNOT, n_683, a_SSTS_REG_F1_G_aNOT_aCLRN,
          a_SSTS_REG_F1_G_aNOT_aD, n_690, n_691, n_692, n_693, n_694, n_695,
          a_SSTS_REG_F1_G_aNOT_aCLK, a_N625_aNOT, a_EQ161, n_699, n_700, n_701,
          n_702, n_703, n_704, n_705, a_N776, n_707, n_708, n_709, n_710,
          n_711, a_SREG_RXDATA_F1_G, a_SREG_RXDATA_F1_G_aCLRN, a_EQ210, n_719,
          n_720, n_721, n_722, n_723, n_724, n_725, n_726, n_727, n_728, n_729,
          a_SREG_RXDATA_F1_G_aCLK, a_N164, a_EQ057, n_733, n_734, n_735, a_N339,
          n_737, a_SSTS_REG_F2_G, n_739, n_740, a_N337, n_742, n_743, a_SSTS_REG_F2_G_aCLRN,
          a_EQ219, n_751, n_752, n_753, n_754, n_755, n_756, n_757, n_758,
          a_SSTS_REG_F2_G_aCLK, a_N624_aNOT, a_EQ160, n_762, n_763, n_764,
          n_765, n_766, n_767, n_768, a_N775, n_770, n_771, n_772, n_773,
          n_774, a_SREG_RXDATA_F2_G, a_SREG_RXDATA_F2_G_aCLRN, a_EQ211, n_782,
          n_783, n_784, n_785, n_786, n_787, n_788, n_789, n_790, n_791, n_792,
          a_SREG_RXDATA_F2_G_aCLK, a_SSTS_REG_F3_G, a_SSTS_REG_F3_G_aCLRN,
          a_SSTS_REG_F3_G_aD, n_801, n_802, n_803, n_804, n_805, a_SSTS_REG_F3_G_aCLK,
          a_N623_aNOT, a_EQ159, n_809, n_810, n_811, n_812, n_813, n_814,
          n_815, a_N774, n_817, n_818, n_819, n_820, n_821, a_SREG_RXDATA_F3_G,
          a_SREG_RXDATA_F3_G_aCLRN, a_EQ212, n_829, n_830, n_831, a_N609,
          n_833, n_834, n_835, n_836, n_837, n_838, n_839, n_840, a_SREG_RXDATA_F3_G_aCLK,
          a_LC3_B17, a_EQ099, n_844, n_845, n_846, n_847, n_848, a_LC3_B10,
          n_850, n_851, n_852, a_N394, n_854, a_SSTS_REG_F4_G, a_SSTS_REG_F4_G_aCLRN,
          a_EQ220, n_862, n_863, n_864, n_865, n_866, n_867, n_868, n_869,
          n_870, n_871, n_872, a_SSTS_REG_F4_G_aCLK, a_N622_aNOT, a_EQ158,
          n_876, n_877, n_878, n_879, n_880, n_881, n_882, a_N773, n_884,
          n_885, n_886, n_887, n_888, a_SREG_RXDATA_F4_G, a_SREG_RXDATA_F4_G_aCLRN,
          a_EQ213, n_896, n_897, n_898, n_899, n_900, n_901, n_902, n_903,
          n_904, n_905, n_906, a_SREG_RXDATA_F4_G_aCLK, a_N17_aNOT, a_EQ020,
          n_910, n_911, n_912, n_913, a_SSTS_REG_F5_G, n_915, n_916, a_LC5_B14,
          n_918, n_919, a_SSTS_REG_F5_G_aCLRN, a_SSTS_REG_F5_G_aD, n_926,
          n_927, n_928, n_929, n_930, n_931, a_SSTS_REG_F5_G_aCLK, a_N621_aNOT,
          a_EQ157, n_935, n_936, n_937, n_938, n_939, n_940, n_941, a_N772,
          n_943, n_944, n_945, n_946, n_947, a_SREG_RXDATA_F5_G, a_SREG_RXDATA_F5_G_aCLRN,
          a_EQ214, n_955, n_956, n_957, n_958, n_959, n_960, n_961, n_962,
          n_963, n_964, n_965, a_SREG_RXDATA_F5_G_aCLK, a_LC1_B13, a_EQ175,
          n_969, n_970, n_971, n_972, n_973, n_974, a_N771, n_976, n_977,
          n_978, n_979, n_980, n_981, n_982, n_983, n_984, n_985, a_N303,
          a_EQ091, n_988, n_989, n_990, n_991, n_992, n_993, n_994, n_995,
          n_996, n_997, n_998, n_999, a_LC3_B13, a_EQ176, n_1002, n_1003,
          n_1004, n_1005, n_1006, n_1007, n_1008, n_1009, n_1010, n_1011,
          n_1012, n_1013, n_1014, n_1015, n_1016, n_1017, n_1018, n_1019,
          n_1020, n_1021, n_1022, n_1023, n_1024, n_1025, n_1026, n_1027,
          n_1028, n_1029, n_1030, n_1031, n_1032, n_1033, n_1034, n_1035,
          n_1036, n_1037, n_1038, n_1039, n_1040, n_1041, n_1042, n_1043,
          a_LC6_B5, a_EQ177, n_1046, n_1047, n_1048, n_1049, n_1050, n_1051,
          n_1052, n_1053, n_1054, n_1055, n_1056, n_1057, n_1058, n_1059,
          n_1060, n_1061, n_1062, n_1063, n_1064, n_1065, n_1066, n_1067,
          n_1068, n_1069, n_1070, n_1071, n_1072, n_1073, n_1074, n_1075,
          n_1076, n_1077, n_1078, n_1079, n_1080, n_1081, n_1082, n_1083,
          n_1084, n_1085, n_1086, n_1087, a_LC1_B12, a_EQ090, n_1090, n_1091,
          n_1092, n_1093, rx_parity, n_1095, n_1096, n_1097, n_1098, n_1099,
          n_1100, n_1101, n_1102, n_1103, n_1104, n_1105, n_1106, n_1107,
          n_1108, n_1109, n_1110, n_1111, n_1112, a_SSTS_REG_F6_G, a_SSTS_REG_F6_G_aCLRN,
          a_EQ222, n_1120, n_1121, n_1122, n_1123, n_1124, n_1125, n_1126,
          n_1127, n_1128, n_1129, n_1130, a_SSTS_REG_F6_G_aCLK, a_SREG_RXDATA_F6_G,
          a_SREG_RXDATA_F6_G_aCLRN, a_EQ215, n_1139, n_1140, n_1141, n_1142,
          n_1143, n_1144, n_1145, n_1146, n_1147, n_1148, n_1149, a_SREG_RXDATA_F6_G_aCLK,
          a_LC8_B12, a_EQ089, n_1153, n_1154, n_1155, n_1156, n_1157, n_1158,
          n_1159, n_1160, n_1161, n_1162, a_SREG_RXDATA_F7_G, a_SREG_RXDATA_F7_G_aCLRN,
          a_EQ216, n_1170, n_1171, n_1172, n_1173, n_1174, n_1175, n_1176,
          n_1177, n_1178, n_1179, n_1180, a_SREG_RXDATA_F7_G_aCLK, a_N890,
          a_N890_aCLRN, a_EQ188, n_1189, n_1190, n_1191, n_1192, n_1193, n_1194,
          n_1195, n_1196, n_1197, n_1198, n_1199, n_1200, n_1201, a_N890_aCLK,
          a_N891, a_N891_aCLRN, a_EQ189, n_1210, n_1211, n_1212, n_1213, n_1214,
          n_1215, n_1216, n_1217, n_1218, n_1219, n_1220, n_1221, n_1222,
          a_N891_aCLK, a_EQ010, n_1225, n_1226, n_1227, n_1228, n_1229, n_1230,
          n_1231, n_1232, a_EQ014, n_1234, n_1235, n_1236, n_1237, n_1238,
          n_1239, n_1240, n_1241, a_EQ016, n_1243, n_1244, n_1245, n_1246,
          n_1247, n_1248, n_1249, n_1250, a_EQ012, n_1252, n_1253, n_1254,
          n_1255, n_1256, n_1257, n_1258, n_1259, a_EQ009, n_1261, n_1262,
          n_1263, n_1264, n_1265, n_1266, n_1267, n_1268, a_EQ013, n_1270,
          n_1271, n_1272, n_1273, n_1274, n_1275, n_1276, n_1277, a_EQ011,
          n_1279, n_1280, n_1281, n_1282, n_1283, n_1284, n_1285, n_1286,
          a_LC5_B11, a_EQ056, n_1289, n_1290, n_1291, n_1292, n_1293, n_1294,
          n_1295, n_1296, n_1297, a_N759, a_N759_aCLRN, a_EQ179, n_1305, n_1306,
          n_1307, n_1308, n_1309, n_1310, n_1311, n_1312, n_1313, n_1314,
          a_N759_aCLK, a_N758, a_N758_aCLRN, a_EQ178, n_1323, n_1324, n_1325,
          n_1326, n_1327, n_1328, n_1329, n_1330, n_1331, n_1332, n_1333,
          a_N758_aCLK, a_EQ015, n_1336, n_1337, n_1338, n_1339, n_1340, n_1341,
          n_1342, n_1343, n_1344, n_1345, n_1346, a_N378_aNOT, a_EQ108, n_1349,
          n_1350, n_1351, n_1352, n_1353, n_1354, n_1355, n_1356, n_1357,
          a_N1016, n_1359, n_1360, a_LC4_A16, a_EQ106, n_1363, n_1364, n_1365,
          n_1366, n_1367, n_1368, n_1369, n_1370, a_EQ223, n_1372, n_1373,
          n_1374, n_1375, n_1376, n_1377, n_1378, n_1379, n_1380, n_1381,
          n_1382, n_1383, n_1384, n_1385, a_SRTS_aIN, n_1387, n_1388, n_1389,
          n_1390, n_1391, a_EQ208, n_1393, n_1394, n_1395, n_1396, n_1397,
          n_1398, a_EQ164, n_1400, n_1401, n_1402, n_1403, n_1404, n_1405,
          a_N589_aNOT, a_EQ143, n_1408, n_1409, n_1410, n_1411, n_1412, n_1413,
          n_1414, n_1415, a_LC1_A14, a_EQ039, n_1418, n_1419, n_1420, a_N167,
          n_1422, a_N168, n_1424, a_N166, n_1426, n_1427, n_1428, n_1429,
          n_1430, n_1431, n_1432, a_LC1_A5, a_LC1_A5_aIN, n_1435, n_1436,
          n_1437, a_N171, n_1439, a_N172, n_1441, a_LC2_A5, a_LC2_A5_aIN,
          n_1444, n_1445, n_1446, n_1447, a_N170, n_1449, a_LC2_A14, a_LC2_A14_aIN,
          n_1452, n_1453, n_1454, n_1455, a_N169, n_1457, a_N55, a_EQ040,
          n_1460, n_1461, n_1462, n_1463, n_1464, n_1465, n_1466, n_1467,
          a_EQ152, n_1469, n_1470, n_1471, n_1472, n_1473, n_1474, a_EQ173,
          n_1476, n_1477, n_1478, n_1479, n_1480, n_1481, n_1482, n_1483,
          a_N604_aIN, n_1485, n_1486, n_1487, n_1488, n_1489, a_EQ145, n_1491,
          n_1492, n_1493, n_1494, n_1495, n_1496, n_1497, a_LC6_A13, a_EQ109,
          n_1500, n_1501, n_1502, n_1503, n_1504, n_1505, n_1506, n_1507,
          a_N602, a_N602_aIN, n_1510, n_1511, n_1512, n_1513, n_1514, a_N633_aIN,
          n_1516, n_1517, n_1518, n_1519, n_1520, n_1521, n_1522, a_EQ110,
          n_1524, n_1525, n_1526, n_1527, n_1528, n_1529, n_1530, n_1531,
          a_LC8_A9, a_LC8_A9_aIN, n_1534, n_1535, n_1536, n_1537, n_1538,
          a_LC2_A12, a_LC2_A12_aIN, n_1541, n_1542, n_1543, n_1544, n_1545,
          n_1546, a_N30, a_N30_aCLRN, a_EQ023, n_1554, n_1555, n_1556, n_1557,
          n_1558, n_1559, n_1560, n_1561, n_1562, n_1563, a_N30_aCLK, a_LC3_A19,
          a_LC3_A19_aIN, n_1567, n_1568, n_1569, n_1570, n_1571, n_1572, a_LC7_A12,
          a_EQ094, n_1575, n_1576, n_1577, n_1578, a_N32, n_1580, n_1581,
          n_1582, n_1583, a_N32_aCLRN, a_EQ025, n_1590, n_1591, n_1592, n_1593,
          n_1594, n_1595, n_1596, n_1597, n_1598, n_1599, n_1600, a_N32_aCLK,
          a_N326, a_EQ098, n_1604, n_1605, n_1606, n_1607, n_1608, n_1609,
          n_1610, a_N33, n_1612, a_N33_aCLRN, a_EQ026, n_1619, n_1620, n_1621,
          n_1622, n_1623, n_1624, n_1625, n_1626, n_1627, n_1628, n_1629,
          a_N33_aCLK, a_N609_aIN, n_1632, n_1633, n_1634, n_1635, n_1636,
          a_N197, a_N197_aIN, n_1639, n_1640, n_1641, n_1642, n_1643, a_N597_aIN,
          n_1645, n_1646, n_1647, n_1648, n_1649, a_LC5_A11, a_EQ117, n_1652,
          n_1653, n_1654, n_1655, a_N34, n_1657, n_1658, n_1659, n_1660, a_N34_aCLRN,
          a_EQ027, n_1667, n_1668, n_1669, n_1670, n_1671, n_1672, n_1673,
          n_1674, a_N34_aCLK, a_LC6_A11, a_EQ095, n_1678, n_1679, n_1680,
          n_1681, a_N35, n_1683, n_1684, n_1685, n_1686, a_N35_aCLRN, a_EQ028,
          n_1693, n_1694, n_1695, n_1696, n_1697, n_1698, n_1699, n_1700,
          n_1701, n_1702, n_1703, a_N35_aCLK, a_N51_aNOT, a_EQ037, n_1707,
          n_1708, n_1709, n_1710, n_1711, n_1712, n_1713, n_1714, n_1715,
          n_1716, a_N45_aNOT, a_EQ035, n_1719, n_1720, n_1721, a_N475, n_1723,
          n_1724, a_N474, n_1726, a_N126_aNOT, a_EQ046, n_1729, n_1730, n_1731,
          n_1732, n_1733, a_N473, n_1735, n_1736, a_N476, n_1738, n_1739,
          n_1740, n_1741, n_1742, a_N380, a_EQ111, n_1745, n_1746, n_1747,
          n_1748, n_1749, n_1750, n_1751, n_1752, n_1753, n_1754, n_1755,
          n_1756, n_1757, n_1758, n_1759, a_N642_aNOT, a_EQ174, n_1762, n_1763,
          n_1764, n_1765, n_1766, n_1767, n_1768, n_1769, a_N603_aNOT, a_EQ150,
          n_1772, n_1773, n_1774, n_1775, n_1776, n_1777, a_N636_aNOT, a_EQ171,
          n_1780, n_1781, n_1782, n_1783, n_1784, n_1785, n_1786, n_1787,
          n_1788, n_1789, a_N44_aNOT, a_EQ034, n_1792, n_1793, n_1794, n_1795,
          n_1796, n_1797, n_1798, n_1799, n_1800, n_1801, a_N248, a_EQ083,
          n_1804, n_1805, n_1806, n_1807, n_1808, n_1809, n_1810, n_1811,
          a_N124, a_N124_aIN, n_1814, n_1815, n_1816, n_1817, n_1818, n_1819,
          a_N475_aCLRN, a_EQ128, n_1826, n_1827, n_1828, n_1829, n_1830, n_1831,
          n_1832, n_1833, n_1834, n_1835, n_1836, a_N475_aCLK, a_N474_aCLRN,
          a_EQ127, n_1844, n_1845, n_1846, n_1847, n_1848, n_1849, n_1850,
          n_1851, n_1852, n_1853, n_1854, n_1855, n_1856, n_1857, n_1858,
          n_1859, a_N474_aCLK, a_N473_aCLRN, a_EQ126, n_1867, n_1868, n_1869,
          n_1870, n_1871, n_1872, n_1873, n_1874, n_1875, n_1876, n_1877,
          n_1878, n_1879, n_1880, n_1881, n_1882, a_N473_aCLK, a_N476_aCLRN,
          a_EQ129, n_1890, n_1891, n_1892, n_1893, n_1894, n_1895, n_1896,
          n_1897, n_1898, n_1899, n_1900, n_1901, n_1902, n_1903, n_1904,
          n_1905, a_N476_aCLK, a_LC8_A2, a_EQ097, n_1909, n_1910, n_1911,
          n_1912, a_N36, n_1914, n_1915, n_1916, n_1917, a_N36_aCLRN, a_EQ029,
          n_1924, n_1925, n_1926, n_1927, n_1928, n_1929, n_1930, n_1931,
          n_1932, n_1933, n_1934, a_N36_aCLK, a_LC6_A18, a_EQ042, n_1938,
          n_1939, n_1940, n_1941, n_1942, n_1943, n_1944, n_1945, a_LC5_A18,
          a_EQ103, n_1948, n_1949, n_1950, n_1951, n_1952, n_1953, n_1954,
          n_1955, n_1956, a_LC2_A18, a_LC2_A18_aIN, n_1959, n_1960, n_1961,
          n_1962, n_1963, n_1964, a_N171_aCLRN, a_EQ064, n_1971, n_1972, n_1973,
          n_1974, n_1975, n_1976, n_1977, n_1978, n_1979, n_1980, n_1981,
          n_1982, n_1983, n_1984, a_N171_aCLK, a_N172_aCLRN, a_EQ065, n_1992,
          n_1993, n_1994, n_1995, n_1996, n_1997, n_1998, n_1999, n_2000,
          a_N172_aCLK, a_N374_aNOT, a_EQ107, n_2004, n_2005, n_2006, n_2007,
          n_2008, n_2009, n_2010, n_2011, n_2012, n_2013, n_2014, n_2015,
          n_2016, n_2017, n_2018, n_2019, n_2020, n_2021, n_2022, a_N398_aNOT,
          a_EQ115, n_2025, n_2026, n_2027, a_N434, n_2029, n_2030, n_2031,
          n_2032, n_2033, a_LC3_B8, a_EQ165, n_2036, n_2037, n_2038, n_2039,
          n_2040, n_2041, n_2042, n_2043, n_2044, n_2045, n_2046, n_2047,
          n_2048, n_2049, a_N388, a_EQ113, n_2052, n_2053, n_2054, a_N433,
          n_2056, n_2057, n_2058, n_2059, a_N432, n_2061, a_LC4_B8, a_EQ038,
          n_2064, n_2065, n_2066, a_N430, n_2068, a_N429, n_2070, n_2071,
          n_2072, n_2073, n_2074, n_2075, n_2076, n_2077, n_2078, n_2079,
          n_2080, n_2081, n_2082, n_2083, a_LC1_B8, a_EQ166, n_2086, n_2087,
          n_2088, n_2089, n_2090, n_2091, n_2092, a_N431, n_2094, n_2095,
          n_2096, a_LC2_B8, a_EQ050, n_2099, n_2100, n_2101, n_2102, n_2103,
          n_2104, n_2105, n_2106, n_2107, n_2108, n_2109, n_2110, n_2111,
          n_2112, n_2113, n_2114, n_2115, n_2116, a_N141, a_EQ051, n_2119,
          n_2120, n_2121, n_2122, n_2123, n_2124, n_2125, n_2126, n_2127,
          n_2128, a_N608_aNOT, a_EQ153, n_2131, n_2132, n_2133, n_2135, n_2136,
          n_2137, n_2138, n_2139, n_2140, n_2141, a_N134, a_EQ048, n_2144,
          n_2145, n_2146, n_2147, n_2148, n_2149, n_2150, n_2151, a_N68, a_EQ043,
          n_2154, n_2155, n_2156, n_2157, n_2158, n_2159, n_2160, n_2161,
          a_N433_aCLRN, a_EQ124, n_2168, n_2169, n_2170, n_2171, n_2172, n_2173,
          n_2174, n_2175, n_2176, n_2177, n_2178, a_N433_aCLK, a_N434_aCLRN,
          a_EQ125, n_2186, n_2187, n_2188, n_2189, n_2190, n_2191, n_2192,
          n_2193, n_2194, n_2195, n_2196, n_2197, n_2198, n_2199, n_2200,
          n_2201, a_N434_aCLK, a_N432_aCLRN, a_EQ123, n_2209, n_2210, n_2211,
          n_2212, n_2213, n_2214, n_2215, n_2216, n_2217, n_2218, n_2219,
          n_2220, n_2221, n_2222, n_2223, n_2224, a_N432_aCLK, a_N399, a_EQ116,
          n_2228, n_2229, n_2230, n_2231, n_2232, n_2233, n_2234, n_2235,
          n_2236, n_2237, a_N430_aCLRN, a_EQ121, n_2244, n_2245, n_2246, n_2247,
          n_2248, n_2249, n_2250, n_2251, n_2252, n_2253, n_2254, a_N430_aCLK,
          a_N170_aCLRN, a_EQ063, n_2262, n_2263, n_2264, n_2265, n_2266, n_2267,
          n_2268, n_2269, n_2270, n_2271, n_2272, n_2273, n_2274, n_2275,
          a_N170_aCLK, a_N429_aCLRN, a_EQ120, n_2283, n_2284, n_2285, n_2286,
          n_2287, n_2288, n_2289, n_2290, n_2291, n_2292, n_2293, n_2294,
          n_2295, n_2296, n_2297, n_2298, a_N429_aCLK, a_LC3_A14, a_LC3_A14_aIN,
          n_2302, n_2303, n_2304, n_2305, n_2306, a_N167_aCLRN, a_EQ060, n_2313,
          n_2314, n_2315, n_2316, n_2317, n_2318, n_2319, n_2320, n_2321,
          n_2322, n_2323, n_2324, n_2325, n_2326, a_N167_aCLK, a_N168_aCLRN,
          a_EQ061, n_2334, n_2335, n_2336, n_2337, n_2338, n_2339, n_2340,
          n_2341, n_2342, n_2343, n_2344, n_2345, n_2346, n_2347, a_N168_aCLK,
          a_LC4_A14, a_LC4_A14_aIN, n_2351, n_2352, n_2353, n_2354, n_2355,
          n_2356, n_2357, a_N166_aCLRN, a_EQ059, n_2364, n_2365, n_2366, n_2367,
          n_2368, n_2369, n_2370, n_2371, n_2372, n_2373, n_2374, n_2375,
          n_2376, n_2377, a_N166_aCLK, a_N169_aCLRN, a_EQ062, n_2385, n_2386,
          n_2387, n_2388, n_2389, n_2390, n_2391, n_2392, n_2393, n_2394,
          n_2395, n_2396, n_2397, n_2398, a_N169_aCLK, a_N387, a_N387_aIN,
          n_2402, n_2403, n_2404, n_2405, n_2406, n_2407, a_N431_aCLRN, a_EQ122,
          n_2414, n_2415, n_2416, n_2417, n_2418, n_2419, n_2420, n_2421,
          n_2422, n_2423, n_2424, a_N431_aCLK, a_LC7_A2, a_EQ118, n_2428,
          n_2429, n_2430, n_2431, n_2432, n_2433, n_2434, n_2435, a_N37, a_N37_aCLRN,
          a_EQ030, n_2443, n_2444, n_2445, n_2446, n_2447, n_2448, n_2449,
          n_2450, n_2451, a_N37_aCLK, a_EQ155, n_2454, n_2455, n_2456, a_N952,
          n_2458, n_2459, a_N950, n_2461, a_STX_REG_DATA_F6_G_aCLRN, a_EQ230,
          n_2468, n_2469, n_2470, n_2471, n_2472, n_2473, n_2474, n_2475,
          n_2476, n_2477, n_2478, a_STX_REG_DATA_F6_G_aCLK, a_STX_REG_DATA_F5_G_aCLRN,
          a_EQ229, n_2486, n_2487, n_2488, n_2489, n_2490, n_2491, n_2492,
          n_2493, n_2494, n_2495, n_2496, a_STX_REG_DATA_F5_G_aCLK, a_STX_REG_DATA_F3_G_aCLRN,
          a_EQ227, n_2504, n_2505, n_2506, n_2507, n_2508, a_SINT_DI_F3_G,
          n_2510, n_2511, n_2512, n_2513, n_2514, n_2515, a_STX_REG_DATA_F3_G_aCLK,
          a_STX_REG_DATA_F4_G_aCLRN, a_EQ228, n_2523, n_2524, n_2525, n_2526,
          n_2527, n_2528, n_2529, n_2530, n_2531, a_SINT_DI_F4_G, n_2533,
          n_2534, a_STX_REG_DATA_F4_G_aCLK, a_SINT_DI_F3_G_aCLRN, a_EQ203,
          n_2543, n_2544, n_2545, n_2546, n_2547, n_2548, n_2549, n_2550,
          n_2551, a_SINT_DI_F3_G_aCLK, a_SINT_DI_F2_G, a_SINT_DI_F2_G_aCLRN,
          a_EQ202, n_2561, n_2562, n_2563, n_2564, n_2565, n_2566, n_2567,
          n_2568, n_2569, a_SINT_DI_F2_G_aCLK, a_EQ142, n_2572, n_2573, n_2574,
          a_N204, n_2576, n_2577, a_N202, n_2579, n_2580, a_N205, n_2582,
          n_2583, n_2584, n_2585, n_2586, a_LC4_A15, a_LC4_A15_aIN, n_2589,
          n_2590, n_2591, n_2592, n_2593, a_N204_aCLRN, a_EQ070, n_2600, n_2601,
          n_2602, n_2603, n_2604, n_2605, n_2606, n_2607, n_2608, n_2609,
          n_2610, n_2611, n_2612, n_2613, a_N204_aCLK, a_N212, a_EQ072, n_2617,
          n_2618, n_2619, n_2620, n_2621, n_2622, a_N202_aCLRN, a_EQ069, n_2629,
          n_2630, n_2631, n_2632, n_2633, n_2634, n_2635, n_2636, n_2637,
          n_2638, n_2639, n_2640, n_2641, n_2642, a_N202_aCLK, a_N205_aCLRN,
          a_EQ071, n_2650, n_2651, n_2652, n_2653, n_2654, n_2655, n_2656,
          n_2657, n_2658, a_N205_aCLK, a_SINT_DI_F4_G_aCLRN, a_EQ204, n_2667,
          n_2668, n_2669, n_2670, n_2671, n_2672, n_2673, n_2674, n_2675,
          a_SINT_DI_F4_G_aCLK, a_STX_REG_DATA_F2_G_aCLRN, a_EQ226, n_2683,
          n_2684, n_2685, n_2686, n_2687, n_2688, n_2689, n_2690, n_2691,
          n_2692, n_2693, a_STX_REG_DATA_F2_G_aCLK, a_STX_REG_DATA_F0_G_aCLRN,
          a_EQ224, n_2701, n_2702, n_2703, n_2704, n_2705, n_2706, n_2707,
          n_2708, n_2709, n_2710, n_2711, a_STX_REG_DATA_F0_G_aCLK, a_STX_REG_DATA_F1_G_aCLRN,
          a_EQ225, n_2719, n_2720, n_2721, n_2722, n_2723, n_2724, n_2725,
          n_2726, n_2727, n_2728, n_2729, a_STX_REG_DATA_F1_G_aCLK, a_N892_aCLRN,
          a_EQ190, n_2737, n_2738, n_2739, n_2740, n_2741, n_2742, n_2743,
          n_2744, n_2745, n_2746, n_2747, n_2748, n_2749, a_N892_aCLK, a_N893_aCLRN,
          a_EQ191, n_2757, n_2758, n_2759, n_2760, n_2761, n_2762, n_2763,
          n_2764, n_2765, n_2766, n_2767, n_2768, n_2769, a_N893_aCLK, a_STX_REG_DATA_F7_G_aCLRN,
          a_EQ231, n_2777, n_2778, n_2779, n_2780, n_2781, n_2782, n_2783,
          n_2784, n_2785, n_2786, n_2787, a_STX_REG_DATA_F7_G_aCLK, a_LC7_A21_aIN,
          n_2790, n_2791, n_2792, n_2793, n_2794, n_2795, n_2796, a_N952_aCLRN,
          a_N952_aD, n_2803, n_2804, n_2805, n_2806, n_2807, n_2808, n_2809,
          a_N952_aCLK, a_N950_aCLRN, a_N950_aD, n_2817, n_2818, n_2819, n_2820,
          n_2821, a_N950_aCLK, a_N600, a_N600_aIN, n_2825, n_2826, n_2827,
          n_2828, n_2829, a_LC1_B10, a_EQ131, n_2832, n_2833, n_2834, n_2835,
          n_2836, n_2837, n_2838, n_2839, n_2840, n_2841, a_N48_aNOT, a_N48_aNOT_aIN,
          n_2844, n_2845, n_2846, n_2847, n_2848, n_2849, a_LC5_B10, a_LC5_B10_aIN,
          n_2852, n_2853, n_2854, n_2855, n_2856, n_2857, n_2858, a_LC5_B14_aIN,
          n_2860, n_2861, n_2862, n_2863, n_2864, n_2865, n_2866, a_N28, a_N28_aIN,
          n_2869, n_2870, n_2871, n_2872, n_2873, a_N31_aNOT, a_EQ024, n_2876,
          n_2877, n_2878, n_2879, n_2880, n_2881, n_2882, n_2883, n_2884,
          a_LC2_B10, a_EQ132, n_2887, n_2888, n_2889, n_2890, n_2891, n_2892,
          n_2893, n_2894, n_2895, n_2896, a_N146_aNOT, a_N146_aNOT_aIN, n_2899,
          n_2900, n_2901, n_2902, n_2903, n_2904, n_2905, a_N263, a_N263_aIN,
          n_2908, n_2909, n_2910, n_2911, n_2912, n_2913, a_N637_aNOT, a_EQ172,
          n_2916, n_2917, n_2918, n_2919, n_2920, n_2921, n_2922, n_2923,
          n_2924, n_2925, a_N42_aNOT, a_EQ031, n_2928, n_2929, n_2930, n_2931,
          n_2932, n_2933, n_2934, n_2935, a_N495_aCLRN, a_EQ130, n_2942, n_2943,
          n_2944, n_2945, n_2946, n_2947, n_2948, n_2949, n_2950, n_2951,
          n_2952, n_2953, a_N495_aCLK, a_EQ144, n_2956, n_2957, n_2958, n_2959,
          n_2960, n_2961, a_N145_aNOT, a_N145_aNOT_aIN, n_2964, n_2965, n_2966,
          n_2967, n_2968, a_LC2_B19, a_EQ140, n_2971, n_2972, n_2973, n_2974,
          n_2975, n_2976, n_2977, n_2978, n_2979, n_2980, a_N261_aNOT_aIN,
          n_2982, n_2983, n_2984, n_2985, n_2986, n_2987, n_2988, a_LC4_B16,
          a_EQ032, n_2991, n_2992, n_2993, n_2994, n_2995, n_2996, n_2997,
          n_2998, n_2999, n_3000, n_3001, n_3002, a_N43_aNOT, a_EQ033, n_3005,
          n_3006, n_3007, n_3008, n_3009, n_3010, n_3011, n_3012, n_3013,
          a_LC7_B19, a_EQ141, n_3016, n_3017, n_3018, n_3019, n_3020, n_3021,
          n_3022, n_3023, n_3024, n_3025, a_LC6_B9, a_EQ138, n_3028, n_3029,
          n_3030, n_3031, n_3032, n_3033, n_3034, n_3035, n_3036, n_3037,
          a_LC3_B9, a_LC3_B9_aIN, n_3040, n_3041, n_3042, n_3043, n_3044,
          n_3045, a_LC5_B9, a_EQ139, n_3048, n_3049, n_3050, n_3051, n_3052,
          n_3053, n_3054, n_3055, a_N498_aCLRN, a_EQ134, n_3062, n_3063, n_3064,
          n_3065, n_3066, n_3067, n_3068, n_3069, n_3070, n_3071, a_N498_aCLK,
          a_LC2_B1, a_EQ052, n_3075, n_3076, n_3077, n_3078, n_3079, n_3080,
          n_3081, n_3082, n_3083, n_3084, a_LC1_B1, a_LC1_B1_aIN, n_3087,
          n_3088, n_3089, n_3090, n_3091, n_3092, a_N140_aNOT, a_N140_aNOT_aIN,
          n_3095, n_3096, n_3097, n_3098, n_3099, n_3100, a_N499_aCLRN, a_EQ135,
          n_3107, n_3108, n_3109, n_3110, n_3111, n_3112, n_3113, n_3114,
          n_3115, n_3116, n_3117, n_3118, a_N499_aCLK, a_LC2_B9, a_EQ136,
          n_3122, n_3123, n_3124, n_3125, n_3126, n_3127, n_3128, a_N130_aNOT,
          a_N130_aNOT_aIN, n_3131, n_3132, n_3133, n_3134, n_3135, n_3136,
          a_LC1_B9, a_EQ137, n_3139, n_3140, n_3141, n_3142, n_3143, n_3144,
          n_3145, n_3146, n_3147, a_N497_aCLRN, a_EQ133, n_3154, n_3155, n_3156,
          n_3157, n_3158, n_3159, n_3160, n_3161, n_3162, n_3163, a_N497_aCLK,
          a_N778_aCLRN, a_EQ187, n_3171, n_3172, n_3173, n_3174, n_3175, n_3176,
          n_3177, n_3178, n_3179, n_3180, n_3181, a_N778_aCLK, a_N777_aCLRN,
          a_EQ186, n_3189, n_3190, n_3191, n_3192, n_3193, n_3194, n_3195,
          n_3196, n_3197, n_3198, n_3199, a_N777_aCLK, a_N956, a_N956_aCLRN,
          a_N956_aD, n_3208, n_3209, n_3210, n_3211, n_3212, n_3213, n_3214,
          a_N956_aCLK, a_N953, a_N953_aCLRN, a_N953_aD, n_3223, n_3224, n_3225,
          n_3226, n_3227, a_N953_aCLK, a_LC7_A6, a_LC7_A6_aIN, n_3231, n_3232,
          n_3233, n_3234, n_3235, a_N339_aCLRN, a_EQ101, n_3242, n_3243, n_3244,
          n_3245, n_3246, n_3247, n_3248, n_3249, n_3250, n_3251, a_N339_aCLK,
          a_N957, a_N957_aCLRN, a_N957_aD, n_3260, n_3261, n_3262, n_3263,
          n_3264, n_3265, n_3266, a_N957_aCLK, a_N954, a_N954_aCLRN, a_N954_aD,
          n_3275, n_3276, n_3277, n_3278, n_3279, a_N954_aCLK, a_N57_aNOT_aIN,
          n_3282, n_3283, n_3284, n_3285, n_3286, a_LC3_B11, a_LC3_B11_aIN,
          n_3289, n_3290, n_3291, n_3292, n_3293, a_N337_aCLRN, a_EQ100, n_3300,
          n_3301, n_3302, n_3303, n_3304, n_3305, n_3306, n_3307, n_3308,
          n_3309, a_N337_aCLK, a_N776_aCLRN, a_EQ185, n_3317, n_3318, n_3319,
          n_3320, n_3321, n_3322, n_3323, n_3324, n_3325, n_3326, n_3327,
          a_N776_aCLK, a_N775_aCLRN, a_EQ184, n_3335, n_3336, n_3337, n_3338,
          n_3339, n_3340, n_3341, n_3342, n_3343, n_3344, n_3345, a_N775_aCLK,
          a_EQ156, n_3348, n_3349, n_3350, n_3351, n_3352, n_3353, n_3354,
          n_3355, n_3356, n_3357, a_N394_aCLRN, a_EQ114, n_3364, n_3365, n_3366,
          n_3367, n_3368, n_3369, n_3370, n_3371, n_3372, a_N394_aCLK, a_N774_aCLRN,
          a_EQ183, n_3380, n_3381, n_3382, n_3383, n_3384, n_3385, n_3386,
          n_3387, n_3388, n_3389, n_3390, a_N774_aCLK, a_N773_aCLRN, a_EQ182,
          n_3398, n_3399, n_3400, n_3401, n_3402, n_3403, n_3404, n_3405,
          n_3406, n_3407, n_3408, a_N773_aCLK, a_N772_aCLRN, a_EQ181, n_3416,
          n_3417, n_3418, n_3419, n_3420, n_3421, n_3422, n_3423, n_3424,
          n_3425, n_3426, a_N772_aCLK, rx_parity_aCLRN, a_EQ002, n_3434, n_3435,
          n_3436, n_3437, n_3438, n_3439, n_3440, n_3441, n_3442, n_3443,
          n_3444, rx_parity_aCLK, word_lngth_aCLRN, a_EQ003, n_3452, n_3453,
          n_3454, n_3455, n_3456, n_3457, n_3458, n_3459, n_3460, n_3461,
          n_3462, n_3463, n_3464, word_lngth_aCLK, a_N771_aCLRN, a_EQ180,
          n_3472, n_3473, n_3474, n_3475, n_3476, n_3477, n_3478, n_3479,
          n_3480, n_3481, n_3482, a_N771_aCLK, a_N365_aNOT, a_N365_aNOT_aIN,
          n_3486, n_3487, n_3488, n_3489, n_3490, n_3491, a_N631, a_N631_aIN,
          n_3494, n_3495, n_3496, n_3497, n_3498, n_3499, a_LC7_A18, a_EQ105,
          n_3502, n_3503, n_3504, n_3505, n_3506, n_3507, n_3508, n_3509,
          n_3510, a_N219_aCLRN, a_EQ075, n_3517, n_3518, n_3519, n_3520, n_3521,
          n_3522, n_3523, n_3524, n_3525, n_3526, n_3527, n_3528, a_N219_aCLK,
          a_LC1_A2, a_EQ119, n_3532, n_3533, n_3534, n_3535, n_3536, n_3537,
          n_3538, n_3539, a_N1016_aCLRN, a_EQ199, n_3546, n_3547, n_3548,
          n_3549, n_3550, n_3551, n_3552, n_3553, n_3554, n_3555, a_N1016_aCLK,
          a_SINT_DI_F1_G_aCLRN, a_EQ201, n_3564, n_3565, n_3566, n_3567, n_3568,
          n_3569, n_3570, n_3571, n_3572, a_SINT_DI_F1_G_aCLK : std_logic;

COMPONENT TRIBUF_a6850
    PORT (in1, oe  : IN std_logic; y : OUT std_logic);
END COMPONENT;

COMPONENT DFF_a6850
    PORT (d, clk, clrn, prn : IN std_logic; q : OUT std_logic);
END COMPONENT;

COMPONENT FILTER_a6850
    PORT (in1 : IN std_logic; y : OUT std_logic);
END COMPONENT;

BEGIN

PROCESS(CS(0), CS(1), CS(2), DI(0), DI(1), DI(2), DI(3), DI(4), DI(5), DI(6), DI(7),
          E, nCTS, nDCD, nRESET, RnW, RS, RXCLK, RXDATA, TXCLK)
BEGIN
    ASSERT CS(0) /= 'X' OR Now = 0 ns
        REPORT "Unknown value on CS(0)"
        SEVERITY Warning;
    ASSERT CS(1) /= 'X' OR Now = 0 ns
        REPORT "Unknown value on CS(1)"
        SEVERITY Warning;
    ASSERT CS(2) /= 'X' OR Now = 0 ns
        REPORT "Unknown value on CS(2)"
        SEVERITY Warning;
    ASSERT DI(0) /= 'X' OR Now = 0 ns
        REPORT "Unknown value on DI(0)"
        SEVERITY Warning;
    ASSERT DI(1) /= 'X' OR Now = 0 ns
        REPORT "Unknown value on DI(1)"
        SEVERITY Warning;
    ASSERT DI(2) /= 'X' OR Now = 0 ns
        REPORT "Unknown value on DI(2)"
        SEVERITY Warning;
    ASSERT DI(3) /= 'X' OR Now = 0 ns
        REPORT "Unknown value on DI(3)"
        SEVERITY Warning;
    ASSERT DI(4) /= 'X' OR Now = 0 ns
        REPORT "Unknown value on DI(4)"
        SEVERITY Warning;
    ASSERT DI(5) /= 'X' OR Now = 0 ns
        REPORT "Unknown value on DI(5)"
        SEVERITY Warning;
    ASSERT DI(6) /= 'X' OR Now = 0 ns
        REPORT "Unknown value on DI(6)"
        SEVERITY Warning;
    ASSERT DI(7) /= 'X' OR Now = 0 ns
        REPORT "Unknown value on DI(7)"
        SEVERITY Warning;
    ASSERT E /= 'X' OR Now = 0 ns
        REPORT "Unknown value on E"
        SEVERITY Warning;
    ASSERT nCTS /= 'X' OR Now = 0 ns
        REPORT "Unknown value on nCTS"
        SEVERITY Warning;
    ASSERT nDCD /= 'X' OR Now = 0 ns
        REPORT "Unknown value on nDCD"
        SEVERITY Warning;
    ASSERT nRESET /= 'X' OR Now = 0 ns
        REPORT "Unknown value on nRESET"
        SEVERITY Warning;
    ASSERT RnW /= 'X' OR Now = 0 ns
        REPORT "Unknown value on RnW"
        SEVERITY Warning;
    ASSERT RS /= 'X' OR Now = 0 ns
        REPORT "Unknown value on RS"
        SEVERITY Warning;
    ASSERT RXCLK /= 'X' OR Now = 0 ns
        REPORT "Unknown value on RXCLK"
        SEVERITY Warning;
    ASSERT RXDATA /= 'X' OR Now = 0 ns
        REPORT "Unknown value on RXDATA"
        SEVERITY Warning;
    ASSERT TXCLK /= 'X' OR Now = 0 ns
        REPORT "Unknown value on TXCLK"
        SEVERITY Warning;
END PROCESS;

tribuf_2: TRIBUF_a6850

    PORT MAP (IN1 => n_58, OE => vcc, Y => DO(0));
tribuf_4: TRIBUF_a6850

    PORT MAP (IN1 => n_65, OE => vcc, Y => DO(1));
tribuf_6: TRIBUF_a6850

    PORT MAP (IN1 => n_72, OE => vcc, Y => DO(2));
tribuf_8: TRIBUF_a6850

    PORT MAP (IN1 => n_79, OE => vcc, Y => DO(3));
tribuf_10: TRIBUF_a6850

    PORT MAP (IN1 => n_86, OE => vcc, Y => DO(4));
tribuf_12: TRIBUF_a6850

    PORT MAP (IN1 => n_93, OE => vcc, Y => DO(5));
tribuf_14: TRIBUF_a6850

    PORT MAP (IN1 => n_100, OE => vcc, Y => DO(6));
tribuf_16: TRIBUF_a6850

    PORT MAP (IN1 => n_107, OE => vcc, Y => DO(7));
tribuf_18: TRIBUF_a6850

    PORT MAP (IN1 => n_114, OE => vcc, Y => TXDATA);
tribuf_20: TRIBUF_a6850

    PORT MAP (IN1 => n_121, OE => vcc, Y => nRTS);
tribuf_22: TRIBUF_a6850

    PORT MAP (IN1 => n_128, OE => vcc, Y => nIRQ);
delay_23: n_58  <= TRANSPORT n_59;
xor2_24: n_59 <=  n_60  XOR n_64;
or1_25: n_60 <=  n_61;
and1_26: n_61 <=  n_62;
delay_27: n_62  <= TRANSPORT a_G57  ;
and1_28: n_64 <=  gnd;
delay_29: n_65  <= TRANSPORT n_66;
xor2_30: n_66 <=  n_67  XOR n_71;
or1_31: n_67 <=  n_68;
and1_32: n_68 <=  n_69;
delay_33: n_69  <= TRANSPORT a_G211  ;
and1_34: n_71 <=  gnd;
delay_35: n_72  <= TRANSPORT n_73;
xor2_36: n_73 <=  n_74  XOR n_78;
or1_37: n_74 <=  n_75;
and1_38: n_75 <=  n_76;
delay_39: n_76  <= TRANSPORT a_G345  ;
and1_40: n_78 <=  gnd;
delay_41: n_79  <= TRANSPORT n_80;
xor2_42: n_80 <=  n_81  XOR n_85;
or1_43: n_81 <=  n_82;
and1_44: n_82 <=  n_83;
delay_45: n_83  <= TRANSPORT a_G207  ;
and1_46: n_85 <=  gnd;
delay_47: n_86  <= TRANSPORT n_87;
xor2_48: n_87 <=  n_88  XOR n_92;
or1_49: n_88 <=  n_89;
and1_50: n_89 <=  n_90;
delay_51: n_90  <= TRANSPORT a_G54  ;
and1_52: n_92 <=  gnd;
delay_53: n_93  <= TRANSPORT n_94;
xor2_54: n_94 <=  n_95  XOR n_99;
or1_55: n_95 <=  n_96;
and1_56: n_96 <=  n_97;
delay_57: n_97  <= TRANSPORT a_G209  ;
and1_58: n_99 <=  gnd;
delay_59: n_100  <= TRANSPORT n_101;
xor2_60: n_101 <=  n_102  XOR n_106;
or1_61: n_102 <=  n_103;
and1_62: n_103 <=  n_104;
delay_63: n_104  <= TRANSPORT a_G76  ;
and1_64: n_106 <=  gnd;
delay_65: n_107  <= TRANSPORT n_108;
xor2_66: n_108 <=  n_109  XOR n_113;
or1_67: n_109 <=  n_110;
and1_68: n_110 <=  n_111;
delay_69: n_111  <= TRANSPORT a_G266  ;
and1_70: n_113 <=  gnd;
delay_71: n_114  <= TRANSPORT n_115;
xor2_72: n_115 <=  n_116  XOR n_120;
or1_73: n_116 <=  n_117;
and1_74: n_117 <=  n_118;
delay_75: n_118  <= TRANSPORT a_STXDATA  ;
and1_76: n_120 <=  gnd;
delay_77: n_121  <= TRANSPORT n_122;
xor2_78: n_122 <=  n_123  XOR n_127;
or1_79: n_123 <=  n_124;
and1_80: n_124 <=  n_125;
delay_81: n_125  <= TRANSPORT a_SRTS  ;
and1_82: n_127 <=  gnd;
delay_83: n_128  <= TRANSPORT n_129;
xor2_84: n_129 <=  n_130  XOR n_134;
or1_85: n_130 <=  n_131;
and1_86: n_131 <=  n_132;
inv_87: n_132  <= TRANSPORT NOT a_SIRQ_N_aNOT  ;
and1_88: n_134 <=  gnd;
dff_89: DFF_a6850

    PORT MAP ( D => a_EQ200, CLK => a_SINT_DI_F0_G_aCLK, CLRN => a_SINT_DI_F0_G_aCLRN,
          PRN => vcc, Q => a_SINT_DI_F0_G);
delay_90: a_SINT_DI_F0_G_aCLRN  <= TRANSPORT nRESET  ;
xor2_91: a_EQ200 <=  n_143  XOR n_152;
or2_92: n_143 <=  n_144  OR n_148;
and2_93: n_144 <=  n_145  AND n_146;
delay_94: n_145  <= TRANSPORT a_SINT_DI_F0_G  ;
inv_95: n_146  <= TRANSPORT NOT E  ;
and2_96: n_148 <=  n_149  AND n_151;
delay_97: n_149  <= TRANSPORT DI(0)  ;
delay_98: n_151  <= TRANSPORT E  ;
and1_99: n_152 <=  gnd;
delay_100: n_153  <= TRANSPORT TXCLK  ;
filter_101: FILTER_a6850

    PORT MAP (IN1 => n_153, Y => a_SINT_DI_F0_G_aCLK);
dff_102: DFF_a6850

    PORT MAP ( D => a_EQ207, CLK => a_SINT_DI_F7_G_aCLK, CLRN => a_SINT_DI_F7_G_aCLRN,
          PRN => vcc, Q => a_SINT_DI_F7_G);
delay_103: a_SINT_DI_F7_G_aCLRN  <= TRANSPORT nRESET  ;
xor2_104: a_EQ207 <=  n_167  XOR n_174;
or2_105: n_167 <=  n_168  OR n_171;
and2_106: n_168 <=  n_169  AND n_170;
delay_107: n_169  <= TRANSPORT a_SINT_DI_F7_G  ;
inv_108: n_170  <= TRANSPORT NOT E  ;
and2_109: n_171 <=  n_172  AND n_173;
delay_110: n_172  <= TRANSPORT DI(7)  ;
delay_111: n_173  <= TRANSPORT E  ;
and1_112: n_174 <=  gnd;
delay_113: n_175  <= TRANSPORT TXCLK  ;
filter_114: FILTER_a6850

    PORT MAP (IN1 => n_175, Y => a_SINT_DI_F7_G_aCLK);
delay_115: a_LC6_A12  <= TRANSPORT a_EQ018  ;
xor2_116: a_EQ018 <=  n_180  XOR n_225;
or8_117: n_180 <=  n_181  OR n_190  OR n_195  OR n_200  OR n_205  OR n_210
           OR n_215  OR n_220;
and4_118: n_181 <=  n_182  AND n_184  AND n_186  AND n_188;
delay_119: n_182  <= TRANSPORT a_STX_REG_DATA_F6_G  ;
inv_120: n_184  <= TRANSPORT NOT a_STX_REG_DATA_F5_G  ;
delay_121: n_186  <= TRANSPORT a_STX_REG_DATA_F3_G  ;
delay_122: n_188  <= TRANSPORT a_STX_REG_DATA_F4_G  ;
and4_123: n_190 <=  n_191  AND n_192  AND n_193  AND n_194;
inv_124: n_191  <= TRANSPORT NOT a_STX_REG_DATA_F6_G  ;
delay_125: n_192  <= TRANSPORT a_STX_REG_DATA_F5_G  ;
delay_126: n_193  <= TRANSPORT a_STX_REG_DATA_F3_G  ;
delay_127: n_194  <= TRANSPORT a_STX_REG_DATA_F4_G  ;
and4_128: n_195 <=  n_196  AND n_197  AND n_198  AND n_199;
inv_129: n_196  <= TRANSPORT NOT a_STX_REG_DATA_F6_G  ;
inv_130: n_197  <= TRANSPORT NOT a_STX_REG_DATA_F5_G  ;
inv_131: n_198  <= TRANSPORT NOT a_STX_REG_DATA_F3_G  ;
delay_132: n_199  <= TRANSPORT a_STX_REG_DATA_F4_G  ;
and4_133: n_200 <=  n_201  AND n_202  AND n_203  AND n_204;
delay_134: n_201  <= TRANSPORT a_STX_REG_DATA_F6_G  ;
delay_135: n_202  <= TRANSPORT a_STX_REG_DATA_F5_G  ;
inv_136: n_203  <= TRANSPORT NOT a_STX_REG_DATA_F3_G  ;
delay_137: n_204  <= TRANSPORT a_STX_REG_DATA_F4_G  ;
and4_138: n_205 <=  n_206  AND n_207  AND n_208  AND n_209;
delay_139: n_206  <= TRANSPORT a_STX_REG_DATA_F6_G  ;
inv_140: n_207  <= TRANSPORT NOT a_STX_REG_DATA_F5_G  ;
inv_141: n_208  <= TRANSPORT NOT a_STX_REG_DATA_F3_G  ;
inv_142: n_209  <= TRANSPORT NOT a_STX_REG_DATA_F4_G  ;
and4_143: n_210 <=  n_211  AND n_212  AND n_213  AND n_214;
inv_144: n_211  <= TRANSPORT NOT a_STX_REG_DATA_F6_G  ;
delay_145: n_212  <= TRANSPORT a_STX_REG_DATA_F5_G  ;
inv_146: n_213  <= TRANSPORT NOT a_STX_REG_DATA_F3_G  ;
inv_147: n_214  <= TRANSPORT NOT a_STX_REG_DATA_F4_G  ;
and4_148: n_215 <=  n_216  AND n_217  AND n_218  AND n_219;
inv_149: n_216  <= TRANSPORT NOT a_STX_REG_DATA_F6_G  ;
inv_150: n_217  <= TRANSPORT NOT a_STX_REG_DATA_F5_G  ;
delay_151: n_218  <= TRANSPORT a_STX_REG_DATA_F3_G  ;
inv_152: n_219  <= TRANSPORT NOT a_STX_REG_DATA_F4_G  ;
and4_153: n_220 <=  n_221  AND n_222  AND n_223  AND n_224;
delay_154: n_221  <= TRANSPORT a_STX_REG_DATA_F6_G  ;
delay_155: n_222  <= TRANSPORT a_STX_REG_DATA_F5_G  ;
delay_156: n_223  <= TRANSPORT a_STX_REG_DATA_F3_G  ;
inv_157: n_224  <= TRANSPORT NOT a_STX_REG_DATA_F4_G  ;
and1_158: n_225 <=  gnd;
delay_159: a_LC2_A2  <= TRANSPORT a_EQ019  ;
xor2_160: a_EQ019 <=  n_228  XOR n_272;
or8_161: n_228 <=  n_229  OR n_237  OR n_242  OR n_247  OR n_252  OR n_257
           OR n_262  OR n_267;
and4_162: n_229 <=  n_230  AND n_232  AND n_234  AND n_236;
inv_163: n_230  <= TRANSPORT NOT a_STX_REG_DATA_F2_G  ;
inv_164: n_232  <= TRANSPORT NOT a_STX_REG_DATA_F0_G  ;
inv_165: n_234  <= TRANSPORT NOT a_STX_REG_DATA_F1_G  ;
delay_166: n_236  <= TRANSPORT a_LC6_A12  ;
and4_167: n_237 <=  n_238  AND n_239  AND n_240  AND n_241;
delay_168: n_238  <= TRANSPORT a_STX_REG_DATA_F2_G  ;
delay_169: n_239  <= TRANSPORT a_STX_REG_DATA_F0_G  ;
inv_170: n_240  <= TRANSPORT NOT a_STX_REG_DATA_F1_G  ;
delay_171: n_241  <= TRANSPORT a_LC6_A12  ;
and4_172: n_242 <=  n_243  AND n_244  AND n_245  AND n_246;
delay_173: n_243  <= TRANSPORT a_STX_REG_DATA_F2_G  ;
inv_174: n_244  <= TRANSPORT NOT a_STX_REG_DATA_F0_G  ;
delay_175: n_245  <= TRANSPORT a_STX_REG_DATA_F1_G  ;
delay_176: n_246  <= TRANSPORT a_LC6_A12  ;
and4_177: n_247 <=  n_248  AND n_249  AND n_250  AND n_251;
inv_178: n_248  <= TRANSPORT NOT a_STX_REG_DATA_F2_G  ;
delay_179: n_249  <= TRANSPORT a_STX_REG_DATA_F0_G  ;
delay_180: n_250  <= TRANSPORT a_STX_REG_DATA_F1_G  ;
delay_181: n_251  <= TRANSPORT a_LC6_A12  ;
and4_182: n_252 <=  n_253  AND n_254  AND n_255  AND n_256;
inv_183: n_253  <= TRANSPORT NOT a_STX_REG_DATA_F2_G  ;
inv_184: n_254  <= TRANSPORT NOT a_STX_REG_DATA_F0_G  ;
delay_185: n_255  <= TRANSPORT a_STX_REG_DATA_F1_G  ;
inv_186: n_256  <= TRANSPORT NOT a_LC6_A12  ;
and4_187: n_257 <=  n_258  AND n_259  AND n_260  AND n_261;
delay_188: n_258  <= TRANSPORT a_STX_REG_DATA_F2_G  ;
delay_189: n_259  <= TRANSPORT a_STX_REG_DATA_F0_G  ;
delay_190: n_260  <= TRANSPORT a_STX_REG_DATA_F1_G  ;
inv_191: n_261  <= TRANSPORT NOT a_LC6_A12  ;
and4_192: n_262 <=  n_263  AND n_264  AND n_265  AND n_266;
delay_193: n_263  <= TRANSPORT a_STX_REG_DATA_F2_G  ;
inv_194: n_264  <= TRANSPORT NOT a_STX_REG_DATA_F0_G  ;
inv_195: n_265  <= TRANSPORT NOT a_STX_REG_DATA_F1_G  ;
inv_196: n_266  <= TRANSPORT NOT a_LC6_A12  ;
and4_197: n_267 <=  n_268  AND n_269  AND n_270  AND n_271;
inv_198: n_268  <= TRANSPORT NOT a_STX_REG_DATA_F2_G  ;
delay_199: n_269  <= TRANSPORT a_STX_REG_DATA_F0_G  ;
inv_200: n_270  <= TRANSPORT NOT a_STX_REG_DATA_F1_G  ;
inv_201: n_271  <= TRANSPORT NOT a_LC6_A12  ;
and1_202: n_272 <=  gnd;
delay_203: a_LC3_A16  <= TRANSPORT a_EQ017  ;
xor2_204: a_EQ017 <=  n_275  XOR n_295;
or4_205: n_275 <=  n_276  OR n_283  OR n_287  OR n_290;
and3_206: n_276 <=  n_277  AND n_279  AND n_281;
inv_207: n_277  <= TRANSPORT NOT a_N892  ;
inv_208: n_279  <= TRANSPORT NOT a_STX_REG_DATA_F7_G  ;
delay_209: n_281  <= TRANSPORT word_lngth  ;
and2_210: n_283 <=  n_284  AND n_286;
inv_211: n_284  <= TRANSPORT NOT a_N893  ;
inv_212: n_286  <= TRANSPORT NOT word_lngth  ;
and2_213: n_287 <=  n_288  AND n_289;
inv_214: n_288  <= TRANSPORT NOT a_N893  ;
inv_215: n_289  <= TRANSPORT NOT a_STX_REG_DATA_F7_G  ;
and4_216: n_290 <=  n_291  AND n_292  AND n_293  AND n_294;
delay_217: n_291  <= TRANSPORT a_N892  ;
delay_218: n_292  <= TRANSPORT a_N893  ;
delay_219: n_293  <= TRANSPORT a_STX_REG_DATA_F7_G  ;
delay_220: n_294  <= TRANSPORT word_lngth  ;
and1_221: n_295 <=  gnd;
dff_222: DFF_a6850

    PORT MAP ( D => a_EQ198, CLK => a_N1015_aCLK, CLRN => a_N1015_aCLRN, PRN => vcc,
          Q => a_N1015);
delay_223: a_N1015_aCLRN  <= TRANSPORT nRESET  ;
xor2_224: a_EQ198 <=  n_303  XOR n_316;
or3_225: n_303 <=  n_304  OR n_308  OR n_312;
and2_226: n_304 <=  n_305  AND n_307;
inv_227: n_305  <= TRANSPORT NOT a_N597  ;
delay_228: n_307  <= TRANSPORT a_N1015  ;
and3_229: n_308 <=  n_309  AND n_310  AND n_311;
delay_230: n_309  <= TRANSPORT a_N597  ;
inv_231: n_310  <= TRANSPORT NOT a_LC2_A2  ;
inv_232: n_311  <= TRANSPORT NOT a_LC3_A16  ;
and3_233: n_312 <=  n_313  AND n_314  AND n_315;
delay_234: n_313  <= TRANSPORT a_N597  ;
delay_235: n_314  <= TRANSPORT a_LC2_A2  ;
delay_236: n_315  <= TRANSPORT a_LC3_A16  ;
and1_237: n_316 <=  gnd;
inv_238: n_317  <= TRANSPORT NOT TXCLK  ;
filter_239: FILTER_a6850

    PORT MAP (IN1 => n_317, Y => a_N1015_aCLK);
delay_240: a_LC4_A13  <= TRANSPORT a_EQ076  ;
xor2_241: a_EQ076 <=  n_321  XOR n_331;
or2_242: n_321 <=  n_322  OR n_327;
and2_243: n_322 <=  n_323  AND n_325;
delay_244: n_323  <= TRANSPORT a_N221  ;
inv_245: n_325  <= TRANSPORT NOT a_N222  ;
and2_246: n_327 <=  n_328  AND n_330;
delay_247: n_328  <= TRANSPORT a_N606_aNOT  ;
delay_248: n_330  <= TRANSPORT a_N221  ;
and1_249: n_331 <=  gnd;
delay_250: a_N226_aNOT  <= TRANSPORT a_EQ081  ;
xor2_251: a_EQ081 <=  n_334  XOR n_345;
or3_252: n_334 <=  n_335  OR n_340  OR n_343;
and2_253: n_335 <=  n_336  AND n_338;
inv_254: n_336  <= TRANSPORT NOT a_N640_aNOT  ;
delay_255: n_338  <= TRANSPORT a_N591  ;
and1_256: n_340 <=  n_341;
delay_257: n_341  <= TRANSPORT a_N587_aNOT  ;
and1_258: n_343 <=  n_344;
delay_259: n_344  <= TRANSPORT a_N606_aNOT  ;
and1_260: n_345 <=  gnd;
delay_261: a_N632  <= TRANSPORT a_N632_aIN  ;
xor2_262: a_N632_aIN <=  n_348  XOR n_355;
or1_263: n_348 <=  n_349;
and4_264: n_349 <=  n_350  AND n_351  AND n_353  AND n_354;
inv_265: n_350  <= TRANSPORT NOT a_N606_aNOT  ;
inv_266: n_351  <= TRANSPORT NOT a_N219  ;
inv_267: n_353  <= TRANSPORT NOT a_N221  ;
delay_268: n_354  <= TRANSPORT a_N222  ;
and1_269: n_355 <=  gnd;
dff_270: DFF_a6850

    PORT MAP ( D => a_EQ077, CLK => a_N221_aCLK, CLRN => a_N221_aCLRN, PRN => vcc,
          Q => a_N221);
delay_271: a_N221_aCLRN  <= TRANSPORT nRESET  ;
xor2_272: a_EQ077 <=  n_362  XOR n_371;
or2_273: n_362 <=  n_363  OR n_368;
and3_274: n_363 <=  n_364  AND n_366  AND n_367;
delay_275: n_364  <= TRANSPORT a_N627_aNOT  ;
delay_276: n_366  <= TRANSPORT a_LC4_A13  ;
delay_277: n_367  <= TRANSPORT a_N226_aNOT  ;
and2_278: n_368 <=  n_369  AND n_370;
delay_279: n_369  <= TRANSPORT a_N627_aNOT  ;
delay_280: n_370  <= TRANSPORT a_N632  ;
and1_281: n_371 <=  gnd;
inv_282: n_372  <= TRANSPORT NOT TXCLK  ;
filter_283: FILTER_a6850

    PORT MAP (IN1 => n_372, Y => a_N221_aCLK);
delay_284: a_N229  <= TRANSPORT a_N229_aIN  ;
xor2_285: a_N229_aIN <=  n_376  XOR n_381;
or1_286: n_376 <=  n_377;
and3_287: n_377 <=  n_378  AND n_379  AND n_380;
inv_288: n_378  <= TRANSPORT NOT a_N640_aNOT  ;
inv_289: n_379  <= TRANSPORT NOT a_N587_aNOT  ;
delay_290: n_380  <= TRANSPORT a_N591  ;
and1_291: n_381 <=  gnd;
delay_292: a_N218_aNOT  <= TRANSPORT a_EQ074  ;
xor2_293: a_EQ074 <=  n_384  XOR n_393;
or2_294: n_384 <=  n_385  OR n_389;
and3_295: n_385 <=  n_386  AND n_387  AND n_388;
delay_296: n_386  <= TRANSPORT a_N606_aNOT  ;
delay_297: n_387  <= TRANSPORT a_N221  ;
delay_298: n_388  <= TRANSPORT a_N222  ;
and3_299: n_389 <=  n_390  AND n_391  AND n_392;
delay_300: n_390  <= TRANSPORT a_N606_aNOT  ;
inv_301: n_391  <= TRANSPORT NOT a_N219  ;
delay_302: n_392  <= TRANSPORT a_N222  ;
and1_303: n_393 <=  gnd;
delay_304: a_LC2_A17  <= TRANSPORT a_EQ079  ;
xor2_305: a_EQ079 <=  n_396  XOR n_409;
or3_306: n_396 <=  n_397  OR n_400  OR n_404;
and2_307: n_397 <=  n_398  AND n_399;
delay_308: n_398  <= TRANSPORT a_N606_aNOT  ;
delay_309: n_399  <= TRANSPORT a_N222  ;
and2_310: n_400 <=  n_401  AND n_402;
inv_311: n_401  <= TRANSPORT NOT a_N606_aNOT  ;
delay_312: n_402  <= TRANSPORT a_SSTS_REG_F1_G_aNOT  ;
and3_313: n_404 <=  n_405  AND n_406  AND n_408;
inv_314: n_405  <= TRANSPORT NOT a_N606_aNOT  ;
inv_315: n_406  <= TRANSPORT NOT a_N593  ;
inv_316: n_408  <= TRANSPORT NOT a_N222  ;
and1_317: n_409 <=  gnd;
delay_318: a_LC4_A17  <= TRANSPORT a_EQ080  ;
xor2_319: a_EQ080 <=  n_412  XOR n_422;
or3_320: n_412 <=  n_413  OR n_415  OR n_419;
and1_321: n_413 <=  n_414;
delay_322: n_414  <= TRANSPORT a_N218_aNOT  ;
and2_323: n_415 <=  n_416  AND n_418;
delay_324: n_416  <= TRANSPORT a_N604  ;
delay_325: n_418  <= TRANSPORT a_LC2_A17  ;
and1_326: n_419 <=  n_420;
delay_327: n_420  <= TRANSPORT a_N633  ;
and1_328: n_422 <=  gnd;
dff_329: DFF_a6850

    PORT MAP ( D => a_EQ078, CLK => a_N222_aCLK, CLRN => a_N222_aCLRN, PRN => vcc,
          Q => a_N222);
delay_330: a_N222_aCLRN  <= TRANSPORT nRESET  ;
xor2_331: a_EQ078 <=  n_429  XOR n_436;
or2_332: n_429 <=  n_430  OR n_433;
and2_333: n_430 <=  n_431  AND n_432;
delay_334: n_431  <= TRANSPORT a_N627_aNOT  ;
delay_335: n_432  <= TRANSPORT a_N229  ;
and2_336: n_433 <=  n_434  AND n_435;
delay_337: n_434  <= TRANSPORT a_N627_aNOT  ;
delay_338: n_435  <= TRANSPORT a_LC4_A17  ;
and1_339: n_436 <=  gnd;
inv_340: n_437  <= TRANSPORT NOT TXCLK  ;
filter_341: FILTER_a6850

    PORT MAP (IN1 => n_437, Y => a_N222_aCLK);
dff_342: DFF_a6850

    PORT MAP ( D => a_EQ192, CLK => a_N894_aCLK, CLRN => a_N894_aCLRN, PRN => vcc,
          Q => a_N894);
delay_343: a_N894_aCLRN  <= TRANSPORT nRESET  ;
xor2_344: a_EQ192 <=  n_446  XOR n_460;
or3_345: n_446 <=  n_447  OR n_451  OR n_455;
and2_346: n_447 <=  n_448  AND n_449;
delay_347: n_448  <= TRANSPORT a_N894  ;
delay_348: n_449  <= TRANSPORT a_N951  ;
and2_349: n_451 <=  n_452  AND n_453;
delay_350: n_452  <= TRANSPORT a_N894  ;
inv_351: n_453  <= TRANSPORT NOT a_N949  ;
and3_352: n_455 <=  n_456  AND n_458  AND n_459;
delay_353: n_456  <= TRANSPORT a_SINT_DI_F1_G  ;
inv_354: n_458  <= TRANSPORT NOT a_N951  ;
delay_355: n_459  <= TRANSPORT a_N949  ;
and1_356: n_460 <=  gnd;
inv_357: n_461  <= TRANSPORT NOT RXCLK  ;
filter_358: FILTER_a6850

    PORT MAP (IN1 => n_461, Y => a_N894_aCLK);
dff_359: DFF_a6850

    PORT MAP ( D => a_EQ193, CLK => a_N895_aCLK, CLRN => a_N895_aCLRN, PRN => vcc,
          Q => a_N895);
delay_360: a_N895_aCLRN  <= TRANSPORT nRESET  ;
xor2_361: a_EQ193 <=  n_471  XOR n_482;
or3_362: n_471 <=  n_472  OR n_475  OR n_478;
and2_363: n_472 <=  n_473  AND n_474;
delay_364: n_473  <= TRANSPORT a_N895  ;
delay_365: n_474  <= TRANSPORT a_N951  ;
and2_366: n_475 <=  n_476  AND n_477;
delay_367: n_476  <= TRANSPORT a_N895  ;
inv_368: n_477  <= TRANSPORT NOT a_N949  ;
and3_369: n_478 <=  n_479  AND n_480  AND n_481;
delay_370: n_479  <= TRANSPORT a_SINT_DI_F0_G  ;
inv_371: n_480  <= TRANSPORT NOT a_N951  ;
delay_372: n_481  <= TRANSPORT a_N949  ;
and1_373: n_482 <=  gnd;
inv_374: n_483  <= TRANSPORT NOT RXCLK  ;
filter_375: FILTER_a6850

    PORT MAP (IN1 => n_483, Y => a_N895_aCLK);
dff_376: DFF_a6850

    PORT MAP ( D => a_EQ001, CLK => rx_irq_en_aCLK, CLRN => rx_irq_en_aCLRN,
          PRN => vcc, Q => rx_irq_en);
delay_377: rx_irq_en_aCLRN  <= TRANSPORT nRESET  ;
xor2_378: a_EQ001 <=  n_492  XOR n_503;
or3_379: n_492 <=  n_493  OR n_497  OR n_500;
and3_380: n_493 <=  n_494  AND n_495  AND n_496;
delay_381: n_494  <= TRANSPORT a_SINT_DI_F7_G  ;
inv_382: n_495  <= TRANSPORT NOT a_N951  ;
delay_383: n_496  <= TRANSPORT a_N949  ;
and2_384: n_497 <=  n_498  AND n_499;
delay_385: n_498  <= TRANSPORT rx_irq_en  ;
delay_386: n_499  <= TRANSPORT a_N951  ;
and2_387: n_500 <=  n_501  AND n_502;
delay_388: n_501  <= TRANSPORT rx_irq_en  ;
inv_389: n_502  <= TRANSPORT NOT a_N949  ;
and1_390: n_503 <=  gnd;
inv_391: n_504  <= TRANSPORT NOT RXCLK  ;
filter_392: FILTER_a6850

    PORT MAP (IN1 => n_504, Y => rx_irq_en_aCLK);
dff_393: DFF_a6850

    PORT MAP ( D => a_EQ206, CLK => a_SINT_DI_F6_G_aCLK, CLRN => a_SINT_DI_F6_G_aCLRN,
          PRN => vcc, Q => a_SINT_DI_F6_G);
delay_394: a_SINT_DI_F6_G_aCLRN  <= TRANSPORT nRESET  ;
xor2_395: a_EQ206 <=  n_514  XOR n_521;
or2_396: n_514 <=  n_515  OR n_518;
and2_397: n_515 <=  n_516  AND n_517;
inv_398: n_516  <= TRANSPORT NOT E  ;
delay_399: n_517  <= TRANSPORT a_SINT_DI_F6_G  ;
and2_400: n_518 <=  n_519  AND n_520;
delay_401: n_519  <= TRANSPORT E  ;
delay_402: n_520  <= TRANSPORT DI(6)  ;
and1_403: n_521 <=  gnd;
delay_404: n_522  <= TRANSPORT TXCLK  ;
filter_405: FILTER_a6850

    PORT MAP (IN1 => n_522, Y => a_SINT_DI_F6_G_aCLK);
dff_406: DFF_a6850

    PORT MAP ( D => a_N951_aD, CLK => a_N951_aCLK, CLRN => a_N951_aCLRN, PRN => vcc,
          Q => a_N951);
delay_407: a_N951_aCLRN  <= TRANSPORT nRESET  ;
xor2_408: a_N951_aD <=  n_530  XOR n_537;
or1_409: n_530 <=  n_531;
and3_410: n_531 <=  n_532  AND n_534  AND n_535;
delay_411: n_532  <= TRANSPORT a_LC7_A21  ;
inv_412: n_534  <= TRANSPORT NOT RnW  ;
inv_413: n_535  <= TRANSPORT NOT RS  ;
and1_414: n_537 <=  gnd;
delay_415: n_538  <= TRANSPORT TXCLK  ;
filter_416: FILTER_a6850

    PORT MAP (IN1 => n_538, Y => a_N951_aCLK);
dff_417: DFF_a6850

    PORT MAP ( D => a_N949_aD, CLK => a_N949_aCLK, CLRN => a_N949_aCLRN, PRN => vcc,
          Q => a_N949);
delay_418: a_N949_aCLRN  <= TRANSPORT nRESET  ;
xor2_419: a_N949_aD <=  n_546  XOR n_549;
or1_420: n_546 <=  n_547;
and1_421: n_547 <=  n_548;
delay_422: n_548  <= TRANSPORT a_N951  ;
and1_423: n_549 <=  gnd;
inv_424: n_550  <= TRANSPORT NOT TXCLK  ;
filter_425: FILTER_a6850

    PORT MAP (IN1 => n_550, Y => a_N949_aCLK);
dff_426: DFF_a6850

    PORT MAP ( D => a_EQ205, CLK => a_SINT_DI_F5_G_aCLK, CLRN => a_SINT_DI_F5_G_aCLRN,
          PRN => vcc, Q => a_SINT_DI_F5_G);
delay_427: a_SINT_DI_F5_G_aCLRN  <= TRANSPORT nRESET  ;
xor2_428: a_EQ205 <=  n_560  XOR n_567;
or2_429: n_560 <=  n_561  OR n_564;
and2_430: n_561 <=  n_562  AND n_563;
inv_431: n_562  <= TRANSPORT NOT E  ;
delay_432: n_563  <= TRANSPORT a_SINT_DI_F5_G  ;
and2_433: n_564 <=  n_565  AND n_566;
delay_434: n_565  <= TRANSPORT E  ;
delay_435: n_566  <= TRANSPORT DI(5)  ;
and1_436: n_567 <=  gnd;
delay_437: n_568  <= TRANSPORT TXCLK  ;
filter_438: FILTER_a6850

    PORT MAP (IN1 => n_568, Y => a_SINT_DI_F5_G_aCLK);
delay_439: a_LC7_B16  <= TRANSPORT a_EQ085  ;
xor2_440: a_EQ085 <=  n_572  XOR n_586;
or3_441: n_572 <=  n_573  OR n_578  OR n_582;
and2_442: n_573 <=  n_574  AND n_576;
delay_443: n_574  <= TRANSPORT a_N498  ;
delay_444: n_576  <= TRANSPORT a_N499  ;
and3_445: n_578 <=  n_579  AND n_580  AND n_581;
inv_446: n_579  <= TRANSPORT NOT a_N593  ;
inv_447: n_580  <= TRANSPORT NOT a_N498  ;
inv_448: n_581  <= TRANSPORT NOT a_N499  ;
and2_449: n_582 <=  n_583  AND n_584;
inv_450: n_583  <= TRANSPORT NOT a_N499  ;
inv_451: n_584  <= TRANSPORT NOT a_N497  ;
and1_452: n_586 <=  gnd;
delay_453: a_N260_aNOT  <= TRANSPORT a_EQ086  ;
xor2_454: a_EQ086 <=  n_589  XOR n_598;
or2_455: n_589 <=  n_590  OR n_594;
and2_456: n_590 <=  n_591  AND n_593;
inv_457: n_591  <= TRANSPORT NOT a_N261_aNOT  ;
delay_458: n_593  <= TRANSPORT a_LC7_B16  ;
and2_459: n_594 <=  n_595  AND n_597;
inv_460: n_595  <= TRANSPORT NOT a_N495  ;
inv_461: n_597  <= TRANSPORT NOT a_N261_aNOT  ;
and1_462: n_598 <=  gnd;
delay_463: a_N315  <= TRANSPORT a_EQ096  ;
xor2_464: a_EQ096 <=  n_601  XOR n_612;
or2_465: n_601 <=  n_602  OR n_608;
and3_466: n_602 <=  n_603  AND n_604  AND n_606;
delay_467: n_603  <= TRANSPORT a_N627_aNOT  ;
inv_468: n_604  <= TRANSPORT NOT a_N57_aNOT  ;
delay_469: n_606  <= TRANSPORT a_SSTS_REG_F0_G  ;
and3_470: n_608 <=  n_609  AND n_610  AND n_611;
delay_471: n_609  <= TRANSPORT a_N627_aNOT  ;
inv_472: n_610  <= TRANSPORT NOT a_N57_aNOT  ;
inv_473: n_611  <= TRANSPORT NOT a_N260_aNOT  ;
and1_474: n_612 <=  gnd;
dff_475: DFF_a6850

    PORT MAP ( D => a_SSTS_REG_F0_G_aD, CLK => a_SSTS_REG_F0_G_aCLK, CLRN => a_SSTS_REG_F0_G_aCLRN,
          PRN => vcc, Q => a_SSTS_REG_F0_G);
delay_476: a_SSTS_REG_F0_G_aCLRN  <= TRANSPORT nRESET  ;
xor2_477: a_SSTS_REG_F0_G_aD <=  n_619  XOR n_622;
or1_478: n_619 <=  n_620;
and1_479: n_620 <=  n_621;
delay_480: n_621  <= TRANSPORT a_N315  ;
and1_481: n_622 <=  gnd;
delay_482: n_623  <= TRANSPORT RXCLK  ;
filter_483: FILTER_a6850

    PORT MAP (IN1 => n_623, Y => a_SSTS_REG_F0_G_aCLK);
delay_484: a_N595_aNOT  <= TRANSPORT a_EQ146  ;
xor2_485: a_EQ146 <=  n_627  XOR n_634;
or3_486: n_627 <=  n_628  OR n_630  OR n_632;
and1_487: n_628 <=  n_629;
delay_488: n_629  <= TRANSPORT a_N260_aNOT  ;
and1_489: n_630 <=  n_631;
delay_490: n_631  <= TRANSPORT a_SSTS_REG_F0_G  ;
and1_491: n_632 <=  n_633;
inv_492: n_633  <= TRANSPORT NOT a_N627_aNOT  ;
and1_493: n_634 <=  gnd;
delay_494: a_N304  <= TRANSPORT a_EQ092  ;
xor2_495: a_EQ092 <=  n_637  XOR n_650;
or3_496: n_637 <=  n_638  OR n_643  OR n_647;
and3_497: n_638 <=  n_639  AND n_640  AND n_642;
delay_498: n_639  <= TRANSPORT a_N591  ;
delay_499: n_640  <= TRANSPORT a_N778  ;
delay_500: n_642  <= TRANSPORT word_lngth  ;
and2_501: n_643 <=  n_644  AND n_646;
delay_502: n_644  <= TRANSPORT a_N777  ;
inv_503: n_646  <= TRANSPORT NOT word_lngth  ;
and2_504: n_647 <=  n_648  AND n_649;
inv_505: n_648  <= TRANSPORT NOT a_N591  ;
delay_506: n_649  <= TRANSPORT a_N777  ;
and1_507: n_650 <=  gnd;
dff_508: DFF_a6850

    PORT MAP ( D => a_EQ209, CLK => a_SREG_RXDATA_F0_G_aCLK, CLRN => a_SREG_RXDATA_F0_G_aCLRN,
          PRN => vcc, Q => a_SREG_RXDATA_F0_G);
delay_509: a_SREG_RXDATA_F0_G_aCLRN  <= TRANSPORT nRESET  ;
xor2_510: a_EQ209 <=  n_658  XOR n_667;
or2_511: n_658 <=  n_659  OR n_663;
and3_512: n_659 <=  n_660  AND n_661  AND n_662;
delay_513: n_660  <= TRANSPORT a_N627_aNOT  ;
delay_514: n_661  <= TRANSPORT a_N595_aNOT  ;
delay_515: n_662  <= TRANSPORT a_SREG_RXDATA_F0_G  ;
and3_516: n_663 <=  n_664  AND n_665  AND n_666;
delay_517: n_664  <= TRANSPORT a_N627_aNOT  ;
inv_518: n_665  <= TRANSPORT NOT a_N595_aNOT  ;
delay_519: n_666  <= TRANSPORT a_N304  ;
and1_520: n_667 <=  gnd;
delay_521: n_668  <= TRANSPORT RXCLK  ;
filter_522: FILTER_a6850

    PORT MAP (IN1 => n_668, Y => a_SREG_RXDATA_F0_G_aCLK);
delay_523: a_N256  <= TRANSPORT a_EQ084  ;
xor2_524: a_EQ084 <=  n_673  XOR n_683;
or3_525: n_673 <=  n_674  OR n_678  OR n_680;
and2_526: n_674 <=  n_675  AND n_677;
inv_527: n_675  <= TRANSPORT NOT a_N379_aNOT  ;
delay_528: n_677  <= TRANSPORT a_SSTS_REG_F1_G_aNOT  ;
and1_529: n_678 <=  n_679;
delay_530: n_679  <= TRANSPORT nCTS  ;
and1_531: n_680 <=  n_681;
inv_532: n_681  <= TRANSPORT NOT a_N618_aNOT  ;
and1_533: n_683 <=  gnd;
dff_534: DFF_a6850

    PORT MAP ( D => a_SSTS_REG_F1_G_aNOT_aD, CLK => a_SSTS_REG_F1_G_aNOT_aCLK,
          CLRN => a_SSTS_REG_F1_G_aNOT_aCLRN, PRN => vcc, Q => a_SSTS_REG_F1_G_aNOT);
delay_535: a_SSTS_REG_F1_G_aNOT_aCLRN  <= TRANSPORT nRESET  ;
xor2_536: a_SSTS_REG_F1_G_aNOT_aD <=  n_690  XOR n_694;
or1_537: n_690 <=  n_691;
and2_538: n_691 <=  n_692  AND n_693;
delay_539: n_692  <= TRANSPORT a_N627_aNOT  ;
delay_540: n_693  <= TRANSPORT a_N256  ;
and1_541: n_694 <=  gnd;
inv_542: n_695  <= TRANSPORT NOT TXCLK  ;
filter_543: FILTER_a6850

    PORT MAP (IN1 => n_695, Y => a_SSTS_REG_F1_G_aNOT_aCLK);
delay_544: a_N625_aNOT  <= TRANSPORT a_EQ161  ;
xor2_545: a_EQ161 <=  n_699  XOR n_711;
or3_546: n_699 <=  n_700  OR n_704  OR n_708;
and3_547: n_700 <=  n_701  AND n_702  AND n_703;
delay_548: n_701  <= TRANSPORT a_N591  ;
delay_549: n_702  <= TRANSPORT a_N777  ;
delay_550: n_703  <= TRANSPORT word_lngth  ;
and2_551: n_704 <=  n_705  AND n_707;
delay_552: n_705  <= TRANSPORT a_N776  ;
inv_553: n_707  <= TRANSPORT NOT word_lngth  ;
and2_554: n_708 <=  n_709  AND n_710;
inv_555: n_709  <= TRANSPORT NOT a_N591  ;
delay_556: n_710  <= TRANSPORT a_N776  ;
and1_557: n_711 <=  gnd;
dff_558: DFF_a6850

    PORT MAP ( D => a_EQ210, CLK => a_SREG_RXDATA_F1_G_aCLK, CLRN => a_SREG_RXDATA_F1_G_aCLRN,
          PRN => vcc, Q => a_SREG_RXDATA_F1_G);
delay_559: a_SREG_RXDATA_F1_G_aCLRN  <= TRANSPORT nRESET  ;
xor2_560: a_EQ210 <=  n_719  XOR n_728;
or2_561: n_719 <=  n_720  OR n_724;
and3_562: n_720 <=  n_721  AND n_722  AND n_723;
delay_563: n_721  <= TRANSPORT a_N627_aNOT  ;
delay_564: n_722  <= TRANSPORT a_N595_aNOT  ;
delay_565: n_723  <= TRANSPORT a_SREG_RXDATA_F1_G  ;
and3_566: n_724 <=  n_725  AND n_726  AND n_727;
delay_567: n_725  <= TRANSPORT a_N627_aNOT  ;
inv_568: n_726  <= TRANSPORT NOT a_N595_aNOT  ;
delay_569: n_727  <= TRANSPORT a_N625_aNOT  ;
and1_570: n_728 <=  gnd;
delay_571: n_729  <= TRANSPORT RXCLK  ;
filter_572: FILTER_a6850

    PORT MAP (IN1 => n_729, Y => a_SREG_RXDATA_F1_G_aCLK);
delay_573: a_N164  <= TRANSPORT a_EQ057  ;
xor2_574: a_EQ057 <=  n_733  XOR n_743;
or2_575: n_733 <=  n_734  OR n_739;
and2_576: n_734 <=  n_735  AND n_737;
inv_577: n_735  <= TRANSPORT NOT a_N339  ;
delay_578: n_737  <= TRANSPORT a_SSTS_REG_F2_G  ;
and2_579: n_739 <=  n_740  AND n_742;
inv_580: n_740  <= TRANSPORT NOT a_N337  ;
delay_581: n_742  <= TRANSPORT a_SSTS_REG_F2_G  ;
and1_582: n_743 <=  gnd;
dff_583: DFF_a6850

    PORT MAP ( D => a_EQ219, CLK => a_SSTS_REG_F2_G_aCLK, CLRN => a_SSTS_REG_F2_G_aCLRN,
          PRN => vcc, Q => a_SSTS_REG_F2_G);
delay_584: a_SSTS_REG_F2_G_aCLRN  <= TRANSPORT nRESET  ;
xor2_585: a_EQ219 <=  n_751  XOR n_757;
or2_586: n_751 <=  n_752  OR n_755;
and2_587: n_752 <=  n_753  AND n_754;
delay_588: n_753  <= TRANSPORT a_N627_aNOT  ;
delay_589: n_754  <= TRANSPORT a_N164  ;
and1_590: n_755 <=  n_756;
delay_591: n_756  <= TRANSPORT nDCD  ;
and1_592: n_757 <=  gnd;
delay_593: n_758  <= TRANSPORT RXCLK  ;
filter_594: FILTER_a6850

    PORT MAP (IN1 => n_758, Y => a_SSTS_REG_F2_G_aCLK);
delay_595: a_N624_aNOT  <= TRANSPORT a_EQ160  ;
xor2_596: a_EQ160 <=  n_762  XOR n_774;
or3_597: n_762 <=  n_763  OR n_767  OR n_771;
and3_598: n_763 <=  n_764  AND n_765  AND n_766;
delay_599: n_764  <= TRANSPORT a_N591  ;
delay_600: n_765  <= TRANSPORT a_N776  ;
delay_601: n_766  <= TRANSPORT word_lngth  ;
and2_602: n_767 <=  n_768  AND n_770;
delay_603: n_768  <= TRANSPORT a_N775  ;
inv_604: n_770  <= TRANSPORT NOT word_lngth  ;
and2_605: n_771 <=  n_772  AND n_773;
inv_606: n_772  <= TRANSPORT NOT a_N591  ;
delay_607: n_773  <= TRANSPORT a_N775  ;
and1_608: n_774 <=  gnd;
dff_609: DFF_a6850

    PORT MAP ( D => a_EQ211, CLK => a_SREG_RXDATA_F2_G_aCLK, CLRN => a_SREG_RXDATA_F2_G_aCLRN,
          PRN => vcc, Q => a_SREG_RXDATA_F2_G);
delay_610: a_SREG_RXDATA_F2_G_aCLRN  <= TRANSPORT nRESET  ;
xor2_611: a_EQ211 <=  n_782  XOR n_791;
or2_612: n_782 <=  n_783  OR n_787;
and3_613: n_783 <=  n_784  AND n_785  AND n_786;
delay_614: n_784  <= TRANSPORT a_N627_aNOT  ;
delay_615: n_785  <= TRANSPORT a_N595_aNOT  ;
delay_616: n_786  <= TRANSPORT a_SREG_RXDATA_F2_G  ;
and3_617: n_787 <=  n_788  AND n_789  AND n_790;
delay_618: n_788  <= TRANSPORT a_N627_aNOT  ;
inv_619: n_789  <= TRANSPORT NOT a_N595_aNOT  ;
delay_620: n_790  <= TRANSPORT a_N624_aNOT  ;
and1_621: n_791 <=  gnd;
delay_622: n_792  <= TRANSPORT RXCLK  ;
filter_623: FILTER_a6850

    PORT MAP (IN1 => n_792, Y => a_SREG_RXDATA_F2_G_aCLK);
dff_624: DFF_a6850

    PORT MAP ( D => a_SSTS_REG_F3_G_aD, CLK => a_SSTS_REG_F3_G_aCLK, CLRN => a_SSTS_REG_F3_G_aCLRN,
          PRN => vcc, Q => a_SSTS_REG_F3_G);
delay_625: a_SSTS_REG_F3_G_aCLRN  <= TRANSPORT nRESET  ;
xor2_626: a_SSTS_REG_F3_G_aD <=  n_801  XOR n_804;
or1_627: n_801 <=  n_802;
and1_628: n_802 <=  n_803;
delay_629: n_803  <= TRANSPORT nCTS  ;
and1_630: n_804 <=  gnd;
inv_631: n_805  <= TRANSPORT NOT TXCLK  ;
filter_632: FILTER_a6850

    PORT MAP (IN1 => n_805, Y => a_SSTS_REG_F3_G_aCLK);
delay_633: a_N623_aNOT  <= TRANSPORT a_EQ159  ;
xor2_634: a_EQ159 <=  n_809  XOR n_821;
or3_635: n_809 <=  n_810  OR n_814  OR n_818;
and3_636: n_810 <=  n_811  AND n_812  AND n_813;
delay_637: n_811  <= TRANSPORT a_N591  ;
delay_638: n_812  <= TRANSPORT a_N775  ;
delay_639: n_813  <= TRANSPORT word_lngth  ;
and2_640: n_814 <=  n_815  AND n_817;
delay_641: n_815  <= TRANSPORT a_N774  ;
inv_642: n_817  <= TRANSPORT NOT word_lngth  ;
and2_643: n_818 <=  n_819  AND n_820;
inv_644: n_819  <= TRANSPORT NOT a_N591  ;
delay_645: n_820  <= TRANSPORT a_N774  ;
and1_646: n_821 <=  gnd;
dff_647: DFF_a6850

    PORT MAP ( D => a_EQ212, CLK => a_SREG_RXDATA_F3_G_aCLK, CLRN => a_SREG_RXDATA_F3_G_aCLRN,
          PRN => vcc, Q => a_SREG_RXDATA_F3_G);
delay_648: a_SREG_RXDATA_F3_G_aCLRN  <= TRANSPORT nRESET  ;
xor2_649: a_EQ212 <=  n_829  XOR n_839;
or2_650: n_829 <=  n_830  OR n_835;
and3_651: n_830 <=  n_831  AND n_833  AND n_834;
delay_652: n_831  <= TRANSPORT a_N609  ;
delay_653: n_833  <= TRANSPORT a_N595_aNOT  ;
delay_654: n_834  <= TRANSPORT a_SREG_RXDATA_F3_G  ;
and3_655: n_835 <=  n_836  AND n_837  AND n_838;
delay_656: n_836  <= TRANSPORT a_N609  ;
inv_657: n_837  <= TRANSPORT NOT a_N595_aNOT  ;
delay_658: n_838  <= TRANSPORT a_N623_aNOT  ;
and1_659: n_839 <=  gnd;
delay_660: n_840  <= TRANSPORT RXCLK  ;
filter_661: FILTER_a6850

    PORT MAP (IN1 => n_840, Y => a_SREG_RXDATA_F3_G_aCLK);
delay_662: a_LC3_B17  <= TRANSPORT a_EQ099  ;
xor2_663: a_EQ099 <=  n_844  XOR n_854;
or2_664: n_844 <=  n_845  OR n_850;
and3_665: n_845 <=  n_846  AND n_847  AND n_848;
delay_666: n_846  <= TRANSPORT a_N627_aNOT  ;
delay_667: n_847  <= TRANSPORT a_N593  ;
delay_668: n_848  <= TRANSPORT a_LC3_B10  ;
and2_669: n_850 <=  n_851  AND n_852;
inv_670: n_851  <= TRANSPORT NOT a_N593  ;
delay_671: n_852  <= TRANSPORT a_N394  ;
and1_672: n_854 <=  gnd;
dff_673: DFF_a6850

    PORT MAP ( D => a_EQ220, CLK => a_SSTS_REG_F4_G_aCLK, CLRN => a_SSTS_REG_F4_G_aCLRN,
          PRN => vcc, Q => a_SSTS_REG_F4_G);
delay_674: a_SSTS_REG_F4_G_aCLRN  <= TRANSPORT nRESET  ;
xor2_675: a_EQ220 <=  n_862  XOR n_871;
or2_676: n_862 <=  n_863  OR n_867;
and3_677: n_863 <=  n_864  AND n_865  AND n_866;
delay_678: n_864  <= TRANSPORT a_N627_aNOT  ;
delay_679: n_865  <= TRANSPORT a_N595_aNOT  ;
delay_680: n_866  <= TRANSPORT a_SSTS_REG_F4_G  ;
and3_681: n_867 <=  n_868  AND n_869  AND n_870;
delay_682: n_868  <= TRANSPORT a_N627_aNOT  ;
inv_683: n_869  <= TRANSPORT NOT a_N595_aNOT  ;
delay_684: n_870  <= TRANSPORT a_LC3_B17  ;
and1_685: n_871 <=  gnd;
delay_686: n_872  <= TRANSPORT RXCLK  ;
filter_687: FILTER_a6850

    PORT MAP (IN1 => n_872, Y => a_SSTS_REG_F4_G_aCLK);
delay_688: a_N622_aNOT  <= TRANSPORT a_EQ158  ;
xor2_689: a_EQ158 <=  n_876  XOR n_888;
or3_690: n_876 <=  n_877  OR n_881  OR n_885;
and3_691: n_877 <=  n_878  AND n_879  AND n_880;
delay_692: n_878  <= TRANSPORT a_N591  ;
delay_693: n_879  <= TRANSPORT a_N774  ;
delay_694: n_880  <= TRANSPORT word_lngth  ;
and2_695: n_881 <=  n_882  AND n_884;
delay_696: n_882  <= TRANSPORT a_N773  ;
inv_697: n_884  <= TRANSPORT NOT word_lngth  ;
and2_698: n_885 <=  n_886  AND n_887;
inv_699: n_886  <= TRANSPORT NOT a_N591  ;
delay_700: n_887  <= TRANSPORT a_N773  ;
and1_701: n_888 <=  gnd;
dff_702: DFF_a6850

    PORT MAP ( D => a_EQ213, CLK => a_SREG_RXDATA_F4_G_aCLK, CLRN => a_SREG_RXDATA_F4_G_aCLRN,
          PRN => vcc, Q => a_SREG_RXDATA_F4_G);
delay_703: a_SREG_RXDATA_F4_G_aCLRN  <= TRANSPORT nRESET  ;
xor2_704: a_EQ213 <=  n_896  XOR n_905;
or2_705: n_896 <=  n_897  OR n_901;
and3_706: n_897 <=  n_898  AND n_899  AND n_900;
delay_707: n_898  <= TRANSPORT a_N609  ;
delay_708: n_899  <= TRANSPORT a_N595_aNOT  ;
delay_709: n_900  <= TRANSPORT a_SREG_RXDATA_F4_G  ;
and3_710: n_901 <=  n_902  AND n_903  AND n_904;
delay_711: n_902  <= TRANSPORT a_N609  ;
inv_712: n_903  <= TRANSPORT NOT a_N595_aNOT  ;
delay_713: n_904  <= TRANSPORT a_N622_aNOT  ;
and1_714: n_905 <=  gnd;
delay_715: n_906  <= TRANSPORT RXCLK  ;
filter_716: FILTER_a6850

    PORT MAP (IN1 => n_906, Y => a_SREG_RXDATA_F4_G_aCLK);
delay_717: a_N17_aNOT  <= TRANSPORT a_EQ020  ;
xor2_718: a_EQ020 <=  n_910  XOR n_919;
or2_719: n_910 <=  n_911  OR n_915;
and2_720: n_911 <=  n_912  AND n_913;
delay_721: n_912  <= TRANSPORT a_N595_aNOT  ;
delay_722: n_913  <= TRANSPORT a_SSTS_REG_F5_G  ;
and2_723: n_915 <=  n_916  AND n_918;
delay_724: n_916  <= TRANSPORT a_LC5_B14  ;
inv_725: n_918  <= TRANSPORT NOT a_SSTS_REG_F0_G  ;
and1_726: n_919 <=  gnd;
dff_727: DFF_a6850

    PORT MAP ( D => a_SSTS_REG_F5_G_aD, CLK => a_SSTS_REG_F5_G_aCLK, CLRN => a_SSTS_REG_F5_G_aCLRN,
          PRN => vcc, Q => a_SSTS_REG_F5_G);
delay_728: a_SSTS_REG_F5_G_aCLRN  <= TRANSPORT nRESET  ;
xor2_729: a_SSTS_REG_F5_G_aD <=  n_926  XOR n_930;
or1_730: n_926 <=  n_927;
and2_731: n_927 <=  n_928  AND n_929;
delay_732: n_928  <= TRANSPORT a_N627_aNOT  ;
delay_733: n_929  <= TRANSPORT a_N17_aNOT  ;
and1_734: n_930 <=  gnd;
delay_735: n_931  <= TRANSPORT RXCLK  ;
filter_736: FILTER_a6850

    PORT MAP (IN1 => n_931, Y => a_SSTS_REG_F5_G_aCLK);
delay_737: a_N621_aNOT  <= TRANSPORT a_EQ157  ;
xor2_738: a_EQ157 <=  n_935  XOR n_947;
or3_739: n_935 <=  n_936  OR n_940  OR n_944;
and3_740: n_936 <=  n_937  AND n_938  AND n_939;
delay_741: n_937  <= TRANSPORT a_N591  ;
delay_742: n_938  <= TRANSPORT a_N773  ;
delay_743: n_939  <= TRANSPORT word_lngth  ;
and2_744: n_940 <=  n_941  AND n_943;
delay_745: n_941  <= TRANSPORT a_N772  ;
inv_746: n_943  <= TRANSPORT NOT word_lngth  ;
and2_747: n_944 <=  n_945  AND n_946;
inv_748: n_945  <= TRANSPORT NOT a_N591  ;
delay_749: n_946  <= TRANSPORT a_N772  ;
and1_750: n_947 <=  gnd;
dff_751: DFF_a6850

    PORT MAP ( D => a_EQ214, CLK => a_SREG_RXDATA_F5_G_aCLK, CLRN => a_SREG_RXDATA_F5_G_aCLRN,
          PRN => vcc, Q => a_SREG_RXDATA_F5_G);
delay_752: a_SREG_RXDATA_F5_G_aCLRN  <= TRANSPORT nRESET  ;
xor2_753: a_EQ214 <=  n_955  XOR n_964;
or2_754: n_955 <=  n_956  OR n_960;
and3_755: n_956 <=  n_957  AND n_958  AND n_959;
delay_756: n_957  <= TRANSPORT a_N609  ;
delay_757: n_958  <= TRANSPORT a_N595_aNOT  ;
delay_758: n_959  <= TRANSPORT a_SREG_RXDATA_F5_G  ;
and3_759: n_960 <=  n_961  AND n_962  AND n_963;
delay_760: n_961  <= TRANSPORT a_N609  ;
inv_761: n_962  <= TRANSPORT NOT a_N595_aNOT  ;
delay_762: n_963  <= TRANSPORT a_N621_aNOT  ;
and1_763: n_964 <=  gnd;
delay_764: n_965  <= TRANSPORT RXCLK  ;
filter_765: FILTER_a6850

    PORT MAP (IN1 => n_965, Y => a_SREG_RXDATA_F5_G_aCLK);
delay_766: a_LC1_B13  <= TRANSPORT a_EQ175  ;
xor2_767: a_EQ175 <=  n_969  XOR n_985;
or4_768: n_969 <=  n_970  OR n_976  OR n_979  OR n_982;
and4_769: n_970 <=  n_971  AND n_972  AND n_973  AND n_974;
delay_770: n_971  <= TRANSPORT a_N893  ;
delay_771: n_972  <= TRANSPORT a_N591  ;
delay_772: n_973  <= TRANSPORT word_lngth  ;
delay_773: n_974  <= TRANSPORT a_N771  ;
and2_774: n_976 <=  n_977  AND n_978;
inv_775: n_977  <= TRANSPORT NOT a_N893  ;
inv_776: n_978  <= TRANSPORT NOT word_lngth  ;
and2_777: n_979 <=  n_980  AND n_981;
inv_778: n_980  <= TRANSPORT NOT a_N893  ;
inv_779: n_981  <= TRANSPORT NOT a_N591  ;
and2_780: n_982 <=  n_983  AND n_984;
inv_781: n_983  <= TRANSPORT NOT a_N893  ;
inv_782: n_984  <= TRANSPORT NOT a_N771  ;
and1_783: n_985 <=  gnd;
delay_784: a_N303  <= TRANSPORT a_EQ091  ;
xor2_785: a_EQ091 <=  n_988  XOR n_999;
or3_786: n_988 <=  n_989  OR n_993  OR n_996;
and3_787: n_989 <=  n_990  AND n_991  AND n_992;
delay_788: n_990  <= TRANSPORT a_N591  ;
delay_789: n_991  <= TRANSPORT a_N772  ;
delay_790: n_992  <= TRANSPORT word_lngth  ;
and2_791: n_993 <=  n_994  AND n_995;
inv_792: n_994  <= TRANSPORT NOT word_lngth  ;
delay_793: n_995  <= TRANSPORT a_N771  ;
and2_794: n_996 <=  n_997  AND n_998;
inv_795: n_997  <= TRANSPORT NOT a_N591  ;
delay_796: n_998  <= TRANSPORT a_N771  ;
and1_797: n_999 <=  gnd;
delay_798: a_LC3_B13  <= TRANSPORT a_EQ176  ;
xor2_799: a_EQ176 <=  n_1002  XOR n_1043;
or8_800: n_1002 <=  n_1003  OR n_1008  OR n_1013  OR n_1018  OR n_1023  OR n_1028
           OR n_1033  OR n_1038;
and4_801: n_1003 <=  n_1004  AND n_1005  AND n_1006  AND n_1007;
inv_802: n_1004  <= TRANSPORT NOT a_N304  ;
inv_803: n_1005  <= TRANSPORT NOT a_N621_aNOT  ;
inv_804: n_1006  <= TRANSPORT NOT a_LC1_B13  ;
inv_805: n_1007  <= TRANSPORT NOT a_N303  ;
and4_806: n_1008 <=  n_1009  AND n_1010  AND n_1011  AND n_1012;
delay_807: n_1009  <= TRANSPORT a_N304  ;
inv_808: n_1010  <= TRANSPORT NOT a_N621_aNOT  ;
delay_809: n_1011  <= TRANSPORT a_LC1_B13  ;
inv_810: n_1012  <= TRANSPORT NOT a_N303  ;
and4_811: n_1013 <=  n_1014  AND n_1015  AND n_1016  AND n_1017;
delay_812: n_1014  <= TRANSPORT a_N304  ;
delay_813: n_1015  <= TRANSPORT a_N621_aNOT  ;
inv_814: n_1016  <= TRANSPORT NOT a_LC1_B13  ;
inv_815: n_1017  <= TRANSPORT NOT a_N303  ;
and4_816: n_1018 <=  n_1019  AND n_1020  AND n_1021  AND n_1022;
inv_817: n_1019  <= TRANSPORT NOT a_N304  ;
delay_818: n_1020  <= TRANSPORT a_N621_aNOT  ;
delay_819: n_1021  <= TRANSPORT a_LC1_B13  ;
inv_820: n_1022  <= TRANSPORT NOT a_N303  ;
and4_821: n_1023 <=  n_1024  AND n_1025  AND n_1026  AND n_1027;
inv_822: n_1024  <= TRANSPORT NOT a_N304  ;
delay_823: n_1025  <= TRANSPORT a_N621_aNOT  ;
inv_824: n_1026  <= TRANSPORT NOT a_LC1_B13  ;
delay_825: n_1027  <= TRANSPORT a_N303  ;
and4_826: n_1028 <=  n_1029  AND n_1030  AND n_1031  AND n_1032;
delay_827: n_1029  <= TRANSPORT a_N304  ;
delay_828: n_1030  <= TRANSPORT a_N621_aNOT  ;
delay_829: n_1031  <= TRANSPORT a_LC1_B13  ;
delay_830: n_1032  <= TRANSPORT a_N303  ;
and4_831: n_1033 <=  n_1034  AND n_1035  AND n_1036  AND n_1037;
delay_832: n_1034  <= TRANSPORT a_N304  ;
inv_833: n_1035  <= TRANSPORT NOT a_N621_aNOT  ;
inv_834: n_1036  <= TRANSPORT NOT a_LC1_B13  ;
delay_835: n_1037  <= TRANSPORT a_N303  ;
and4_836: n_1038 <=  n_1039  AND n_1040  AND n_1041  AND n_1042;
inv_837: n_1039  <= TRANSPORT NOT a_N304  ;
inv_838: n_1040  <= TRANSPORT NOT a_N621_aNOT  ;
delay_839: n_1041  <= TRANSPORT a_LC1_B13  ;
delay_840: n_1042  <= TRANSPORT a_N303  ;
and1_841: n_1043 <=  gnd;
delay_842: a_LC6_B5  <= TRANSPORT a_EQ177  ;
xor2_843: a_EQ177 <=  n_1046  XOR n_1087;
or8_844: n_1046 <=  n_1047  OR n_1052  OR n_1057  OR n_1062  OR n_1067  OR n_1072
           OR n_1077  OR n_1082;
and4_845: n_1047 <=  n_1048  AND n_1049  AND n_1050  AND n_1051;
inv_846: n_1048  <= TRANSPORT NOT a_N625_aNOT  ;
delay_847: n_1049  <= TRANSPORT a_N624_aNOT  ;
delay_848: n_1050  <= TRANSPORT a_N622_aNOT  ;
inv_849: n_1051  <= TRANSPORT NOT a_LC3_B13  ;
and4_850: n_1052 <=  n_1053  AND n_1054  AND n_1055  AND n_1056;
delay_851: n_1053  <= TRANSPORT a_N625_aNOT  ;
inv_852: n_1054  <= TRANSPORT NOT a_N624_aNOT  ;
delay_853: n_1055  <= TRANSPORT a_N622_aNOT  ;
inv_854: n_1056  <= TRANSPORT NOT a_LC3_B13  ;
and4_855: n_1057 <=  n_1058  AND n_1059  AND n_1060  AND n_1061;
delay_856: n_1058  <= TRANSPORT a_N625_aNOT  ;
delay_857: n_1059  <= TRANSPORT a_N624_aNOT  ;
inv_858: n_1060  <= TRANSPORT NOT a_N622_aNOT  ;
inv_859: n_1061  <= TRANSPORT NOT a_LC3_B13  ;
and4_860: n_1062 <=  n_1063  AND n_1064  AND n_1065  AND n_1066;
inv_861: n_1063  <= TRANSPORT NOT a_N625_aNOT  ;
inv_862: n_1064  <= TRANSPORT NOT a_N624_aNOT  ;
inv_863: n_1065  <= TRANSPORT NOT a_N622_aNOT  ;
inv_864: n_1066  <= TRANSPORT NOT a_LC3_B13  ;
and4_865: n_1067 <=  n_1068  AND n_1069  AND n_1070  AND n_1071;
inv_866: n_1068  <= TRANSPORT NOT a_N625_aNOT  ;
delay_867: n_1069  <= TRANSPORT a_N624_aNOT  ;
inv_868: n_1070  <= TRANSPORT NOT a_N622_aNOT  ;
delay_869: n_1071  <= TRANSPORT a_LC3_B13  ;
and4_870: n_1072 <=  n_1073  AND n_1074  AND n_1075  AND n_1076;
delay_871: n_1073  <= TRANSPORT a_N625_aNOT  ;
inv_872: n_1074  <= TRANSPORT NOT a_N624_aNOT  ;
inv_873: n_1075  <= TRANSPORT NOT a_N622_aNOT  ;
delay_874: n_1076  <= TRANSPORT a_LC3_B13  ;
and4_875: n_1077 <=  n_1078  AND n_1079  AND n_1080  AND n_1081;
delay_876: n_1078  <= TRANSPORT a_N625_aNOT  ;
delay_877: n_1079  <= TRANSPORT a_N624_aNOT  ;
delay_878: n_1080  <= TRANSPORT a_N622_aNOT  ;
delay_879: n_1081  <= TRANSPORT a_LC3_B13  ;
and4_880: n_1082 <=  n_1083  AND n_1084  AND n_1085  AND n_1086;
inv_881: n_1083  <= TRANSPORT NOT a_N625_aNOT  ;
inv_882: n_1084  <= TRANSPORT NOT a_N624_aNOT  ;
delay_883: n_1085  <= TRANSPORT a_N622_aNOT  ;
delay_884: n_1086  <= TRANSPORT a_LC3_B13  ;
and1_885: n_1087 <=  gnd;
delay_886: a_LC1_B12  <= TRANSPORT a_EQ090  ;
xor2_887: a_EQ090 <=  n_1090  XOR n_1112;
or4_888: n_1090 <=  n_1091  OR n_1097  OR n_1102  OR n_1107;
and4_889: n_1091 <=  n_1092  AND n_1093  AND n_1095  AND n_1096;
delay_890: n_1092  <= TRANSPORT a_N591  ;
inv_891: n_1093  <= TRANSPORT NOT rx_parity  ;
delay_892: n_1095  <= TRANSPORT a_N623_aNOT  ;
delay_893: n_1096  <= TRANSPORT a_LC6_B5  ;
and4_894: n_1097 <=  n_1098  AND n_1099  AND n_1100  AND n_1101;
delay_895: n_1098  <= TRANSPORT a_N591  ;
delay_896: n_1099  <= TRANSPORT rx_parity  ;
inv_897: n_1100  <= TRANSPORT NOT a_N623_aNOT  ;
delay_898: n_1101  <= TRANSPORT a_LC6_B5  ;
and4_899: n_1102 <=  n_1103  AND n_1104  AND n_1105  AND n_1106;
delay_900: n_1103  <= TRANSPORT a_N591  ;
delay_901: n_1104  <= TRANSPORT rx_parity  ;
delay_902: n_1105  <= TRANSPORT a_N623_aNOT  ;
inv_903: n_1106  <= TRANSPORT NOT a_LC6_B5  ;
and4_904: n_1107 <=  n_1108  AND n_1109  AND n_1110  AND n_1111;
delay_905: n_1108  <= TRANSPORT a_N591  ;
inv_906: n_1109  <= TRANSPORT NOT rx_parity  ;
inv_907: n_1110  <= TRANSPORT NOT a_N623_aNOT  ;
inv_908: n_1111  <= TRANSPORT NOT a_LC6_B5  ;
and1_909: n_1112 <=  gnd;
dff_910: DFF_a6850

    PORT MAP ( D => a_EQ222, CLK => a_SSTS_REG_F6_G_aCLK, CLRN => a_SSTS_REG_F6_G_aCLRN,
          PRN => vcc, Q => a_SSTS_REG_F6_G);
delay_911: a_SSTS_REG_F6_G_aCLRN  <= TRANSPORT nRESET  ;
xor2_912: a_EQ222 <=  n_1120  XOR n_1129;
or2_913: n_1120 <=  n_1121  OR n_1125;
and3_914: n_1121 <=  n_1122  AND n_1123  AND n_1124;
delay_915: n_1122  <= TRANSPORT a_N627_aNOT  ;
delay_916: n_1123  <= TRANSPORT a_N595_aNOT  ;
delay_917: n_1124  <= TRANSPORT a_SSTS_REG_F6_G  ;
and3_918: n_1125 <=  n_1126  AND n_1127  AND n_1128;
delay_919: n_1126  <= TRANSPORT a_N627_aNOT  ;
inv_920: n_1127  <= TRANSPORT NOT a_N595_aNOT  ;
delay_921: n_1128  <= TRANSPORT a_LC1_B12  ;
and1_922: n_1129 <=  gnd;
delay_923: n_1130  <= TRANSPORT RXCLK  ;
filter_924: FILTER_a6850

    PORT MAP (IN1 => n_1130, Y => a_SSTS_REG_F6_G_aCLK);
dff_925: DFF_a6850

    PORT MAP ( D => a_EQ215, CLK => a_SREG_RXDATA_F6_G_aCLK, CLRN => a_SREG_RXDATA_F6_G_aCLRN,
          PRN => vcc, Q => a_SREG_RXDATA_F6_G);
delay_926: a_SREG_RXDATA_F6_G_aCLRN  <= TRANSPORT nRESET  ;
xor2_927: a_EQ215 <=  n_1139  XOR n_1148;
or2_928: n_1139 <=  n_1140  OR n_1144;
and3_929: n_1140 <=  n_1141  AND n_1142  AND n_1143;
delay_930: n_1141  <= TRANSPORT a_N627_aNOT  ;
delay_931: n_1142  <= TRANSPORT a_N595_aNOT  ;
delay_932: n_1143  <= TRANSPORT a_SREG_RXDATA_F6_G  ;
and3_933: n_1144 <=  n_1145  AND n_1146  AND n_1147;
delay_934: n_1145  <= TRANSPORT a_N627_aNOT  ;
inv_935: n_1146  <= TRANSPORT NOT a_N595_aNOT  ;
delay_936: n_1147  <= TRANSPORT a_N303  ;
and1_937: n_1148 <=  gnd;
delay_938: n_1149  <= TRANSPORT RXCLK  ;
filter_939: FILTER_a6850

    PORT MAP (IN1 => n_1149, Y => a_SREG_RXDATA_F6_G_aCLK);
delay_940: a_LC8_B12  <= TRANSPORT a_EQ089  ;
xor2_941: a_EQ089 <=  n_1153  XOR n_1162;
or2_942: n_1153 <=  n_1154  OR n_1158;
and3_943: n_1154 <=  n_1155  AND n_1156  AND n_1157;
inv_944: n_1155  <= TRANSPORT NOT a_N591  ;
delay_945: n_1156  <= TRANSPORT rx_parity  ;
delay_946: n_1157  <= TRANSPORT word_lngth  ;
and3_947: n_1158 <=  n_1159  AND n_1160  AND n_1161;
delay_948: n_1159  <= TRANSPORT a_N591  ;
delay_949: n_1160  <= TRANSPORT word_lngth  ;
delay_950: n_1161  <= TRANSPORT a_N771  ;
and1_951: n_1162 <=  gnd;
dff_952: DFF_a6850

    PORT MAP ( D => a_EQ216, CLK => a_SREG_RXDATA_F7_G_aCLK, CLRN => a_SREG_RXDATA_F7_G_aCLRN,
          PRN => vcc, Q => a_SREG_RXDATA_F7_G);
delay_953: a_SREG_RXDATA_F7_G_aCLRN  <= TRANSPORT nRESET  ;
xor2_954: a_EQ216 <=  n_1170  XOR n_1179;
or2_955: n_1170 <=  n_1171  OR n_1175;
and3_956: n_1171 <=  n_1172  AND n_1173  AND n_1174;
delay_957: n_1172  <= TRANSPORT a_N627_aNOT  ;
delay_958: n_1173  <= TRANSPORT a_N595_aNOT  ;
delay_959: n_1174  <= TRANSPORT a_SREG_RXDATA_F7_G  ;
and3_960: n_1175 <=  n_1176  AND n_1177  AND n_1178;
delay_961: n_1176  <= TRANSPORT a_N627_aNOT  ;
inv_962: n_1177  <= TRANSPORT NOT a_N595_aNOT  ;
delay_963: n_1178  <= TRANSPORT a_LC8_B12  ;
and1_964: n_1179 <=  gnd;
delay_965: n_1180  <= TRANSPORT RXCLK  ;
filter_966: FILTER_a6850

    PORT MAP (IN1 => n_1180, Y => a_SREG_RXDATA_F7_G_aCLK);
dff_967: DFF_a6850

    PORT MAP ( D => a_EQ188, CLK => a_N890_aCLK, CLRN => a_N890_aCLRN, PRN => vcc,
          Q => a_N890);
delay_968: a_N890_aCLRN  <= TRANSPORT nRESET  ;
xor2_969: a_EQ188 <=  n_1189  XOR n_1200;
or3_970: n_1189 <=  n_1190  OR n_1193  OR n_1196;
and2_971: n_1190 <=  n_1191  AND n_1192;
delay_972: n_1191  <= TRANSPORT a_N951  ;
delay_973: n_1192  <= TRANSPORT a_N890  ;
and2_974: n_1193 <=  n_1194  AND n_1195;
inv_975: n_1194  <= TRANSPORT NOT a_N949  ;
delay_976: n_1195  <= TRANSPORT a_N890  ;
and3_977: n_1196 <=  n_1197  AND n_1198  AND n_1199;
delay_978: n_1197  <= TRANSPORT a_SINT_DI_F6_G  ;
inv_979: n_1198  <= TRANSPORT NOT a_N951  ;
delay_980: n_1199  <= TRANSPORT a_N949  ;
and1_981: n_1200 <=  gnd;
inv_982: n_1201  <= TRANSPORT NOT RXCLK  ;
filter_983: FILTER_a6850

    PORT MAP (IN1 => n_1201, Y => a_N890_aCLK);
dff_984: DFF_a6850

    PORT MAP ( D => a_EQ189, CLK => a_N891_aCLK, CLRN => a_N891_aCLRN, PRN => vcc,
          Q => a_N891);
delay_985: a_N891_aCLRN  <= TRANSPORT nRESET  ;
xor2_986: a_EQ189 <=  n_1210  XOR n_1221;
or3_987: n_1210 <=  n_1211  OR n_1214  OR n_1217;
and2_988: n_1211 <=  n_1212  AND n_1213;
delay_989: n_1212  <= TRANSPORT a_N951  ;
delay_990: n_1213  <= TRANSPORT a_N891  ;
and2_991: n_1214 <=  n_1215  AND n_1216;
inv_992: n_1215  <= TRANSPORT NOT a_N949  ;
delay_993: n_1216  <= TRANSPORT a_N891  ;
and3_994: n_1217 <=  n_1218  AND n_1219  AND n_1220;
inv_995: n_1218  <= TRANSPORT NOT a_N951  ;
delay_996: n_1219  <= TRANSPORT a_N949  ;
delay_997: n_1220  <= TRANSPORT a_SINT_DI_F5_G  ;
and1_998: n_1221 <=  gnd;
inv_999: n_1222  <= TRANSPORT NOT RXCLK  ;
filter_1000: FILTER_a6850

    PORT MAP (IN1 => n_1222, Y => a_N891_aCLK);
delay_1001: a_G57  <= TRANSPORT a_EQ010  ;
xor2_1002: a_EQ010 <=  n_1225  XOR n_1232;
or2_1003: n_1225 <=  n_1226  OR n_1229;
and2_1004: n_1226 <=  n_1227  AND n_1228;
delay_1005: n_1227  <= TRANSPORT a_SSTS_REG_F0_G  ;
inv_1006: n_1228  <= TRANSPORT NOT RS  ;
and2_1007: n_1229 <=  n_1230  AND n_1231;
delay_1008: n_1230  <= TRANSPORT a_SREG_RXDATA_F0_G  ;
delay_1009: n_1231  <= TRANSPORT RS  ;
and1_1010: n_1232 <=  gnd;
delay_1011: a_G211  <= TRANSPORT a_EQ014  ;
xor2_1012: a_EQ014 <=  n_1234  XOR n_1241;
or2_1013: n_1234 <=  n_1235  OR n_1238;
and2_1014: n_1235 <=  n_1236  AND n_1237;
inv_1015: n_1236  <= TRANSPORT NOT a_SSTS_REG_F1_G_aNOT  ;
inv_1016: n_1237  <= TRANSPORT NOT RS  ;
and2_1017: n_1238 <=  n_1239  AND n_1240;
delay_1018: n_1239  <= TRANSPORT a_SREG_RXDATA_F1_G  ;
delay_1019: n_1240  <= TRANSPORT RS  ;
and1_1020: n_1241 <=  gnd;
delay_1021: a_G345  <= TRANSPORT a_EQ016  ;
xor2_1022: a_EQ016 <=  n_1243  XOR n_1250;
or2_1023: n_1243 <=  n_1244  OR n_1247;
and2_1024: n_1244 <=  n_1245  AND n_1246;
delay_1025: n_1245  <= TRANSPORT a_SSTS_REG_F2_G  ;
inv_1026: n_1246  <= TRANSPORT NOT RS  ;
and2_1027: n_1247 <=  n_1248  AND n_1249;
delay_1028: n_1248  <= TRANSPORT a_SREG_RXDATA_F2_G  ;
delay_1029: n_1249  <= TRANSPORT RS  ;
and1_1030: n_1250 <=  gnd;
delay_1031: a_G207  <= TRANSPORT a_EQ012  ;
xor2_1032: a_EQ012 <=  n_1252  XOR n_1259;
or2_1033: n_1252 <=  n_1253  OR n_1256;
and2_1034: n_1253 <=  n_1254  AND n_1255;
delay_1035: n_1254  <= TRANSPORT a_SSTS_REG_F3_G  ;
inv_1036: n_1255  <= TRANSPORT NOT RS  ;
and2_1037: n_1256 <=  n_1257  AND n_1258;
delay_1038: n_1257  <= TRANSPORT a_SREG_RXDATA_F3_G  ;
delay_1039: n_1258  <= TRANSPORT RS  ;
and1_1040: n_1259 <=  gnd;
delay_1041: a_G54  <= TRANSPORT a_EQ009  ;
xor2_1042: a_EQ009 <=  n_1261  XOR n_1268;
or2_1043: n_1261 <=  n_1262  OR n_1265;
and2_1044: n_1262 <=  n_1263  AND n_1264;
delay_1045: n_1263  <= TRANSPORT a_SSTS_REG_F4_G  ;
inv_1046: n_1264  <= TRANSPORT NOT RS  ;
and2_1047: n_1265 <=  n_1266  AND n_1267;
delay_1048: n_1266  <= TRANSPORT a_SREG_RXDATA_F4_G  ;
delay_1049: n_1267  <= TRANSPORT RS  ;
and1_1050: n_1268 <=  gnd;
delay_1051: a_G209  <= TRANSPORT a_EQ013  ;
xor2_1052: a_EQ013 <=  n_1270  XOR n_1277;
or2_1053: n_1270 <=  n_1271  OR n_1274;
and2_1054: n_1271 <=  n_1272  AND n_1273;
delay_1055: n_1272  <= TRANSPORT a_SSTS_REG_F5_G  ;
inv_1056: n_1273  <= TRANSPORT NOT RS  ;
and2_1057: n_1274 <=  n_1275  AND n_1276;
delay_1058: n_1275  <= TRANSPORT a_SREG_RXDATA_F5_G  ;
delay_1059: n_1276  <= TRANSPORT RS  ;
and1_1060: n_1277 <=  gnd;
delay_1061: a_G76  <= TRANSPORT a_EQ011  ;
xor2_1062: a_EQ011 <=  n_1279  XOR n_1286;
or2_1063: n_1279 <=  n_1280  OR n_1283;
and2_1064: n_1280 <=  n_1281  AND n_1282;
delay_1065: n_1281  <= TRANSPORT a_SSTS_REG_F6_G  ;
inv_1066: n_1282  <= TRANSPORT NOT RS  ;
and2_1067: n_1283 <=  n_1284  AND n_1285;
delay_1068: n_1284  <= TRANSPORT a_SREG_RXDATA_F6_G  ;
delay_1069: n_1285  <= TRANSPORT RS  ;
and1_1070: n_1286 <=  gnd;
delay_1071: a_LC5_B11  <= TRANSPORT a_EQ056  ;
xor2_1072: a_EQ056 <=  n_1289  XOR n_1297;
or3_1073: n_1289 <=  n_1290  OR n_1293  OR n_1295;
and2_1074: n_1290 <=  n_1291  AND n_1292;
delay_1075: n_1291  <= TRANSPORT a_N627_aNOT  ;
delay_1076: n_1292  <= TRANSPORT a_N164  ;
and1_1077: n_1293 <=  n_1294;
delay_1078: n_1294  <= TRANSPORT nDCD  ;
and1_1079: n_1295 <=  n_1296;
delay_1080: n_1296  <= TRANSPORT a_N315  ;
and1_1081: n_1297 <=  gnd;
dff_1082: DFF_a6850

    PORT MAP ( D => a_EQ179, CLK => a_N759_aCLK, CLRN => a_N759_aCLRN, PRN => vcc,
          Q => a_N759);
delay_1083: a_N759_aCLRN  <= TRANSPORT nRESET  ;
xor2_1084: a_EQ179 <=  n_1305  XOR n_1313;
or2_1085: n_1305 <=  n_1306  OR n_1310;
and3_1086: n_1306 <=  n_1307  AND n_1308  AND n_1309;
delay_1087: n_1307  <= TRANSPORT a_N627_aNOT  ;
delay_1088: n_1308  <= TRANSPORT rx_irq_en  ;
delay_1089: n_1309  <= TRANSPORT a_N17_aNOT  ;
and2_1090: n_1310 <=  n_1311  AND n_1312;
delay_1091: n_1311  <= TRANSPORT rx_irq_en  ;
delay_1092: n_1312  <= TRANSPORT a_LC5_B11  ;
and1_1093: n_1313 <=  gnd;
delay_1094: n_1314  <= TRANSPORT RXCLK  ;
filter_1095: FILTER_a6850

    PORT MAP (IN1 => n_1314, Y => a_N759_aCLK);
dff_1096: DFF_a6850

    PORT MAP ( D => a_EQ178, CLK => a_N758_aCLK, CLRN => a_N758_aCLRN, PRN => vcc,
          Q => a_N758);
delay_1097: a_N758_aCLRN  <= TRANSPORT nRESET  ;
xor2_1098: a_EQ178 <=  n_1323  XOR n_1332;
or2_1099: n_1323 <=  n_1324  OR n_1328;
and3_1100: n_1324 <=  n_1325  AND n_1326  AND n_1327;
inv_1101: n_1325  <= TRANSPORT NOT a_N256  ;
inv_1102: n_1326  <= TRANSPORT NOT a_N890  ;
delay_1103: n_1327  <= TRANSPORT a_N891  ;
and3_1104: n_1328 <=  n_1329  AND n_1330  AND n_1331;
inv_1105: n_1329  <= TRANSPORT NOT a_N627_aNOT  ;
inv_1106: n_1330  <= TRANSPORT NOT a_N890  ;
delay_1107: n_1331  <= TRANSPORT a_N891  ;
and1_1108: n_1332 <=  gnd;
inv_1109: n_1333  <= TRANSPORT NOT TXCLK  ;
filter_1110: FILTER_a6850

    PORT MAP (IN1 => n_1333, Y => a_N758_aCLK);
delay_1111: a_G266  <= TRANSPORT a_EQ015  ;
xor2_1112: a_EQ015 <=  n_1336  XOR n_1346;
or3_1113: n_1336 <=  n_1337  OR n_1340  OR n_1343;
and2_1114: n_1337 <=  n_1338  AND n_1339;
delay_1115: n_1338  <= TRANSPORT a_SREG_RXDATA_F7_G  ;
delay_1116: n_1339  <= TRANSPORT RS  ;
and2_1117: n_1340 <=  n_1341  AND n_1342;
inv_1118: n_1341  <= TRANSPORT NOT RS  ;
delay_1119: n_1342  <= TRANSPORT a_N759  ;
and2_1120: n_1343 <=  n_1344  AND n_1345;
inv_1121: n_1344  <= TRANSPORT NOT RS  ;
delay_1122: n_1345  <= TRANSPORT a_N758  ;
and1_1123: n_1346 <=  gnd;
delay_1124: a_N378_aNOT  <= TRANSPORT a_EQ108  ;
xor2_1125: a_EQ108 <=  n_1349  XOR n_1360;
or3_1126: n_1349 <=  n_1350  OR n_1353  OR n_1356;
and2_1127: n_1350 <=  n_1351  AND n_1352;
delay_1128: n_1351  <= TRANSPORT a_N219  ;
inv_1129: n_1352  <= TRANSPORT NOT a_N221  ;
and2_1130: n_1353 <=  n_1354  AND n_1355;
inv_1131: n_1354  <= TRANSPORT NOT a_N221  ;
inv_1132: n_1355  <= TRANSPORT NOT a_N222  ;
and2_1133: n_1356 <=  n_1357  AND n_1359;
delay_1134: n_1357  <= TRANSPORT a_N1016  ;
inv_1135: n_1359  <= TRANSPORT NOT a_N222  ;
and1_1136: n_1360 <=  gnd;
delay_1137: a_LC4_A16  <= TRANSPORT a_EQ106  ;
xor2_1138: a_EQ106 <=  n_1363  XOR n_1370;
or2_1139: n_1363 <=  n_1364  OR n_1366;
and1_1140: n_1364 <=  n_1365;
delay_1141: n_1365  <= TRANSPORT a_N378_aNOT  ;
and3_1142: n_1366 <=  n_1367  AND n_1368  AND n_1369;
delay_1143: n_1367  <= TRANSPORT a_N1015  ;
delay_1144: n_1368  <= TRANSPORT a_N221  ;
delay_1145: n_1369  <= TRANSPORT a_N222  ;
and1_1146: n_1370 <=  gnd;
delay_1147: a_STXDATA  <= TRANSPORT a_EQ223  ;
xor2_1148: a_EQ223 <=  n_1372  XOR n_1385;
or4_1149: n_1372 <=  n_1373  OR n_1376  OR n_1379  OR n_1382;
and2_1150: n_1373 <=  n_1374  AND n_1375;
inv_1151: n_1374  <= TRANSPORT NOT a_N891  ;
delay_1152: n_1375  <= TRANSPORT a_LC4_A16  ;
and2_1153: n_1376 <=  n_1377  AND n_1378;
inv_1154: n_1377  <= TRANSPORT NOT a_N627_aNOT  ;
inv_1155: n_1378  <= TRANSPORT NOT a_N891  ;
and2_1156: n_1379 <=  n_1380  AND n_1381;
inv_1157: n_1380  <= TRANSPORT NOT a_N890  ;
delay_1158: n_1381  <= TRANSPORT a_LC4_A16  ;
and2_1159: n_1382 <=  n_1383  AND n_1384;
inv_1160: n_1383  <= TRANSPORT NOT a_N627_aNOT  ;
inv_1161: n_1384  <= TRANSPORT NOT a_N890  ;
and1_1162: n_1385 <=  gnd;
delay_1163: a_SRTS  <= TRANSPORT a_SRTS_aIN  ;
xor2_1164: a_SRTS_aIN <=  n_1387  XOR n_1391;
or1_1165: n_1387 <=  n_1388;
and2_1166: n_1388 <=  n_1389  AND n_1390;
delay_1167: n_1389  <= TRANSPORT a_N890  ;
inv_1168: n_1390  <= TRANSPORT NOT a_N891  ;
and1_1169: n_1391 <=  gnd;
delay_1170: a_SIRQ_N_aNOT  <= TRANSPORT a_EQ208  ;
xor2_1171: a_EQ208 <=  n_1393  XOR n_1398;
or2_1172: n_1393 <=  n_1394  OR n_1396;
and1_1173: n_1394 <=  n_1395;
delay_1174: n_1395  <= TRANSPORT a_N759  ;
and1_1175: n_1396 <=  n_1397;
delay_1176: n_1397  <= TRANSPORT a_N758  ;
and1_1177: n_1398 <=  gnd;
delay_1178: a_N627_aNOT  <= TRANSPORT a_EQ164  ;
xor2_1179: a_EQ164 <=  n_1400  XOR n_1405;
or2_1180: n_1400 <=  n_1401  OR n_1403;
and1_1181: n_1401 <=  n_1402;
inv_1182: n_1402  <= TRANSPORT NOT a_N894  ;
and1_1183: n_1403 <=  n_1404;
inv_1184: n_1404  <= TRANSPORT NOT a_N895  ;
and1_1185: n_1405 <=  gnd;
delay_1186: a_N589_aNOT  <= TRANSPORT a_EQ143  ;
xor2_1187: a_EQ143 <=  n_1408  XOR n_1415;
or2_1188: n_1408 <=  n_1409  OR n_1411;
and1_1189: n_1409 <=  n_1410;
inv_1190: n_1410  <= TRANSPORT NOT a_N627_aNOT  ;
and3_1191: n_1411 <=  n_1412  AND n_1413  AND n_1414;
inv_1192: n_1412  <= TRANSPORT NOT a_N219  ;
inv_1193: n_1413  <= TRANSPORT NOT a_N221  ;
inv_1194: n_1414  <= TRANSPORT NOT a_N222  ;
and1_1195: n_1415 <=  gnd;
delay_1196: a_LC1_A14  <= TRANSPORT a_EQ039  ;
xor2_1197: a_EQ039 <=  n_1418  XOR n_1432;
or2_1198: n_1418 <=  n_1419  OR n_1427;
and4_1199: n_1419 <=  n_1420  AND n_1422  AND n_1424  AND n_1426;
delay_1200: n_1420  <= TRANSPORT a_N167  ;
delay_1201: n_1422  <= TRANSPORT a_N168  ;
inv_1202: n_1424  <= TRANSPORT NOT a_N166  ;
delay_1203: n_1426  <= TRANSPORT a_N894  ;
and4_1204: n_1427 <=  n_1428  AND n_1429  AND n_1430  AND n_1431;
inv_1205: n_1428  <= TRANSPORT NOT a_N167  ;
inv_1206: n_1429  <= TRANSPORT NOT a_N168  ;
inv_1207: n_1430  <= TRANSPORT NOT a_N166  ;
inv_1208: n_1431  <= TRANSPORT NOT a_N894  ;
and1_1209: n_1432 <=  gnd;
delay_1210: a_LC1_A5  <= TRANSPORT a_LC1_A5_aIN  ;
xor2_1211: a_LC1_A5_aIN <=  n_1435  XOR n_1441;
or1_1212: n_1435 <=  n_1436;
and2_1213: n_1436 <=  n_1437  AND n_1439;
delay_1214: n_1437  <= TRANSPORT a_N171  ;
delay_1215: n_1439  <= TRANSPORT a_N172  ;
and1_1216: n_1441 <=  gnd;
delay_1217: a_LC2_A5  <= TRANSPORT a_LC2_A5_aIN  ;
xor2_1218: a_LC2_A5_aIN <=  n_1444  XOR n_1449;
or1_1219: n_1444 <=  n_1445;
and2_1220: n_1445 <=  n_1446  AND n_1447;
delay_1221: n_1446  <= TRANSPORT a_LC1_A5  ;
delay_1222: n_1447  <= TRANSPORT a_N170  ;
and1_1223: n_1449 <=  gnd;
delay_1224: a_LC2_A14  <= TRANSPORT a_LC2_A14_aIN  ;
xor2_1225: a_LC2_A14_aIN <=  n_1452  XOR n_1457;
or1_1226: n_1452 <=  n_1453;
and2_1227: n_1453 <=  n_1454  AND n_1455;
delay_1228: n_1454  <= TRANSPORT a_LC2_A5  ;
delay_1229: n_1455  <= TRANSPORT a_N169  ;
and1_1230: n_1457 <=  gnd;
delay_1231: a_N55  <= TRANSPORT a_EQ040  ;
xor2_1232: a_EQ040 <=  n_1460  XOR n_1467;
or2_1233: n_1460 <=  n_1461  OR n_1464;
and2_1234: n_1461 <=  n_1462  AND n_1463;
delay_1235: n_1462  <= TRANSPORT a_LC1_A14  ;
delay_1236: n_1463  <= TRANSPORT a_LC2_A14  ;
and2_1237: n_1464 <=  n_1465  AND n_1466;
inv_1238: n_1465  <= TRANSPORT NOT a_N894  ;
inv_1239: n_1466  <= TRANSPORT NOT a_N895  ;
and1_1240: n_1467 <=  gnd;
delay_1241: a_N606_aNOT  <= TRANSPORT a_EQ152  ;
xor2_1242: a_EQ152 <=  n_1469  XOR n_1474;
or2_1243: n_1469 <=  n_1470  OR n_1472;
and1_1244: n_1470 <=  n_1471;
delay_1245: n_1471  <= TRANSPORT a_N589_aNOT  ;
and1_1246: n_1472 <=  n_1473;
inv_1247: n_1473  <= TRANSPORT NOT a_N55  ;
and1_1248: n_1474 <=  gnd;
delay_1249: a_N640_aNOT  <= TRANSPORT a_EQ173  ;
xor2_1250: a_EQ173 <=  n_1476  XOR n_1483;
or3_1251: n_1476 <=  n_1477  OR n_1479  OR n_1481;
and1_1252: n_1477 <=  n_1478;
delay_1253: n_1478  <= TRANSPORT a_N606_aNOT  ;
and1_1254: n_1479 <=  n_1480;
delay_1255: n_1480  <= TRANSPORT a_N222  ;
and1_1256: n_1481 <=  n_1482;
inv_1257: n_1482  <= TRANSPORT NOT a_N221  ;
and1_1258: n_1483 <=  gnd;
delay_1259: a_N604  <= TRANSPORT a_N604_aIN  ;
xor2_1260: a_N604_aIN <=  n_1485  XOR n_1489;
or1_1261: n_1485 <=  n_1486;
and2_1262: n_1486 <=  n_1487  AND n_1488;
delay_1263: n_1487  <= TRANSPORT a_N219  ;
inv_1264: n_1488  <= TRANSPORT NOT a_N221  ;
and1_1265: n_1489 <=  gnd;
delay_1266: a_N593  <= TRANSPORT a_EQ145  ;
xor2_1267: a_EQ145 <=  n_1491  XOR n_1497;
or2_1268: n_1491 <=  n_1492  OR n_1494;
and1_1269: n_1492 <=  n_1493;
delay_1270: n_1493  <= TRANSPORT a_N892  ;
and2_1271: n_1494 <=  n_1495  AND n_1496;
delay_1272: n_1495  <= TRANSPORT a_N893  ;
delay_1273: n_1496  <= TRANSPORT word_lngth  ;
and1_1274: n_1497 <=  gnd;
delay_1275: a_LC6_A13  <= TRANSPORT a_EQ109  ;
xor2_1276: a_EQ109 <=  n_1500  XOR n_1507;
or2_1277: n_1500 <=  n_1501  OR n_1504;
and2_1278: n_1501 <=  n_1502  AND n_1503;
delay_1279: n_1502  <= TRANSPORT a_N222  ;
delay_1280: n_1503  <= TRANSPORT a_SSTS_REG_F1_G_aNOT  ;
and2_1281: n_1504 <=  n_1505  AND n_1506;
delay_1282: n_1505  <= TRANSPORT a_N593  ;
delay_1283: n_1506  <= TRANSPORT a_SSTS_REG_F1_G_aNOT  ;
and1_1284: n_1507 <=  gnd;
delay_1285: a_N602  <= TRANSPORT a_N602_aIN  ;
xor2_1286: a_N602_aIN <=  n_1510  XOR n_1514;
or1_1287: n_1510 <=  n_1511;
and2_1288: n_1511 <=  n_1512  AND n_1513;
inv_1289: n_1512  <= TRANSPORT NOT a_N219  ;
inv_1290: n_1513  <= TRANSPORT NOT a_N221  ;
and1_1291: n_1514 <=  gnd;
delay_1292: a_N633  <= TRANSPORT a_N633_aIN  ;
xor2_1293: a_N633_aIN <=  n_1516  XOR n_1522;
or1_1294: n_1516 <=  n_1517;
and4_1295: n_1517 <=  n_1518  AND n_1519  AND n_1520  AND n_1521;
delay_1296: n_1518  <= TRANSPORT a_N602  ;
inv_1297: n_1519  <= TRANSPORT NOT a_N222  ;
delay_1298: n_1520  <= TRANSPORT a_SSTS_REG_F1_G_aNOT  ;
inv_1299: n_1521  <= TRANSPORT NOT a_SSTS_REG_F3_G  ;
and1_1300: n_1522 <=  gnd;
delay_1301: a_N379_aNOT  <= TRANSPORT a_EQ110  ;
xor2_1302: a_EQ110 <=  n_1524  XOR n_1531;
or2_1303: n_1524 <=  n_1525  OR n_1529;
and3_1304: n_1525 <=  n_1526  AND n_1527  AND n_1528;
delay_1305: n_1526  <= TRANSPORT a_N55  ;
delay_1306: n_1527  <= TRANSPORT a_N604  ;
delay_1307: n_1528  <= TRANSPORT a_LC6_A13  ;
and1_1308: n_1529 <=  n_1530;
delay_1309: n_1530  <= TRANSPORT a_N633  ;
and1_1310: n_1531 <=  gnd;
delay_1311: a_LC8_A9  <= TRANSPORT a_LC8_A9_aIN  ;
xor2_1312: a_LC8_A9_aIN <=  n_1534  XOR n_1538;
or1_1313: n_1534 <=  n_1535;
and2_1314: n_1535 <=  n_1536  AND n_1537;
delay_1315: n_1536  <= TRANSPORT a_N640_aNOT  ;
inv_1316: n_1537  <= TRANSPORT NOT a_N379_aNOT  ;
and1_1317: n_1538 <=  gnd;
delay_1318: a_LC2_A12  <= TRANSPORT a_LC2_A12_aIN  ;
xor2_1319: a_LC2_A12_aIN <=  n_1541  XOR n_1546;
or1_1320: n_1541 <=  n_1542;
and3_1321: n_1542 <=  n_1543  AND n_1544  AND n_1545;
delay_1322: n_1543  <= TRANSPORT a_N379_aNOT  ;
delay_1323: n_1544  <= TRANSPORT a_STX_REG_DATA_F7_G  ;
delay_1324: n_1545  <= TRANSPORT word_lngth  ;
and1_1325: n_1546 <=  gnd;
dff_1326: DFF_a6850

    PORT MAP ( D => a_EQ023, CLK => a_N30_aCLK, CLRN => a_N30_aCLRN, PRN => vcc,
          Q => a_N30);
delay_1327: a_N30_aCLRN  <= TRANSPORT nRESET  ;
xor2_1328: a_EQ023 <=  n_1554  XOR n_1562;
or2_1329: n_1554 <=  n_1555  OR n_1559;
and3_1330: n_1555 <=  n_1556  AND n_1557  AND n_1558;
delay_1331: n_1556  <= TRANSPORT a_N627_aNOT  ;
delay_1332: n_1557  <= TRANSPORT a_LC8_A9  ;
delay_1333: n_1558  <= TRANSPORT a_N30  ;
and2_1334: n_1559 <=  n_1560  AND n_1561;
delay_1335: n_1560  <= TRANSPORT a_N627_aNOT  ;
delay_1336: n_1561  <= TRANSPORT a_LC2_A12  ;
and1_1337: n_1562 <=  gnd;
inv_1338: n_1563  <= TRANSPORT NOT TXCLK  ;
filter_1339: FILTER_a6850

    PORT MAP (IN1 => n_1563, Y => a_N30_aCLK);
delay_1340: a_LC3_A19  <= TRANSPORT a_LC3_A19_aIN  ;
xor2_1341: a_LC3_A19_aIN <=  n_1567  XOR n_1572;
or1_1342: n_1567 <=  n_1568;
and3_1343: n_1568 <=  n_1569  AND n_1570  AND n_1571;
inv_1344: n_1569  <= TRANSPORT NOT a_N606_aNOT  ;
delay_1345: n_1570  <= TRANSPORT a_N221  ;
inv_1346: n_1571  <= TRANSPORT NOT a_N222  ;
and1_1347: n_1572 <=  gnd;
delay_1348: a_LC7_A12  <= TRANSPORT a_EQ094  ;
xor2_1349: a_EQ094 <=  n_1575  XOR n_1583;
or2_1350: n_1575 <=  n_1576  OR n_1580;
and2_1351: n_1576 <=  n_1577  AND n_1578;
delay_1352: n_1577  <= TRANSPORT a_N640_aNOT  ;
delay_1353: n_1578  <= TRANSPORT a_N32  ;
and2_1354: n_1580 <=  n_1581  AND n_1582;
delay_1355: n_1581  <= TRANSPORT a_N30  ;
delay_1356: n_1582  <= TRANSPORT a_LC3_A19  ;
and1_1357: n_1583 <=  gnd;
dff_1358: DFF_a6850

    PORT MAP ( D => a_EQ025, CLK => a_N32_aCLK, CLRN => a_N32_aCLRN, PRN => vcc,
          Q => a_N32);
delay_1359: a_N32_aCLRN  <= TRANSPORT nRESET  ;
xor2_1360: a_EQ025 <=  n_1590  XOR n_1599;
or2_1361: n_1590 <=  n_1591  OR n_1595;
and3_1362: n_1591 <=  n_1592  AND n_1593  AND n_1594;
delay_1363: n_1592  <= TRANSPORT a_N627_aNOT  ;
inv_1364: n_1593  <= TRANSPORT NOT a_N379_aNOT  ;
delay_1365: n_1594  <= TRANSPORT a_LC7_A12  ;
and3_1366: n_1595 <=  n_1596  AND n_1597  AND n_1598;
delay_1367: n_1596  <= TRANSPORT a_N627_aNOT  ;
delay_1368: n_1597  <= TRANSPORT a_N379_aNOT  ;
delay_1369: n_1598  <= TRANSPORT a_STX_REG_DATA_F6_G  ;
and1_1370: n_1599 <=  gnd;
inv_1371: n_1600  <= TRANSPORT NOT TXCLK  ;
filter_1372: FILTER_a6850

    PORT MAP (IN1 => n_1600, Y => a_N32_aCLK);
delay_1373: a_N326  <= TRANSPORT a_EQ098  ;
xor2_1374: a_EQ098 <=  n_1604  XOR n_1612;
or2_1375: n_1604 <=  n_1605  OR n_1608;
and2_1376: n_1605 <=  n_1606  AND n_1607;
inv_1377: n_1606  <= TRANSPORT NOT a_N640_aNOT  ;
delay_1378: n_1607  <= TRANSPORT a_N32  ;
and2_1379: n_1608 <=  n_1609  AND n_1610;
delay_1380: n_1609  <= TRANSPORT a_N640_aNOT  ;
delay_1381: n_1610  <= TRANSPORT a_N33  ;
and1_1382: n_1612 <=  gnd;
dff_1383: DFF_a6850

    PORT MAP ( D => a_EQ026, CLK => a_N33_aCLK, CLRN => a_N33_aCLRN, PRN => vcc,
          Q => a_N33);
delay_1384: a_N33_aCLRN  <= TRANSPORT nRESET  ;
xor2_1385: a_EQ026 <=  n_1619  XOR n_1628;
or2_1386: n_1619 <=  n_1620  OR n_1624;
and3_1387: n_1620 <=  n_1621  AND n_1622  AND n_1623;
delay_1388: n_1621  <= TRANSPORT a_N627_aNOT  ;
inv_1389: n_1622  <= TRANSPORT NOT a_N379_aNOT  ;
delay_1390: n_1623  <= TRANSPORT a_N326  ;
and3_1391: n_1624 <=  n_1625  AND n_1626  AND n_1627;
delay_1392: n_1625  <= TRANSPORT a_N627_aNOT  ;
delay_1393: n_1626  <= TRANSPORT a_N379_aNOT  ;
delay_1394: n_1627  <= TRANSPORT a_STX_REG_DATA_F5_G  ;
and1_1395: n_1628 <=  gnd;
inv_1396: n_1629  <= TRANSPORT NOT TXCLK  ;
filter_1397: FILTER_a6850

    PORT MAP (IN1 => n_1629, Y => a_N33_aCLK);
delay_1398: a_N609  <= TRANSPORT a_N609_aIN  ;
xor2_1399: a_N609_aIN <=  n_1632  XOR n_1636;
or1_1400: n_1632 <=  n_1633;
and2_1401: n_1633 <=  n_1634  AND n_1635;
delay_1402: n_1634  <= TRANSPORT a_N627_aNOT  ;
delay_1403: n_1635  <= TRANSPORT nRESET  ;
and1_1404: n_1636 <=  gnd;
delay_1405: a_N197  <= TRANSPORT a_N197_aIN  ;
xor2_1406: a_N197_aIN <=  n_1639  XOR n_1643;
or1_1407: n_1639 <=  n_1640;
and2_1408: n_1640 <=  n_1641  AND n_1642;
delay_1409: n_1641  <= TRANSPORT a_LC8_A9  ;
delay_1410: n_1642  <= TRANSPORT a_N609  ;
and1_1411: n_1643 <=  gnd;
delay_1412: a_N597  <= TRANSPORT a_N597_aIN  ;
xor2_1413: a_N597_aIN <=  n_1645  XOR n_1649;
or1_1414: n_1645 <=  n_1646;
and2_1415: n_1646 <=  n_1647  AND n_1648;
delay_1416: n_1647  <= TRANSPORT a_N627_aNOT  ;
delay_1417: n_1648  <= TRANSPORT a_N379_aNOT  ;
and1_1418: n_1649 <=  gnd;
delay_1419: a_LC5_A11  <= TRANSPORT a_EQ117  ;
xor2_1420: a_EQ117 <=  n_1652  XOR n_1660;
or2_1421: n_1652 <=  n_1653  OR n_1657;
and2_1422: n_1653 <=  n_1654  AND n_1655;
delay_1423: n_1654  <= TRANSPORT a_N197  ;
delay_1424: n_1655  <= TRANSPORT a_N34  ;
and2_1425: n_1657 <=  n_1658  AND n_1659;
delay_1426: n_1658  <= TRANSPORT a_N597  ;
delay_1427: n_1659  <= TRANSPORT a_STX_REG_DATA_F4_G  ;
and1_1428: n_1660 <=  gnd;
dff_1429: DFF_a6850

    PORT MAP ( D => a_EQ027, CLK => a_N34_aCLK, CLRN => a_N34_aCLRN, PRN => vcc,
          Q => a_N34);
delay_1430: a_N34_aCLRN  <= TRANSPORT nRESET  ;
xor2_1431: a_EQ027 <=  n_1667  XOR n_1673;
or2_1432: n_1667 <=  n_1668  OR n_1670;
and1_1433: n_1668 <=  n_1669;
delay_1434: n_1669  <= TRANSPORT a_LC5_A11  ;
and2_1435: n_1670 <=  n_1671  AND n_1672;
inv_1436: n_1671  <= TRANSPORT NOT a_N640_aNOT  ;
delay_1437: n_1672  <= TRANSPORT a_N33  ;
and1_1438: n_1673 <=  gnd;
inv_1439: n_1674  <= TRANSPORT NOT TXCLK  ;
filter_1440: FILTER_a6850

    PORT MAP (IN1 => n_1674, Y => a_N34_aCLK);
delay_1441: a_LC6_A11  <= TRANSPORT a_EQ095  ;
xor2_1442: a_EQ095 <=  n_1678  XOR n_1686;
or2_1443: n_1678 <=  n_1679  OR n_1683;
and2_1444: n_1679 <=  n_1680  AND n_1681;
delay_1445: n_1680  <= TRANSPORT a_N640_aNOT  ;
delay_1446: n_1681  <= TRANSPORT a_N35  ;
and2_1447: n_1683 <=  n_1684  AND n_1685;
inv_1448: n_1684  <= TRANSPORT NOT a_N640_aNOT  ;
delay_1449: n_1685  <= TRANSPORT a_N34  ;
and1_1450: n_1686 <=  gnd;
dff_1451: DFF_a6850

    PORT MAP ( D => a_EQ028, CLK => a_N35_aCLK, CLRN => a_N35_aCLRN, PRN => vcc,
          Q => a_N35);
delay_1452: a_N35_aCLRN  <= TRANSPORT nRESET  ;
xor2_1453: a_EQ028 <=  n_1693  XOR n_1702;
or2_1454: n_1693 <=  n_1694  OR n_1698;
and3_1455: n_1694 <=  n_1695  AND n_1696  AND n_1697;
delay_1456: n_1695  <= TRANSPORT a_N627_aNOT  ;
inv_1457: n_1696  <= TRANSPORT NOT a_N379_aNOT  ;
delay_1458: n_1697  <= TRANSPORT a_LC6_A11  ;
and3_1459: n_1698 <=  n_1699  AND n_1700  AND n_1701;
delay_1460: n_1699  <= TRANSPORT a_N627_aNOT  ;
delay_1461: n_1700  <= TRANSPORT a_N379_aNOT  ;
delay_1462: n_1701  <= TRANSPORT a_STX_REG_DATA_F3_G  ;
and1_1463: n_1702 <=  gnd;
inv_1464: n_1703  <= TRANSPORT NOT TXCLK  ;
filter_1465: FILTER_a6850

    PORT MAP (IN1 => n_1703, Y => a_N35_aCLK);
delay_1466: a_N51_aNOT  <= TRANSPORT a_EQ037  ;
xor2_1467: a_EQ037 <=  n_1707  XOR n_1716;
or4_1468: n_1707 <=  n_1708  OR n_1710  OR n_1712  OR n_1714;
and1_1469: n_1708 <=  n_1709;
delay_1470: n_1709  <= TRANSPORT a_N495  ;
and1_1471: n_1710 <=  n_1711;
delay_1472: n_1711  <= TRANSPORT a_N499  ;
and1_1473: n_1712 <=  n_1713;
delay_1474: n_1713  <= TRANSPORT a_N497  ;
and1_1475: n_1714 <=  n_1715;
delay_1476: n_1715  <= TRANSPORT a_N498  ;
and1_1477: n_1716 <=  gnd;
delay_1478: a_N45_aNOT  <= TRANSPORT a_EQ035  ;
xor2_1479: a_EQ035 <=  n_1719  XOR n_1726;
or2_1480: n_1719 <=  n_1720  OR n_1723;
and1_1481: n_1720 <=  n_1721;
inv_1482: n_1721  <= TRANSPORT NOT a_N475  ;
and1_1483: n_1723 <=  n_1724;
inv_1484: n_1724  <= TRANSPORT NOT a_N474  ;
and1_1485: n_1726 <=  gnd;
delay_1486: a_N126_aNOT  <= TRANSPORT a_EQ046  ;
xor2_1487: a_EQ046 <=  n_1729  XOR n_1742;
or4_1488: n_1729 <=  n_1730  OR n_1732  OR n_1735  OR n_1739;
and1_1489: n_1730 <=  n_1731;
delay_1490: n_1731  <= TRANSPORT a_N45_aNOT  ;
and1_1491: n_1732 <=  n_1733;
delay_1492: n_1733  <= TRANSPORT a_N473  ;
and2_1493: n_1735 <=  n_1736  AND n_1738;
inv_1494: n_1736  <= TRANSPORT NOT a_N476  ;
delay_1495: n_1738  <= TRANSPORT word_lngth  ;
and2_1496: n_1739 <=  n_1740  AND n_1741;
delay_1497: n_1740  <= TRANSPORT a_N476  ;
inv_1498: n_1741  <= TRANSPORT NOT word_lngth  ;
and1_1499: n_1742 <=  gnd;
delay_1500: a_N380  <= TRANSPORT a_EQ111  ;
xor2_1501: a_EQ111 <=  n_1745  XOR n_1759;
or3_1502: n_1745 <=  n_1746  OR n_1750  OR n_1754;
and3_1503: n_1746 <=  n_1747  AND n_1748  AND n_1749;
delay_1504: n_1747  <= TRANSPORT a_N495  ;
delay_1505: n_1748  <= TRANSPORT a_N498  ;
inv_1506: n_1749  <= TRANSPORT NOT a_N497  ;
and3_1507: n_1750 <=  n_1751  AND n_1752  AND n_1753;
delay_1508: n_1751  <= TRANSPORT a_N498  ;
delay_1509: n_1752  <= TRANSPORT a_N499  ;
inv_1510: n_1753  <= TRANSPORT NOT a_N497  ;
and4_1511: n_1754 <=  n_1755  AND n_1756  AND n_1757  AND n_1758;
inv_1512: n_1755  <= TRANSPORT NOT a_N495  ;
inv_1513: n_1756  <= TRANSPORT NOT a_N498  ;
delay_1514: n_1757  <= TRANSPORT a_N499  ;
delay_1515: n_1758  <= TRANSPORT a_N497  ;
and1_1516: n_1759 <=  gnd;
delay_1517: a_N642_aNOT  <= TRANSPORT a_EQ174  ;
xor2_1518: a_EQ174 <=  n_1762  XOR n_1769;
or3_1519: n_1762 <=  n_1763  OR n_1765  OR n_1767;
and1_1520: n_1763 <=  n_1764;
delay_1521: n_1764  <= TRANSPORT a_N126_aNOT  ;
and1_1522: n_1765 <=  n_1766;
inv_1523: n_1766  <= TRANSPORT NOT a_N380  ;
and1_1524: n_1767 <=  n_1768;
inv_1525: n_1768  <= TRANSPORT NOT a_N627_aNOT  ;
and1_1526: n_1769 <=  gnd;
delay_1527: a_N603_aNOT  <= TRANSPORT a_EQ150  ;
xor2_1528: a_EQ150 <=  n_1772  XOR n_1777;
or2_1529: n_1772 <=  n_1773  OR n_1775;
and1_1530: n_1773 <=  n_1774;
delay_1531: n_1774  <= TRANSPORT a_N497  ;
and1_1532: n_1775 <=  n_1776;
inv_1533: n_1776  <= TRANSPORT NOT a_N498  ;
and1_1534: n_1777 <=  gnd;
delay_1535: a_N636_aNOT  <= TRANSPORT a_EQ171  ;
xor2_1536: a_EQ171 <=  n_1780  XOR n_1789;
or4_1537: n_1780 <=  n_1781  OR n_1783  OR n_1785  OR n_1787;
and1_1538: n_1781 <=  n_1782;
delay_1539: n_1782  <= TRANSPORT a_N642_aNOT  ;
and1_1540: n_1783 <=  n_1784;
inv_1541: n_1784  <= TRANSPORT NOT a_N499  ;
and1_1542: n_1785 <=  n_1786;
delay_1543: n_1786  <= TRANSPORT a_N495  ;
and1_1544: n_1787 <=  n_1788;
delay_1545: n_1788  <= TRANSPORT a_N603_aNOT  ;
and1_1546: n_1789 <=  gnd;
delay_1547: a_N44_aNOT  <= TRANSPORT a_EQ034  ;
xor2_1548: a_EQ034 <=  n_1792  XOR n_1801;
or4_1549: n_1792 <=  n_1793  OR n_1795  OR n_1797  OR n_1799;
and1_1550: n_1793 <=  n_1794;
inv_1551: n_1794  <= TRANSPORT NOT a_N495  ;
and1_1552: n_1795 <=  n_1796;
delay_1553: n_1796  <= TRANSPORT a_N499  ;
and1_1554: n_1797 <=  n_1798;
delay_1555: n_1798  <= TRANSPORT a_N603_aNOT  ;
and1_1556: n_1799 <=  n_1800;
delay_1557: n_1800  <= TRANSPORT a_N642_aNOT  ;
and1_1558: n_1801 <=  gnd;
delay_1559: a_N248  <= TRANSPORT a_EQ083  ;
xor2_1560: a_EQ083 <=  n_1804  XOR n_1811;
or2_1561: n_1804 <=  n_1805  OR n_1809;
and3_1562: n_1805 <=  n_1806  AND n_1807  AND n_1808;
delay_1563: n_1806  <= TRANSPORT a_N51_aNOT  ;
delay_1564: n_1807  <= TRANSPORT a_N636_aNOT  ;
delay_1565: n_1808  <= TRANSPORT a_N44_aNOT  ;
and1_1566: n_1809 <=  n_1810;
inv_1567: n_1810  <= TRANSPORT NOT a_N627_aNOT  ;
and1_1568: n_1811 <=  gnd;
delay_1569: a_N124  <= TRANSPORT a_N124_aIN  ;
xor2_1570: a_N124_aIN <=  n_1814  XOR n_1819;
or1_1571: n_1814 <=  n_1815;
and3_1572: n_1815 <=  n_1816  AND n_1817  AND n_1818;
delay_1573: n_1816  <= TRANSPORT a_N627_aNOT  ;
delay_1574: n_1817  <= TRANSPORT a_N380  ;
delay_1575: n_1818  <= TRANSPORT a_N476  ;
and1_1576: n_1819 <=  gnd;
dff_1577: DFF_a6850

    PORT MAP ( D => a_EQ128, CLK => a_N475_aCLK, CLRN => a_N475_aCLRN, PRN => vcc,
          Q => a_N475);
delay_1578: a_N475_aCLRN  <= TRANSPORT nRESET  ;
xor2_1579: a_EQ128 <=  n_1826  XOR n_1835;
or2_1580: n_1826 <=  n_1827  OR n_1831;
and3_1581: n_1827 <=  n_1828  AND n_1829  AND n_1830;
delay_1582: n_1828  <= TRANSPORT a_N248  ;
inv_1583: n_1829  <= TRANSPORT NOT a_N124  ;
delay_1584: n_1830  <= TRANSPORT a_N475  ;
and3_1585: n_1831 <=  n_1832  AND n_1833  AND n_1834;
delay_1586: n_1832  <= TRANSPORT a_N248  ;
delay_1587: n_1833  <= TRANSPORT a_N124  ;
inv_1588: n_1834  <= TRANSPORT NOT a_N475  ;
and1_1589: n_1835 <=  gnd;
delay_1590: n_1836  <= TRANSPORT RXCLK  ;
filter_1591: FILTER_a6850

    PORT MAP (IN1 => n_1836, Y => a_N475_aCLK);
dff_1592: DFF_a6850

    PORT MAP ( D => a_EQ127, CLK => a_N474_aCLK, CLRN => a_N474_aCLRN, PRN => vcc,
          Q => a_N474);
delay_1593: a_N474_aCLRN  <= TRANSPORT nRESET  ;
xor2_1594: a_EQ127 <=  n_1844  XOR n_1858;
or3_1595: n_1844 <=  n_1845  OR n_1849  OR n_1853;
and3_1596: n_1845 <=  n_1846  AND n_1847  AND n_1848;
delay_1597: n_1846  <= TRANSPORT a_N248  ;
inv_1598: n_1847  <= TRANSPORT NOT a_N475  ;
delay_1599: n_1848  <= TRANSPORT a_N474  ;
and3_1600: n_1849 <=  n_1850  AND n_1851  AND n_1852;
delay_1601: n_1850  <= TRANSPORT a_N248  ;
inv_1602: n_1851  <= TRANSPORT NOT a_N124  ;
delay_1603: n_1852  <= TRANSPORT a_N474  ;
and4_1604: n_1853 <=  n_1854  AND n_1855  AND n_1856  AND n_1857;
delay_1605: n_1854  <= TRANSPORT a_N248  ;
delay_1606: n_1855  <= TRANSPORT a_N124  ;
delay_1607: n_1856  <= TRANSPORT a_N475  ;
inv_1608: n_1857  <= TRANSPORT NOT a_N474  ;
and1_1609: n_1858 <=  gnd;
delay_1610: n_1859  <= TRANSPORT RXCLK  ;
filter_1611: FILTER_a6850

    PORT MAP (IN1 => n_1859, Y => a_N474_aCLK);
dff_1612: DFF_a6850

    PORT MAP ( D => a_EQ126, CLK => a_N473_aCLK, CLRN => a_N473_aCLRN, PRN => vcc,
          Q => a_N473);
delay_1613: a_N473_aCLRN  <= TRANSPORT nRESET  ;
xor2_1614: a_EQ126 <=  n_1867  XOR n_1881;
or3_1615: n_1867 <=  n_1868  OR n_1872  OR n_1876;
and3_1616: n_1868 <=  n_1869  AND n_1870  AND n_1871;
delay_1617: n_1869  <= TRANSPORT a_N248  ;
inv_1618: n_1870  <= TRANSPORT NOT a_N124  ;
delay_1619: n_1871  <= TRANSPORT a_N473  ;
and3_1620: n_1872 <=  n_1873  AND n_1874  AND n_1875;
delay_1621: n_1873  <= TRANSPORT a_N45_aNOT  ;
delay_1622: n_1874  <= TRANSPORT a_N248  ;
delay_1623: n_1875  <= TRANSPORT a_N473  ;
and4_1624: n_1876 <=  n_1877  AND n_1878  AND n_1879  AND n_1880;
inv_1625: n_1877  <= TRANSPORT NOT a_N45_aNOT  ;
delay_1626: n_1878  <= TRANSPORT a_N248  ;
delay_1627: n_1879  <= TRANSPORT a_N124  ;
inv_1628: n_1880  <= TRANSPORT NOT a_N473  ;
and1_1629: n_1881 <=  gnd;
delay_1630: n_1882  <= TRANSPORT RXCLK  ;
filter_1631: FILTER_a6850

    PORT MAP (IN1 => n_1882, Y => a_N473_aCLK);
dff_1632: DFF_a6850

    PORT MAP ( D => a_EQ129, CLK => a_N476_aCLK, CLRN => a_N476_aCLRN, PRN => vcc,
          Q => a_N476);
delay_1633: a_N476_aCLRN  <= TRANSPORT nRESET  ;
xor2_1634: a_EQ129 <=  n_1890  XOR n_1904;
or3_1635: n_1890 <=  n_1891  OR n_1895  OR n_1899;
and3_1636: n_1891 <=  n_1892  AND n_1893  AND n_1894;
inv_1637: n_1892  <= TRANSPORT NOT a_N380  ;
delay_1638: n_1893  <= TRANSPORT a_N248  ;
delay_1639: n_1894  <= TRANSPORT a_N476  ;
and3_1640: n_1895 <=  n_1896  AND n_1897  AND n_1898;
inv_1641: n_1896  <= TRANSPORT NOT a_N627_aNOT  ;
delay_1642: n_1897  <= TRANSPORT a_N248  ;
delay_1643: n_1898  <= TRANSPORT a_N476  ;
and4_1644: n_1899 <=  n_1900  AND n_1901  AND n_1902  AND n_1903;
delay_1645: n_1900  <= TRANSPORT a_N627_aNOT  ;
delay_1646: n_1901  <= TRANSPORT a_N380  ;
delay_1647: n_1902  <= TRANSPORT a_N248  ;
inv_1648: n_1903  <= TRANSPORT NOT a_N476  ;
and1_1649: n_1904 <=  gnd;
delay_1650: n_1905  <= TRANSPORT RXCLK  ;
filter_1651: FILTER_a6850

    PORT MAP (IN1 => n_1905, Y => a_N476_aCLK);
delay_1652: a_LC8_A2  <= TRANSPORT a_EQ097  ;
xor2_1653: a_EQ097 <=  n_1909  XOR n_1917;
or2_1654: n_1909 <=  n_1910  OR n_1914;
and2_1655: n_1910 <=  n_1911  AND n_1912;
delay_1656: n_1911  <= TRANSPORT a_N640_aNOT  ;
delay_1657: n_1912  <= TRANSPORT a_N36  ;
and2_1658: n_1914 <=  n_1915  AND n_1916;
inv_1659: n_1915  <= TRANSPORT NOT a_N640_aNOT  ;
delay_1660: n_1916  <= TRANSPORT a_N35  ;
and1_1661: n_1917 <=  gnd;
dff_1662: DFF_a6850

    PORT MAP ( D => a_EQ029, CLK => a_N36_aCLK, CLRN => a_N36_aCLRN, PRN => vcc,
          Q => a_N36);
delay_1663: a_N36_aCLRN  <= TRANSPORT nRESET  ;
xor2_1664: a_EQ029 <=  n_1924  XOR n_1933;
or2_1665: n_1924 <=  n_1925  OR n_1929;
and3_1666: n_1925 <=  n_1926  AND n_1927  AND n_1928;
delay_1667: n_1926  <= TRANSPORT a_N627_aNOT  ;
inv_1668: n_1927  <= TRANSPORT NOT a_N379_aNOT  ;
delay_1669: n_1928  <= TRANSPORT a_LC8_A2  ;
and3_1670: n_1929 <=  n_1930  AND n_1931  AND n_1932;
delay_1671: n_1930  <= TRANSPORT a_N627_aNOT  ;
delay_1672: n_1931  <= TRANSPORT a_N379_aNOT  ;
delay_1673: n_1932  <= TRANSPORT a_STX_REG_DATA_F2_G  ;
and1_1674: n_1933 <=  gnd;
inv_1675: n_1934  <= TRANSPORT NOT TXCLK  ;
filter_1676: FILTER_a6850

    PORT MAP (IN1 => n_1934, Y => a_N36_aCLK);
delay_1677: a_LC6_A18  <= TRANSPORT a_EQ042  ;
xor2_1678: a_EQ042 <=  n_1938  XOR n_1945;
or2_1679: n_1938 <=  n_1939  OR n_1943;
and3_1680: n_1939 <=  n_1940  AND n_1941  AND n_1942;
inv_1681: n_1940  <= TRANSPORT NOT a_N219  ;
inv_1682: n_1941  <= TRANSPORT NOT a_N221  ;
inv_1683: n_1942  <= TRANSPORT NOT a_N222  ;
and1_1684: n_1943 <=  n_1944;
delay_1685: n_1944  <= TRANSPORT a_N606_aNOT  ;
and1_1686: n_1945 <=  gnd;
delay_1687: a_LC5_A18  <= TRANSPORT a_EQ103  ;
xor2_1688: a_EQ103 <=  n_1948  XOR n_1956;
or2_1689: n_1948 <=  n_1949  OR n_1953;
and3_1690: n_1949 <=  n_1950  AND n_1951  AND n_1952;
delay_1691: n_1950  <= TRANSPORT a_N589_aNOT  ;
inv_1692: n_1951  <= TRANSPORT NOT a_N633  ;
delay_1693: n_1952  <= TRANSPORT a_LC6_A18  ;
and2_1694: n_1953 <=  n_1954  AND n_1955;
inv_1695: n_1954  <= TRANSPORT NOT a_N627_aNOT  ;
delay_1696: n_1955  <= TRANSPORT a_N589_aNOT  ;
and1_1697: n_1956 <=  gnd;
delay_1698: a_LC2_A18  <= TRANSPORT a_LC2_A18_aIN  ;
xor2_1699: a_LC2_A18_aIN <=  n_1959  XOR n_1964;
or1_1700: n_1959 <=  n_1960;
and3_1701: n_1960 <=  n_1961  AND n_1962  AND n_1963;
inv_1702: n_1961  <= TRANSPORT NOT a_N589_aNOT  ;
inv_1703: n_1962  <= TRANSPORT NOT a_N633  ;
delay_1704: n_1963  <= TRANSPORT a_LC6_A18  ;
and1_1705: n_1964 <=  gnd;
dff_1706: DFF_a6850

    PORT MAP ( D => a_EQ064, CLK => a_N171_aCLK, CLRN => a_N171_aCLRN, PRN => vcc,
          Q => a_N171);
delay_1707: a_N171_aCLRN  <= TRANSPORT nRESET  ;
xor2_1708: a_EQ064 <=  n_1971  XOR n_1983;
or3_1709: n_1971 <=  n_1972  OR n_1975  OR n_1979;
and2_1710: n_1972 <=  n_1973  AND n_1974;
delay_1711: n_1973  <= TRANSPORT a_LC5_A18  ;
delay_1712: n_1974  <= TRANSPORT a_N171  ;
and3_1713: n_1975 <=  n_1976  AND n_1977  AND n_1978;
delay_1714: n_1976  <= TRANSPORT a_LC2_A18  ;
inv_1715: n_1977  <= TRANSPORT NOT a_N171  ;
delay_1716: n_1978  <= TRANSPORT a_N172  ;
and3_1717: n_1979 <=  n_1980  AND n_1981  AND n_1982;
delay_1718: n_1980  <= TRANSPORT a_LC2_A18  ;
delay_1719: n_1981  <= TRANSPORT a_N171  ;
inv_1720: n_1982  <= TRANSPORT NOT a_N172  ;
and1_1721: n_1983 <=  gnd;
inv_1722: n_1984  <= TRANSPORT NOT TXCLK  ;
filter_1723: FILTER_a6850

    PORT MAP (IN1 => n_1984, Y => a_N171_aCLK);
dff_1724: DFF_a6850

    PORT MAP ( D => a_EQ065, CLK => a_N172_aCLK, CLRN => a_N172_aCLRN, PRN => vcc,
          Q => a_N172);
delay_1725: a_N172_aCLRN  <= TRANSPORT nRESET  ;
xor2_1726: a_EQ065 <=  n_1992  XOR n_1999;
or2_1727: n_1992 <=  n_1993  OR n_1996;
and2_1728: n_1993 <=  n_1994  AND n_1995;
delay_1729: n_1994  <= TRANSPORT a_LC5_A18  ;
delay_1730: n_1995  <= TRANSPORT a_N172  ;
and2_1731: n_1996 <=  n_1997  AND n_1998;
delay_1732: n_1997  <= TRANSPORT a_LC2_A18  ;
inv_1733: n_1998  <= TRANSPORT NOT a_N172  ;
and1_1734: n_1999 <=  gnd;
inv_1735: n_2000  <= TRANSPORT NOT TXCLK  ;
filter_1736: FILTER_a6850

    PORT MAP (IN1 => n_2000, Y => a_N172_aCLK);
delay_1737: a_N374_aNOT  <= TRANSPORT a_EQ107  ;
xor2_1738: a_EQ107 <=  n_2004  XOR n_2022;
or4_1739: n_2004 <=  n_2005  OR n_2010  OR n_2014  OR n_2018;
and4_1740: n_2005 <=  n_2006  AND n_2007  AND n_2008  AND n_2009;
inv_1741: n_2006  <= TRANSPORT NOT a_N495  ;
inv_1742: n_2007  <= TRANSPORT NOT a_N498  ;
inv_1743: n_2008  <= TRANSPORT NOT a_N499  ;
inv_1744: n_2009  <= TRANSPORT NOT a_N497  ;
and3_1745: n_2010 <=  n_2011  AND n_2012  AND n_2013;
delay_1746: n_2011  <= TRANSPORT a_N495  ;
inv_1747: n_2012  <= TRANSPORT NOT a_N498  ;
delay_1748: n_2013  <= TRANSPORT a_N497  ;
and3_1749: n_2014 <=  n_2015  AND n_2016  AND n_2017;
delay_1750: n_2015  <= TRANSPORT a_N495  ;
delay_1751: n_2016  <= TRANSPORT a_N498  ;
inv_1752: n_2017  <= TRANSPORT NOT a_N499  ;
and3_1753: n_2018 <=  n_2019  AND n_2020  AND n_2021;
delay_1754: n_2019  <= TRANSPORT a_N495  ;
delay_1755: n_2020  <= TRANSPORT a_N499  ;
inv_1756: n_2021  <= TRANSPORT NOT a_N497  ;
and1_1757: n_2022 <=  gnd;
delay_1758: a_N398_aNOT  <= TRANSPORT a_EQ115  ;
xor2_1759: a_EQ115 <=  n_2025  XOR n_2033;
or3_1760: n_2025 <=  n_2026  OR n_2029  OR n_2031;
and1_1761: n_2026 <=  n_2027;
inv_1762: n_2027  <= TRANSPORT NOT a_N434  ;
and1_1763: n_2029 <=  n_2030;
delay_1764: n_2030  <= TRANSPORT a_N374_aNOT  ;
and1_1765: n_2031 <=  n_2032;
inv_1766: n_2032  <= TRANSPORT NOT a_N627_aNOT  ;
and1_1767: n_2033 <=  gnd;
delay_1768: a_LC3_B8  <= TRANSPORT a_EQ165  ;
xor2_1769: a_EQ165 <=  n_2036  XOR n_2049;
or4_1770: n_2036 <=  n_2037  OR n_2039  OR n_2043  OR n_2046;
and1_1771: n_2037 <=  n_2038;
delay_1772: n_2038  <= TRANSPORT a_N499  ;
and3_1773: n_2039 <=  n_2040  AND n_2041  AND n_2042;
inv_1774: n_2040  <= TRANSPORT NOT a_N495  ;
inv_1775: n_2041  <= TRANSPORT NOT a_N498  ;
inv_1776: n_2042  <= TRANSPORT NOT a_N497  ;
and2_1777: n_2043 <=  n_2044  AND n_2045;
delay_1778: n_2044  <= TRANSPORT a_N495  ;
delay_1779: n_2045  <= TRANSPORT a_N497  ;
and2_1780: n_2046 <=  n_2047  AND n_2048;
delay_1781: n_2047  <= TRANSPORT a_N495  ;
delay_1782: n_2048  <= TRANSPORT a_N498  ;
and1_1783: n_2049 <=  gnd;
delay_1784: a_N388  <= TRANSPORT a_EQ113  ;
xor2_1785: a_EQ113 <=  n_2052  XOR n_2061;
or3_1786: n_2052 <=  n_2053  OR n_2056  OR n_2058;
and1_1787: n_2053 <=  n_2054;
inv_1788: n_2054  <= TRANSPORT NOT a_N433  ;
and1_1789: n_2056 <=  n_2057;
inv_1790: n_2057  <= TRANSPORT NOT a_N434  ;
and1_1791: n_2058 <=  n_2059;
inv_1792: n_2059  <= TRANSPORT NOT a_N432  ;
and1_1793: n_2061 <=  gnd;
delay_1794: a_LC4_B8  <= TRANSPORT a_EQ038  ;
xor2_1795: a_EQ038 <=  n_2064  XOR n_2083;
or5_1796: n_2064 <=  n_2065  OR n_2070  OR n_2073  OR n_2076  OR n_2079;
and2_1797: n_2065 <=  n_2066  AND n_2068;
delay_1798: n_2066  <= TRANSPORT a_N430  ;
inv_1799: n_2068  <= TRANSPORT NOT a_N429  ;
and2_1800: n_2070 <=  n_2071  AND n_2072;
inv_1801: n_2071  <= TRANSPORT NOT a_N429  ;
delay_1802: n_2072  <= TRANSPORT a_N894  ;
and2_1803: n_2073 <=  n_2074  AND n_2075;
inv_1804: n_2074  <= TRANSPORT NOT a_N429  ;
inv_1805: n_2075  <= TRANSPORT NOT a_N895  ;
and2_1806: n_2076 <=  n_2077  AND n_2078;
inv_1807: n_2077  <= TRANSPORT NOT a_N430  ;
delay_1808: n_2078  <= TRANSPORT a_N429  ;
and3_1809: n_2079 <=  n_2080  AND n_2081  AND n_2082;
delay_1810: n_2080  <= TRANSPORT a_N429  ;
inv_1811: n_2081  <= TRANSPORT NOT a_N894  ;
delay_1812: n_2082  <= TRANSPORT a_N895  ;
and1_1813: n_2083 <=  gnd;
delay_1814: a_LC1_B8  <= TRANSPORT a_EQ166  ;
xor2_1815: a_EQ166 <=  n_2086  XOR n_2096;
or4_1816: n_2086 <=  n_2087  OR n_2089  OR n_2091  OR n_2094;
and1_1817: n_2087 <=  n_2088;
delay_1818: n_2088  <= TRANSPORT a_LC3_B8  ;
and1_1819: n_2089 <=  n_2090;
delay_1820: n_2090  <= TRANSPORT a_N388  ;
and1_1821: n_2091 <=  n_2092;
inv_1822: n_2092  <= TRANSPORT NOT a_N431  ;
and1_1823: n_2094 <=  n_2095;
delay_1824: n_2095  <= TRANSPORT a_LC4_B8  ;
and1_1825: n_2096 <=  gnd;
delay_1826: a_LC2_B8  <= TRANSPORT a_EQ050  ;
xor2_1827: a_EQ050 <=  n_2099  XOR n_2116;
or5_1828: n_2099 <=  n_2100  OR n_2103  OR n_2106  OR n_2109  OR n_2112;
and2_1829: n_2100 <=  n_2101  AND n_2102;
delay_1830: n_2101  <= TRANSPORT a_N430  ;
inv_1831: n_2102  <= TRANSPORT NOT a_N431  ;
and2_1832: n_2103 <=  n_2104  AND n_2105;
inv_1833: n_2104  <= TRANSPORT NOT a_N431  ;
delay_1834: n_2105  <= TRANSPORT a_N894  ;
and2_1835: n_2106 <=  n_2107  AND n_2108;
inv_1836: n_2107  <= TRANSPORT NOT a_N431  ;
inv_1837: n_2108  <= TRANSPORT NOT a_N895  ;
and2_1838: n_2109 <=  n_2110  AND n_2111;
inv_1839: n_2110  <= TRANSPORT NOT a_N430  ;
delay_1840: n_2111  <= TRANSPORT a_N431  ;
and3_1841: n_2112 <=  n_2113  AND n_2114  AND n_2115;
delay_1842: n_2113  <= TRANSPORT a_N431  ;
inv_1843: n_2114  <= TRANSPORT NOT a_N894  ;
delay_1844: n_2115  <= TRANSPORT a_N895  ;
and1_1845: n_2116 <=  gnd;
delay_1846: a_N141  <= TRANSPORT a_EQ051  ;
xor2_1847: a_EQ051 <=  n_2119  XOR n_2128;
or4_1848: n_2119 <=  n_2120  OR n_2122  OR n_2124  OR n_2126;
and1_1849: n_2120 <=  n_2121;
delay_1850: n_2121  <= TRANSPORT a_LC2_B8  ;
and1_1851: n_2122 <=  n_2123;
inv_1852: n_2123  <= TRANSPORT NOT a_N499  ;
and1_1853: n_2124 <=  n_2125;
delay_1854: n_2125  <= TRANSPORT a_N429  ;
and1_1855: n_2126 <=  n_2127;
delay_1856: n_2127  <= TRANSPORT a_N388  ;
and1_1857: n_2128 <=  gnd;
delay_1858: a_N608_aNOT  <= TRANSPORT a_EQ153  ;
xor2_1859: a_EQ153 <=  n_2131  XOR n_2141;
or4_1860: n_2131 <=  n_2132  OR n_2135  OR n_2137  OR n_2139;
and1_1861: n_2132 <=  n_2133;
delay_1862: n_2133  <= TRANSPORT RXDATA  ;
and1_1863: n_2135 <=  n_2136;
delay_1864: n_2136  <= TRANSPORT a_N495  ;
and1_1865: n_2137 <=  n_2138;
delay_1866: n_2138  <= TRANSPORT a_N497  ;
and1_1867: n_2139 <=  n_2140;
delay_1868: n_2140  <= TRANSPORT a_N498  ;
and1_1869: n_2141 <=  gnd;
delay_1870: a_N134  <= TRANSPORT a_EQ048  ;
xor2_1871: a_EQ048 <=  n_2144  XOR n_2151;
or3_1872: n_2144 <=  n_2145  OR n_2147  OR n_2149;
and1_1873: n_2145 <=  n_2146;
delay_1874: n_2146  <= TRANSPORT a_N141  ;
and1_1875: n_2147 <=  n_2148;
delay_1876: n_2148  <= TRANSPORT a_N608_aNOT  ;
and1_1877: n_2149 <=  n_2150;
inv_1878: n_2150  <= TRANSPORT NOT a_N627_aNOT  ;
and1_1879: n_2151 <=  gnd;
delay_1880: a_N68  <= TRANSPORT a_EQ043  ;
xor2_1881: a_EQ043 <=  n_2154  XOR n_2161;
or2_1882: n_2154 <=  n_2155  OR n_2159;
and3_1883: n_2155 <=  n_2156  AND n_2157  AND n_2158;
delay_1884: n_2156  <= TRANSPORT a_N51_aNOT  ;
delay_1885: n_2157  <= TRANSPORT a_LC1_B8  ;
delay_1886: n_2158  <= TRANSPORT a_N134  ;
and1_1887: n_2159 <=  n_2160;
inv_1888: n_2160  <= TRANSPORT NOT a_N627_aNOT  ;
and1_1889: n_2161 <=  gnd;
dff_1890: DFF_a6850

    PORT MAP ( D => a_EQ124, CLK => a_N433_aCLK, CLRN => a_N433_aCLRN, PRN => vcc,
          Q => a_N433);
delay_1891: a_N433_aCLRN  <= TRANSPORT nRESET  ;
xor2_1892: a_EQ124 <=  n_2168  XOR n_2177;
or2_1893: n_2168 <=  n_2169  OR n_2173;
and3_1894: n_2169 <=  n_2170  AND n_2171  AND n_2172;
delay_1895: n_2170  <= TRANSPORT a_N398_aNOT  ;
delay_1896: n_2171  <= TRANSPORT a_N68  ;
delay_1897: n_2172  <= TRANSPORT a_N433  ;
and3_1898: n_2173 <=  n_2174  AND n_2175  AND n_2176;
inv_1899: n_2174  <= TRANSPORT NOT a_N398_aNOT  ;
delay_1900: n_2175  <= TRANSPORT a_N68  ;
inv_1901: n_2176  <= TRANSPORT NOT a_N433  ;
and1_1902: n_2177 <=  gnd;
delay_1903: n_2178  <= TRANSPORT RXCLK  ;
filter_1904: FILTER_a6850

    PORT MAP (IN1 => n_2178, Y => a_N433_aCLK);
dff_1905: DFF_a6850

    PORT MAP ( D => a_EQ125, CLK => a_N434_aCLK, CLRN => a_N434_aCLRN, PRN => vcc,
          Q => a_N434);
delay_1906: a_N434_aCLRN  <= TRANSPORT nRESET  ;
xor2_1907: a_EQ125 <=  n_2186  XOR n_2200;
or3_1908: n_2186 <=  n_2187  OR n_2191  OR n_2195;
and3_1909: n_2187 <=  n_2188  AND n_2189  AND n_2190;
delay_1910: n_2188  <= TRANSPORT a_N374_aNOT  ;
delay_1911: n_2189  <= TRANSPORT a_N68  ;
delay_1912: n_2190  <= TRANSPORT a_N434  ;
and3_1913: n_2191 <=  n_2192  AND n_2193  AND n_2194;
inv_1914: n_2192  <= TRANSPORT NOT a_N627_aNOT  ;
delay_1915: n_2193  <= TRANSPORT a_N68  ;
delay_1916: n_2194  <= TRANSPORT a_N434  ;
and4_1917: n_2195 <=  n_2196  AND n_2197  AND n_2198  AND n_2199;
delay_1918: n_2196  <= TRANSPORT a_N627_aNOT  ;
inv_1919: n_2197  <= TRANSPORT NOT a_N374_aNOT  ;
delay_1920: n_2198  <= TRANSPORT a_N68  ;
inv_1921: n_2199  <= TRANSPORT NOT a_N434  ;
and1_1922: n_2200 <=  gnd;
delay_1923: n_2201  <= TRANSPORT RXCLK  ;
filter_1924: FILTER_a6850

    PORT MAP (IN1 => n_2201, Y => a_N434_aCLK);
dff_1925: DFF_a6850

    PORT MAP ( D => a_EQ123, CLK => a_N432_aCLK, CLRN => a_N432_aCLRN, PRN => vcc,
          Q => a_N432);
delay_1926: a_N432_aCLRN  <= TRANSPORT nRESET  ;
xor2_1927: a_EQ123 <=  n_2209  XOR n_2223;
or3_1928: n_2209 <=  n_2210  OR n_2214  OR n_2218;
and3_1929: n_2210 <=  n_2211  AND n_2212  AND n_2213;
delay_1930: n_2211  <= TRANSPORT a_N68  ;
inv_1931: n_2212  <= TRANSPORT NOT a_N433  ;
delay_1932: n_2213  <= TRANSPORT a_N432  ;
and3_1933: n_2214 <=  n_2215  AND n_2216  AND n_2217;
delay_1934: n_2215  <= TRANSPORT a_N398_aNOT  ;
delay_1935: n_2216  <= TRANSPORT a_N68  ;
delay_1936: n_2217  <= TRANSPORT a_N432  ;
and4_1937: n_2218 <=  n_2219  AND n_2220  AND n_2221  AND n_2222;
inv_1938: n_2219  <= TRANSPORT NOT a_N398_aNOT  ;
delay_1939: n_2220  <= TRANSPORT a_N68  ;
delay_1940: n_2221  <= TRANSPORT a_N433  ;
inv_1941: n_2222  <= TRANSPORT NOT a_N432  ;
and1_1942: n_2223 <=  gnd;
delay_1943: n_2224  <= TRANSPORT RXCLK  ;
filter_1944: FILTER_a6850

    PORT MAP (IN1 => n_2224, Y => a_N432_aCLK);
delay_1945: a_N399  <= TRANSPORT a_EQ116  ;
xor2_1946: a_EQ116 <=  n_2228  XOR n_2237;
or4_1947: n_2228 <=  n_2229  OR n_2231  OR n_2233  OR n_2235;
and1_1948: n_2229 <=  n_2230;
inv_1949: n_2230  <= TRANSPORT NOT a_N431  ;
and1_1950: n_2231 <=  n_2232;
inv_1951: n_2232  <= TRANSPORT NOT a_N432  ;
and1_1952: n_2233 <=  n_2234;
inv_1953: n_2234  <= TRANSPORT NOT a_N433  ;
and1_1954: n_2235 <=  n_2236;
delay_1955: n_2236  <= TRANSPORT a_N398_aNOT  ;
and1_1956: n_2237 <=  gnd;
dff_1957: DFF_a6850

    PORT MAP ( D => a_EQ121, CLK => a_N430_aCLK, CLRN => a_N430_aCLRN, PRN => vcc,
          Q => a_N430);
delay_1958: a_N430_aCLRN  <= TRANSPORT nRESET  ;
xor2_1959: a_EQ121 <=  n_2244  XOR n_2253;
or2_1960: n_2244 <=  n_2245  OR n_2249;
and3_1961: n_2245 <=  n_2246  AND n_2247  AND n_2248;
delay_1962: n_2246  <= TRANSPORT a_N68  ;
inv_1963: n_2247  <= TRANSPORT NOT a_N399  ;
inv_1964: n_2248  <= TRANSPORT NOT a_N430  ;
and3_1965: n_2249 <=  n_2250  AND n_2251  AND n_2252;
delay_1966: n_2250  <= TRANSPORT a_N68  ;
delay_1967: n_2251  <= TRANSPORT a_N399  ;
delay_1968: n_2252  <= TRANSPORT a_N430  ;
and1_1969: n_2253 <=  gnd;
delay_1970: n_2254  <= TRANSPORT RXCLK  ;
filter_1971: FILTER_a6850

    PORT MAP (IN1 => n_2254, Y => a_N430_aCLK);
dff_1972: DFF_a6850

    PORT MAP ( D => a_EQ063, CLK => a_N170_aCLK, CLRN => a_N170_aCLRN, PRN => vcc,
          Q => a_N170);
delay_1973: a_N170_aCLRN  <= TRANSPORT nRESET  ;
xor2_1974: a_EQ063 <=  n_2262  XOR n_2274;
or3_1975: n_2262 <=  n_2263  OR n_2266  OR n_2270;
and2_1976: n_2263 <=  n_2264  AND n_2265;
delay_1977: n_2264  <= TRANSPORT a_LC5_A18  ;
delay_1978: n_2265  <= TRANSPORT a_N170  ;
and3_1979: n_2266 <=  n_2267  AND n_2268  AND n_2269;
inv_1980: n_2267  <= TRANSPORT NOT a_LC1_A5  ;
delay_1981: n_2268  <= TRANSPORT a_LC2_A18  ;
delay_1982: n_2269  <= TRANSPORT a_N170  ;
and3_1983: n_2270 <=  n_2271  AND n_2272  AND n_2273;
delay_1984: n_2271  <= TRANSPORT a_LC1_A5  ;
delay_1985: n_2272  <= TRANSPORT a_LC2_A18  ;
inv_1986: n_2273  <= TRANSPORT NOT a_N170  ;
and1_1987: n_2274 <=  gnd;
inv_1988: n_2275  <= TRANSPORT NOT TXCLK  ;
filter_1989: FILTER_a6850

    PORT MAP (IN1 => n_2275, Y => a_N170_aCLK);
dff_1990: DFF_a6850

    PORT MAP ( D => a_EQ120, CLK => a_N429_aCLK, CLRN => a_N429_aCLRN, PRN => vcc,
          Q => a_N429);
delay_1991: a_N429_aCLRN  <= TRANSPORT nRESET  ;
xor2_1992: a_EQ120 <=  n_2283  XOR n_2297;
or3_1993: n_2283 <=  n_2284  OR n_2288  OR n_2292;
and3_1994: n_2284 <=  n_2285  AND n_2286  AND n_2287;
delay_1995: n_2285  <= TRANSPORT a_N68  ;
inv_1996: n_2286  <= TRANSPORT NOT a_N430  ;
delay_1997: n_2287  <= TRANSPORT a_N429  ;
and3_1998: n_2288 <=  n_2289  AND n_2290  AND n_2291;
delay_1999: n_2289  <= TRANSPORT a_N68  ;
delay_2000: n_2290  <= TRANSPORT a_N399  ;
delay_2001: n_2291  <= TRANSPORT a_N429  ;
and4_2002: n_2292 <=  n_2293  AND n_2294  AND n_2295  AND n_2296;
delay_2003: n_2293  <= TRANSPORT a_N68  ;
inv_2004: n_2294  <= TRANSPORT NOT a_N399  ;
delay_2005: n_2295  <= TRANSPORT a_N430  ;
inv_2006: n_2296  <= TRANSPORT NOT a_N429  ;
and1_2007: n_2297 <=  gnd;
delay_2008: n_2298  <= TRANSPORT RXCLK  ;
filter_2009: FILTER_a6850

    PORT MAP (IN1 => n_2298, Y => a_N429_aCLK);
delay_2010: a_LC3_A14  <= TRANSPORT a_LC3_A14_aIN  ;
xor2_2011: a_LC3_A14_aIN <=  n_2302  XOR n_2306;
or1_2012: n_2302 <=  n_2303;
and2_2013: n_2303 <=  n_2304  AND n_2305;
delay_2014: n_2304  <= TRANSPORT a_LC2_A14  ;
delay_2015: n_2305  <= TRANSPORT a_N168  ;
and1_2016: n_2306 <=  gnd;
dff_2017: DFF_a6850

    PORT MAP ( D => a_EQ060, CLK => a_N167_aCLK, CLRN => a_N167_aCLRN, PRN => vcc,
          Q => a_N167);
delay_2018: a_N167_aCLRN  <= TRANSPORT nRESET  ;
xor2_2019: a_EQ060 <=  n_2313  XOR n_2325;
or3_2020: n_2313 <=  n_2314  OR n_2317  OR n_2321;
and2_2021: n_2314 <=  n_2315  AND n_2316;
delay_2022: n_2315  <= TRANSPORT a_LC5_A18  ;
delay_2023: n_2316  <= TRANSPORT a_N167  ;
and3_2024: n_2317 <=  n_2318  AND n_2319  AND n_2320;
delay_2025: n_2318  <= TRANSPORT a_LC2_A18  ;
inv_2026: n_2319  <= TRANSPORT NOT a_LC3_A14  ;
delay_2027: n_2320  <= TRANSPORT a_N167  ;
and3_2028: n_2321 <=  n_2322  AND n_2323  AND n_2324;
delay_2029: n_2322  <= TRANSPORT a_LC2_A18  ;
delay_2030: n_2323  <= TRANSPORT a_LC3_A14  ;
inv_2031: n_2324  <= TRANSPORT NOT a_N167  ;
and1_2032: n_2325 <=  gnd;
inv_2033: n_2326  <= TRANSPORT NOT TXCLK  ;
filter_2034: FILTER_a6850

    PORT MAP (IN1 => n_2326, Y => a_N167_aCLK);
dff_2035: DFF_a6850

    PORT MAP ( D => a_EQ061, CLK => a_N168_aCLK, CLRN => a_N168_aCLRN, PRN => vcc,
          Q => a_N168);
delay_2036: a_N168_aCLRN  <= TRANSPORT nRESET  ;
xor2_2037: a_EQ061 <=  n_2334  XOR n_2346;
or3_2038: n_2334 <=  n_2335  OR n_2338  OR n_2342;
and2_2039: n_2335 <=  n_2336  AND n_2337;
delay_2040: n_2336  <= TRANSPORT a_LC5_A18  ;
delay_2041: n_2337  <= TRANSPORT a_N168  ;
and3_2042: n_2338 <=  n_2339  AND n_2340  AND n_2341;
inv_2043: n_2339  <= TRANSPORT NOT a_LC2_A14  ;
delay_2044: n_2340  <= TRANSPORT a_LC2_A18  ;
delay_2045: n_2341  <= TRANSPORT a_N168  ;
and3_2046: n_2342 <=  n_2343  AND n_2344  AND n_2345;
delay_2047: n_2343  <= TRANSPORT a_LC2_A14  ;
delay_2048: n_2344  <= TRANSPORT a_LC2_A18  ;
inv_2049: n_2345  <= TRANSPORT NOT a_N168  ;
and1_2050: n_2346 <=  gnd;
inv_2051: n_2347  <= TRANSPORT NOT TXCLK  ;
filter_2052: FILTER_a6850

    PORT MAP (IN1 => n_2347, Y => a_N168_aCLK);
delay_2053: a_LC4_A14  <= TRANSPORT a_LC4_A14_aIN  ;
xor2_2054: a_LC4_A14_aIN <=  n_2351  XOR n_2357;
or1_2055: n_2351 <=  n_2352;
and4_2056: n_2352 <=  n_2353  AND n_2354  AND n_2355  AND n_2356;
delay_2057: n_2353  <= TRANSPORT a_LC2_A5  ;
delay_2058: n_2354  <= TRANSPORT a_N167  ;
delay_2059: n_2355  <= TRANSPORT a_N168  ;
delay_2060: n_2356  <= TRANSPORT a_N169  ;
and1_2061: n_2357 <=  gnd;
dff_2062: DFF_a6850

    PORT MAP ( D => a_EQ059, CLK => a_N166_aCLK, CLRN => a_N166_aCLRN, PRN => vcc,
          Q => a_N166);
delay_2063: a_N166_aCLRN  <= TRANSPORT nRESET  ;
xor2_2064: a_EQ059 <=  n_2364  XOR n_2376;
or3_2065: n_2364 <=  n_2365  OR n_2368  OR n_2372;
and2_2066: n_2365 <=  n_2366  AND n_2367;
delay_2067: n_2366  <= TRANSPORT a_LC5_A18  ;
delay_2068: n_2367  <= TRANSPORT a_N166  ;
and3_2069: n_2368 <=  n_2369  AND n_2370  AND n_2371;
delay_2070: n_2369  <= TRANSPORT a_LC2_A18  ;
inv_2071: n_2370  <= TRANSPORT NOT a_LC4_A14  ;
delay_2072: n_2371  <= TRANSPORT a_N166  ;
and3_2073: n_2372 <=  n_2373  AND n_2374  AND n_2375;
delay_2074: n_2373  <= TRANSPORT a_LC2_A18  ;
delay_2075: n_2374  <= TRANSPORT a_LC4_A14  ;
inv_2076: n_2375  <= TRANSPORT NOT a_N166  ;
and1_2077: n_2376 <=  gnd;
inv_2078: n_2377  <= TRANSPORT NOT TXCLK  ;
filter_2079: FILTER_a6850

    PORT MAP (IN1 => n_2377, Y => a_N166_aCLK);
dff_2080: DFF_a6850

    PORT MAP ( D => a_EQ062, CLK => a_N169_aCLK, CLRN => a_N169_aCLRN, PRN => vcc,
          Q => a_N169);
delay_2081: a_N169_aCLRN  <= TRANSPORT nRESET  ;
xor2_2082: a_EQ062 <=  n_2385  XOR n_2397;
or3_2083: n_2385 <=  n_2386  OR n_2389  OR n_2393;
and2_2084: n_2386 <=  n_2387  AND n_2388;
delay_2085: n_2387  <= TRANSPORT a_LC5_A18  ;
delay_2086: n_2388  <= TRANSPORT a_N169  ;
and3_2087: n_2389 <=  n_2390  AND n_2391  AND n_2392;
inv_2088: n_2390  <= TRANSPORT NOT a_LC2_A5  ;
delay_2089: n_2391  <= TRANSPORT a_LC2_A18  ;
delay_2090: n_2392  <= TRANSPORT a_N169  ;
and3_2091: n_2393 <=  n_2394  AND n_2395  AND n_2396;
delay_2092: n_2394  <= TRANSPORT a_LC2_A5  ;
delay_2093: n_2395  <= TRANSPORT a_LC2_A18  ;
inv_2094: n_2396  <= TRANSPORT NOT a_N169  ;
and1_2095: n_2397 <=  gnd;
inv_2096: n_2398  <= TRANSPORT NOT TXCLK  ;
filter_2097: FILTER_a6850

    PORT MAP (IN1 => n_2398, Y => a_N169_aCLK);
delay_2098: a_N387  <= TRANSPORT a_N387_aIN  ;
xor2_2099: a_N387_aIN <=  n_2402  XOR n_2407;
or1_2100: n_2402 <=  n_2403;
and3_2101: n_2403 <=  n_2404  AND n_2405  AND n_2406;
inv_2102: n_2404  <= TRANSPORT NOT a_N398_aNOT  ;
delay_2103: n_2405  <= TRANSPORT a_N433  ;
delay_2104: n_2406  <= TRANSPORT a_N432  ;
and1_2105: n_2407 <=  gnd;
dff_2106: DFF_a6850

    PORT MAP ( D => a_EQ122, CLK => a_N431_aCLK, CLRN => a_N431_aCLRN, PRN => vcc,
          Q => a_N431);
delay_2107: a_N431_aCLRN  <= TRANSPORT nRESET  ;
xor2_2108: a_EQ122 <=  n_2414  XOR n_2423;
or2_2109: n_2414 <=  n_2415  OR n_2419;
and3_2110: n_2415 <=  n_2416  AND n_2417  AND n_2418;
delay_2111: n_2416  <= TRANSPORT a_N68  ;
inv_2112: n_2417  <= TRANSPORT NOT a_N387  ;
delay_2113: n_2418  <= TRANSPORT a_N431  ;
and3_2114: n_2419 <=  n_2420  AND n_2421  AND n_2422;
delay_2115: n_2420  <= TRANSPORT a_N68  ;
delay_2116: n_2421  <= TRANSPORT a_N387  ;
inv_2117: n_2422  <= TRANSPORT NOT a_N431  ;
and1_2118: n_2423 <=  gnd;
delay_2119: n_2424  <= TRANSPORT RXCLK  ;
filter_2120: FILTER_a6850

    PORT MAP (IN1 => n_2424, Y => a_N431_aCLK);
delay_2121: a_LC7_A2  <= TRANSPORT a_EQ118  ;
xor2_2122: a_EQ118 <=  n_2428  XOR n_2435;
or2_2123: n_2428 <=  n_2429  OR n_2432;
and2_2124: n_2429 <=  n_2430  AND n_2431;
inv_2125: n_2430  <= TRANSPORT NOT a_N640_aNOT  ;
delay_2126: n_2431  <= TRANSPORT a_N36  ;
and2_2127: n_2432 <=  n_2433  AND n_2434;
delay_2128: n_2433  <= TRANSPORT a_N379_aNOT  ;
delay_2129: n_2434  <= TRANSPORT a_STX_REG_DATA_F1_G  ;
and1_2130: n_2435 <=  gnd;
dff_2131: DFF_a6850

    PORT MAP ( D => a_EQ030, CLK => a_N37_aCLK, CLRN => a_N37_aCLRN, PRN => vcc,
          Q => a_N37);
delay_2132: a_N37_aCLRN  <= TRANSPORT nRESET  ;
xor2_2133: a_EQ030 <=  n_2443  XOR n_2450;
or2_2134: n_2443 <=  n_2444  OR n_2447;
and2_2135: n_2444 <=  n_2445  AND n_2446;
delay_2136: n_2445  <= TRANSPORT a_N197  ;
delay_2137: n_2446  <= TRANSPORT a_N37  ;
and2_2138: n_2447 <=  n_2448  AND n_2449;
delay_2139: n_2448  <= TRANSPORT a_N627_aNOT  ;
delay_2140: n_2449  <= TRANSPORT a_LC7_A2  ;
and1_2141: n_2450 <=  gnd;
inv_2142: n_2451  <= TRANSPORT NOT TXCLK  ;
filter_2143: FILTER_a6850

    PORT MAP (IN1 => n_2451, Y => a_N37_aCLK);
delay_2144: a_N618_aNOT  <= TRANSPORT a_EQ155  ;
xor2_2145: a_EQ155 <=  n_2454  XOR n_2461;
or2_2146: n_2454 <=  n_2455  OR n_2458;
and1_2147: n_2455 <=  n_2456;
delay_2148: n_2456  <= TRANSPORT a_N952  ;
and1_2149: n_2458 <=  n_2459;
inv_2150: n_2459  <= TRANSPORT NOT a_N950  ;
and1_2151: n_2461 <=  gnd;
dff_2152: DFF_a6850

    PORT MAP ( D => a_EQ230, CLK => a_STX_REG_DATA_F6_G_aCLK, CLRN => a_STX_REG_DATA_F6_G_aCLRN,
          PRN => vcc, Q => a_STX_REG_DATA_F6_G);
delay_2153: a_STX_REG_DATA_F6_G_aCLRN  <= TRANSPORT nRESET  ;
xor2_2154: a_EQ230 <=  n_2468  XOR n_2477;
or2_2155: n_2468 <=  n_2469  OR n_2473;
and3_2156: n_2469 <=  n_2470  AND n_2471  AND n_2472;
delay_2157: n_2470  <= TRANSPORT a_N627_aNOT  ;
inv_2158: n_2471  <= TRANSPORT NOT a_N618_aNOT  ;
delay_2159: n_2472  <= TRANSPORT a_SINT_DI_F6_G  ;
and3_2160: n_2473 <=  n_2474  AND n_2475  AND n_2476;
delay_2161: n_2474  <= TRANSPORT a_N627_aNOT  ;
delay_2162: n_2475  <= TRANSPORT a_N618_aNOT  ;
delay_2163: n_2476  <= TRANSPORT a_STX_REG_DATA_F6_G  ;
and1_2164: n_2477 <=  gnd;
inv_2165: n_2478  <= TRANSPORT NOT TXCLK  ;
filter_2166: FILTER_a6850

    PORT MAP (IN1 => n_2478, Y => a_STX_REG_DATA_F6_G_aCLK);
dff_2167: DFF_a6850

    PORT MAP ( D => a_EQ229, CLK => a_STX_REG_DATA_F5_G_aCLK, CLRN => a_STX_REG_DATA_F5_G_aCLRN,
          PRN => vcc, Q => a_STX_REG_DATA_F5_G);
delay_2168: a_STX_REG_DATA_F5_G_aCLRN  <= TRANSPORT nRESET  ;
xor2_2169: a_EQ229 <=  n_2486  XOR n_2495;
or2_2170: n_2486 <=  n_2487  OR n_2491;
and3_2171: n_2487 <=  n_2488  AND n_2489  AND n_2490;
delay_2172: n_2488  <= TRANSPORT a_N627_aNOT  ;
delay_2173: n_2489  <= TRANSPORT a_N618_aNOT  ;
delay_2174: n_2490  <= TRANSPORT a_STX_REG_DATA_F5_G  ;
and3_2175: n_2491 <=  n_2492  AND n_2493  AND n_2494;
delay_2176: n_2492  <= TRANSPORT a_N627_aNOT  ;
inv_2177: n_2493  <= TRANSPORT NOT a_N618_aNOT  ;
delay_2178: n_2494  <= TRANSPORT a_SINT_DI_F5_G  ;
and1_2179: n_2495 <=  gnd;
inv_2180: n_2496  <= TRANSPORT NOT TXCLK  ;
filter_2181: FILTER_a6850

    PORT MAP (IN1 => n_2496, Y => a_STX_REG_DATA_F5_G_aCLK);
dff_2182: DFF_a6850

    PORT MAP ( D => a_EQ227, CLK => a_STX_REG_DATA_F3_G_aCLK, CLRN => a_STX_REG_DATA_F3_G_aCLRN,
          PRN => vcc, Q => a_STX_REG_DATA_F3_G);
delay_2183: a_STX_REG_DATA_F3_G_aCLRN  <= TRANSPORT nRESET  ;
xor2_2184: a_EQ227 <=  n_2504  XOR n_2514;
or2_2185: n_2504 <=  n_2505  OR n_2510;
and3_2186: n_2505 <=  n_2506  AND n_2507  AND n_2508;
delay_2187: n_2506  <= TRANSPORT a_N627_aNOT  ;
inv_2188: n_2507  <= TRANSPORT NOT a_N618_aNOT  ;
delay_2189: n_2508  <= TRANSPORT a_SINT_DI_F3_G  ;
and3_2190: n_2510 <=  n_2511  AND n_2512  AND n_2513;
delay_2191: n_2511  <= TRANSPORT a_N627_aNOT  ;
delay_2192: n_2512  <= TRANSPORT a_N618_aNOT  ;
delay_2193: n_2513  <= TRANSPORT a_STX_REG_DATA_F3_G  ;
and1_2194: n_2514 <=  gnd;
inv_2195: n_2515  <= TRANSPORT NOT TXCLK  ;
filter_2196: FILTER_a6850

    PORT MAP (IN1 => n_2515, Y => a_STX_REG_DATA_F3_G_aCLK);
dff_2197: DFF_a6850

    PORT MAP ( D => a_EQ228, CLK => a_STX_REG_DATA_F4_G_aCLK, CLRN => a_STX_REG_DATA_F4_G_aCLRN,
          PRN => vcc, Q => a_STX_REG_DATA_F4_G);
delay_2198: a_STX_REG_DATA_F4_G_aCLRN  <= TRANSPORT nRESET  ;
xor2_2199: a_EQ228 <=  n_2523  XOR n_2533;
or2_2200: n_2523 <=  n_2524  OR n_2528;
and3_2201: n_2524 <=  n_2525  AND n_2526  AND n_2527;
delay_2202: n_2525  <= TRANSPORT a_N627_aNOT  ;
delay_2203: n_2526  <= TRANSPORT a_N618_aNOT  ;
delay_2204: n_2527  <= TRANSPORT a_STX_REG_DATA_F4_G  ;
and3_2205: n_2528 <=  n_2529  AND n_2530  AND n_2531;
delay_2206: n_2529  <= TRANSPORT a_N627_aNOT  ;
inv_2207: n_2530  <= TRANSPORT NOT a_N618_aNOT  ;
delay_2208: n_2531  <= TRANSPORT a_SINT_DI_F4_G  ;
and1_2209: n_2533 <=  gnd;
inv_2210: n_2534  <= TRANSPORT NOT TXCLK  ;
filter_2211: FILTER_a6850

    PORT MAP (IN1 => n_2534, Y => a_STX_REG_DATA_F4_G_aCLK);
dff_2212: DFF_a6850

    PORT MAP ( D => a_EQ203, CLK => a_SINT_DI_F3_G_aCLK, CLRN => a_SINT_DI_F3_G_aCLRN,
          PRN => vcc, Q => a_SINT_DI_F3_G);
delay_2213: a_SINT_DI_F3_G_aCLRN  <= TRANSPORT nRESET  ;
xor2_2214: a_EQ203 <=  n_2543  XOR n_2550;
or2_2215: n_2543 <=  n_2544  OR n_2547;
and2_2216: n_2544 <=  n_2545  AND n_2546;
delay_2217: n_2545  <= TRANSPORT a_SINT_DI_F3_G  ;
inv_2218: n_2546  <= TRANSPORT NOT E  ;
and2_2219: n_2547 <=  n_2548  AND n_2549;
delay_2220: n_2548  <= TRANSPORT DI(3)  ;
delay_2221: n_2549  <= TRANSPORT E  ;
and1_2222: n_2550 <=  gnd;
delay_2223: n_2551  <= TRANSPORT TXCLK  ;
filter_2224: FILTER_a6850

    PORT MAP (IN1 => n_2551, Y => a_SINT_DI_F3_G_aCLK);
dff_2225: DFF_a6850

    PORT MAP ( D => a_EQ202, CLK => a_SINT_DI_F2_G_aCLK, CLRN => a_SINT_DI_F2_G_aCLRN,
          PRN => vcc, Q => a_SINT_DI_F2_G);
delay_2226: a_SINT_DI_F2_G_aCLRN  <= TRANSPORT nRESET  ;
xor2_2227: a_EQ202 <=  n_2561  XOR n_2568;
or2_2228: n_2561 <=  n_2562  OR n_2565;
and2_2229: n_2562 <=  n_2563  AND n_2564;
delay_2230: n_2563  <= TRANSPORT a_SINT_DI_F2_G  ;
inv_2231: n_2564  <= TRANSPORT NOT E  ;
and2_2232: n_2565 <=  n_2566  AND n_2567;
delay_2233: n_2566  <= TRANSPORT DI(2)  ;
delay_2234: n_2567  <= TRANSPORT E  ;
and1_2235: n_2568 <=  gnd;
delay_2236: n_2569  <= TRANSPORT TXCLK  ;
filter_2237: FILTER_a6850

    PORT MAP (IN1 => n_2569, Y => a_SINT_DI_F2_G_aCLK);
delay_2238: a_N587_aNOT  <= TRANSPORT a_EQ142  ;
xor2_2239: a_EQ142 <=  n_2572  XOR n_2586;
or4_2240: n_2572 <=  n_2573  OR n_2576  OR n_2579  OR n_2583;
and1_2241: n_2573 <=  n_2574;
inv_2242: n_2574  <= TRANSPORT NOT a_N204  ;
and1_2243: n_2576 <=  n_2577;
inv_2244: n_2577  <= TRANSPORT NOT a_N202  ;
and2_2245: n_2579 <=  n_2580  AND n_2582;
delay_2246: n_2580  <= TRANSPORT a_N205  ;
inv_2247: n_2582  <= TRANSPORT NOT word_lngth  ;
and2_2248: n_2583 <=  n_2584  AND n_2585;
inv_2249: n_2584  <= TRANSPORT NOT a_N205  ;
delay_2250: n_2585  <= TRANSPORT word_lngth  ;
and1_2251: n_2586 <=  gnd;
delay_2252: a_LC4_A15  <= TRANSPORT a_LC4_A15_aIN  ;
xor2_2253: a_LC4_A15_aIN <=  n_2589  XOR n_2593;
or1_2254: n_2589 <=  n_2590;
and2_2255: n_2590 <=  n_2591  AND n_2592;
delay_2256: n_2591  <= TRANSPORT a_LC3_A19  ;
delay_2257: n_2592  <= TRANSPORT a_N587_aNOT  ;
and1_2258: n_2593 <=  gnd;
dff_2259: DFF_a6850

    PORT MAP ( D => a_EQ070, CLK => a_N204_aCLK, CLRN => a_N204_aCLRN, PRN => vcc,
          Q => a_N204);
delay_2260: a_N204_aCLRN  <= TRANSPORT nRESET  ;
xor2_2261: a_EQ070 <=  n_2600  XOR n_2612;
or3_2262: n_2600 <=  n_2601  OR n_2605  OR n_2609;
and3_2263: n_2601 <=  n_2602  AND n_2603  AND n_2604;
delay_2264: n_2602  <= TRANSPORT a_LC4_A15  ;
delay_2265: n_2603  <= TRANSPORT a_N204  ;
inv_2266: n_2604  <= TRANSPORT NOT a_N205  ;
and3_2267: n_2605 <=  n_2606  AND n_2607  AND n_2608;
delay_2268: n_2606  <= TRANSPORT a_LC4_A15  ;
inv_2269: n_2607  <= TRANSPORT NOT a_N204  ;
delay_2270: n_2608  <= TRANSPORT a_N205  ;
and2_2271: n_2609 <=  n_2610  AND n_2611;
delay_2272: n_2610  <= TRANSPORT a_N640_aNOT  ;
delay_2273: n_2611  <= TRANSPORT a_N204  ;
and1_2274: n_2612 <=  gnd;
inv_2275: n_2613  <= TRANSPORT NOT TXCLK  ;
filter_2276: FILTER_a6850

    PORT MAP (IN1 => n_2613, Y => a_N204_aCLK);
delay_2277: a_N212  <= TRANSPORT a_EQ072  ;
xor2_2278: a_EQ072 <=  n_2617  XOR n_2622;
or2_2279: n_2617 <=  n_2618  OR n_2620;
and1_2280: n_2618 <=  n_2619;
inv_2281: n_2619  <= TRANSPORT NOT a_N204  ;
and1_2282: n_2620 <=  n_2621;
inv_2283: n_2621  <= TRANSPORT NOT a_N205  ;
and1_2284: n_2622 <=  gnd;
dff_2285: DFF_a6850

    PORT MAP ( D => a_EQ069, CLK => a_N202_aCLK, CLRN => a_N202_aCLRN, PRN => vcc,
          Q => a_N202);
delay_2286: a_N202_aCLRN  <= TRANSPORT nRESET  ;
xor2_2287: a_EQ069 <=  n_2629  XOR n_2641;
or3_2288: n_2629 <=  n_2630  OR n_2634  OR n_2638;
and3_2289: n_2630 <=  n_2631  AND n_2632  AND n_2633;
delay_2290: n_2631  <= TRANSPORT a_LC4_A15  ;
inv_2291: n_2632  <= TRANSPORT NOT a_N212  ;
inv_2292: n_2633  <= TRANSPORT NOT a_N202  ;
and3_2293: n_2634 <=  n_2635  AND n_2636  AND n_2637;
delay_2294: n_2635  <= TRANSPORT a_LC4_A15  ;
delay_2295: n_2636  <= TRANSPORT a_N212  ;
delay_2296: n_2637  <= TRANSPORT a_N202  ;
and2_2297: n_2638 <=  n_2639  AND n_2640;
delay_2298: n_2639  <= TRANSPORT a_N640_aNOT  ;
delay_2299: n_2640  <= TRANSPORT a_N202  ;
and1_2300: n_2641 <=  gnd;
inv_2301: n_2642  <= TRANSPORT NOT TXCLK  ;
filter_2302: FILTER_a6850

    PORT MAP (IN1 => n_2642, Y => a_N202_aCLK);
dff_2303: DFF_a6850

    PORT MAP ( D => a_EQ071, CLK => a_N205_aCLK, CLRN => a_N205_aCLRN, PRN => vcc,
          Q => a_N205);
delay_2304: a_N205_aCLRN  <= TRANSPORT nRESET  ;
xor2_2305: a_EQ071 <=  n_2650  XOR n_2657;
or2_2306: n_2650 <=  n_2651  OR n_2654;
and2_2307: n_2651 <=  n_2652  AND n_2653;
delay_2308: n_2652  <= TRANSPORT a_LC4_A15  ;
inv_2309: n_2653  <= TRANSPORT NOT a_N205  ;
and2_2310: n_2654 <=  n_2655  AND n_2656;
delay_2311: n_2655  <= TRANSPORT a_N640_aNOT  ;
delay_2312: n_2656  <= TRANSPORT a_N205  ;
and1_2313: n_2657 <=  gnd;
inv_2314: n_2658  <= TRANSPORT NOT TXCLK  ;
filter_2315: FILTER_a6850

    PORT MAP (IN1 => n_2658, Y => a_N205_aCLK);
dff_2316: DFF_a6850

    PORT MAP ( D => a_EQ204, CLK => a_SINT_DI_F4_G_aCLK, CLRN => a_SINT_DI_F4_G_aCLRN,
          PRN => vcc, Q => a_SINT_DI_F4_G);
delay_2317: a_SINT_DI_F4_G_aCLRN  <= TRANSPORT nRESET  ;
xor2_2318: a_EQ204 <=  n_2667  XOR n_2674;
or2_2319: n_2667 <=  n_2668  OR n_2671;
and2_2320: n_2668 <=  n_2669  AND n_2670;
delay_2321: n_2669  <= TRANSPORT a_SINT_DI_F4_G  ;
inv_2322: n_2670  <= TRANSPORT NOT E  ;
and2_2323: n_2671 <=  n_2672  AND n_2673;
delay_2324: n_2672  <= TRANSPORT DI(4)  ;
delay_2325: n_2673  <= TRANSPORT E  ;
and1_2326: n_2674 <=  gnd;
delay_2327: n_2675  <= TRANSPORT TXCLK  ;
filter_2328: FILTER_a6850

    PORT MAP (IN1 => n_2675, Y => a_SINT_DI_F4_G_aCLK);
dff_2329: DFF_a6850

    PORT MAP ( D => a_EQ226, CLK => a_STX_REG_DATA_F2_G_aCLK, CLRN => a_STX_REG_DATA_F2_G_aCLRN,
          PRN => vcc, Q => a_STX_REG_DATA_F2_G);
delay_2330: a_STX_REG_DATA_F2_G_aCLRN  <= TRANSPORT nRESET  ;
xor2_2331: a_EQ226 <=  n_2683  XOR n_2692;
or2_2332: n_2683 <=  n_2684  OR n_2688;
and3_2333: n_2684 <=  n_2685  AND n_2686  AND n_2687;
delay_2334: n_2685  <= TRANSPORT a_N627_aNOT  ;
delay_2335: n_2686  <= TRANSPORT a_N618_aNOT  ;
delay_2336: n_2687  <= TRANSPORT a_STX_REG_DATA_F2_G  ;
and3_2337: n_2688 <=  n_2689  AND n_2690  AND n_2691;
delay_2338: n_2689  <= TRANSPORT a_N627_aNOT  ;
inv_2339: n_2690  <= TRANSPORT NOT a_N618_aNOT  ;
delay_2340: n_2691  <= TRANSPORT a_SINT_DI_F2_G  ;
and1_2341: n_2692 <=  gnd;
inv_2342: n_2693  <= TRANSPORT NOT TXCLK  ;
filter_2343: FILTER_a6850

    PORT MAP (IN1 => n_2693, Y => a_STX_REG_DATA_F2_G_aCLK);
dff_2344: DFF_a6850

    PORT MAP ( D => a_EQ224, CLK => a_STX_REG_DATA_F0_G_aCLK, CLRN => a_STX_REG_DATA_F0_G_aCLRN,
          PRN => vcc, Q => a_STX_REG_DATA_F0_G);
delay_2345: a_STX_REG_DATA_F0_G_aCLRN  <= TRANSPORT nRESET  ;
xor2_2346: a_EQ224 <=  n_2701  XOR n_2710;
or2_2347: n_2701 <=  n_2702  OR n_2706;
and3_2348: n_2702 <=  n_2703  AND n_2704  AND n_2705;
delay_2349: n_2703  <= TRANSPORT a_N627_aNOT  ;
inv_2350: n_2704  <= TRANSPORT NOT a_N618_aNOT  ;
delay_2351: n_2705  <= TRANSPORT a_SINT_DI_F0_G  ;
and3_2352: n_2706 <=  n_2707  AND n_2708  AND n_2709;
delay_2353: n_2707  <= TRANSPORT a_N627_aNOT  ;
delay_2354: n_2708  <= TRANSPORT a_N618_aNOT  ;
delay_2355: n_2709  <= TRANSPORT a_STX_REG_DATA_F0_G  ;
and1_2356: n_2710 <=  gnd;
inv_2357: n_2711  <= TRANSPORT NOT TXCLK  ;
filter_2358: FILTER_a6850

    PORT MAP (IN1 => n_2711, Y => a_STX_REG_DATA_F0_G_aCLK);
dff_2359: DFF_a6850

    PORT MAP ( D => a_EQ225, CLK => a_STX_REG_DATA_F1_G_aCLK, CLRN => a_STX_REG_DATA_F1_G_aCLRN,
          PRN => vcc, Q => a_STX_REG_DATA_F1_G);
delay_2360: a_STX_REG_DATA_F1_G_aCLRN  <= TRANSPORT nRESET  ;
xor2_2361: a_EQ225 <=  n_2719  XOR n_2728;
or2_2362: n_2719 <=  n_2720  OR n_2724;
and3_2363: n_2720 <=  n_2721  AND n_2722  AND n_2723;
delay_2364: n_2721  <= TRANSPORT a_N627_aNOT  ;
inv_2365: n_2722  <= TRANSPORT NOT a_N618_aNOT  ;
delay_2366: n_2723  <= TRANSPORT a_SINT_DI_F1_G  ;
and3_2367: n_2724 <=  n_2725  AND n_2726  AND n_2727;
delay_2368: n_2725  <= TRANSPORT a_N627_aNOT  ;
delay_2369: n_2726  <= TRANSPORT a_N618_aNOT  ;
delay_2370: n_2727  <= TRANSPORT a_STX_REG_DATA_F1_G  ;
and1_2371: n_2728 <=  gnd;
inv_2372: n_2729  <= TRANSPORT NOT TXCLK  ;
filter_2373: FILTER_a6850

    PORT MAP (IN1 => n_2729, Y => a_STX_REG_DATA_F1_G_aCLK);
dff_2374: DFF_a6850

    PORT MAP ( D => a_EQ190, CLK => a_N892_aCLK, CLRN => a_N892_aCLRN, PRN => vcc,
          Q => a_N892);
delay_2375: a_N892_aCLRN  <= TRANSPORT nRESET  ;
xor2_2376: a_EQ190 <=  n_2737  XOR n_2748;
or3_2377: n_2737 <=  n_2738  OR n_2741  OR n_2744;
and2_2378: n_2738 <=  n_2739  AND n_2740;
delay_2379: n_2739  <= TRANSPORT a_N892  ;
delay_2380: n_2740  <= TRANSPORT a_N951  ;
and2_2381: n_2741 <=  n_2742  AND n_2743;
delay_2382: n_2742  <= TRANSPORT a_N892  ;
inv_2383: n_2743  <= TRANSPORT NOT a_N949  ;
and3_2384: n_2744 <=  n_2745  AND n_2746  AND n_2747;
delay_2385: n_2745  <= TRANSPORT a_SINT_DI_F3_G  ;
inv_2386: n_2746  <= TRANSPORT NOT a_N951  ;
delay_2387: n_2747  <= TRANSPORT a_N949  ;
and1_2388: n_2748 <=  gnd;
inv_2389: n_2749  <= TRANSPORT NOT RXCLK  ;
filter_2390: FILTER_a6850

    PORT MAP (IN1 => n_2749, Y => a_N892_aCLK);
dff_2391: DFF_a6850

    PORT MAP ( D => a_EQ191, CLK => a_N893_aCLK, CLRN => a_N893_aCLRN, PRN => vcc,
          Q => a_N893);
delay_2392: a_N893_aCLRN  <= TRANSPORT nRESET  ;
xor2_2393: a_EQ191 <=  n_2757  XOR n_2768;
or3_2394: n_2757 <=  n_2758  OR n_2761  OR n_2764;
and2_2395: n_2758 <=  n_2759  AND n_2760;
delay_2396: n_2759  <= TRANSPORT a_N893  ;
delay_2397: n_2760  <= TRANSPORT a_N951  ;
and2_2398: n_2761 <=  n_2762  AND n_2763;
delay_2399: n_2762  <= TRANSPORT a_N893  ;
inv_2400: n_2763  <= TRANSPORT NOT a_N949  ;
and3_2401: n_2764 <=  n_2765  AND n_2766  AND n_2767;
delay_2402: n_2765  <= TRANSPORT a_SINT_DI_F2_G  ;
inv_2403: n_2766  <= TRANSPORT NOT a_N951  ;
delay_2404: n_2767  <= TRANSPORT a_N949  ;
and1_2405: n_2768 <=  gnd;
inv_2406: n_2769  <= TRANSPORT NOT RXCLK  ;
filter_2407: FILTER_a6850

    PORT MAP (IN1 => n_2769, Y => a_N893_aCLK);
dff_2408: DFF_a6850

    PORT MAP ( D => a_EQ231, CLK => a_STX_REG_DATA_F7_G_aCLK, CLRN => a_STX_REG_DATA_F7_G_aCLRN,
          PRN => vcc, Q => a_STX_REG_DATA_F7_G);
delay_2409: a_STX_REG_DATA_F7_G_aCLRN  <= TRANSPORT nRESET  ;
xor2_2410: a_EQ231 <=  n_2777  XOR n_2786;
or2_2411: n_2777 <=  n_2778  OR n_2782;
and3_2412: n_2778 <=  n_2779  AND n_2780  AND n_2781;
delay_2413: n_2779  <= TRANSPORT a_N627_aNOT  ;
delay_2414: n_2780  <= TRANSPORT a_N618_aNOT  ;
delay_2415: n_2781  <= TRANSPORT a_STX_REG_DATA_F7_G  ;
and3_2416: n_2782 <=  n_2783  AND n_2784  AND n_2785;
delay_2417: n_2783  <= TRANSPORT a_N627_aNOT  ;
inv_2418: n_2784  <= TRANSPORT NOT a_N618_aNOT  ;
delay_2419: n_2785  <= TRANSPORT a_SINT_DI_F7_G  ;
and1_2420: n_2786 <=  gnd;
inv_2421: n_2787  <= TRANSPORT NOT TXCLK  ;
filter_2422: FILTER_a6850

    PORT MAP (IN1 => n_2787, Y => a_STX_REG_DATA_F7_G_aCLK);
delay_2423: a_LC7_A21  <= TRANSPORT a_LC7_A21_aIN  ;
xor2_2424: a_LC7_A21_aIN <=  n_2790  XOR n_2796;
or1_2425: n_2790 <=  n_2791;
and4_2426: n_2791 <=  n_2792  AND n_2793  AND n_2794  AND n_2795;
inv_2427: n_2792  <= TRANSPORT NOT CS(0)  ;
delay_2428: n_2793  <= TRANSPORT CS(1)  ;
delay_2429: n_2794  <= TRANSPORT CS(2)  ;
delay_2430: n_2795  <= TRANSPORT E  ;
and1_2431: n_2796 <=  gnd;
dff_2432: DFF_a6850

    PORT MAP ( D => a_N952_aD, CLK => a_N952_aCLK, CLRN => a_N952_aCLRN, PRN => vcc,
          Q => a_N952);
delay_2433: a_N952_aCLRN  <= TRANSPORT nRESET  ;
xor2_2434: a_N952_aD <=  n_2803  XOR n_2808;
or1_2435: n_2803 <=  n_2804;
and3_2436: n_2804 <=  n_2805  AND n_2806  AND n_2807;
delay_2437: n_2805  <= TRANSPORT a_LC7_A21  ;
inv_2438: n_2806  <= TRANSPORT NOT RnW  ;
delay_2439: n_2807  <= TRANSPORT RS  ;
and1_2440: n_2808 <=  gnd;
delay_2441: n_2809  <= TRANSPORT TXCLK  ;
filter_2442: FILTER_a6850

    PORT MAP (IN1 => n_2809, Y => a_N952_aCLK);
dff_2443: DFF_a6850

    PORT MAP ( D => a_N950_aD, CLK => a_N950_aCLK, CLRN => a_N950_aCLRN, PRN => vcc,
          Q => a_N950);
delay_2444: a_N950_aCLRN  <= TRANSPORT nRESET  ;
xor2_2445: a_N950_aD <=  n_2817  XOR n_2820;
or1_2446: n_2817 <=  n_2818;
and1_2447: n_2818 <=  n_2819;
delay_2448: n_2819  <= TRANSPORT a_N952  ;
and1_2449: n_2820 <=  gnd;
inv_2450: n_2821  <= TRANSPORT NOT TXCLK  ;
filter_2451: FILTER_a6850

    PORT MAP (IN1 => n_2821, Y => a_N950_aCLK);
delay_2452: a_N600  <= TRANSPORT a_N600_aIN  ;
xor2_2453: a_N600_aIN <=  n_2825  XOR n_2829;
or1_2454: n_2825 <=  n_2826;
and2_2455: n_2826 <=  n_2827  AND n_2828;
delay_2456: n_2827  <= TRANSPORT a_N498  ;
delay_2457: n_2828  <= TRANSPORT a_N499  ;
and1_2458: n_2829 <=  gnd;
delay_2459: a_LC1_B10  <= TRANSPORT a_EQ131  ;
xor2_2460: a_EQ131 <=  n_2832  XOR n_2841;
or2_2461: n_2832 <=  n_2833  OR n_2837;
and3_2462: n_2833 <=  n_2834  AND n_2835  AND n_2836;
delay_2463: n_2834  <= TRANSPORT a_N600  ;
delay_2464: n_2835  <= TRANSPORT a_N497  ;
delay_2465: n_2836  <= TRANSPORT a_SSTS_REG_F0_G  ;
and3_2466: n_2837 <=  n_2838  AND n_2839  AND n_2840;
inv_2467: n_2838  <= TRANSPORT NOT a_N593  ;
delay_2468: n_2839  <= TRANSPORT a_N600  ;
delay_2469: n_2840  <= TRANSPORT a_N497  ;
and1_2470: n_2841 <=  gnd;
delay_2471: a_N48_aNOT  <= TRANSPORT a_N48_aNOT_aIN  ;
xor2_2472: a_N48_aNOT_aIN <=  n_2844  XOR n_2849;
or1_2473: n_2844 <=  n_2845;
and3_2474: n_2845 <=  n_2846  AND n_2847  AND n_2848;
inv_2475: n_2846  <= TRANSPORT NOT a_N603_aNOT  ;
delay_2476: n_2847  <= TRANSPORT a_N495  ;
inv_2477: n_2848  <= TRANSPORT NOT a_N499  ;
and1_2478: n_2849 <=  gnd;
delay_2479: a_LC5_B10  <= TRANSPORT a_LC5_B10_aIN  ;
xor2_2480: a_LC5_B10_aIN <=  n_2852  XOR n_2858;
or1_2481: n_2852 <=  n_2853;
and4_2482: n_2853 <=  n_2854  AND n_2855  AND n_2856  AND n_2857;
delay_2483: n_2854  <= TRANSPORT a_N495  ;
inv_2484: n_2855  <= TRANSPORT NOT a_N498  ;
inv_2485: n_2856  <= TRANSPORT NOT a_N499  ;
inv_2486: n_2857  <= TRANSPORT NOT a_N497  ;
and1_2487: n_2858 <=  gnd;
delay_2488: a_LC5_B14  <= TRANSPORT a_LC5_B14_aIN  ;
xor2_2489: a_LC5_B14_aIN <=  n_2860  XOR n_2866;
or1_2490: n_2860 <=  n_2861;
and4_2491: n_2861 <=  n_2862  AND n_2863  AND n_2864  AND n_2865;
delay_2492: n_2862  <= TRANSPORT a_N495  ;
delay_2493: n_2863  <= TRANSPORT a_N498  ;
inv_2494: n_2864  <= TRANSPORT NOT a_N499  ;
delay_2495: n_2865  <= TRANSPORT a_N497  ;
and1_2496: n_2866 <=  gnd;
delay_2497: a_N28  <= TRANSPORT a_N28_aIN  ;
xor2_2498: a_N28_aIN <=  n_2869  XOR n_2873;
or1_2499: n_2869 <=  n_2870;
and2_2500: n_2870 <=  n_2871  AND n_2872;
inv_2501: n_2871  <= TRANSPORT NOT a_N498  ;
delay_2502: n_2872  <= TRANSPORT a_N499  ;
and1_2503: n_2873 <=  gnd;
delay_2504: a_N31_aNOT  <= TRANSPORT a_EQ024  ;
xor2_2505: a_EQ024 <=  n_2876  XOR n_2884;
or2_2506: n_2876 <=  n_2877  OR n_2880;
and2_2507: n_2877 <=  n_2878  AND n_2879;
delay_2508: n_2878  <= TRANSPORT a_LC5_B14  ;
delay_2509: n_2879  <= TRANSPORT a_SSTS_REG_F0_G  ;
and3_2510: n_2880 <=  n_2881  AND n_2882  AND n_2883;
delay_2511: n_2881  <= TRANSPORT a_N28  ;
delay_2512: n_2882  <= TRANSPORT a_N495  ;
delay_2513: n_2883  <= TRANSPORT a_SSTS_REG_F0_G  ;
and1_2514: n_2884 <=  gnd;
delay_2515: a_LC2_B10  <= TRANSPORT a_EQ132  ;
xor2_2516: a_EQ132 <=  n_2887  XOR n_2896;
or4_2517: n_2887 <=  n_2888  OR n_2890  OR n_2892  OR n_2894;
and1_2518: n_2888 <=  n_2889;
delay_2519: n_2889  <= TRANSPORT a_LC1_B10  ;
and1_2520: n_2890 <=  n_2891;
delay_2521: n_2891  <= TRANSPORT a_N48_aNOT  ;
and1_2522: n_2892 <=  n_2893;
delay_2523: n_2893  <= TRANSPORT a_LC5_B10  ;
and1_2524: n_2894 <=  n_2895;
delay_2525: n_2895  <= TRANSPORT a_N31_aNOT  ;
and1_2526: n_2896 <=  gnd;
delay_2527: a_N146_aNOT  <= TRANSPORT a_N146_aNOT_aIN  ;
xor2_2528: a_N146_aNOT_aIN <=  n_2899  XOR n_2905;
or1_2529: n_2899 <=  n_2900;
and4_2530: n_2900 <=  n_2901  AND n_2902  AND n_2903  AND n_2904;
inv_2531: n_2901  <= TRANSPORT NOT a_N608_aNOT  ;
inv_2532: n_2902  <= TRANSPORT NOT a_N499  ;
inv_2533: n_2903  <= TRANSPORT NOT a_N894  ;
inv_2534: n_2904  <= TRANSPORT NOT a_N895  ;
and1_2535: n_2905 <=  gnd;
delay_2536: a_N263  <= TRANSPORT a_N263_aIN  ;
xor2_2537: a_N263_aIN <=  n_2908  XOR n_2913;
or1_2538: n_2908 <=  n_2909;
and3_2539: n_2909 <=  n_2910  AND n_2911  AND n_2912;
delay_2540: n_2910  <= TRANSPORT a_N495  ;
inv_2541: n_2911  <= TRANSPORT NOT a_N498  ;
inv_2542: n_2912  <= TRANSPORT NOT a_N499  ;
and1_2543: n_2913 <=  gnd;
delay_2544: a_N637_aNOT  <= TRANSPORT a_EQ172  ;
xor2_2545: a_EQ172 <=  n_2916  XOR n_2925;
or2_2546: n_2916 <=  n_2917  OR n_2921;
and3_2547: n_2917 <=  n_2918  AND n_2919  AND n_2920;
delay_2548: n_2918  <= TRANSPORT a_N263  ;
delay_2549: n_2919  <= TRANSPORT a_N497  ;
delay_2550: n_2920  <= TRANSPORT a_SSTS_REG_F0_G  ;
and3_2551: n_2921 <=  n_2922  AND n_2923  AND n_2924;
inv_2552: n_2922  <= TRANSPORT NOT a_N593  ;
delay_2553: n_2923  <= TRANSPORT a_N263  ;
delay_2554: n_2924  <= TRANSPORT a_N497  ;
and1_2555: n_2925 <=  gnd;
delay_2556: a_N42_aNOT  <= TRANSPORT a_EQ031  ;
xor2_2557: a_EQ031 <=  n_2928  XOR n_2935;
or2_2558: n_2928 <=  n_2929  OR n_2931;
and1_2559: n_2929 <=  n_2930;
delay_2560: n_2930  <= TRANSPORT a_N637_aNOT  ;
and3_2561: n_2931 <=  n_2932  AND n_2933  AND n_2934;
delay_2562: n_2932  <= TRANSPORT a_N600  ;
delay_2563: n_2933  <= TRANSPORT a_N495  ;
inv_2564: n_2934  <= TRANSPORT NOT a_N497  ;
and1_2565: n_2935 <=  gnd;
dff_2566: DFF_a6850

    PORT MAP ( D => a_EQ130, CLK => a_N495_aCLK, CLRN => a_N495_aCLRN, PRN => vcc,
          Q => a_N495);
delay_2567: a_N495_aCLRN  <= TRANSPORT nRESET  ;
xor2_2568: a_EQ130 <=  n_2942  XOR n_2952;
or3_2569: n_2942 <=  n_2943  OR n_2946  OR n_2949;
and2_2570: n_2943 <=  n_2944  AND n_2945;
delay_2571: n_2944  <= TRANSPORT a_N627_aNOT  ;
delay_2572: n_2945  <= TRANSPORT a_LC2_B10  ;
and2_2573: n_2946 <=  n_2947  AND n_2948;
delay_2574: n_2947  <= TRANSPORT a_N627_aNOT  ;
delay_2575: n_2948  <= TRANSPORT a_N146_aNOT  ;
and2_2576: n_2949 <=  n_2950  AND n_2951;
delay_2577: n_2950  <= TRANSPORT a_N627_aNOT  ;
delay_2578: n_2951  <= TRANSPORT a_N42_aNOT  ;
and1_2579: n_2952 <=  gnd;
delay_2580: n_2953  <= TRANSPORT RXCLK  ;
filter_2581: FILTER_a6850

    PORT MAP (IN1 => n_2953, Y => a_N495_aCLK);
delay_2582: a_N591  <= TRANSPORT a_EQ144  ;
xor2_2583: a_EQ144 <=  n_2956  XOR n_2961;
or2_2584: n_2956 <=  n_2957  OR n_2959;
and1_2585: n_2957 <=  n_2958;
inv_2586: n_2958  <= TRANSPORT NOT word_lngth  ;
and1_2587: n_2959 <=  n_2960;
delay_2588: n_2960  <= TRANSPORT a_N892  ;
and1_2589: n_2961 <=  gnd;
delay_2590: a_N145_aNOT  <= TRANSPORT a_N145_aNOT_aIN  ;
xor2_2591: a_N145_aNOT_aIN <=  n_2964  XOR n_2968;
or1_2592: n_2964 <=  n_2965;
and2_2593: n_2965 <=  n_2966  AND n_2967;
inv_2594: n_2966  <= TRANSPORT NOT a_N126_aNOT  ;
delay_2595: n_2967  <= TRANSPORT a_N591  ;
and1_2596: n_2968 <=  gnd;
delay_2597: a_LC2_B19  <= TRANSPORT a_EQ140  ;
xor2_2598: a_EQ140 <=  n_2971  XOR n_2980;
or2_2599: n_2971 <=  n_2972  OR n_2976;
and3_2600: n_2972 <=  n_2973  AND n_2974  AND n_2975;
inv_2601: n_2973  <= TRANSPORT NOT a_N603_aNOT  ;
inv_2602: n_2974  <= TRANSPORT NOT a_N495  ;
inv_2603: n_2975  <= TRANSPORT NOT a_N499  ;
and3_2604: n_2976 <=  n_2977  AND n_2978  AND n_2979;
inv_2605: n_2977  <= TRANSPORT NOT a_N603_aNOT  ;
inv_2606: n_2978  <= TRANSPORT NOT a_N495  ;
inv_2607: n_2979  <= TRANSPORT NOT a_N145_aNOT  ;
and1_2608: n_2980 <=  gnd;
delay_2609: a_N261_aNOT  <= TRANSPORT a_N261_aNOT_aIN  ;
xor2_2610: a_N261_aNOT_aIN <=  n_2982  XOR n_2988;
or1_2611: n_2982 <=  n_2983;
and4_2612: n_2983 <=  n_2984  AND n_2985  AND n_2986  AND n_2987;
delay_2613: n_2984  <= TRANSPORT a_N593  ;
delay_2614: n_2985  <= TRANSPORT a_N498  ;
delay_2615: n_2986  <= TRANSPORT a_N499  ;
delay_2616: n_2987  <= TRANSPORT a_N497  ;
and1_2617: n_2988 <=  gnd;
delay_2618: a_LC4_B16  <= TRANSPORT a_EQ032  ;
xor2_2619: a_EQ032 <=  n_2991  XOR n_3002;
or2_2620: n_2991 <=  n_2992  OR n_2997;
and4_2621: n_2992 <=  n_2993  AND n_2994  AND n_2995  AND n_2996;
inv_2622: n_2993  <= TRANSPORT NOT a_N495  ;
inv_2623: n_2994  <= TRANSPORT NOT a_N498  ;
delay_2624: n_2995  <= TRANSPORT a_N499  ;
delay_2625: n_2996  <= TRANSPORT a_N497  ;
and4_2626: n_2997 <=  n_2998  AND n_2999  AND n_3000  AND n_3001;
inv_2627: n_2998  <= TRANSPORT NOT a_N495  ;
delay_2628: n_2999  <= TRANSPORT a_N498  ;
inv_2629: n_3000  <= TRANSPORT NOT a_N499  ;
delay_2630: n_3001  <= TRANSPORT a_N497  ;
and1_2631: n_3002 <=  gnd;
delay_2632: a_N43_aNOT  <= TRANSPORT a_EQ033  ;
xor2_2633: a_EQ033 <=  n_3005  XOR n_3013;
or3_2634: n_3005 <=  n_3006  OR n_3008  OR n_3011;
and1_2635: n_3006 <=  n_3007;
delay_2636: n_3007  <= TRANSPORT a_N31_aNOT  ;
and2_2637: n_3008 <=  n_3009  AND n_3010;
delay_2638: n_3009  <= TRANSPORT a_N261_aNOT  ;
delay_2639: n_3010  <= TRANSPORT a_SSTS_REG_F0_G  ;
and1_2640: n_3011 <=  n_3012;
delay_2641: n_3012  <= TRANSPORT a_LC4_B16  ;
and1_2642: n_3013 <=  gnd;
delay_2643: a_LC7_B19  <= TRANSPORT a_EQ141  ;
xor2_2644: a_EQ141 <=  n_3016  XOR n_3025;
or4_2645: n_3016 <=  n_3017  OR n_3019  OR n_3021  OR n_3023;
and1_2646: n_3017 <=  n_3018;
delay_2647: n_3018  <= TRANSPORT a_LC2_B19  ;
and1_2648: n_3019 <=  n_3020;
delay_2649: n_3020  <= TRANSPORT a_N43_aNOT  ;
and1_2650: n_3021 <=  n_3022;
delay_2651: n_3022  <= TRANSPORT a_N146_aNOT  ;
and1_2652: n_3023 <=  n_3024;
inv_2653: n_3024  <= TRANSPORT NOT a_N134  ;
and1_2654: n_3025 <=  gnd;
delay_2655: a_LC6_B9  <= TRANSPORT a_EQ138  ;
xor2_2656: a_EQ138 <=  n_3028  XOR n_3037;
or2_2657: n_3028 <=  n_3029  OR n_3033;
and3_2658: n_3029 <=  n_3030  AND n_3031  AND n_3032;
inv_2659: n_3030  <= TRANSPORT NOT a_N603_aNOT  ;
delay_2660: n_3031  <= TRANSPORT a_N591  ;
inv_2661: n_3032  <= TRANSPORT NOT a_N499  ;
and3_2662: n_3033 <=  n_3034  AND n_3035  AND n_3036;
delay_2663: n_3034  <= TRANSPORT a_N642_aNOT  ;
inv_2664: n_3035  <= TRANSPORT NOT a_N603_aNOT  ;
inv_2665: n_3036  <= TRANSPORT NOT a_N499  ;
and1_2666: n_3037 <=  gnd;
delay_2667: a_LC3_B9  <= TRANSPORT a_LC3_B9_aIN  ;
xor2_2668: a_LC3_B9_aIN <=  n_3040  XOR n_3045;
or1_2669: n_3040 <=  n_3041;
and3_2670: n_3041 <=  n_3042  AND n_3043  AND n_3044;
inv_2671: n_3042  <= TRANSPORT NOT a_N498  ;
inv_2672: n_3043  <= TRANSPORT NOT a_N499  ;
delay_2673: n_3044  <= TRANSPORT a_N497  ;
and1_2674: n_3045 <=  gnd;
delay_2675: a_LC5_B9  <= TRANSPORT a_EQ139  ;
xor2_2676: a_EQ139 <=  n_3048  XOR n_3055;
or2_2677: n_3048 <=  n_3049  OR n_3051;
and1_2678: n_3049 <=  n_3050;
delay_2679: n_3050  <= TRANSPORT a_LC6_B9  ;
and3_2680: n_3051 <=  n_3052  AND n_3053  AND n_3054;
delay_2681: n_3052  <= TRANSPORT a_N593  ;
delay_2682: n_3053  <= TRANSPORT a_LC3_B9  ;
delay_2683: n_3054  <= TRANSPORT a_SSTS_REG_F0_G  ;
and1_2684: n_3055 <=  gnd;
dff_2685: DFF_a6850

    PORT MAP ( D => a_EQ134, CLK => a_N498_aCLK, CLRN => a_N498_aCLRN, PRN => vcc,
          Q => a_N498);
delay_2686: a_N498_aCLRN  <= TRANSPORT nRESET  ;
xor2_2687: a_EQ134 <=  n_3062  XOR n_3070;
or2_2688: n_3062 <=  n_3063  OR n_3066;
and2_2689: n_3063 <=  n_3064  AND n_3065;
delay_2690: n_3064  <= TRANSPORT a_N627_aNOT  ;
delay_2691: n_3065  <= TRANSPORT a_LC7_B19  ;
and3_2692: n_3066 <=  n_3067  AND n_3068  AND n_3069;
delay_2693: n_3067  <= TRANSPORT a_N627_aNOT  ;
delay_2694: n_3068  <= TRANSPORT a_N495  ;
delay_2695: n_3069  <= TRANSPORT a_LC5_B9  ;
and1_2696: n_3070 <=  gnd;
delay_2697: n_3071  <= TRANSPORT RXCLK  ;
filter_2698: FILTER_a6850

    PORT MAP (IN1 => n_3071, Y => a_N498_aCLK);
delay_2699: a_LC2_B1  <= TRANSPORT a_EQ052  ;
xor2_2700: a_EQ052 <=  n_3075  XOR n_3084;
or2_2701: n_3075 <=  n_3076  OR n_3080;
and3_2702: n_3076 <=  n_3077  AND n_3078  AND n_3079;
delay_2703: n_3077  <= TRANSPORT a_N145_aNOT  ;
delay_2704: n_3078  <= TRANSPORT a_N498  ;
inv_2705: n_3079  <= TRANSPORT NOT a_N497  ;
and3_2706: n_3080 <=  n_3081  AND n_3082  AND n_3083;
inv_2707: n_3081  <= TRANSPORT NOT a_N593  ;
inv_2708: n_3082  <= TRANSPORT NOT a_N498  ;
delay_2709: n_3083  <= TRANSPORT a_N497  ;
and1_2710: n_3084 <=  gnd;
delay_2711: a_LC1_B1  <= TRANSPORT a_LC1_B1_aIN  ;
xor2_2712: a_LC1_B1_aIN <=  n_3087  XOR n_3092;
or1_2713: n_3087 <=  n_3088;
and3_2714: n_3088 <=  n_3089  AND n_3090  AND n_3091;
delay_2715: n_3089  <= TRANSPORT a_N495  ;
delay_2716: n_3090  <= TRANSPORT a_LC2_B1  ;
inv_2717: n_3091  <= TRANSPORT NOT a_N499  ;
and1_2718: n_3092 <=  gnd;
delay_2719: a_N140_aNOT  <= TRANSPORT a_N140_aNOT_aIN  ;
xor2_2720: a_N140_aNOT_aIN <=  n_3095  XOR n_3100;
or1_2721: n_3095 <=  n_3096;
and3_2722: n_3096 <=  n_3097  AND n_3098  AND n_3099;
delay_2723: n_3097  <= TRANSPORT a_N141  ;
inv_2724: n_3098  <= TRANSPORT NOT a_N608_aNOT  ;
inv_2725: n_3099  <= TRANSPORT NOT a_N146_aNOT  ;
and1_2726: n_3100 <=  gnd;
dff_2727: DFF_a6850

    PORT MAP ( D => a_EQ135, CLK => a_N499_aCLK, CLRN => a_N499_aCLRN, PRN => vcc,
          Q => a_N499);
delay_2728: a_N499_aCLRN  <= TRANSPORT nRESET  ;
xor2_2729: a_EQ135 <=  n_3107  XOR n_3117;
or3_2730: n_3107 <=  n_3108  OR n_3111  OR n_3114;
and2_2731: n_3108 <=  n_3109  AND n_3110;
delay_2732: n_3109  <= TRANSPORT a_N627_aNOT  ;
delay_2733: n_3110  <= TRANSPORT a_LC1_B1  ;
and2_2734: n_3111 <=  n_3112  AND n_3113;
delay_2735: n_3112  <= TRANSPORT a_N627_aNOT  ;
delay_2736: n_3113  <= TRANSPORT a_N140_aNOT  ;
and2_2737: n_3114 <=  n_3115  AND n_3116;
delay_2738: n_3115  <= TRANSPORT a_N627_aNOT  ;
inv_2739: n_3116  <= TRANSPORT NOT a_LC1_B8  ;
and1_2740: n_3117 <=  gnd;
delay_2741: n_3118  <= TRANSPORT RXCLK  ;
filter_2742: FILTER_a6850

    PORT MAP (IN1 => n_3118, Y => a_N499_aCLK);
delay_2743: a_LC2_B9  <= TRANSPORT a_EQ136  ;
xor2_2744: a_EQ136 <=  n_3122  XOR n_3128;
or2_2745: n_3122 <=  n_3123  OR n_3125;
and1_2746: n_3123 <=  n_3124;
delay_2747: n_3124  <= TRANSPORT a_N42_aNOT  ;
and2_2748: n_3125 <=  n_3126  AND n_3127;
inv_2749: n_3126  <= TRANSPORT NOT a_N495  ;
delay_2750: n_3127  <= TRANSPORT a_LC3_B9  ;
and1_2751: n_3128 <=  gnd;
delay_2752: a_N130_aNOT  <= TRANSPORT a_N130_aNOT_aIN  ;
xor2_2753: a_N130_aNOT_aIN <=  n_3131  XOR n_3136;
or1_2754: n_3131 <=  n_3132;
and3_2755: n_3132 <=  n_3133  AND n_3134  AND n_3135;
inv_2756: n_3133  <= TRANSPORT NOT a_N603_aNOT  ;
inv_2757: n_3134  <= TRANSPORT NOT a_N495  ;
delay_2758: n_3135  <= TRANSPORT a_N499  ;
and1_2759: n_3136 <=  gnd;
delay_2760: a_LC1_B9  <= TRANSPORT a_EQ137  ;
xor2_2761: a_EQ137 <=  n_3139  XOR n_3147;
or3_2762: n_3139 <=  n_3140  OR n_3142  OR n_3145;
and1_2763: n_3140 <=  n_3141;
delay_2764: n_3141  <= TRANSPORT a_LC2_B9  ;
and2_2765: n_3142 <=  n_3143  AND n_3144;
inv_2766: n_3143  <= TRANSPORT NOT a_N642_aNOT  ;
delay_2767: n_3144  <= TRANSPORT a_N130_aNOT  ;
and1_2768: n_3145 <=  n_3146;
delay_2769: n_3146  <= TRANSPORT a_N43_aNOT  ;
and1_2770: n_3147 <=  gnd;
dff_2771: DFF_a6850

    PORT MAP ( D => a_EQ133, CLK => a_N497_aCLK, CLRN => a_N497_aCLRN, PRN => vcc,
          Q => a_N497);
delay_2772: a_N497_aCLRN  <= TRANSPORT nRESET  ;
xor2_2773: a_EQ133 <=  n_3154  XOR n_3162;
or2_2774: n_3154 <=  n_3155  OR n_3158;
and2_2775: n_3155 <=  n_3156  AND n_3157;
delay_2776: n_3156  <= TRANSPORT a_N627_aNOT  ;
delay_2777: n_3157  <= TRANSPORT a_LC1_B9  ;
and3_2778: n_3158 <=  n_3159  AND n_3160  AND n_3161;
delay_2779: n_3159  <= TRANSPORT a_N627_aNOT  ;
inv_2780: n_3160  <= TRANSPORT NOT a_N44_aNOT  ;
inv_2781: n_3161  <= TRANSPORT NOT a_N591  ;
and1_2782: n_3162 <=  gnd;
delay_2783: n_3163  <= TRANSPORT RXCLK  ;
filter_2784: FILTER_a6850

    PORT MAP (IN1 => n_3163, Y => a_N497_aCLK);
dff_2785: DFF_a6850

    PORT MAP ( D => a_EQ187, CLK => a_N778_aCLK, CLRN => a_N778_aCLRN, PRN => vcc,
          Q => a_N778);
delay_2786: a_N778_aCLRN  <= TRANSPORT nRESET  ;
xor2_2787: a_EQ187 <=  n_3171  XOR n_3180;
or2_2788: n_3171 <=  n_3172  OR n_3176;
and3_2789: n_3172 <=  n_3173  AND n_3174  AND n_3175;
delay_2790: n_3173  <= TRANSPORT a_N627_aNOT  ;
delay_2791: n_3174  <= TRANSPORT a_N380  ;
delay_2792: n_3175  <= TRANSPORT a_N777  ;
and3_2793: n_3176 <=  n_3177  AND n_3178  AND n_3179;
delay_2794: n_3177  <= TRANSPORT a_N627_aNOT  ;
inv_2795: n_3178  <= TRANSPORT NOT a_N380  ;
delay_2796: n_3179  <= TRANSPORT a_N778  ;
and1_2797: n_3180 <=  gnd;
delay_2798: n_3181  <= TRANSPORT RXCLK  ;
filter_2799: FILTER_a6850

    PORT MAP (IN1 => n_3181, Y => a_N778_aCLK);
dff_2800: DFF_a6850

    PORT MAP ( D => a_EQ186, CLK => a_N777_aCLK, CLRN => a_N777_aCLRN, PRN => vcc,
          Q => a_N777);
delay_2801: a_N777_aCLRN  <= TRANSPORT nRESET  ;
xor2_2802: a_EQ186 <=  n_3189  XOR n_3198;
or2_2803: n_3189 <=  n_3190  OR n_3194;
and3_2804: n_3190 <=  n_3191  AND n_3192  AND n_3193;
delay_2805: n_3191  <= TRANSPORT a_N627_aNOT  ;
delay_2806: n_3192  <= TRANSPORT a_N380  ;
delay_2807: n_3193  <= TRANSPORT a_N776  ;
and3_2808: n_3194 <=  n_3195  AND n_3196  AND n_3197;
delay_2809: n_3195  <= TRANSPORT a_N627_aNOT  ;
inv_2810: n_3196  <= TRANSPORT NOT a_N380  ;
delay_2811: n_3197  <= TRANSPORT a_N777  ;
and1_2812: n_3198 <=  gnd;
delay_2813: n_3199  <= TRANSPORT RXCLK  ;
filter_2814: FILTER_a6850

    PORT MAP (IN1 => n_3199, Y => a_N777_aCLK);
dff_2815: DFF_a6850

    PORT MAP ( D => a_N956_aD, CLK => a_N956_aCLK, CLRN => a_N956_aCLRN, PRN => vcc,
          Q => a_N956);
delay_2816: a_N956_aCLRN  <= TRANSPORT nRESET  ;
xor2_2817: a_N956_aD <=  n_3208  XOR n_3213;
or1_2818: n_3208 <=  n_3209;
and3_2819: n_3209 <=  n_3210  AND n_3211  AND n_3212;
delay_2820: n_3210  <= TRANSPORT a_LC7_A21  ;
delay_2821: n_3211  <= TRANSPORT RnW  ;
inv_2822: n_3212  <= TRANSPORT NOT RS  ;
and1_2823: n_3213 <=  gnd;
inv_2824: n_3214  <= TRANSPORT NOT RXCLK  ;
filter_2825: FILTER_a6850

    PORT MAP (IN1 => n_3214, Y => a_N956_aCLK);
dff_2826: DFF_a6850

    PORT MAP ( D => a_N953_aD, CLK => a_N953_aCLK, CLRN => a_N953_aCLRN, PRN => vcc,
          Q => a_N953);
delay_2827: a_N953_aCLRN  <= TRANSPORT nRESET  ;
xor2_2828: a_N953_aD <=  n_3223  XOR n_3226;
or1_2829: n_3223 <=  n_3224;
and1_2830: n_3224 <=  n_3225;
delay_2831: n_3225  <= TRANSPORT a_N956  ;
and1_2832: n_3226 <=  gnd;
delay_2833: n_3227  <= TRANSPORT RXCLK  ;
filter_2834: FILTER_a6850

    PORT MAP (IN1 => n_3227, Y => a_N953_aCLK);
delay_2835: a_LC7_A6  <= TRANSPORT a_LC7_A6_aIN  ;
xor2_2836: a_LC7_A6_aIN <=  n_3231  XOR n_3235;
or1_2837: n_3231 <=  n_3232;
and2_2838: n_3232 <=  n_3233  AND n_3234;
inv_2839: n_3233  <= TRANSPORT NOT a_N956  ;
delay_2840: n_3234  <= TRANSPORT a_N953  ;
and1_2841: n_3235 <=  gnd;
dff_2842: DFF_a6850

    PORT MAP ( D => a_EQ101, CLK => a_N339_aCLK, CLRN => a_N339_aCLRN, PRN => vcc,
          Q => a_N339);
delay_2843: a_N339_aCLRN  <= TRANSPORT nRESET  ;
xor2_2844: a_EQ101 <=  n_3242  XOR n_3250;
or2_2845: n_3242 <=  n_3243  OR n_3246;
and2_2846: n_3243 <=  n_3244  AND n_3245;
delay_2847: n_3244  <= TRANSPORT a_N627_aNOT  ;
delay_2848: n_3245  <= TRANSPORT a_N339  ;
and3_2849: n_3246 <=  n_3247  AND n_3248  AND n_3249;
delay_2850: n_3247  <= TRANSPORT a_N627_aNOT  ;
delay_2851: n_3248  <= TRANSPORT a_LC7_A6  ;
delay_2852: n_3249  <= TRANSPORT a_SSTS_REG_F2_G  ;
and1_2853: n_3250 <=  gnd;
delay_2854: n_3251  <= TRANSPORT RXCLK  ;
filter_2855: FILTER_a6850

    PORT MAP (IN1 => n_3251, Y => a_N339_aCLK);
dff_2856: DFF_a6850

    PORT MAP ( D => a_N957_aD, CLK => a_N957_aCLK, CLRN => a_N957_aCLRN, PRN => vcc,
          Q => a_N957);
delay_2857: a_N957_aCLRN  <= TRANSPORT nRESET  ;
xor2_2858: a_N957_aD <=  n_3260  XOR n_3265;
or1_2859: n_3260 <=  n_3261;
and3_2860: n_3261 <=  n_3262  AND n_3263  AND n_3264;
delay_2861: n_3262  <= TRANSPORT a_LC7_A21  ;
delay_2862: n_3263  <= TRANSPORT RnW  ;
delay_2863: n_3264  <= TRANSPORT RS  ;
and1_2864: n_3265 <=  gnd;
inv_2865: n_3266  <= TRANSPORT NOT RXCLK  ;
filter_2866: FILTER_a6850

    PORT MAP (IN1 => n_3266, Y => a_N957_aCLK);
dff_2867: DFF_a6850

    PORT MAP ( D => a_N954_aD, CLK => a_N954_aCLK, CLRN => a_N954_aCLRN, PRN => vcc,
          Q => a_N954);
delay_2868: a_N954_aCLRN  <= TRANSPORT nRESET  ;
xor2_2869: a_N954_aD <=  n_3275  XOR n_3278;
or1_2870: n_3275 <=  n_3276;
and1_2871: n_3276 <=  n_3277;
delay_2872: n_3277  <= TRANSPORT a_N957  ;
and1_2873: n_3278 <=  gnd;
delay_2874: n_3279  <= TRANSPORT RXCLK  ;
filter_2875: FILTER_a6850

    PORT MAP (IN1 => n_3279, Y => a_N954_aCLK);
delay_2876: a_N57_aNOT  <= TRANSPORT a_N57_aNOT_aIN  ;
xor2_2877: a_N57_aNOT_aIN <=  n_3282  XOR n_3286;
or1_2878: n_3282 <=  n_3283;
and2_2879: n_3283 <=  n_3284  AND n_3285;
inv_2880: n_3284  <= TRANSPORT NOT a_N957  ;
delay_2881: n_3285  <= TRANSPORT a_N954  ;
and1_2882: n_3286 <=  gnd;
delay_2883: a_LC3_B11  <= TRANSPORT a_LC3_B11_aIN  ;
xor2_2884: a_LC3_B11_aIN <=  n_3289  XOR n_3293;
or1_2885: n_3289 <=  n_3290;
and2_2886: n_3290 <=  n_3291  AND n_3292;
delay_2887: n_3291  <= TRANSPORT a_N339  ;
delay_2888: n_3292  <= TRANSPORT a_N57_aNOT  ;
and1_2889: n_3293 <=  gnd;
dff_2890: DFF_a6850

    PORT MAP ( D => a_EQ100, CLK => a_N337_aCLK, CLRN => a_N337_aCLRN, PRN => vcc,
          Q => a_N337);
delay_2891: a_N337_aCLRN  <= TRANSPORT nRESET  ;
xor2_2892: a_EQ100 <=  n_3300  XOR n_3308;
or2_2893: n_3300 <=  n_3301  OR n_3304;
and2_2894: n_3301 <=  n_3302  AND n_3303;
delay_2895: n_3302  <= TRANSPORT a_N627_aNOT  ;
delay_2896: n_3303  <= TRANSPORT a_N337  ;
and3_2897: n_3304 <=  n_3305  AND n_3306  AND n_3307;
delay_2898: n_3305  <= TRANSPORT a_N627_aNOT  ;
delay_2899: n_3306  <= TRANSPORT a_LC3_B11  ;
delay_2900: n_3307  <= TRANSPORT a_SSTS_REG_F2_G  ;
and1_2901: n_3308 <=  gnd;
delay_2902: n_3309  <= TRANSPORT RXCLK  ;
filter_2903: FILTER_a6850

    PORT MAP (IN1 => n_3309, Y => a_N337_aCLK);
dff_2904: DFF_a6850

    PORT MAP ( D => a_EQ185, CLK => a_N776_aCLK, CLRN => a_N776_aCLRN, PRN => vcc,
          Q => a_N776);
delay_2905: a_N776_aCLRN  <= TRANSPORT nRESET  ;
xor2_2906: a_EQ185 <=  n_3317  XOR n_3326;
or2_2907: n_3317 <=  n_3318  OR n_3322;
and3_2908: n_3318 <=  n_3319  AND n_3320  AND n_3321;
delay_2909: n_3319  <= TRANSPORT a_N627_aNOT  ;
delay_2910: n_3320  <= TRANSPORT a_N380  ;
delay_2911: n_3321  <= TRANSPORT a_N775  ;
and3_2912: n_3322 <=  n_3323  AND n_3324  AND n_3325;
delay_2913: n_3323  <= TRANSPORT a_N627_aNOT  ;
inv_2914: n_3324  <= TRANSPORT NOT a_N380  ;
delay_2915: n_3325  <= TRANSPORT a_N776  ;
and1_2916: n_3326 <=  gnd;
delay_2917: n_3327  <= TRANSPORT RXCLK  ;
filter_2918: FILTER_a6850

    PORT MAP (IN1 => n_3327, Y => a_N776_aCLK);
dff_2919: DFF_a6850

    PORT MAP ( D => a_EQ184, CLK => a_N775_aCLK, CLRN => a_N775_aCLRN, PRN => vcc,
          Q => a_N775);
delay_2920: a_N775_aCLRN  <= TRANSPORT nRESET  ;
xor2_2921: a_EQ184 <=  n_3335  XOR n_3344;
or2_2922: n_3335 <=  n_3336  OR n_3340;
and3_2923: n_3336 <=  n_3337  AND n_3338  AND n_3339;
delay_2924: n_3337  <= TRANSPORT a_N627_aNOT  ;
delay_2925: n_3338  <= TRANSPORT a_N380  ;
delay_2926: n_3339  <= TRANSPORT a_N774  ;
and3_2927: n_3340 <=  n_3341  AND n_3342  AND n_3343;
delay_2928: n_3341  <= TRANSPORT a_N627_aNOT  ;
inv_2929: n_3342  <= TRANSPORT NOT a_N380  ;
delay_2930: n_3343  <= TRANSPORT a_N775  ;
and1_2931: n_3344 <=  gnd;
delay_2932: n_3345  <= TRANSPORT RXCLK  ;
filter_2933: FILTER_a6850

    PORT MAP (IN1 => n_3345, Y => a_N775_aCLK);
delay_2934: a_LC3_B10  <= TRANSPORT a_EQ156  ;
xor2_2935: a_EQ156 <=  n_3348  XOR n_3357;
or2_2936: n_3348 <=  n_3349  OR n_3353;
and3_2937: n_3349 <=  n_3350  AND n_3351  AND n_3352;
inv_2938: n_3350  <= TRANSPORT NOT RXDATA  ;
delay_2939: n_3351  <= TRANSPORT a_N263  ;
delay_2940: n_3352  <= TRANSPORT a_N497  ;
and3_2941: n_3353 <=  n_3354  AND n_3355  AND n_3356;
inv_2942: n_3354  <= TRANSPORT NOT RXDATA  ;
delay_2943: n_3355  <= TRANSPORT a_N600  ;
delay_2944: n_3356  <= TRANSPORT a_N497  ;
and1_2945: n_3357 <=  gnd;
dff_2946: DFF_a6850

    PORT MAP ( D => a_EQ114, CLK => a_N394_aCLK, CLRN => a_N394_aCLRN, PRN => vcc,
          Q => a_N394);
delay_2947: a_N394_aCLRN  <= TRANSPORT nRESET  ;
xor2_2948: a_EQ114 <=  n_3364  XOR n_3371;
or2_2949: n_3364 <=  n_3365  OR n_3368;
and2_2950: n_3365 <=  n_3366  AND n_3367;
delay_2951: n_3366  <= TRANSPORT a_N627_aNOT  ;
delay_2952: n_3367  <= TRANSPORT a_N394  ;
and2_2953: n_3368 <=  n_3369  AND n_3370;
delay_2954: n_3369  <= TRANSPORT a_N627_aNOT  ;
delay_2955: n_3370  <= TRANSPORT a_LC3_B10  ;
and1_2956: n_3371 <=  gnd;
delay_2957: n_3372  <= TRANSPORT RXCLK  ;
filter_2958: FILTER_a6850

    PORT MAP (IN1 => n_3372, Y => a_N394_aCLK);
dff_2959: DFF_a6850

    PORT MAP ( D => a_EQ183, CLK => a_N774_aCLK, CLRN => a_N774_aCLRN, PRN => vcc,
          Q => a_N774);
delay_2960: a_N774_aCLRN  <= TRANSPORT nRESET  ;
xor2_2961: a_EQ183 <=  n_3380  XOR n_3389;
or2_2962: n_3380 <=  n_3381  OR n_3385;
and3_2963: n_3381 <=  n_3382  AND n_3383  AND n_3384;
delay_2964: n_3382  <= TRANSPORT a_N627_aNOT  ;
delay_2965: n_3383  <= TRANSPORT a_N380  ;
delay_2966: n_3384  <= TRANSPORT a_N773  ;
and3_2967: n_3385 <=  n_3386  AND n_3387  AND n_3388;
delay_2968: n_3386  <= TRANSPORT a_N627_aNOT  ;
inv_2969: n_3387  <= TRANSPORT NOT a_N380  ;
delay_2970: n_3388  <= TRANSPORT a_N774  ;
and1_2971: n_3389 <=  gnd;
delay_2972: n_3390  <= TRANSPORT RXCLK  ;
filter_2973: FILTER_a6850

    PORT MAP (IN1 => n_3390, Y => a_N774_aCLK);
dff_2974: DFF_a6850

    PORT MAP ( D => a_EQ182, CLK => a_N773_aCLK, CLRN => a_N773_aCLRN, PRN => vcc,
          Q => a_N773);
delay_2975: a_N773_aCLRN  <= TRANSPORT nRESET  ;
xor2_2976: a_EQ182 <=  n_3398  XOR n_3407;
or2_2977: n_3398 <=  n_3399  OR n_3403;
and3_2978: n_3399 <=  n_3400  AND n_3401  AND n_3402;
delay_2979: n_3400  <= TRANSPORT a_N627_aNOT  ;
delay_2980: n_3401  <= TRANSPORT a_N380  ;
delay_2981: n_3402  <= TRANSPORT a_N772  ;
and3_2982: n_3403 <=  n_3404  AND n_3405  AND n_3406;
delay_2983: n_3404  <= TRANSPORT a_N627_aNOT  ;
inv_2984: n_3405  <= TRANSPORT NOT a_N380  ;
delay_2985: n_3406  <= TRANSPORT a_N773  ;
and1_2986: n_3407 <=  gnd;
delay_2987: n_3408  <= TRANSPORT RXCLK  ;
filter_2988: FILTER_a6850

    PORT MAP (IN1 => n_3408, Y => a_N773_aCLK);
dff_2989: DFF_a6850

    PORT MAP ( D => a_EQ181, CLK => a_N772_aCLK, CLRN => a_N772_aCLRN, PRN => vcc,
          Q => a_N772);
delay_2990: a_N772_aCLRN  <= TRANSPORT nRESET  ;
xor2_2991: a_EQ181 <=  n_3416  XOR n_3425;
or2_2992: n_3416 <=  n_3417  OR n_3421;
and3_2993: n_3417 <=  n_3418  AND n_3419  AND n_3420;
delay_2994: n_3418  <= TRANSPORT a_N627_aNOT  ;
inv_2995: n_3419  <= TRANSPORT NOT a_N380  ;
delay_2996: n_3420  <= TRANSPORT a_N772  ;
and3_2997: n_3421 <=  n_3422  AND n_3423  AND n_3424;
delay_2998: n_3422  <= TRANSPORT a_N627_aNOT  ;
delay_2999: n_3423  <= TRANSPORT a_N380  ;
delay_3000: n_3424  <= TRANSPORT a_N771  ;
and1_3001: n_3425 <=  gnd;
delay_3002: n_3426  <= TRANSPORT RXCLK  ;
filter_3003: FILTER_a6850

    PORT MAP (IN1 => n_3426, Y => a_N772_aCLK);
dff_3004: DFF_a6850

    PORT MAP ( D => a_EQ002, CLK => rx_parity_aCLK, CLRN => rx_parity_aCLRN,
          PRN => vcc, Q => rx_parity);
delay_3005: rx_parity_aCLRN  <= TRANSPORT nRESET  ;
xor2_3006: a_EQ002 <=  n_3434  XOR n_3443;
or2_3007: n_3434 <=  n_3435  OR n_3439;
and3_3008: n_3435 <=  n_3436  AND n_3437  AND n_3438;
delay_3009: n_3436  <= TRANSPORT a_N627_aNOT  ;
inv_3010: n_3437  <= TRANSPORT NOT a_N380  ;
delay_3011: n_3438  <= TRANSPORT rx_parity  ;
and3_3012: n_3439 <=  n_3440  AND n_3441  AND n_3442;
delay_3013: n_3440  <= TRANSPORT a_N627_aNOT  ;
delay_3014: n_3441  <= TRANSPORT a_N380  ;
delay_3015: n_3442  <= TRANSPORT RXDATA  ;
and1_3016: n_3443 <=  gnd;
delay_3017: n_3444  <= TRANSPORT RXCLK  ;
filter_3018: FILTER_a6850

    PORT MAP (IN1 => n_3444, Y => rx_parity_aCLK);
dff_3019: DFF_a6850

    PORT MAP ( D => a_EQ003, CLK => word_lngth_aCLK, CLRN => word_lngth_aCLRN,
          PRN => vcc, Q => word_lngth);
delay_3020: word_lngth_aCLRN  <= TRANSPORT nRESET  ;
xor2_3021: a_EQ003 <=  n_3452  XOR n_3463;
or3_3022: n_3452 <=  n_3453  OR n_3456  OR n_3459;
and2_3023: n_3453 <=  n_3454  AND n_3455;
delay_3024: n_3454  <= TRANSPORT word_lngth  ;
delay_3025: n_3455  <= TRANSPORT a_N951  ;
and2_3026: n_3456 <=  n_3457  AND n_3458;
delay_3027: n_3457  <= TRANSPORT word_lngth  ;
inv_3028: n_3458  <= TRANSPORT NOT a_N949  ;
and3_3029: n_3459 <=  n_3460  AND n_3461  AND n_3462;
delay_3030: n_3460  <= TRANSPORT a_SINT_DI_F4_G  ;
inv_3031: n_3461  <= TRANSPORT NOT a_N951  ;
delay_3032: n_3462  <= TRANSPORT a_N949  ;
and1_3033: n_3463 <=  gnd;
inv_3034: n_3464  <= TRANSPORT NOT RXCLK  ;
filter_3035: FILTER_a6850

    PORT MAP (IN1 => n_3464, Y => word_lngth_aCLK);
dff_3036: DFF_a6850

    PORT MAP ( D => a_EQ180, CLK => a_N771_aCLK, CLRN => a_N771_aCLRN, PRN => vcc,
          Q => a_N771);
delay_3037: a_N771_aCLRN  <= TRANSPORT nRESET  ;
xor2_3038: a_EQ180 <=  n_3472  XOR n_3481;
or2_3039: n_3472 <=  n_3473  OR n_3477;
and3_3040: n_3473 <=  n_3474  AND n_3475  AND n_3476;
delay_3041: n_3474  <= TRANSPORT a_N627_aNOT  ;
delay_3042: n_3475  <= TRANSPORT a_N380  ;
delay_3043: n_3476  <= TRANSPORT rx_parity  ;
and3_3044: n_3477 <=  n_3478  AND n_3479  AND n_3480;
delay_3045: n_3478  <= TRANSPORT a_N627_aNOT  ;
inv_3046: n_3479  <= TRANSPORT NOT a_N380  ;
delay_3047: n_3480  <= TRANSPORT a_N771  ;
and1_3048: n_3481 <=  gnd;
delay_3049: n_3482  <= TRANSPORT RXCLK  ;
filter_3050: FILTER_a6850

    PORT MAP (IN1 => n_3482, Y => a_N771_aCLK);
delay_3051: a_N365_aNOT  <= TRANSPORT a_N365_aNOT_aIN  ;
xor2_3052: a_N365_aNOT_aIN <=  n_3486  XOR n_3491;
or1_3053: n_3486 <=  n_3487;
and3_3054: n_3487 <=  n_3488  AND n_3489  AND n_3490;
delay_3055: n_3488  <= TRANSPORT a_LC3_A19  ;
inv_3056: n_3489  <= TRANSPORT NOT a_N587_aNOT  ;
inv_3057: n_3490  <= TRANSPORT NOT a_N591  ;
and1_3058: n_3491 <=  gnd;
delay_3059: a_N631  <= TRANSPORT a_N631_aIN  ;
xor2_3060: a_N631_aIN <=  n_3494  XOR n_3499;
or1_3061: n_3494 <=  n_3495;
and3_3062: n_3495 <=  n_3496  AND n_3497  AND n_3498;
inv_3063: n_3496  <= TRANSPORT NOT a_N606_aNOT  ;
delay_3064: n_3497  <= TRANSPORT a_N221  ;
delay_3065: n_3498  <= TRANSPORT a_N222  ;
and1_3066: n_3499 <=  gnd;
delay_3067: a_LC7_A18  <= TRANSPORT a_EQ105  ;
xor2_3068: a_EQ105 <=  n_3502  XOR n_3510;
or2_3069: n_3502 <=  n_3503  OR n_3507;
and3_3070: n_3503 <=  n_3504  AND n_3505  AND n_3506;
delay_3071: n_3504  <= TRANSPORT a_N604  ;
inv_3072: n_3505  <= TRANSPORT NOT a_N593  ;
inv_3073: n_3506  <= TRANSPORT NOT a_N222  ;
and2_3074: n_3507 <=  n_3508  AND n_3509;
inv_3075: n_3508  <= TRANSPORT NOT a_N55  ;
delay_3076: n_3509  <= TRANSPORT a_N604  ;
and1_3077: n_3510 <=  gnd;
dff_3078: DFF_a6850

    PORT MAP ( D => a_EQ075, CLK => a_N219_aCLK, CLRN => a_N219_aCLRN, PRN => vcc,
          Q => a_N219);
delay_3079: a_N219_aCLRN  <= TRANSPORT nRESET  ;
xor2_3080: a_EQ075 <=  n_3517  XOR n_3527;
or3_3081: n_3517 <=  n_3518  OR n_3521  OR n_3524;
and2_3082: n_3518 <=  n_3519  AND n_3520;
delay_3083: n_3519  <= TRANSPORT a_N627_aNOT  ;
delay_3084: n_3520  <= TRANSPORT a_N365_aNOT  ;
and2_3085: n_3521 <=  n_3522  AND n_3523;
delay_3086: n_3522  <= TRANSPORT a_N627_aNOT  ;
delay_3087: n_3523  <= TRANSPORT a_N631  ;
and2_3088: n_3524 <=  n_3525  AND n_3526;
delay_3089: n_3525  <= TRANSPORT a_N627_aNOT  ;
delay_3090: n_3526  <= TRANSPORT a_LC7_A18  ;
and1_3091: n_3527 <=  gnd;
inv_3092: n_3528  <= TRANSPORT NOT TXCLK  ;
filter_3093: FILTER_a6850

    PORT MAP (IN1 => n_3528, Y => a_N219_aCLK);
delay_3094: a_LC1_A2  <= TRANSPORT a_EQ119  ;
xor2_3095: a_EQ119 <=  n_3532  XOR n_3539;
or2_3096: n_3532 <=  n_3533  OR n_3536;
and2_3097: n_3533 <=  n_3534  AND n_3535;
inv_3098: n_3534  <= TRANSPORT NOT a_N640_aNOT  ;
delay_3099: n_3535  <= TRANSPORT a_N37  ;
and2_3100: n_3536 <=  n_3537  AND n_3538;
delay_3101: n_3537  <= TRANSPORT a_N379_aNOT  ;
delay_3102: n_3538  <= TRANSPORT a_STX_REG_DATA_F0_G  ;
and1_3103: n_3539 <=  gnd;
dff_3104: DFF_a6850

    PORT MAP ( D => a_EQ199, CLK => a_N1016_aCLK, CLRN => a_N1016_aCLRN, PRN => vcc,
          Q => a_N1016);
delay_3105: a_N1016_aCLRN  <= TRANSPORT nRESET  ;
xor2_3106: a_EQ199 <=  n_3546  XOR n_3554;
or2_3107: n_3546 <=  n_3547  OR n_3550;
and2_3108: n_3547 <=  n_3548  AND n_3549;
delay_3109: n_3548  <= TRANSPORT a_N627_aNOT  ;
delay_3110: n_3549  <= TRANSPORT a_LC1_A2  ;
and3_3111: n_3550 <=  n_3551  AND n_3552  AND n_3553;
delay_3112: n_3551  <= TRANSPORT a_N627_aNOT  ;
delay_3113: n_3552  <= TRANSPORT a_LC8_A9  ;
delay_3114: n_3553  <= TRANSPORT a_N1016  ;
and1_3115: n_3554 <=  gnd;
inv_3116: n_3555  <= TRANSPORT NOT TXCLK  ;
filter_3117: FILTER_a6850

    PORT MAP (IN1 => n_3555, Y => a_N1016_aCLK);
dff_3118: DFF_a6850

    PORT MAP ( D => a_EQ201, CLK => a_SINT_DI_F1_G_aCLK, CLRN => a_SINT_DI_F1_G_aCLRN,
          PRN => vcc, Q => a_SINT_DI_F1_G);
delay_3119: a_SINT_DI_F1_G_aCLRN  <= TRANSPORT nRESET  ;
xor2_3120: a_EQ201 <=  n_3564  XOR n_3571;
or2_3121: n_3564 <=  n_3565  OR n_3568;
and2_3122: n_3565 <=  n_3566  AND n_3567;
delay_3123: n_3566  <= TRANSPORT a_SINT_DI_F1_G  ;
inv_3124: n_3567  <= TRANSPORT NOT E  ;
and2_3125: n_3568 <=  n_3569  AND n_3570;
delay_3126: n_3569  <= TRANSPORT DI(1)  ;
delay_3127: n_3570  <= TRANSPORT E  ;
and1_3128: n_3571 <=  gnd;
delay_3129: n_3572  <= TRANSPORT TXCLK  ;
filter_3130: FILTER_a6850

    PORT MAP (IN1 => n_3572, Y => a_SINT_DI_F1_G_aCLK);

END Version_1_0;
