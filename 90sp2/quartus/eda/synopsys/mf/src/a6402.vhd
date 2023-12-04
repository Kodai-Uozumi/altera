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

ENTITY TRIBUF_a6402 IS
    PORT (
        in1 : IN std_logic;
        oe  : IN std_logic;
        y   : OUT std_logic);
END TRIBUF_a6402;

ARCHITECTURE behavior OF TRIBUF_a6402 IS
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

ENTITY DFF_a6402 IS
    PORT (
      	 d   : IN std_logic;
      	 clk : IN std_logic;
      	 clrn: IN std_logic;
      	 prn : IN std_logic;
      	 q   : OUT std_logic := '0');
END DFF_a6402;

ARCHITECTURE behavior OF DFF_a6402 IS
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

ENTITY FILTER_a6402 IS
    PORT (
        in1 : IN std_logic;
        y: OUT std_logic);
END FILTER_a6402;

ARCHITECTURE behavior OF FILTER_a6402 IS
BEGIN
    y <= in1;
END behavior;

LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE work.tribuf_a6402;
USE work.dff_a6402;
USE work.filter_a6402;

ENTITY a6402 IS
    PORT (
      tbr : IN std_logic_vector(7 downto 0);
      rbr : OUT std_logic_vector(7 downto 0);
      cls1 : IN std_logic;
      cls2 : IN std_logic;
      crl : IN std_logic;
      epe : IN std_logic;
      mr : IN std_logic;
      ndrr : IN std_logic;
      ntbrl : IN std_logic;
      pi : IN std_logic;
      rrc : IN std_logic;
      rri : IN std_logic;
      sbs : IN std_logic;
      trc : IN std_logic;
      dr : OUT std_logic;
      fe : OUT std_logic;
      oe : OUT std_logic;
      pe : OUT std_logic;
      tbre : OUT std_logic;
      tre : OUT std_logic;
      tro : OUT std_logic);
END a6402;

ARCHITECTURE version_1_0 OF a6402 IS

SIGNAL gnd : std_logic := '0';
SIGNAL vcc : std_logic := '1';
SIGNAL
    n_78, n_79, n_80, n_81, n_82, a_STRO_aNOT, n_84, n_85, n_86, n_87, n_88,
          n_89, a_N438, n_91, n_92, n_93, n_94, n_95, n_96, a_N439, n_98,
          n_99, n_100, n_101, n_102, n_103, a_SRBR0, n_105, n_106, n_107,
          n_108, n_109, n_110, a_SRBR1, n_112, n_113, n_114, n_115, n_116,
          n_117, a_SRBR2, n_119, n_120, n_121, n_122, n_123, n_124, a_SRBR3,
          n_126, n_127, n_128, n_129, n_130, n_131, a_SRBR4, n_133, n_134,
          n_135, n_136, n_137, n_138, a_SRBR5, n_140, n_141, n_142, n_143,
          n_144, n_145, a_SRBR6, n_147, n_148, n_149, n_150, n_151, n_152,
          a_SRBR7, n_154, n_155, n_156, n_157, n_158, n_159, a_SPE, n_161,
          n_162, n_163, n_164, n_165, n_166, a_SOE, n_168, n_169, n_170, n_171,
          n_172, n_173, a_SFE, n_175, n_176, n_177, n_178, n_179, n_180, a_SDR_aNOT,
          n_182, a_N238_aNOT, a_EQ033, n_185, n_186, n_187, a_N92, n_189,
          n_190, a_N91, n_192, a_N88, a_N88_aCLRN, a_EQ032, n_201, n_202,
          n_203, a_N32, n_205, a_N90, n_207, n_208, n_209, n_210, n_211, n_212,
          n_213, n_214, n_215, n_216, n_217, n_218, a_N88_aCLK, a_N91_aCLRN,
          a_EQ034, n_227, n_228, n_229, n_230, n_231, n_232, n_233, n_234,
          n_235, n_236, n_237, a_N91_aCLK, a_N92_aCLRN, a_N92_aD, n_245, n_246,
          n_247, n_248, n_249, n_250, a_N92_aCLK, a_SCNTLQ_F4_G, a_SCNTLQ_F4_G_aCLRN,
          a_EQ119, n_260, n_261, n_262, n_264, n_265, n_266, n_267, n_268,
          n_269, a_SCNTLQ_F4_G_aCLK, a_SCNTLQ_F3_G, a_SCNTLQ_F3_G_aCLRN, a_EQ118,
          n_280, n_281, n_282, n_283, n_284, n_285, n_286, n_287, n_288, a_SCNTLQ_F3_G_aCLK,
          a_SCNTLQ_F2_G, a_SCNTLQ_F2_G_aCLRN, a_EQ117, n_298, n_299, n_300,
          n_301, n_302, n_303, n_304, n_305, n_306, a_SCNTLQ_F2_G_aCLK, a_LC2_A3,
          a_LC2_A3_aIN, n_310, n_311, n_312, a_N59_aNOT, n_314, n_315, n_316,
          a_N224_aNOT, a_N224_aNOT_aIN, n_319, n_320, n_321, a_N226, n_323,
          a_N395, n_325, n_326, a_N393, n_328, a_N14, a_EQ001, n_331, n_332,
          n_333, a_N396, n_335, a_N397, n_337, n_338, n_339, n_340, n_341,
          n_342, n_343, n_344, a_N38, a_N38_aIN, n_347, n_348, n_349, n_350,
          n_351, a_LC2_B1_aNOT, a_LC2_B1_aNOT_aIN, n_354, n_355, n_356, n_357,
          n_358, a_N396_aCLRN, a_EQ107, n_365, n_366, n_367, n_368, n_369,
          n_370, n_371, n_372, n_373, n_374, a_N396_aCLK, a_N259, a_N259_aIN,
          n_378, n_379, n_380, a_N37, n_382, n_383, n_384, a_LC4_A3, a_EQ087,
          n_387, n_388, n_389, n_390, n_391, n_392, n_393, n_394, n_395, n_396,
          n_397, a_N229_aNOT, a_N229_aNOT_aIN, n_400, n_401, n_402, n_403,
          n_404, a_LC6_A3, a_EQ088, n_407, n_408, n_409, n_410, n_411, n_412,
          n_413, n_414, n_415, n_416, n_417, a_LC1_A2, a_EQ020, n_420, n_421,
          n_422, n_423, n_424, n_425, n_426, n_427, a_LC2_A2, a_EQ086, n_430,
          n_431, n_432, n_433, n_434, n_435, n_436, n_437, a_LC4_A2, a_EQ089,
          n_440, n_441, n_442, n_443, n_444, n_445, n_446, n_447, a_LC5_A2,
          a_LC5_A2_aIN, n_450, n_451, n_452, n_453, n_454, n_455, a_LC6_A2,
          a_EQ091, n_458, n_459, n_460, n_461, n_462, n_463, n_464, a_N34_aNOT,
          n_466, n_467, n_468, a_N397_aCLRN, a_EQ108, n_475, n_476, n_477,
          n_478, n_479, n_480, n_481, n_482, n_483, n_484, n_485, a_N397_aCLK,
          a_LC6_A5, a_EQ083, n_489, n_490, n_491, n_492, n_493, n_494, n_495,
          n_496, n_497, n_498, n_499, a_LC3_A5, a_EQ084, n_502, n_503, n_504,
          n_505, n_506, n_507, n_508, n_509, a_N393_aCLRN, a_EQ105, n_516,
          n_517, n_518, a_N184_aNOT, n_520, n_521, n_522, n_523, n_524, n_525,
          n_526, n_527, a_N393_aCLK, a_N57_aNOT, a_EQ018, n_532, n_533, n_534,
          n_535, n_536, n_537, n_538, n_539, n_540, n_541, a_N58, a_N58_aIN,
          n_544, n_545, n_546, n_547, a_N107, n_549, a_N70, a_N70_aIN, n_552,
          n_553, n_554, a_N65, n_556, n_557, a_N106, n_559, n_560, a_N26,
          a_N26_aIN, n_563, n_564, n_565, n_566, n_567, n_568, a_N93_aNOT,
          a_N93_aNOT_aIN, n_571, n_572, n_573, a_N108, n_575, n_576, a_N23,
          a_EQ005, n_579, n_580, n_581, n_582, n_583, n_585, n_586, n_587,
          n_588, n_589, a_N203, a_N203_aIN, n_592, n_593, n_594, n_595, n_596,
          n_597, a_LC1_B11, a_EQ080, n_600, n_601, n_602, n_603, n_604, n_605,
          n_606, a_N107_aCLRN, a_EQ042, n_613, n_614, n_615, n_616, n_617,
          n_618, n_619, n_620, n_621, n_622, a_N107_aCLK, a_N55, a_EQ017,
          n_626, n_627, n_628, n_629, n_630, n_631, n_632, n_633, a_N16, a_N16_aIN,
          n_636, n_637, n_638, n_639, n_640, a_N49, a_N49_aIN, n_643, n_644,
          n_645, n_646, n_647, n_648, n_649, a_N117, a_EQ046, n_652, n_653,
          n_654, n_655, n_656, n_657, n_658, n_659, n_660, n_661, a_N106_aCLRN,
          a_EQ041, n_668, n_669, n_670, n_671, n_672, n_673, n_674, n_675,
          a_N106_aCLK, a_LC2_B5, a_EQ053, n_679, n_680, n_681, n_682, n_683,
          n_684, n_685, n_686, n_687, a_N105, n_689, a_N62_aNOT, a_EQ023,
          n_692, n_693, n_694, n_695, n_696, n_697, a_N46, a_EQ014, n_700,
          n_701, n_702, n_703, n_704, n_705, n_706, a_LC3_B8, a_EQ079, n_709,
          n_710, n_711, n_712, n_713, n_714, n_715, n_716, n_717, n_718, a_N105_aCLRN,
          a_N105_aD, n_725, n_726, n_727, n_728, n_729, n_730, a_N105_aCLK,
          a_SRXREGQ_F0_G, a_SRXREGQ_F0_G_aCLRN, a_EQ132, n_739, n_740, n_741,
          n_742, n_743, n_744, n_745, n_746, n_747, a_SRXREGQ_F0_G_aCLK, a_SRXREGQ_F1_G,
          a_SRXREGQ_F1_G_aCLRN, a_EQ133, n_756, n_757, n_758, n_759, n_760,
          n_761, n_762, n_763, n_764, n_765, n_766, n_767, n_768, a_SRXREGQ_F1_G_aCLK,
          a_N22, a_N22_aIN, n_772, n_773, n_774, n_775, n_776, n_777, a_SRXREGQ_F2_G,
          a_SRXREGQ_F2_G_aCLRN, a_EQ134, n_785, n_786, n_787, n_788, n_789,
          n_790, n_791, n_792, n_793, n_794, n_795, n_796, n_797, a_SRXREGQ_F2_G_aCLK,
          a_LC3_B12, a_EQ094, n_801, n_802, n_803, a_SRXREGQ_F3_G, n_805,
          n_806, n_807, n_808, n_809, n_810, n_811, n_812, a_N30, a_N30_aIN,
          n_815, n_816, n_817, n_818, n_819, n_820, a_SRXREGQ_F3_G_aCLRN,
          a_EQ135, n_827, n_828, n_829, n_830, n_831, n_832, n_833, n_834,
          n_835, a_SRXREGQ_F3_G_aCLK, a_N73, a_EQ028, n_839, n_840, n_841,
          n_842, n_843, n_844, n_845, n_846, n_847, n_848, n_849, a_SRXREGQ_F4_G,
          a_SRXREGQ_F4_G_aCLRN, a_EQ136, n_857, n_858, n_859, n_860, n_861,
          n_862, n_863, n_864, n_865, n_866, n_867, n_868, n_869, a_SRXREGQ_F4_G_aCLK,
          a_N206_aNOT, a_EQ061, n_873, n_874, n_875, n_876, n_877, a_SRXREGQ_F5_G,
          n_879, n_880, n_881, n_882, n_883, a_SRXREGQ_F5_G_aCLRN, a_EQ137,
          n_890, n_891, n_892, n_893, n_894, n_895, n_896, n_897, n_898, a_SRXREGQ_F5_G_aCLK,
          a_N121_aNOT, a_N121_aNOT_aIN, n_902, n_903, n_904, n_905, n_906,
          n_907, n_908, a_N113, a_EQ045, n_911, n_912, n_913, n_914, n_915,
          n_916, n_917, n_918, n_919, a_N98, a_EQ038, n_922, n_923, n_924,
          n_925, n_926, n_927, n_928, n_929, n_930, a_LC6_B10, a_EQ049, n_933,
          n_934, n_935, n_936, n_937, n_938, n_939, n_940, n_941, n_942, n_943,
          a_LC3_B13, a_EQ039, n_946, n_947, n_948, n_949, n_950, n_951, n_952,
          n_953, n_954, n_955, a_SRXREGQ_F6_G, a_SRXREGQ_F6_G_aCLRN, a_EQ138,
          n_963, n_964, n_965, n_966, n_967, n_968, n_969, n_970, n_971, n_972,
          n_973, a_SRXREGQ_F6_G_aCLK, a_N112_aNOT, a_N112_aNOT_aIN, n_977,
          n_978, n_979, n_980, n_981, n_982, n_983, a_LC3_B9, a_EQ092, n_986,
          n_987, n_988, n_989, n_990, n_991, n_992, n_993, a_LC5_B10, a_LC5_B10_aIN,
          n_996, n_997, n_998, n_999, n_1000, a_LC3_B10, a_LC3_B10_aIN, n_1003,
          n_1004, n_1005, n_1006, n_1007, n_1008, n_1009, a_SRXREGQ_F7_G,
          a_SRXREGQ_F7_G_aCLRN, a_EQ139, n_1017, n_1018, n_1019, n_1020, n_1021,
          n_1022, n_1023, n_1024, n_1025, n_1026, n_1027, a_SRXREGQ_F7_G_aCLK,
          a_LC4_B9, a_EQ037, n_1031, n_1032, n_1033, n_1034, n_1035, n_1036,
          n_1037, n_1038, a_LC2_B9, a_EQ081, n_1041, n_1042, n_1043, n_1044,
          n_1045, n_1046, n_1047, n_1048, n_1049, n_1050, a_N125_aNOT, a_N125_aNOT_aIN,
          n_1053, n_1054, n_1055, n_1056, n_1057, n_1058, n_1059, a_LC2_B8,
          a_EQ082, n_1062, n_1063, n_1064, n_1065, n_1066, n_1067, n_1068,
          n_1069, n_1070, a_N108_aCLRN, a_EQ043, n_1077, n_1078, n_1079, n_1080,
          n_1081, n_1082, n_1083, n_1084, n_1085, n_1086, a_N108_aCLK, a_N102,
          a_N102_aD, n_1095, n_1096, n_1097, n_1098, n_1099, a_N102_aCLK,
          a_N100, a_N100_aD, n_1107, n_1108, n_1109, n_1110, n_1111, a_N100_aCLK,
          a_N186, a_EQ058, n_1115, n_1116, n_1117, n_1118, n_1119, n_1120,
          a_SOE_aIN, n_1122, n_1123, n_1124, a_N142, n_1126, a_N143, n_1128,
          a_N142_aCLRN, a_EQ051, n_1135, n_1136, n_1137, n_1138, n_1139, n_1140,
          n_1141, n_1142, n_1143, n_1144, a_N142_aCLK, a_SDR_aNOT_aIN, n_1147,
          n_1148, n_1149, n_1150, n_1151, a_N143_aCLRN, a_EQ052, n_1158, n_1159,
          n_1160, n_1161, n_1162, n_1163, n_1164, n_1165, n_1166, n_1167,
          n_1168, n_1169, n_1170, n_1171, a_N143_aCLK, a_N459, a_N459_aD,
          n_1179, n_1180, n_1181, n_1182, n_1183, a_N459_aCLK, a_N458, a_N458_aD,
          n_1191, n_1192, n_1193, n_1194, n_1195, a_N458_aCLK, a_N18_aNOT,
          a_N18_aNOT_aIN, n_1199, n_1200, n_1201, n_1202, n_1203, n_1204,
          n_1205, a_N438_aCLRN, a_EQ109, n_1212, n_1213, n_1214, n_1215, n_1216,
          n_1217, n_1218, n_1219, n_1220, n_1221, n_1222, n_1223, a_N438_aCLK,
          a_N439_aCLRN, a_EQ110, n_1231, n_1232, n_1233, n_1234, n_1235, n_1236,
          n_1237, n_1238, a_N439_aCLK, a_SRBR0_aCLRN, a_EQ124, n_1246, n_1247,
          n_1248, n_1249, n_1250, n_1251, n_1252, n_1253, n_1254, n_1255,
          n_1256, n_1257, n_1258, a_SRBR0_aCLK, a_SRBR1_aCLRN, a_EQ125, n_1266,
          n_1267, n_1268, n_1269, n_1270, n_1271, n_1272, n_1273, n_1274,
          n_1275, n_1276, n_1277, n_1278, a_SRBR1_aCLK, a_SRBR2_aCLRN, a_EQ126,
          n_1286, n_1287, n_1288, n_1289, n_1290, n_1291, n_1292, n_1293,
          n_1294, n_1295, n_1296, n_1297, n_1298, a_SRBR2_aCLK, a_SRBR3_aCLRN,
          a_EQ127, n_1306, n_1307, n_1308, n_1309, n_1310, n_1311, n_1312,
          n_1313, n_1314, n_1315, n_1316, n_1317, n_1318, a_SRBR3_aCLK, a_SRBR4_aCLRN,
          a_EQ128, n_1326, n_1327, n_1328, n_1329, n_1330, n_1331, n_1332,
          n_1333, n_1334, n_1335, n_1336, n_1337, n_1338, a_SRBR4_aCLK, a_SRBR5_aCLRN,
          a_EQ129, n_1346, n_1347, n_1348, n_1349, n_1350, n_1351, n_1352,
          n_1353, n_1354, n_1355, n_1356, n_1357, n_1358, a_SRBR5_aCLK, a_SRBR6_aCLRN,
          a_EQ130, n_1366, n_1367, n_1368, n_1369, n_1370, n_1371, n_1372,
          n_1373, n_1374, n_1375, n_1376, n_1377, n_1378, a_SRBR6_aCLK, a_SRBR7_aCLRN,
          a_EQ131, n_1386, n_1387, n_1388, n_1389, n_1390, n_1391, n_1392,
          n_1393, n_1394, n_1395, n_1396, n_1397, n_1398, a_SRBR7_aCLK, a_LC3_B2,
          a_EQ055, n_1402, n_1403, n_1404, a_SCNTLQ_F1_G, n_1406, n_1407,
          n_1408, n_1409, n_1410, n_1411, n_1412, n_1413, n_1414, n_1415,
          n_1416, n_1417, n_1418, n_1419, n_1420, n_1421, n_1422, n_1423,
          n_1424, n_1425, n_1426, n_1427, n_1428, n_1429, n_1430, n_1431,
          n_1432, n_1433, n_1434, n_1435, n_1436, n_1437, n_1438, n_1439,
          n_1440, n_1441, n_1442, n_1443, n_1444, a_LC1_B2, a_EQ054, n_1447,
          n_1448, n_1449, n_1450, n_1451, n_1452, n_1453, n_1454, n_1455,
          n_1456, n_1457, n_1458, n_1459, n_1460, n_1461, n_1462, n_1463,
          n_1464, n_1465, n_1466, n_1467, n_1468, n_1469, n_1470, n_1471,
          n_1472, n_1473, n_1474, n_1475, n_1476, n_1477, n_1478, n_1479,
          n_1480, n_1481, n_1482, n_1483, n_1484, n_1485, n_1486, n_1487,
          n_1488, a_N179, a_EQ056, n_1491, n_1492, n_1493, n_1494, n_1495,
          n_1496, n_1497, n_1498, n_1499, n_1500, n_1501, n_1502, n_1503,
          n_1504, n_1505, n_1506, n_1507, n_1508, n_1509, n_1510, n_1511,
          n_1512, n_1513, n_1514, n_1515, n_1516, n_1517, n_1518, n_1519,
          n_1520, n_1521, n_1522, n_1523, n_1524, n_1525, n_1526, n_1527,
          n_1528, n_1529, n_1530, n_1531, n_1532, a_SPE_aCLRN, a_EQ123, n_1539,
          n_1540, n_1541, n_1542, n_1543, n_1544, n_1545, n_1546, n_1547,
          n_1548, n_1549, n_1550, n_1551, a_SPE_aCLK, a_SFE_aCLRN, a_EQ121,
          n_1559, n_1560, n_1561, n_1562, n_1563, n_1564, n_1565, n_1566,
          n_1567, n_1568, n_1569, n_1570, n_1571, a_SFE_aCLK, a_N68, a_EQ026,
          n_1575, n_1576, n_1577, a_STRQ_F2_G, n_1579, a_STRQ_F3_G, n_1581,
          a_STRQ_F1_G, n_1583, n_1584, n_1585, n_1586, n_1587, n_1588, n_1589,
          n_1590, n_1591, n_1592, n_1593, n_1594, n_1595, n_1596, n_1597,
          n_1598, n_1599, n_1600, n_1601, n_1602, n_1603, n_1604, n_1605,
          n_1606, n_1607, n_1608, n_1609, n_1610, n_1611, n_1612, n_1613,
          n_1614, n_1615, n_1616, n_1617, n_1618, n_1619, a_N252, a_EQ071,
          n_1622, n_1623, n_1624, a_STRQ_F5_G, n_1626, n_1627, n_1628, n_1629,
          n_1630, a_LC6_A13, a_EQ077, n_1633, n_1634, n_1635, a_STRQ_F0_G,
          n_1637, a_STRQ_F4_G, n_1639, n_1640, n_1641, n_1642, n_1643, n_1644,
          a_N256, a_EQ073, n_1647, n_1648, n_1649, n_1650, n_1651, n_1652,
          n_1653, n_1654, n_1655, n_1656, a_LC3_A13_aNOT, a_EQ069, n_1659,
          n_1660, n_1661, n_1662, n_1663, n_1664, n_1665, n_1666, n_1667,
          n_1668, a_N60_aNOT, a_EQ022, n_1671, n_1672, n_1673, a_STRQ_F7_G,
          n_1675, n_1676, n_1677, a_LC1_A13_aNOT, a_EQ068, n_1680, n_1681,
          n_1682, n_1683, n_1684, n_1685, n_1686, n_1687, a_LC6_A4, a_EQ078,
          n_1690, n_1691, n_1692, n_1693, n_1694, n_1695, n_1696, n_1697,
          n_1698, n_1699, n_1700, a_LC4_A10_aNOT, a_EQ095, n_1703, n_1704,
          n_1705, n_1706, n_1707, n_1708, n_1709, n_1710, n_1711, n_1712,
          n_1713, n_1714, n_1715, a_LC5_A10_aNOT, a_EQ096, n_1718, n_1719,
          n_1720, a_STRQ_F6_G, n_1722, n_1723, n_1724, n_1725, n_1726, a_LC3_A10,
          a_EQ016, n_1729, n_1730, n_1731, n_1732, n_1733, n_1734, n_1735,
          n_1736, a_LC6_A10, a_EQ097, n_1739, n_1740, n_1741, n_1742, n_1743,
          n_1744, n_1745, n_1746, n_1747, n_1748, a_LC3_A1, a_EQ098, n_1751,
          n_1752, n_1753, n_1754, n_1755, n_1756, n_1757, n_1758, n_1759,
          a_N260_aNOT, a_N260_aNOT_aIN, n_1762, n_1763, n_1764, n_1765, n_1766,
          a_LC5_A1_aNOT, a_EQ099, n_1769, n_1770, n_1771, n_1772, n_1773,
          n_1774, n_1775, n_1776, n_1777, a_LC6_A1_aNOT, a_EQ100, n_1780,
          n_1781, n_1782, n_1783, n_1784, n_1785, n_1786, n_1787, a_LC5_A13_aNOT,
          a_EQ101, n_1790, n_1791, n_1792, n_1793, n_1794, n_1795, n_1796,
          n_1797, n_1798, n_1799, a_N67_aNOT, a_N67_aNOT_aIN, n_1802, n_1803,
          n_1804, n_1805, n_1806, a_LC7_A1_aNOT, a_EQ102, n_1809, n_1810,
          n_1811, n_1812, n_1813, n_1814, n_1815, n_1816, n_1817, a_LC4_A1_aNOT,
          a_EQ103, n_1820, n_1821, n_1822, n_1823, n_1824, n_1825, n_1826,
          n_1827, a_LC1_A10, a_EQ076, n_1830, n_1831, n_1832, n_1833, n_1834,
          n_1835, n_1836, n_1837, n_1838, n_1839, a_N253_aNOT, a_EQ072, n_1842,
          n_1843, n_1844, n_1845, n_1846, n_1847, n_1848, n_1849, n_1850,
          n_1851, a_LC7_A10, a_EQ104, n_1854, n_1855, n_1856, n_1857, n_1858,
          n_1859, n_1860, n_1861, n_1862, n_1863, a_STRO_aNOT_aCLRN, a_EQ148,
          n_1870, n_1871, n_1872, n_1873, n_1874, n_1875, n_1876, a_STRO_aNOT_aCLK,
          a_STR_F2_G, a_STR_F2_G_aCLRN, a_EQ142, n_1886, n_1887, n_1888, n_1889,
          n_1890, n_1891, n_1892, n_1893, n_1894, a_STR_F2_G_aCLK, a_STR_F0_G,
          a_STR_F0_G_aCLRN, a_EQ140, n_1904, n_1905, n_1906, n_1907, n_1908,
          n_1909, n_1910, n_1911, n_1912, a_STR_F0_G_aCLK, a_EQ010, n_1915,
          n_1916, n_1917, n_1918, n_1919, n_1920, a_N450, a_N450_aCLRN, a_EQ113,
          n_1928, n_1929, n_1930, n_1931, n_1932, a_N451, n_1934, n_1935,
          n_1936, n_1937, n_1938, n_1939, a_N450_aCLK, a_N451_aCLRN, a_N451_aD,
          n_1947, n_1948, n_1949, n_1950, n_1951, n_1952, a_N451_aCLK, a_N449,
          a_N449_aCLRN, a_EQ112, n_1961, n_1962, n_1963, n_1964, n_1965, n_1966,
          n_1967, n_1968, n_1969, n_1970, n_1971, n_1972, n_1973, n_1974,
          n_1975, n_1976, a_N449_aCLK, a_STR_F6_G, a_STR_F6_G_aCLRN, a_EQ146,
          n_1986, n_1987, n_1988, n_1989, n_1990, n_1991, n_1992, n_1993,
          n_1994, a_STR_F6_G_aCLK, a_STR_F7_G, a_STR_F7_G_aCLRN, a_EQ147,
          n_2004, n_2005, n_2006, n_2007, n_2008, n_2009, n_2010, n_2011,
          n_2012, a_STR_F7_G_aCLK, a_STR_F3_G, a_STR_F3_G_aCLRN, a_EQ143,
          n_2022, n_2023, n_2024, n_2025, n_2026, n_2027, n_2028, n_2029,
          n_2030, a_STR_F3_G_aCLK, a_STRQ_F2_G_aCLRN, a_EQ151, n_2038, n_2039,
          n_2040, n_2041, n_2042, n_2043, n_2044, n_2045, n_2046, a_STRQ_F2_G_aCLK,
          a_STRQ_F0_G_aCLRN, a_EQ149, n_2054, n_2055, n_2056, n_2057, n_2058,
          n_2059, n_2060, n_2061, n_2062, a_STRQ_F0_G_aCLK, a_STR_F1_G, a_STR_F1_G_aCLRN,
          a_EQ141, n_2072, n_2073, n_2074, n_2075, n_2076, n_2077, n_2078,
          n_2079, n_2080, a_STR_F1_G_aCLK, a_N78, a_N78_aIN, n_2084, n_2085,
          n_2086, n_2087, n_2088, n_2089, a_N448, a_N448_aCLRN, a_EQ111, n_2097,
          n_2098, n_2099, n_2100, n_2101, n_2102, n_2103, n_2104, n_2105,
          n_2106, n_2107, a_N448_aCLK, a_STR_F4_G, a_STR_F4_G_aCLRN, a_EQ144,
          n_2117, n_2118, n_2119, n_2120, n_2121, n_2122, n_2123, n_2124,
          n_2125, a_STR_F4_G_aCLK, a_STR_F5_G, a_STR_F5_G_aCLRN, a_EQ145,
          n_2135, n_2136, n_2137, n_2138, n_2139, n_2140, n_2141, n_2142,
          n_2143, a_STR_F5_G_aCLK, a_STRQ_F6_G_aCLRN, a_EQ155, n_2151, n_2152,
          n_2153, n_2154, n_2155, n_2156, n_2157, n_2158, n_2159, a_STRQ_F6_G_aCLK,
          a_STRQ_F7_G_aCLRN, a_EQ156, n_2167, n_2168, n_2169, n_2170, n_2171,
          n_2172, n_2173, n_2174, n_2175, a_STRQ_F7_G_aCLK, a_STRQ_F3_G_aCLRN,
          a_EQ152, n_2183, n_2184, n_2185, n_2186, n_2187, n_2188, n_2189,
          n_2190, n_2191, a_STRQ_F3_G_aCLK, a_STRQ_F1_G_aCLRN, a_EQ150, n_2199,
          n_2200, n_2201, n_2202, n_2203, n_2204, n_2205, n_2206, n_2207,
          a_STRQ_F1_G_aCLK, a_STRQ_F4_G_aCLRN, a_EQ153, n_2215, n_2216, n_2217,
          n_2218, n_2219, n_2220, n_2221, n_2222, n_2223, a_STRQ_F4_G_aCLK,
          a_STRQ_F5_G_aCLRN, a_EQ154, n_2231, n_2232, n_2233, n_2234, n_2235,
          n_2236, n_2237, n_2238, n_2239, a_STRQ_F5_G_aCLK, a_EQ021, n_2242,
          n_2243, n_2244, n_2245, n_2246, n_2247, a_N45_aNOT, a_EQ013, n_2250,
          n_2251, n_2252, n_2253, n_2254, n_2255, a_EQ011, n_2257, n_2258,
          n_2259, n_2260, n_2261, n_2262, a_LC5_A5, a_EQ085, n_2265, n_2266,
          n_2267, n_2268, n_2269, n_2270, n_2271, n_2272, n_2273, a_N194,
          a_EQ059, n_2276, n_2277, n_2278, n_2279, n_2280, n_2281, n_2282,
          n_2283, n_2284, n_2285, a_LC1_A7, a_EQ030, n_2288, n_2289, n_2290,
          n_2291, n_2292, n_2293, n_2294, n_2295, n_2296, a_SCNTLQ_F0_G, n_2298,
          a_N81, a_EQ031, n_2301, n_2302, n_2303, n_2304, n_2305, n_2306,
          n_2307, n_2308, n_2309, n_2310, a_N226_aIN, n_2312, n_2313, n_2314,
          n_2315, n_2316, n_2317, a_N29_aNOT, a_EQ007, n_2320, n_2321, n_2322,
          n_2323, n_2324, n_2325, n_2326, n_2327, n_2328, n_2329, n_2330,
          a_EQ057, n_2332, n_2333, n_2334, n_2335, n_2336, n_2337, n_2338,
          n_2339, n_2340, n_2341, a_N395_aCLRN, a_EQ106, n_2348, n_2349, n_2350,
          n_2351, n_2352, n_2353, n_2354, n_2355, n_2356, n_2357, n_2358,
          a_N395_aCLK, a_SCNTLQ_F0_G_aCLRN, a_EQ115, n_2367, n_2368, n_2369,
          n_2370, n_2371, n_2372, n_2373, n_2374, n_2375, a_SCNTLQ_F0_G_aCLK,
          a_SCNTLQ_F1_G_aCLRN, a_EQ116, n_2384, n_2385, n_2386, n_2387, n_2388,
          n_2389, n_2390, n_2391, n_2392, a_SCNTLQ_F1_G_aCLK, a_EQ024, n_2395,
          n_2396, n_2397, n_2398, n_2399, n_2400, a_N208, a_EQ062, n_2403,
          n_2404, n_2405, n_2406, n_2407, n_2408, a_N101, a_N101_aD, n_2415,
          n_2416, n_2417, n_2418, n_2419, a_N101_aCLK, a_N99, a_N99_aD, n_2427,
          n_2428, n_2429, n_2430, n_2431, a_N99_aCLK, a_EQ009, n_2434, n_2435,
          n_2436, n_2437, n_2438, n_2439, n_2440, n_2441, n_2442, n_2443,
          a_N90_aCLRN, a_N90_aD, n_2450, n_2451, n_2452, n_2453, n_2454, n_2455,
          n_2456, n_2457, n_2458, n_2459, n_2460, n_2461, n_2462, n_2463,
          n_2464, n_2465, a_N90_aCLK : std_logic;

COMPONENT TRIBUF_a6402
    PORT (in1, oe  : IN std_logic; y : OUT std_logic);
END COMPONENT;

COMPONENT DFF_a6402
    PORT (d, clk, clrn, prn : IN std_logic; q : OUT std_logic);
END COMPONENT;

COMPONENT FILTER_a6402
    PORT (in1 : IN std_logic; y : OUT std_logic);
END COMPONENT;

BEGIN

PROCESS(cls1, cls2, crl, epe, mr, ndrr, ntbrl, pi, rrc, rri, sbs, tbr(0), tbr(1),
          tbr(2), tbr(3), tbr(4), tbr(5), tbr(6), tbr(7), trc)
BEGIN
    ASSERT cls1 /= 'X' OR Now = 0 ns
        REPORT "Unknown value on cls1"
        SEVERITY Warning;
    ASSERT cls2 /= 'X' OR Now = 0 ns
        REPORT "Unknown value on cls2"
        SEVERITY Warning;
    ASSERT crl /= 'X' OR Now = 0 ns
        REPORT "Unknown value on crl"
        SEVERITY Warning;
    ASSERT epe /= 'X' OR Now = 0 ns
        REPORT "Unknown value on epe"
        SEVERITY Warning;
    ASSERT mr /= 'X' OR Now = 0 ns
        REPORT "Unknown value on mr"
        SEVERITY Warning;
    ASSERT ndrr /= 'X' OR Now = 0 ns
        REPORT "Unknown value on ndrr"
        SEVERITY Warning;
    ASSERT ntbrl /= 'X' OR Now = 0 ns
        REPORT "Unknown value on ntbrl"
        SEVERITY Warning;
    ASSERT pi /= 'X' OR Now = 0 ns
        REPORT "Unknown value on pi"
        SEVERITY Warning;
    ASSERT rrc /= 'X' OR Now = 0 ns
        REPORT "Unknown value on rrc"
        SEVERITY Warning;
    ASSERT rri /= 'X' OR Now = 0 ns
        REPORT "Unknown value on rri"
        SEVERITY Warning;
    ASSERT sbs /= 'X' OR Now = 0 ns
        REPORT "Unknown value on sbs"
        SEVERITY Warning;
    ASSERT tbr(0) /= 'X' OR Now = 0 ns
        REPORT "Unknown value on tbr(0)"
        SEVERITY Warning;
    ASSERT tbr(1) /= 'X' OR Now = 0 ns
        REPORT "Unknown value on tbr(1)"
        SEVERITY Warning;
    ASSERT tbr(2) /= 'X' OR Now = 0 ns
        REPORT "Unknown value on tbr(2)"
        SEVERITY Warning;
    ASSERT tbr(3) /= 'X' OR Now = 0 ns
        REPORT "Unknown value on tbr(3)"
        SEVERITY Warning;
    ASSERT tbr(4) /= 'X' OR Now = 0 ns
        REPORT "Unknown value on tbr(4)"
        SEVERITY Warning;
    ASSERT tbr(5) /= 'X' OR Now = 0 ns
        REPORT "Unknown value on tbr(5)"
        SEVERITY Warning;
    ASSERT tbr(6) /= 'X' OR Now = 0 ns
        REPORT "Unknown value on tbr(6)"
        SEVERITY Warning;
    ASSERT tbr(7) /= 'X' OR Now = 0 ns
        REPORT "Unknown value on tbr(7)"
        SEVERITY Warning;
    ASSERT trc /= 'X' OR Now = 0 ns
        REPORT "Unknown value on trc"
        SEVERITY Warning;
END PROCESS;

tribuf_2: TRIBUF_a6402

    PORT MAP (IN1 => n_78, OE => vcc, Y => tro);
tribuf_4: TRIBUF_a6402

    PORT MAP (IN1 => n_85, OE => vcc, Y => tre);
tribuf_6: TRIBUF_a6402

    PORT MAP (IN1 => n_92, OE => vcc, Y => tbre);
tribuf_8: TRIBUF_a6402

    PORT MAP (IN1 => n_99, OE => vcc, Y => rbr(0));
tribuf_10: TRIBUF_a6402

    PORT MAP (IN1 => n_106, OE => vcc, Y => rbr(1));
tribuf_12: TRIBUF_a6402

    PORT MAP (IN1 => n_113, OE => vcc, Y => rbr(2));
tribuf_14: TRIBUF_a6402

    PORT MAP (IN1 => n_120, OE => vcc, Y => rbr(3));
tribuf_16: TRIBUF_a6402

    PORT MAP (IN1 => n_127, OE => vcc, Y => rbr(4));
tribuf_18: TRIBUF_a6402

    PORT MAP (IN1 => n_134, OE => vcc, Y => rbr(5));
tribuf_20: TRIBUF_a6402

    PORT MAP (IN1 => n_141, OE => vcc, Y => rbr(6));
tribuf_22: TRIBUF_a6402

    PORT MAP (IN1 => n_148, OE => vcc, Y => rbr(7));
tribuf_24: TRIBUF_a6402

    PORT MAP (IN1 => n_155, OE => vcc, Y => pe);
tribuf_26: TRIBUF_a6402

    PORT MAP (IN1 => n_162, OE => vcc, Y => oe);
tribuf_28: TRIBUF_a6402

    PORT MAP (IN1 => n_169, OE => vcc, Y => fe);
tribuf_30: TRIBUF_a6402

    PORT MAP (IN1 => n_176, OE => vcc, Y => dr);
delay_31: n_78  <= TRANSPORT n_79;
xor2_32: n_79 <=  n_80  XOR n_84;
or1_33: n_80 <=  n_81;
and1_34: n_81 <=  n_82;
inv_35: n_82  <= TRANSPORT NOT a_STRO_aNOT  ;
and1_36: n_84 <=  gnd;
delay_37: n_85  <= TRANSPORT n_86;
xor2_38: n_86 <=  n_87  XOR n_91;
or1_39: n_87 <=  n_88;
and1_40: n_88 <=  n_89;
inv_41: n_89  <= TRANSPORT NOT a_N438  ;
and1_42: n_91 <=  gnd;
delay_43: n_92  <= TRANSPORT n_93;
xor2_44: n_93 <=  n_94  XOR n_98;
or1_45: n_94 <=  n_95;
and1_46: n_95 <=  n_96;
inv_47: n_96  <= TRANSPORT NOT a_N439  ;
and1_48: n_98 <=  gnd;
delay_49: n_99  <= TRANSPORT n_100;
xor2_50: n_100 <=  n_101  XOR n_105;
or1_51: n_101 <=  n_102;
and1_52: n_102 <=  n_103;
delay_53: n_103  <= TRANSPORT a_SRBR0  ;
and1_54: n_105 <=  gnd;
delay_55: n_106  <= TRANSPORT n_107;
xor2_56: n_107 <=  n_108  XOR n_112;
or1_57: n_108 <=  n_109;
and1_58: n_109 <=  n_110;
delay_59: n_110  <= TRANSPORT a_SRBR1  ;
and1_60: n_112 <=  gnd;
delay_61: n_113  <= TRANSPORT n_114;
xor2_62: n_114 <=  n_115  XOR n_119;
or1_63: n_115 <=  n_116;
and1_64: n_116 <=  n_117;
delay_65: n_117  <= TRANSPORT a_SRBR2  ;
and1_66: n_119 <=  gnd;
delay_67: n_120  <= TRANSPORT n_121;
xor2_68: n_121 <=  n_122  XOR n_126;
or1_69: n_122 <=  n_123;
and1_70: n_123 <=  n_124;
delay_71: n_124  <= TRANSPORT a_SRBR3  ;
and1_72: n_126 <=  gnd;
delay_73: n_127  <= TRANSPORT n_128;
xor2_74: n_128 <=  n_129  XOR n_133;
or1_75: n_129 <=  n_130;
and1_76: n_130 <=  n_131;
delay_77: n_131  <= TRANSPORT a_SRBR4  ;
and1_78: n_133 <=  gnd;
delay_79: n_134  <= TRANSPORT n_135;
xor2_80: n_135 <=  n_136  XOR n_140;
or1_81: n_136 <=  n_137;
and1_82: n_137 <=  n_138;
delay_83: n_138  <= TRANSPORT a_SRBR5  ;
and1_84: n_140 <=  gnd;
delay_85: n_141  <= TRANSPORT n_142;
xor2_86: n_142 <=  n_143  XOR n_147;
or1_87: n_143 <=  n_144;
and1_88: n_144 <=  n_145;
delay_89: n_145  <= TRANSPORT a_SRBR6  ;
and1_90: n_147 <=  gnd;
delay_91: n_148  <= TRANSPORT n_149;
xor2_92: n_149 <=  n_150  XOR n_154;
or1_93: n_150 <=  n_151;
and1_94: n_151 <=  n_152;
delay_95: n_152  <= TRANSPORT a_SRBR7  ;
and1_96: n_154 <=  gnd;
delay_97: n_155  <= TRANSPORT n_156;
xor2_98: n_156 <=  n_157  XOR n_161;
or1_99: n_157 <=  n_158;
and1_100: n_158 <=  n_159;
delay_101: n_159  <= TRANSPORT a_SPE  ;
and1_102: n_161 <=  gnd;
delay_103: n_162  <= TRANSPORT n_163;
xor2_104: n_163 <=  n_164  XOR n_168;
or1_105: n_164 <=  n_165;
and1_106: n_165 <=  n_166;
delay_107: n_166  <= TRANSPORT a_SOE  ;
and1_108: n_168 <=  gnd;
delay_109: n_169  <= TRANSPORT n_170;
xor2_110: n_170 <=  n_171  XOR n_175;
or1_111: n_171 <=  n_172;
and1_112: n_172 <=  n_173;
delay_113: n_173  <= TRANSPORT a_SFE  ;
and1_114: n_175 <=  gnd;
delay_115: n_176  <= TRANSPORT n_177;
xor2_116: n_177 <=  n_178  XOR n_182;
or1_117: n_178 <=  n_179;
and1_118: n_179 <=  n_180;
inv_119: n_180  <= TRANSPORT NOT a_SDR_aNOT  ;
and1_120: n_182 <=  gnd;
delay_121: a_N238_aNOT  <= TRANSPORT a_EQ033  ;
xor2_122: a_EQ033 <=  n_185  XOR n_192;
or2_123: n_185 <=  n_186  OR n_189;
and1_124: n_186 <=  n_187;
inv_125: n_187  <= TRANSPORT NOT a_N92  ;
and1_126: n_189 <=  n_190;
inv_127: n_190  <= TRANSPORT NOT a_N91  ;
and1_128: n_192 <=  gnd;
dff_129: DFF_a6402

    PORT MAP ( D => a_EQ032, CLK => a_N88_aCLK, CLRN => a_N88_aCLRN, PRN => vcc,
          Q => a_N88);
inv_130: a_N88_aCLRN  <= TRANSPORT NOT mr  ;
xor2_131: a_EQ032 <=  n_201  XOR n_217;
or3_132: n_201 <=  n_202  OR n_208  OR n_212;
and3_133: n_202 <=  n_203  AND n_205  AND n_207;
delay_134: n_203  <= TRANSPORT a_N32  ;
inv_135: n_205  <= TRANSPORT NOT a_N90  ;
delay_136: n_207  <= TRANSPORT a_N88  ;
and3_137: n_208 <=  n_209  AND n_210  AND n_211;
delay_138: n_209  <= TRANSPORT a_N32  ;
delay_139: n_210  <= TRANSPORT a_N238_aNOT  ;
delay_140: n_211  <= TRANSPORT a_N88  ;
and4_141: n_212 <=  n_213  AND n_214  AND n_215  AND n_216;
delay_142: n_213  <= TRANSPORT a_N32  ;
delay_143: n_214  <= TRANSPORT a_N90  ;
inv_144: n_215  <= TRANSPORT NOT a_N238_aNOT  ;
inv_145: n_216  <= TRANSPORT NOT a_N88  ;
and1_146: n_217 <=  gnd;
delay_147: n_218  <= TRANSPORT rrc  ;
filter_148: FILTER_a6402

    PORT MAP (IN1 => n_218, Y => a_N88_aCLK);
dff_149: DFF_a6402

    PORT MAP ( D => a_EQ034, CLK => a_N91_aCLK, CLRN => a_N91_aCLRN, PRN => vcc,
          Q => a_N91);
inv_150: a_N91_aCLRN  <= TRANSPORT NOT mr  ;
xor2_151: a_EQ034 <=  n_227  XOR n_236;
or2_152: n_227 <=  n_228  OR n_232;
and3_153: n_228 <=  n_229  AND n_230  AND n_231;
delay_154: n_229  <= TRANSPORT a_N32  ;
inv_155: n_230  <= TRANSPORT NOT a_N91  ;
delay_156: n_231  <= TRANSPORT a_N92  ;
and3_157: n_232 <=  n_233  AND n_234  AND n_235;
delay_158: n_233  <= TRANSPORT a_N32  ;
delay_159: n_234  <= TRANSPORT a_N91  ;
inv_160: n_235  <= TRANSPORT NOT a_N92  ;
and1_161: n_236 <=  gnd;
delay_162: n_237  <= TRANSPORT rrc  ;
filter_163: FILTER_a6402

    PORT MAP (IN1 => n_237, Y => a_N91_aCLK);
dff_164: DFF_a6402

    PORT MAP ( D => a_N92_aD, CLK => a_N92_aCLK, CLRN => a_N92_aCLRN, PRN => vcc,
          Q => a_N92);
inv_165: a_N92_aCLRN  <= TRANSPORT NOT mr  ;
xor2_166: a_N92_aD <=  n_245  XOR n_249;
or1_167: n_245 <=  n_246;
and2_168: n_246 <=  n_247  AND n_248;
delay_169: n_247  <= TRANSPORT a_N32  ;
inv_170: n_248  <= TRANSPORT NOT a_N92  ;
and1_171: n_249 <=  gnd;
delay_172: n_250  <= TRANSPORT rrc  ;
filter_173: FILTER_a6402

    PORT MAP (IN1 => n_250, Y => a_N92_aCLK);
dff_174: DFF_a6402

    PORT MAP ( D => a_EQ119, CLK => a_SCNTLQ_F4_G_aCLK, CLRN => a_SCNTLQ_F4_G_aCLRN,
          PRN => vcc, Q => a_SCNTLQ_F4_G);
inv_175: a_SCNTLQ_F4_G_aCLRN  <= TRANSPORT NOT mr  ;
xor2_176: a_EQ119 <=  n_260  XOR n_268;
or2_177: n_260 <=  n_261  OR n_265;
and2_178: n_261 <=  n_262  AND n_264;
inv_179: n_262  <= TRANSPORT NOT crl  ;
delay_180: n_264  <= TRANSPORT a_SCNTLQ_F4_G  ;
and2_181: n_265 <=  n_266  AND n_267;
delay_182: n_266  <= TRANSPORT crl  ;
delay_183: n_267  <= TRANSPORT cls2  ;
and1_184: n_268 <=  gnd;
delay_185: n_269  <= TRANSPORT trc  ;
filter_186: FILTER_a6402

    PORT MAP (IN1 => n_269, Y => a_SCNTLQ_F4_G_aCLK);
dff_187: DFF_a6402

    PORT MAP ( D => a_EQ118, CLK => a_SCNTLQ_F3_G_aCLK, CLRN => a_SCNTLQ_F3_G_aCLRN,
          PRN => vcc, Q => a_SCNTLQ_F3_G);
inv_188: a_SCNTLQ_F3_G_aCLRN  <= TRANSPORT NOT mr  ;
xor2_189: a_EQ118 <=  n_280  XOR n_287;
or2_190: n_280 <=  n_281  OR n_284;
and2_191: n_281 <=  n_282  AND n_283;
inv_192: n_282  <= TRANSPORT NOT crl  ;
delay_193: n_283  <= TRANSPORT a_SCNTLQ_F3_G  ;
and2_194: n_284 <=  n_285  AND n_286;
delay_195: n_285  <= TRANSPORT crl  ;
delay_196: n_286  <= TRANSPORT cls1  ;
and1_197: n_287 <=  gnd;
delay_198: n_288  <= TRANSPORT trc  ;
filter_199: FILTER_a6402

    PORT MAP (IN1 => n_288, Y => a_SCNTLQ_F3_G_aCLK);
dff_200: DFF_a6402

    PORT MAP ( D => a_EQ117, CLK => a_SCNTLQ_F2_G_aCLK, CLRN => a_SCNTLQ_F2_G_aCLRN,
          PRN => vcc, Q => a_SCNTLQ_F2_G);
inv_201: a_SCNTLQ_F2_G_aCLRN  <= TRANSPORT NOT mr  ;
xor2_202: a_EQ117 <=  n_298  XOR n_305;
or2_203: n_298 <=  n_299  OR n_302;
and2_204: n_299 <=  n_300  AND n_301;
inv_205: n_300  <= TRANSPORT NOT crl  ;
delay_206: n_301  <= TRANSPORT a_SCNTLQ_F2_G  ;
and2_207: n_302 <=  n_303  AND n_304;
delay_208: n_303  <= TRANSPORT crl  ;
delay_209: n_304  <= TRANSPORT pi  ;
and1_210: n_305 <=  gnd;
delay_211: n_306  <= TRANSPORT trc  ;
filter_212: FILTER_a6402

    PORT MAP (IN1 => n_306, Y => a_SCNTLQ_F2_G_aCLK);
delay_213: a_LC2_A3  <= TRANSPORT a_LC2_A3_aIN  ;
xor2_214: a_LC2_A3_aIN <=  n_310  XOR n_316;
or1_215: n_310 <=  n_311;
and3_216: n_311 <=  n_312  AND n_314  AND n_315;
inv_217: n_312  <= TRANSPORT NOT a_N59_aNOT  ;
delay_218: n_314  <= TRANSPORT a_SCNTLQ_F4_G  ;
inv_219: n_315  <= TRANSPORT NOT a_SCNTLQ_F3_G  ;
and1_220: n_316 <=  gnd;
delay_221: a_N224_aNOT  <= TRANSPORT a_N224_aNOT_aIN  ;
xor2_222: a_N224_aNOT_aIN <=  n_319  XOR n_328;
or1_223: n_319 <=  n_320;
and4_224: n_320 <=  n_321  AND n_323  AND n_325  AND n_326;
inv_225: n_321  <= TRANSPORT NOT a_N226  ;
inv_226: n_323  <= TRANSPORT NOT a_N395  ;
delay_227: n_325  <= TRANSPORT a_LC2_A3  ;
delay_228: n_326  <= TRANSPORT a_N393  ;
and1_229: n_328 <=  gnd;
delay_230: a_N14  <= TRANSPORT a_EQ001  ;
xor2_231: a_EQ001 <=  n_331  XOR n_344;
or3_232: n_331 <=  n_332  OR n_337  OR n_340;
and2_233: n_332 <=  n_333  AND n_335;
inv_234: n_333  <= TRANSPORT NOT a_N396  ;
inv_235: n_335  <= TRANSPORT NOT a_N397  ;
and2_236: n_337 <=  n_338  AND n_339;
delay_237: n_338  <= TRANSPORT a_N59_aNOT  ;
inv_238: n_339  <= TRANSPORT NOT a_N396  ;
and3_239: n_340 <=  n_341  AND n_342  AND n_343;
inv_240: n_341  <= TRANSPORT NOT a_N59_aNOT  ;
delay_241: n_342  <= TRANSPORT a_N396  ;
delay_242: n_343  <= TRANSPORT a_N397  ;
and1_243: n_344 <=  gnd;
delay_244: a_N38  <= TRANSPORT a_N38_aIN  ;
xor2_245: a_N38_aIN <=  n_347  XOR n_351;
or1_246: n_347 <=  n_348;
and2_247: n_348 <=  n_349  AND n_350;
delay_248: n_349  <= TRANSPORT a_N395  ;
delay_249: n_350  <= TRANSPORT a_N396  ;
and1_250: n_351 <=  gnd;
delay_251: a_LC2_B1_aNOT  <= TRANSPORT a_LC2_B1_aNOT_aIN  ;
xor2_252: a_LC2_B1_aNOT_aIN <=  n_354  XOR n_358;
or1_253: n_354 <=  n_355;
and2_254: n_355 <=  n_356  AND n_357;
inv_255: n_356  <= TRANSPORT NOT a_SCNTLQ_F4_G  ;
delay_256: n_357  <= TRANSPORT a_SCNTLQ_F3_G  ;
and1_257: n_358 <=  gnd;
dff_258: DFF_a6402

    PORT MAP ( D => a_EQ107, CLK => a_N396_aCLK, CLRN => a_N396_aCLRN, PRN => vcc,
          Q => a_N396);
inv_259: a_N396_aCLRN  <= TRANSPORT NOT mr  ;
xor2_260: a_EQ107 <=  n_365  XOR n_373;
or3_261: n_365 <=  n_366  OR n_368  OR n_370;
and1_262: n_366 <=  n_367;
delay_263: n_367  <= TRANSPORT a_N224_aNOT  ;
and1_264: n_368 <=  n_369;
inv_265: n_369  <= TRANSPORT NOT a_N14  ;
and2_266: n_370 <=  n_371  AND n_372;
delay_267: n_371  <= TRANSPORT a_N38  ;
delay_268: n_372  <= TRANSPORT a_LC2_B1_aNOT  ;
and1_269: n_373 <=  gnd;
delay_270: n_374  <= TRANSPORT trc  ;
filter_271: FILTER_a6402

    PORT MAP (IN1 => n_374, Y => a_N396_aCLK);
delay_272: a_N259  <= TRANSPORT a_N259_aIN  ;
xor2_273: a_N259_aIN <=  n_378  XOR n_384;
or1_274: n_378 <=  n_379;
and3_275: n_379 <=  n_380  AND n_382  AND n_383;
delay_276: n_380  <= TRANSPORT a_N37  ;
delay_277: n_382  <= TRANSPORT a_N396  ;
inv_278: n_383  <= TRANSPORT NOT a_N397  ;
and1_279: n_384 <=  gnd;
delay_280: a_LC4_A3  <= TRANSPORT a_EQ087  ;
xor2_281: a_EQ087 <=  n_387  XOR n_397;
or3_282: n_387 <=  n_388  OR n_391  OR n_394;
and2_283: n_388 <=  n_389  AND n_390;
delay_284: n_389  <= TRANSPORT a_N396  ;
delay_285: n_390  <= TRANSPORT a_N259  ;
and2_286: n_391 <=  n_392  AND n_393;
inv_287: n_392  <= TRANSPORT NOT a_N395  ;
delay_288: n_393  <= TRANSPORT a_N396  ;
and2_289: n_394 <=  n_395  AND n_396;
delay_290: n_395  <= TRANSPORT a_SCNTLQ_F2_G  ;
delay_291: n_396  <= TRANSPORT a_N396  ;
and1_292: n_397 <=  gnd;
delay_293: a_N229_aNOT  <= TRANSPORT a_N229_aNOT_aIN  ;
xor2_294: a_N229_aNOT_aIN <=  n_400  XOR n_404;
or1_295: n_400 <=  n_401;
and2_296: n_401 <=  n_402  AND n_403;
delay_297: n_402  <= TRANSPORT a_N38  ;
delay_298: n_403  <= TRANSPORT a_LC2_B1_aNOT  ;
and1_299: n_404 <=  gnd;
delay_300: a_LC6_A3  <= TRANSPORT a_EQ088  ;
xor2_301: a_EQ088 <=  n_407  XOR n_417;
or3_302: n_407 <=  n_408  OR n_411  OR n_414;
and2_303: n_408 <=  n_409  AND n_410;
delay_304: n_409  <= TRANSPORT a_N224_aNOT  ;
delay_305: n_410  <= TRANSPORT a_LC4_A3  ;
and2_306: n_411 <=  n_412  AND n_413;
inv_307: n_412  <= TRANSPORT NOT a_N14  ;
delay_308: n_413  <= TRANSPORT a_LC4_A3  ;
and2_309: n_414 <=  n_415  AND n_416;
delay_310: n_415  <= TRANSPORT a_LC4_A3  ;
delay_311: n_416  <= TRANSPORT a_N229_aNOT  ;
and1_312: n_417 <=  gnd;
delay_313: a_LC1_A2  <= TRANSPORT a_EQ020  ;
xor2_314: a_EQ020 <=  n_420  XOR n_427;
or2_315: n_420 <=  n_421  OR n_424;
and2_316: n_421 <=  n_422  AND n_423;
inv_317: n_422  <= TRANSPORT NOT a_SCNTLQ_F4_G  ;
inv_318: n_423  <= TRANSPORT NOT a_N397  ;
and2_319: n_424 <=  n_425  AND n_426;
delay_320: n_425  <= TRANSPORT a_SCNTLQ_F3_G  ;
inv_321: n_426  <= TRANSPORT NOT a_N397  ;
and1_322: n_427 <=  gnd;
delay_323: a_LC2_A2  <= TRANSPORT a_EQ086  ;
xor2_324: a_EQ086 <=  n_430  XOR n_437;
or2_325: n_430 <=  n_431  OR n_435;
and3_326: n_431 <=  n_432  AND n_433  AND n_434;
inv_327: n_432  <= TRANSPORT NOT a_N226  ;
inv_328: n_433  <= TRANSPORT NOT a_N395  ;
delay_329: n_434  <= TRANSPORT a_SCNTLQ_F2_G  ;
and1_330: n_435 <=  n_436;
delay_331: n_436  <= TRANSPORT a_LC1_A2  ;
and1_332: n_437 <=  gnd;
delay_333: a_LC4_A2  <= TRANSPORT a_EQ089  ;
xor2_334: a_EQ089 <=  n_440  XOR n_447;
or2_335: n_440 <=  n_441  OR n_443;
and1_336: n_441 <=  n_442;
delay_337: n_442  <= TRANSPORT a_LC6_A3  ;
and3_338: n_443 <=  n_444  AND n_445  AND n_446;
inv_339: n_444  <= TRANSPORT NOT a_N395  ;
delay_340: n_445  <= TRANSPORT a_LC2_A2  ;
delay_341: n_446  <= TRANSPORT a_N393  ;
and1_342: n_447 <=  gnd;
delay_343: a_LC5_A2  <= TRANSPORT a_LC5_A2_aIN  ;
xor2_344: a_LC5_A2_aIN <=  n_450  XOR n_455;
or1_345: n_450 <=  n_451;
and3_346: n_451 <=  n_452  AND n_453  AND n_454;
inv_347: n_452  <= TRANSPORT NOT a_N396  ;
inv_348: n_453  <= TRANSPORT NOT a_N397  ;
inv_349: n_454  <= TRANSPORT NOT a_N393  ;
and1_350: n_455 <=  gnd;
delay_351: a_LC6_A2  <= TRANSPORT a_EQ091  ;
xor2_352: a_EQ091 <=  n_458  XOR n_468;
or2_353: n_458 <=  n_459  OR n_463;
and3_354: n_459 <=  n_460  AND n_461  AND n_462;
inv_355: n_460  <= TRANSPORT NOT a_N59_aNOT  ;
delay_356: n_461  <= TRANSPORT a_N395  ;
delay_357: n_462  <= TRANSPORT a_LC5_A2  ;
and3_358: n_463 <=  n_464  AND n_466  AND n_467;
inv_359: n_464  <= TRANSPORT NOT a_N34_aNOT  ;
inv_360: n_466  <= TRANSPORT NOT a_N395  ;
delay_361: n_467  <= TRANSPORT a_LC5_A2  ;
and1_362: n_468 <=  gnd;
dff_363: DFF_a6402

    PORT MAP ( D => a_EQ108, CLK => a_N397_aCLK, CLRN => a_N397_aCLRN, PRN => vcc,
          Q => a_N397);
inv_364: a_N397_aCLRN  <= TRANSPORT NOT mr  ;
xor2_365: a_EQ108 <=  n_475  XOR n_484;
or3_366: n_475 <=  n_476  OR n_479  OR n_482;
and2_367: n_476 <=  n_477  AND n_478;
inv_368: n_477  <= TRANSPORT NOT a_N59_aNOT  ;
delay_369: n_478  <= TRANSPORT a_LC4_A2  ;
and2_370: n_479 <=  n_480  AND n_481;
delay_371: n_480  <= TRANSPORT a_N59_aNOT  ;
delay_372: n_481  <= TRANSPORT a_N397  ;
and1_373: n_482 <=  n_483;
delay_374: n_483  <= TRANSPORT a_LC6_A2  ;
and1_375: n_484 <=  gnd;
delay_376: n_485  <= TRANSPORT trc  ;
filter_377: FILTER_a6402

    PORT MAP (IN1 => n_485, Y => a_N397_aCLK);
delay_378: a_LC6_A5  <= TRANSPORT a_EQ083  ;
xor2_379: a_EQ083 <=  n_489  XOR n_499;
or3_380: n_489 <=  n_490  OR n_493  OR n_496;
and2_381: n_490 <=  n_491  AND n_492;
inv_382: n_491  <= TRANSPORT NOT a_N396  ;
inv_383: n_492  <= TRANSPORT NOT a_N397  ;
and2_384: n_493 <=  n_494  AND n_495;
inv_385: n_494  <= TRANSPORT NOT a_N37  ;
inv_386: n_495  <= TRANSPORT NOT a_N397  ;
and2_387: n_496 <=  n_497  AND n_498;
delay_388: n_497  <= TRANSPORT a_N396  ;
delay_389: n_498  <= TRANSPORT a_N397  ;
and1_390: n_499 <=  gnd;
delay_391: a_LC3_A5  <= TRANSPORT a_EQ084  ;
xor2_392: a_EQ084 <=  n_502  XOR n_509;
or2_393: n_502 <=  n_503  OR n_506;
and2_394: n_503 <=  n_504  AND n_505;
inv_395: n_504  <= TRANSPORT NOT a_N59_aNOT  ;
delay_396: n_505  <= TRANSPORT a_N38  ;
and2_397: n_506 <=  n_507  AND n_508;
inv_398: n_507  <= TRANSPORT NOT a_N38  ;
delay_399: n_508  <= TRANSPORT a_N393  ;
and1_400: n_509 <=  gnd;
dff_401: DFF_a6402

    PORT MAP ( D => a_EQ105, CLK => a_N393_aCLK, CLRN => a_N393_aCLRN, PRN => vcc,
          Q => a_N393);
inv_402: a_N393_aCLRN  <= TRANSPORT NOT mr  ;
xor2_403: a_EQ105 <=  n_516  XOR n_526;
or2_404: n_516 <=  n_517  OR n_522;
and3_405: n_517 <=  n_518  AND n_520  AND n_521;
delay_406: n_518  <= TRANSPORT a_N184_aNOT  ;
delay_407: n_520  <= TRANSPORT a_LC6_A5  ;
delay_408: n_521  <= TRANSPORT a_LC3_A5  ;
and3_409: n_522 <=  n_523  AND n_524  AND n_525;
delay_410: n_523  <= TRANSPORT a_N184_aNOT  ;
inv_411: n_524  <= TRANSPORT NOT a_N395  ;
delay_412: n_525  <= TRANSPORT a_LC3_A5  ;
and1_413: n_526 <=  gnd;
delay_414: n_527  <= TRANSPORT trc  ;
filter_415: FILTER_a6402

    PORT MAP (IN1 => n_527, Y => a_N393_aCLK);
delay_416: a_N57_aNOT  <= TRANSPORT a_EQ018  ;
xor2_417: a_EQ018 <=  n_532  XOR n_541;
or4_418: n_532 <=  n_533  OR n_535  OR n_537  OR n_539;
and1_419: n_533 <=  n_534;
inv_420: n_534  <= TRANSPORT NOT a_N90  ;
and1_421: n_535 <=  n_536;
delay_422: n_536  <= TRANSPORT a_N88  ;
and1_423: n_537 <=  n_538;
delay_424: n_538  <= TRANSPORT a_N91  ;
and1_425: n_539 <=  n_540;
inv_426: n_540  <= TRANSPORT NOT a_N92  ;
and1_427: n_541 <=  gnd;
delay_428: a_N58  <= TRANSPORT a_N58_aIN  ;
xor2_429: a_N58_aIN <=  n_544  XOR n_549;
or1_430: n_544 <=  n_545;
and2_431: n_545 <=  n_546  AND n_547;
inv_432: n_546  <= TRANSPORT NOT a_N57_aNOT  ;
inv_433: n_547  <= TRANSPORT NOT a_N107  ;
and1_434: n_549 <=  gnd;
delay_435: a_N70  <= TRANSPORT a_N70_aIN  ;
xor2_436: a_N70_aIN <=  n_552  XOR n_560;
or1_437: n_552 <=  n_553;
and4_438: n_553 <=  n_554  AND n_556  AND n_557  AND n_559;
delay_439: n_554  <= TRANSPORT a_N65  ;
delay_440: n_556  <= TRANSPORT a_N58  ;
inv_441: n_557  <= TRANSPORT NOT a_N106  ;
inv_442: n_559  <= TRANSPORT NOT mr  ;
and1_443: n_560 <=  gnd;
delay_444: a_N26  <= TRANSPORT a_N26_aIN  ;
xor2_445: a_N26_aIN <=  n_563  XOR n_568;
or1_446: n_563 <=  n_564;
and3_447: n_564 <=  n_565  AND n_566  AND n_567;
delay_448: n_565  <= TRANSPORT a_SCNTLQ_F4_G  ;
inv_449: n_566  <= TRANSPORT NOT a_SCNTLQ_F3_G  ;
delay_450: n_567  <= TRANSPORT a_N70  ;
and1_451: n_568 <=  gnd;
delay_452: a_N93_aNOT  <= TRANSPORT a_N93_aNOT_aIN  ;
xor2_453: a_N93_aNOT_aIN <=  n_571  XOR n_576;
or1_454: n_571 <=  n_572;
and2_455: n_572 <=  n_573  AND n_575;
delay_456: n_573  <= TRANSPORT a_N108  ;
inv_457: n_575  <= TRANSPORT NOT mr  ;
and1_458: n_576 <=  gnd;
delay_459: a_N23  <= TRANSPORT a_EQ005  ;
xor2_460: a_EQ005 <=  n_579  XOR n_589;
or2_461: n_579 <=  n_580  OR n_585;
and3_462: n_580 <=  n_581  AND n_582  AND n_583;
delay_463: n_581  <= TRANSPORT a_N58  ;
delay_464: n_582  <= TRANSPORT a_N93_aNOT  ;
inv_465: n_583  <= TRANSPORT NOT rri  ;
and3_466: n_585 <=  n_586  AND n_587  AND n_588;
delay_467: n_586  <= TRANSPORT a_N65  ;
delay_468: n_587  <= TRANSPORT a_N58  ;
delay_469: n_588  <= TRANSPORT a_N93_aNOT  ;
and1_470: n_589 <=  gnd;
delay_471: a_N203  <= TRANSPORT a_N203_aIN  ;
xor2_472: a_N203_aIN <=  n_592  XOR n_597;
or1_473: n_592 <=  n_593;
and3_474: n_593 <=  n_594  AND n_595  AND n_596;
inv_475: n_594  <= TRANSPORT NOT a_N57_aNOT  ;
delay_476: n_595  <= TRANSPORT a_N107  ;
delay_477: n_596  <= TRANSPORT a_N108  ;
and1_478: n_597 <=  gnd;
delay_479: a_LC1_B11  <= TRANSPORT a_EQ080  ;
xor2_480: a_EQ080 <=  n_600  XOR n_606;
or2_481: n_600 <=  n_601  OR n_604;
and2_482: n_601 <=  n_602  AND n_603;
delay_483: n_602  <= TRANSPORT a_LC2_B1_aNOT  ;
delay_484: n_603  <= TRANSPORT a_N106  ;
and1_485: n_604 <=  n_605;
inv_486: n_605  <= TRANSPORT NOT a_N203  ;
and1_487: n_606 <=  gnd;
dff_488: DFF_a6402

    PORT MAP ( D => a_EQ042, CLK => a_N107_aCLK, CLRN => a_N107_aCLRN, PRN => vcc,
          Q => a_N107);
inv_489: a_N107_aCLRN  <= TRANSPORT NOT mr  ;
xor2_490: a_EQ042 <=  n_613  XOR n_621;
or3_491: n_613 <=  n_614  OR n_616  OR n_618;
and1_492: n_614 <=  n_615;
delay_493: n_615  <= TRANSPORT a_N26  ;
and1_494: n_616 <=  n_617;
delay_495: n_617  <= TRANSPORT a_N23  ;
and2_496: n_618 <=  n_619  AND n_620;
delay_497: n_619  <= TRANSPORT a_LC1_B11  ;
delay_498: n_620  <= TRANSPORT a_N107  ;
and1_499: n_621 <=  gnd;
delay_500: n_622  <= TRANSPORT rrc  ;
filter_501: FILTER_a6402

    PORT MAP (IN1 => n_622, Y => a_N107_aCLK);
delay_502: a_N55  <= TRANSPORT a_EQ017  ;
xor2_503: a_EQ017 <=  n_626  XOR n_633;
or3_504: n_626 <=  n_627  OR n_629  OR n_631;
and1_505: n_627 <=  n_628;
inv_506: n_628  <= TRANSPORT NOT a_N107  ;
and1_507: n_629 <=  n_630;
delay_508: n_630  <= TRANSPORT a_N57_aNOT  ;
and1_509: n_631 <=  n_632;
delay_510: n_632  <= TRANSPORT a_N65  ;
and1_511: n_633 <=  gnd;
delay_512: a_N16  <= TRANSPORT a_N16_aIN  ;
xor2_513: a_N16_aIN <=  n_636  XOR n_640;
or1_514: n_636 <=  n_637;
and2_515: n_637 <=  n_638  AND n_639;
delay_516: n_638  <= TRANSPORT a_N106  ;
inv_517: n_639  <= TRANSPORT NOT mr  ;
and1_518: n_640 <=  gnd;
delay_519: a_N49  <= TRANSPORT a_N49_aIN  ;
xor2_520: a_N49_aIN <=  n_643  XOR n_649;
or1_521: n_643 <=  n_644;
and4_522: n_644 <=  n_645  AND n_646  AND n_647  AND n_648;
inv_523: n_645  <= TRANSPORT NOT a_N37  ;
inv_524: n_646  <= TRANSPORT NOT a_N57_aNOT  ;
delay_525: n_647  <= TRANSPORT a_N107  ;
delay_526: n_648  <= TRANSPORT a_N16  ;
and1_527: n_649 <=  gnd;
delay_528: a_N117  <= TRANSPORT a_EQ046  ;
xor2_529: a_EQ046 <=  n_652  XOR n_661;
or4_530: n_652 <=  n_653  OR n_655  OR n_657  OR n_659;
and1_531: n_653 <=  n_654;
delay_532: n_654  <= TRANSPORT a_N49  ;
and1_533: n_655 <=  n_656;
delay_534: n_656  <= TRANSPORT a_N203  ;
and1_535: n_657 <=  n_658;
delay_536: n_658  <= TRANSPORT mr  ;
and1_537: n_659 <=  n_660;
inv_538: n_660  <= TRANSPORT NOT a_N106  ;
and1_539: n_661 <=  gnd;
dff_540: DFF_a6402

    PORT MAP ( D => a_EQ041, CLK => a_N106_aCLK, CLRN => a_N106_aCLRN, PRN => vcc,
          Q => a_N106);
inv_541: a_N106_aCLRN  <= TRANSPORT NOT mr  ;
xor2_542: a_EQ041 <=  n_668  XOR n_674;
or2_543: n_668 <=  n_669  OR n_672;
and2_544: n_669 <=  n_670  AND n_671;
delay_545: n_670  <= TRANSPORT a_N93_aNOT  ;
inv_546: n_671  <= TRANSPORT NOT a_N55  ;
and1_547: n_672 <=  n_673;
inv_548: n_673  <= TRANSPORT NOT a_N117  ;
and1_549: n_674 <=  gnd;
delay_550: n_675  <= TRANSPORT rrc  ;
filter_551: FILTER_a6402

    PORT MAP (IN1 => n_675, Y => a_N106_aCLK);
delay_552: a_LC2_B5  <= TRANSPORT a_EQ053  ;
xor2_553: a_EQ053 <=  n_679  XOR n_689;
or4_554: n_679 <=  n_680  OR n_682  OR n_684  OR n_686;
and1_555: n_680 <=  n_681;
inv_556: n_681  <= TRANSPORT NOT a_N107  ;
and1_557: n_682 <=  n_683;
delay_558: n_683  <= TRANSPORT a_N57_aNOT  ;
and1_559: n_684 <=  n_685;
delay_560: n_685  <= TRANSPORT a_N106  ;
and1_561: n_686 <=  n_687;
inv_562: n_687  <= TRANSPORT NOT a_N105  ;
and1_563: n_689 <=  gnd;
delay_564: a_N62_aNOT  <= TRANSPORT a_EQ023  ;
xor2_565: a_EQ023 <=  n_692  XOR n_697;
or2_566: n_692 <=  n_693  OR n_695;
and1_567: n_693 <=  n_694;
inv_568: n_694  <= TRANSPORT NOT a_N108  ;
and1_569: n_695 <=  n_696;
delay_570: n_696  <= TRANSPORT a_LC2_B5  ;
and1_571: n_697 <=  gnd;
delay_572: a_N46  <= TRANSPORT a_EQ014  ;
xor2_573: a_EQ014 <=  n_700  XOR n_706;
or2_574: n_700 <=  n_701  OR n_703;
and1_575: n_701 <=  n_702;
delay_576: n_702  <= TRANSPORT a_N93_aNOT  ;
and2_577: n_703 <=  n_704  AND n_705;
delay_578: n_704  <= TRANSPORT a_N55  ;
inv_579: n_705  <= TRANSPORT NOT mr  ;
and1_580: n_706 <=  gnd;
delay_581: a_LC3_B8  <= TRANSPORT a_EQ079  ;
xor2_582: a_EQ079 <=  n_709  XOR n_718;
or2_583: n_709 <=  n_710  OR n_714;
and3_584: n_710 <=  n_711  AND n_712  AND n_713;
delay_585: n_711  <= TRANSPORT a_N62_aNOT  ;
delay_586: n_712  <= TRANSPORT a_N46  ;
delay_587: n_713  <= TRANSPORT mr  ;
and3_588: n_714 <=  n_715  AND n_716  AND n_717;
delay_589: n_715  <= TRANSPORT a_N65  ;
delay_590: n_716  <= TRANSPORT a_N62_aNOT  ;
delay_591: n_717  <= TRANSPORT a_N46  ;
and1_592: n_718 <=  gnd;
dff_593: DFF_a6402

    PORT MAP ( D => a_N105_aD, CLK => a_N105_aCLK, CLRN => a_N105_aCLRN, PRN => vcc,
          Q => a_N105);
inv_594: a_N105_aCLRN  <= TRANSPORT NOT mr  ;
xor2_595: a_N105_aD <=  n_725  XOR n_729;
or1_596: n_725 <=  n_726;
and2_597: n_726 <=  n_727  AND n_728;
delay_598: n_727  <= TRANSPORT a_N117  ;
delay_599: n_728  <= TRANSPORT a_LC3_B8  ;
and1_600: n_729 <=  gnd;
delay_601: n_730  <= TRANSPORT rrc  ;
filter_602: FILTER_a6402

    PORT MAP (IN1 => n_730, Y => a_N105_aCLK);
dff_603: DFF_a6402

    PORT MAP ( D => a_EQ132, CLK => a_SRXREGQ_F0_G_aCLK, CLRN => a_SRXREGQ_F0_G_aCLRN,
          PRN => vcc, Q => a_SRXREGQ_F0_G);
inv_604: a_SRXREGQ_F0_G_aCLRN  <= TRANSPORT NOT mr  ;
xor2_605: a_EQ132 <=  n_739  XOR n_746;
or2_606: n_739 <=  n_740  OR n_743;
and2_607: n_740 <=  n_741  AND n_742;
delay_608: n_741  <= TRANSPORT a_N46  ;
delay_609: n_742  <= TRANSPORT a_SRXREGQ_F0_G  ;
and2_610: n_743 <=  n_744  AND n_745;
inv_611: n_744  <= TRANSPORT NOT a_N46  ;
delay_612: n_745  <= TRANSPORT rri  ;
and1_613: n_746 <=  gnd;
delay_614: n_747  <= TRANSPORT rrc  ;
filter_615: FILTER_a6402

    PORT MAP (IN1 => n_747, Y => a_SRXREGQ_F0_G_aCLK);
dff_616: DFF_a6402

    PORT MAP ( D => a_EQ133, CLK => a_SRXREGQ_F1_G_aCLK, CLRN => a_SRXREGQ_F1_G_aCLRN,
          PRN => vcc, Q => a_SRXREGQ_F1_G);
inv_617: a_SRXREGQ_F1_G_aCLRN  <= TRANSPORT NOT mr  ;
xor2_618: a_EQ133 <=  n_756  XOR n_767;
or3_619: n_756 <=  n_757  OR n_760  OR n_763;
and2_620: n_757 <=  n_758  AND n_759;
inv_621: n_758  <= TRANSPORT NOT a_N93_aNOT  ;
delay_622: n_759  <= TRANSPORT a_SRXREGQ_F1_G  ;
and2_623: n_760 <=  n_761  AND n_762;
delay_624: n_761  <= TRANSPORT a_N55  ;
delay_625: n_762  <= TRANSPORT a_SRXREGQ_F1_G  ;
and3_626: n_763 <=  n_764  AND n_765  AND n_766;
delay_627: n_764  <= TRANSPORT a_N93_aNOT  ;
inv_628: n_765  <= TRANSPORT NOT a_N55  ;
delay_629: n_766  <= TRANSPORT rri  ;
and1_630: n_767 <=  gnd;
delay_631: n_768  <= TRANSPORT rrc  ;
filter_632: FILTER_a6402

    PORT MAP (IN1 => n_768, Y => a_SRXREGQ_F1_G_aCLK);
delay_633: a_N22  <= TRANSPORT a_N22_aIN  ;
xor2_634: a_N22_aIN <=  n_772  XOR n_777;
or1_635: n_772 <=  n_773;
and3_636: n_773 <=  n_774  AND n_775  AND n_776;
delay_637: n_774  <= TRANSPORT a_N106  ;
inv_638: n_775  <= TRANSPORT NOT a_N108  ;
inv_639: n_776  <= TRANSPORT NOT mr  ;
and1_640: n_777 <=  gnd;
dff_641: DFF_a6402

    PORT MAP ( D => a_EQ134, CLK => a_SRXREGQ_F2_G_aCLK, CLRN => a_SRXREGQ_F2_G_aCLRN,
          PRN => vcc, Q => a_SRXREGQ_F2_G);
inv_642: a_SRXREGQ_F2_G_aCLRN  <= TRANSPORT NOT mr  ;
xor2_643: a_EQ134 <=  n_785  XOR n_796;
or3_644: n_785 <=  n_786  OR n_789  OR n_792;
and2_645: n_786 <=  n_787  AND n_788;
inv_646: n_787  <= TRANSPORT NOT a_N22  ;
delay_647: n_788  <= TRANSPORT a_SRXREGQ_F2_G  ;
and2_648: n_789 <=  n_790  AND n_791;
inv_649: n_790  <= TRANSPORT NOT a_N58  ;
delay_650: n_791  <= TRANSPORT a_SRXREGQ_F2_G  ;
and3_651: n_792 <=  n_793  AND n_794  AND n_795;
delay_652: n_793  <= TRANSPORT a_N58  ;
delay_653: n_794  <= TRANSPORT a_N22  ;
delay_654: n_795  <= TRANSPORT rri  ;
and1_655: n_796 <=  gnd;
delay_656: n_797  <= TRANSPORT rrc  ;
filter_657: FILTER_a6402

    PORT MAP (IN1 => n_797, Y => a_SRXREGQ_F2_G_aCLK);
delay_658: a_LC3_B12  <= TRANSPORT a_EQ094  ;
xor2_659: a_EQ094 <=  n_801  XOR n_812;
or3_660: n_801 <=  n_802  OR n_806  OR n_809;
and2_661: n_802 <=  n_803  AND n_805;
delay_662: n_803  <= TRANSPORT a_SRXREGQ_F3_G  ;
inv_663: n_805  <= TRANSPORT NOT a_N108  ;
and2_664: n_806 <=  n_807  AND n_808;
inv_665: n_807  <= TRANSPORT NOT a_N58  ;
delay_666: n_808  <= TRANSPORT a_SRXREGQ_F3_G  ;
and2_667: n_809 <=  n_810  AND n_811;
inv_668: n_810  <= TRANSPORT NOT a_N106  ;
delay_669: n_811  <= TRANSPORT a_SRXREGQ_F3_G  ;
and1_670: n_812 <=  gnd;
delay_671: a_N30  <= TRANSPORT a_N30_aIN  ;
xor2_672: a_N30_aIN <=  n_815  XOR n_820;
or1_673: n_815 <=  n_816;
and3_674: n_816 <=  n_817  AND n_818  AND n_819;
delay_675: n_817  <= TRANSPORT a_N106  ;
delay_676: n_818  <= TRANSPORT rri  ;
inv_677: n_819  <= TRANSPORT NOT mr  ;
and1_678: n_820 <=  gnd;
dff_679: DFF_a6402

    PORT MAP ( D => a_EQ135, CLK => a_SRXREGQ_F3_G_aCLK, CLRN => a_SRXREGQ_F3_G_aCLRN,
          PRN => vcc, Q => a_SRXREGQ_F3_G);
inv_680: a_SRXREGQ_F3_G_aCLRN  <= TRANSPORT NOT mr  ;
xor2_681: a_EQ135 <=  n_827  XOR n_834;
or2_682: n_827 <=  n_828  OR n_830;
and1_683: n_828 <=  n_829;
delay_684: n_829  <= TRANSPORT a_LC3_B12  ;
and3_685: n_830 <=  n_831  AND n_832  AND n_833;
delay_686: n_831  <= TRANSPORT a_N58  ;
delay_687: n_832  <= TRANSPORT a_N30  ;
delay_688: n_833  <= TRANSPORT a_N108  ;
and1_689: n_834 <=  gnd;
delay_690: n_835  <= TRANSPORT rrc  ;
filter_691: FILTER_a6402

    PORT MAP (IN1 => n_835, Y => a_SRXREGQ_F3_G_aCLK);
delay_692: a_N73  <= TRANSPORT a_EQ028  ;
xor2_693: a_EQ028 <=  n_839  XOR n_849;
or3_694: n_839 <=  n_840  OR n_843  OR n_846;
and2_695: n_840 <=  n_841  AND n_842;
inv_696: n_841  <= TRANSPORT NOT a_N107  ;
inv_697: n_842  <= TRANSPORT NOT mr  ;
and2_698: n_843 <=  n_844  AND n_845;
delay_699: n_844  <= TRANSPORT a_N57_aNOT  ;
inv_700: n_845  <= TRANSPORT NOT mr  ;
and2_701: n_846 <=  n_847  AND n_848;
inv_702: n_847  <= TRANSPORT NOT a_N106  ;
inv_703: n_848  <= TRANSPORT NOT mr  ;
and1_704: n_849 <=  gnd;
dff_705: DFF_a6402

    PORT MAP ( D => a_EQ136, CLK => a_SRXREGQ_F4_G_aCLK, CLRN => a_SRXREGQ_F4_G_aCLRN,
          PRN => vcc, Q => a_SRXREGQ_F4_G);
inv_706: a_SRXREGQ_F4_G_aCLRN  <= TRANSPORT NOT mr  ;
xor2_707: a_EQ136 <=  n_857  XOR n_868;
or3_708: n_857 <=  n_858  OR n_861  OR n_864;
and2_709: n_858 <=  n_859  AND n_860;
delay_710: n_859  <= TRANSPORT a_N73  ;
delay_711: n_860  <= TRANSPORT a_SRXREGQ_F4_G  ;
and2_712: n_861 <=  n_862  AND n_863;
delay_713: n_862  <= TRANSPORT a_N93_aNOT  ;
delay_714: n_863  <= TRANSPORT a_SRXREGQ_F4_G  ;
and3_715: n_864 <=  n_865  AND n_866  AND n_867;
inv_716: n_865  <= TRANSPORT NOT a_N93_aNOT  ;
delay_717: n_866  <= TRANSPORT a_N30  ;
inv_718: n_867  <= TRANSPORT NOT a_N73  ;
and1_719: n_868 <=  gnd;
delay_720: n_869  <= TRANSPORT rrc  ;
filter_721: FILTER_a6402

    PORT MAP (IN1 => n_869, Y => a_SRXREGQ_F4_G_aCLK);
delay_722: a_N206_aNOT  <= TRANSPORT a_EQ061  ;
xor2_723: a_EQ061 <=  n_873  XOR n_883;
or2_724: n_873 <=  n_874  OR n_879;
and3_725: n_874 <=  n_875  AND n_876  AND n_877;
inv_726: n_875  <= TRANSPORT NOT a_N49  ;
inv_727: n_876  <= TRANSPORT NOT a_N106  ;
delay_728: n_877  <= TRANSPORT a_SRXREGQ_F5_G  ;
and3_729: n_879 <=  n_880  AND n_881  AND n_882;
inv_730: n_880  <= TRANSPORT NOT a_N203  ;
inv_731: n_881  <= TRANSPORT NOT a_N49  ;
delay_732: n_882  <= TRANSPORT a_SRXREGQ_F5_G  ;
and1_733: n_883 <=  gnd;
dff_734: DFF_a6402

    PORT MAP ( D => a_EQ137, CLK => a_SRXREGQ_F5_G_aCLK, CLRN => a_SRXREGQ_F5_G_aCLRN,
          PRN => vcc, Q => a_SRXREGQ_F5_G);
inv_735: a_SRXREGQ_F5_G_aCLRN  <= TRANSPORT NOT mr  ;
xor2_736: a_EQ137 <=  n_890  XOR n_897;
or2_737: n_890 <=  n_891  OR n_893;
and1_738: n_891 <=  n_892;
delay_739: n_892  <= TRANSPORT a_N206_aNOT  ;
and3_740: n_893 <=  n_894  AND n_895  AND n_896;
delay_741: n_894  <= TRANSPORT a_N37  ;
delay_742: n_895  <= TRANSPORT a_N203  ;
delay_743: n_896  <= TRANSPORT a_N30  ;
and1_744: n_897 <=  gnd;
delay_745: n_898  <= TRANSPORT rrc  ;
filter_746: FILTER_a6402

    PORT MAP (IN1 => n_898, Y => a_SRXREGQ_F5_G_aCLK);
delay_747: a_N121_aNOT  <= TRANSPORT a_N121_aNOT_aIN  ;
xor2_748: a_N121_aNOT_aIN <=  n_902  XOR n_908;
or1_749: n_902 <=  n_903;
and4_750: n_903 <=  n_904  AND n_905  AND n_906  AND n_907;
delay_751: n_904  <= TRANSPORT a_SCNTLQ_F4_G  ;
delay_752: n_905  <= TRANSPORT a_N70  ;
inv_753: n_906  <= TRANSPORT NOT a_N108  ;
delay_754: n_907  <= TRANSPORT rri  ;
and1_755: n_908 <=  gnd;
delay_756: a_N113  <= TRANSPORT a_EQ045  ;
xor2_757: a_EQ045 <=  n_911  XOR n_919;
or3_758: n_911 <=  n_912  OR n_914  OR n_916;
and1_759: n_912 <=  n_913;
delay_760: n_913  <= TRANSPORT mr  ;
and1_761: n_914 <=  n_915;
inv_762: n_915  <= TRANSPORT NOT a_N106  ;
and2_763: n_916 <=  n_917  AND n_918;
inv_764: n_917  <= TRANSPORT NOT a_SCNTLQ_F4_G  ;
delay_765: n_918  <= TRANSPORT a_N107  ;
and1_766: n_919 <=  gnd;
delay_767: a_N98  <= TRANSPORT a_EQ038  ;
xor2_768: a_EQ038 <=  n_922  XOR n_930;
or2_769: n_922 <=  n_923  OR n_926;
and2_770: n_923 <=  n_924  AND n_925;
delay_771: n_924  <= TRANSPORT a_N113  ;
delay_772: n_925  <= TRANSPORT mr  ;
and3_773: n_926 <=  n_927  AND n_928  AND n_929;
delay_774: n_927  <= TRANSPORT a_N65  ;
inv_775: n_928  <= TRANSPORT NOT a_N57_aNOT  ;
delay_776: n_929  <= TRANSPORT a_N113  ;
and1_777: n_930 <=  gnd;
delay_778: a_LC6_B10  <= TRANSPORT a_EQ049  ;
xor2_779: a_EQ049 <=  n_933  XOR n_943;
or3_780: n_933 <=  n_934  OR n_937  OR n_940;
and2_781: n_934 <=  n_935  AND n_936;
delay_782: n_935  <= TRANSPORT a_N73  ;
delay_783: n_936  <= TRANSPORT a_N98  ;
and2_784: n_937 <=  n_938  AND n_939;
inv_785: n_938  <= TRANSPORT NOT a_N93_aNOT  ;
delay_786: n_939  <= TRANSPORT a_N98  ;
and2_787: n_940 <=  n_941  AND n_942;
delay_788: n_941  <= TRANSPORT a_SCNTLQ_F3_G  ;
delay_789: n_942  <= TRANSPORT a_N98  ;
and1_790: n_943 <=  gnd;
delay_791: a_LC3_B13  <= TRANSPORT a_EQ039  ;
xor2_792: a_EQ039 <=  n_946  XOR n_955;
or3_793: n_946 <=  n_947  OR n_950  OR n_953;
and2_794: n_947 <=  n_948  AND n_949;
delay_795: n_948  <= TRANSPORT a_N73  ;
delay_796: n_949  <= TRANSPORT a_N108  ;
and2_797: n_950 <=  n_951  AND n_952;
delay_798: n_951  <= TRANSPORT a_N107  ;
delay_799: n_952  <= TRANSPORT a_N73  ;
and1_800: n_953 <=  n_954;
inv_801: n_954  <= TRANSPORT NOT a_LC6_B10  ;
and1_802: n_955 <=  gnd;
dff_803: DFF_a6402

    PORT MAP ( D => a_EQ138, CLK => a_SRXREGQ_F6_G_aCLK, CLRN => a_SRXREGQ_F6_G_aCLRN,
          PRN => vcc, Q => a_SRXREGQ_F6_G);
inv_804: a_SRXREGQ_F6_G_aCLRN  <= TRANSPORT NOT mr  ;
xor2_805: a_EQ138 <=  n_963  XOR n_972;
or3_806: n_963 <=  n_964  OR n_966  OR n_969;
and1_807: n_964 <=  n_965;
delay_808: n_965  <= TRANSPORT a_N121_aNOT  ;
and2_809: n_966 <=  n_967  AND n_968;
delay_810: n_967  <= TRANSPORT a_LC3_B13  ;
delay_811: n_968  <= TRANSPORT a_SRXREGQ_F6_G  ;
and2_812: n_969 <=  n_970  AND n_971;
inv_813: n_970  <= TRANSPORT NOT a_N117  ;
delay_814: n_971  <= TRANSPORT a_SRXREGQ_F6_G  ;
and1_815: n_972 <=  gnd;
delay_816: n_973  <= TRANSPORT rrc  ;
filter_817: FILTER_a6402

    PORT MAP (IN1 => n_973, Y => a_SRXREGQ_F6_G_aCLK);
delay_818: a_N112_aNOT  <= TRANSPORT a_N112_aNOT_aIN  ;
xor2_819: a_N112_aNOT_aIN <=  n_977  XOR n_983;
or1_820: n_977 <=  n_978;
and4_821: n_978 <=  n_979  AND n_980  AND n_981  AND n_982;
inv_822: n_979  <= TRANSPORT NOT a_N26  ;
inv_823: n_980  <= TRANSPORT NOT a_N49  ;
inv_824: n_981  <= TRANSPORT NOT a_N108  ;
inv_825: n_982  <= TRANSPORT NOT mr  ;
and1_826: n_983 <=  gnd;
delay_827: a_LC3_B9  <= TRANSPORT a_EQ092  ;
xor2_828: a_EQ092 <=  n_986  XOR n_993;
or2_829: n_986 <=  n_987  OR n_991;
and3_830: n_987 <=  n_988  AND n_989  AND n_990;
delay_831: n_988  <= TRANSPORT a_N107  ;
inv_832: n_989  <= TRANSPORT NOT a_N106  ;
inv_833: n_990  <= TRANSPORT NOT mr  ;
and1_834: n_991 <=  n_992;
delay_835: n_992  <= TRANSPORT a_N112_aNOT  ;
and1_836: n_993 <=  gnd;
delay_837: a_LC5_B10  <= TRANSPORT a_LC5_B10_aIN  ;
xor2_838: a_LC5_B10_aIN <=  n_996  XOR n_1000;
or1_839: n_996 <=  n_997;
and2_840: n_997 <=  n_998  AND n_999;
delay_841: n_998  <= TRANSPORT a_SCNTLQ_F4_G  ;
delay_842: n_999  <= TRANSPORT rri  ;
and1_843: n_1000 <=  gnd;
delay_844: a_LC3_B10  <= TRANSPORT a_LC3_B10_aIN  ;
xor2_845: a_LC3_B10_aIN <=  n_1003  XOR n_1009;
or1_846: n_1003 <=  n_1004;
and4_847: n_1004 <=  n_1005  AND n_1006  AND n_1007  AND n_1008;
delay_848: n_1005  <= TRANSPORT a_SCNTLQ_F3_G  ;
delay_849: n_1006  <= TRANSPORT a_N23  ;
delay_850: n_1007  <= TRANSPORT a_N98  ;
delay_851: n_1008  <= TRANSPORT a_LC5_B10  ;
and1_852: n_1009 <=  gnd;
dff_853: DFF_a6402

    PORT MAP ( D => a_EQ139, CLK => a_SRXREGQ_F7_G_aCLK, CLRN => a_SRXREGQ_F7_G_aCLRN,
          PRN => vcc, Q => a_SRXREGQ_F7_G);
inv_854: a_SRXREGQ_F7_G_aCLRN  <= TRANSPORT NOT mr  ;
xor2_855: a_EQ139 <=  n_1017  XOR n_1026;
or3_856: n_1017 <=  n_1018  OR n_1021  OR n_1024;
and2_857: n_1018 <=  n_1019  AND n_1020;
delay_858: n_1019  <= TRANSPORT a_LC3_B9  ;
delay_859: n_1020  <= TRANSPORT a_SRXREGQ_F7_G  ;
and2_860: n_1021 <=  n_1022  AND n_1023;
inv_861: n_1022  <= TRANSPORT NOT a_LC6_B10  ;
delay_862: n_1023  <= TRANSPORT a_SRXREGQ_F7_G  ;
and1_863: n_1024 <=  n_1025;
delay_864: n_1025  <= TRANSPORT a_LC3_B10  ;
and1_865: n_1026 <=  gnd;
delay_866: n_1027  <= TRANSPORT rrc  ;
filter_867: FILTER_a6402

    PORT MAP (IN1 => n_1027, Y => a_SRXREGQ_F7_G_aCLK);
delay_868: a_LC4_B9  <= TRANSPORT a_EQ037  ;
xor2_869: a_EQ037 <=  n_1031  XOR n_1038;
or2_870: n_1031 <=  n_1032  OR n_1035;
and2_871: n_1032 <=  n_1033  AND n_1034;
delay_872: n_1033  <= TRANSPORT a_N37  ;
delay_873: n_1034  <= TRANSPORT a_N22  ;
and2_874: n_1035 <=  n_1036  AND n_1037;
delay_875: n_1036  <= TRANSPORT a_SCNTLQ_F2_G  ;
delay_876: n_1037  <= TRANSPORT a_N22  ;
and1_877: n_1038 <=  gnd;
delay_878: a_LC2_B9  <= TRANSPORT a_EQ081  ;
xor2_879: a_EQ081 <=  n_1041  XOR n_1050;
or3_880: n_1041 <=  n_1042  OR n_1045  OR n_1048;
and2_881: n_1042 <=  n_1043  AND n_1044;
delay_882: n_1043  <= TRANSPORT a_N112_aNOT  ;
delay_883: n_1044  <= TRANSPORT mr  ;
and2_884: n_1045 <=  n_1046  AND n_1047;
delay_885: n_1046  <= TRANSPORT a_N65  ;
delay_886: n_1047  <= TRANSPORT a_N112_aNOT  ;
and1_887: n_1048 <=  n_1049;
delay_888: n_1049  <= TRANSPORT a_LC4_B9  ;
and1_889: n_1050 <=  gnd;
delay_890: a_N125_aNOT  <= TRANSPORT a_N125_aNOT_aIN  ;
xor2_891: a_N125_aNOT_aIN <=  n_1053  XOR n_1059;
or1_892: n_1053 <=  n_1054;
and4_893: n_1054 <=  n_1055  AND n_1056  AND n_1057  AND n_1058;
delay_894: n_1055  <= TRANSPORT a_SCNTLQ_F2_G  ;
delay_895: n_1056  <= TRANSPORT a_N117  ;
delay_896: n_1057  <= TRANSPORT a_LC3_B8  ;
delay_897: n_1058  <= TRANSPORT a_LC6_B10  ;
and1_898: n_1059 <=  gnd;
delay_899: a_LC2_B8  <= TRANSPORT a_EQ082  ;
xor2_900: a_EQ082 <=  n_1062  XOR n_1070;
or3_901: n_1062 <=  n_1063  OR n_1066  OR n_1068;
and2_902: n_1063 <=  n_1064  AND n_1065;
delay_903: n_1064  <= TRANSPORT a_N57_aNOT  ;
delay_904: n_1065  <= TRANSPORT a_N108  ;
and1_905: n_1066 <=  n_1067;
inv_906: n_1067  <= TRANSPORT NOT a_N32  ;
and1_907: n_1068 <=  n_1069;
inv_908: n_1069  <= TRANSPORT NOT a_N46  ;
and1_909: n_1070 <=  gnd;
dff_910: DFF_a6402

    PORT MAP ( D => a_EQ043, CLK => a_N108_aCLK, CLRN => a_N108_aCLRN, PRN => vcc,
          Q => a_N108);
inv_911: a_N108_aCLRN  <= TRANSPORT NOT mr  ;
xor2_912: a_EQ043 <=  n_1077  XOR n_1085;
or3_913: n_1077 <=  n_1078  OR n_1081  OR n_1083;
and2_914: n_1078 <=  n_1079  AND n_1080;
inv_915: n_1079  <= TRANSPORT NOT a_N57_aNOT  ;
delay_916: n_1080  <= TRANSPORT a_LC2_B9  ;
and1_917: n_1081 <=  n_1082;
delay_918: n_1082  <= TRANSPORT a_N125_aNOT  ;
and1_919: n_1083 <=  n_1084;
delay_920: n_1084  <= TRANSPORT a_LC2_B8  ;
and1_921: n_1085 <=  gnd;
delay_922: n_1086  <= TRANSPORT rrc  ;
filter_923: FILTER_a6402

    PORT MAP (IN1 => n_1086, Y => a_N108_aCLK);
dff_924: DFF_a6402

    PORT MAP ( D => a_N102_aD, CLK => a_N102_aCLK, CLRN => vcc, PRN => vcc,
          Q => a_N102);
xor2_925: a_N102_aD <=  n_1095  XOR n_1098;
or1_926: n_1095 <=  n_1096;
and1_927: n_1096 <=  n_1097;
delay_928: n_1097  <= TRANSPORT ndrr  ;
and1_929: n_1098 <=  gnd;
delay_930: n_1099  <= TRANSPORT rrc  ;
filter_931: FILTER_a6402

    PORT MAP (IN1 => n_1099, Y => a_N102_aCLK);
dff_932: DFF_a6402

    PORT MAP ( D => a_N100_aD, CLK => a_N100_aCLK, CLRN => vcc, PRN => vcc,
          Q => a_N100);
xor2_933: a_N100_aD <=  n_1107  XOR n_1110;
or1_934: n_1107 <=  n_1108;
and1_935: n_1108 <=  n_1109;
delay_936: n_1109  <= TRANSPORT a_N102  ;
and1_937: n_1110 <=  gnd;
delay_938: n_1111  <= TRANSPORT rrc  ;
filter_939: FILTER_a6402

    PORT MAP (IN1 => n_1111, Y => a_N100_aCLK);
delay_940: a_N186  <= TRANSPORT a_EQ058  ;
xor2_941: a_EQ058 <=  n_1115  XOR n_1120;
or2_942: n_1115 <=  n_1116  OR n_1118;
and1_943: n_1116 <=  n_1117;
delay_944: n_1117  <= TRANSPORT a_N100  ;
and1_945: n_1118 <=  n_1119;
inv_946: n_1119  <= TRANSPORT NOT a_N102  ;
and1_947: n_1120 <=  gnd;
delay_948: a_SOE  <= TRANSPORT a_SOE_aIN  ;
xor2_949: a_SOE_aIN <=  n_1122  XOR n_1128;
or1_950: n_1122 <=  n_1123;
and2_951: n_1123 <=  n_1124  AND n_1126;
delay_952: n_1124  <= TRANSPORT a_N142  ;
inv_953: n_1126  <= TRANSPORT NOT a_N143  ;
and1_954: n_1128 <=  gnd;
dff_955: DFF_a6402

    PORT MAP ( D => a_EQ051, CLK => a_N142_aCLK, CLRN => a_N142_aCLRN, PRN => vcc,
          Q => a_N142);
inv_956: a_N142_aCLRN  <= TRANSPORT NOT mr  ;
xor2_957: a_EQ051 <=  n_1135  XOR n_1143;
or2_958: n_1135 <=  n_1136  OR n_1140;
and3_959: n_1136 <=  n_1137  AND n_1138  AND n_1139;
inv_960: n_1137  <= TRANSPORT NOT a_N62_aNOT  ;
delay_961: n_1138  <= TRANSPORT a_N186  ;
delay_962: n_1139  <= TRANSPORT a_N143  ;
and2_963: n_1140 <=  n_1141  AND n_1142;
delay_964: n_1141  <= TRANSPORT a_N186  ;
delay_965: n_1142  <= TRANSPORT a_SOE  ;
and1_966: n_1143 <=  gnd;
delay_967: n_1144  <= TRANSPORT rrc  ;
filter_968: FILTER_a6402

    PORT MAP (IN1 => n_1144, Y => a_N142_aCLK);
delay_969: a_SDR_aNOT  <= TRANSPORT a_SDR_aNOT_aIN  ;
xor2_970: a_SDR_aNOT_aIN <=  n_1147  XOR n_1151;
or1_971: n_1147 <=  n_1148;
and2_972: n_1148 <=  n_1149  AND n_1150;
inv_973: n_1149  <= TRANSPORT NOT a_N142  ;
inv_974: n_1150  <= TRANSPORT NOT a_N143  ;
and1_975: n_1151 <=  gnd;
dff_976: DFF_a6402

    PORT MAP ( D => a_EQ052, CLK => a_N143_aCLK, CLRN => a_N143_aCLRN, PRN => vcc,
          Q => a_N143);
inv_977: a_N143_aCLRN  <= TRANSPORT NOT mr  ;
xor2_978: a_EQ052 <=  n_1158  XOR n_1170;
or3_979: n_1158 <=  n_1159  OR n_1163  OR n_1166;
and3_980: n_1159 <=  n_1160  AND n_1161  AND n_1162;
delay_981: n_1160  <= TRANSPORT a_N62_aNOT  ;
delay_982: n_1161  <= TRANSPORT a_N186  ;
delay_983: n_1162  <= TRANSPORT a_N143  ;
and2_984: n_1163 <=  n_1164  AND n_1165;
inv_985: n_1164  <= TRANSPORT NOT a_N62_aNOT  ;
delay_986: n_1165  <= TRANSPORT a_SDR_aNOT  ;
and3_987: n_1166 <=  n_1167  AND n_1168  AND n_1169;
inv_988: n_1167  <= TRANSPORT NOT a_N62_aNOT  ;
inv_989: n_1168  <= TRANSPORT NOT a_N186  ;
delay_990: n_1169  <= TRANSPORT a_N143  ;
and1_991: n_1170 <=  gnd;
delay_992: n_1171  <= TRANSPORT rrc  ;
filter_993: FILTER_a6402

    PORT MAP (IN1 => n_1171, Y => a_N143_aCLK);
dff_994: DFF_a6402

    PORT MAP ( D => a_N459_aD, CLK => a_N459_aCLK, CLRN => vcc, PRN => vcc,
          Q => a_N459);
xor2_995: a_N459_aD <=  n_1179  XOR n_1182;
or1_996: n_1179 <=  n_1180;
and1_997: n_1180 <=  n_1181;
delay_998: n_1181  <= TRANSPORT ntbrl  ;
and1_999: n_1182 <=  gnd;
delay_1000: n_1183  <= TRANSPORT trc  ;
filter_1001: FILTER_a6402

    PORT MAP (IN1 => n_1183, Y => a_N459_aCLK);
dff_1002: DFF_a6402

    PORT MAP ( D => a_N458_aD, CLK => a_N458_aCLK, CLRN => vcc, PRN => vcc,
          Q => a_N458);
xor2_1003: a_N458_aD <=  n_1191  XOR n_1194;
or1_1004: n_1191 <=  n_1192;
and1_1005: n_1192 <=  n_1193;
delay_1006: n_1193  <= TRANSPORT a_N459  ;
and1_1007: n_1194 <=  gnd;
delay_1008: n_1195  <= TRANSPORT trc  ;
filter_1009: FILTER_a6402

    PORT MAP (IN1 => n_1195, Y => a_N458_aCLK);
delay_1010: a_N18_aNOT  <= TRANSPORT a_N18_aNOT_aIN  ;
xor2_1011: a_N18_aNOT_aIN <=  n_1199  XOR n_1205;
or1_1012: n_1199 <=  n_1200;
and4_1013: n_1200 <=  n_1201  AND n_1202  AND n_1203  AND n_1204;
inv_1014: n_1201  <= TRANSPORT NOT mr  ;
delay_1015: n_1202  <= TRANSPORT a_N459  ;
inv_1016: n_1203  <= TRANSPORT NOT a_N458  ;
inv_1017: n_1204  <= TRANSPORT NOT a_N439  ;
and1_1018: n_1205 <=  gnd;
dff_1019: DFF_a6402

    PORT MAP ( D => a_EQ109, CLK => a_N438_aCLK, CLRN => a_N438_aCLRN, PRN => vcc,
          Q => a_N438);
inv_1020: a_N438_aCLRN  <= TRANSPORT NOT mr  ;
xor2_1021: a_EQ109 <=  n_1212  XOR n_1222;
or3_1022: n_1212 <=  n_1213  OR n_1216  OR n_1219;
and2_1023: n_1213 <=  n_1214  AND n_1215;
inv_1024: n_1214  <= TRANSPORT NOT a_N438  ;
delay_1025: n_1215  <= TRANSPORT a_N439  ;
and2_1026: n_1216 <=  n_1217  AND n_1218;
delay_1027: n_1217  <= TRANSPORT a_N18_aNOT  ;
delay_1028: n_1218  <= TRANSPORT a_N438  ;
and2_1029: n_1219 <=  n_1220  AND n_1221;
delay_1030: n_1220  <= TRANSPORT a_N184_aNOT  ;
delay_1031: n_1221  <= TRANSPORT a_N438  ;
and1_1032: n_1222 <=  gnd;
delay_1033: n_1223  <= TRANSPORT trc  ;
filter_1034: FILTER_a6402

    PORT MAP (IN1 => n_1223, Y => a_N438_aCLK);
dff_1035: DFF_a6402

    PORT MAP ( D => a_EQ110, CLK => a_N439_aCLK, CLRN => a_N439_aCLRN, PRN => vcc,
          Q => a_N439);
inv_1036: a_N439_aCLRN  <= TRANSPORT NOT mr  ;
xor2_1037: a_EQ110 <=  n_1231  XOR n_1237;
or2_1038: n_1231 <=  n_1232  OR n_1235;
and2_1039: n_1232 <=  n_1233  AND n_1234;
delay_1040: n_1233  <= TRANSPORT a_N438  ;
delay_1041: n_1234  <= TRANSPORT a_N439  ;
and1_1042: n_1235 <=  n_1236;
delay_1043: n_1236  <= TRANSPORT a_N18_aNOT  ;
and1_1044: n_1237 <=  gnd;
delay_1045: n_1238  <= TRANSPORT trc  ;
filter_1046: FILTER_a6402

    PORT MAP (IN1 => n_1238, Y => a_N439_aCLK);
dff_1047: DFF_a6402

    PORT MAP ( D => a_EQ124, CLK => a_SRBR0_aCLK, CLRN => a_SRBR0_aCLRN, PRN => vcc,
          Q => a_SRBR0);
inv_1048: a_SRBR0_aCLRN  <= TRANSPORT NOT mr  ;
xor2_1049: a_EQ124 <=  n_1246  XOR n_1257;
or3_1050: n_1246 <=  n_1247  OR n_1251  OR n_1254;
and3_1051: n_1247 <=  n_1248  AND n_1249  AND n_1250;
inv_1052: n_1248  <= TRANSPORT NOT a_LC2_B5  ;
delay_1053: n_1249  <= TRANSPORT a_SRXREGQ_F0_G  ;
delay_1054: n_1250  <= TRANSPORT a_N108  ;
and2_1055: n_1251 <=  n_1252  AND n_1253;
inv_1056: n_1252  <= TRANSPORT NOT a_N108  ;
delay_1057: n_1253  <= TRANSPORT a_SRBR0  ;
and2_1058: n_1254 <=  n_1255  AND n_1256;
delay_1059: n_1255  <= TRANSPORT a_LC2_B5  ;
delay_1060: n_1256  <= TRANSPORT a_SRBR0  ;
and1_1061: n_1257 <=  gnd;
delay_1062: n_1258  <= TRANSPORT rrc  ;
filter_1063: FILTER_a6402

    PORT MAP (IN1 => n_1258, Y => a_SRBR0_aCLK);
dff_1064: DFF_a6402

    PORT MAP ( D => a_EQ125, CLK => a_SRBR1_aCLK, CLRN => a_SRBR1_aCLRN, PRN => vcc,
          Q => a_SRBR1);
inv_1065: a_SRBR1_aCLRN  <= TRANSPORT NOT mr  ;
xor2_1066: a_EQ125 <=  n_1266  XOR n_1277;
or3_1067: n_1266 <=  n_1267  OR n_1271  OR n_1274;
and3_1068: n_1267 <=  n_1268  AND n_1269  AND n_1270;
inv_1069: n_1268  <= TRANSPORT NOT a_LC2_B5  ;
delay_1070: n_1269  <= TRANSPORT a_SRXREGQ_F1_G  ;
delay_1071: n_1270  <= TRANSPORT a_N108  ;
and2_1072: n_1271 <=  n_1272  AND n_1273;
inv_1073: n_1272  <= TRANSPORT NOT a_N108  ;
delay_1074: n_1273  <= TRANSPORT a_SRBR1  ;
and2_1075: n_1274 <=  n_1275  AND n_1276;
delay_1076: n_1275  <= TRANSPORT a_LC2_B5  ;
delay_1077: n_1276  <= TRANSPORT a_SRBR1  ;
and1_1078: n_1277 <=  gnd;
delay_1079: n_1278  <= TRANSPORT rrc  ;
filter_1080: FILTER_a6402

    PORT MAP (IN1 => n_1278, Y => a_SRBR1_aCLK);
dff_1081: DFF_a6402

    PORT MAP ( D => a_EQ126, CLK => a_SRBR2_aCLK, CLRN => a_SRBR2_aCLRN, PRN => vcc,
          Q => a_SRBR2);
inv_1082: a_SRBR2_aCLRN  <= TRANSPORT NOT mr  ;
xor2_1083: a_EQ126 <=  n_1286  XOR n_1297;
or3_1084: n_1286 <=  n_1287  OR n_1291  OR n_1294;
and3_1085: n_1287 <=  n_1288  AND n_1289  AND n_1290;
inv_1086: n_1288  <= TRANSPORT NOT a_LC2_B5  ;
delay_1087: n_1289  <= TRANSPORT a_SRXREGQ_F2_G  ;
delay_1088: n_1290  <= TRANSPORT a_N108  ;
and2_1089: n_1291 <=  n_1292  AND n_1293;
inv_1090: n_1292  <= TRANSPORT NOT a_N108  ;
delay_1091: n_1293  <= TRANSPORT a_SRBR2  ;
and2_1092: n_1294 <=  n_1295  AND n_1296;
delay_1093: n_1295  <= TRANSPORT a_LC2_B5  ;
delay_1094: n_1296  <= TRANSPORT a_SRBR2  ;
and1_1095: n_1297 <=  gnd;
delay_1096: n_1298  <= TRANSPORT rrc  ;
filter_1097: FILTER_a6402

    PORT MAP (IN1 => n_1298, Y => a_SRBR2_aCLK);
dff_1098: DFF_a6402

    PORT MAP ( D => a_EQ127, CLK => a_SRBR3_aCLK, CLRN => a_SRBR3_aCLRN, PRN => vcc,
          Q => a_SRBR3);
inv_1099: a_SRBR3_aCLRN  <= TRANSPORT NOT mr  ;
xor2_1100: a_EQ127 <=  n_1306  XOR n_1317;
or3_1101: n_1306 <=  n_1307  OR n_1311  OR n_1314;
and3_1102: n_1307 <=  n_1308  AND n_1309  AND n_1310;
inv_1103: n_1308  <= TRANSPORT NOT a_LC2_B5  ;
delay_1104: n_1309  <= TRANSPORT a_SRXREGQ_F3_G  ;
delay_1105: n_1310  <= TRANSPORT a_N108  ;
and2_1106: n_1311 <=  n_1312  AND n_1313;
inv_1107: n_1312  <= TRANSPORT NOT a_N108  ;
delay_1108: n_1313  <= TRANSPORT a_SRBR3  ;
and2_1109: n_1314 <=  n_1315  AND n_1316;
delay_1110: n_1315  <= TRANSPORT a_LC2_B5  ;
delay_1111: n_1316  <= TRANSPORT a_SRBR3  ;
and1_1112: n_1317 <=  gnd;
delay_1113: n_1318  <= TRANSPORT rrc  ;
filter_1114: FILTER_a6402

    PORT MAP (IN1 => n_1318, Y => a_SRBR3_aCLK);
dff_1115: DFF_a6402

    PORT MAP ( D => a_EQ128, CLK => a_SRBR4_aCLK, CLRN => a_SRBR4_aCLRN, PRN => vcc,
          Q => a_SRBR4);
inv_1116: a_SRBR4_aCLRN  <= TRANSPORT NOT mr  ;
xor2_1117: a_EQ128 <=  n_1326  XOR n_1337;
or3_1118: n_1326 <=  n_1327  OR n_1331  OR n_1334;
and3_1119: n_1327 <=  n_1328  AND n_1329  AND n_1330;
inv_1120: n_1328  <= TRANSPORT NOT a_LC2_B5  ;
delay_1121: n_1329  <= TRANSPORT a_SRXREGQ_F4_G  ;
delay_1122: n_1330  <= TRANSPORT a_N108  ;
and2_1123: n_1331 <=  n_1332  AND n_1333;
inv_1124: n_1332  <= TRANSPORT NOT a_N108  ;
delay_1125: n_1333  <= TRANSPORT a_SRBR4  ;
and2_1126: n_1334 <=  n_1335  AND n_1336;
delay_1127: n_1335  <= TRANSPORT a_LC2_B5  ;
delay_1128: n_1336  <= TRANSPORT a_SRBR4  ;
and1_1129: n_1337 <=  gnd;
delay_1130: n_1338  <= TRANSPORT rrc  ;
filter_1131: FILTER_a6402

    PORT MAP (IN1 => n_1338, Y => a_SRBR4_aCLK);
dff_1132: DFF_a6402

    PORT MAP ( D => a_EQ129, CLK => a_SRBR5_aCLK, CLRN => a_SRBR5_aCLRN, PRN => vcc,
          Q => a_SRBR5);
inv_1133: a_SRBR5_aCLRN  <= TRANSPORT NOT mr  ;
xor2_1134: a_EQ129 <=  n_1346  XOR n_1357;
or3_1135: n_1346 <=  n_1347  OR n_1351  OR n_1354;
and3_1136: n_1347 <=  n_1348  AND n_1349  AND n_1350;
inv_1137: n_1348  <= TRANSPORT NOT a_LC2_B5  ;
delay_1138: n_1349  <= TRANSPORT a_SRXREGQ_F5_G  ;
delay_1139: n_1350  <= TRANSPORT a_N108  ;
and2_1140: n_1351 <=  n_1352  AND n_1353;
inv_1141: n_1352  <= TRANSPORT NOT a_N108  ;
delay_1142: n_1353  <= TRANSPORT a_SRBR5  ;
and2_1143: n_1354 <=  n_1355  AND n_1356;
delay_1144: n_1355  <= TRANSPORT a_LC2_B5  ;
delay_1145: n_1356  <= TRANSPORT a_SRBR5  ;
and1_1146: n_1357 <=  gnd;
delay_1147: n_1358  <= TRANSPORT rrc  ;
filter_1148: FILTER_a6402

    PORT MAP (IN1 => n_1358, Y => a_SRBR5_aCLK);
dff_1149: DFF_a6402

    PORT MAP ( D => a_EQ130, CLK => a_SRBR6_aCLK, CLRN => a_SRBR6_aCLRN, PRN => vcc,
          Q => a_SRBR6);
inv_1150: a_SRBR6_aCLRN  <= TRANSPORT NOT mr  ;
xor2_1151: a_EQ130 <=  n_1366  XOR n_1377;
or3_1152: n_1366 <=  n_1367  OR n_1371  OR n_1374;
and3_1153: n_1367 <=  n_1368  AND n_1369  AND n_1370;
inv_1154: n_1368  <= TRANSPORT NOT a_LC2_B5  ;
delay_1155: n_1369  <= TRANSPORT a_SRXREGQ_F6_G  ;
delay_1156: n_1370  <= TRANSPORT a_N108  ;
and2_1157: n_1371 <=  n_1372  AND n_1373;
inv_1158: n_1372  <= TRANSPORT NOT a_N108  ;
delay_1159: n_1373  <= TRANSPORT a_SRBR6  ;
and2_1160: n_1374 <=  n_1375  AND n_1376;
delay_1161: n_1375  <= TRANSPORT a_LC2_B5  ;
delay_1162: n_1376  <= TRANSPORT a_SRBR6  ;
and1_1163: n_1377 <=  gnd;
delay_1164: n_1378  <= TRANSPORT rrc  ;
filter_1165: FILTER_a6402

    PORT MAP (IN1 => n_1378, Y => a_SRBR6_aCLK);
dff_1166: DFF_a6402

    PORT MAP ( D => a_EQ131, CLK => a_SRBR7_aCLK, CLRN => a_SRBR7_aCLRN, PRN => vcc,
          Q => a_SRBR7);
inv_1167: a_SRBR7_aCLRN  <= TRANSPORT NOT mr  ;
xor2_1168: a_EQ131 <=  n_1386  XOR n_1397;
or3_1169: n_1386 <=  n_1387  OR n_1391  OR n_1394;
and3_1170: n_1387 <=  n_1388  AND n_1389  AND n_1390;
inv_1171: n_1388  <= TRANSPORT NOT a_LC2_B5  ;
delay_1172: n_1389  <= TRANSPORT a_SRXREGQ_F7_G  ;
delay_1173: n_1390  <= TRANSPORT a_N108  ;
and2_1174: n_1391 <=  n_1392  AND n_1393;
inv_1175: n_1392  <= TRANSPORT NOT a_N108  ;
delay_1176: n_1393  <= TRANSPORT a_SRBR7  ;
and2_1177: n_1394 <=  n_1395  AND n_1396;
delay_1178: n_1395  <= TRANSPORT a_LC2_B5  ;
delay_1179: n_1396  <= TRANSPORT a_SRBR7  ;
and1_1180: n_1397 <=  gnd;
delay_1181: n_1398  <= TRANSPORT rrc  ;
filter_1182: FILTER_a6402

    PORT MAP (IN1 => n_1398, Y => a_SRBR7_aCLK);
delay_1183: a_LC3_B2  <= TRANSPORT a_EQ055  ;
xor2_1184: a_EQ055 <=  n_1402  XOR n_1444;
or8_1185: n_1402 <=  n_1403  OR n_1409  OR n_1414  OR n_1419  OR n_1424  OR n_1429
           OR n_1434  OR n_1439;
and4_1186: n_1403 <=  n_1404  AND n_1406  AND n_1407  AND n_1408;
delay_1187: n_1404  <= TRANSPORT a_SCNTLQ_F1_G  ;
delay_1188: n_1406  <= TRANSPORT a_SRXREGQ_F4_G  ;
delay_1189: n_1407  <= TRANSPORT a_SRXREGQ_F5_G  ;
inv_1190: n_1408  <= TRANSPORT NOT rri  ;
and4_1191: n_1409 <=  n_1410  AND n_1411  AND n_1412  AND n_1413;
inv_1192: n_1410  <= TRANSPORT NOT a_SCNTLQ_F1_G  ;
delay_1193: n_1411  <= TRANSPORT a_SRXREGQ_F4_G  ;
delay_1194: n_1412  <= TRANSPORT a_SRXREGQ_F5_G  ;
delay_1195: n_1413  <= TRANSPORT rri  ;
and4_1196: n_1414 <=  n_1415  AND n_1416  AND n_1417  AND n_1418;
inv_1197: n_1415  <= TRANSPORT NOT a_SCNTLQ_F1_G  ;
inv_1198: n_1416  <= TRANSPORT NOT a_SRXREGQ_F4_G  ;
delay_1199: n_1417  <= TRANSPORT a_SRXREGQ_F5_G  ;
inv_1200: n_1418  <= TRANSPORT NOT rri  ;
and4_1201: n_1419 <=  n_1420  AND n_1421  AND n_1422  AND n_1423;
delay_1202: n_1420  <= TRANSPORT a_SCNTLQ_F1_G  ;
inv_1203: n_1421  <= TRANSPORT NOT a_SRXREGQ_F4_G  ;
delay_1204: n_1422  <= TRANSPORT a_SRXREGQ_F5_G  ;
delay_1205: n_1423  <= TRANSPORT rri  ;
and4_1206: n_1424 <=  n_1425  AND n_1426  AND n_1427  AND n_1428;
delay_1207: n_1425  <= TRANSPORT a_SCNTLQ_F1_G  ;
inv_1208: n_1426  <= TRANSPORT NOT a_SRXREGQ_F4_G  ;
inv_1209: n_1427  <= TRANSPORT NOT a_SRXREGQ_F5_G  ;
inv_1210: n_1428  <= TRANSPORT NOT rri  ;
and4_1211: n_1429 <=  n_1430  AND n_1431  AND n_1432  AND n_1433;
inv_1212: n_1430  <= TRANSPORT NOT a_SCNTLQ_F1_G  ;
inv_1213: n_1431  <= TRANSPORT NOT a_SRXREGQ_F4_G  ;
inv_1214: n_1432  <= TRANSPORT NOT a_SRXREGQ_F5_G  ;
delay_1215: n_1433  <= TRANSPORT rri  ;
and4_1216: n_1434 <=  n_1435  AND n_1436  AND n_1437  AND n_1438;
inv_1217: n_1435  <= TRANSPORT NOT a_SCNTLQ_F1_G  ;
delay_1218: n_1436  <= TRANSPORT a_SRXREGQ_F4_G  ;
inv_1219: n_1437  <= TRANSPORT NOT a_SRXREGQ_F5_G  ;
inv_1220: n_1438  <= TRANSPORT NOT rri  ;
and4_1221: n_1439 <=  n_1440  AND n_1441  AND n_1442  AND n_1443;
delay_1222: n_1440  <= TRANSPORT a_SCNTLQ_F1_G  ;
delay_1223: n_1441  <= TRANSPORT a_SRXREGQ_F4_G  ;
inv_1224: n_1442  <= TRANSPORT NOT a_SRXREGQ_F5_G  ;
delay_1225: n_1443  <= TRANSPORT rri  ;
and1_1226: n_1444 <=  gnd;
delay_1227: a_LC1_B2  <= TRANSPORT a_EQ054  ;
xor2_1228: a_EQ054 <=  n_1447  XOR n_1488;
or8_1229: n_1447 <=  n_1448  OR n_1453  OR n_1458  OR n_1463  OR n_1468  OR n_1473
           OR n_1478  OR n_1483;
and4_1230: n_1448 <=  n_1449  AND n_1450  AND n_1451  AND n_1452;
inv_1231: n_1449  <= TRANSPORT NOT a_SRXREGQ_F0_G  ;
inv_1232: n_1450  <= TRANSPORT NOT a_SRXREGQ_F1_G  ;
inv_1233: n_1451  <= TRANSPORT NOT a_SRXREGQ_F2_G  ;
delay_1234: n_1452  <= TRANSPORT a_SRXREGQ_F3_G  ;
and4_1235: n_1453 <=  n_1454  AND n_1455  AND n_1456  AND n_1457;
delay_1236: n_1454  <= TRANSPORT a_SRXREGQ_F0_G  ;
delay_1237: n_1455  <= TRANSPORT a_SRXREGQ_F1_G  ;
inv_1238: n_1456  <= TRANSPORT NOT a_SRXREGQ_F2_G  ;
delay_1239: n_1457  <= TRANSPORT a_SRXREGQ_F3_G  ;
and4_1240: n_1458 <=  n_1459  AND n_1460  AND n_1461  AND n_1462;
delay_1241: n_1459  <= TRANSPORT a_SRXREGQ_F0_G  ;
inv_1242: n_1460  <= TRANSPORT NOT a_SRXREGQ_F1_G  ;
delay_1243: n_1461  <= TRANSPORT a_SRXREGQ_F2_G  ;
delay_1244: n_1462  <= TRANSPORT a_SRXREGQ_F3_G  ;
and4_1245: n_1463 <=  n_1464  AND n_1465  AND n_1466  AND n_1467;
inv_1246: n_1464  <= TRANSPORT NOT a_SRXREGQ_F0_G  ;
delay_1247: n_1465  <= TRANSPORT a_SRXREGQ_F1_G  ;
delay_1248: n_1466  <= TRANSPORT a_SRXREGQ_F2_G  ;
delay_1249: n_1467  <= TRANSPORT a_SRXREGQ_F3_G  ;
and4_1250: n_1468 <=  n_1469  AND n_1470  AND n_1471  AND n_1472;
inv_1251: n_1469  <= TRANSPORT NOT a_SRXREGQ_F0_G  ;
inv_1252: n_1470  <= TRANSPORT NOT a_SRXREGQ_F1_G  ;
delay_1253: n_1471  <= TRANSPORT a_SRXREGQ_F2_G  ;
inv_1254: n_1472  <= TRANSPORT NOT a_SRXREGQ_F3_G  ;
and4_1255: n_1473 <=  n_1474  AND n_1475  AND n_1476  AND n_1477;
delay_1256: n_1474  <= TRANSPORT a_SRXREGQ_F0_G  ;
delay_1257: n_1475  <= TRANSPORT a_SRXREGQ_F1_G  ;
delay_1258: n_1476  <= TRANSPORT a_SRXREGQ_F2_G  ;
inv_1259: n_1477  <= TRANSPORT NOT a_SRXREGQ_F3_G  ;
and4_1260: n_1478 <=  n_1479  AND n_1480  AND n_1481  AND n_1482;
delay_1261: n_1479  <= TRANSPORT a_SRXREGQ_F0_G  ;
inv_1262: n_1480  <= TRANSPORT NOT a_SRXREGQ_F1_G  ;
inv_1263: n_1481  <= TRANSPORT NOT a_SRXREGQ_F2_G  ;
inv_1264: n_1482  <= TRANSPORT NOT a_SRXREGQ_F3_G  ;
and4_1265: n_1483 <=  n_1484  AND n_1485  AND n_1486  AND n_1487;
inv_1266: n_1484  <= TRANSPORT NOT a_SRXREGQ_F0_G  ;
delay_1267: n_1485  <= TRANSPORT a_SRXREGQ_F1_G  ;
inv_1268: n_1486  <= TRANSPORT NOT a_SRXREGQ_F2_G  ;
inv_1269: n_1487  <= TRANSPORT NOT a_SRXREGQ_F3_G  ;
and1_1270: n_1488 <=  gnd;
delay_1271: a_N179  <= TRANSPORT a_EQ056  ;
xor2_1272: a_EQ056 <=  n_1491  XOR n_1532;
or8_1273: n_1491 <=  n_1492  OR n_1497  OR n_1502  OR n_1507  OR n_1512  OR n_1517
           OR n_1522  OR n_1527;
and4_1274: n_1492 <=  n_1493  AND n_1494  AND n_1495  AND n_1496;
inv_1275: n_1493  <= TRANSPORT NOT a_SRXREGQ_F6_G  ;
delay_1276: n_1494  <= TRANSPORT a_SRXREGQ_F7_G  ;
inv_1277: n_1495  <= TRANSPORT NOT a_LC3_B2  ;
inv_1278: n_1496  <= TRANSPORT NOT a_LC1_B2  ;
and4_1279: n_1497 <=  n_1498  AND n_1499  AND n_1500  AND n_1501;
delay_1280: n_1498  <= TRANSPORT a_SRXREGQ_F6_G  ;
inv_1281: n_1499  <= TRANSPORT NOT a_SRXREGQ_F7_G  ;
inv_1282: n_1500  <= TRANSPORT NOT a_LC3_B2  ;
inv_1283: n_1501  <= TRANSPORT NOT a_LC1_B2  ;
and4_1284: n_1502 <=  n_1503  AND n_1504  AND n_1505  AND n_1506;
delay_1285: n_1503  <= TRANSPORT a_SRXREGQ_F6_G  ;
delay_1286: n_1504  <= TRANSPORT a_SRXREGQ_F7_G  ;
delay_1287: n_1505  <= TRANSPORT a_LC3_B2  ;
inv_1288: n_1506  <= TRANSPORT NOT a_LC1_B2  ;
and4_1289: n_1507 <=  n_1508  AND n_1509  AND n_1510  AND n_1511;
inv_1290: n_1508  <= TRANSPORT NOT a_SRXREGQ_F6_G  ;
inv_1291: n_1509  <= TRANSPORT NOT a_SRXREGQ_F7_G  ;
delay_1292: n_1510  <= TRANSPORT a_LC3_B2  ;
inv_1293: n_1511  <= TRANSPORT NOT a_LC1_B2  ;
and4_1294: n_1512 <=  n_1513  AND n_1514  AND n_1515  AND n_1516;
delay_1295: n_1513  <= TRANSPORT a_SRXREGQ_F6_G  ;
delay_1296: n_1514  <= TRANSPORT a_SRXREGQ_F7_G  ;
inv_1297: n_1515  <= TRANSPORT NOT a_LC3_B2  ;
delay_1298: n_1516  <= TRANSPORT a_LC1_B2  ;
and4_1299: n_1517 <=  n_1518  AND n_1519  AND n_1520  AND n_1521;
inv_1300: n_1518  <= TRANSPORT NOT a_SRXREGQ_F6_G  ;
inv_1301: n_1519  <= TRANSPORT NOT a_SRXREGQ_F7_G  ;
inv_1302: n_1520  <= TRANSPORT NOT a_LC3_B2  ;
delay_1303: n_1521  <= TRANSPORT a_LC1_B2  ;
and4_1304: n_1522 <=  n_1523  AND n_1524  AND n_1525  AND n_1526;
inv_1305: n_1523  <= TRANSPORT NOT a_SRXREGQ_F6_G  ;
delay_1306: n_1524  <= TRANSPORT a_SRXREGQ_F7_G  ;
delay_1307: n_1525  <= TRANSPORT a_LC3_B2  ;
delay_1308: n_1526  <= TRANSPORT a_LC1_B2  ;
and4_1309: n_1527 <=  n_1528  AND n_1529  AND n_1530  AND n_1531;
delay_1310: n_1528  <= TRANSPORT a_SRXREGQ_F6_G  ;
inv_1311: n_1529  <= TRANSPORT NOT a_SRXREGQ_F7_G  ;
delay_1312: n_1530  <= TRANSPORT a_LC3_B2  ;
delay_1313: n_1531  <= TRANSPORT a_LC1_B2  ;
and1_1314: n_1532 <=  gnd;
dff_1315: DFF_a6402

    PORT MAP ( D => a_EQ123, CLK => a_SPE_aCLK, CLRN => a_SPE_aCLRN, PRN => vcc,
          Q => a_SPE);
inv_1316: a_SPE_aCLRN  <= TRANSPORT NOT mr  ;
xor2_1317: a_EQ123 <=  n_1539  XOR n_1550;
or3_1318: n_1539 <=  n_1540  OR n_1543  OR n_1546;
and2_1319: n_1540 <=  n_1541  AND n_1542;
delay_1320: n_1541  <= TRANSPORT a_N108  ;
delay_1321: n_1542  <= TRANSPORT a_SPE  ;
and2_1322: n_1543 <=  n_1544  AND n_1545;
delay_1323: n_1544  <= TRANSPORT a_LC2_B5  ;
delay_1324: n_1545  <= TRANSPORT a_SPE  ;
and3_1325: n_1546 <=  n_1547  AND n_1548  AND n_1549;
inv_1326: n_1547  <= TRANSPORT NOT a_LC2_B5  ;
inv_1327: n_1548  <= TRANSPORT NOT a_N108  ;
inv_1328: n_1549  <= TRANSPORT NOT a_N179  ;
and1_1329: n_1550 <=  gnd;
delay_1330: n_1551  <= TRANSPORT rrc  ;
filter_1331: FILTER_a6402

    PORT MAP (IN1 => n_1551, Y => a_SPE_aCLK);
dff_1332: DFF_a6402

    PORT MAP ( D => a_EQ121, CLK => a_SFE_aCLK, CLRN => a_SFE_aCLRN, PRN => vcc,
          Q => a_SFE);
inv_1333: a_SFE_aCLRN  <= TRANSPORT NOT mr  ;
xor2_1334: a_EQ121 <=  n_1559  XOR n_1570;
or3_1335: n_1559 <=  n_1560  OR n_1563  OR n_1566;
and2_1336: n_1560 <=  n_1561  AND n_1562;
inv_1337: n_1561  <= TRANSPORT NOT a_N108  ;
delay_1338: n_1562  <= TRANSPORT a_SFE  ;
and2_1339: n_1563 <=  n_1564  AND n_1565;
delay_1340: n_1564  <= TRANSPORT a_LC2_B5  ;
delay_1341: n_1565  <= TRANSPORT a_SFE  ;
and3_1342: n_1566 <=  n_1567  AND n_1568  AND n_1569;
inv_1343: n_1567  <= TRANSPORT NOT a_LC2_B5  ;
delay_1344: n_1568  <= TRANSPORT a_N108  ;
inv_1345: n_1569  <= TRANSPORT NOT rri  ;
and1_1346: n_1570 <=  gnd;
delay_1347: n_1571  <= TRANSPORT rrc  ;
filter_1348: FILTER_a6402

    PORT MAP (IN1 => n_1571, Y => a_SFE_aCLK);
delay_1349: a_N68  <= TRANSPORT a_EQ026  ;
xor2_1350: a_EQ026 <=  n_1575  XOR n_1619;
or8_1351: n_1575 <=  n_1576  OR n_1584  OR n_1589  OR n_1594  OR n_1599  OR n_1604
           OR n_1609  OR n_1614;
and4_1352: n_1576 <=  n_1577  AND n_1579  AND n_1581  AND n_1583;
inv_1353: n_1577  <= TRANSPORT NOT a_STRQ_F2_G  ;
delay_1354: n_1579  <= TRANSPORT a_STRQ_F3_G  ;
delay_1355: n_1581  <= TRANSPORT a_STRQ_F1_G  ;
inv_1356: n_1583  <= TRANSPORT NOT a_SCNTLQ_F1_G  ;
and4_1357: n_1584 <=  n_1585  AND n_1586  AND n_1587  AND n_1588;
delay_1358: n_1585  <= TRANSPORT a_STRQ_F2_G  ;
delay_1359: n_1586  <= TRANSPORT a_STRQ_F3_G  ;
inv_1360: n_1587  <= TRANSPORT NOT a_STRQ_F1_G  ;
inv_1361: n_1588  <= TRANSPORT NOT a_SCNTLQ_F1_G  ;
and4_1362: n_1589 <=  n_1590  AND n_1591  AND n_1592  AND n_1593;
delay_1363: n_1590  <= TRANSPORT a_STRQ_F2_G  ;
inv_1364: n_1591  <= TRANSPORT NOT a_STRQ_F3_G  ;
delay_1365: n_1592  <= TRANSPORT a_STRQ_F1_G  ;
inv_1366: n_1593  <= TRANSPORT NOT a_SCNTLQ_F1_G  ;
and4_1367: n_1594 <=  n_1595  AND n_1596  AND n_1597  AND n_1598;
inv_1368: n_1595  <= TRANSPORT NOT a_STRQ_F2_G  ;
inv_1369: n_1596  <= TRANSPORT NOT a_STRQ_F3_G  ;
inv_1370: n_1597  <= TRANSPORT NOT a_STRQ_F1_G  ;
inv_1371: n_1598  <= TRANSPORT NOT a_SCNTLQ_F1_G  ;
and4_1372: n_1599 <=  n_1600  AND n_1601  AND n_1602  AND n_1603;
inv_1373: n_1600  <= TRANSPORT NOT a_STRQ_F2_G  ;
inv_1374: n_1601  <= TRANSPORT NOT a_STRQ_F3_G  ;
delay_1375: n_1602  <= TRANSPORT a_STRQ_F1_G  ;
delay_1376: n_1603  <= TRANSPORT a_SCNTLQ_F1_G  ;
and4_1377: n_1604 <=  n_1605  AND n_1606  AND n_1607  AND n_1608;
delay_1378: n_1605  <= TRANSPORT a_STRQ_F2_G  ;
inv_1379: n_1606  <= TRANSPORT NOT a_STRQ_F3_G  ;
inv_1380: n_1607  <= TRANSPORT NOT a_STRQ_F1_G  ;
delay_1381: n_1608  <= TRANSPORT a_SCNTLQ_F1_G  ;
and4_1382: n_1609 <=  n_1610  AND n_1611  AND n_1612  AND n_1613;
delay_1383: n_1610  <= TRANSPORT a_STRQ_F2_G  ;
delay_1384: n_1611  <= TRANSPORT a_STRQ_F3_G  ;
delay_1385: n_1612  <= TRANSPORT a_STRQ_F1_G  ;
delay_1386: n_1613  <= TRANSPORT a_SCNTLQ_F1_G  ;
and4_1387: n_1614 <=  n_1615  AND n_1616  AND n_1617  AND n_1618;
inv_1388: n_1615  <= TRANSPORT NOT a_STRQ_F2_G  ;
delay_1389: n_1616  <= TRANSPORT a_STRQ_F3_G  ;
inv_1390: n_1617  <= TRANSPORT NOT a_STRQ_F1_G  ;
delay_1391: n_1618  <= TRANSPORT a_SCNTLQ_F1_G  ;
and1_1392: n_1619 <=  gnd;
delay_1393: a_N252  <= TRANSPORT a_EQ071  ;
xor2_1394: a_EQ071 <=  n_1622  XOR n_1630;
or2_1395: n_1622 <=  n_1623  OR n_1627;
and2_1396: n_1623 <=  n_1624  AND n_1626;
delay_1397: n_1624  <= TRANSPORT a_STRQ_F5_G  ;
inv_1398: n_1626  <= TRANSPORT NOT a_N68  ;
and2_1399: n_1627 <=  n_1628  AND n_1629;
inv_1400: n_1628  <= TRANSPORT NOT a_STRQ_F5_G  ;
delay_1401: n_1629  <= TRANSPORT a_N68  ;
and1_1402: n_1630 <=  gnd;
delay_1403: a_LC6_A13  <= TRANSPORT a_EQ077  ;
xor2_1404: a_EQ077 <=  n_1633  XOR n_1644;
or2_1405: n_1633 <=  n_1634  OR n_1640;
and3_1406: n_1634 <=  n_1635  AND n_1637  AND n_1639;
inv_1407: n_1635  <= TRANSPORT NOT a_STRQ_F0_G  ;
delay_1408: n_1637  <= TRANSPORT a_STRQ_F4_G  ;
inv_1409: n_1639  <= TRANSPORT NOT a_N395  ;
and3_1410: n_1640 <=  n_1641  AND n_1642  AND n_1643;
delay_1411: n_1641  <= TRANSPORT a_STRQ_F0_G  ;
inv_1412: n_1642  <= TRANSPORT NOT a_STRQ_F4_G  ;
delay_1413: n_1643  <= TRANSPORT a_N393  ;
and1_1414: n_1644 <=  gnd;
delay_1415: a_N256  <= TRANSPORT a_EQ073  ;
xor2_1416: a_EQ073 <=  n_1647  XOR n_1656;
or2_1417: n_1647 <=  n_1648  OR n_1653;
and4_1418: n_1648 <=  n_1649  AND n_1650  AND n_1651  AND n_1652;
delay_1419: n_1649  <= TRANSPORT a_STRQ_F0_G  ;
delay_1420: n_1650  <= TRANSPORT a_STRQ_F4_G  ;
inv_1421: n_1651  <= TRANSPORT NOT a_N395  ;
delay_1422: n_1652  <= TRANSPORT a_N393  ;
and2_1423: n_1653 <=  n_1654  AND n_1655;
inv_1424: n_1654  <= TRANSPORT NOT a_STRQ_F0_G  ;
inv_1425: n_1655  <= TRANSPORT NOT a_STRQ_F4_G  ;
and1_1426: n_1656 <=  gnd;
delay_1427: a_LC3_A13_aNOT  <= TRANSPORT a_EQ069  ;
xor2_1428: a_EQ069 <=  n_1659  XOR n_1668;
or2_1429: n_1659 <=  n_1660  OR n_1664;
and3_1430: n_1660 <=  n_1661  AND n_1662  AND n_1663;
delay_1431: n_1661  <= TRANSPORT a_SCNTLQ_F4_G  ;
inv_1432: n_1662  <= TRANSPORT NOT a_N252  ;
delay_1433: n_1663  <= TRANSPORT a_LC6_A13  ;
and3_1434: n_1664 <=  n_1665  AND n_1666  AND n_1667;
delay_1435: n_1665  <= TRANSPORT a_SCNTLQ_F4_G  ;
delay_1436: n_1666  <= TRANSPORT a_N252  ;
delay_1437: n_1667  <= TRANSPORT a_N256  ;
and1_1438: n_1668 <=  gnd;
delay_1439: a_N60_aNOT  <= TRANSPORT a_EQ022  ;
xor2_1440: a_EQ022 <=  n_1671  XOR n_1677;
or2_1441: n_1671 <=  n_1672  OR n_1675;
and1_1442: n_1672 <=  n_1673;
inv_1443: n_1673  <= TRANSPORT NOT a_STRQ_F7_G  ;
and1_1444: n_1675 <=  n_1676;
inv_1445: n_1676  <= TRANSPORT NOT a_SCNTLQ_F3_G  ;
and1_1446: n_1677 <=  gnd;
delay_1447: a_LC1_A13_aNOT  <= TRANSPORT a_EQ068  ;
xor2_1448: a_EQ068 <=  n_1680  XOR n_1687;
or2_1449: n_1680 <=  n_1681  OR n_1684;
and2_1450: n_1681 <=  n_1682  AND n_1683;
inv_1451: n_1682  <= TRANSPORT NOT a_N252  ;
delay_1452: n_1683  <= TRANSPORT a_N256  ;
and2_1453: n_1684 <=  n_1685  AND n_1686;
delay_1454: n_1685  <= TRANSPORT a_N252  ;
delay_1455: n_1686  <= TRANSPORT a_LC6_A13  ;
and1_1456: n_1687 <=  gnd;
delay_1457: a_LC6_A4  <= TRANSPORT a_EQ078  ;
xor2_1458: a_EQ078 <=  n_1690  XOR n_1700;
or3_1459: n_1690 <=  n_1691  OR n_1694  OR n_1697;
and2_1460: n_1691 <=  n_1692  AND n_1693;
delay_1461: n_1692  <= TRANSPORT a_SCNTLQ_F4_G  ;
delay_1462: n_1693  <= TRANSPORT a_N60_aNOT  ;
and2_1463: n_1694 <=  n_1695  AND n_1696;
delay_1464: n_1695  <= TRANSPORT a_SCNTLQ_F3_G  ;
delay_1465: n_1696  <= TRANSPORT a_N60_aNOT  ;
and2_1466: n_1697 <=  n_1698  AND n_1699;
inv_1467: n_1698  <= TRANSPORT NOT a_STRQ_F5_G  ;
delay_1468: n_1699  <= TRANSPORT a_N60_aNOT  ;
and1_1469: n_1700 <=  gnd;
delay_1470: a_LC4_A10_aNOT  <= TRANSPORT a_EQ095  ;
xor2_1471: a_EQ095 <=  n_1703  XOR n_1715;
or3_1472: n_1703 <=  n_1704  OR n_1708  OR n_1712;
and3_1473: n_1704 <=  n_1705  AND n_1706  AND n_1707;
delay_1474: n_1705  <= TRANSPORT a_LC3_A13_aNOT  ;
delay_1475: n_1706  <= TRANSPORT a_N60_aNOT  ;
inv_1476: n_1707  <= TRANSPORT NOT a_LC1_A13_aNOT  ;
and3_1477: n_1708 <=  n_1709  AND n_1710  AND n_1711;
delay_1478: n_1709  <= TRANSPORT a_LC3_A13_aNOT  ;
delay_1479: n_1710  <= TRANSPORT a_N60_aNOT  ;
inv_1480: n_1711  <= TRANSPORT NOT a_LC6_A4  ;
and2_1481: n_1712 <=  n_1713  AND n_1714;
inv_1482: n_1713  <= TRANSPORT NOT a_N60_aNOT  ;
delay_1483: n_1714  <= TRANSPORT a_LC1_A13_aNOT  ;
and1_1484: n_1715 <=  gnd;
delay_1485: a_LC5_A10_aNOT  <= TRANSPORT a_EQ096  ;
xor2_1486: a_EQ096 <=  n_1718  XOR n_1726;
or2_1487: n_1718 <=  n_1719  OR n_1723;
and2_1488: n_1719 <=  n_1720  AND n_1722;
delay_1489: n_1720  <= TRANSPORT a_STRQ_F6_G  ;
delay_1490: n_1722  <= TRANSPORT a_LC4_A10_aNOT  ;
and2_1491: n_1723 <=  n_1724  AND n_1725;
delay_1492: n_1724  <= TRANSPORT a_LC2_B1_aNOT  ;
delay_1493: n_1725  <= TRANSPORT a_LC1_A13_aNOT  ;
and1_1494: n_1726 <=  gnd;
delay_1495: a_LC3_A10  <= TRANSPORT a_EQ016  ;
xor2_1496: a_EQ016 <=  n_1729  XOR n_1736;
or2_1497: n_1729 <=  n_1730  OR n_1733;
and2_1498: n_1730 <=  n_1731  AND n_1732;
inv_1499: n_1731  <= TRANSPORT NOT a_STRQ_F7_G  ;
inv_1500: n_1732  <= TRANSPORT NOT a_N395  ;
and2_1501: n_1733 <=  n_1734  AND n_1735;
inv_1502: n_1734  <= TRANSPORT NOT a_STRQ_F3_G  ;
delay_1503: n_1735  <= TRANSPORT a_N395  ;
and1_1504: n_1736 <=  gnd;
delay_1505: a_LC6_A10  <= TRANSPORT a_EQ097  ;
xor2_1506: a_EQ097 <=  n_1739  XOR n_1748;
or2_1507: n_1739 <=  n_1740  OR n_1744;
and3_1508: n_1740 <=  n_1741  AND n_1742  AND n_1743;
delay_1509: n_1741  <= TRANSPORT a_N396  ;
inv_1510: n_1742  <= TRANSPORT NOT a_N397  ;
delay_1511: n_1743  <= TRANSPORT a_LC5_A10_aNOT  ;
and3_1512: n_1744 <=  n_1745  AND n_1746  AND n_1747;
inv_1513: n_1745  <= TRANSPORT NOT a_N396  ;
delay_1514: n_1746  <= TRANSPORT a_N397  ;
delay_1515: n_1747  <= TRANSPORT a_LC3_A10  ;
and1_1516: n_1748 <=  gnd;
delay_1517: a_LC3_A1  <= TRANSPORT a_EQ098  ;
xor2_1518: a_EQ098 <=  n_1751  XOR n_1759;
or2_1519: n_1751 <=  n_1752  OR n_1756;
and3_1520: n_1752 <=  n_1753  AND n_1754  AND n_1755;
inv_1521: n_1753  <= TRANSPORT NOT a_STRQ_F6_G  ;
inv_1522: n_1754  <= TRANSPORT NOT a_N395  ;
delay_1523: n_1755  <= TRANSPORT a_N393  ;
and2_1524: n_1756 <=  n_1757  AND n_1758;
inv_1525: n_1757  <= TRANSPORT NOT a_STRQ_F6_G  ;
delay_1526: n_1758  <= TRANSPORT a_N396  ;
and1_1527: n_1759 <=  gnd;
delay_1528: a_N260_aNOT  <= TRANSPORT a_N260_aNOT_aIN  ;
xor2_1529: a_N260_aNOT_aIN <=  n_1762  XOR n_1766;
or1_1530: n_1762 <=  n_1763;
and2_1531: n_1763 <=  n_1764  AND n_1765;
delay_1532: n_1764  <= TRANSPORT a_LC3_A13_aNOT  ;
inv_1533: n_1765  <= TRANSPORT NOT a_N60_aNOT  ;
and1_1534: n_1766 <=  gnd;
delay_1535: a_LC5_A1_aNOT  <= TRANSPORT a_EQ099  ;
xor2_1536: a_EQ099 <=  n_1769  XOR n_1777;
or3_1537: n_1769 <=  n_1770  OR n_1772  OR n_1775;
and1_1538: n_1770 <=  n_1771;
delay_1539: n_1771  <= TRANSPORT a_N260_aNOT  ;
and2_1540: n_1772 <=  n_1773  AND n_1774;
delay_1541: n_1773  <= TRANSPORT a_LC1_A13_aNOT  ;
delay_1542: n_1774  <= TRANSPORT a_LC6_A4  ;
and1_1543: n_1775 <=  n_1776;
inv_1544: n_1776  <= TRANSPORT NOT a_N396  ;
and1_1545: n_1777 <=  gnd;
delay_1546: a_LC6_A1_aNOT  <= TRANSPORT a_EQ100  ;
xor2_1547: a_EQ100 <=  n_1780  XOR n_1787;
or2_1548: n_1780 <=  n_1781  OR n_1785;
and3_1549: n_1781 <=  n_1782  AND n_1783  AND n_1784;
inv_1550: n_1782  <= TRANSPORT NOT a_STRQ_F2_G  ;
delay_1551: n_1783  <= TRANSPORT a_N395  ;
inv_1552: n_1784  <= TRANSPORT NOT a_N393  ;
and1_1553: n_1785 <=  n_1786;
delay_1554: n_1786  <= TRANSPORT a_N396  ;
and1_1555: n_1787 <=  gnd;
delay_1556: a_LC5_A13_aNOT  <= TRANSPORT a_EQ101  ;
xor2_1557: a_EQ101 <=  n_1790  XOR n_1799;
or2_1558: n_1790 <=  n_1791  OR n_1795;
and3_1559: n_1791 <=  n_1792  AND n_1793  AND n_1794;
inv_1560: n_1792  <= TRANSPORT NOT a_N37  ;
delay_1561: n_1793  <= TRANSPORT a_N68  ;
delay_1562: n_1794  <= TRANSPORT a_LC6_A13  ;
and3_1563: n_1795 <=  n_1796  AND n_1797  AND n_1798;
inv_1564: n_1796  <= TRANSPORT NOT a_N37  ;
inv_1565: n_1797  <= TRANSPORT NOT a_N68  ;
delay_1566: n_1798  <= TRANSPORT a_N256  ;
and1_1567: n_1799 <=  gnd;
delay_1568: a_N67_aNOT  <= TRANSPORT a_N67_aNOT_aIN  ;
xor2_1569: a_N67_aNOT_aIN <=  n_1802  XOR n_1806;
or1_1570: n_1802 <=  n_1803;
and2_1571: n_1803 <=  n_1804  AND n_1805;
inv_1572: n_1804  <= TRANSPORT NOT a_N38  ;
inv_1573: n_1805  <= TRANSPORT NOT a_N393  ;
and1_1574: n_1806 <=  gnd;
delay_1575: a_LC7_A1_aNOT  <= TRANSPORT a_EQ102  ;
xor2_1576: a_EQ102 <=  n_1809  XOR n_1817;
or3_1577: n_1809 <=  n_1810  OR n_1812  OR n_1815;
and1_1578: n_1810 <=  n_1811;
delay_1579: n_1811  <= TRANSPORT a_LC5_A13_aNOT  ;
and2_1580: n_1812 <=  n_1813  AND n_1814;
inv_1581: n_1813  <= TRANSPORT NOT a_STRQ_F0_G  ;
delay_1582: n_1814  <= TRANSPORT a_N67_aNOT  ;
and1_1583: n_1815 <=  n_1816;
inv_1584: n_1816  <= TRANSPORT NOT a_N396  ;
and1_1585: n_1817 <=  gnd;
delay_1586: a_LC4_A1_aNOT  <= TRANSPORT a_EQ103  ;
xor2_1587: a_EQ103 <=  n_1820  XOR n_1827;
or2_1588: n_1820 <=  n_1821  OR n_1824;
and2_1589: n_1821 <=  n_1822  AND n_1823;
delay_1590: n_1822  <= TRANSPORT a_LC3_A1  ;
delay_1591: n_1823  <= TRANSPORT a_LC5_A1_aNOT  ;
and2_1592: n_1824 <=  n_1825  AND n_1826;
delay_1593: n_1825  <= TRANSPORT a_LC6_A1_aNOT  ;
delay_1594: n_1826  <= TRANSPORT a_LC7_A1_aNOT  ;
and1_1595: n_1827 <=  gnd;
delay_1596: a_LC1_A10  <= TRANSPORT a_EQ076  ;
xor2_1597: a_EQ076 <=  n_1830  XOR n_1839;
or2_1598: n_1830 <=  n_1831  OR n_1835;
and3_1599: n_1831 <=  n_1832  AND n_1833  AND n_1834;
inv_1600: n_1832  <= TRANSPORT NOT a_N395  ;
inv_1601: n_1833  <= TRANSPORT NOT a_N396  ;
inv_1602: n_1834  <= TRANSPORT NOT a_N393  ;
and3_1603: n_1835 <=  n_1836  AND n_1837  AND n_1838;
inv_1604: n_1836  <= TRANSPORT NOT a_STRQ_F1_G  ;
inv_1605: n_1837  <= TRANSPORT NOT a_N395  ;
inv_1606: n_1838  <= TRANSPORT NOT a_N393  ;
and1_1607: n_1839 <=  gnd;
delay_1608: a_N253_aNOT  <= TRANSPORT a_EQ072  ;
xor2_1609: a_EQ072 <=  n_1842  XOR n_1851;
or2_1610: n_1842 <=  n_1843  OR n_1847;
and3_1611: n_1843 <=  n_1844  AND n_1845  AND n_1846;
inv_1612: n_1844  <= TRANSPORT NOT a_STRQ_F4_G  ;
delay_1613: n_1845  <= TRANSPORT a_N38  ;
inv_1614: n_1846  <= TRANSPORT NOT a_N397  ;
and3_1615: n_1847 <=  n_1848  AND n_1849  AND n_1850;
inv_1616: n_1848  <= TRANSPORT NOT a_STRQ_F5_G  ;
delay_1617: n_1849  <= TRANSPORT a_N38  ;
delay_1618: n_1850  <= TRANSPORT a_N397  ;
and1_1619: n_1851 <=  gnd;
delay_1620: a_LC7_A10  <= TRANSPORT a_EQ104  ;
xor2_1621: a_EQ104 <=  n_1854  XOR n_1863;
or3_1622: n_1854 <=  n_1855  OR n_1858  OR n_1861;
and2_1623: n_1855 <=  n_1856  AND n_1857;
inv_1624: n_1856  <= TRANSPORT NOT a_N397  ;
delay_1625: n_1857  <= TRANSPORT a_LC4_A1_aNOT  ;
and2_1626: n_1858 <=  n_1859  AND n_1860;
delay_1627: n_1859  <= TRANSPORT a_N397  ;
delay_1628: n_1860  <= TRANSPORT a_LC1_A10  ;
and1_1629: n_1861 <=  n_1862;
delay_1630: n_1862  <= TRANSPORT a_N253_aNOT  ;
and1_1631: n_1863 <=  gnd;
dff_1632: DFF_a6402

    PORT MAP ( D => a_EQ148, CLK => a_STRO_aNOT_aCLK, CLRN => a_STRO_aNOT_aCLRN,
          PRN => vcc, Q => a_STRO_aNOT);
inv_1633: a_STRO_aNOT_aCLRN  <= TRANSPORT NOT mr  ;
xor2_1634: a_EQ148 <=  n_1870  XOR n_1875;
or2_1635: n_1870 <=  n_1871  OR n_1873;
and1_1636: n_1871 <=  n_1872;
delay_1637: n_1872  <= TRANSPORT a_LC6_A10  ;
and1_1638: n_1873 <=  n_1874;
delay_1639: n_1874  <= TRANSPORT a_LC7_A10  ;
and1_1640: n_1875 <=  gnd;
delay_1641: n_1876  <= TRANSPORT trc  ;
filter_1642: FILTER_a6402

    PORT MAP (IN1 => n_1876, Y => a_STRO_aNOT_aCLK);
dff_1643: DFF_a6402

    PORT MAP ( D => a_EQ142, CLK => a_STR_F2_G_aCLK, CLRN => a_STR_F2_G_aCLRN,
          PRN => vcc, Q => a_STR_F2_G);
inv_1644: a_STR_F2_G_aCLRN  <= TRANSPORT NOT mr  ;
xor2_1645: a_EQ142 <=  n_1886  XOR n_1893;
or2_1646: n_1886 <=  n_1887  OR n_1890;
and2_1647: n_1887 <=  n_1888  AND n_1889;
delay_1648: n_1888  <= TRANSPORT a_STR_F2_G  ;
delay_1649: n_1889  <= TRANSPORT ntbrl  ;
and2_1650: n_1890 <=  n_1891  AND n_1892;
delay_1651: n_1891  <= TRANSPORT tbr(2)  ;
inv_1652: n_1892  <= TRANSPORT NOT ntbrl  ;
and1_1653: n_1893 <=  gnd;
delay_1654: n_1894  <= TRANSPORT trc  ;
filter_1655: FILTER_a6402

    PORT MAP (IN1 => n_1894, Y => a_STR_F2_G_aCLK);
dff_1656: DFF_a6402

    PORT MAP ( D => a_EQ140, CLK => a_STR_F0_G_aCLK, CLRN => a_STR_F0_G_aCLRN,
          PRN => vcc, Q => a_STR_F0_G);
inv_1657: a_STR_F0_G_aCLRN  <= TRANSPORT NOT mr  ;
xor2_1658: a_EQ140 <=  n_1904  XOR n_1911;
or2_1659: n_1904 <=  n_1905  OR n_1908;
and2_1660: n_1905 <=  n_1906  AND n_1907;
delay_1661: n_1906  <= TRANSPORT a_STR_F0_G  ;
delay_1662: n_1907  <= TRANSPORT ntbrl  ;
and2_1663: n_1908 <=  n_1909  AND n_1910;
delay_1664: n_1909  <= TRANSPORT tbr(0)  ;
inv_1665: n_1910  <= TRANSPORT NOT ntbrl  ;
and1_1666: n_1911 <=  gnd;
delay_1667: n_1912  <= TRANSPORT trc  ;
filter_1668: FILTER_a6402

    PORT MAP (IN1 => n_1912, Y => a_STR_F0_G_aCLK);
delay_1669: a_N34_aNOT  <= TRANSPORT a_EQ010  ;
xor2_1670: a_EQ010 <=  n_1915  XOR n_1920;
or2_1671: n_1915 <=  n_1916  OR n_1918;
and1_1672: n_1916 <=  n_1917;
inv_1673: n_1917  <= TRANSPORT NOT a_N439  ;
and1_1674: n_1918 <=  n_1919;
delay_1675: n_1919  <= TRANSPORT a_N438  ;
and1_1676: n_1920 <=  gnd;
dff_1677: DFF_a6402

    PORT MAP ( D => a_EQ113, CLK => a_N450_aCLK, CLRN => a_N450_aCLRN, PRN => vcc,
          Q => a_N450);
inv_1678: a_N450_aCLRN  <= TRANSPORT NOT mr  ;
xor2_1679: a_EQ113 <=  n_1928  XOR n_1938;
or2_1680: n_1928 <=  n_1929  OR n_1934;
and3_1681: n_1929 <=  n_1930  AND n_1931  AND n_1932;
delay_1682: n_1930  <= TRANSPORT a_N34_aNOT  ;
inv_1683: n_1931  <= TRANSPORT NOT a_N450  ;
delay_1684: n_1932  <= TRANSPORT a_N451  ;
and3_1685: n_1934 <=  n_1935  AND n_1936  AND n_1937;
delay_1686: n_1935  <= TRANSPORT a_N34_aNOT  ;
delay_1687: n_1936  <= TRANSPORT a_N450  ;
inv_1688: n_1937  <= TRANSPORT NOT a_N451  ;
and1_1689: n_1938 <=  gnd;
delay_1690: n_1939  <= TRANSPORT trc  ;
filter_1691: FILTER_a6402

    PORT MAP (IN1 => n_1939, Y => a_N450_aCLK);
dff_1692: DFF_a6402

    PORT MAP ( D => a_N451_aD, CLK => a_N451_aCLK, CLRN => a_N451_aCLRN, PRN => vcc,
          Q => a_N451);
inv_1693: a_N451_aCLRN  <= TRANSPORT NOT mr  ;
xor2_1694: a_N451_aD <=  n_1947  XOR n_1951;
or1_1695: n_1947 <=  n_1948;
and2_1696: n_1948 <=  n_1949  AND n_1950;
delay_1697: n_1949  <= TRANSPORT a_N34_aNOT  ;
inv_1698: n_1950  <= TRANSPORT NOT a_N451  ;
and1_1699: n_1951 <=  gnd;
delay_1700: n_1952  <= TRANSPORT trc  ;
filter_1701: FILTER_a6402

    PORT MAP (IN1 => n_1952, Y => a_N451_aCLK);
dff_1702: DFF_a6402

    PORT MAP ( D => a_EQ112, CLK => a_N449_aCLK, CLRN => a_N449_aCLRN, PRN => vcc,
          Q => a_N449);
inv_1703: a_N449_aCLRN  <= TRANSPORT NOT mr  ;
xor2_1704: a_EQ112 <=  n_1961  XOR n_1975;
or3_1705: n_1961 <=  n_1962  OR n_1966  OR n_1970;
and3_1706: n_1962 <=  n_1963  AND n_1964  AND n_1965;
delay_1707: n_1963  <= TRANSPORT a_N34_aNOT  ;
inv_1708: n_1964  <= TRANSPORT NOT a_N451  ;
delay_1709: n_1965  <= TRANSPORT a_N449  ;
and3_1710: n_1966 <=  n_1967  AND n_1968  AND n_1969;
delay_1711: n_1967  <= TRANSPORT a_N34_aNOT  ;
inv_1712: n_1968  <= TRANSPORT NOT a_N450  ;
delay_1713: n_1969  <= TRANSPORT a_N449  ;
and4_1714: n_1970 <=  n_1971  AND n_1972  AND n_1973  AND n_1974;
delay_1715: n_1971  <= TRANSPORT a_N34_aNOT  ;
delay_1716: n_1972  <= TRANSPORT a_N450  ;
delay_1717: n_1973  <= TRANSPORT a_N451  ;
inv_1718: n_1974  <= TRANSPORT NOT a_N449  ;
and1_1719: n_1975 <=  gnd;
delay_1720: n_1976  <= TRANSPORT trc  ;
filter_1721: FILTER_a6402

    PORT MAP (IN1 => n_1976, Y => a_N449_aCLK);
dff_1722: DFF_a6402

    PORT MAP ( D => a_EQ146, CLK => a_STR_F6_G_aCLK, CLRN => a_STR_F6_G_aCLRN,
          PRN => vcc, Q => a_STR_F6_G);
inv_1723: a_STR_F6_G_aCLRN  <= TRANSPORT NOT mr  ;
xor2_1724: a_EQ146 <=  n_1986  XOR n_1993;
or2_1725: n_1986 <=  n_1987  OR n_1990;
and2_1726: n_1987 <=  n_1988  AND n_1989;
delay_1727: n_1988  <= TRANSPORT a_STR_F6_G  ;
delay_1728: n_1989  <= TRANSPORT ntbrl  ;
and2_1729: n_1990 <=  n_1991  AND n_1992;
delay_1730: n_1991  <= TRANSPORT tbr(6)  ;
inv_1731: n_1992  <= TRANSPORT NOT ntbrl  ;
and1_1732: n_1993 <=  gnd;
delay_1733: n_1994  <= TRANSPORT trc  ;
filter_1734: FILTER_a6402

    PORT MAP (IN1 => n_1994, Y => a_STR_F6_G_aCLK);
dff_1735: DFF_a6402

    PORT MAP ( D => a_EQ147, CLK => a_STR_F7_G_aCLK, CLRN => a_STR_F7_G_aCLRN,
          PRN => vcc, Q => a_STR_F7_G);
inv_1736: a_STR_F7_G_aCLRN  <= TRANSPORT NOT mr  ;
xor2_1737: a_EQ147 <=  n_2004  XOR n_2011;
or2_1738: n_2004 <=  n_2005  OR n_2008;
and2_1739: n_2005 <=  n_2006  AND n_2007;
delay_1740: n_2006  <= TRANSPORT a_STR_F7_G  ;
delay_1741: n_2007  <= TRANSPORT ntbrl  ;
and2_1742: n_2008 <=  n_2009  AND n_2010;
delay_1743: n_2009  <= TRANSPORT tbr(7)  ;
inv_1744: n_2010  <= TRANSPORT NOT ntbrl  ;
and1_1745: n_2011 <=  gnd;
delay_1746: n_2012  <= TRANSPORT trc  ;
filter_1747: FILTER_a6402

    PORT MAP (IN1 => n_2012, Y => a_STR_F7_G_aCLK);
dff_1748: DFF_a6402

    PORT MAP ( D => a_EQ143, CLK => a_STR_F3_G_aCLK, CLRN => a_STR_F3_G_aCLRN,
          PRN => vcc, Q => a_STR_F3_G);
inv_1749: a_STR_F3_G_aCLRN  <= TRANSPORT NOT mr  ;
xor2_1750: a_EQ143 <=  n_2022  XOR n_2029;
or2_1751: n_2022 <=  n_2023  OR n_2026;
and2_1752: n_2023 <=  n_2024  AND n_2025;
delay_1753: n_2024  <= TRANSPORT a_STR_F3_G  ;
delay_1754: n_2025  <= TRANSPORT ntbrl  ;
and2_1755: n_2026 <=  n_2027  AND n_2028;
delay_1756: n_2027  <= TRANSPORT tbr(3)  ;
inv_1757: n_2028  <= TRANSPORT NOT ntbrl  ;
and1_1758: n_2029 <=  gnd;
delay_1759: n_2030  <= TRANSPORT trc  ;
filter_1760: FILTER_a6402

    PORT MAP (IN1 => n_2030, Y => a_STR_F3_G_aCLK);
dff_1761: DFF_a6402

    PORT MAP ( D => a_EQ151, CLK => a_STRQ_F2_G_aCLK, CLRN => a_STRQ_F2_G_aCLRN,
          PRN => vcc, Q => a_STRQ_F2_G);
inv_1762: a_STRQ_F2_G_aCLRN  <= TRANSPORT NOT mr  ;
xor2_1763: a_EQ151 <=  n_2038  XOR n_2045;
or2_1764: n_2038 <=  n_2039  OR n_2042;
and2_1765: n_2039 <=  n_2040  AND n_2041;
delay_1766: n_2040  <= TRANSPORT a_STR_F2_G  ;
inv_1767: n_2041  <= TRANSPORT NOT a_N34_aNOT  ;
and2_1768: n_2042 <=  n_2043  AND n_2044;
delay_1769: n_2043  <= TRANSPORT a_N34_aNOT  ;
delay_1770: n_2044  <= TRANSPORT a_STRQ_F2_G  ;
and1_1771: n_2045 <=  gnd;
delay_1772: n_2046  <= TRANSPORT trc  ;
filter_1773: FILTER_a6402

    PORT MAP (IN1 => n_2046, Y => a_STRQ_F2_G_aCLK);
dff_1774: DFF_a6402

    PORT MAP ( D => a_EQ149, CLK => a_STRQ_F0_G_aCLK, CLRN => a_STRQ_F0_G_aCLRN,
          PRN => vcc, Q => a_STRQ_F0_G);
inv_1775: a_STRQ_F0_G_aCLRN  <= TRANSPORT NOT mr  ;
xor2_1776: a_EQ149 <=  n_2054  XOR n_2061;
or2_1777: n_2054 <=  n_2055  OR n_2058;
and2_1778: n_2055 <=  n_2056  AND n_2057;
delay_1779: n_2056  <= TRANSPORT a_STR_F0_G  ;
inv_1780: n_2057  <= TRANSPORT NOT a_N34_aNOT  ;
and2_1781: n_2058 <=  n_2059  AND n_2060;
delay_1782: n_2059  <= TRANSPORT a_N34_aNOT  ;
delay_1783: n_2060  <= TRANSPORT a_STRQ_F0_G  ;
and1_1784: n_2061 <=  gnd;
delay_1785: n_2062  <= TRANSPORT trc  ;
filter_1786: FILTER_a6402

    PORT MAP (IN1 => n_2062, Y => a_STRQ_F0_G_aCLK);
dff_1787: DFF_a6402

    PORT MAP ( D => a_EQ141, CLK => a_STR_F1_G_aCLK, CLRN => a_STR_F1_G_aCLRN,
          PRN => vcc, Q => a_STR_F1_G);
inv_1788: a_STR_F1_G_aCLRN  <= TRANSPORT NOT mr  ;
xor2_1789: a_EQ141 <=  n_2072  XOR n_2079;
or2_1790: n_2072 <=  n_2073  OR n_2076;
and2_1791: n_2073 <=  n_2074  AND n_2075;
delay_1792: n_2074  <= TRANSPORT a_STR_F1_G  ;
delay_1793: n_2075  <= TRANSPORT ntbrl  ;
and2_1794: n_2076 <=  n_2077  AND n_2078;
delay_1795: n_2077  <= TRANSPORT tbr(1)  ;
inv_1796: n_2078  <= TRANSPORT NOT ntbrl  ;
and1_1797: n_2079 <=  gnd;
delay_1798: n_2080  <= TRANSPORT trc  ;
filter_1799: FILTER_a6402

    PORT MAP (IN1 => n_2080, Y => a_STR_F1_G_aCLK);
delay_1800: a_N78  <= TRANSPORT a_N78_aIN  ;
xor2_1801: a_N78_aIN <=  n_2084  XOR n_2089;
or1_1802: n_2084 <=  n_2085;
and3_1803: n_2085 <=  n_2086  AND n_2087  AND n_2088;
delay_1804: n_2086  <= TRANSPORT a_N450  ;
delay_1805: n_2087  <= TRANSPORT a_N451  ;
delay_1806: n_2088  <= TRANSPORT a_N449  ;
and1_1807: n_2089 <=  gnd;
dff_1808: DFF_a6402

    PORT MAP ( D => a_EQ111, CLK => a_N448_aCLK, CLRN => a_N448_aCLRN, PRN => vcc,
          Q => a_N448);
inv_1809: a_N448_aCLRN  <= TRANSPORT NOT mr  ;
xor2_1810: a_EQ111 <=  n_2097  XOR n_2106;
or2_1811: n_2097 <=  n_2098  OR n_2102;
and3_1812: n_2098 <=  n_2099  AND n_2100  AND n_2101;
delay_1813: n_2099  <= TRANSPORT a_N34_aNOT  ;
inv_1814: n_2100  <= TRANSPORT NOT a_N78  ;
delay_1815: n_2101  <= TRANSPORT a_N448  ;
and3_1816: n_2102 <=  n_2103  AND n_2104  AND n_2105;
delay_1817: n_2103  <= TRANSPORT a_N34_aNOT  ;
delay_1818: n_2104  <= TRANSPORT a_N78  ;
inv_1819: n_2105  <= TRANSPORT NOT a_N448  ;
and1_1820: n_2106 <=  gnd;
delay_1821: n_2107  <= TRANSPORT trc  ;
filter_1822: FILTER_a6402

    PORT MAP (IN1 => n_2107, Y => a_N448_aCLK);
dff_1823: DFF_a6402

    PORT MAP ( D => a_EQ144, CLK => a_STR_F4_G_aCLK, CLRN => a_STR_F4_G_aCLRN,
          PRN => vcc, Q => a_STR_F4_G);
inv_1824: a_STR_F4_G_aCLRN  <= TRANSPORT NOT mr  ;
xor2_1825: a_EQ144 <=  n_2117  XOR n_2124;
or2_1826: n_2117 <=  n_2118  OR n_2121;
and2_1827: n_2118 <=  n_2119  AND n_2120;
delay_1828: n_2119  <= TRANSPORT a_STR_F4_G  ;
delay_1829: n_2120  <= TRANSPORT ntbrl  ;
and2_1830: n_2121 <=  n_2122  AND n_2123;
delay_1831: n_2122  <= TRANSPORT tbr(4)  ;
inv_1832: n_2123  <= TRANSPORT NOT ntbrl  ;
and1_1833: n_2124 <=  gnd;
delay_1834: n_2125  <= TRANSPORT trc  ;
filter_1835: FILTER_a6402

    PORT MAP (IN1 => n_2125, Y => a_STR_F4_G_aCLK);
dff_1836: DFF_a6402

    PORT MAP ( D => a_EQ145, CLK => a_STR_F5_G_aCLK, CLRN => a_STR_F5_G_aCLRN,
          PRN => vcc, Q => a_STR_F5_G);
inv_1837: a_STR_F5_G_aCLRN  <= TRANSPORT NOT mr  ;
xor2_1838: a_EQ145 <=  n_2135  XOR n_2142;
or2_1839: n_2135 <=  n_2136  OR n_2139;
and2_1840: n_2136 <=  n_2137  AND n_2138;
delay_1841: n_2137  <= TRANSPORT a_STR_F5_G  ;
delay_1842: n_2138  <= TRANSPORT ntbrl  ;
and2_1843: n_2139 <=  n_2140  AND n_2141;
delay_1844: n_2140  <= TRANSPORT tbr(5)  ;
inv_1845: n_2141  <= TRANSPORT NOT ntbrl  ;
and1_1846: n_2142 <=  gnd;
delay_1847: n_2143  <= TRANSPORT trc  ;
filter_1848: FILTER_a6402

    PORT MAP (IN1 => n_2143, Y => a_STR_F5_G_aCLK);
dff_1849: DFF_a6402

    PORT MAP ( D => a_EQ155, CLK => a_STRQ_F6_G_aCLK, CLRN => a_STRQ_F6_G_aCLRN,
          PRN => vcc, Q => a_STRQ_F6_G);
inv_1850: a_STRQ_F6_G_aCLRN  <= TRANSPORT NOT mr  ;
xor2_1851: a_EQ155 <=  n_2151  XOR n_2158;
or2_1852: n_2151 <=  n_2152  OR n_2155;
and2_1853: n_2152 <=  n_2153  AND n_2154;
inv_1854: n_2153  <= TRANSPORT NOT a_N34_aNOT  ;
delay_1855: n_2154  <= TRANSPORT a_STR_F6_G  ;
and2_1856: n_2155 <=  n_2156  AND n_2157;
delay_1857: n_2156  <= TRANSPORT a_N34_aNOT  ;
delay_1858: n_2157  <= TRANSPORT a_STRQ_F6_G  ;
and1_1859: n_2158 <=  gnd;
delay_1860: n_2159  <= TRANSPORT trc  ;
filter_1861: FILTER_a6402

    PORT MAP (IN1 => n_2159, Y => a_STRQ_F6_G_aCLK);
dff_1862: DFF_a6402

    PORT MAP ( D => a_EQ156, CLK => a_STRQ_F7_G_aCLK, CLRN => a_STRQ_F7_G_aCLRN,
          PRN => vcc, Q => a_STRQ_F7_G);
inv_1863: a_STRQ_F7_G_aCLRN  <= TRANSPORT NOT mr  ;
xor2_1864: a_EQ156 <=  n_2167  XOR n_2174;
or2_1865: n_2167 <=  n_2168  OR n_2171;
and2_1866: n_2168 <=  n_2169  AND n_2170;
delay_1867: n_2169  <= TRANSPORT a_N34_aNOT  ;
delay_1868: n_2170  <= TRANSPORT a_STRQ_F7_G  ;
and2_1869: n_2171 <=  n_2172  AND n_2173;
inv_1870: n_2172  <= TRANSPORT NOT a_N34_aNOT  ;
delay_1871: n_2173  <= TRANSPORT a_STR_F7_G  ;
and1_1872: n_2174 <=  gnd;
delay_1873: n_2175  <= TRANSPORT trc  ;
filter_1874: FILTER_a6402

    PORT MAP (IN1 => n_2175, Y => a_STRQ_F7_G_aCLK);
dff_1875: DFF_a6402

    PORT MAP ( D => a_EQ152, CLK => a_STRQ_F3_G_aCLK, CLRN => a_STRQ_F3_G_aCLRN,
          PRN => vcc, Q => a_STRQ_F3_G);
inv_1876: a_STRQ_F3_G_aCLRN  <= TRANSPORT NOT mr  ;
xor2_1877: a_EQ152 <=  n_2183  XOR n_2190;
or2_1878: n_2183 <=  n_2184  OR n_2187;
and2_1879: n_2184 <=  n_2185  AND n_2186;
inv_1880: n_2185  <= TRANSPORT NOT a_N34_aNOT  ;
delay_1881: n_2186  <= TRANSPORT a_STR_F3_G  ;
and2_1882: n_2187 <=  n_2188  AND n_2189;
delay_1883: n_2188  <= TRANSPORT a_N34_aNOT  ;
delay_1884: n_2189  <= TRANSPORT a_STRQ_F3_G  ;
and1_1885: n_2190 <=  gnd;
delay_1886: n_2191  <= TRANSPORT trc  ;
filter_1887: FILTER_a6402

    PORT MAP (IN1 => n_2191, Y => a_STRQ_F3_G_aCLK);
dff_1888: DFF_a6402

    PORT MAP ( D => a_EQ150, CLK => a_STRQ_F1_G_aCLK, CLRN => a_STRQ_F1_G_aCLRN,
          PRN => vcc, Q => a_STRQ_F1_G);
inv_1889: a_STRQ_F1_G_aCLRN  <= TRANSPORT NOT mr  ;
xor2_1890: a_EQ150 <=  n_2199  XOR n_2206;
or2_1891: n_2199 <=  n_2200  OR n_2203;
and2_1892: n_2200 <=  n_2201  AND n_2202;
delay_1893: n_2201  <= TRANSPORT a_N34_aNOT  ;
delay_1894: n_2202  <= TRANSPORT a_STRQ_F1_G  ;
and2_1895: n_2203 <=  n_2204  AND n_2205;
inv_1896: n_2204  <= TRANSPORT NOT a_N34_aNOT  ;
delay_1897: n_2205  <= TRANSPORT a_STR_F1_G  ;
and1_1898: n_2206 <=  gnd;
delay_1899: n_2207  <= TRANSPORT trc  ;
filter_1900: FILTER_a6402

    PORT MAP (IN1 => n_2207, Y => a_STRQ_F1_G_aCLK);
dff_1901: DFF_a6402

    PORT MAP ( D => a_EQ153, CLK => a_STRQ_F4_G_aCLK, CLRN => a_STRQ_F4_G_aCLRN,
          PRN => vcc, Q => a_STRQ_F4_G);
inv_1902: a_STRQ_F4_G_aCLRN  <= TRANSPORT NOT mr  ;
xor2_1903: a_EQ153 <=  n_2215  XOR n_2222;
or2_1904: n_2215 <=  n_2216  OR n_2219;
and2_1905: n_2216 <=  n_2217  AND n_2218;
delay_1906: n_2217  <= TRANSPORT a_N34_aNOT  ;
delay_1907: n_2218  <= TRANSPORT a_STRQ_F4_G  ;
and2_1908: n_2219 <=  n_2220  AND n_2221;
inv_1909: n_2220  <= TRANSPORT NOT a_N34_aNOT  ;
delay_1910: n_2221  <= TRANSPORT a_STR_F4_G  ;
and1_1911: n_2222 <=  gnd;
delay_1912: n_2223  <= TRANSPORT trc  ;
filter_1913: FILTER_a6402

    PORT MAP (IN1 => n_2223, Y => a_STRQ_F4_G_aCLK);
dff_1914: DFF_a6402

    PORT MAP ( D => a_EQ154, CLK => a_STRQ_F5_G_aCLK, CLRN => a_STRQ_F5_G_aCLRN,
          PRN => vcc, Q => a_STRQ_F5_G);
inv_1915: a_STRQ_F5_G_aCLRN  <= TRANSPORT NOT mr  ;
xor2_1916: a_EQ154 <=  n_2231  XOR n_2238;
or2_1917: n_2231 <=  n_2232  OR n_2235;
and2_1918: n_2232 <=  n_2233  AND n_2234;
inv_1919: n_2233  <= TRANSPORT NOT a_N34_aNOT  ;
delay_1920: n_2234  <= TRANSPORT a_STR_F5_G  ;
and2_1921: n_2235 <=  n_2236  AND n_2237;
delay_1922: n_2236  <= TRANSPORT a_N34_aNOT  ;
delay_1923: n_2237  <= TRANSPORT a_STRQ_F5_G  ;
and1_1924: n_2238 <=  gnd;
delay_1925: n_2239  <= TRANSPORT trc  ;
filter_1926: FILTER_a6402

    PORT MAP (IN1 => n_2239, Y => a_STRQ_F5_G_aCLK);
delay_1927: a_N59_aNOT  <= TRANSPORT a_EQ021  ;
xor2_1928: a_EQ021 <=  n_2242  XOR n_2247;
or2_1929: n_2242 <=  n_2243  OR n_2245;
and1_1930: n_2243 <=  n_2244;
inv_1931: n_2244  <= TRANSPORT NOT a_N448  ;
and1_1932: n_2245 <=  n_2246;
inv_1933: n_2246  <= TRANSPORT NOT a_N78  ;
and1_1934: n_2247 <=  gnd;
delay_1935: a_N45_aNOT  <= TRANSPORT a_EQ013  ;
xor2_1936: a_EQ013 <=  n_2250  XOR n_2255;
or2_1937: n_2250 <=  n_2251  OR n_2253;
and1_1938: n_2251 <=  n_2252;
inv_1939: n_2252  <= TRANSPORT NOT a_N395  ;
and1_1940: n_2253 <=  n_2254;
delay_1941: n_2254  <= TRANSPORT a_N59_aNOT  ;
and1_1942: n_2255 <=  gnd;
delay_1943: a_N37  <= TRANSPORT a_EQ011  ;
xor2_1944: a_EQ011 <=  n_2257  XOR n_2262;
or2_1945: n_2257 <=  n_2258  OR n_2260;
and1_1946: n_2258 <=  n_2259;
delay_1947: n_2259  <= TRANSPORT a_SCNTLQ_F4_G  ;
and1_1948: n_2260 <=  n_2261;
delay_1949: n_2261  <= TRANSPORT a_SCNTLQ_F3_G  ;
and1_1950: n_2262 <=  gnd;
delay_1951: a_LC5_A5  <= TRANSPORT a_EQ085  ;
xor2_1952: a_EQ085 <=  n_2265  XOR n_2273;
or3_1953: n_2265 <=  n_2266  OR n_2268  OR n_2270;
and1_1954: n_2266 <=  n_2267;
delay_1955: n_2267  <= TRANSPORT a_N45_aNOT  ;
and1_1956: n_2268 <=  n_2269;
inv_1957: n_2269  <= TRANSPORT NOT a_N396  ;
and2_1958: n_2270 <=  n_2271  AND n_2272;
delay_1959: n_2271  <= TRANSPORT a_N37  ;
inv_1960: n_2272  <= TRANSPORT NOT a_N397  ;
and1_1961: n_2273 <=  gnd;
delay_1962: a_N194  <= TRANSPORT a_EQ059  ;
xor2_1963: a_EQ059 <=  n_2276  XOR n_2285;
or4_1964: n_2276 <=  n_2277  OR n_2279  OR n_2281  OR n_2283;
and1_1965: n_2277 <=  n_2278;
delay_1966: n_2278  <= TRANSPORT a_N395  ;
and1_1967: n_2279 <=  n_2280;
delay_1968: n_2280  <= TRANSPORT a_N393  ;
and1_1969: n_2281 <=  n_2282;
delay_1970: n_2282  <= TRANSPORT a_N396  ;
and1_1971: n_2283 <=  n_2284;
delay_1972: n_2284  <= TRANSPORT a_N397  ;
and1_1973: n_2285 <=  gnd;
delay_1974: a_LC1_A7  <= TRANSPORT a_EQ030  ;
xor2_1975: a_EQ030 <=  n_2288  XOR n_2298;
or3_1976: n_2288 <=  n_2289  OR n_2291  OR n_2294;
and1_1977: n_2289 <=  n_2290;
inv_1978: n_2290  <= TRANSPORT NOT a_N395  ;
and2_1979: n_2291 <=  n_2292  AND n_2293;
inv_1980: n_2292  <= TRANSPORT NOT a_N448  ;
delay_1981: n_2293  <= TRANSPORT a_N37  ;
and2_1982: n_2294 <=  n_2295  AND n_2296;
inv_1983: n_2295  <= TRANSPORT NOT a_N448  ;
inv_1984: n_2296  <= TRANSPORT NOT a_SCNTLQ_F0_G  ;
and1_1985: n_2298 <=  gnd;
delay_1986: a_N81  <= TRANSPORT a_EQ031  ;
xor2_1987: a_EQ031 <=  n_2301  XOR n_2310;
or4_1988: n_2301 <=  n_2302  OR n_2304  OR n_2306  OR n_2308;
and1_1989: n_2302 <=  n_2303;
delay_1990: n_2303  <= TRANSPORT a_LC1_A7  ;
and1_1991: n_2304 <=  n_2305;
delay_1992: n_2305  <= TRANSPORT a_N396  ;
and1_1993: n_2306 <=  n_2307;
delay_1994: n_2307  <= TRANSPORT a_N397  ;
and1_1995: n_2308 <=  n_2309;
inv_1996: n_2309  <= TRANSPORT NOT a_N78  ;
and1_1997: n_2310 <=  gnd;
delay_1998: a_N226  <= TRANSPORT a_N226_aIN  ;
xor2_1999: a_N226_aIN <=  n_2312  XOR n_2317;
or1_2000: n_2312 <=  n_2313;
and3_2001: n_2313 <=  n_2314  AND n_2315  AND n_2316;
inv_2002: n_2314  <= TRANSPORT NOT a_N59_aNOT  ;
delay_2003: n_2315  <= TRANSPORT a_N396  ;
delay_2004: n_2316  <= TRANSPORT a_N397  ;
and1_2005: n_2317 <=  gnd;
delay_2006: a_N29_aNOT  <= TRANSPORT a_EQ007  ;
xor2_2007: a_EQ007 <=  n_2320  XOR n_2330;
or3_2008: n_2320 <=  n_2321  OR n_2324  OR n_2327;
and2_2009: n_2321 <=  n_2322  AND n_2323;
delay_2010: n_2322  <= TRANSPORT a_N81  ;
delay_2011: n_2323  <= TRANSPORT a_N395  ;
and2_2012: n_2324 <=  n_2325  AND n_2326;
delay_2013: n_2325  <= TRANSPORT a_N81  ;
delay_2014: n_2326  <= TRANSPORT a_SCNTLQ_F0_G  ;
and2_2015: n_2327 <=  n_2328  AND n_2329;
delay_2016: n_2328  <= TRANSPORT a_N81  ;
inv_2017: n_2329  <= TRANSPORT NOT a_N226  ;
and1_2018: n_2330 <=  gnd;
delay_2019: a_N184_aNOT  <= TRANSPORT a_EQ057  ;
xor2_2020: a_EQ057 <=  n_2332  XOR n_2341;
or2_2021: n_2332 <=  n_2333  OR n_2337;
and3_2022: n_2333 <=  n_2334  AND n_2335  AND n_2336;
delay_2023: n_2334  <= TRANSPORT a_N194  ;
inv_2024: n_2335  <= TRANSPORT NOT a_N393  ;
inv_2025: n_2336  <= TRANSPORT NOT mr  ;
and3_2026: n_2337 <=  n_2338  AND n_2339  AND n_2340;
delay_2027: n_2338  <= TRANSPORT a_N194  ;
delay_2028: n_2339  <= TRANSPORT a_N29_aNOT  ;
inv_2029: n_2340  <= TRANSPORT NOT mr  ;
and1_2030: n_2341 <=  gnd;
dff_2031: DFF_a6402

    PORT MAP ( D => a_EQ106, CLK => a_N395_aCLK, CLRN => a_N395_aCLRN, PRN => vcc,
          Q => a_N395);
inv_2032: a_N395_aCLRN  <= TRANSPORT NOT mr  ;
xor2_2033: a_EQ106 <=  n_2348  XOR n_2357;
or2_2034: n_2348 <=  n_2349  OR n_2353;
and3_2035: n_2349 <=  n_2350  AND n_2351  AND n_2352;
delay_2036: n_2350  <= TRANSPORT a_LC5_A5  ;
delay_2037: n_2351  <= TRANSPORT a_N184_aNOT  ;
delay_2038: n_2352  <= TRANSPORT a_N395  ;
and3_2039: n_2353 <=  n_2354  AND n_2355  AND n_2356;
delay_2040: n_2354  <= TRANSPORT a_LC5_A5  ;
delay_2041: n_2355  <= TRANSPORT a_N226  ;
delay_2042: n_2356  <= TRANSPORT a_N184_aNOT  ;
and1_2043: n_2357 <=  gnd;
delay_2044: n_2358  <= TRANSPORT trc  ;
filter_2045: FILTER_a6402

    PORT MAP (IN1 => n_2358, Y => a_N395_aCLK);
dff_2046: DFF_a6402

    PORT MAP ( D => a_EQ115, CLK => a_SCNTLQ_F0_G_aCLK, CLRN => a_SCNTLQ_F0_G_aCLRN,
          PRN => vcc, Q => a_SCNTLQ_F0_G);
inv_2047: a_SCNTLQ_F0_G_aCLRN  <= TRANSPORT NOT mr  ;
xor2_2048: a_EQ115 <=  n_2367  XOR n_2374;
or2_2049: n_2367 <=  n_2368  OR n_2371;
and2_2050: n_2368 <=  n_2369  AND n_2370;
inv_2051: n_2369  <= TRANSPORT NOT crl  ;
delay_2052: n_2370  <= TRANSPORT a_SCNTLQ_F0_G  ;
and2_2053: n_2371 <=  n_2372  AND n_2373;
delay_2054: n_2372  <= TRANSPORT crl  ;
delay_2055: n_2373  <= TRANSPORT sbs  ;
and1_2056: n_2374 <=  gnd;
delay_2057: n_2375  <= TRANSPORT trc  ;
filter_2058: FILTER_a6402

    PORT MAP (IN1 => n_2375, Y => a_SCNTLQ_F0_G_aCLK);
dff_2059: DFF_a6402

    PORT MAP ( D => a_EQ116, CLK => a_SCNTLQ_F1_G_aCLK, CLRN => a_SCNTLQ_F1_G_aCLRN,
          PRN => vcc, Q => a_SCNTLQ_F1_G);
inv_2060: a_SCNTLQ_F1_G_aCLRN  <= TRANSPORT NOT mr  ;
xor2_2061: a_EQ116 <=  n_2384  XOR n_2391;
or2_2062: n_2384 <=  n_2385  OR n_2388;
and2_2063: n_2385 <=  n_2386  AND n_2387;
inv_2064: n_2386  <= TRANSPORT NOT crl  ;
delay_2065: n_2387  <= TRANSPORT a_SCNTLQ_F1_G  ;
and2_2066: n_2388 <=  n_2389  AND n_2390;
delay_2067: n_2389  <= TRANSPORT crl  ;
delay_2068: n_2390  <= TRANSPORT epe  ;
and1_2069: n_2391 <=  gnd;
delay_2070: n_2392  <= TRANSPORT trc  ;
filter_2071: FILTER_a6402

    PORT MAP (IN1 => n_2392, Y => a_SCNTLQ_F1_G_aCLK);
delay_2072: a_N65  <= TRANSPORT a_EQ024  ;
xor2_2073: a_EQ024 <=  n_2395  XOR n_2400;
or2_2074: n_2395 <=  n_2396  OR n_2398;
and1_2075: n_2396 <=  n_2397;
delay_2076: n_2397  <= TRANSPORT a_N106  ;
and1_2077: n_2398 <=  n_2399;
delay_2078: n_2399  <= TRANSPORT a_N105  ;
and1_2079: n_2400 <=  gnd;
delay_2080: a_N208  <= TRANSPORT a_EQ062  ;
xor2_2081: a_EQ062 <=  n_2403  XOR n_2408;
or2_2082: n_2403 <=  n_2404  OR n_2406;
and1_2083: n_2404 <=  n_2405;
delay_2084: n_2405  <= TRANSPORT a_N108  ;
and1_2085: n_2406 <=  n_2407;
delay_2086: n_2407  <= TRANSPORT a_N107  ;
and1_2087: n_2408 <=  gnd;
dff_2088: DFF_a6402

    PORT MAP ( D => a_N101_aD, CLK => a_N101_aCLK, CLRN => vcc, PRN => vcc,
          Q => a_N101);
xor2_2089: a_N101_aD <=  n_2415  XOR n_2418;
or1_2090: n_2415 <=  n_2416;
and1_2091: n_2416 <=  n_2417;
delay_2092: n_2417  <= TRANSPORT rri  ;
and1_2093: n_2418 <=  gnd;
delay_2094: n_2419  <= TRANSPORT rrc  ;
filter_2095: FILTER_a6402

    PORT MAP (IN1 => n_2419, Y => a_N101_aCLK);
dff_2096: DFF_a6402

    PORT MAP ( D => a_N99_aD, CLK => a_N99_aCLK, CLRN => vcc, PRN => vcc,
          Q => a_N99);
xor2_2097: a_N99_aD <=  n_2427  XOR n_2430;
or1_2098: n_2427 <=  n_2428;
and1_2099: n_2428 <=  n_2429;
delay_2100: n_2429  <= TRANSPORT a_N101  ;
and1_2101: n_2430 <=  gnd;
delay_2102: n_2431  <= TRANSPORT rrc  ;
filter_2103: FILTER_a6402

    PORT MAP (IN1 => n_2431, Y => a_N99_aCLK);
delay_2104: a_N32  <= TRANSPORT a_EQ009  ;
xor2_2105: a_EQ009 <=  n_2434  XOR n_2443;
or4_2106: n_2434 <=  n_2435  OR n_2437  OR n_2439  OR n_2441;
and1_2107: n_2435 <=  n_2436;
delay_2108: n_2436  <= TRANSPORT a_N65  ;
and1_2109: n_2437 <=  n_2438;
delay_2110: n_2438  <= TRANSPORT a_N208  ;
and1_2111: n_2439 <=  n_2440;
inv_2112: n_2440  <= TRANSPORT NOT a_N99  ;
and1_2113: n_2441 <=  n_2442;
delay_2114: n_2442  <= TRANSPORT a_N101  ;
and1_2115: n_2443 <=  gnd;
dff_2116: DFF_a6402

    PORT MAP ( D => a_N90_aD, CLK => a_N90_aCLK, CLRN => a_N90_aCLRN, PRN => vcc,
          Q => a_N90);
inv_2117: a_N90_aCLRN  <= TRANSPORT NOT mr  ;
xor2_2118: a_N90_aD <=  n_2450  XOR n_2464;
or3_2119: n_2450 <=  n_2451  OR n_2455  OR n_2459;
and3_2120: n_2451 <=  n_2452  AND n_2453  AND n_2454;
delay_2121: n_2452  <= TRANSPORT a_N32  ;
delay_2122: n_2453  <= TRANSPORT a_N90  ;
inv_2123: n_2454  <= TRANSPORT NOT a_N92  ;
and3_2124: n_2455 <=  n_2456  AND n_2457  AND n_2458;
delay_2125: n_2456  <= TRANSPORT a_N32  ;
delay_2126: n_2457  <= TRANSPORT a_N90  ;
inv_2127: n_2458  <= TRANSPORT NOT a_N91  ;
and4_2128: n_2459 <=  n_2460  AND n_2461  AND n_2462  AND n_2463;
delay_2129: n_2460  <= TRANSPORT a_N32  ;
inv_2130: n_2461  <= TRANSPORT NOT a_N90  ;
delay_2131: n_2462  <= TRANSPORT a_N91  ;
delay_2132: n_2463  <= TRANSPORT a_N92  ;
and1_2133: n_2464 <=  gnd;
delay_2134: n_2465  <= TRANSPORT rrc  ;
filter_2135: FILTER_a6402

    PORT MAP (IN1 => n_2465, Y => a_N90_aCLK);

END Version_1_0;
