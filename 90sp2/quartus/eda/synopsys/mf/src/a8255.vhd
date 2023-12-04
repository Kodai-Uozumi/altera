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

ENTITY TRIBUF_a8255 IS
    PORT (
        in1 : IN std_logic;
        oe  : IN std_logic;
        y   : OUT std_logic);
END TRIBUF_a8255;

ARCHITECTURE behavior OF TRIBUF_a8255 IS
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

ENTITY DFF_a8255 IS
    PORT (
      	 d   : IN std_logic;
      	 clk : IN std_logic;
      	 clrn: IN std_logic;
      	 prn : IN std_logic;
      	 q   : OUT std_logic := '0');
END DFF_a8255;

ARCHITECTURE behavior OF DFF_a8255 IS
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

ENTITY FILTER_a8255 IS
    PORT (
        in1 : IN std_logic;
        y: OUT std_logic);
END FILTER_a8255;

ARCHITECTURE behavior OF FILTER_a8255 IS
BEGIN

    y <= in1;
END behavior;

LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE work.tribuf_a8255;
USE work.dff_a8255;
USE work.filter_a8255;

ENTITY a8255 IS
    PORT (
      A : IN std_logic_vector(1 downto 0);
      DIN : IN std_logic_vector(7 downto 0);
      PAin : IN std_logic_vector(7 downto 0);
      PBin : IN std_logic_vector(7 downto 0);
      PCin : IN std_logic_vector(7 downto 0);
      DOUT : OUT std_logic_vector(7 downto 0);
      PAOUT : OUT std_logic_vector(7 downto 0);
      PBOUT : OUT std_logic_vector(7 downto 0);
      PCEN : OUT std_logic_vector(7 downto 0);
      PCOUT : OUT std_logic_vector(7 downto 0);
      CLK : IN std_logic;
      nCS : IN std_logic;
      nRD : IN std_logic;
      nWR : IN std_logic;
      RESET : IN std_logic;
      PAEN : OUT std_logic;
      PBEN : OUT std_logic);
END a8255;

ARCHITECTURE Version_1_0 OF a8255 IS

SIGNAL gnd : std_logic := '0';
SIGNAL vcc : std_logic := '1';
SIGNAL
    n_213, n_214, n_215, n_216, n_217, a_LC6_A8, n_219, n_220, n_221, n_222,
          n_223, n_224, a_LC8_A21, n_226, n_227, n_228, n_229, n_230, n_231,
          a_LC6_A2, n_233, n_234, n_235, n_236, n_237, n_238, a_LC8_A4, n_240,
          n_241, n_242, n_243, n_244, n_245, a_LC4_A1, n_247, n_248, n_249,
          n_250, n_251, n_252, a_LC1_B19, n_254, n_255, n_256, n_257, n_258,
          n_259, a_LC2_A1, n_261, n_262, n_263, n_264, n_265, n_266, a_LC6_B3,
          n_268, n_269, n_270, n_271, n_272, n_273, a_G119, n_275, n_276,
          n_277, n_278, n_279, n_280, a_LC2_A12, n_282, n_283, n_284, n_285,
          n_286, n_287, a_G107, n_289, n_290, n_291, n_292, n_293, n_294,
          a_G137, n_296, n_297, n_298, n_299, n_300, n_301, a_G98, n_303,
          n_304, n_305, n_306, n_307, n_308, a_G381, n_310, n_311, n_312,
          n_313, n_314, n_315, a_G99, n_317, n_318, n_319, n_320, n_321, n_322,
          a_G89, n_324, n_325, n_326, n_327, n_328, n_329, a_LC1_A3, n_331,
          n_332, n_333, n_334, n_335, n_336, a_LC4_B17, n_338, n_339, n_340,
          n_341, n_342, n_343, a_LC3_B6, n_345, n_346, n_347, n_348, n_349,
          n_350, a_LC1_A18, n_352, n_353, n_354, n_355, n_356, n_357, a_LC3_A13,
          n_359, n_360, n_361, n_362, n_363, n_364, a_LC2_B10, n_366, n_367,
          n_368, n_369, n_370, n_371, a_LC2_B9, n_373, n_374, n_375, n_376,
          n_377, n_378, a_LC3_B7, n_380, n_381, n_382, n_383, n_384, n_385,
          a_LC1_A13, n_387, n_388, n_389, n_390, n_391, n_392, a_LC2_B6, n_394,
          n_395, n_396, n_397, n_398, n_399, a_LC1_B6, n_401, n_402, n_403,
          n_404, n_405, n_406, a_LC1_B10, n_408, n_409, n_410, n_411, n_412,
          n_413, a_LC2_A13, n_415, n_416, n_417, n_418, n_419, n_420, a_LC1_B9,
          n_422, n_423, n_424, n_425, n_426, n_427, a_LC1_B11, n_429, n_430,
          n_431, n_432, n_433, n_434, a_LC6_A18, n_436, n_437, n_438, n_439,
          n_440, n_441, a_G135, n_443, n_444, n_445, n_446, n_447, n_448,
          a_G84, n_450, n_451, n_452, n_453, n_454, n_455, a_G153, n_457,
          n_458, n_459, n_460, n_461, n_462, a_G82, n_464, n_465, n_466, n_467,
          n_468, n_469, a_G233, n_471, n_472, n_473, n_474, n_475, n_476,
          a_G83, n_478, n_479, n_480, n_481, n_482, n_483, a_G227, n_485,
          n_486, n_487, n_488, n_489, n_490, a_G152, n_492, n_493, n_494,
          n_495, n_496, n_497, a_SCONTROLREG_F1_G_aNOT, n_499, n_500, n_501,
          n_502, n_503, n_504, a_SPAEN, n_506, a_LC4_A8, a_LC4_A8_aIN, n_509,
          n_510, n_511, n_513, a_N286, n_515, a_N62, n_517, n_518, a_LC4_A7,
          a_LC4_A7_aIN, n_521, n_522, n_523, n_525, n_527, n_529, a_LC2_A8,
          a_EQ116, n_532, n_533, n_534, n_535, a_SCONTROLREG_F2_G, n_537,
          n_538, n_539, n_540, n_541, n_542, a_LC5_A8, a_EQ137, n_545, n_546,
          n_547, a_LC7_A8, n_549, n_550, n_552, n_553, n_554, n_555, n_556,
          a_N16, a_EQ073, n_559, n_560, n_561, n_562, a_N270_aNOT, n_564,
          n_565, n_566, n_567, n_568, a_LC4_A5, a_LC4_A5_aIN, n_571, n_572,
          n_573, n_574, n_575, n_576, a_LC5_A5, a_EQ138, n_579, n_580, n_581,
          n_582, n_583, n_584, n_585, a_N42, n_587, n_588, a_N188_aNOT, a_EQ117,
          n_591, n_592, n_593, n_594, n_595, n_596, n_597, n_598, n_599, a_LC2_A5,
          a_EQ139, n_602, n_603, n_604, n_605, n_606, n_607, n_608, n_609,
          n_610, a_LC6_A8_aCLRN, a_EQ025, n_618, n_619, n_620, n_621, n_622,
          n_623, n_624, n_625, n_626, n_627, a_LC6_A8_aCLK, a_N156, a_EQ112,
          n_632, n_633, n_634, n_635, n_636, n_637, n_638, n_639, n_640, n_642,
          a_N24, a_N24_aIN, n_645, n_646, n_647, n_649, n_651, n_653, n_654,
          a_LC4_A21, a_EQ162, n_657, n_658, n_659, n_660, n_661, n_662, n_663,
          n_664, n_665, a_N46, n_667, n_668, a_N158, a_EQ114, n_671, n_672,
          n_673, n_674, n_675, n_677, n_678, a_N265_aNOT, a_EQ130, n_681,
          n_682, n_683, n_684, n_685, n_686, a_N348_aNOT, a_EQ141, n_689,
          n_690, n_691, n_692, n_693, n_694, n_695, n_696, a_N598, a_N598_aCLRN,
          a_N598_aD, n_704, n_705, n_706, n_707, n_708, a_N598_aCLK, a_N596,
          a_N596_aCLRN, a_EQ164, n_717, n_718, n_719, n_720, n_721, n_723,
          n_724, n_725, n_726, a_N596_aCLK, a_N142, a_EQ108, n_730, n_731,
          n_732, n_733, n_734, n_735, n_736, n_737, n_738, n_739, n_740, a_N157,
          a_EQ113, n_743, n_744, n_745, n_746, n_747, n_748, n_749, n_750,
          n_751, a_LC6_A21, a_EQ110, n_754, n_755, n_756, n_757, n_758, n_759,
          n_760, n_761, a_LC3_A21, a_EQ163, n_764, n_765, n_766, n_767, n_768,
          n_769, n_770, n_771, a_LC6_A6, a_EQ111, n_774, n_775, n_776, n_777,
          n_778, n_779, n_780, n_781, n_782, a_N56_aNOT, a_EQ100, n_785, n_786,
          n_787, n_788, n_789, n_790, n_791, n_792, n_793, n_794, a_LC5_A6,
          a_EQ109, n_797, n_798, n_799, n_800, n_801, n_802, n_803, n_804,
          n_805, n_806, a_LC1_A21, a_EQ107, n_809, n_810, n_811, n_812, n_813,
          n_814, n_815, n_816, a_LC1_A6, a_EQ161, n_819, n_820, n_821, n_822,
          n_823, n_824, n_825, n_826, a_LC8_A21_aCLRN, a_LC8_A21_aD, n_833,
          n_834, n_835, n_836, n_837, n_838, n_839, n_840, a_LC8_A21_aCLK,
          a_N240, a_EQ125, n_844, n_845, n_846, n_847, n_848, n_849, n_850,
          n_851, a_N229, a_N229_aIN, n_854, n_855, n_856, n_857, n_858, n_859,
          n_860, a_N26, a_EQ082, n_863, n_864, n_865, n_866, n_867, n_868,
          n_869, n_870, a_LC1_A2, a_EQ133, n_873, n_874, n_875, n_876, n_877,
          n_878, n_879, n_880, n_881, n_882, a_N230, a_N230_aIN, n_885, n_886,
          n_887, n_888, n_889, n_890, n_891, a_LC6_A2_aCLRN, a_EQ023, n_898,
          n_899, n_900, n_901, n_902, n_903, n_904, n_905, n_906, n_907, a_LC6_A2_aCLK,
          a_LC2_A4, a_EQ085, n_911, n_912, n_913, n_914, n_915, n_916, a_LC2_B8,
          a_EQ104, n_919, n_920, n_921, a_SCONTROLREG_F6_G, n_923, n_924,
          a_SCONTROLREG_F5_G, n_926, n_927, n_928, n_929, n_930, a_N43, a_N43_aIN,
          n_933, n_934, n_935, n_936, n_937, n_938, a_LC4_A4, a_EQ154, n_941,
          n_942, n_943, n_944, n_945, n_946, n_947, n_948, n_949, n_950, n_951,
          n_952, n_953, n_954, a_N595, a_N595_aCLRN, a_N595_aD, n_963, n_964,
          n_965, n_966, n_967, a_N595_aCLK, a_N13, a_N13_aIN, n_971, n_972,
          n_973, n_974, n_975, n_976, a_N594, a_N594_aCLRN, a_N594_aD, n_984,
          n_985, n_986, n_988, n_989, a_N594_aCLK, a_N18, a_N18_aIN, n_993,
          n_994, n_995, n_996, n_997, n_998, a_LC7_A9, a_EQ155, n_1001, n_1002,
          n_1003, n_1004, n_1005, n_1006, a_SCONTROLREG_F4_G_aNOT, n_1008,
          n_1009, n_1010, n_1011, n_1012, n_1013, n_1014, n_1015, a_N199_aNOT,
          a_EQ118, n_1018, n_1019, n_1020, n_1021, n_1022, n_1023, n_1024,
          n_1025, n_1026, a_N44_aNOT, a_EQ093, n_1029, n_1030, n_1031, n_1032,
          n_1033, n_1034, a_N37_aNOT, a_EQ088, n_1037, n_1038, n_1039, n_1040,
          n_1041, n_1042, n_1043, n_1044, a_N19_aNOT, a_EQ080, n_1047, n_1048,
          n_1049, n_1050, n_1051, n_1052, a_LC2_B17, a_EQ156, n_1055, n_1056,
          n_1057, n_1058, n_1059, n_1060, n_1061, n_1062, n_1063, n_1064,
          n_1065, n_1066, n_1067, n_1068, a_N67, a_N67_aIN, n_1071, n_1072,
          n_1073, n_1074, n_1075, n_1076, n_1077, a_LC6_A9, a_EQ157, n_1080,
          n_1081, n_1082, n_1083, n_1084, n_1085, n_1086, n_1087, n_1088,
          a_N45_aNOT, a_EQ094, n_1091, n_1092, n_1093, n_1094, n_1095, n_1096,
          a_N11, a_N11_aIN, n_1099, n_1100, n_1101, n_1102, n_1103, a_LC5_A9,
          a_EQ119, n_1106, n_1107, n_1108, n_1109, n_1110, n_1111, n_1112,
          a_LC2_A9, a_EQ158, n_1115, n_1116, n_1117, n_1118, n_1119, n_1120,
          n_1121, n_1122, n_1123, n_1124, n_1125, a_LC3_A4, a_EQ159, n_1128,
          n_1129, n_1130, n_1131, n_1132, n_1133, n_1134, n_1135, n_1136,
          n_1137, n_1138, n_1139, n_1140, n_1141, a_LC7_A20_aNOT, a_EQ106,
          n_1144, n_1145, n_1146, n_1147, n_1148, n_1149, portaread, a_EQ165,
          n_1152, n_1153, n_1154, n_1155, n_1156, n_1157, n_1158, n_1159,
          n_1160, n_1161, a_LC3_A9_aNOT, a_EQ075, n_1164, n_1165, n_1166,
          n_1167, n_1168, n_1169, a_N33, a_N33_aIN, n_1172, n_1173, n_1174,
          n_1175, n_1176, n_1177, n_1178, a_LC4_A9, a_EQ102, n_1181, n_1182,
          n_1183, n_1184, n_1185, n_1186, n_1187, n_1188, n_1189, n_1190,
          a_LC8_A20, a_EQ152, n_1193, n_1194, n_1195, n_1196, n_1197, n_1198,
          n_1199, n_1200, n_1201, n_1202, a_N17_aNOT, a_EQ074, n_1205, n_1206,
          n_1207, n_1208, n_1209, n_1210, a_LC6_A20, a_EQ153, n_1213, n_1214,
          n_1215, n_1216, n_1217, n_1218, n_1219, n_1220, n_1221, n_1222,
          n_1223, a_N12, a_N12_aIN, n_1226, n_1227, n_1228, n_1229, n_1230,
          a_N347_aNOT, a_EQ140, n_1233, n_1234, n_1235, n_1236, n_1237, n_1238,
          n_1239, n_1240, n_1241, n_1242, a_LC1_A4, a_EQ160, n_1245, n_1246,
          n_1247, n_1248, n_1249, n_1250, n_1251, n_1252, n_1253, n_1254,
          n_1255, a_LC8_A4_aCLRN, a_EQ022, n_1262, n_1263, n_1264, n_1265,
          n_1266, n_1267, n_1268, n_1269, n_1270, n_1271, n_1272, a_LC8_A4_aCLK,
          a_N54, a_EQ099, n_1276, n_1277, n_1278, n_1279, n_1280, n_1281,
          n_1282, a_N23_aNOT, a_N23_aNOT_aIN, n_1285, n_1286, n_1287, n_1288,
          n_1289, n_1290, n_1291, n_1292, n_1293, n_1294, a_N241, a_EQ126,
          n_1297, n_1298, n_1299, n_1300, n_1301, n_1302, n_1303, n_1304,
          a_LC6_A1, a_EQ151, n_1307, n_1308, n_1309, n_1310, n_1311, n_1312,
          n_1313, n_1314, n_1315, a_LC8_A1, a_LC8_A1_aIN, n_1318, n_1319,
          n_1320, n_1321, n_1322, n_1323, a_N232, a_N232_aIN, n_1326, n_1327,
          n_1328, n_1329, n_1330, n_1331, n_1332, a_LC4_A1_aCLRN, a_EQ021,
          n_1339, n_1340, n_1341, n_1342, n_1343, n_1344, n_1345, n_1347,
          n_1348, n_1349, a_LC4_A1_aCLK, a_N597, a_N597_aCLRN, a_N597_aD,
          n_1358, n_1359, n_1360, n_1361, n_1362, n_1363, n_1364, n_1365,
          n_1366, n_1367, n_1368, a_N597_aCLK, a_N21_aNOT, a_EQ079, n_1372,
          n_1373, n_1374, n_1375, n_1376, n_1377, n_1378, n_1379, a_LC1_A19,
          a_EQ129, n_1382, n_1383, n_1384, n_1385, n_1386, n_1387, n_1388,
          n_1389, n_1390, n_1391, a_LC4_A19, a_EQ127, n_1394, n_1395, n_1396,
          n_1397, n_1398, n_1399, n_1400, n_1401, n_1402, a_N39_aNOT, a_EQ090,
          n_1405, n_1406, n_1407, n_1408, n_1409, n_1410, n_1411, n_1412,
          n_1413, n_1414, a_LC7_B19, a_EQ148, n_1417, n_1418, n_1419, n_1420,
          n_1421, n_1422, n_1424, n_1425, n_1426, n_1427, n_1428, n_1429,
          n_1430, n_1431, a_LC2_B19, a_EQ128, n_1434, n_1435, n_1436, n_1437,
          n_1438, n_1439, n_1440, n_1441, n_1442, a_LC5_B19, a_EQ149, n_1445,
          n_1446, n_1447, n_1448, n_1449, n_1450, n_1451, n_1452, n_1453,
          n_1454, a_LC4_B19, a_EQ150, n_1457, n_1458, n_1459, n_1460, n_1461,
          n_1462, n_1463, n_1464, n_1465, n_1466, a_LC1_B19_aCLRN, a_EQ020,
          n_1473, n_1474, n_1475, n_1476, n_1477, n_1478, n_1479, n_1480,
          n_1481, n_1482, n_1483, a_LC1_B19_aCLK, a_LC1_A1, a_EQ147, n_1487,
          n_1488, n_1489, n_1491, n_1492, n_1493, n_1494, n_1495, a_LC5_A1,
          a_EQ124, n_1498, n_1499, n_1500, n_1501, n_1502, n_1503, n_1504,
          n_1505, n_1506, n_1507, n_1508, a_LC2_A1_aCLRN, a_EQ019, n_1515,
          n_1516, n_1517, n_1518, n_1519, n_1520, n_1521, n_1522, n_1523,
          n_1524, n_1525, a_LC2_A1_aCLK, a_LC8_B3, a_EQ142, n_1529, n_1530,
          n_1531, n_1532, n_1533, n_1534, n_1535, n_1536, n_1537, n_1538,
          n_1539, n_1540, n_1541, n_1542, a_LC6_B19, a_EQ143, n_1545, n_1546,
          n_1547, n_1548, n_1549, n_1550, n_1551, n_1552, n_1553, n_1554,
          n_1555, a_N38_aNOT, a_EQ089, n_1558, n_1559, n_1560, n_1561, n_1562,
          n_1563, a_LC4_B3, a_EQ144, n_1566, n_1567, n_1568, n_1569, n_1570,
          n_1571, n_1572, n_1573, n_1574, n_1575, n_1576, n_1577, n_1578,
          n_1579, a_LC5_B3, a_EQ105, n_1582, n_1583, n_1584, n_1585, n_1586,
          n_1587, n_1588, n_1589, n_1590, a_LC3_B3, a_EQ145, n_1593, n_1594,
          n_1595, n_1596, n_1597, n_1598, n_1599, n_1600, n_1601, n_1602,
          a_LC2_B3, a_EQ146, n_1605, n_1606, n_1607, n_1608, n_1609, n_1610,
          n_1611, n_1612, n_1613, n_1614, n_1615, n_1616, n_1617, n_1618,
          a_N599, a_N599_aCLRN, a_N599_aD, n_1626, n_1627, n_1628, n_1629,
          n_1630, a_N599_aCLK, a_LC6_B3_aCLRN, a_EQ018, n_1638, n_1639, n_1640,
          n_1641, n_1642, n_1643, n_1644, n_1645, n_1646, n_1647, n_1648,
          n_1649, a_LC6_B3_aCLK, a_LC1_A3_aCLRN, a_EQ017, n_1657, n_1658,
          n_1659, n_1660, n_1661, n_1662, n_1663, n_1664, n_1665, a_LC1_A3_aCLK,
          a_LC4_B17_aCLRN, a_EQ016, n_1673, n_1674, n_1675, n_1676, n_1677,
          n_1678, n_1679, n_1680, n_1681, a_LC4_B17_aCLK, a_LC3_B6_aCLRN,
          a_EQ015, n_1689, n_1690, n_1691, n_1692, n_1693, n_1694, n_1695,
          n_1696, n_1697, a_LC3_B6_aCLK, a_LC1_A18_aCLRN, a_EQ014, n_1705,
          n_1706, n_1707, n_1708, n_1709, n_1710, n_1711, n_1712, n_1713,
          a_LC1_A18_aCLK, a_LC3_A13_aCLRN, a_EQ013, n_1721, n_1722, n_1723,
          n_1724, n_1725, n_1726, n_1727, n_1728, n_1729, a_LC3_A13_aCLK,
          a_LC2_B10_aCLRN, a_EQ012, n_1737, n_1738, n_1739, n_1740, n_1741,
          n_1742, n_1743, n_1744, n_1745, a_LC2_B10_aCLK, a_LC2_B9_aCLRN,
          a_EQ011, n_1753, n_1754, n_1755, n_1756, n_1757, n_1758, n_1759,
          n_1760, n_1761, a_LC2_B9_aCLK, a_LC3_B7_aCLRN, a_EQ010, n_1769,
          n_1770, n_1771, n_1772, n_1773, n_1774, n_1775, n_1776, n_1777,
          a_LC3_B7_aCLK, a_LC1_A13_aCLRN, a_EQ009, n_1785, n_1786, n_1787,
          n_1788, n_1789, n_1790, n_1791, n_1792, n_1793, a_LC1_A13_aCLK,
          a_LC2_B6_aCLRN, a_EQ008, n_1801, n_1802, n_1803, n_1804, n_1805,
          n_1806, n_1807, n_1808, n_1809, a_LC2_B6_aCLK, a_LC1_B6_aCLRN, a_EQ007,
          n_1817, n_1818, n_1819, n_1820, n_1821, n_1822, n_1823, n_1824,
          n_1825, a_LC1_B6_aCLK, a_LC1_B10_aCLRN, a_EQ006, n_1833, n_1834,
          n_1835, n_1836, n_1837, n_1838, n_1839, n_1840, n_1841, a_LC1_B10_aCLK,
          a_LC2_A13_aCLRN, a_EQ005, n_1849, n_1850, n_1851, n_1852, n_1853,
          n_1854, n_1855, n_1856, n_1857, a_LC2_A13_aCLK, a_LC1_B9_aCLRN,
          a_EQ004, n_1865, n_1866, n_1867, n_1868, n_1869, n_1870, n_1871,
          n_1872, n_1873, a_LC1_B9_aCLK, a_LC1_B11_aCLRN, a_EQ003, n_1881,
          n_1882, n_1883, n_1884, n_1885, n_1886, n_1887, n_1888, n_1889,
          a_LC1_B11_aCLK, a_LC6_A18_aCLRN, a_EQ002, n_1897, n_1898, n_1899,
          n_1900, n_1901, n_1902, n_1903, n_1904, n_1905, a_LC6_A18_aCLK,
          a_SCONTROLREG_F1_G_aNOT_aCLRN, a_EQ167, n_1913, n_1914, n_1915,
          n_1916, n_1917, n_1918, n_1919, n_1920, n_1921, n_1922, n_1923,
          n_1924, n_1925, a_SCONTROLREG_F1_G_aNOT_aCLK, a_EQ042, n_1928, n_1929,
          n_1930, n_1931, n_1932, a_SCONTROLREG_F0_G_aNOT, n_1934, a_LC2_A12_aIN,
          n_1936, n_1937, n_1938, n_1939, n_1940, n_1941, a_G107_aIN, n_1943,
          n_1944, n_1945, n_1946, n_1947, a_EQ048, n_1949, n_1950, n_1951,
          n_1952, n_1953, n_1954, n_1955, n_1956, a_G98_aIN, n_1958, n_1959,
          n_1960, a_SCONTROLREG_F3_G_aNOT, n_1962, n_1963, a_EQ069, n_1965,
          n_1966, n_1967, n_1968, n_1969, n_1970, a_G99_aIN, n_1972, n_1973,
          n_1974, n_1975, n_1976, a_EQ038, n_1978, n_1979, n_1980, n_1981,
          n_1982, n_1983, a_N36, a_N36_aIN, n_1986, n_1987, n_1988, n_1989,
          n_1990, n_1991, n_1992, a_N20, a_EQ078, n_1995, n_1996, n_1997,
          n_1998, n_1999, n_2000, n_2001, n_2002, n_2003, n_2004, a_LC5_A14,
          a_EQ044, n_2007, n_2008, n_2009, n_2011, n_2012, n_2013, a_SPORTAINREG_F0_G,
          n_2015, n_2016, a_LC7_A14, a_EQ045, n_2019, n_2020, n_2021, a_SPORTBINREG_F0_G,
          n_2023, n_2024, n_2025, n_2027, n_2028, a_LC6_A14, a_EQ046, n_2031,
          n_2032, n_2033, n_2034, n_2035, n_2036, n_2037, n_2038, n_2039,
          n_2040, a_N48, a_N48_aIN, n_2044, n_2045, n_2046, n_2047, n_2048,
          a_EQ047, n_2050, n_2051, n_2052, n_2053, n_2054, n_2055, n_2056,
          n_2057, n_2058, a_LC2_B20, a_EQ035, n_2062, n_2063, n_2064, n_2065,
          n_2066, n_2067, n_2068, n_2069, n_2070, n_2071, a_N50, a_N50_aIN,
          n_2074, n_2075, n_2076, n_2077, n_2078, a_LC4_B20, a_EQ036, n_2081,
          n_2082, n_2083, n_2084, n_2085, a_SPORTBINREG_F1_G, n_2087, n_2088,
          a_LC3_B13, a_EQ034, n_2091, n_2092, n_2093, n_2095, n_2096, n_2097,
          a_SPORTAINREG_F1_G, n_2099, n_2100, a_N47, a_N47_aIN, n_2103, n_2104,
          n_2105, n_2106, n_2107, a_EQ037, n_2109, n_2110, n_2111, n_2112,
          n_2113, n_2114, n_2115, n_2117, n_2118, a_LC6_B2, a_EQ053, n_2121,
          n_2122, n_2123, a_SPORTAINREG_F2_G, n_2125, n_2126, n_2127, n_2128,
          n_2129, n_2130, n_2132, n_2133, n_2134, a_LC5_B2, a_EQ054, n_2137,
          n_2138, n_2139, n_2140, n_2141, n_2142, n_2143, n_2144, n_2145,
          a_LC4_B2, a_EQ055, n_2148, n_2149, n_2150, n_2151, n_2152, n_2153,
          a_SPORTBINREG_F2_G, n_2155, n_2156, n_2157, a_LC8_B2, a_EQ057, n_2160,
          n_2161, n_2162, n_2163, n_2164, n_2165, n_2166, a_LC7_B2, a_EQ056,
          n_2169, n_2170, n_2171, n_2172, n_2173, n_2174, n_2176, n_2177,
          n_2178, a_EQ058, n_2180, n_2181, n_2182, n_2183, n_2184, n_2185,
          n_2186, a_LC6_B16, a_EQ027, n_2190, n_2191, n_2192, n_2193, n_2194,
          n_2195, n_2196, n_2197, a_LC5_B16, a_EQ028, n_2200, n_2201, n_2202,
          n_2204, n_2205, n_2206, n_2207, n_2208, a_LC7_B16, a_EQ026, n_2211,
          n_2212, n_2213, n_2215, n_2216, n_2217, a_SPORTAINREG_F3_G, n_2219,
          n_2220, a_EQ029, n_2222, n_2223, n_2224, n_2225, n_2226, n_2227,
          n_2228, a_SPORTBINREG_F3_G, n_2230, n_2231, a_LC5_A20, a_EQ064,
          n_2234, n_2235, n_2236, n_2237, n_2238, n_2239, n_2240, n_2241,
          n_2242, a_LC4_A20, a_EQ065, n_2245, n_2246, n_2247, n_2248, n_2249,
          n_2250, n_2251, n_2252, n_2253, n_2254, a_LC1_B16, a_EQ067, n_2257,
          n_2258, n_2259, n_2261, n_2262, n_2263, a_SPORTBINREG_F4_G, n_2265,
          n_2266, a_LC1_A7, a_EQ066, n_2269, n_2270, n_2271, a_SPORTAINREG_F4_G,
          n_2273, n_2274, n_2275, n_2277, n_2278, a_EQ068, n_2280, n_2281,
          n_2282, n_2283, n_2284, n_2285, n_2286, n_2287, n_2288, a_LC2_B13,
          a_EQ030, n_2291, n_2292, n_2293, n_2295, n_2296, n_2297, a_SPORTAINREG_F5_G,
          n_2299, n_2300, a_LC6_B12, a_EQ031, n_2304, n_2305, n_2306, n_2307,
          n_2308, n_2309, n_2310, n_2311, n_2312, n_2313, a_LC5_B12, a_EQ032,
          n_2316, n_2317, n_2318, n_2319, n_2320, a_SPORTBINREG_F5_G, n_2322,
          n_2323, n_2324, a_EQ033, n_2326, n_2327, n_2328, n_2329, n_2330,
          n_2331, n_2332, n_2334, n_2335, a_LC3_B1, a_EQ061, n_2338, n_2339,
          n_2340, n_2342, n_2343, n_2344, a_SPORTBINREG_F6_G, n_2346, n_2347,
          a_LC5_B1, a_EQ059, n_2350, n_2351, n_2352, n_2353, n_2354, n_2355,
          n_2356, n_2357, n_2358, n_2359, n_2360, n_2361, a_LC4_B1, a_EQ060,
          n_2364, n_2365, n_2366, n_2367, n_2368, n_2369, n_2370, n_2371,
          a_LC2_B15, a_EQ062, n_2374, n_2375, n_2376, n_2378, n_2379, n_2380,
          a_SPORTAINREG_F6_G, n_2382, n_2383, a_EQ063, n_2385, n_2386, n_2387,
          n_2388, n_2389, n_2390, n_2391, n_2392, n_2393, a_LC1_B12, a_EQ050,
          n_2396, n_2397, n_2398, a_SPORTBINREG_F7_G, n_2400, n_2401, n_2402,
          n_2404, n_2405, a_LC6_B15, a_EQ049, n_2408, n_2409, n_2410, a_SPORTAINREG_F7_G,
          n_2412, n_2413, n_2414, n_2415, n_2416, n_2417, n_2419, n_2420,
          n_2421, a_LC5_B15, a_EQ051, n_2424, n_2425, n_2426, n_2427, n_2428,
          n_2429, n_2430, n_2431, a_EQ052, n_2434, n_2435, n_2436, n_2437,
          n_2438, n_2439, n_2440, n_2441, n_2442, n_2443, n_2444, a_EQ173,
          n_2446, n_2447, n_2448, n_2449, n_2450, n_2451, n_2452, n_2453,
          a_SPORTAINREG_F2_G_aCLRN, a_EQ176, n_2460, n_2461, n_2462, n_2463,
          n_2464, n_2465, n_2466, n_2467, n_2468, a_SPORTAINREG_F2_G_aCLK,
          a_SPORTBINREG_F0_G_aCLRN, a_EQ182, n_2476, n_2477, n_2478, n_2479,
          n_2480, n_2481, n_2482, n_2483, n_2484, a_SPORTBINREG_F0_G_aCLK,
          a_SPORTBINREG_F7_G_aCLRN, a_EQ189, n_2492, n_2493, n_2494, n_2495,
          n_2496, n_2497, n_2498, n_2499, n_2500, a_SPORTBINREG_F7_G_aCLK,
          a_SPORTAINREG_F7_G_aCLRN, a_EQ181, n_2508, n_2509, n_2510, n_2511,
          n_2512, n_2513, n_2514, n_2515, n_2516, a_SPORTAINREG_F7_G_aCLK,
          a_N42_aIN, n_2519, n_2520, n_2521, n_2522, n_2523, n_2524, a_N46_aIN,
          n_2526, n_2527, n_2528, n_2529, n_2530, a_SCONTROLREG_F5_G_aCLRN,
          a_EQ171, n_2537, n_2538, n_2539, n_2540, n_2541, n_2542, n_2543,
          n_2544, n_2545, n_2546, n_2547, n_2548, n_2549, a_SCONTROLREG_F5_G_aCLK,
          a_SPORTAINREG_F0_G_aCLRN, a_EQ174, n_2557, n_2558, n_2559, n_2560,
          n_2561, n_2562, n_2563, n_2564, n_2565, a_SPORTAINREG_F0_G_aCLK,
          a_SPORTBINREG_F1_G_aCLRN, a_EQ183, n_2573, n_2574, n_2575, n_2576,
          n_2577, n_2578, n_2579, n_2580, n_2581, a_SPORTBINREG_F1_G_aCLK,
          a_SPORTAINREG_F1_G_aCLRN, a_EQ175, n_2589, n_2590, n_2591, n_2592,
          n_2593, n_2594, n_2595, n_2596, n_2597, a_SPORTAINREG_F1_G_aCLK,
          a_SPORTBINREG_F2_G_aCLRN, a_EQ184, n_2605, n_2606, n_2607, n_2608,
          n_2609, n_2610, n_2611, n_2612, n_2613, a_SPORTBINREG_F2_G_aCLK,
          a_SPORTAINREG_F3_G_aCLRN, a_EQ177, n_2621, n_2622, n_2623, n_2624,
          n_2625, n_2626, n_2627, n_2628, n_2629, a_SPORTAINREG_F3_G_aCLK,
          a_SPORTBINREG_F4_G_aCLRN, a_EQ186, n_2637, n_2638, n_2639, n_2640,
          n_2641, n_2642, n_2643, n_2644, n_2645, a_SPORTBINREG_F4_G_aCLK,
          a_SPORTAINREG_F4_G_aCLRN, a_EQ178, n_2653, n_2654, n_2655, n_2656,
          n_2657, n_2658, n_2659, n_2660, n_2661, a_SPORTAINREG_F4_G_aCLK,
          a_SPORTAINREG_F5_G_aCLRN, a_EQ179, n_2669, n_2670, n_2671, n_2672,
          n_2673, n_2674, n_2675, n_2676, n_2677, a_SPORTAINREG_F5_G_aCLK,
          a_SPORTBINREG_F5_G_aCLRN, a_EQ187, n_2685, n_2686, n_2687, n_2688,
          n_2689, n_2690, n_2691, n_2692, n_2693, a_SPORTBINREG_F5_G_aCLK,
          a_SPORTBINREG_F6_G_aCLRN, a_EQ188, n_2701, n_2702, n_2703, n_2704,
          n_2705, n_2706, n_2707, n_2708, n_2709, a_SPORTBINREG_F6_G_aCLK,
          a_SPORTAINREG_F6_G_aCLRN, a_EQ180, n_2717, n_2718, n_2719, n_2720,
          n_2721, n_2722, n_2723, n_2724, n_2725, a_SPORTAINREG_F6_G_aCLK,
          a_SPORTBINREG_F3_G_aCLRN, a_EQ185, n_2733, n_2734, n_2735, n_2736,
          n_2737, n_2738, n_2739, n_2740, n_2741, a_SPORTBINREG_F3_G_aCLK,
          a_SCONTROLREG_F4_G_aNOT_aCLRN, a_EQ170, n_2749, n_2750, n_2751,
          n_2752, n_2753, n_2754, n_2755, n_2756, n_2757, n_2758, n_2759,
          n_2760, n_2761, a_SCONTROLREG_F4_G_aNOT_aCLK, a_SCONTROLREG_F6_G_aCLRN,
          a_EQ172, n_2769, n_2770, n_2771, n_2772, n_2773, n_2774, n_2775,
          n_2776, n_2777, n_2778, n_2779, n_2780, n_2781, a_SCONTROLREG_F6_G_aCLK,
          a_SCONTROLREG_F0_G_aNOT_aCLRN, a_EQ166, n_2789, n_2790, n_2791,
          n_2792, n_2793, n_2794, n_2795, n_2796, n_2797, n_2798, n_2799,
          n_2800, n_2801, a_SCONTROLREG_F0_G_aNOT_aCLK, a_SCONTROLREG_F2_G_aCLRN,
          a_EQ168, n_2809, n_2810, n_2811, n_2812, n_2813, n_2814, n_2815,
          n_2816, n_2817, n_2818, n_2819, n_2820, n_2821, a_SCONTROLREG_F2_G_aCLK,
          a_SCONTROLREG_F3_G_aNOT_aCLRN, a_EQ169, n_2829, n_2830, n_2831,
          n_2832, n_2833, n_2834, n_2835, n_2836, n_2837, n_2838, n_2839,
          n_2840, n_2841, a_SCONTROLREG_F3_G_aNOT_aCLK, a_LC2_A11, a_EQ134,
          n_2845, n_2846, n_2847, n_2848, n_2849, n_2850, n_2851, n_2852,
          n_2853, n_2854, a_LC8_A8, a_EQ135, n_2857, n_2858, n_2859, n_2860,
          n_2861, n_2862, n_2863, n_2864, a_N593, a_N593_aCLRN, a_N593_aD,
          n_2872, n_2873, n_2874, n_2875, n_2876, a_N593_aCLK, a_N286_aIN,
          n_2879, n_2880, n_2881, n_2882, n_2883, n_2884, a_N270_aNOT_aIN,
          n_2886, n_2887, n_2888, n_2889, n_2890, n_2891, a_EQ136, n_2893,
          n_2894, n_2895, n_2896, n_2897, n_2898, n_2899, n_2900, n_2901,
          a_EQ101, n_2903, n_2904, n_2905, n_2906, n_2907, n_2908, n_2909,
          n_2910, n_2911, n_2912 : std_logic;

COMPONENT TRIBUF_a8255
    PORT (in1, oe  : IN std_logic; y : OUT std_logic);
END COMPONENT;

COMPONENT DFF_a8255
    PORT (d, clk, clrn, prn : IN std_logic; q : OUT std_logic);
END COMPONENT;

COMPONENT FILTER_a8255
    PORT (in1 : IN std_logic; y : OUT std_logic);
END COMPONENT;

BEGIN

PROCESS(A(0), A(1), CLK, DIN(0), DIN(1), DIN(2), DIN(3), DIN(4), DIN(5), DIN(6),
          DIN(7), nCS, nRD, nWR, PAin(0), PAin(1), PAin(2), PAin(3), PAin(4),
          PAin(5), PAin(6), PAin(7), PBin(0), PBin(1), PBin(2), PBin(3), PBin(4),
          PBin(5), PBin(6), PBin(7), PCin(0), PCin(1), PCin(2), PCin(3), PCin(4),
          PCin(5), PCin(6), PCin(7), RESET)
BEGIN
    ASSERT A(0) /= 'X' OR Now = 0 ns
        REPORT "Unknown value on A(0)"
        SEVERITY Warning;
    ASSERT A(1) /= 'X' OR Now = 0 ns
        REPORT "Unknown value on A(1)"
        SEVERITY Warning;
    ASSERT CLK /= 'X' OR Now = 0 ns
        REPORT "Unknown value on CLK"
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
    ASSERT nCS /= 'X' OR Now = 0 ns
        REPORT "Unknown value on nCS"
        SEVERITY Warning;
    ASSERT nRD /= 'X' OR Now = 0 ns
        REPORT "Unknown value on nRD"
        SEVERITY Warning;
    ASSERT nWR /= 'X' OR Now = 0 ns
        REPORT "Unknown value on nWR"
        SEVERITY Warning;
    ASSERT PAin(0) /= 'X' OR Now = 0 ns
        REPORT "Unknown value on PAin(0)"
        SEVERITY Warning;
    ASSERT PAin(1) /= 'X' OR Now = 0 ns
        REPORT "Unknown value on PAin(1)"
        SEVERITY Warning;
    ASSERT PAin(2) /= 'X' OR Now = 0 ns
        REPORT "Unknown value on PAin(2)"
        SEVERITY Warning;
    ASSERT PAin(3) /= 'X' OR Now = 0 ns
        REPORT "Unknown value on PAin(3)"
        SEVERITY Warning;
    ASSERT PAin(4) /= 'X' OR Now = 0 ns
        REPORT "Unknown value on PAin(4)"
        SEVERITY Warning;
    ASSERT PAin(5) /= 'X' OR Now = 0 ns
        REPORT "Unknown value on PAin(5)"
        SEVERITY Warning;
    ASSERT PAin(6) /= 'X' OR Now = 0 ns
        REPORT "Unknown value on PAin(6)"
        SEVERITY Warning;
    ASSERT PAin(7) /= 'X' OR Now = 0 ns
        REPORT "Unknown value on PAin(7)"
        SEVERITY Warning;
    ASSERT PBin(0) /= 'X' OR Now = 0 ns
        REPORT "Unknown value on PBin(0)"
        SEVERITY Warning;
    ASSERT PBin(1) /= 'X' OR Now = 0 ns
        REPORT "Unknown value on PBin(1)"
        SEVERITY Warning;
    ASSERT PBin(2) /= 'X' OR Now = 0 ns
        REPORT "Unknown value on PBin(2)"
        SEVERITY Warning;
    ASSERT PBin(3) /= 'X' OR Now = 0 ns
        REPORT "Unknown value on PBin(3)"
        SEVERITY Warning;
    ASSERT PBin(4) /= 'X' OR Now = 0 ns
        REPORT "Unknown value on PBin(4)"
        SEVERITY Warning;
    ASSERT PBin(5) /= 'X' OR Now = 0 ns
        REPORT "Unknown value on PBin(5)"
        SEVERITY Warning;
    ASSERT PBin(6) /= 'X' OR Now = 0 ns
        REPORT "Unknown value on PBin(6)"
        SEVERITY Warning;
    ASSERT PBin(7) /= 'X' OR Now = 0 ns
        REPORT "Unknown value on PBin(7)"
        SEVERITY Warning;
    ASSERT PCin(0) /= 'X' OR Now = 0 ns
        REPORT "Unknown value on PCin(0)"
        SEVERITY Warning;
    ASSERT PCin(1) /= 'X' OR Now = 0 ns
        REPORT "Unknown value on PCin(1)"
        SEVERITY Warning;
    ASSERT PCin(2) /= 'X' OR Now = 0 ns
        REPORT "Unknown value on PCin(2)"
        SEVERITY Warning;
    ASSERT PCin(3) /= 'X' OR Now = 0 ns
        REPORT "Unknown value on PCin(3)"
        SEVERITY Warning;
    ASSERT PCin(4) /= 'X' OR Now = 0 ns
        REPORT "Unknown value on PCin(4)"
        SEVERITY Warning;
    ASSERT PCin(5) /= 'X' OR Now = 0 ns
        REPORT "Unknown value on PCin(5)"
        SEVERITY Warning;
    ASSERT PCin(6) /= 'X' OR Now = 0 ns
        REPORT "Unknown value on PCin(6)"
        SEVERITY Warning;
    ASSERT PCin(7) /= 'X' OR Now = 0 ns
        REPORT "Unknown value on PCin(7)"
        SEVERITY Warning;
    ASSERT RESET /= 'X' OR Now = 0 ns
        REPORT "Unknown value on RESET"
        SEVERITY Warning;
END PROCESS;

tribuf_2: TRIBUF_a8255

    PORT MAP (IN1 => n_213, OE => vcc, Y => PCOUT(0));
tribuf_4: TRIBUF_a8255

    PORT MAP (IN1 => n_220, OE => vcc, Y => PCOUT(1));
tribuf_6: TRIBUF_a8255

    PORT MAP (IN1 => n_227, OE => vcc, Y => PCOUT(2));
tribuf_8: TRIBUF_a8255

    PORT MAP (IN1 => n_234, OE => vcc, Y => PCOUT(3));
tribuf_10: TRIBUF_a8255

    PORT MAP (IN1 => n_241, OE => vcc, Y => PCOUT(4));
tribuf_12: TRIBUF_a8255

    PORT MAP (IN1 => n_248, OE => vcc, Y => PCOUT(5));
tribuf_14: TRIBUF_a8255

    PORT MAP (IN1 => n_255, OE => vcc, Y => PCOUT(6));
tribuf_16: TRIBUF_a8255

    PORT MAP (IN1 => n_262, OE => vcc, Y => PCOUT(7));
tribuf_18: TRIBUF_a8255

    PORT MAP (IN1 => n_269, OE => vcc, Y => PCEN(0));
tribuf_20: TRIBUF_a8255

    PORT MAP (IN1 => n_276, OE => vcc, Y => PCEN(1));
tribuf_22: TRIBUF_a8255

    PORT MAP (IN1 => n_283, OE => vcc, Y => PCEN(2));
tribuf_24: TRIBUF_a8255

    PORT MAP (IN1 => n_290, OE => vcc, Y => PCEN(3));
tribuf_26: TRIBUF_a8255

    PORT MAP (IN1 => n_297, OE => vcc, Y => PCEN(4));
tribuf_28: TRIBUF_a8255

    PORT MAP (IN1 => n_304, OE => vcc, Y => PCEN(5));
tribuf_30: TRIBUF_a8255

    PORT MAP (IN1 => n_311, OE => vcc, Y => PCEN(6));
tribuf_32: TRIBUF_a8255

    PORT MAP (IN1 => n_318, OE => vcc, Y => PCEN(7));
tribuf_34: TRIBUF_a8255

    PORT MAP (IN1 => n_325, OE => vcc, Y => PBOUT(0));
tribuf_36: TRIBUF_a8255

    PORT MAP (IN1 => n_332, OE => vcc, Y => PBOUT(1));
tribuf_38: TRIBUF_a8255

    PORT MAP (IN1 => n_339, OE => vcc, Y => PBOUT(2));
tribuf_40: TRIBUF_a8255

    PORT MAP (IN1 => n_346, OE => vcc, Y => PBOUT(3));
tribuf_42: TRIBUF_a8255

    PORT MAP (IN1 => n_353, OE => vcc, Y => PBOUT(4));
tribuf_44: TRIBUF_a8255

    PORT MAP (IN1 => n_360, OE => vcc, Y => PBOUT(5));
tribuf_46: TRIBUF_a8255

    PORT MAP (IN1 => n_367, OE => vcc, Y => PBOUT(6));
tribuf_48: TRIBUF_a8255

    PORT MAP (IN1 => n_374, OE => vcc, Y => PBOUT(7));
tribuf_50: TRIBUF_a8255

    PORT MAP (IN1 => n_381, OE => vcc, Y => PAOUT(0));
tribuf_52: TRIBUF_a8255

    PORT MAP (IN1 => n_388, OE => vcc, Y => PAOUT(1));
tribuf_54: TRIBUF_a8255

    PORT MAP (IN1 => n_395, OE => vcc, Y => PAOUT(2));
tribuf_56: TRIBUF_a8255

    PORT MAP (IN1 => n_402, OE => vcc, Y => PAOUT(3));
tribuf_58: TRIBUF_a8255

    PORT MAP (IN1 => n_409, OE => vcc, Y => PAOUT(4));
tribuf_60: TRIBUF_a8255

    PORT MAP (IN1 => n_416, OE => vcc, Y => PAOUT(5));
tribuf_62: TRIBUF_a8255

    PORT MAP (IN1 => n_423, OE => vcc, Y => PAOUT(6));
tribuf_64: TRIBUF_a8255

    PORT MAP (IN1 => n_430, OE => vcc, Y => PAOUT(7));
tribuf_66: TRIBUF_a8255

    PORT MAP (IN1 => n_437, OE => vcc, Y => DOUT(0));
tribuf_68: TRIBUF_a8255

    PORT MAP (IN1 => n_444, OE => vcc, Y => DOUT(1));
tribuf_70: TRIBUF_a8255

    PORT MAP (IN1 => n_451, OE => vcc, Y => DOUT(2));
tribuf_72: TRIBUF_a8255

    PORT MAP (IN1 => n_458, OE => vcc, Y => DOUT(3));
tribuf_74: TRIBUF_a8255

    PORT MAP (IN1 => n_465, OE => vcc, Y => DOUT(4));
tribuf_76: TRIBUF_a8255

    PORT MAP (IN1 => n_472, OE => vcc, Y => DOUT(5));
tribuf_78: TRIBUF_a8255

    PORT MAP (IN1 => n_479, OE => vcc, Y => DOUT(6));
tribuf_80: TRIBUF_a8255

    PORT MAP (IN1 => n_486, OE => vcc, Y => DOUT(7));
tribuf_82: TRIBUF_a8255

    PORT MAP (IN1 => n_493, OE => vcc, Y => PBEN);
tribuf_84: TRIBUF_a8255

    PORT MAP (IN1 => n_500, OE => vcc, Y => PAEN);
delay_85: n_213  <= TRANSPORT n_214;
xor2_86: n_214 <=  n_215  XOR n_219;
or1_87: n_215 <=  n_216;
and1_88: n_216 <=  n_217;
delay_89: n_217  <= TRANSPORT a_LC6_A8  ;
and1_90: n_219 <=  gnd;
delay_91: n_220  <= TRANSPORT n_221;
xor2_92: n_221 <=  n_222  XOR n_226;
or1_93: n_222 <=  n_223;
and1_94: n_223 <=  n_224;
delay_95: n_224  <= TRANSPORT a_LC8_A21  ;
and1_96: n_226 <=  gnd;
delay_97: n_227  <= TRANSPORT n_228;
xor2_98: n_228 <=  n_229  XOR n_233;
or1_99: n_229 <=  n_230;
and1_100: n_230 <=  n_231;
delay_101: n_231  <= TRANSPORT a_LC6_A2  ;
and1_102: n_233 <=  gnd;
delay_103: n_234  <= TRANSPORT n_235;
xor2_104: n_235 <=  n_236  XOR n_240;
or1_105: n_236 <=  n_237;
and1_106: n_237 <=  n_238;
delay_107: n_238  <= TRANSPORT a_LC8_A4  ;
and1_108: n_240 <=  gnd;
delay_109: n_241  <= TRANSPORT n_242;
xor2_110: n_242 <=  n_243  XOR n_247;
or1_111: n_243 <=  n_244;
and1_112: n_244 <=  n_245;
delay_113: n_245  <= TRANSPORT a_LC4_A1  ;
and1_114: n_247 <=  gnd;
delay_115: n_248  <= TRANSPORT n_249;
xor2_116: n_249 <=  n_250  XOR n_254;
or1_117: n_250 <=  n_251;
and1_118: n_251 <=  n_252;
delay_119: n_252  <= TRANSPORT a_LC1_B19  ;
and1_120: n_254 <=  gnd;
delay_121: n_255  <= TRANSPORT n_256;
xor2_122: n_256 <=  n_257  XOR n_261;
or1_123: n_257 <=  n_258;
and1_124: n_258 <=  n_259;
delay_125: n_259  <= TRANSPORT a_LC2_A1  ;
and1_126: n_261 <=  gnd;
delay_127: n_262  <= TRANSPORT n_263;
xor2_128: n_263 <=  n_264  XOR n_268;
or1_129: n_264 <=  n_265;
and1_130: n_265 <=  n_266;
delay_131: n_266  <= TRANSPORT a_LC6_B3  ;
and1_132: n_268 <=  gnd;
delay_133: n_269  <= TRANSPORT n_270;
xor2_134: n_270 <=  n_271  XOR n_275;
or1_135: n_271 <=  n_272;
and1_136: n_272 <=  n_273;
delay_137: n_273  <= TRANSPORT a_G119  ;
and1_138: n_275 <=  gnd;
delay_139: n_276  <= TRANSPORT n_277;
xor2_140: n_277 <=  n_278  XOR n_282;
or1_141: n_278 <=  n_279;
and1_142: n_279 <=  n_280;
delay_143: n_280  <= TRANSPORT a_LC2_A12  ;
and1_144: n_282 <=  gnd;
delay_145: n_283  <= TRANSPORT n_284;
xor2_146: n_284 <=  n_285  XOR n_289;
or1_147: n_285 <=  n_286;
and1_148: n_286 <=  n_287;
delay_149: n_287  <= TRANSPORT a_G107  ;
and1_150: n_289 <=  gnd;
delay_151: n_290  <= TRANSPORT n_291;
xor2_152: n_291 <=  n_292  XOR n_296;
or1_153: n_292 <=  n_293;
and1_154: n_293 <=  n_294;
delay_155: n_294  <= TRANSPORT a_G137  ;
and1_156: n_296 <=  gnd;
delay_157: n_297  <= TRANSPORT n_298;
xor2_158: n_298 <=  n_299  XOR n_303;
or1_159: n_299 <=  n_300;
and1_160: n_300 <=  n_301;
delay_161: n_301  <= TRANSPORT a_G98  ;
and1_162: n_303 <=  gnd;
delay_163: n_304  <= TRANSPORT n_305;
xor2_164: n_305 <=  n_306  XOR n_310;
or1_165: n_306 <=  n_307;
and1_166: n_307 <=  n_308;
delay_167: n_308  <= TRANSPORT a_G381  ;
and1_168: n_310 <=  gnd;
delay_169: n_311  <= TRANSPORT n_312;
xor2_170: n_312 <=  n_313  XOR n_317;
or1_171: n_313 <=  n_314;
and1_172: n_314 <=  n_315;
delay_173: n_315  <= TRANSPORT a_G99  ;
and1_174: n_317 <=  gnd;
delay_175: n_318  <= TRANSPORT n_319;
xor2_176: n_319 <=  n_320  XOR n_324;
or1_177: n_320 <=  n_321;
and1_178: n_321 <=  n_322;
delay_179: n_322  <= TRANSPORT a_G89  ;
and1_180: n_324 <=  gnd;
delay_181: n_325  <= TRANSPORT n_326;
xor2_182: n_326 <=  n_327  XOR n_331;
or1_183: n_327 <=  n_328;
and1_184: n_328 <=  n_329;
delay_185: n_329  <= TRANSPORT a_LC1_A3  ;
and1_186: n_331 <=  gnd;
delay_187: n_332  <= TRANSPORT n_333;
xor2_188: n_333 <=  n_334  XOR n_338;
or1_189: n_334 <=  n_335;
and1_190: n_335 <=  n_336;
delay_191: n_336  <= TRANSPORT a_LC4_B17  ;
and1_192: n_338 <=  gnd;
delay_193: n_339  <= TRANSPORT n_340;
xor2_194: n_340 <=  n_341  XOR n_345;
or1_195: n_341 <=  n_342;
and1_196: n_342 <=  n_343;
delay_197: n_343  <= TRANSPORT a_LC3_B6  ;
and1_198: n_345 <=  gnd;
delay_199: n_346  <= TRANSPORT n_347;
xor2_200: n_347 <=  n_348  XOR n_352;
or1_201: n_348 <=  n_349;
and1_202: n_349 <=  n_350;
delay_203: n_350  <= TRANSPORT a_LC1_A18  ;
and1_204: n_352 <=  gnd;
delay_205: n_353  <= TRANSPORT n_354;
xor2_206: n_354 <=  n_355  XOR n_359;
or1_207: n_355 <=  n_356;
and1_208: n_356 <=  n_357;
delay_209: n_357  <= TRANSPORT a_LC3_A13  ;
and1_210: n_359 <=  gnd;
delay_211: n_360  <= TRANSPORT n_361;
xor2_212: n_361 <=  n_362  XOR n_366;
or1_213: n_362 <=  n_363;
and1_214: n_363 <=  n_364;
delay_215: n_364  <= TRANSPORT a_LC2_B10  ;
and1_216: n_366 <=  gnd;
delay_217: n_367  <= TRANSPORT n_368;
xor2_218: n_368 <=  n_369  XOR n_373;
or1_219: n_369 <=  n_370;
and1_220: n_370 <=  n_371;
delay_221: n_371  <= TRANSPORT a_LC2_B9  ;
and1_222: n_373 <=  gnd;
delay_223: n_374  <= TRANSPORT n_375;
xor2_224: n_375 <=  n_376  XOR n_380;
or1_225: n_376 <=  n_377;
and1_226: n_377 <=  n_378;
delay_227: n_378  <= TRANSPORT a_LC3_B7  ;
and1_228: n_380 <=  gnd;
delay_229: n_381  <= TRANSPORT n_382;
xor2_230: n_382 <=  n_383  XOR n_387;
or1_231: n_383 <=  n_384;
and1_232: n_384 <=  n_385;
delay_233: n_385  <= TRANSPORT a_LC1_A13  ;
and1_234: n_387 <=  gnd;
delay_235: n_388  <= TRANSPORT n_389;
xor2_236: n_389 <=  n_390  XOR n_394;
or1_237: n_390 <=  n_391;
and1_238: n_391 <=  n_392;
delay_239: n_392  <= TRANSPORT a_LC2_B6  ;
and1_240: n_394 <=  gnd;
delay_241: n_395  <= TRANSPORT n_396;
xor2_242: n_396 <=  n_397  XOR n_401;
or1_243: n_397 <=  n_398;
and1_244: n_398 <=  n_399;
delay_245: n_399  <= TRANSPORT a_LC1_B6  ;
and1_246: n_401 <=  gnd;
delay_247: n_402  <= TRANSPORT n_403;
xor2_248: n_403 <=  n_404  XOR n_408;
or1_249: n_404 <=  n_405;
and1_250: n_405 <=  n_406;
delay_251: n_406  <= TRANSPORT a_LC1_B10  ;
and1_252: n_408 <=  gnd;
delay_253: n_409  <= TRANSPORT n_410;
xor2_254: n_410 <=  n_411  XOR n_415;
or1_255: n_411 <=  n_412;
and1_256: n_412 <=  n_413;
delay_257: n_413  <= TRANSPORT a_LC2_A13  ;
and1_258: n_415 <=  gnd;
delay_259: n_416  <= TRANSPORT n_417;
xor2_260: n_417 <=  n_418  XOR n_422;
or1_261: n_418 <=  n_419;
and1_262: n_419 <=  n_420;
delay_263: n_420  <= TRANSPORT a_LC1_B9  ;
and1_264: n_422 <=  gnd;
delay_265: n_423  <= TRANSPORT n_424;
xor2_266: n_424 <=  n_425  XOR n_429;
or1_267: n_425 <=  n_426;
and1_268: n_426 <=  n_427;
delay_269: n_427  <= TRANSPORT a_LC1_B11  ;
and1_270: n_429 <=  gnd;
delay_271: n_430  <= TRANSPORT n_431;
xor2_272: n_431 <=  n_432  XOR n_436;
or1_273: n_432 <=  n_433;
and1_274: n_433 <=  n_434;
delay_275: n_434  <= TRANSPORT a_LC6_A18  ;
and1_276: n_436 <=  gnd;
delay_277: n_437  <= TRANSPORT n_438;
xor2_278: n_438 <=  n_439  XOR n_443;
or1_279: n_439 <=  n_440;
and1_280: n_440 <=  n_441;
delay_281: n_441  <= TRANSPORT a_G135  ;
and1_282: n_443 <=  gnd;
delay_283: n_444  <= TRANSPORT n_445;
xor2_284: n_445 <=  n_446  XOR n_450;
or1_285: n_446 <=  n_447;
and1_286: n_447 <=  n_448;
delay_287: n_448  <= TRANSPORT a_G84  ;
and1_288: n_450 <=  gnd;
delay_289: n_451  <= TRANSPORT n_452;
xor2_290: n_452 <=  n_453  XOR n_457;
or1_291: n_453 <=  n_454;
and1_292: n_454 <=  n_455;
delay_293: n_455  <= TRANSPORT a_G153  ;
and1_294: n_457 <=  gnd;
delay_295: n_458  <= TRANSPORT n_459;
xor2_296: n_459 <=  n_460  XOR n_464;
or1_297: n_460 <=  n_461;
and1_298: n_461 <=  n_462;
delay_299: n_462  <= TRANSPORT a_G82  ;
and1_300: n_464 <=  gnd;
delay_301: n_465  <= TRANSPORT n_466;
xor2_302: n_466 <=  n_467  XOR n_471;
or1_303: n_467 <=  n_468;
and1_304: n_468 <=  n_469;
delay_305: n_469  <= TRANSPORT a_G233  ;
and1_306: n_471 <=  gnd;
delay_307: n_472  <= TRANSPORT n_473;
xor2_308: n_473 <=  n_474  XOR n_478;
or1_309: n_474 <=  n_475;
and1_310: n_475 <=  n_476;
delay_311: n_476  <= TRANSPORT a_G83  ;
and1_312: n_478 <=  gnd;
delay_313: n_479  <= TRANSPORT n_480;
xor2_314: n_480 <=  n_481  XOR n_485;
or1_315: n_481 <=  n_482;
and1_316: n_482 <=  n_483;
delay_317: n_483  <= TRANSPORT a_G227  ;
and1_318: n_485 <=  gnd;
delay_319: n_486  <= TRANSPORT n_487;
xor2_320: n_487 <=  n_488  XOR n_492;
or1_321: n_488 <=  n_489;
and1_322: n_489 <=  n_490;
delay_323: n_490  <= TRANSPORT a_G152  ;
and1_324: n_492 <=  gnd;
delay_325: n_493  <= TRANSPORT n_494;
xor2_326: n_494 <=  n_495  XOR n_499;
or1_327: n_495 <=  n_496;
and1_328: n_496 <=  n_497;
delay_329: n_497  <= TRANSPORT a_SCONTROLREG_F1_G_aNOT  ;
and1_330: n_499 <=  gnd;
delay_331: n_500  <= TRANSPORT n_501;
xor2_332: n_501 <=  n_502  XOR n_506;
or1_333: n_502 <=  n_503;
and1_334: n_503 <=  n_504;
delay_335: n_504  <= TRANSPORT a_SPAEN  ;
and1_336: n_506 <=  gnd;
delay_337: a_LC4_A8  <= TRANSPORT a_LC4_A8_aIN  ;
xor2_338: a_LC4_A8_aIN <=  n_509  XOR n_518;
or1_339: n_509 <=  n_510;
and4_340: n_510 <=  n_511  AND n_513  AND n_515  AND n_517;
delay_341: n_511  <= TRANSPORT A(0)  ;
inv_342: n_513  <= TRANSPORT NOT a_N286  ;
delay_343: n_515  <= TRANSPORT a_N62  ;
delay_344: n_517  <= TRANSPORT a_LC6_A8  ;
and1_345: n_518 <=  gnd;
delay_346: a_LC4_A7  <= TRANSPORT a_LC4_A7_aIN  ;
xor2_347: a_LC4_A7_aIN <=  n_521  XOR n_529;
or1_348: n_521 <=  n_522;
and3_349: n_522 <=  n_523  AND n_525  AND n_527;
inv_350: n_523  <= TRANSPORT NOT nCS  ;
inv_351: n_525  <= TRANSPORT NOT nWR  ;
delay_352: n_527  <= TRANSPORT DIN(0)  ;
and1_353: n_529 <=  gnd;
delay_354: a_LC2_A8  <= TRANSPORT a_EQ116  ;
xor2_355: a_EQ116 <=  n_532  XOR n_542;
or2_356: n_532 <=  n_533  OR n_538;
and3_357: n_533 <=  n_534  AND n_535  AND n_537;
inv_358: n_534  <= TRANSPORT NOT A(0)  ;
inv_359: n_535  <= TRANSPORT NOT a_SCONTROLREG_F2_G  ;
delay_360: n_537  <= TRANSPORT a_LC4_A7  ;
and3_361: n_538 <=  n_539  AND n_540  AND n_541;
delay_362: n_539  <= TRANSPORT A(0)  ;
inv_363: n_540  <= TRANSPORT NOT a_N62  ;
delay_364: n_541  <= TRANSPORT a_LC4_A7  ;
and1_365: n_542 <=  gnd;
delay_366: a_LC5_A8  <= TRANSPORT a_EQ137  ;
xor2_367: a_EQ137 <=  n_545  XOR n_556;
or3_368: n_545 <=  n_546  OR n_549  OR n_553;
and1_369: n_546 <=  n_547;
delay_370: n_547  <= TRANSPORT a_LC7_A8  ;
and2_371: n_549 <=  n_550  AND n_552;
delay_372: n_550  <= TRANSPORT A(1)  ;
delay_373: n_552  <= TRANSPORT a_LC4_A8  ;
and2_374: n_553 <=  n_554  AND n_555;
delay_375: n_554  <= TRANSPORT A(1)  ;
delay_376: n_555  <= TRANSPORT a_LC2_A8  ;
and1_377: n_556 <=  gnd;
delay_378: a_N16  <= TRANSPORT a_EQ073  ;
xor2_379: a_EQ073 <=  n_559  XOR n_568;
or2_380: n_559 <=  n_560  OR n_565;
and3_381: n_560 <=  n_561  AND n_562  AND n_564;
delay_382: n_561  <= TRANSPORT A(1)  ;
delay_383: n_562  <= TRANSPORT a_N270_aNOT  ;
delay_384: n_564  <= TRANSPORT a_N62  ;
and2_385: n_565 <=  n_566  AND n_567;
inv_386: n_566  <= TRANSPORT NOT A(0)  ;
delay_387: n_567  <= TRANSPORT a_N270_aNOT  ;
and1_388: n_568 <=  gnd;
delay_389: a_LC4_A5  <= TRANSPORT a_LC4_A5_aIN  ;
xor2_390: a_LC4_A5_aIN <=  n_571  XOR n_576;
or1_391: n_571 <=  n_572;
and3_392: n_572 <=  n_573  AND n_574  AND n_575;
inv_393: n_573  <= TRANSPORT NOT A(0)  ;
delay_394: n_574  <= TRANSPORT a_SCONTROLREG_F2_G  ;
inv_395: n_575  <= TRANSPORT NOT a_N286  ;
and1_396: n_576 <=  gnd;
delay_397: a_LC5_A5  <= TRANSPORT a_EQ138  ;
xor2_398: a_EQ138 <=  n_579  XOR n_588;
or2_399: n_579 <=  n_580  OR n_584;
and3_400: n_580 <=  n_581  AND n_582  AND n_583;
delay_401: n_581  <= TRANSPORT A(0)  ;
inv_402: n_582  <= TRANSPORT NOT a_SCONTROLREG_F2_G  ;
delay_403: n_583  <= TRANSPORT a_N62  ;
and2_404: n_584 <=  n_585  AND n_587;
inv_405: n_585  <= TRANSPORT NOT a_N42  ;
inv_406: n_587  <= TRANSPORT NOT a_SCONTROLREG_F2_G  ;
and1_407: n_588 <=  gnd;
delay_408: a_N188_aNOT  <= TRANSPORT a_EQ117  ;
xor2_409: a_EQ117 <=  n_591  XOR n_599;
or3_410: n_591 <=  n_592  OR n_594  OR n_596;
and1_411: n_592 <=  n_593;
delay_412: n_593  <= TRANSPORT nCS  ;
and1_413: n_594 <=  n_595;
delay_414: n_595  <= TRANSPORT nWR  ;
and2_415: n_596 <=  n_597  AND n_598;
inv_416: n_597  <= TRANSPORT NOT A(1)  ;
inv_417: n_598  <= TRANSPORT NOT a_SCONTROLREG_F1_G_aNOT  ;
and1_418: n_599 <=  gnd;
delay_419: a_LC2_A5  <= TRANSPORT a_EQ139  ;
xor2_420: a_EQ139 <=  n_602  XOR n_610;
or3_421: n_602 <=  n_603  OR n_605  OR n_607;
and1_422: n_603 <=  n_604;
delay_423: n_604  <= TRANSPORT a_LC4_A5  ;
and1_424: n_605 <=  n_606;
delay_425: n_606  <= TRANSPORT a_LC5_A5  ;
and2_426: n_607 <=  n_608  AND n_609;
delay_427: n_608  <= TRANSPORT a_N188_aNOT  ;
inv_428: n_609  <= TRANSPORT NOT a_LC8_A21  ;
and1_429: n_610 <=  gnd;
dff_430: DFF_a8255

    PORT MAP ( D => a_EQ025, CLK => a_LC6_A8_aCLK, CLRN => a_LC6_A8_aCLRN,
          PRN => vcc, Q => a_LC6_A8);
inv_431: a_LC6_A8_aCLRN  <= TRANSPORT NOT RESET  ;
xor2_432: a_EQ025 <=  n_618  XOR n_626;
or3_433: n_618 <=  n_619  OR n_621  OR n_623;
and1_434: n_619 <=  n_620;
delay_435: n_620  <= TRANSPORT a_LC5_A8  ;
and1_436: n_621 <=  n_622;
delay_437: n_622  <= TRANSPORT a_N16  ;
and2_438: n_623 <=  n_624  AND n_625;
delay_439: n_624  <= TRANSPORT a_LC2_A5  ;
delay_440: n_625  <= TRANSPORT a_LC6_A8  ;
and1_441: n_626 <=  gnd;
delay_442: n_627  <= TRANSPORT CLK  ;
filter_443: FILTER_a8255

    PORT MAP (IN1 => n_627, Y => a_LC6_A8_aCLK);
delay_444: a_N156  <= TRANSPORT a_EQ112  ;
xor2_445: a_EQ112 <=  n_632  XOR n_642;
or4_446: n_632 <=  n_633  OR n_635  OR n_637  OR n_639;
and1_447: n_633 <=  n_634;
delay_448: n_634  <= TRANSPORT a_SCONTROLREG_F2_G  ;
and1_449: n_635 <=  n_636;
delay_450: n_636  <= TRANSPORT A(0)  ;
and1_451: n_637 <=  n_638;
inv_452: n_638  <= TRANSPORT NOT a_N42  ;
and1_453: n_639 <=  n_640;
delay_454: n_640  <= TRANSPORT DIN(1)  ;
and1_455: n_642 <=  gnd;
delay_456: a_N24  <= TRANSPORT a_N24_aIN  ;
xor2_457: a_N24_aIN <=  n_645  XOR n_654;
or1_458: n_645 <=  n_646;
and4_459: n_646 <=  n_647  AND n_649  AND n_651  AND n_653;
inv_460: n_647  <= TRANSPORT NOT DIN(7)  ;
inv_461: n_649  <= TRANSPORT NOT DIN(2)  ;
inv_462: n_651  <= TRANSPORT NOT DIN(3)  ;
delay_463: n_653  <= TRANSPORT DIN(1)  ;
and1_464: n_654 <=  gnd;
delay_465: a_LC4_A21  <= TRANSPORT a_EQ162  ;
xor2_466: a_EQ162 <=  n_657  XOR n_668;
or3_467: n_657 <=  n_658  OR n_661  OR n_664;
and2_468: n_658 <=  n_659  AND n_660;
delay_469: n_659  <= TRANSPORT a_N156  ;
inv_470: n_660  <= TRANSPORT NOT a_N24  ;
and2_471: n_661 <=  n_662  AND n_663;
delay_472: n_662  <= TRANSPORT DIN(0)  ;
delay_473: n_663  <= TRANSPORT a_N156  ;
and2_474: n_664 <=  n_665  AND n_667;
inv_475: n_665  <= TRANSPORT NOT a_N46  ;
delay_476: n_667  <= TRANSPORT a_N156  ;
and1_477: n_668 <=  gnd;
delay_478: a_N158  <= TRANSPORT a_EQ114  ;
xor2_479: a_EQ114 <=  n_671  XOR n_678;
or2_480: n_671 <=  n_672  OR n_674;
and1_481: n_672 <=  n_673;
delay_482: n_673  <= TRANSPORT a_LC8_A21  ;
and2_483: n_674 <=  n_675  AND n_677;
inv_484: n_675  <= TRANSPORT NOT PCin(2)  ;
delay_485: n_677  <= TRANSPORT a_SCONTROLREG_F2_G  ;
and1_486: n_678 <=  gnd;
delay_487: a_N265_aNOT  <= TRANSPORT a_EQ130  ;
xor2_488: a_EQ130 <=  n_681  XOR n_686;
or2_489: n_681 <=  n_682  OR n_684;
and1_490: n_682 <=  n_683;
delay_491: n_683  <= TRANSPORT A(1)  ;
and1_492: n_684 <=  n_685;
inv_493: n_685  <= TRANSPORT NOT A(0)  ;
and1_494: n_686 <=  gnd;
delay_495: a_N348_aNOT  <= TRANSPORT a_EQ141  ;
xor2_496: a_EQ141 <=  n_689  XOR n_696;
or3_497: n_689 <=  n_690  OR n_692  OR n_694;
and1_498: n_690 <=  n_691;
delay_499: n_691  <= TRANSPORT nCS  ;
and1_500: n_692 <=  n_693;
delay_501: n_693  <= TRANSPORT nWR  ;
and1_502: n_694 <=  n_695;
delay_503: n_695  <= TRANSPORT a_N265_aNOT  ;
and1_504: n_696 <=  gnd;
dff_505: DFF_a8255

    PORT MAP ( D => a_N598_aD, CLK => a_N598_aCLK, CLRN => a_N598_aCLRN, PRN => vcc,
          Q => a_N598);
inv_506: a_N598_aCLRN  <= TRANSPORT NOT RESET  ;
xor2_507: a_N598_aD <=  n_704  XOR n_707;
or1_508: n_704 <=  n_705;
and1_509: n_705 <=  n_706;
delay_510: n_706  <= TRANSPORT a_N348_aNOT  ;
and1_511: n_707 <=  gnd;
delay_512: n_708  <= TRANSPORT CLK  ;
filter_513: FILTER_a8255

    PORT MAP (IN1 => n_708, Y => a_N598_aCLK);
dff_514: DFF_a8255

    PORT MAP ( D => a_EQ164, CLK => a_N596_aCLK, CLRN => a_N596_aCLRN, PRN => vcc,
          Q => a_N596);
inv_515: a_N596_aCLRN  <= TRANSPORT NOT RESET  ;
xor2_516: a_EQ164 <=  n_717  XOR n_725;
or3_517: n_717 <=  n_718  OR n_720  OR n_723;
and1_518: n_718 <=  n_719;
delay_519: n_719  <= TRANSPORT a_N265_aNOT  ;
and1_520: n_720 <=  n_721;
delay_521: n_721  <= TRANSPORT nRD  ;
and1_522: n_723 <=  n_724;
delay_523: n_724  <= TRANSPORT nCS  ;
and1_524: n_725 <=  gnd;
delay_525: n_726  <= TRANSPORT CLK  ;
filter_526: FILTER_a8255

    PORT MAP (IN1 => n_726, Y => a_N596_aCLK);
delay_527: a_N142  <= TRANSPORT a_EQ108  ;
xor2_528: a_EQ108 <=  n_730  XOR n_740;
or3_529: n_730 <=  n_731  OR n_734  OR n_737;
and2_530: n_731 <=  n_732  AND n_733;
delay_531: n_732  <= TRANSPORT a_N598  ;
delay_532: n_733  <= TRANSPORT a_SCONTROLREG_F1_G_aNOT  ;
and2_533: n_734 <=  n_735  AND n_736;
delay_534: n_735  <= TRANSPORT a_N596  ;
inv_535: n_736  <= TRANSPORT NOT a_SCONTROLREG_F1_G_aNOT  ;
and2_536: n_737 <=  n_738  AND n_739;
delay_537: n_738  <= TRANSPORT a_LC6_A8  ;
inv_538: n_739  <= TRANSPORT NOT a_SCONTROLREG_F1_G_aNOT  ;
and1_539: n_740 <=  gnd;
delay_540: a_N157  <= TRANSPORT a_EQ113  ;
xor2_541: a_EQ113 <=  n_743  XOR n_751;
or3_542: n_743 <=  n_744  OR n_746  OR n_748;
and1_543: n_744 <=  n_745;
inv_544: n_745  <= TRANSPORT NOT a_SCONTROLREG_F2_G  ;
and1_545: n_746 <=  n_747;
delay_546: n_747  <= TRANSPORT A(0)  ;
and2_547: n_748 <=  n_749  AND n_750;
delay_548: n_749  <= TRANSPORT a_N158  ;
delay_549: n_750  <= TRANSPORT a_N142  ;
and1_550: n_751 <=  gnd;
delay_551: a_LC6_A21  <= TRANSPORT a_EQ110  ;
xor2_552: a_EQ110 <=  n_754  XOR n_761;
or2_553: n_754 <=  n_755  OR n_759;
and3_554: n_755 <=  n_756  AND n_757  AND n_758;
inv_555: n_756  <= TRANSPORT NOT DIN(7)  ;
inv_556: n_757  <= TRANSPORT NOT DIN(2)  ;
inv_557: n_758  <= TRANSPORT NOT DIN(3)  ;
and1_558: n_759 <=  n_760;
inv_559: n_760  <= TRANSPORT NOT A(0)  ;
and1_560: n_761 <=  gnd;
delay_561: a_LC3_A21  <= TRANSPORT a_EQ163  ;
xor2_562: a_EQ163 <=  n_764  XOR n_771;
or2_563: n_764 <=  n_765  OR n_769;
and3_564: n_765 <=  n_766  AND n_767  AND n_768;
delay_565: n_766  <= TRANSPORT a_N42  ;
delay_566: n_767  <= TRANSPORT DIN(1)  ;
delay_567: n_768  <= TRANSPORT a_LC6_A21  ;
and1_568: n_769 <=  n_770;
delay_569: n_770  <= TRANSPORT a_N158  ;
and1_570: n_771 <=  gnd;
delay_571: a_LC6_A6  <= TRANSPORT a_EQ111  ;
xor2_572: a_EQ111 <=  n_774  XOR n_782;
or3_573: n_774 <=  n_775  OR n_777  OR n_780;
and1_574: n_775 <=  n_776;
inv_575: n_776  <= TRANSPORT NOT a_SCONTROLREG_F1_G_aNOT  ;
and2_576: n_777 <=  n_778  AND n_779;
inv_577: n_778  <= TRANSPORT NOT nCS  ;
inv_578: n_779  <= TRANSPORT NOT nWR  ;
and1_579: n_780 <=  n_781;
delay_580: n_781  <= TRANSPORT a_N598  ;
and1_581: n_782 <=  gnd;
delay_582: a_N56_aNOT  <= TRANSPORT a_EQ100  ;
xor2_583: a_EQ100 <=  n_785  XOR n_794;
or2_584: n_785 <=  n_786  OR n_790;
and3_585: n_786 <=  n_787  AND n_788  AND n_789;
inv_586: n_787  <= TRANSPORT NOT nCS  ;
inv_587: n_788  <= TRANSPORT NOT nWR  ;
delay_588: n_789  <= TRANSPORT A(1)  ;
and3_589: n_790 <=  n_791  AND n_792  AND n_793;
inv_590: n_791  <= TRANSPORT NOT nCS  ;
inv_591: n_792  <= TRANSPORT NOT A(1)  ;
inv_592: n_793  <= TRANSPORT NOT nRD  ;
and1_593: n_794 <=  gnd;
delay_594: a_LC5_A6  <= TRANSPORT a_EQ109  ;
xor2_595: a_EQ109 <=  n_797  XOR n_806;
or4_596: n_797 <=  n_798  OR n_800  OR n_802  OR n_804;
and1_597: n_798 <=  n_799;
delay_598: n_799  <= TRANSPORT a_SCONTROLREG_F1_G_aNOT  ;
and1_599: n_800 <=  n_801;
delay_600: n_801  <= TRANSPORT a_N56_aNOT  ;
and1_601: n_802 <=  n_803;
delay_602: n_803  <= TRANSPORT a_N596  ;
and1_603: n_804 <=  n_805;
delay_604: n_805  <= TRANSPORT a_LC6_A8  ;
and1_605: n_806 <=  gnd;
delay_606: a_LC1_A21  <= TRANSPORT a_EQ107  ;
xor2_607: a_EQ107 <=  n_809  XOR n_816;
or3_608: n_809 <=  n_810  OR n_812  OR n_814;
and1_609: n_810 <=  n_811;
delay_610: n_811  <= TRANSPORT a_N24  ;
and1_611: n_812 <=  n_813;
inv_612: n_813  <= TRANSPORT NOT A(1)  ;
and1_613: n_814 <=  n_815;
delay_614: n_815  <= TRANSPORT a_N142  ;
and1_615: n_816 <=  gnd;
delay_616: a_LC1_A6  <= TRANSPORT a_EQ161  ;
xor2_617: a_EQ161 <=  n_819  XOR n_826;
or2_618: n_819 <=  n_820  OR n_824;
and3_619: n_820 <=  n_821  AND n_822  AND n_823;
delay_620: n_821  <= TRANSPORT a_LC6_A6  ;
delay_621: n_822  <= TRANSPORT a_LC5_A6  ;
delay_622: n_823  <= TRANSPORT a_LC1_A21  ;
and1_623: n_824 <=  n_825;
inv_624: n_825  <= TRANSPORT NOT a_SCONTROLREG_F2_G  ;
and1_625: n_826 <=  gnd;
dff_626: DFF_a8255

    PORT MAP ( D => a_LC8_A21_aD, CLK => a_LC8_A21_aCLK, CLRN => a_LC8_A21_aCLRN,
          PRN => vcc, Q => a_LC8_A21);
inv_627: a_LC8_A21_aCLRN  <= TRANSPORT NOT RESET  ;
xor2_628: a_LC8_A21_aD <=  n_833  XOR n_839;
or1_629: n_833 <=  n_834;
and4_630: n_834 <=  n_835  AND n_836  AND n_837  AND n_838;
delay_631: n_835  <= TRANSPORT a_LC4_A21  ;
delay_632: n_836  <= TRANSPORT a_N157  ;
delay_633: n_837  <= TRANSPORT a_LC3_A21  ;
delay_634: n_838  <= TRANSPORT a_LC1_A6  ;
and1_635: n_839 <=  gnd;
delay_636: n_840  <= TRANSPORT CLK  ;
filter_637: FILTER_a8255

    PORT MAP (IN1 => n_840, Y => a_LC8_A21_aCLK);
delay_638: a_N240  <= TRANSPORT a_EQ125  ;
xor2_639: a_EQ125 <=  n_844  XOR n_851;
or3_640: n_844 <=  n_845  OR n_847  OR n_849;
and1_641: n_845 <=  n_846;
inv_642: n_846  <= TRANSPORT NOT DIN(2)  ;
and1_643: n_847 <=  n_848;
delay_644: n_848  <= TRANSPORT DIN(7)  ;
and1_645: n_849 <=  n_850;
delay_646: n_850  <= TRANSPORT DIN(1)  ;
and1_647: n_851 <=  gnd;
delay_648: a_N229  <= TRANSPORT a_N229_aIN  ;
xor2_649: a_N229_aIN <=  n_854  XOR n_860;
or1_650: n_854 <=  n_855;
and4_651: n_855 <=  n_856  AND n_857  AND n_858  AND n_859;
delay_652: n_856  <= TRANSPORT a_N46  ;
delay_653: n_857  <= TRANSPORT DIN(0)  ;
inv_654: n_858  <= TRANSPORT NOT DIN(3)  ;
inv_655: n_859  <= TRANSPORT NOT a_N240  ;
and1_656: n_860 <=  gnd;
delay_657: a_N26  <= TRANSPORT a_EQ082  ;
xor2_658: a_EQ082 <=  n_863  XOR n_870;
or2_659: n_863 <=  n_864  OR n_867;
and2_660: n_864 <=  n_865  AND n_866;
delay_661: n_865  <= TRANSPORT a_N42  ;
inv_662: n_866  <= TRANSPORT NOT a_SCONTROLREG_F2_G  ;
and2_663: n_867 <=  n_868  AND n_869;
delay_664: n_868  <= TRANSPORT a_N42  ;
delay_665: n_869  <= TRANSPORT A(0)  ;
and1_666: n_870 <=  gnd;
delay_667: a_LC1_A2  <= TRANSPORT a_EQ133  ;
xor2_668: a_EQ133 <=  n_873  XOR n_882;
or3_669: n_873 <=  n_874  OR n_876  OR n_879;
and1_670: n_874 <=  n_875;
inv_671: n_875  <= TRANSPORT NOT a_N26  ;
and2_672: n_876 <=  n_877  AND n_878;
delay_673: n_877  <= TRANSPORT A(0)  ;
delay_674: n_878  <= TRANSPORT a_N240  ;
and2_675: n_879 <=  n_880  AND n_881;
delay_676: n_880  <= TRANSPORT A(0)  ;
delay_677: n_881  <= TRANSPORT DIN(3)  ;
and1_678: n_882 <=  gnd;
delay_679: a_N230  <= TRANSPORT a_N230_aIN  ;
xor2_680: a_N230_aIN <=  n_885  XOR n_891;
or1_681: n_885 <=  n_886;
and4_682: n_886 <=  n_887  AND n_888  AND n_889  AND n_890;
delay_683: n_887  <= TRANSPORT a_N42  ;
inv_684: n_888  <= TRANSPORT NOT A(0)  ;
delay_685: n_889  <= TRANSPORT DIN(2)  ;
inv_686: n_890  <= TRANSPORT NOT a_SCONTROLREG_F2_G  ;
and1_687: n_891 <=  gnd;
dff_688: DFF_a8255

    PORT MAP ( D => a_EQ023, CLK => a_LC6_A2_aCLK, CLRN => a_LC6_A2_aCLRN,
          PRN => vcc, Q => a_LC6_A2);
inv_689: a_LC6_A2_aCLRN  <= TRANSPORT NOT RESET  ;
xor2_690: a_EQ023 <=  n_898  XOR n_906;
or3_691: n_898 <=  n_899  OR n_901  OR n_904;
and1_692: n_899 <=  n_900;
delay_693: n_900  <= TRANSPORT a_N229  ;
and2_694: n_901 <=  n_902  AND n_903;
delay_695: n_902  <= TRANSPORT a_LC1_A2  ;
delay_696: n_903  <= TRANSPORT a_LC6_A2  ;
and1_697: n_904 <=  n_905;
delay_698: n_905  <= TRANSPORT a_N230  ;
and1_699: n_906 <=  gnd;
delay_700: n_907  <= TRANSPORT CLK  ;
filter_701: FILTER_a8255

    PORT MAP (IN1 => n_907, Y => a_LC6_A2_aCLK);
delay_702: a_LC2_A4  <= TRANSPORT a_EQ085  ;
xor2_703: a_EQ085 <=  n_911  XOR n_916;
or2_704: n_911 <=  n_912  OR n_914;
and1_705: n_912 <=  n_913;
delay_706: n_913  <= TRANSPORT DIN(0)  ;
and1_707: n_914 <=  n_915;
inv_708: n_915  <= TRANSPORT NOT a_N46  ;
and1_709: n_916 <=  gnd;
delay_710: a_LC2_B8  <= TRANSPORT a_EQ104  ;
xor2_711: a_EQ104 <=  n_919  XOR n_930;
or4_712: n_919 <=  n_920  OR n_923  OR n_926  OR n_928;
and1_713: n_920 <=  n_921;
delay_714: n_921  <= TRANSPORT a_SCONTROLREG_F6_G  ;
and1_715: n_923 <=  n_924;
delay_716: n_924  <= TRANSPORT a_SCONTROLREG_F5_G  ;
and1_717: n_926 <=  n_927;
delay_718: n_927  <= TRANSPORT A(0)  ;
and1_719: n_928 <=  n_929;
inv_720: n_929  <= TRANSPORT NOT a_N42  ;
and1_721: n_930 <=  gnd;
delay_722: a_N43  <= TRANSPORT a_N43_aIN  ;
xor2_723: a_N43_aIN <=  n_933  XOR n_938;
or1_724: n_933 <=  n_934;
and3_725: n_934 <=  n_935  AND n_936  AND n_937;
inv_726: n_935  <= TRANSPORT NOT DIN(7)  ;
delay_727: n_936  <= TRANSPORT DIN(2)  ;
delay_728: n_937  <= TRANSPORT DIN(1)  ;
and1_729: n_938 <=  gnd;
delay_730: a_LC4_A4  <= TRANSPORT a_EQ154  ;
xor2_731: a_EQ154 <=  n_941  XOR n_954;
or4_732: n_941 <=  n_942  OR n_945  OR n_948  OR n_951;
and2_733: n_942 <=  n_943  AND n_944;
delay_734: n_943  <= TRANSPORT a_LC2_A4  ;
delay_735: n_944  <= TRANSPORT a_LC2_B8  ;
and2_736: n_945 <=  n_946  AND n_947;
delay_737: n_946  <= TRANSPORT a_SCONTROLREG_F2_G  ;
delay_738: n_947  <= TRANSPORT a_LC2_A4  ;
and2_739: n_948 <=  n_949  AND n_950;
delay_740: n_949  <= TRANSPORT a_LC2_B8  ;
inv_741: n_950  <= TRANSPORT NOT a_N43  ;
and2_742: n_951 <=  n_952  AND n_953;
delay_743: n_952  <= TRANSPORT a_SCONTROLREG_F2_G  ;
inv_744: n_953  <= TRANSPORT NOT a_N43  ;
and1_745: n_954 <=  gnd;
dff_746: DFF_a8255

    PORT MAP ( D => a_N595_aD, CLK => a_N595_aCLK, CLRN => a_N595_aCLRN, PRN => vcc,
          Q => a_N595);
inv_747: a_N595_aCLRN  <= TRANSPORT NOT RESET  ;
xor2_748: a_N595_aD <=  n_963  XOR n_966;
or1_749: n_963 <=  n_964;
and1_750: n_964 <=  n_965;
delay_751: n_965  <= TRANSPORT PCin(6)  ;
and1_752: n_966 <=  gnd;
delay_753: n_967  <= TRANSPORT CLK  ;
filter_754: FILTER_a8255

    PORT MAP (IN1 => n_967, Y => a_N595_aCLK);
delay_755: a_N13  <= TRANSPORT a_N13_aIN  ;
xor2_756: a_N13_aIN <=  n_971  XOR n_976;
or1_757: n_971 <=  n_972;
and3_758: n_972 <=  n_973  AND n_974  AND n_975;
delay_759: n_973  <= TRANSPORT PCin(6)  ;
inv_760: n_974  <= TRANSPORT NOT a_N595  ;
delay_761: n_975  <= TRANSPORT a_LC6_B3  ;
and1_762: n_976 <=  gnd;
dff_763: DFF_a8255

    PORT MAP ( D => a_N594_aD, CLK => a_N594_aCLK, CLRN => a_N594_aCLRN, PRN => vcc,
          Q => a_N594);
inv_764: a_N594_aCLRN  <= TRANSPORT NOT RESET  ;
xor2_765: a_N594_aD <=  n_984  XOR n_988;
or1_766: n_984 <=  n_985;
and1_767: n_985 <=  n_986;
delay_768: n_986  <= TRANSPORT PCin(4)  ;
and1_769: n_988 <=  gnd;
delay_770: n_989  <= TRANSPORT CLK  ;
filter_771: FILTER_a8255

    PORT MAP (IN1 => n_989, Y => a_N594_aCLK);
delay_772: a_N18  <= TRANSPORT a_N18_aIN  ;
xor2_773: a_N18_aIN <=  n_993  XOR n_998;
or1_774: n_993 <=  n_994;
and3_775: n_994 <=  n_995  AND n_996  AND n_997;
delay_776: n_995  <= TRANSPORT PCin(4)  ;
inv_777: n_996  <= TRANSPORT NOT a_N594  ;
delay_778: n_997  <= TRANSPORT a_LC1_B19  ;
and1_779: n_998 <=  gnd;
delay_780: a_LC7_A9  <= TRANSPORT a_EQ155  ;
xor2_781: a_EQ155 <=  n_1001  XOR n_1015;
or4_782: n_1001 <=  n_1002  OR n_1005  OR n_1009  OR n_1012;
and2_783: n_1002 <=  n_1003  AND n_1004;
delay_784: n_1003  <= TRANSPORT a_SCONTROLREG_F6_G  ;
delay_785: n_1004  <= TRANSPORT a_N13  ;
and2_786: n_1005 <=  n_1006  AND n_1008;
delay_787: n_1006  <= TRANSPORT a_SCONTROLREG_F4_G_aNOT  ;
delay_788: n_1008  <= TRANSPORT a_N13  ;
and2_789: n_1009 <=  n_1010  AND n_1011;
delay_790: n_1010  <= TRANSPORT a_SCONTROLREG_F6_G  ;
delay_791: n_1011  <= TRANSPORT a_N18  ;
and2_792: n_1012 <=  n_1013  AND n_1014;
inv_793: n_1013  <= TRANSPORT NOT a_SCONTROLREG_F4_G_aNOT  ;
delay_794: n_1014  <= TRANSPORT a_N18  ;
and1_795: n_1015 <=  gnd;
delay_796: a_N199_aNOT  <= TRANSPORT a_EQ118  ;
xor2_797: a_EQ118 <=  n_1018  XOR n_1026;
or2_798: n_1018 <=  n_1019  OR n_1023;
and3_799: n_1019 <=  n_1020  AND n_1021  AND n_1022;
inv_800: n_1020  <= TRANSPORT NOT DIN(3)  ;
delay_801: n_1021  <= TRANSPORT a_N26  ;
delay_802: n_1022  <= TRANSPORT a_N43  ;
and2_803: n_1023 <=  n_1024  AND n_1025;
inv_804: n_1024  <= TRANSPORT NOT A(0)  ;
delay_805: n_1025  <= TRANSPORT a_N26  ;
and1_806: n_1026 <=  gnd;
delay_807: a_N44_aNOT  <= TRANSPORT a_EQ093  ;
xor2_808: a_EQ093 <=  n_1029  XOR n_1034;
or2_809: n_1029 <=  n_1030  OR n_1032;
and1_810: n_1030 <=  n_1031;
inv_811: n_1031  <= TRANSPORT NOT a_SCONTROLREG_F4_G_aNOT  ;
and1_812: n_1032 <=  n_1033;
inv_813: n_1033  <= TRANSPORT NOT a_SCONTROLREG_F5_G  ;
and1_814: n_1034 <=  gnd;
delay_815: a_N37_aNOT  <= TRANSPORT a_EQ088  ;
xor2_816: a_EQ088 <=  n_1037  XOR n_1044;
or3_817: n_1037 <=  n_1038  OR n_1040  OR n_1042;
and1_818: n_1038 <=  n_1039;
delay_819: n_1039  <= TRANSPORT a_SCONTROLREG_F6_G  ;
and1_820: n_1040 <=  n_1041;
delay_821: n_1041  <= TRANSPORT A(0)  ;
and1_822: n_1042 <=  n_1043;
delay_823: n_1043  <= TRANSPORT a_N44_aNOT  ;
and1_824: n_1044 <=  gnd;
delay_825: a_N19_aNOT  <= TRANSPORT a_EQ080  ;
xor2_826: a_EQ080 <=  n_1047  XOR n_1052;
or2_827: n_1047 <=  n_1048  OR n_1050;
and1_828: n_1048 <=  n_1049;
delay_829: n_1049  <= TRANSPORT a_SCONTROLREG_F6_G  ;
and1_830: n_1050 <=  n_1051;
delay_831: n_1051  <= TRANSPORT a_SCONTROLREG_F5_G  ;
and1_832: n_1052 <=  gnd;
delay_833: a_LC2_B17  <= TRANSPORT a_EQ156  ;
xor2_834: a_EQ156 <=  n_1055  XOR n_1068;
or4_835: n_1055 <=  n_1056  OR n_1059  OR n_1062  OR n_1065;
and2_836: n_1056 <=  n_1057  AND n_1058;
delay_837: n_1057  <= TRANSPORT a_N199_aNOT  ;
delay_838: n_1058  <= TRANSPORT a_N37_aNOT  ;
and2_839: n_1059 <=  n_1060  AND n_1061;
delay_840: n_1060  <= TRANSPORT a_N37_aNOT  ;
delay_841: n_1061  <= TRANSPORT a_N19_aNOT  ;
and2_842: n_1062 <=  n_1063  AND n_1064;
delay_843: n_1063  <= TRANSPORT a_N13  ;
delay_844: n_1064  <= TRANSPORT a_N199_aNOT  ;
and2_845: n_1065 <=  n_1066  AND n_1067;
delay_846: n_1066  <= TRANSPORT a_N13  ;
delay_847: n_1067  <= TRANSPORT a_N19_aNOT  ;
and1_848: n_1068 <=  gnd;
delay_849: a_N67  <= TRANSPORT a_N67_aIN  ;
xor2_850: a_N67_aIN <=  n_1071  XOR n_1077;
or2_851: n_1071 <=  n_1072  OR n_1075;
and2_852: n_1072 <=  n_1073  AND n_1074;
inv_853: n_1073  <= TRANSPORT NOT DIN(3)  ;
delay_854: n_1074  <= TRANSPORT a_N43  ;
and1_855: n_1075 <=  n_1076;
inv_856: n_1076  <= TRANSPORT NOT A(0)  ;
and1_857: n_1077 <=  gnd;
delay_858: a_LC6_A9  <= TRANSPORT a_EQ157  ;
xor2_859: a_EQ157 <=  n_1080  XOR n_1088;
or2_860: n_1080 <=  n_1081  OR n_1084;
and2_861: n_1081 <=  n_1082  AND n_1083;
delay_862: n_1082  <= TRANSPORT a_LC7_A9  ;
delay_863: n_1083  <= TRANSPORT a_LC2_B17  ;
and3_864: n_1084 <=  n_1085  AND n_1086  AND n_1087;
delay_865: n_1085  <= TRANSPORT a_N42  ;
delay_866: n_1086  <= TRANSPORT a_LC2_B17  ;
delay_867: n_1087  <= TRANSPORT a_N67  ;
and1_868: n_1088 <=  gnd;
delay_869: a_N45_aNOT  <= TRANSPORT a_EQ094  ;
xor2_870: a_EQ094 <=  n_1091  XOR n_1096;
or2_871: n_1091 <=  n_1092  OR n_1094;
and1_872: n_1092 <=  n_1093;
delay_873: n_1093  <= TRANSPORT a_SCONTROLREG_F4_G_aNOT  ;
and1_874: n_1094 <=  n_1095;
inv_875: n_1095  <= TRANSPORT NOT a_SCONTROLREG_F5_G  ;
and1_876: n_1096 <=  gnd;
delay_877: a_N11  <= TRANSPORT a_N11_aIN  ;
xor2_878: a_N11_aIN <=  n_1099  XOR n_1103;
or1_879: n_1099 <=  n_1100;
and2_880: n_1100 <=  n_1101  AND n_1102;
inv_881: n_1101  <= TRANSPORT NOT a_SCONTROLREG_F6_G  ;
delay_882: n_1102  <= TRANSPORT a_N45_aNOT  ;
and1_883: n_1103 <=  gnd;
delay_884: a_LC5_A9  <= TRANSPORT a_EQ119  ;
xor2_885: a_EQ119 <=  n_1106  XOR n_1112;
or2_886: n_1106 <=  n_1107  OR n_1109;
and1_887: n_1107 <=  n_1108;
delay_888: n_1108  <= TRANSPORT a_N11  ;
and2_889: n_1109 <=  n_1110  AND n_1111;
delay_890: n_1110  <= TRANSPORT a_SCONTROLREG_F6_G  ;
delay_891: n_1111  <= TRANSPORT a_N13  ;
and1_892: n_1112 <=  gnd;
delay_893: a_LC2_A9  <= TRANSPORT a_EQ158  ;
xor2_894: a_EQ158 <=  n_1115  XOR n_1125;
or3_895: n_1115 <=  n_1116  OR n_1119  OR n_1122;
and2_896: n_1116 <=  n_1117  AND n_1118;
delay_897: n_1117  <= TRANSPORT a_LC6_A9  ;
delay_898: n_1118  <= TRANSPORT a_LC5_A9  ;
and2_899: n_1119 <=  n_1120  AND n_1121;
delay_900: n_1120  <= TRANSPORT a_N18  ;
delay_901: n_1121  <= TRANSPORT a_LC6_A9  ;
and2_902: n_1122 <=  n_1123  AND n_1124;
delay_903: n_1123  <= TRANSPORT A(0)  ;
delay_904: n_1124  <= TRANSPORT a_LC6_A9  ;
and1_905: n_1125 <=  gnd;
delay_906: a_LC3_A4  <= TRANSPORT a_EQ159  ;
xor2_907: a_EQ159 <=  n_1128  XOR n_1141;
or4_908: n_1128 <=  n_1129  OR n_1132  OR n_1135  OR n_1138;
and2_909: n_1129 <=  n_1130  AND n_1131;
delay_910: n_1130  <= TRANSPORT a_LC4_A4  ;
delay_911: n_1131  <= TRANSPORT a_LC8_A4  ;
and2_912: n_1132 <=  n_1133  AND n_1134;
delay_913: n_1133  <= TRANSPORT a_LC4_A4  ;
delay_914: n_1134  <= TRANSPORT a_LC2_A9  ;
and2_915: n_1135 <=  n_1136  AND n_1137;
delay_916: n_1136  <= TRANSPORT DIN(3)  ;
delay_917: n_1137  <= TRANSPORT a_LC8_A4  ;
and2_918: n_1138 <=  n_1139  AND n_1140;
delay_919: n_1139  <= TRANSPORT DIN(3)  ;
delay_920: n_1140  <= TRANSPORT a_LC2_A9  ;
and1_921: n_1141 <=  gnd;
delay_922: a_LC7_A20_aNOT  <= TRANSPORT a_EQ106  ;
xor2_923: a_EQ106 <=  n_1144  XOR n_1149;
or2_924: n_1144 <=  n_1145  OR n_1147;
and1_925: n_1145 <=  n_1146;
inv_926: n_1146  <= TRANSPORT NOT a_SCONTROLREG_F6_G  ;
and1_927: n_1147 <=  n_1148;
delay_928: n_1148  <= TRANSPORT A(0)  ;
and1_929: n_1149 <=  gnd;
delay_930: portaread  <= TRANSPORT a_EQ165  ;
xor2_931: a_EQ165 <=  n_1152  XOR n_1161;
or4_932: n_1152 <=  n_1153  OR n_1155  OR n_1157  OR n_1159;
and1_933: n_1153 <=  n_1154;
delay_934: n_1154  <= TRANSPORT A(1)  ;
and1_935: n_1155 <=  n_1156;
delay_936: n_1156  <= TRANSPORT A(0)  ;
and1_937: n_1157 <=  n_1158;
delay_938: n_1158  <= TRANSPORT nRD  ;
and1_939: n_1159 <=  n_1160;
delay_940: n_1160  <= TRANSPORT nCS  ;
and1_941: n_1161 <=  gnd;
delay_942: a_LC3_A9_aNOT  <= TRANSPORT a_EQ075  ;
xor2_943: a_EQ075 <=  n_1164  XOR n_1169;
or2_944: n_1164 <=  n_1165  OR n_1167;
and1_945: n_1165 <=  n_1166;
delay_946: n_1166  <= TRANSPORT a_N594  ;
and1_947: n_1167 <=  n_1168;
inv_948: n_1168  <= TRANSPORT NOT PCin(4)  ;
and1_949: n_1169 <=  gnd;
delay_950: a_N33  <= TRANSPORT a_N33_aIN  ;
xor2_951: a_N33_aIN <=  n_1172  XOR n_1178;
or1_952: n_1172 <=  n_1173;
and4_953: n_1173 <=  n_1174  AND n_1175  AND n_1176  AND n_1177;
delay_954: n_1174  <= TRANSPORT a_N42  ;
delay_955: n_1175  <= TRANSPORT A(0)  ;
inv_956: n_1176  <= TRANSPORT NOT DIN(3)  ;
delay_957: n_1177  <= TRANSPORT a_N43  ;
and1_958: n_1178 <=  gnd;
delay_959: a_LC4_A9  <= TRANSPORT a_EQ102  ;
xor2_960: a_EQ102 <=  n_1181  XOR n_1190;
or4_961: n_1181 <=  n_1182  OR n_1184  OR n_1186  OR n_1188;
and1_962: n_1182 <=  n_1183;
delay_963: n_1183  <= TRANSPORT a_LC4_A1  ;
and1_964: n_1184 <=  n_1185;
delay_965: n_1185  <= TRANSPORT a_LC3_A9_aNOT  ;
and1_966: n_1186 <=  n_1187;
delay_967: n_1187  <= TRANSPORT a_N33  ;
and1_968: n_1188 <=  n_1189;
delay_969: n_1189  <= TRANSPORT a_LC5_A9  ;
and1_970: n_1190 <=  gnd;
delay_971: a_LC8_A20  <= TRANSPORT a_EQ152  ;
xor2_972: a_EQ152 <=  n_1193  XOR n_1202;
or3_973: n_1193 <=  n_1194  OR n_1196  OR n_1199;
and1_974: n_1194 <=  n_1195;
inv_975: n_1195  <= TRANSPORT NOT a_LC1_B19  ;
and2_976: n_1196 <=  n_1197  AND n_1198;
delay_977: n_1197  <= TRANSPORT portaread  ;
delay_978: n_1198  <= TRANSPORT a_LC4_A9  ;
and2_979: n_1199 <=  n_1200  AND n_1201;
delay_980: n_1200  <= TRANSPORT a_N45_aNOT  ;
delay_981: n_1201  <= TRANSPORT a_LC4_A9  ;
and1_982: n_1202 <=  gnd;
delay_983: a_N17_aNOT  <= TRANSPORT a_EQ074  ;
xor2_984: a_EQ074 <=  n_1205  XOR n_1210;
or2_985: n_1205 <=  n_1206  OR n_1208;
and1_986: n_1206 <=  n_1207;
delay_987: n_1207  <= TRANSPORT nRD  ;
and1_988: n_1208 <=  n_1209;
delay_989: n_1209  <= TRANSPORT nCS  ;
and1_990: n_1210 <=  gnd;
delay_991: a_LC6_A20  <= TRANSPORT a_EQ153  ;
xor2_992: a_EQ153 <=  n_1213  XOR n_1223;
or3_993: n_1213 <=  n_1214  OR n_1217  OR n_1220;
and2_994: n_1214 <=  n_1215  AND n_1216;
delay_995: n_1215  <= TRANSPORT a_LC7_A20_aNOT  ;
delay_996: n_1216  <= TRANSPORT a_LC8_A20  ;
and2_997: n_1217 <=  n_1218  AND n_1219;
delay_998: n_1218  <= TRANSPORT a_LC8_A20  ;
delay_999: n_1219  <= TRANSPORT a_N17_aNOT  ;
and2_1000: n_1220 <=  n_1221  AND n_1222;
delay_1001: n_1221  <= TRANSPORT A(1)  ;
delay_1002: n_1222  <= TRANSPORT a_LC8_A20  ;
and1_1003: n_1223 <=  gnd;
delay_1004: a_N12  <= TRANSPORT a_N12_aIN  ;
xor2_1005: a_N12_aIN <=  n_1226  XOR n_1230;
or1_1006: n_1226 <=  n_1227;
and2_1007: n_1227 <=  n_1228  AND n_1229;
inv_1008: n_1228  <= TRANSPORT NOT a_SCONTROLREG_F6_G  ;
delay_1009: n_1229  <= TRANSPORT a_N44_aNOT  ;
and1_1010: n_1230 <=  gnd;
delay_1011: a_N347_aNOT  <= TRANSPORT a_EQ140  ;
xor2_1012: a_EQ140 <=  n_1233  XOR n_1242;
or4_1013: n_1233 <=  n_1234  OR n_1236  OR n_1238  OR n_1240;
and1_1014: n_1234 <=  n_1235;
delay_1015: n_1235  <= TRANSPORT A(1)  ;
and1_1016: n_1236 <=  n_1237;
delay_1017: n_1237  <= TRANSPORT A(0)  ;
and1_1018: n_1238 <=  n_1239;
delay_1019: n_1239  <= TRANSPORT nCS  ;
and1_1020: n_1240 <=  n_1241;
delay_1021: n_1241  <= TRANSPORT nWR  ;
and1_1022: n_1242 <=  gnd;
delay_1023: a_LC1_A4  <= TRANSPORT a_EQ160  ;
xor2_1024: a_EQ160 <=  n_1245  XOR n_1255;
or3_1025: n_1245 <=  n_1246  OR n_1249  OR n_1252;
and2_1026: n_1246 <=  n_1247  AND n_1248;
delay_1027: n_1247  <= TRANSPORT a_N33  ;
delay_1028: n_1248  <= TRANSPORT a_N347_aNOT  ;
and2_1029: n_1249 <=  n_1250  AND n_1251;
delay_1030: n_1250  <= TRANSPORT a_N347_aNOT  ;
delay_1031: n_1251  <= TRANSPORT a_LC2_A1  ;
and2_1032: n_1252 <=  n_1253  AND n_1254;
inv_1033: n_1253  <= TRANSPORT NOT a_N13  ;
delay_1034: n_1254  <= TRANSPORT a_N347_aNOT  ;
and1_1035: n_1255 <=  gnd;
dff_1036: DFF_a8255

    PORT MAP ( D => a_EQ022, CLK => a_LC8_A4_aCLK, CLRN => a_LC8_A4_aCLRN,
          PRN => vcc, Q => a_LC8_A4);
inv_1037: a_LC8_A4_aCLRN  <= TRANSPORT NOT RESET  ;
xor2_1038: a_EQ022 <=  n_1262  XOR n_1271;
or2_1039: n_1262 <=  n_1263  OR n_1267;
and3_1040: n_1263 <=  n_1264  AND n_1265  AND n_1266;
delay_1041: n_1264  <= TRANSPORT a_LC3_A4  ;
delay_1042: n_1265  <= TRANSPORT a_LC6_A20  ;
delay_1043: n_1266  <= TRANSPORT a_N12  ;
and3_1044: n_1267 <=  n_1268  AND n_1269  AND n_1270;
delay_1045: n_1268  <= TRANSPORT a_LC3_A4  ;
delay_1046: n_1269  <= TRANSPORT a_LC6_A20  ;
delay_1047: n_1270  <= TRANSPORT a_LC1_A4  ;
and1_1048: n_1271 <=  gnd;
delay_1049: n_1272  <= TRANSPORT CLK  ;
filter_1050: FILTER_a8255

    PORT MAP (IN1 => n_1272, Y => a_LC8_A4_aCLK);
delay_1051: a_N54  <= TRANSPORT a_EQ099  ;
xor2_1052: a_EQ099 <=  n_1276  XOR n_1282;
or2_1053: n_1276 <=  n_1277  OR n_1280;
and2_1054: n_1277 <=  n_1278  AND n_1279;
delay_1055: n_1278  <= TRANSPORT A(0)  ;
inv_1056: n_1279  <= TRANSPORT NOT DIN(3)  ;
and1_1057: n_1280 <=  n_1281;
inv_1058: n_1281  <= TRANSPORT NOT a_N42  ;
and1_1059: n_1282 <=  gnd;
delay_1060: a_N23_aNOT  <= TRANSPORT a_N23_aNOT_aIN  ;
xor2_1061: a_N23_aNOT_aIN <=  n_1285  XOR n_1294;
or3_1062: n_1285 <=  n_1286  OR n_1288  OR n_1291;
and1_1063: n_1286 <=  n_1287;
delay_1064: n_1287  <= TRANSPORT a_N54  ;
and2_1065: n_1288 <=  n_1289  AND n_1290;
inv_1066: n_1289  <= TRANSPORT NOT A(0)  ;
delay_1067: n_1290  <= TRANSPORT a_SCONTROLREG_F6_G  ;
and2_1068: n_1291 <=  n_1292  AND n_1293;
delay_1069: n_1292  <= TRANSPORT a_SCONTROLREG_F5_G  ;
inv_1070: n_1293  <= TRANSPORT NOT A(0)  ;
and1_1071: n_1294 <=  gnd;
delay_1072: a_N241  <= TRANSPORT a_EQ126  ;
xor2_1073: a_EQ126 <=  n_1297  XOR n_1304;
or3_1074: n_1297 <=  n_1298  OR n_1300  OR n_1302;
and1_1075: n_1298 <=  n_1299;
delay_1076: n_1299  <= TRANSPORT DIN(2)  ;
and1_1077: n_1300 <=  n_1301;
delay_1078: n_1301  <= TRANSPORT DIN(7)  ;
and1_1079: n_1302 <=  n_1303;
delay_1080: n_1303  <= TRANSPORT DIN(1)  ;
and1_1081: n_1304 <=  gnd;
delay_1082: a_LC6_A1  <= TRANSPORT a_EQ151  ;
xor2_1083: a_EQ151 <=  n_1307  XOR n_1315;
or2_1084: n_1307 <=  n_1308  OR n_1311;
and2_1085: n_1308 <=  n_1309  AND n_1310;
delay_1086: n_1309  <= TRANSPORT a_N23_aNOT  ;
delay_1087: n_1310  <= TRANSPORT a_LC4_A1  ;
and3_1088: n_1311 <=  n_1312  AND n_1313  AND n_1314;
delay_1089: n_1312  <= TRANSPORT A(0)  ;
delay_1090: n_1313  <= TRANSPORT a_N241  ;
delay_1091: n_1314  <= TRANSPORT a_LC4_A1  ;
and1_1092: n_1315 <=  gnd;
delay_1093: a_LC8_A1  <= TRANSPORT a_LC8_A1_aIN  ;
xor2_1094: a_LC8_A1_aIN <=  n_1318  XOR n_1323;
or1_1095: n_1318 <=  n_1319;
and3_1096: n_1319 <=  n_1320  AND n_1321  AND n_1322;
delay_1097: n_1320  <= TRANSPORT a_N46  ;
delay_1098: n_1321  <= TRANSPORT DIN(0)  ;
delay_1099: n_1322  <= TRANSPORT DIN(3)  ;
and1_1100: n_1323 <=  gnd;
delay_1101: a_N232  <= TRANSPORT a_N232_aIN  ;
xor2_1102: a_N232_aIN <=  n_1326  XOR n_1332;
or1_1103: n_1326 <=  n_1327;
and4_1104: n_1327 <=  n_1328  AND n_1329  AND n_1330  AND n_1331;
inv_1105: n_1328  <= TRANSPORT NOT DIN(7)  ;
inv_1106: n_1329  <= TRANSPORT NOT DIN(2)  ;
inv_1107: n_1330  <= TRANSPORT NOT DIN(1)  ;
delay_1108: n_1331  <= TRANSPORT a_LC8_A1  ;
and1_1109: n_1332 <=  gnd;
dff_1110: DFF_a8255

    PORT MAP ( D => a_EQ021, CLK => a_LC4_A1_aCLK, CLRN => a_LC4_A1_aCLRN,
          PRN => vcc, Q => a_LC4_A1);
inv_1111: a_LC4_A1_aCLRN  <= TRANSPORT NOT RESET  ;
xor2_1112: a_EQ021 <=  n_1339  XOR n_1348;
or3_1113: n_1339 <=  n_1340  OR n_1342  OR n_1344;
and1_1114: n_1340 <=  n_1341;
delay_1115: n_1341  <= TRANSPORT a_LC6_A1  ;
and1_1116: n_1342 <=  n_1343;
delay_1117: n_1343  <= TRANSPORT a_N232  ;
and2_1118: n_1344 <=  n_1345  AND n_1347;
delay_1119: n_1345  <= TRANSPORT DIN(4)  ;
inv_1120: n_1347  <= TRANSPORT NOT a_LC2_B8  ;
and1_1121: n_1348 <=  gnd;
delay_1122: n_1349  <= TRANSPORT CLK  ;
filter_1123: FILTER_a8255

    PORT MAP (IN1 => n_1349, Y => a_LC4_A1_aCLK);
dff_1124: DFF_a8255

    PORT MAP ( D => a_N597_aD, CLK => a_N597_aCLK, CLRN => a_N597_aCLRN, PRN => vcc,
          Q => a_N597);
inv_1125: a_N597_aCLRN  <= TRANSPORT NOT RESET  ;
xor2_1126: a_N597_aD <=  n_1358  XOR n_1367;
or4_1127: n_1358 <=  n_1359  OR n_1361  OR n_1363  OR n_1365;
and1_1128: n_1359 <=  n_1360;
delay_1129: n_1360  <= TRANSPORT A(1)  ;
and1_1130: n_1361 <=  n_1362;
delay_1131: n_1362  <= TRANSPORT A(0)  ;
and1_1132: n_1363 <=  n_1364;
delay_1133: n_1364  <= TRANSPORT nRD  ;
and1_1134: n_1365 <=  n_1366;
delay_1135: n_1366  <= TRANSPORT nCS  ;
and1_1136: n_1367 <=  gnd;
delay_1137: n_1368  <= TRANSPORT CLK  ;
filter_1138: FILTER_a8255

    PORT MAP (IN1 => n_1368, Y => a_N597_aCLK);
delay_1139: a_N21_aNOT  <= TRANSPORT a_EQ079  ;
xor2_1140: a_EQ079 <=  n_1372  XOR n_1379;
or3_1141: n_1372 <=  n_1373  OR n_1375  OR n_1377;
and1_1142: n_1373 <=  n_1374;
delay_1143: n_1374  <= TRANSPORT DIN(2)  ;
and1_1144: n_1375 <=  n_1376;
delay_1145: n_1376  <= TRANSPORT DIN(7)  ;
and1_1146: n_1377 <=  n_1378;
inv_1147: n_1378  <= TRANSPORT NOT DIN(1)  ;
and1_1148: n_1379 <=  gnd;
delay_1149: a_LC1_A19  <= TRANSPORT a_EQ129  ;
xor2_1150: a_EQ129 <=  n_1382  XOR n_1391;
or2_1151: n_1382 <=  n_1383  OR n_1386;
and2_1152: n_1383 <=  n_1384  AND n_1385;
inv_1153: n_1384  <= TRANSPORT NOT A(1)  ;
inv_1154: n_1385  <= TRANSPORT NOT A(0)  ;
and4_1155: n_1386 <=  n_1387  AND n_1388  AND n_1389  AND n_1390;
delay_1156: n_1387  <= TRANSPORT A(1)  ;
delay_1157: n_1388  <= TRANSPORT A(0)  ;
delay_1158: n_1389  <= TRANSPORT DIN(3)  ;
inv_1159: n_1390  <= TRANSPORT NOT a_N21_aNOT  ;
and1_1160: n_1391 <=  gnd;
delay_1161: a_LC4_A19  <= TRANSPORT a_EQ127  ;
xor2_1162: a_EQ127 <=  n_1394  XOR n_1402;
or3_1163: n_1394 <=  n_1395  OR n_1397  OR n_1400;
and1_1164: n_1395 <=  n_1396;
delay_1165: n_1396  <= TRANSPORT a_N597  ;
and2_1166: n_1397 <=  n_1398  AND n_1399;
delay_1167: n_1398  <= TRANSPORT a_N56_aNOT  ;
delay_1168: n_1399  <= TRANSPORT a_LC1_A19  ;
and1_1169: n_1400 <=  n_1401;
delay_1170: n_1401  <= TRANSPORT a_LC8_A4  ;
and1_1171: n_1402 <=  gnd;
delay_1172: a_N39_aNOT  <= TRANSPORT a_EQ090  ;
xor2_1173: a_EQ090 <=  n_1405  XOR n_1414;
or4_1174: n_1405 <=  n_1406  OR n_1408  OR n_1410  OR n_1412;
and1_1175: n_1406 <=  n_1407;
inv_1176: n_1407  <= TRANSPORT NOT A(0)  ;
and1_1177: n_1408 <=  n_1409;
inv_1178: n_1409  <= TRANSPORT NOT a_N42  ;
and1_1179: n_1410 <=  n_1411;
inv_1180: n_1411  <= TRANSPORT NOT DIN(3)  ;
and1_1181: n_1412 <=  n_1413;
delay_1182: n_1413  <= TRANSPORT DIN(0)  ;
and1_1183: n_1414 <=  gnd;
delay_1184: a_LC7_B19  <= TRANSPORT a_EQ148  ;
xor2_1185: a_EQ148 <=  n_1417  XOR n_1431;
or4_1186: n_1417 <=  n_1418  OR n_1421  OR n_1425  OR n_1428;
and2_1187: n_1418 <=  n_1419  AND n_1420;
delay_1188: n_1419  <= TRANSPORT a_LC2_B8  ;
delay_1189: n_1420  <= TRANSPORT a_N39_aNOT  ;
and2_1190: n_1421 <=  n_1422  AND n_1424;
delay_1191: n_1422  <= TRANSPORT DIN(5)  ;
delay_1192: n_1424  <= TRANSPORT a_N39_aNOT  ;
and2_1193: n_1425 <=  n_1426  AND n_1427;
delay_1194: n_1426  <= TRANSPORT a_LC2_B8  ;
delay_1195: n_1427  <= TRANSPORT a_N21_aNOT  ;
and2_1196: n_1428 <=  n_1429  AND n_1430;
delay_1197: n_1429  <= TRANSPORT DIN(5)  ;
delay_1198: n_1430  <= TRANSPORT a_N21_aNOT  ;
and1_1199: n_1431 <=  gnd;
delay_1200: a_LC2_B19  <= TRANSPORT a_EQ128  ;
xor2_1201: a_EQ128 <=  n_1434  XOR n_1442;
or3_1202: n_1434 <=  n_1435  OR n_1438  OR n_1440;
and2_1203: n_1435 <=  n_1436  AND n_1437;
inv_1204: n_1436  <= TRANSPORT NOT PCin(4)  ;
inv_1205: n_1437  <= TRANSPORT NOT a_N11  ;
and1_1206: n_1438 <=  n_1439;
inv_1207: n_1439  <= TRANSPORT NOT a_N21_aNOT  ;
and1_1208: n_1440 <=  n_1441;
inv_1209: n_1441  <= TRANSPORT NOT A(0)  ;
and1_1210: n_1442 <=  gnd;
delay_1211: a_LC5_B19  <= TRANSPORT a_EQ149  ;
xor2_1212: a_EQ149 <=  n_1445  XOR n_1454;
or2_1213: n_1445 <=  n_1446  OR n_1450;
and3_1214: n_1446 <=  n_1447  AND n_1448  AND n_1449;
delay_1215: n_1447  <= TRANSPORT a_N37_aNOT  ;
inv_1216: n_1448  <= TRANSPORT NOT a_N23_aNOT  ;
delay_1217: n_1449  <= TRANSPORT a_LC2_B19  ;
and3_1218: n_1450 <=  n_1451  AND n_1452  AND n_1453;
inv_1219: n_1451  <= TRANSPORT NOT PCin(4)  ;
delay_1220: n_1452  <= TRANSPORT a_N37_aNOT  ;
delay_1221: n_1453  <= TRANSPORT a_LC2_B19  ;
and1_1222: n_1454 <=  gnd;
delay_1223: a_LC4_B19  <= TRANSPORT a_EQ150  ;
xor2_1224: a_EQ150 <=  n_1457  XOR n_1466;
or3_1225: n_1457 <=  n_1458  OR n_1460  OR n_1463;
and1_1226: n_1458 <=  n_1459;
delay_1227: n_1459  <= TRANSPORT a_LC1_B19  ;
and2_1228: n_1460 <=  n_1461  AND n_1462;
inv_1229: n_1461  <= TRANSPORT NOT a_N54  ;
delay_1230: n_1462  <= TRANSPORT a_LC5_B19  ;
and2_1231: n_1463 <=  n_1464  AND n_1465;
inv_1232: n_1464  <= TRANSPORT NOT a_N11  ;
delay_1233: n_1465  <= TRANSPORT a_LC5_B19  ;
and1_1234: n_1466 <=  gnd;
dff_1235: DFF_a8255

    PORT MAP ( D => a_EQ020, CLK => a_LC1_B19_aCLK, CLRN => a_LC1_B19_aCLRN,
          PRN => vcc, Q => a_LC1_B19);
inv_1236: a_LC1_B19_aCLRN  <= TRANSPORT NOT RESET  ;
xor2_1237: a_EQ020 <=  n_1473  XOR n_1482;
or2_1238: n_1473 <=  n_1474  OR n_1478;
and3_1239: n_1474 <=  n_1475  AND n_1476  AND n_1477;
delay_1240: n_1475  <= TRANSPORT a_LC4_A19  ;
delay_1241: n_1476  <= TRANSPORT a_LC7_B19  ;
delay_1242: n_1477  <= TRANSPORT a_LC4_B19  ;
and3_1243: n_1478 <=  n_1479  AND n_1480  AND n_1481;
delay_1244: n_1479  <= TRANSPORT a_N11  ;
delay_1245: n_1480  <= TRANSPORT a_LC7_B19  ;
delay_1246: n_1481  <= TRANSPORT a_LC4_B19  ;
and1_1247: n_1482 <=  gnd;
delay_1248: n_1483  <= TRANSPORT CLK  ;
filter_1249: FILTER_a8255

    PORT MAP (IN1 => n_1483, Y => a_LC1_B19_aCLK);
delay_1250: a_LC1_A1  <= TRANSPORT a_EQ147  ;
xor2_1251: a_EQ147 <=  n_1487  XOR n_1495;
or2_1252: n_1487 <=  n_1488  OR n_1492;
and2_1253: n_1488 <=  n_1489  AND n_1491;
delay_1254: n_1489  <= TRANSPORT DIN(6)  ;
inv_1255: n_1491  <= TRANSPORT NOT a_LC2_B8  ;
and2_1256: n_1492 <=  n_1493  AND n_1494;
inv_1257: n_1493  <= TRANSPORT NOT a_N240  ;
delay_1258: n_1494  <= TRANSPORT a_LC8_A1  ;
and1_1259: n_1495 <=  gnd;
delay_1260: a_LC5_A1  <= TRANSPORT a_EQ124  ;
xor2_1261: a_EQ124 <=  n_1498  XOR n_1508;
or3_1262: n_1498 <=  n_1499  OR n_1502  OR n_1505;
and2_1263: n_1499 <=  n_1500  AND n_1501;
delay_1264: n_1500  <= TRANSPORT A(0)  ;
inv_1265: n_1501  <= TRANSPORT NOT DIN(2)  ;
and2_1266: n_1502 <=  n_1503  AND n_1504;
delay_1267: n_1503  <= TRANSPORT A(0)  ;
delay_1268: n_1504  <= TRANSPORT DIN(7)  ;
and2_1269: n_1505 <=  n_1506  AND n_1507;
delay_1270: n_1506  <= TRANSPORT A(0)  ;
delay_1271: n_1507  <= TRANSPORT DIN(1)  ;
and1_1272: n_1508 <=  gnd;
dff_1273: DFF_a8255

    PORT MAP ( D => a_EQ019, CLK => a_LC2_A1_aCLK, CLRN => a_LC2_A1_aCLRN,
          PRN => vcc, Q => a_LC2_A1);
inv_1274: a_LC2_A1_aCLRN  <= TRANSPORT NOT RESET  ;
xor2_1275: a_EQ019 <=  n_1515  XOR n_1524;
or3_1276: n_1515 <=  n_1516  OR n_1518  OR n_1521;
and1_1277: n_1516 <=  n_1517;
delay_1278: n_1517  <= TRANSPORT a_LC1_A1  ;
and2_1279: n_1518 <=  n_1519  AND n_1520;
delay_1280: n_1519  <= TRANSPORT a_LC5_A1  ;
delay_1281: n_1520  <= TRANSPORT a_LC2_A1  ;
and2_1282: n_1521 <=  n_1522  AND n_1523;
delay_1283: n_1522  <= TRANSPORT a_N23_aNOT  ;
delay_1284: n_1523  <= TRANSPORT a_LC2_A1  ;
and1_1285: n_1524 <=  gnd;
delay_1286: n_1525  <= TRANSPORT CLK  ;
filter_1287: FILTER_a8255

    PORT MAP (IN1 => n_1525, Y => a_LC2_A1_aCLK);
delay_1288: a_LC8_B3  <= TRANSPORT a_EQ142  ;
xor2_1289: a_EQ142 <=  n_1529  XOR n_1542;
or4_1290: n_1529 <=  n_1530  OR n_1533  OR n_1536  OR n_1539;
and2_1291: n_1530 <=  n_1531  AND n_1532;
delay_1292: n_1531  <= TRANSPORT a_N43  ;
inv_1293: n_1532  <= TRANSPORT NOT a_N23_aNOT  ;
and2_1294: n_1533 <=  n_1534  AND n_1535;
delay_1295: n_1534  <= TRANSPORT a_N43  ;
inv_1296: n_1535  <= TRANSPORT NOT a_N347_aNOT  ;
and2_1297: n_1536 <=  n_1537  AND n_1538;
inv_1298: n_1537  <= TRANSPORT NOT A(1)  ;
inv_1299: n_1538  <= TRANSPORT NOT a_N23_aNOT  ;
and2_1300: n_1539 <=  n_1540  AND n_1541;
inv_1301: n_1540  <= TRANSPORT NOT A(1)  ;
inv_1302: n_1541  <= TRANSPORT NOT a_N347_aNOT  ;
and1_1303: n_1542 <=  gnd;
delay_1304: a_LC6_B19  <= TRANSPORT a_EQ143  ;
xor2_1305: a_EQ143 <=  n_1545  XOR n_1555;
or3_1306: n_1545 <=  n_1546  OR n_1549  OR n_1552;
and2_1307: n_1546 <=  n_1547  AND n_1548;
inv_1308: n_1547  <= TRANSPORT NOT DIN(1)  ;
delay_1309: n_1548  <= TRANSPORT a_LC2_B8  ;
and2_1310: n_1549 <=  n_1550  AND n_1551;
inv_1311: n_1550  <= TRANSPORT NOT DIN(2)  ;
delay_1312: n_1551  <= TRANSPORT a_LC2_B8  ;
and2_1313: n_1552 <=  n_1553  AND n_1554;
delay_1314: n_1553  <= TRANSPORT a_LC2_B8  ;
delay_1315: n_1554  <= TRANSPORT a_N39_aNOT  ;
and1_1316: n_1555 <=  gnd;
delay_1317: a_N38_aNOT  <= TRANSPORT a_EQ089  ;
xor2_1318: a_EQ089 <=  n_1558  XOR n_1563;
or2_1319: n_1558 <=  n_1559  OR n_1561;
and1_1320: n_1559 <=  n_1560;
delay_1321: n_1560  <= TRANSPORT a_SCONTROLREG_F6_G  ;
and1_1322: n_1561 <=  n_1562;
delay_1323: n_1562  <= TRANSPORT A(0)  ;
and1_1324: n_1563 <=  gnd;
delay_1325: a_LC4_B3  <= TRANSPORT a_EQ144  ;
xor2_1326: a_EQ144 <=  n_1566  XOR n_1579;
or4_1327: n_1566 <=  n_1567  OR n_1570  OR n_1573  OR n_1576;
and2_1328: n_1567 <=  n_1568  AND n_1569;
inv_1329: n_1568  <= TRANSPORT NOT a_N23_aNOT  ;
delay_1330: n_1569  <= TRANSPORT a_N38_aNOT  ;
and2_1331: n_1570 <=  n_1571  AND n_1572;
inv_1332: n_1571  <= TRANSPORT NOT PCin(6)  ;
delay_1333: n_1572  <= TRANSPORT a_N38_aNOT  ;
and2_1334: n_1573 <=  n_1574  AND n_1575;
delay_1335: n_1574  <= TRANSPORT a_N45_aNOT  ;
inv_1336: n_1575  <= TRANSPORT NOT a_N23_aNOT  ;
and2_1337: n_1576 <=  n_1577  AND n_1578;
inv_1338: n_1577  <= TRANSPORT NOT PCin(6)  ;
delay_1339: n_1578  <= TRANSPORT a_N45_aNOT  ;
and1_1340: n_1579 <=  gnd;
delay_1341: a_LC5_B3  <= TRANSPORT a_EQ105  ;
xor2_1342: a_EQ105 <=  n_1582  XOR n_1590;
or3_1343: n_1582 <=  n_1583  OR n_1586  OR n_1588;
and2_1344: n_1583 <=  n_1584  AND n_1585;
inv_1345: n_1584  <= TRANSPORT NOT PCin(6)  ;
inv_1346: n_1585  <= TRANSPORT NOT a_N12  ;
and1_1347: n_1586 <=  n_1587;
delay_1348: n_1587  <= TRANSPORT a_N43  ;
and1_1349: n_1588 <=  n_1589;
inv_1350: n_1589  <= TRANSPORT NOT A(0)  ;
and1_1351: n_1590 <=  gnd;
delay_1352: a_LC3_B3  <= TRANSPORT a_EQ145  ;
xor2_1353: a_EQ145 <=  n_1593  XOR n_1602;
or2_1354: n_1593 <=  n_1594  OR n_1598;
and3_1355: n_1594 <=  n_1595  AND n_1596  AND n_1597;
inv_1356: n_1595  <= TRANSPORT NOT a_N54  ;
delay_1357: n_1596  <= TRANSPORT a_LC4_B3  ;
delay_1358: n_1597  <= TRANSPORT a_LC5_B3  ;
and3_1359: n_1598 <=  n_1599  AND n_1600  AND n_1601;
inv_1360: n_1599  <= TRANSPORT NOT a_N12  ;
delay_1361: n_1600  <= TRANSPORT a_LC4_B3  ;
delay_1362: n_1601  <= TRANSPORT a_LC5_B3  ;
and1_1363: n_1602 <=  gnd;
delay_1364: a_LC2_B3  <= TRANSPORT a_EQ146  ;
xor2_1365: a_EQ146 <=  n_1605  XOR n_1618;
or4_1366: n_1605 <=  n_1606  OR n_1609  OR n_1612  OR n_1615;
and2_1367: n_1606 <=  n_1607  AND n_1608;
delay_1368: n_1607  <= TRANSPORT a_LC6_B19  ;
delay_1369: n_1608  <= TRANSPORT a_LC6_B3  ;
and2_1370: n_1609 <=  n_1610  AND n_1611;
delay_1371: n_1610  <= TRANSPORT a_LC6_B19  ;
delay_1372: n_1611  <= TRANSPORT a_LC3_B3  ;
and2_1373: n_1612 <=  n_1613  AND n_1614;
delay_1374: n_1613  <= TRANSPORT DIN(7)  ;
delay_1375: n_1614  <= TRANSPORT a_LC6_B3  ;
and2_1376: n_1615 <=  n_1616  AND n_1617;
delay_1377: n_1616  <= TRANSPORT DIN(7)  ;
delay_1378: n_1617  <= TRANSPORT a_LC3_B3  ;
and1_1379: n_1618 <=  gnd;
dff_1380: DFF_a8255

    PORT MAP ( D => a_N599_aD, CLK => a_N599_aCLK, CLRN => a_N599_aCLRN, PRN => vcc,
          Q => a_N599);
inv_1381: a_N599_aCLRN  <= TRANSPORT NOT RESET  ;
xor2_1382: a_N599_aD <=  n_1626  XOR n_1629;
or1_1383: n_1626 <=  n_1627;
and1_1384: n_1627 <=  n_1628;
delay_1385: n_1628  <= TRANSPORT a_N347_aNOT  ;
and1_1386: n_1629 <=  gnd;
delay_1387: n_1630  <= TRANSPORT CLK  ;
filter_1388: FILTER_a8255

    PORT MAP (IN1 => n_1630, Y => a_N599_aCLK);
dff_1389: DFF_a8255

    PORT MAP ( D => a_EQ018, CLK => a_LC6_B3_aCLK, CLRN => a_LC6_B3_aCLRN,
          PRN => vcc, Q => a_LC6_B3);
inv_1390: a_LC6_B3_aCLRN  <= TRANSPORT NOT RESET  ;
xor2_1391: a_EQ018 <=  n_1638  XOR n_1648;
or3_1392: n_1638 <=  n_1639  OR n_1642  OR n_1645;
and2_1393: n_1639 <=  n_1640  AND n_1641;
delay_1394: n_1640  <= TRANSPORT a_LC8_B3  ;
delay_1395: n_1641  <= TRANSPORT a_LC2_B3  ;
and2_1396: n_1642 <=  n_1643  AND n_1644;
delay_1397: n_1643  <= TRANSPORT a_LC2_B3  ;
delay_1398: n_1644  <= TRANSPORT a_N599  ;
and2_1399: n_1645 <=  n_1646  AND n_1647;
delay_1400: n_1646  <= TRANSPORT a_N12  ;
delay_1401: n_1647  <= TRANSPORT a_LC2_B3  ;
and1_1402: n_1648 <=  gnd;
delay_1403: n_1649  <= TRANSPORT CLK  ;
filter_1404: FILTER_a8255

    PORT MAP (IN1 => n_1649, Y => a_LC6_B3_aCLK);
dff_1405: DFF_a8255

    PORT MAP ( D => a_EQ017, CLK => a_LC1_A3_aCLK, CLRN => a_LC1_A3_aCLRN,
          PRN => vcc, Q => a_LC1_A3);
inv_1406: a_LC1_A3_aCLRN  <= TRANSPORT NOT RESET  ;
xor2_1407: a_EQ017 <=  n_1657  XOR n_1664;
or2_1408: n_1657 <=  n_1658  OR n_1661;
and2_1409: n_1658 <=  n_1659  AND n_1660;
delay_1410: n_1659  <= TRANSPORT DIN(0)  ;
inv_1411: n_1660  <= TRANSPORT NOT a_N348_aNOT  ;
and2_1412: n_1661 <=  n_1662  AND n_1663;
delay_1413: n_1662  <= TRANSPORT a_N348_aNOT  ;
delay_1414: n_1663  <= TRANSPORT a_LC1_A3  ;
and1_1415: n_1664 <=  gnd;
delay_1416: n_1665  <= TRANSPORT CLK  ;
filter_1417: FILTER_a8255

    PORT MAP (IN1 => n_1665, Y => a_LC1_A3_aCLK);
dff_1418: DFF_a8255

    PORT MAP ( D => a_EQ016, CLK => a_LC4_B17_aCLK, CLRN => a_LC4_B17_aCLRN,
          PRN => vcc, Q => a_LC4_B17);
inv_1419: a_LC4_B17_aCLRN  <= TRANSPORT NOT RESET  ;
xor2_1420: a_EQ016 <=  n_1673  XOR n_1680;
or2_1421: n_1673 <=  n_1674  OR n_1677;
and2_1422: n_1674 <=  n_1675  AND n_1676;
delay_1423: n_1675  <= TRANSPORT DIN(1)  ;
inv_1424: n_1676  <= TRANSPORT NOT a_N348_aNOT  ;
and2_1425: n_1677 <=  n_1678  AND n_1679;
delay_1426: n_1678  <= TRANSPORT a_N348_aNOT  ;
delay_1427: n_1679  <= TRANSPORT a_LC4_B17  ;
and1_1428: n_1680 <=  gnd;
delay_1429: n_1681  <= TRANSPORT CLK  ;
filter_1430: FILTER_a8255

    PORT MAP (IN1 => n_1681, Y => a_LC4_B17_aCLK);
dff_1431: DFF_a8255

    PORT MAP ( D => a_EQ015, CLK => a_LC3_B6_aCLK, CLRN => a_LC3_B6_aCLRN,
          PRN => vcc, Q => a_LC3_B6);
inv_1432: a_LC3_B6_aCLRN  <= TRANSPORT NOT RESET  ;
xor2_1433: a_EQ015 <=  n_1689  XOR n_1696;
or2_1434: n_1689 <=  n_1690  OR n_1693;
and2_1435: n_1690 <=  n_1691  AND n_1692;
delay_1436: n_1691  <= TRANSPORT DIN(2)  ;
inv_1437: n_1692  <= TRANSPORT NOT a_N348_aNOT  ;
and2_1438: n_1693 <=  n_1694  AND n_1695;
delay_1439: n_1694  <= TRANSPORT a_N348_aNOT  ;
delay_1440: n_1695  <= TRANSPORT a_LC3_B6  ;
and1_1441: n_1696 <=  gnd;
delay_1442: n_1697  <= TRANSPORT CLK  ;
filter_1443: FILTER_a8255

    PORT MAP (IN1 => n_1697, Y => a_LC3_B6_aCLK);
dff_1444: DFF_a8255

    PORT MAP ( D => a_EQ014, CLK => a_LC1_A18_aCLK, CLRN => a_LC1_A18_aCLRN,
          PRN => vcc, Q => a_LC1_A18);
inv_1445: a_LC1_A18_aCLRN  <= TRANSPORT NOT RESET  ;
xor2_1446: a_EQ014 <=  n_1705  XOR n_1712;
or2_1447: n_1705 <=  n_1706  OR n_1709;
and2_1448: n_1706 <=  n_1707  AND n_1708;
delay_1449: n_1707  <= TRANSPORT DIN(3)  ;
inv_1450: n_1708  <= TRANSPORT NOT a_N348_aNOT  ;
and2_1451: n_1709 <=  n_1710  AND n_1711;
delay_1452: n_1710  <= TRANSPORT a_N348_aNOT  ;
delay_1453: n_1711  <= TRANSPORT a_LC1_A18  ;
and1_1454: n_1712 <=  gnd;
delay_1455: n_1713  <= TRANSPORT CLK  ;
filter_1456: FILTER_a8255

    PORT MAP (IN1 => n_1713, Y => a_LC1_A18_aCLK);
dff_1457: DFF_a8255

    PORT MAP ( D => a_EQ013, CLK => a_LC3_A13_aCLK, CLRN => a_LC3_A13_aCLRN,
          PRN => vcc, Q => a_LC3_A13);
inv_1458: a_LC3_A13_aCLRN  <= TRANSPORT NOT RESET  ;
xor2_1459: a_EQ013 <=  n_1721  XOR n_1728;
or2_1460: n_1721 <=  n_1722  OR n_1725;
and2_1461: n_1722 <=  n_1723  AND n_1724;
delay_1462: n_1723  <= TRANSPORT DIN(4)  ;
inv_1463: n_1724  <= TRANSPORT NOT a_N348_aNOT  ;
and2_1464: n_1725 <=  n_1726  AND n_1727;
delay_1465: n_1726  <= TRANSPORT a_N348_aNOT  ;
delay_1466: n_1727  <= TRANSPORT a_LC3_A13  ;
and1_1467: n_1728 <=  gnd;
delay_1468: n_1729  <= TRANSPORT CLK  ;
filter_1469: FILTER_a8255

    PORT MAP (IN1 => n_1729, Y => a_LC3_A13_aCLK);
dff_1470: DFF_a8255

    PORT MAP ( D => a_EQ012, CLK => a_LC2_B10_aCLK, CLRN => a_LC2_B10_aCLRN,
          PRN => vcc, Q => a_LC2_B10);
inv_1471: a_LC2_B10_aCLRN  <= TRANSPORT NOT RESET  ;
xor2_1472: a_EQ012 <=  n_1737  XOR n_1744;
or2_1473: n_1737 <=  n_1738  OR n_1741;
and2_1474: n_1738 <=  n_1739  AND n_1740;
delay_1475: n_1739  <= TRANSPORT DIN(5)  ;
inv_1476: n_1740  <= TRANSPORT NOT a_N348_aNOT  ;
and2_1477: n_1741 <=  n_1742  AND n_1743;
delay_1478: n_1742  <= TRANSPORT a_N348_aNOT  ;
delay_1479: n_1743  <= TRANSPORT a_LC2_B10  ;
and1_1480: n_1744 <=  gnd;
delay_1481: n_1745  <= TRANSPORT CLK  ;
filter_1482: FILTER_a8255

    PORT MAP (IN1 => n_1745, Y => a_LC2_B10_aCLK);
dff_1483: DFF_a8255

    PORT MAP ( D => a_EQ011, CLK => a_LC2_B9_aCLK, CLRN => a_LC2_B9_aCLRN,
          PRN => vcc, Q => a_LC2_B9);
inv_1484: a_LC2_B9_aCLRN  <= TRANSPORT NOT RESET  ;
xor2_1485: a_EQ011 <=  n_1753  XOR n_1760;
or2_1486: n_1753 <=  n_1754  OR n_1757;
and2_1487: n_1754 <=  n_1755  AND n_1756;
delay_1488: n_1755  <= TRANSPORT DIN(6)  ;
inv_1489: n_1756  <= TRANSPORT NOT a_N348_aNOT  ;
and2_1490: n_1757 <=  n_1758  AND n_1759;
delay_1491: n_1758  <= TRANSPORT a_N348_aNOT  ;
delay_1492: n_1759  <= TRANSPORT a_LC2_B9  ;
and1_1493: n_1760 <=  gnd;
delay_1494: n_1761  <= TRANSPORT CLK  ;
filter_1495: FILTER_a8255

    PORT MAP (IN1 => n_1761, Y => a_LC2_B9_aCLK);
dff_1496: DFF_a8255

    PORT MAP ( D => a_EQ010, CLK => a_LC3_B7_aCLK, CLRN => a_LC3_B7_aCLRN,
          PRN => vcc, Q => a_LC3_B7);
inv_1497: a_LC3_B7_aCLRN  <= TRANSPORT NOT RESET  ;
xor2_1498: a_EQ010 <=  n_1769  XOR n_1776;
or2_1499: n_1769 <=  n_1770  OR n_1773;
and2_1500: n_1770 <=  n_1771  AND n_1772;
delay_1501: n_1771  <= TRANSPORT DIN(7)  ;
inv_1502: n_1772  <= TRANSPORT NOT a_N348_aNOT  ;
and2_1503: n_1773 <=  n_1774  AND n_1775;
delay_1504: n_1774  <= TRANSPORT a_N348_aNOT  ;
delay_1505: n_1775  <= TRANSPORT a_LC3_B7  ;
and1_1506: n_1776 <=  gnd;
delay_1507: n_1777  <= TRANSPORT CLK  ;
filter_1508: FILTER_a8255

    PORT MAP (IN1 => n_1777, Y => a_LC3_B7_aCLK);
dff_1509: DFF_a8255

    PORT MAP ( D => a_EQ009, CLK => a_LC1_A13_aCLK, CLRN => a_LC1_A13_aCLRN,
          PRN => vcc, Q => a_LC1_A13);
inv_1510: a_LC1_A13_aCLRN  <= TRANSPORT NOT RESET  ;
xor2_1511: a_EQ009 <=  n_1785  XOR n_1792;
or2_1512: n_1785 <=  n_1786  OR n_1789;
and2_1513: n_1786 <=  n_1787  AND n_1788;
delay_1514: n_1787  <= TRANSPORT DIN(0)  ;
inv_1515: n_1788  <= TRANSPORT NOT a_N347_aNOT  ;
and2_1516: n_1789 <=  n_1790  AND n_1791;
delay_1517: n_1790  <= TRANSPORT a_N347_aNOT  ;
delay_1518: n_1791  <= TRANSPORT a_LC1_A13  ;
and1_1519: n_1792 <=  gnd;
delay_1520: n_1793  <= TRANSPORT CLK  ;
filter_1521: FILTER_a8255

    PORT MAP (IN1 => n_1793, Y => a_LC1_A13_aCLK);
dff_1522: DFF_a8255

    PORT MAP ( D => a_EQ008, CLK => a_LC2_B6_aCLK, CLRN => a_LC2_B6_aCLRN,
          PRN => vcc, Q => a_LC2_B6);
inv_1523: a_LC2_B6_aCLRN  <= TRANSPORT NOT RESET  ;
xor2_1524: a_EQ008 <=  n_1801  XOR n_1808;
or2_1525: n_1801 <=  n_1802  OR n_1805;
and2_1526: n_1802 <=  n_1803  AND n_1804;
delay_1527: n_1803  <= TRANSPORT a_N347_aNOT  ;
delay_1528: n_1804  <= TRANSPORT a_LC2_B6  ;
and2_1529: n_1805 <=  n_1806  AND n_1807;
delay_1530: n_1806  <= TRANSPORT DIN(1)  ;
inv_1531: n_1807  <= TRANSPORT NOT a_N347_aNOT  ;
and1_1532: n_1808 <=  gnd;
delay_1533: n_1809  <= TRANSPORT CLK  ;
filter_1534: FILTER_a8255

    PORT MAP (IN1 => n_1809, Y => a_LC2_B6_aCLK);
dff_1535: DFF_a8255

    PORT MAP ( D => a_EQ007, CLK => a_LC1_B6_aCLK, CLRN => a_LC1_B6_aCLRN,
          PRN => vcc, Q => a_LC1_B6);
inv_1536: a_LC1_B6_aCLRN  <= TRANSPORT NOT RESET  ;
xor2_1537: a_EQ007 <=  n_1817  XOR n_1824;
or2_1538: n_1817 <=  n_1818  OR n_1821;
and2_1539: n_1818 <=  n_1819  AND n_1820;
delay_1540: n_1819  <= TRANSPORT a_N347_aNOT  ;
delay_1541: n_1820  <= TRANSPORT a_LC1_B6  ;
and2_1542: n_1821 <=  n_1822  AND n_1823;
delay_1543: n_1822  <= TRANSPORT DIN(2)  ;
inv_1544: n_1823  <= TRANSPORT NOT a_N347_aNOT  ;
and1_1545: n_1824 <=  gnd;
delay_1546: n_1825  <= TRANSPORT CLK  ;
filter_1547: FILTER_a8255

    PORT MAP (IN1 => n_1825, Y => a_LC1_B6_aCLK);
dff_1548: DFF_a8255

    PORT MAP ( D => a_EQ006, CLK => a_LC1_B10_aCLK, CLRN => a_LC1_B10_aCLRN,
          PRN => vcc, Q => a_LC1_B10);
inv_1549: a_LC1_B10_aCLRN  <= TRANSPORT NOT RESET  ;
xor2_1550: a_EQ006 <=  n_1833  XOR n_1840;
or2_1551: n_1833 <=  n_1834  OR n_1837;
and2_1552: n_1834 <=  n_1835  AND n_1836;
delay_1553: n_1835  <= TRANSPORT DIN(3)  ;
inv_1554: n_1836  <= TRANSPORT NOT a_N347_aNOT  ;
and2_1555: n_1837 <=  n_1838  AND n_1839;
delay_1556: n_1838  <= TRANSPORT a_N347_aNOT  ;
delay_1557: n_1839  <= TRANSPORT a_LC1_B10  ;
and1_1558: n_1840 <=  gnd;
delay_1559: n_1841  <= TRANSPORT CLK  ;
filter_1560: FILTER_a8255

    PORT MAP (IN1 => n_1841, Y => a_LC1_B10_aCLK);
dff_1561: DFF_a8255

    PORT MAP ( D => a_EQ005, CLK => a_LC2_A13_aCLK, CLRN => a_LC2_A13_aCLRN,
          PRN => vcc, Q => a_LC2_A13);
inv_1562: a_LC2_A13_aCLRN  <= TRANSPORT NOT RESET  ;
xor2_1563: a_EQ005 <=  n_1849  XOR n_1856;
or2_1564: n_1849 <=  n_1850  OR n_1853;
and2_1565: n_1850 <=  n_1851  AND n_1852;
delay_1566: n_1851  <= TRANSPORT DIN(4)  ;
inv_1567: n_1852  <= TRANSPORT NOT a_N347_aNOT  ;
and2_1568: n_1853 <=  n_1854  AND n_1855;
delay_1569: n_1854  <= TRANSPORT a_N347_aNOT  ;
delay_1570: n_1855  <= TRANSPORT a_LC2_A13  ;
and1_1571: n_1856 <=  gnd;
delay_1572: n_1857  <= TRANSPORT CLK  ;
filter_1573: FILTER_a8255

    PORT MAP (IN1 => n_1857, Y => a_LC2_A13_aCLK);
dff_1574: DFF_a8255

    PORT MAP ( D => a_EQ004, CLK => a_LC1_B9_aCLK, CLRN => a_LC1_B9_aCLRN,
          PRN => vcc, Q => a_LC1_B9);
inv_1575: a_LC1_B9_aCLRN  <= TRANSPORT NOT RESET  ;
xor2_1576: a_EQ004 <=  n_1865  XOR n_1872;
or2_1577: n_1865 <=  n_1866  OR n_1869;
and2_1578: n_1866 <=  n_1867  AND n_1868;
delay_1579: n_1867  <= TRANSPORT DIN(5)  ;
inv_1580: n_1868  <= TRANSPORT NOT a_N347_aNOT  ;
and2_1581: n_1869 <=  n_1870  AND n_1871;
delay_1582: n_1870  <= TRANSPORT a_N347_aNOT  ;
delay_1583: n_1871  <= TRANSPORT a_LC1_B9  ;
and1_1584: n_1872 <=  gnd;
delay_1585: n_1873  <= TRANSPORT CLK  ;
filter_1586: FILTER_a8255

    PORT MAP (IN1 => n_1873, Y => a_LC1_B9_aCLK);
dff_1587: DFF_a8255

    PORT MAP ( D => a_EQ003, CLK => a_LC1_B11_aCLK, CLRN => a_LC1_B11_aCLRN,
          PRN => vcc, Q => a_LC1_B11);
inv_1588: a_LC1_B11_aCLRN  <= TRANSPORT NOT RESET  ;
xor2_1589: a_EQ003 <=  n_1881  XOR n_1888;
or2_1590: n_1881 <=  n_1882  OR n_1885;
and2_1591: n_1882 <=  n_1883  AND n_1884;
delay_1592: n_1883  <= TRANSPORT a_N347_aNOT  ;
delay_1593: n_1884  <= TRANSPORT a_LC1_B11  ;
and2_1594: n_1885 <=  n_1886  AND n_1887;
delay_1595: n_1886  <= TRANSPORT DIN(6)  ;
inv_1596: n_1887  <= TRANSPORT NOT a_N347_aNOT  ;
and1_1597: n_1888 <=  gnd;
delay_1598: n_1889  <= TRANSPORT CLK  ;
filter_1599: FILTER_a8255

    PORT MAP (IN1 => n_1889, Y => a_LC1_B11_aCLK);
dff_1600: DFF_a8255

    PORT MAP ( D => a_EQ002, CLK => a_LC6_A18_aCLK, CLRN => a_LC6_A18_aCLRN,
          PRN => vcc, Q => a_LC6_A18);
inv_1601: a_LC6_A18_aCLRN  <= TRANSPORT NOT RESET  ;
xor2_1602: a_EQ002 <=  n_1897  XOR n_1904;
or2_1603: n_1897 <=  n_1898  OR n_1901;
and2_1604: n_1898 <=  n_1899  AND n_1900;
delay_1605: n_1899  <= TRANSPORT a_N347_aNOT  ;
delay_1606: n_1900  <= TRANSPORT a_LC6_A18  ;
and2_1607: n_1901 <=  n_1902  AND n_1903;
delay_1608: n_1902  <= TRANSPORT DIN(7)  ;
inv_1609: n_1903  <= TRANSPORT NOT a_N347_aNOT  ;
and1_1610: n_1904 <=  gnd;
delay_1611: n_1905  <= TRANSPORT CLK  ;
filter_1612: FILTER_a8255

    PORT MAP (IN1 => n_1905, Y => a_LC6_A18_aCLK);
dff_1613: DFF_a8255

    PORT MAP ( D => a_EQ167, CLK => a_SCONTROLREG_F1_G_aNOT_aCLK, CLRN => a_SCONTROLREG_F1_G_aNOT_aCLRN,
          PRN => vcc, Q => a_SCONTROLREG_F1_G_aNOT);
inv_1614: a_SCONTROLREG_F1_G_aNOT_aCLRN  <= TRANSPORT NOT RESET  ;
xor2_1615: a_EQ167 <=  n_1913  XOR n_1924;
or3_1616: n_1913 <=  n_1914  OR n_1918  OR n_1921;
and3_1617: n_1914 <=  n_1915  AND n_1916  AND n_1917;
delay_1618: n_1915  <= TRANSPORT a_N46  ;
delay_1619: n_1916  <= TRANSPORT DIN(7)  ;
inv_1620: n_1917  <= TRANSPORT NOT DIN(1)  ;
and2_1621: n_1918 <=  n_1919  AND n_1920;
inv_1622: n_1919  <= TRANSPORT NOT DIN(7)  ;
delay_1623: n_1920  <= TRANSPORT a_SCONTROLREG_F1_G_aNOT  ;
and2_1624: n_1921 <=  n_1922  AND n_1923;
inv_1625: n_1922  <= TRANSPORT NOT a_N46  ;
delay_1626: n_1923  <= TRANSPORT a_SCONTROLREG_F1_G_aNOT  ;
and1_1627: n_1924 <=  gnd;
delay_1628: n_1925  <= TRANSPORT CLK  ;
filter_1629: FILTER_a8255

    PORT MAP (IN1 => n_1925, Y => a_SCONTROLREG_F1_G_aNOT_aCLK);
delay_1630: a_G119  <= TRANSPORT a_EQ042  ;
xor2_1631: a_EQ042 <=  n_1928  XOR n_1934;
or2_1632: n_1928 <=  n_1929  OR n_1931;
and1_1633: n_1929 <=  n_1930;
delay_1634: n_1930  <= TRANSPORT a_SCONTROLREG_F2_G  ;
and1_1635: n_1931 <=  n_1932;
delay_1636: n_1932  <= TRANSPORT a_SCONTROLREG_F0_G_aNOT  ;
and1_1637: n_1934 <=  gnd;
delay_1638: a_LC2_A12  <= TRANSPORT a_LC2_A12_aIN  ;
xor2_1639: a_LC2_A12_aIN <=  n_1936  XOR n_1941;
or2_1640: n_1936 <=  n_1937  OR n_1939;
and1_1641: n_1937 <=  n_1938;
delay_1642: n_1938  <= TRANSPORT a_SCONTROLREG_F2_G  ;
and1_1643: n_1939 <=  n_1940;
delay_1644: n_1940  <= TRANSPORT a_SCONTROLREG_F0_G_aNOT  ;
and1_1645: n_1941 <=  gnd;
delay_1646: a_G107  <= TRANSPORT a_G107_aIN  ;
xor2_1647: a_G107_aIN <=  n_1943  XOR n_1947;
or1_1648: n_1943 <=  n_1944;
and2_1649: n_1944 <=  n_1945  AND n_1946;
delay_1650: n_1945  <= TRANSPORT a_SCONTROLREG_F0_G_aNOT  ;
inv_1651: n_1946  <= TRANSPORT NOT a_SCONTROLREG_F2_G  ;
and1_1652: n_1947 <=  gnd;
delay_1653: a_G137  <= TRANSPORT a_EQ048  ;
xor2_1654: a_EQ048 <=  n_1949  XOR n_1956;
or3_1655: n_1949 <=  n_1950  OR n_1952  OR n_1954;
and1_1656: n_1950 <=  n_1951;
delay_1657: n_1951  <= TRANSPORT a_SCONTROLREG_F2_G  ;
and1_1658: n_1952 <=  n_1953;
delay_1659: n_1953  <= TRANSPORT a_SCONTROLREG_F0_G_aNOT  ;
and1_1660: n_1954 <=  n_1955;
delay_1661: n_1955  <= TRANSPORT a_SCONTROLREG_F6_G  ;
and1_1662: n_1956 <=  gnd;
delay_1663: a_G98  <= TRANSPORT a_G98_aIN  ;
xor2_1664: a_G98_aIN <=  n_1958  XOR n_1963;
or1_1665: n_1958 <=  n_1959;
and2_1666: n_1959 <=  n_1960  AND n_1962;
delay_1667: n_1960  <= TRANSPORT a_SCONTROLREG_F3_G_aNOT  ;
delay_1668: n_1962  <= TRANSPORT a_N11  ;
and1_1669: n_1963 <=  gnd;
delay_1670: a_G381  <= TRANSPORT a_EQ069  ;
xor2_1671: a_EQ069 <=  n_1965  XOR n_1970;
or2_1672: n_1965 <=  n_1966  OR n_1968;
and1_1673: n_1966 <=  n_1967;
inv_1674: n_1967  <= TRANSPORT NOT a_N11  ;
and1_1675: n_1968 <=  n_1969;
delay_1676: n_1969  <= TRANSPORT a_SCONTROLREG_F3_G_aNOT  ;
and1_1677: n_1970 <=  gnd;
delay_1678: a_G99  <= TRANSPORT a_G99_aIN  ;
xor2_1679: a_G99_aIN <=  n_1972  XOR n_1976;
or1_1680: n_1972 <=  n_1973;
and2_1681: n_1973 <=  n_1974  AND n_1975;
delay_1682: n_1974  <= TRANSPORT a_SCONTROLREG_F3_G_aNOT  ;
delay_1683: n_1975  <= TRANSPORT a_N12  ;
and1_1684: n_1976 <=  gnd;
delay_1685: a_G89  <= TRANSPORT a_EQ038  ;
xor2_1686: a_EQ038 <=  n_1978  XOR n_1983;
or2_1687: n_1978 <=  n_1979  OR n_1981;
and1_1688: n_1979 <=  n_1980;
inv_1689: n_1980  <= TRANSPORT NOT a_N12  ;
and1_1690: n_1981 <=  n_1982;
delay_1691: n_1982  <= TRANSPORT a_SCONTROLREG_F3_G_aNOT  ;
and1_1692: n_1983 <=  gnd;
delay_1693: a_N36  <= TRANSPORT a_N36_aIN  ;
xor2_1694: a_N36_aIN <=  n_1986  XOR n_1992;
or1_1695: n_1986 <=  n_1987;
and4_1696: n_1987 <=  n_1988  AND n_1989  AND n_1990  AND n_1991;
inv_1697: n_1988  <= TRANSPORT NOT a_SCONTROLREG_F5_G  ;
inv_1698: n_1989  <= TRANSPORT NOT A(1)  ;
inv_1699: n_1990  <= TRANSPORT NOT A(0)  ;
inv_1700: n_1991  <= TRANSPORT NOT a_SCONTROLREG_F6_G  ;
and1_1701: n_1992 <=  gnd;
delay_1702: a_N20  <= TRANSPORT a_EQ078  ;
xor2_1703: a_EQ078 <=  n_1995  XOR n_2004;
or2_1704: n_1995 <=  n_1996  OR n_2000;
and3_1705: n_1996 <=  n_1997  AND n_1998  AND n_1999;
inv_1706: n_1997  <= TRANSPORT NOT A(1)  ;
inv_1707: n_1998  <= TRANSPORT NOT A(0)  ;
delay_1708: n_1999  <= TRANSPORT a_SCONTROLREG_F6_G  ;
and3_1709: n_2000 <=  n_2001  AND n_2002  AND n_2003;
delay_1710: n_2001  <= TRANSPORT a_SCONTROLREG_F5_G  ;
inv_1711: n_2002  <= TRANSPORT NOT A(1)  ;
inv_1712: n_2003  <= TRANSPORT NOT A(0)  ;
and1_1713: n_2004 <=  gnd;
delay_1714: a_LC5_A14  <= TRANSPORT a_EQ044  ;
xor2_1715: a_EQ044 <=  n_2007  XOR n_2016;
or2_1716: n_2007 <=  n_2008  OR n_2012;
and2_1717: n_2008 <=  n_2009  AND n_2011;
delay_1718: n_2009  <= TRANSPORT PAin(0)  ;
delay_1719: n_2011  <= TRANSPORT a_N36  ;
and2_1720: n_2012 <=  n_2013  AND n_2015;
delay_1721: n_2013  <= TRANSPORT a_SPORTAINREG_F0_G  ;
delay_1722: n_2015  <= TRANSPORT a_N20  ;
and1_1723: n_2016 <=  gnd;
delay_1724: a_LC7_A14  <= TRANSPORT a_EQ045  ;
xor2_1725: a_EQ045 <=  n_2019  XOR n_2028;
or2_1726: n_2019 <=  n_2020  OR n_2024;
and2_1727: n_2020 <=  n_2021  AND n_2023;
delay_1728: n_2021  <= TRANSPORT a_SPORTBINREG_F0_G  ;
delay_1729: n_2023  <= TRANSPORT a_SCONTROLREG_F2_G  ;
and2_1730: n_2024 <=  n_2025  AND n_2027;
delay_1731: n_2025  <= TRANSPORT PBin(0)  ;
inv_1732: n_2027  <= TRANSPORT NOT a_SCONTROLREG_F2_G  ;
and1_1733: n_2028 <=  gnd;
delay_1734: a_LC6_A14  <= TRANSPORT a_EQ046  ;
xor2_1735: a_EQ046 <=  n_2031  XOR n_2040;
or2_1736: n_2031 <=  n_2032  OR n_2036;
and3_1737: n_2032 <=  n_2033  AND n_2034  AND n_2035;
inv_1738: n_2033  <= TRANSPORT NOT A(1)  ;
delay_1739: n_2034  <= TRANSPORT A(0)  ;
delay_1740: n_2035  <= TRANSPORT a_LC7_A14  ;
and3_1741: n_2036 <=  n_2037  AND n_2038  AND n_2039;
delay_1742: n_2037  <= TRANSPORT A(1)  ;
delay_1743: n_2038  <= TRANSPORT A(0)  ;
inv_1744: n_2039  <= TRANSPORT NOT a_SCONTROLREG_F0_G_aNOT  ;
and1_1745: n_2040 <=  gnd;
delay_1746: a_N48  <= TRANSPORT a_N48_aIN  ;
xor2_1747: a_N48_aIN <=  n_2044  XOR n_2048;
or1_1748: n_2044 <=  n_2045;
and2_1749: n_2045 <=  n_2046  AND n_2047;
delay_1750: n_2046  <= TRANSPORT A(1)  ;
inv_1751: n_2047  <= TRANSPORT NOT A(0)  ;
and1_1752: n_2048 <=  gnd;
delay_1753: a_G135  <= TRANSPORT a_EQ047  ;
xor2_1754: a_EQ047 <=  n_2050  XOR n_2058;
or3_1755: n_2050 <=  n_2051  OR n_2053  OR n_2055;
and1_1756: n_2051 <=  n_2052;
delay_1757: n_2052  <= TRANSPORT a_LC5_A14  ;
and1_1758: n_2053 <=  n_2054;
delay_1759: n_2054  <= TRANSPORT a_LC6_A14  ;
and2_1760: n_2055 <=  n_2056  AND n_2057;
delay_1761: n_2056  <= TRANSPORT PCin(0)  ;
delay_1762: n_2057  <= TRANSPORT a_N48  ;
and1_1763: n_2058 <=  gnd;
delay_1764: a_LC2_B20  <= TRANSPORT a_EQ035  ;
xor2_1765: a_EQ035 <=  n_2062  XOR n_2071;
or2_1766: n_2062 <=  n_2063  OR n_2067;
and3_1767: n_2063 <=  n_2064  AND n_2065  AND n_2066;
delay_1768: n_2064  <= TRANSPORT A(1)  ;
delay_1769: n_2065  <= TRANSPORT A(0)  ;
inv_1770: n_2066  <= TRANSPORT NOT a_SCONTROLREG_F1_G_aNOT  ;
and3_1771: n_2067 <=  n_2068  AND n_2069  AND n_2070;
delay_1772: n_2068  <= TRANSPORT A(1)  ;
inv_1773: n_2069  <= TRANSPORT NOT A(0)  ;
delay_1774: n_2070  <= TRANSPORT PCin(1)  ;
and1_1775: n_2071 <=  gnd;
delay_1776: a_N50  <= TRANSPORT a_N50_aIN  ;
xor2_1777: a_N50_aIN <=  n_2074  XOR n_2078;
or1_1778: n_2074 <=  n_2075;
and2_1779: n_2075 <=  n_2076  AND n_2077;
delay_1780: n_2076  <= TRANSPORT a_SCONTROLREG_F2_G  ;
inv_1781: n_2077  <= TRANSPORT NOT a_N265_aNOT  ;
and1_1782: n_2078 <=  gnd;
delay_1783: a_LC4_B20  <= TRANSPORT a_EQ036  ;
xor2_1784: a_EQ036 <=  n_2081  XOR n_2088;
or2_1785: n_2081 <=  n_2082  OR n_2084;
and1_1786: n_2082 <=  n_2083;
delay_1787: n_2083  <= TRANSPORT a_LC2_B20  ;
and2_1788: n_2084 <=  n_2085  AND n_2087;
delay_1789: n_2085  <= TRANSPORT a_SPORTBINREG_F1_G  ;
delay_1790: n_2087  <= TRANSPORT a_N50  ;
and1_1791: n_2088 <=  gnd;
delay_1792: a_LC3_B13  <= TRANSPORT a_EQ034  ;
xor2_1793: a_EQ034 <=  n_2091  XOR n_2100;
or2_1794: n_2091 <=  n_2092  OR n_2096;
and2_1795: n_2092 <=  n_2093  AND n_2095;
delay_1796: n_2093  <= TRANSPORT PAin(1)  ;
delay_1797: n_2095  <= TRANSPORT a_N36  ;
and2_1798: n_2096 <=  n_2097  AND n_2099;
delay_1799: n_2097  <= TRANSPORT a_SPORTAINREG_F1_G  ;
delay_1800: n_2099  <= TRANSPORT a_N20  ;
and1_1801: n_2100 <=  gnd;
delay_1802: a_N47  <= TRANSPORT a_N47_aIN  ;
xor2_1803: a_N47_aIN <=  n_2103  XOR n_2107;
or1_1804: n_2103 <=  n_2104;
and2_1805: n_2104 <=  n_2105  AND n_2106;
inv_1806: n_2105  <= TRANSPORT NOT a_SCONTROLREG_F2_G  ;
inv_1807: n_2106  <= TRANSPORT NOT a_N265_aNOT  ;
and1_1808: n_2107 <=  gnd;
delay_1809: a_G84  <= TRANSPORT a_EQ037  ;
xor2_1810: a_EQ037 <=  n_2109  XOR n_2118;
or3_1811: n_2109 <=  n_2110  OR n_2112  OR n_2114;
and1_1812: n_2110 <=  n_2111;
delay_1813: n_2111  <= TRANSPORT a_LC4_B20  ;
and1_1814: n_2112 <=  n_2113;
delay_1815: n_2113  <= TRANSPORT a_LC3_B13  ;
and2_1816: n_2114 <=  n_2115  AND n_2117;
delay_1817: n_2115  <= TRANSPORT PBin(1)  ;
delay_1818: n_2117  <= TRANSPORT a_N47  ;
and1_1819: n_2118 <=  gnd;
delay_1820: a_LC6_B2  <= TRANSPORT a_EQ053  ;
xor2_1821: a_EQ053 <=  n_2121  XOR n_2134;
or3_1822: n_2121 <=  n_2122  OR n_2126  OR n_2129;
and2_1823: n_2122 <=  n_2123  AND n_2125;
delay_1824: n_2123  <= TRANSPORT a_SPORTAINREG_F2_G  ;
delay_1825: n_2125  <= TRANSPORT a_SCONTROLREG_F6_G  ;
and2_1826: n_2126 <=  n_2127  AND n_2128;
delay_1827: n_2127  <= TRANSPORT a_SPORTAINREG_F2_G  ;
delay_1828: n_2128  <= TRANSPORT a_SCONTROLREG_F5_G  ;
and3_1829: n_2129 <=  n_2130  AND n_2132  AND n_2133;
delay_1830: n_2130  <= TRANSPORT PAin(2)  ;
inv_1831: n_2132  <= TRANSPORT NOT a_SCONTROLREG_F5_G  ;
inv_1832: n_2133  <= TRANSPORT NOT a_SCONTROLREG_F6_G  ;
and1_1833: n_2134 <=  gnd;
delay_1834: a_LC5_B2  <= TRANSPORT a_EQ054  ;
xor2_1835: a_EQ054 <=  n_2137  XOR n_2145;
or2_1836: n_2137 <=  n_2138  OR n_2141;
and2_1837: n_2138 <=  n_2139  AND n_2140;
inv_1838: n_2139  <= TRANSPORT NOT A(1)  ;
delay_1839: n_2140  <= TRANSPORT a_LC6_B2  ;
and3_1840: n_2141 <=  n_2142  AND n_2143  AND n_2144;
delay_1841: n_2142  <= TRANSPORT PCin(2)  ;
delay_1842: n_2143  <= TRANSPORT A(1)  ;
inv_1843: n_2144  <= TRANSPORT NOT a_SCONTROLREG_F2_G  ;
and1_1844: n_2145 <=  gnd;
delay_1845: a_LC4_B2  <= TRANSPORT a_EQ055  ;
xor2_1846: a_EQ055 <=  n_2148  XOR n_2157;
or2_1847: n_2148 <=  n_2149  OR n_2152;
and2_1848: n_2149 <=  n_2150  AND n_2151;
inv_1849: n_2150  <= TRANSPORT NOT A(0)  ;
delay_1850: n_2151  <= TRANSPORT a_LC5_B2  ;
and3_1851: n_2152 <=  n_2153  AND n_2155  AND n_2156;
delay_1852: n_2153  <= TRANSPORT a_SPORTBINREG_F2_G  ;
delay_1853: n_2155  <= TRANSPORT A(0)  ;
delay_1854: n_2156  <= TRANSPORT a_SCONTROLREG_F2_G  ;
and1_1855: n_2157 <=  gnd;
delay_1856: a_LC8_B2  <= TRANSPORT a_EQ057  ;
xor2_1857: a_EQ057 <=  n_2160  XOR n_2166;
or2_1858: n_2160 <=  n_2161  OR n_2164;
and2_1859: n_2161 <=  n_2162  AND n_2163;
delay_1860: n_2162  <= TRANSPORT A(1)  ;
delay_1861: n_2163  <= TRANSPORT a_LC6_A2  ;
and1_1862: n_2164 <=  n_2165;
delay_1863: n_2165  <= TRANSPORT A(0)  ;
and1_1864: n_2166 <=  gnd;
delay_1865: a_LC7_B2  <= TRANSPORT a_EQ056  ;
xor2_1866: a_EQ056 <=  n_2169  XOR n_2178;
or2_1867: n_2169 <=  n_2170  OR n_2173;
and2_1868: n_2170 <=  n_2171  AND n_2172;
delay_1869: n_2171  <= TRANSPORT A(1)  ;
delay_1870: n_2172  <= TRANSPORT a_SCONTROLREG_F2_G  ;
and3_1871: n_2173 <=  n_2174  AND n_2176  AND n_2177;
delay_1872: n_2174  <= TRANSPORT PBin(2)  ;
inv_1873: n_2176  <= TRANSPORT NOT A(1)  ;
inv_1874: n_2177  <= TRANSPORT NOT a_SCONTROLREG_F2_G  ;
and1_1875: n_2178 <=  gnd;
delay_1876: a_G153  <= TRANSPORT a_EQ058  ;
xor2_1877: a_EQ058 <=  n_2180  XOR n_2186;
or2_1878: n_2180 <=  n_2181  OR n_2183;
and1_1879: n_2181 <=  n_2182;
delay_1880: n_2182  <= TRANSPORT a_LC4_B2  ;
and2_1881: n_2183 <=  n_2184  AND n_2185;
delay_1882: n_2184  <= TRANSPORT a_LC8_B2  ;
delay_1883: n_2185  <= TRANSPORT a_LC7_B2  ;
and1_1884: n_2186 <=  gnd;
delay_1885: a_LC6_B16  <= TRANSPORT a_EQ027  ;
xor2_1886: a_EQ027 <=  n_2190  XOR n_2197;
or2_1887: n_2190 <=  n_2191  OR n_2194;
and2_1888: n_2191 <=  n_2192  AND n_2193;
delay_1889: n_2192  <= TRANSPORT A(0)  ;
inv_1890: n_2193  <= TRANSPORT NOT a_SCONTROLREG_F3_G_aNOT  ;
and2_1891: n_2194 <=  n_2195  AND n_2196;
inv_1892: n_2195  <= TRANSPORT NOT A(0)  ;
delay_1893: n_2196  <= TRANSPORT PCin(3)  ;
and1_1894: n_2197 <=  gnd;
delay_1895: a_LC5_B16  <= TRANSPORT a_EQ028  ;
xor2_1896: a_EQ028 <=  n_2200  XOR n_2208;
or2_1897: n_2200 <=  n_2201  OR n_2205;
and2_1898: n_2201 <=  n_2202  AND n_2204;
delay_1899: n_2202  <= TRANSPORT PBin(3)  ;
delay_1900: n_2204  <= TRANSPORT a_N47  ;
and2_1901: n_2205 <=  n_2206  AND n_2207;
delay_1902: n_2206  <= TRANSPORT A(1)  ;
delay_1903: n_2207  <= TRANSPORT a_LC6_B16  ;
and1_1904: n_2208 <=  gnd;
delay_1905: a_LC7_B16  <= TRANSPORT a_EQ026  ;
xor2_1906: a_EQ026 <=  n_2211  XOR n_2220;
or2_1907: n_2211 <=  n_2212  OR n_2216;
and2_1908: n_2212 <=  n_2213  AND n_2215;
delay_1909: n_2213  <= TRANSPORT PAin(3)  ;
delay_1910: n_2215  <= TRANSPORT a_N36  ;
and2_1911: n_2216 <=  n_2217  AND n_2219;
delay_1912: n_2217  <= TRANSPORT a_SPORTAINREG_F3_G  ;
delay_1913: n_2219  <= TRANSPORT a_N20  ;
and1_1914: n_2220 <=  gnd;
delay_1915: a_G82  <= TRANSPORT a_EQ029  ;
xor2_1916: a_EQ029 <=  n_2222  XOR n_2231;
or3_1917: n_2222 <=  n_2223  OR n_2225  OR n_2227;
and1_1918: n_2223 <=  n_2224;
delay_1919: n_2224  <= TRANSPORT a_LC5_B16  ;
and1_1920: n_2225 <=  n_2226;
delay_1921: n_2226  <= TRANSPORT a_LC7_B16  ;
and2_1922: n_2227 <=  n_2228  AND n_2230;
delay_1923: n_2228  <= TRANSPORT a_SPORTBINREG_F3_G  ;
delay_1924: n_2230  <= TRANSPORT a_N50  ;
and1_1925: n_2231 <=  gnd;
delay_1926: a_LC5_A20  <= TRANSPORT a_EQ064  ;
xor2_1927: a_EQ064 <=  n_2234  XOR n_2242;
or2_1928: n_2234 <=  n_2235  OR n_2239;
and3_1929: n_2235 <=  n_2236  AND n_2237  AND n_2238;
delay_1930: n_2236  <= TRANSPORT PCin(4)  ;
inv_1931: n_2237  <= TRANSPORT NOT A(0)  ;
delay_1932: n_2238  <= TRANSPORT a_N11  ;
and2_1933: n_2239 <=  n_2240  AND n_2241;
delay_1934: n_2240  <= TRANSPORT A(0)  ;
inv_1935: n_2241  <= TRANSPORT NOT a_SCONTROLREG_F4_G_aNOT  ;
and1_1936: n_2242 <=  gnd;
delay_1937: a_LC4_A20  <= TRANSPORT a_EQ065  ;
xor2_1938: a_EQ065 <=  n_2245  XOR n_2254;
or3_1939: n_2245 <=  n_2246  OR n_2248  OR n_2251;
and1_1940: n_2246 <=  n_2247;
delay_1941: n_2247  <= TRANSPORT a_LC5_A20  ;
and2_1942: n_2248 <=  n_2249  AND n_2250;
inv_1943: n_2249  <= TRANSPORT NOT a_LC7_A20_aNOT  ;
delay_1944: n_2250  <= TRANSPORT a_LC4_A1  ;
and2_1945: n_2251 <=  n_2252  AND n_2253;
inv_1946: n_2252  <= TRANSPORT NOT a_N45_aNOT  ;
delay_1947: n_2253  <= TRANSPORT a_LC4_A1  ;
and1_1948: n_2254 <=  gnd;
delay_1949: a_LC1_B16  <= TRANSPORT a_EQ067  ;
xor2_1950: a_EQ067 <=  n_2257  XOR n_2266;
or2_1951: n_2257 <=  n_2258  OR n_2262;
and2_1952: n_2258 <=  n_2259  AND n_2261;
delay_1953: n_2259  <= TRANSPORT PBin(4)  ;
delay_1954: n_2261  <= TRANSPORT a_N47  ;
and2_1955: n_2262 <=  n_2263  AND n_2265;
delay_1956: n_2263  <= TRANSPORT a_SPORTBINREG_F4_G  ;
delay_1957: n_2265  <= TRANSPORT a_N50  ;
and1_1958: n_2266 <=  gnd;
delay_1959: a_LC1_A7  <= TRANSPORT a_EQ066  ;
xor2_1960: a_EQ066 <=  n_2269  XOR n_2278;
or2_1961: n_2269 <=  n_2270  OR n_2274;
and2_1962: n_2270 <=  n_2271  AND n_2273;
delay_1963: n_2271  <= TRANSPORT a_SPORTAINREG_F4_G  ;
delay_1964: n_2273  <= TRANSPORT a_N20  ;
and2_1965: n_2274 <=  n_2275  AND n_2277;
delay_1966: n_2275  <= TRANSPORT PAin(4)  ;
delay_1967: n_2277  <= TRANSPORT a_N36  ;
and1_1968: n_2278 <=  gnd;
delay_1969: a_G233  <= TRANSPORT a_EQ068  ;
xor2_1970: a_EQ068 <=  n_2280  XOR n_2288;
or3_1971: n_2280 <=  n_2281  OR n_2284  OR n_2286;
and2_1972: n_2281 <=  n_2282  AND n_2283;
delay_1973: n_2282  <= TRANSPORT A(1)  ;
delay_1974: n_2283  <= TRANSPORT a_LC4_A20  ;
and1_1975: n_2284 <=  n_2285;
delay_1976: n_2285  <= TRANSPORT a_LC1_B16  ;
and1_1977: n_2286 <=  n_2287;
delay_1978: n_2287  <= TRANSPORT a_LC1_A7  ;
and1_1979: n_2288 <=  gnd;
delay_1980: a_LC2_B13  <= TRANSPORT a_EQ030  ;
xor2_1981: a_EQ030 <=  n_2291  XOR n_2300;
or2_1982: n_2291 <=  n_2292  OR n_2296;
and2_1983: n_2292 <=  n_2293  AND n_2295;
delay_1984: n_2293  <= TRANSPORT PAin(5)  ;
delay_1985: n_2295  <= TRANSPORT a_N36  ;
and2_1986: n_2296 <=  n_2297  AND n_2299;
delay_1987: n_2297  <= TRANSPORT a_SPORTAINREG_F5_G  ;
delay_1988: n_2299  <= TRANSPORT a_N20  ;
and1_1989: n_2300 <=  gnd;
delay_1990: a_LC6_B12  <= TRANSPORT a_EQ031  ;
xor2_1991: a_EQ031 <=  n_2304  XOR n_2313;
or2_1992: n_2304 <=  n_2305  OR n_2309;
and3_1993: n_2305 <=  n_2306  AND n_2307  AND n_2308;
delay_1994: n_2306  <= TRANSPORT a_SCONTROLREG_F5_G  ;
delay_1995: n_2307  <= TRANSPORT A(1)  ;
delay_1996: n_2308  <= TRANSPORT A(0)  ;
and3_1997: n_2309 <=  n_2310  AND n_2311  AND n_2312;
delay_1998: n_2310  <= TRANSPORT A(1)  ;
inv_1999: n_2311  <= TRANSPORT NOT A(0)  ;
delay_2000: n_2312  <= TRANSPORT PCin(5)  ;
and1_2001: n_2313 <=  gnd;
delay_2002: a_LC5_B12  <= TRANSPORT a_EQ032  ;
xor2_2003: a_EQ032 <=  n_2316  XOR n_2324;
or2_2004: n_2316 <=  n_2317  OR n_2319;
and1_2005: n_2317 <=  n_2318;
delay_2006: n_2318  <= TRANSPORT a_LC6_B12  ;
and3_2007: n_2319 <=  n_2320  AND n_2322  AND n_2323;
delay_2008: n_2320  <= TRANSPORT a_SPORTBINREG_F5_G  ;
delay_2009: n_2322  <= TRANSPORT a_SCONTROLREG_F2_G  ;
inv_2010: n_2323  <= TRANSPORT NOT a_N265_aNOT  ;
and1_2011: n_2324 <=  gnd;
delay_2012: a_G83  <= TRANSPORT a_EQ033  ;
xor2_2013: a_EQ033 <=  n_2326  XOR n_2335;
or3_2014: n_2326 <=  n_2327  OR n_2329  OR n_2331;
and1_2015: n_2327 <=  n_2328;
delay_2016: n_2328  <= TRANSPORT a_LC2_B13  ;
and1_2017: n_2329 <=  n_2330;
delay_2018: n_2330  <= TRANSPORT a_LC5_B12  ;
and2_2019: n_2331 <=  n_2332  AND n_2334;
delay_2020: n_2332  <= TRANSPORT PBin(5)  ;
delay_2021: n_2334  <= TRANSPORT a_N47  ;
and1_2022: n_2335 <=  gnd;
delay_2023: a_LC3_B1  <= TRANSPORT a_EQ061  ;
xor2_2024: a_EQ061 <=  n_2338  XOR n_2347;
or2_2025: n_2338 <=  n_2339  OR n_2343;
and2_2026: n_2339 <=  n_2340  AND n_2342;
delay_2027: n_2340  <= TRANSPORT PBin(6)  ;
delay_2028: n_2342  <= TRANSPORT a_N47  ;
and2_2029: n_2343 <=  n_2344  AND n_2346;
delay_2030: n_2344  <= TRANSPORT a_SPORTBINREG_F6_G  ;
delay_2031: n_2346  <= TRANSPORT a_N50  ;
and1_2032: n_2347 <=  gnd;
delay_2033: a_LC5_B1  <= TRANSPORT a_EQ059  ;
xor2_2034: a_EQ059 <=  n_2350  XOR n_2361;
or3_2035: n_2350 <=  n_2351  OR n_2355  OR n_2358;
and3_2036: n_2351 <=  n_2352  AND n_2353  AND n_2354;
inv_2037: n_2352  <= TRANSPORT NOT A(0)  ;
inv_2038: n_2353  <= TRANSPORT NOT a_N44_aNOT  ;
delay_2039: n_2354  <= TRANSPORT a_LC2_A1  ;
and2_2040: n_2355 <=  n_2356  AND n_2357;
delay_2041: n_2356  <= TRANSPORT a_SCONTROLREG_F6_G  ;
delay_2042: n_2357  <= TRANSPORT a_LC2_A1  ;
and2_2043: n_2358 <=  n_2359  AND n_2360;
delay_2044: n_2359  <= TRANSPORT A(0)  ;
delay_2045: n_2360  <= TRANSPORT a_SCONTROLREG_F6_G  ;
and1_2046: n_2361 <=  gnd;
delay_2047: a_LC4_B1  <= TRANSPORT a_EQ060  ;
xor2_2048: a_EQ060 <=  n_2364  XOR n_2371;
or2_2049: n_2364 <=  n_2365  OR n_2367;
and1_2050: n_2365 <=  n_2366;
delay_2051: n_2366  <= TRANSPORT a_LC5_B1  ;
and3_2052: n_2367 <=  n_2368  AND n_2369  AND n_2370;
inv_2053: n_2368  <= TRANSPORT NOT A(0)  ;
delay_2054: n_2369  <= TRANSPORT PCin(6)  ;
delay_2055: n_2370  <= TRANSPORT a_N12  ;
and1_2056: n_2371 <=  gnd;
delay_2057: a_LC2_B15  <= TRANSPORT a_EQ062  ;
xor2_2058: a_EQ062 <=  n_2374  XOR n_2383;
or2_2059: n_2374 <=  n_2375  OR n_2379;
and2_2060: n_2375 <=  n_2376  AND n_2378;
delay_2061: n_2376  <= TRANSPORT PAin(6)  ;
delay_2062: n_2378  <= TRANSPORT a_N36  ;
and2_2063: n_2379 <=  n_2380  AND n_2382;
delay_2064: n_2380  <= TRANSPORT a_SPORTAINREG_F6_G  ;
delay_2065: n_2382  <= TRANSPORT a_N20  ;
and1_2066: n_2383 <=  gnd;
delay_2067: a_G227  <= TRANSPORT a_EQ063  ;
xor2_2068: a_EQ063 <=  n_2385  XOR n_2393;
or3_2069: n_2385 <=  n_2386  OR n_2388  OR n_2391;
and1_2070: n_2386 <=  n_2387;
delay_2071: n_2387  <= TRANSPORT a_LC3_B1  ;
and2_2072: n_2388 <=  n_2389  AND n_2390;
delay_2073: n_2389  <= TRANSPORT A(1)  ;
delay_2074: n_2390  <= TRANSPORT a_LC4_B1  ;
and1_2075: n_2391 <=  n_2392;
delay_2076: n_2392  <= TRANSPORT a_LC2_B15  ;
and1_2077: n_2393 <=  gnd;
delay_2078: a_LC1_B12  <= TRANSPORT a_EQ050  ;
xor2_2079: a_EQ050 <=  n_2396  XOR n_2405;
or2_2080: n_2396 <=  n_2397  OR n_2401;
and2_2081: n_2397 <=  n_2398  AND n_2400;
delay_2082: n_2398  <= TRANSPORT a_SPORTBINREG_F7_G  ;
delay_2083: n_2400  <= TRANSPORT a_SCONTROLREG_F2_G  ;
and2_2084: n_2401 <=  n_2402  AND n_2404;
delay_2085: n_2402  <= TRANSPORT PBin(7)  ;
inv_2086: n_2404  <= TRANSPORT NOT a_SCONTROLREG_F2_G  ;
and1_2087: n_2405 <=  gnd;
delay_2088: a_LC6_B15  <= TRANSPORT a_EQ049  ;
xor2_2089: a_EQ049 <=  n_2408  XOR n_2421;
or3_2090: n_2408 <=  n_2409  OR n_2413  OR n_2416;
and2_2091: n_2409 <=  n_2410  AND n_2412;
delay_2092: n_2410  <= TRANSPORT a_SPORTAINREG_F7_G  ;
delay_2093: n_2412  <= TRANSPORT a_SCONTROLREG_F6_G  ;
and2_2094: n_2413 <=  n_2414  AND n_2415;
delay_2095: n_2414  <= TRANSPORT a_SPORTAINREG_F7_G  ;
delay_2096: n_2415  <= TRANSPORT a_SCONTROLREG_F5_G  ;
and3_2097: n_2416 <=  n_2417  AND n_2419  AND n_2420;
delay_2098: n_2417  <= TRANSPORT PAin(7)  ;
inv_2099: n_2419  <= TRANSPORT NOT a_SCONTROLREG_F5_G  ;
inv_2100: n_2420  <= TRANSPORT NOT a_SCONTROLREG_F6_G  ;
and1_2101: n_2421 <=  gnd;
delay_2102: a_LC5_B15  <= TRANSPORT a_EQ051  ;
xor2_2103: a_EQ051 <=  n_2424  XOR n_2431;
or2_2104: n_2424 <=  n_2425  OR n_2428;
and2_2105: n_2425 <=  n_2426  AND n_2427;
delay_2106: n_2426  <= TRANSPORT A(0)  ;
delay_2107: n_2427  <= TRANSPORT a_LC1_B12  ;
and2_2108: n_2428 <=  n_2429  AND n_2430;
inv_2109: n_2429  <= TRANSPORT NOT A(0)  ;
delay_2110: n_2430  <= TRANSPORT a_LC6_B15  ;
and1_2111: n_2431 <=  gnd;
delay_2112: a_G152  <= TRANSPORT a_EQ052  ;
xor2_2113: a_EQ052 <=  n_2434  XOR n_2444;
or3_2114: n_2434 <=  n_2435  OR n_2438  OR n_2441;
and2_2115: n_2435 <=  n_2436  AND n_2437;
inv_2116: n_2436  <= TRANSPORT NOT A(1)  ;
delay_2117: n_2437  <= TRANSPORT a_LC5_B15  ;
and2_2118: n_2438 <=  n_2439  AND n_2440;
delay_2119: n_2439  <= TRANSPORT A(1)  ;
delay_2120: n_2440  <= TRANSPORT PCin(7)  ;
and2_2121: n_2441 <=  n_2442  AND n_2443;
delay_2122: n_2442  <= TRANSPORT A(1)  ;
delay_2123: n_2443  <= TRANSPORT A(0)  ;
and1_2124: n_2444 <=  gnd;
delay_2125: a_SPAEN  <= TRANSPORT a_EQ173  ;
xor2_2126: a_EQ173 <=  n_2446  XOR n_2453;
or2_2127: n_2446 <=  n_2447  OR n_2450;
and2_2128: n_2447 <=  n_2448  AND n_2449;
delay_2129: n_2448  <= TRANSPORT a_SCONTROLREG_F4_G_aNOT  ;
inv_2130: n_2449  <= TRANSPORT NOT a_SCONTROLREG_F6_G  ;
and2_2131: n_2450 <=  n_2451  AND n_2452;
delay_2132: n_2451  <= TRANSPORT a_SCONTROLREG_F6_G  ;
inv_2133: n_2452  <= TRANSPORT NOT PCin(6)  ;
and1_2134: n_2453 <=  gnd;
dff_2135: DFF_a8255

    PORT MAP ( D => a_EQ176, CLK => a_SPORTAINREG_F2_G_aCLK, CLRN => a_SPORTAINREG_F2_G_aCLRN,
          PRN => vcc, Q => a_SPORTAINREG_F2_G);
inv_2136: a_SPORTAINREG_F2_G_aCLRN  <= TRANSPORT NOT RESET  ;
xor2_2137: a_EQ176 <=  n_2460  XOR n_2467;
or2_2138: n_2460 <=  n_2461  OR n_2464;
and2_2139: n_2461 <=  n_2462  AND n_2463;
delay_2140: n_2462  <= TRANSPORT a_SPORTAINREG_F2_G  ;
delay_2141: n_2463  <= TRANSPORT PCin(4)  ;
and2_2142: n_2464 <=  n_2465  AND n_2466;
delay_2143: n_2465  <= TRANSPORT PAin(2)  ;
inv_2144: n_2466  <= TRANSPORT NOT PCin(4)  ;
and1_2145: n_2467 <=  gnd;
delay_2146: n_2468  <= TRANSPORT CLK  ;
filter_2147: FILTER_a8255

    PORT MAP (IN1 => n_2468, Y => a_SPORTAINREG_F2_G_aCLK);
dff_2148: DFF_a8255

    PORT MAP ( D => a_EQ182, CLK => a_SPORTBINREG_F0_G_aCLK, CLRN => a_SPORTBINREG_F0_G_aCLRN,
          PRN => vcc, Q => a_SPORTBINREG_F0_G);
inv_2149: a_SPORTBINREG_F0_G_aCLRN  <= TRANSPORT NOT RESET  ;
xor2_2150: a_EQ182 <=  n_2476  XOR n_2483;
or2_2151: n_2476 <=  n_2477  OR n_2480;
and2_2152: n_2477 <=  n_2478  AND n_2479;
delay_2153: n_2478  <= TRANSPORT a_SPORTBINREG_F0_G  ;
delay_2154: n_2479  <= TRANSPORT PCin(2)  ;
and2_2155: n_2480 <=  n_2481  AND n_2482;
delay_2156: n_2481  <= TRANSPORT PBin(0)  ;
inv_2157: n_2482  <= TRANSPORT NOT PCin(2)  ;
and1_2158: n_2483 <=  gnd;
delay_2159: n_2484  <= TRANSPORT CLK  ;
filter_2160: FILTER_a8255

    PORT MAP (IN1 => n_2484, Y => a_SPORTBINREG_F0_G_aCLK);
dff_2161: DFF_a8255

    PORT MAP ( D => a_EQ189, CLK => a_SPORTBINREG_F7_G_aCLK, CLRN => a_SPORTBINREG_F7_G_aCLRN,
          PRN => vcc, Q => a_SPORTBINREG_F7_G);
inv_2162: a_SPORTBINREG_F7_G_aCLRN  <= TRANSPORT NOT RESET  ;
xor2_2163: a_EQ189 <=  n_2492  XOR n_2499;
or2_2164: n_2492 <=  n_2493  OR n_2496;
and2_2165: n_2493 <=  n_2494  AND n_2495;
delay_2166: n_2494  <= TRANSPORT a_SPORTBINREG_F7_G  ;
delay_2167: n_2495  <= TRANSPORT PCin(2)  ;
and2_2168: n_2496 <=  n_2497  AND n_2498;
delay_2169: n_2497  <= TRANSPORT PBin(7)  ;
inv_2170: n_2498  <= TRANSPORT NOT PCin(2)  ;
and1_2171: n_2499 <=  gnd;
delay_2172: n_2500  <= TRANSPORT CLK  ;
filter_2173: FILTER_a8255

    PORT MAP (IN1 => n_2500, Y => a_SPORTBINREG_F7_G_aCLK);
dff_2174: DFF_a8255

    PORT MAP ( D => a_EQ181, CLK => a_SPORTAINREG_F7_G_aCLK, CLRN => a_SPORTAINREG_F7_G_aCLRN,
          PRN => vcc, Q => a_SPORTAINREG_F7_G);
inv_2175: a_SPORTAINREG_F7_G_aCLRN  <= TRANSPORT NOT RESET  ;
xor2_2176: a_EQ181 <=  n_2508  XOR n_2515;
or2_2177: n_2508 <=  n_2509  OR n_2512;
and2_2178: n_2509 <=  n_2510  AND n_2511;
delay_2179: n_2510  <= TRANSPORT PCin(4)  ;
delay_2180: n_2511  <= TRANSPORT a_SPORTAINREG_F7_G  ;
and2_2181: n_2512 <=  n_2513  AND n_2514;
inv_2182: n_2513  <= TRANSPORT NOT PCin(4)  ;
delay_2183: n_2514  <= TRANSPORT PAin(7)  ;
and1_2184: n_2515 <=  gnd;
delay_2185: n_2516  <= TRANSPORT CLK  ;
filter_2186: FILTER_a8255

    PORT MAP (IN1 => n_2516, Y => a_SPORTAINREG_F7_G_aCLK);
delay_2187: a_N42  <= TRANSPORT a_N42_aIN  ;
xor2_2188: a_N42_aIN <=  n_2519  XOR n_2524;
or1_2189: n_2519 <=  n_2520;
and3_2190: n_2520 <=  n_2521  AND n_2522  AND n_2523;
inv_2191: n_2521  <= TRANSPORT NOT nCS  ;
inv_2192: n_2522  <= TRANSPORT NOT nWR  ;
delay_2193: n_2523  <= TRANSPORT A(1)  ;
and1_2194: n_2524 <=  gnd;
delay_2195: a_N46  <= TRANSPORT a_N46_aIN  ;
xor2_2196: a_N46_aIN <=  n_2526  XOR n_2530;
or1_2197: n_2526 <=  n_2527;
and2_2198: n_2527 <=  n_2528  AND n_2529;
delay_2199: n_2528  <= TRANSPORT a_N42  ;
delay_2200: n_2529  <= TRANSPORT A(0)  ;
and1_2201: n_2530 <=  gnd;
dff_2202: DFF_a8255

    PORT MAP ( D => a_EQ171, CLK => a_SCONTROLREG_F5_G_aCLK, CLRN => a_SCONTROLREG_F5_G_aCLRN,
          PRN => vcc, Q => a_SCONTROLREG_F5_G);
inv_2203: a_SCONTROLREG_F5_G_aCLRN  <= TRANSPORT NOT RESET  ;
xor2_2204: a_EQ171 <=  n_2537  XOR n_2548;
or3_2205: n_2537 <=  n_2538  OR n_2542  OR n_2545;
and3_2206: n_2538 <=  n_2539  AND n_2540  AND n_2541;
delay_2207: n_2539  <= TRANSPORT a_N46  ;
delay_2208: n_2540  <= TRANSPORT DIN(5)  ;
delay_2209: n_2541  <= TRANSPORT DIN(7)  ;
and2_2210: n_2542 <=  n_2543  AND n_2544;
delay_2211: n_2543  <= TRANSPORT a_SCONTROLREG_F5_G  ;
inv_2212: n_2544  <= TRANSPORT NOT DIN(7)  ;
and2_2213: n_2545 <=  n_2546  AND n_2547;
inv_2214: n_2546  <= TRANSPORT NOT a_N46  ;
delay_2215: n_2547  <= TRANSPORT a_SCONTROLREG_F5_G  ;
and1_2216: n_2548 <=  gnd;
delay_2217: n_2549  <= TRANSPORT CLK  ;
filter_2218: FILTER_a8255

    PORT MAP (IN1 => n_2549, Y => a_SCONTROLREG_F5_G_aCLK);
dff_2219: DFF_a8255

    PORT MAP ( D => a_EQ174, CLK => a_SPORTAINREG_F0_G_aCLK, CLRN => a_SPORTAINREG_F0_G_aCLRN,
          PRN => vcc, Q => a_SPORTAINREG_F0_G);
inv_2220: a_SPORTAINREG_F0_G_aCLRN  <= TRANSPORT NOT RESET  ;
xor2_2221: a_EQ174 <=  n_2557  XOR n_2564;
or2_2222: n_2557 <=  n_2558  OR n_2561;
and2_2223: n_2558 <=  n_2559  AND n_2560;
delay_2224: n_2559  <= TRANSPORT PCin(4)  ;
delay_2225: n_2560  <= TRANSPORT a_SPORTAINREG_F0_G  ;
and2_2226: n_2561 <=  n_2562  AND n_2563;
inv_2227: n_2562  <= TRANSPORT NOT PCin(4)  ;
delay_2228: n_2563  <= TRANSPORT PAin(0)  ;
and1_2229: n_2564 <=  gnd;
delay_2230: n_2565  <= TRANSPORT CLK  ;
filter_2231: FILTER_a8255

    PORT MAP (IN1 => n_2565, Y => a_SPORTAINREG_F0_G_aCLK);
dff_2232: DFF_a8255

    PORT MAP ( D => a_EQ183, CLK => a_SPORTBINREG_F1_G_aCLK, CLRN => a_SPORTBINREG_F1_G_aCLRN,
          PRN => vcc, Q => a_SPORTBINREG_F1_G);
inv_2233: a_SPORTBINREG_F1_G_aCLRN  <= TRANSPORT NOT RESET  ;
xor2_2234: a_EQ183 <=  n_2573  XOR n_2580;
or2_2235: n_2573 <=  n_2574  OR n_2577;
and2_2236: n_2574 <=  n_2575  AND n_2576;
delay_2237: n_2575  <= TRANSPORT a_SPORTBINREG_F1_G  ;
delay_2238: n_2576  <= TRANSPORT PCin(2)  ;
and2_2239: n_2577 <=  n_2578  AND n_2579;
inv_2240: n_2578  <= TRANSPORT NOT PCin(2)  ;
delay_2241: n_2579  <= TRANSPORT PBin(1)  ;
and1_2242: n_2580 <=  gnd;
delay_2243: n_2581  <= TRANSPORT CLK  ;
filter_2244: FILTER_a8255

    PORT MAP (IN1 => n_2581, Y => a_SPORTBINREG_F1_G_aCLK);
dff_2245: DFF_a8255

    PORT MAP ( D => a_EQ175, CLK => a_SPORTAINREG_F1_G_aCLK, CLRN => a_SPORTAINREG_F1_G_aCLRN,
          PRN => vcc, Q => a_SPORTAINREG_F1_G);
inv_2246: a_SPORTAINREG_F1_G_aCLRN  <= TRANSPORT NOT RESET  ;
xor2_2247: a_EQ175 <=  n_2589  XOR n_2596;
or2_2248: n_2589 <=  n_2590  OR n_2593;
and2_2249: n_2590 <=  n_2591  AND n_2592;
delay_2250: n_2591  <= TRANSPORT PCin(4)  ;
delay_2251: n_2592  <= TRANSPORT a_SPORTAINREG_F1_G  ;
and2_2252: n_2593 <=  n_2594  AND n_2595;
inv_2253: n_2594  <= TRANSPORT NOT PCin(4)  ;
delay_2254: n_2595  <= TRANSPORT PAin(1)  ;
and1_2255: n_2596 <=  gnd;
delay_2256: n_2597  <= TRANSPORT CLK  ;
filter_2257: FILTER_a8255

    PORT MAP (IN1 => n_2597, Y => a_SPORTAINREG_F1_G_aCLK);
dff_2258: DFF_a8255

    PORT MAP ( D => a_EQ184, CLK => a_SPORTBINREG_F2_G_aCLK, CLRN => a_SPORTBINREG_F2_G_aCLRN,
          PRN => vcc, Q => a_SPORTBINREG_F2_G);
inv_2259: a_SPORTBINREG_F2_G_aCLRN  <= TRANSPORT NOT RESET  ;
xor2_2260: a_EQ184 <=  n_2605  XOR n_2612;
or2_2261: n_2605 <=  n_2606  OR n_2609;
and2_2262: n_2606 <=  n_2607  AND n_2608;
delay_2263: n_2607  <= TRANSPORT a_SPORTBINREG_F2_G  ;
delay_2264: n_2608  <= TRANSPORT PCin(2)  ;
and2_2265: n_2609 <=  n_2610  AND n_2611;
delay_2266: n_2610  <= TRANSPORT PBin(2)  ;
inv_2267: n_2611  <= TRANSPORT NOT PCin(2)  ;
and1_2268: n_2612 <=  gnd;
delay_2269: n_2613  <= TRANSPORT CLK  ;
filter_2270: FILTER_a8255

    PORT MAP (IN1 => n_2613, Y => a_SPORTBINREG_F2_G_aCLK);
dff_2271: DFF_a8255

    PORT MAP ( D => a_EQ177, CLK => a_SPORTAINREG_F3_G_aCLK, CLRN => a_SPORTAINREG_F3_G_aCLRN,
          PRN => vcc, Q => a_SPORTAINREG_F3_G);
inv_2272: a_SPORTAINREG_F3_G_aCLRN  <= TRANSPORT NOT RESET  ;
xor2_2273: a_EQ177 <=  n_2621  XOR n_2628;
or2_2274: n_2621 <=  n_2622  OR n_2625;
and2_2275: n_2622 <=  n_2623  AND n_2624;
delay_2276: n_2623  <= TRANSPORT PCin(4)  ;
delay_2277: n_2624  <= TRANSPORT a_SPORTAINREG_F3_G  ;
and2_2278: n_2625 <=  n_2626  AND n_2627;
inv_2279: n_2626  <= TRANSPORT NOT PCin(4)  ;
delay_2280: n_2627  <= TRANSPORT PAin(3)  ;
and1_2281: n_2628 <=  gnd;
delay_2282: n_2629  <= TRANSPORT CLK  ;
filter_2283: FILTER_a8255

    PORT MAP (IN1 => n_2629, Y => a_SPORTAINREG_F3_G_aCLK);
dff_2284: DFF_a8255

    PORT MAP ( D => a_EQ186, CLK => a_SPORTBINREG_F4_G_aCLK, CLRN => a_SPORTBINREG_F4_G_aCLRN,
          PRN => vcc, Q => a_SPORTBINREG_F4_G);
inv_2285: a_SPORTBINREG_F4_G_aCLRN  <= TRANSPORT NOT RESET  ;
xor2_2286: a_EQ186 <=  n_2637  XOR n_2644;
or2_2287: n_2637 <=  n_2638  OR n_2641;
and2_2288: n_2638 <=  n_2639  AND n_2640;
delay_2289: n_2639  <= TRANSPORT PCin(2)  ;
delay_2290: n_2640  <= TRANSPORT a_SPORTBINREG_F4_G  ;
and2_2291: n_2641 <=  n_2642  AND n_2643;
inv_2292: n_2642  <= TRANSPORT NOT PCin(2)  ;
delay_2293: n_2643  <= TRANSPORT PBin(4)  ;
and1_2294: n_2644 <=  gnd;
delay_2295: n_2645  <= TRANSPORT CLK  ;
filter_2296: FILTER_a8255

    PORT MAP (IN1 => n_2645, Y => a_SPORTBINREG_F4_G_aCLK);
dff_2297: DFF_a8255

    PORT MAP ( D => a_EQ178, CLK => a_SPORTAINREG_F4_G_aCLK, CLRN => a_SPORTAINREG_F4_G_aCLRN,
          PRN => vcc, Q => a_SPORTAINREG_F4_G);
inv_2298: a_SPORTAINREG_F4_G_aCLRN  <= TRANSPORT NOT RESET  ;
xor2_2299: a_EQ178 <=  n_2653  XOR n_2660;
or2_2300: n_2653 <=  n_2654  OR n_2657;
and2_2301: n_2654 <=  n_2655  AND n_2656;
delay_2302: n_2655  <= TRANSPORT PCin(4)  ;
delay_2303: n_2656  <= TRANSPORT a_SPORTAINREG_F4_G  ;
and2_2304: n_2657 <=  n_2658  AND n_2659;
inv_2305: n_2658  <= TRANSPORT NOT PCin(4)  ;
delay_2306: n_2659  <= TRANSPORT PAin(4)  ;
and1_2307: n_2660 <=  gnd;
delay_2308: n_2661  <= TRANSPORT CLK  ;
filter_2309: FILTER_a8255

    PORT MAP (IN1 => n_2661, Y => a_SPORTAINREG_F4_G_aCLK);
dff_2310: DFF_a8255

    PORT MAP ( D => a_EQ179, CLK => a_SPORTAINREG_F5_G_aCLK, CLRN => a_SPORTAINREG_F5_G_aCLRN,
          PRN => vcc, Q => a_SPORTAINREG_F5_G);
inv_2311: a_SPORTAINREG_F5_G_aCLRN  <= TRANSPORT NOT RESET  ;
xor2_2312: a_EQ179 <=  n_2669  XOR n_2676;
or2_2313: n_2669 <=  n_2670  OR n_2673;
and2_2314: n_2670 <=  n_2671  AND n_2672;
delay_2315: n_2671  <= TRANSPORT PCin(4)  ;
delay_2316: n_2672  <= TRANSPORT a_SPORTAINREG_F5_G  ;
and2_2317: n_2673 <=  n_2674  AND n_2675;
inv_2318: n_2674  <= TRANSPORT NOT PCin(4)  ;
delay_2319: n_2675  <= TRANSPORT PAin(5)  ;
and1_2320: n_2676 <=  gnd;
delay_2321: n_2677  <= TRANSPORT CLK  ;
filter_2322: FILTER_a8255

    PORT MAP (IN1 => n_2677, Y => a_SPORTAINREG_F5_G_aCLK);
dff_2323: DFF_a8255

    PORT MAP ( D => a_EQ187, CLK => a_SPORTBINREG_F5_G_aCLK, CLRN => a_SPORTBINREG_F5_G_aCLRN,
          PRN => vcc, Q => a_SPORTBINREG_F5_G);
inv_2324: a_SPORTBINREG_F5_G_aCLRN  <= TRANSPORT NOT RESET  ;
xor2_2325: a_EQ187 <=  n_2685  XOR n_2692;
or2_2326: n_2685 <=  n_2686  OR n_2689;
and2_2327: n_2686 <=  n_2687  AND n_2688;
delay_2328: n_2687  <= TRANSPORT PCin(2)  ;
delay_2329: n_2688  <= TRANSPORT a_SPORTBINREG_F5_G  ;
and2_2330: n_2689 <=  n_2690  AND n_2691;
inv_2331: n_2690  <= TRANSPORT NOT PCin(2)  ;
delay_2332: n_2691  <= TRANSPORT PBin(5)  ;
and1_2333: n_2692 <=  gnd;
delay_2334: n_2693  <= TRANSPORT CLK  ;
filter_2335: FILTER_a8255

    PORT MAP (IN1 => n_2693, Y => a_SPORTBINREG_F5_G_aCLK);
dff_2336: DFF_a8255

    PORT MAP ( D => a_EQ188, CLK => a_SPORTBINREG_F6_G_aCLK, CLRN => a_SPORTBINREG_F6_G_aCLRN,
          PRN => vcc, Q => a_SPORTBINREG_F6_G);
inv_2337: a_SPORTBINREG_F6_G_aCLRN  <= TRANSPORT NOT RESET  ;
xor2_2338: a_EQ188 <=  n_2701  XOR n_2708;
or2_2339: n_2701 <=  n_2702  OR n_2705;
and2_2340: n_2702 <=  n_2703  AND n_2704;
delay_2341: n_2703  <= TRANSPORT PCin(2)  ;
delay_2342: n_2704  <= TRANSPORT a_SPORTBINREG_F6_G  ;
and2_2343: n_2705 <=  n_2706  AND n_2707;
inv_2344: n_2706  <= TRANSPORT NOT PCin(2)  ;
delay_2345: n_2707  <= TRANSPORT PBin(6)  ;
and1_2346: n_2708 <=  gnd;
delay_2347: n_2709  <= TRANSPORT CLK  ;
filter_2348: FILTER_a8255

    PORT MAP (IN1 => n_2709, Y => a_SPORTBINREG_F6_G_aCLK);
dff_2349: DFF_a8255

    PORT MAP ( D => a_EQ180, CLK => a_SPORTAINREG_F6_G_aCLK, CLRN => a_SPORTAINREG_F6_G_aCLRN,
          PRN => vcc, Q => a_SPORTAINREG_F6_G);
inv_2350: a_SPORTAINREG_F6_G_aCLRN  <= TRANSPORT NOT RESET  ;
xor2_2351: a_EQ180 <=  n_2717  XOR n_2724;
or2_2352: n_2717 <=  n_2718  OR n_2721;
and2_2353: n_2718 <=  n_2719  AND n_2720;
delay_2354: n_2719  <= TRANSPORT PCin(4)  ;
delay_2355: n_2720  <= TRANSPORT a_SPORTAINREG_F6_G  ;
and2_2356: n_2721 <=  n_2722  AND n_2723;
inv_2357: n_2722  <= TRANSPORT NOT PCin(4)  ;
delay_2358: n_2723  <= TRANSPORT PAin(6)  ;
and1_2359: n_2724 <=  gnd;
delay_2360: n_2725  <= TRANSPORT CLK  ;
filter_2361: FILTER_a8255

    PORT MAP (IN1 => n_2725, Y => a_SPORTAINREG_F6_G_aCLK);
dff_2362: DFF_a8255

    PORT MAP ( D => a_EQ185, CLK => a_SPORTBINREG_F3_G_aCLK, CLRN => a_SPORTBINREG_F3_G_aCLRN,
          PRN => vcc, Q => a_SPORTBINREG_F3_G);
inv_2363: a_SPORTBINREG_F3_G_aCLRN  <= TRANSPORT NOT RESET  ;
xor2_2364: a_EQ185 <=  n_2733  XOR n_2740;
or2_2365: n_2733 <=  n_2734  OR n_2737;
and2_2366: n_2734 <=  n_2735  AND n_2736;
delay_2367: n_2735  <= TRANSPORT PCin(2)  ;
delay_2368: n_2736  <= TRANSPORT a_SPORTBINREG_F3_G  ;
and2_2369: n_2737 <=  n_2738  AND n_2739;
inv_2370: n_2738  <= TRANSPORT NOT PCin(2)  ;
delay_2371: n_2739  <= TRANSPORT PBin(3)  ;
and1_2372: n_2740 <=  gnd;
delay_2373: n_2741  <= TRANSPORT CLK  ;
filter_2374: FILTER_a8255

    PORT MAP (IN1 => n_2741, Y => a_SPORTBINREG_F3_G_aCLK);
dff_2375: DFF_a8255

    PORT MAP ( D => a_EQ170, CLK => a_SCONTROLREG_F4_G_aNOT_aCLK, CLRN => a_SCONTROLREG_F4_G_aNOT_aCLRN,
          PRN => vcc, Q => a_SCONTROLREG_F4_G_aNOT);
inv_2376: a_SCONTROLREG_F4_G_aNOT_aCLRN  <= TRANSPORT NOT RESET  ;
xor2_2377: a_EQ170 <=  n_2749  XOR n_2760;
or3_2378: n_2749 <=  n_2750  OR n_2754  OR n_2757;
and3_2379: n_2750 <=  n_2751  AND n_2752  AND n_2753;
delay_2380: n_2751  <= TRANSPORT a_N46  ;
delay_2381: n_2752  <= TRANSPORT DIN(7)  ;
inv_2382: n_2753  <= TRANSPORT NOT DIN(4)  ;
and2_2383: n_2754 <=  n_2755  AND n_2756;
inv_2384: n_2755  <= TRANSPORT NOT DIN(7)  ;
delay_2385: n_2756  <= TRANSPORT a_SCONTROLREG_F4_G_aNOT  ;
and2_2386: n_2757 <=  n_2758  AND n_2759;
inv_2387: n_2758  <= TRANSPORT NOT a_N46  ;
delay_2388: n_2759  <= TRANSPORT a_SCONTROLREG_F4_G_aNOT  ;
and1_2389: n_2760 <=  gnd;
delay_2390: n_2761  <= TRANSPORT CLK  ;
filter_2391: FILTER_a8255

    PORT MAP (IN1 => n_2761, Y => a_SCONTROLREG_F4_G_aNOT_aCLK);
dff_2392: DFF_a8255

    PORT MAP ( D => a_EQ172, CLK => a_SCONTROLREG_F6_G_aCLK, CLRN => a_SCONTROLREG_F6_G_aCLRN,
          PRN => vcc, Q => a_SCONTROLREG_F6_G);
inv_2393: a_SCONTROLREG_F6_G_aCLRN  <= TRANSPORT NOT RESET  ;
xor2_2394: a_EQ172 <=  n_2769  XOR n_2780;
or3_2395: n_2769 <=  n_2770  OR n_2774  OR n_2777;
and3_2396: n_2770 <=  n_2771  AND n_2772  AND n_2773;
delay_2397: n_2771  <= TRANSPORT a_N46  ;
delay_2398: n_2772  <= TRANSPORT DIN(7)  ;
delay_2399: n_2773  <= TRANSPORT DIN(6)  ;
and2_2400: n_2774 <=  n_2775  AND n_2776;
inv_2401: n_2775  <= TRANSPORT NOT DIN(7)  ;
delay_2402: n_2776  <= TRANSPORT a_SCONTROLREG_F6_G  ;
and2_2403: n_2777 <=  n_2778  AND n_2779;
inv_2404: n_2778  <= TRANSPORT NOT a_N46  ;
delay_2405: n_2779  <= TRANSPORT a_SCONTROLREG_F6_G  ;
and1_2406: n_2780 <=  gnd;
delay_2407: n_2781  <= TRANSPORT CLK  ;
filter_2408: FILTER_a8255

    PORT MAP (IN1 => n_2781, Y => a_SCONTROLREG_F6_G_aCLK);
dff_2409: DFF_a8255

    PORT MAP ( D => a_EQ166, CLK => a_SCONTROLREG_F0_G_aNOT_aCLK, CLRN => a_SCONTROLREG_F0_G_aNOT_aCLRN,
          PRN => vcc, Q => a_SCONTROLREG_F0_G_aNOT);
inv_2410: a_SCONTROLREG_F0_G_aNOT_aCLRN  <= TRANSPORT NOT RESET  ;
xor2_2411: a_EQ166 <=  n_2789  XOR n_2800;
or3_2412: n_2789 <=  n_2790  OR n_2794  OR n_2797;
and3_2413: n_2790 <=  n_2791  AND n_2792  AND n_2793;
delay_2414: n_2791  <= TRANSPORT a_N46  ;
delay_2415: n_2792  <= TRANSPORT DIN(7)  ;
inv_2416: n_2793  <= TRANSPORT NOT DIN(0)  ;
and2_2417: n_2794 <=  n_2795  AND n_2796;
inv_2418: n_2795  <= TRANSPORT NOT DIN(7)  ;
delay_2419: n_2796  <= TRANSPORT a_SCONTROLREG_F0_G_aNOT  ;
and2_2420: n_2797 <=  n_2798  AND n_2799;
inv_2421: n_2798  <= TRANSPORT NOT a_N46  ;
delay_2422: n_2799  <= TRANSPORT a_SCONTROLREG_F0_G_aNOT  ;
and1_2423: n_2800 <=  gnd;
delay_2424: n_2801  <= TRANSPORT CLK  ;
filter_2425: FILTER_a8255

    PORT MAP (IN1 => n_2801, Y => a_SCONTROLREG_F0_G_aNOT_aCLK);
dff_2426: DFF_a8255

    PORT MAP ( D => a_EQ168, CLK => a_SCONTROLREG_F2_G_aCLK, CLRN => a_SCONTROLREG_F2_G_aCLRN,
          PRN => vcc, Q => a_SCONTROLREG_F2_G);
inv_2427: a_SCONTROLREG_F2_G_aCLRN  <= TRANSPORT NOT RESET  ;
xor2_2428: a_EQ168 <=  n_2809  XOR n_2820;
or3_2429: n_2809 <=  n_2810  OR n_2814  OR n_2817;
and3_2430: n_2810 <=  n_2811  AND n_2812  AND n_2813;
delay_2431: n_2811  <= TRANSPORT a_N46  ;
delay_2432: n_2812  <= TRANSPORT DIN(7)  ;
delay_2433: n_2813  <= TRANSPORT DIN(2)  ;
and2_2434: n_2814 <=  n_2815  AND n_2816;
inv_2435: n_2815  <= TRANSPORT NOT DIN(7)  ;
delay_2436: n_2816  <= TRANSPORT a_SCONTROLREG_F2_G  ;
and2_2437: n_2817 <=  n_2818  AND n_2819;
inv_2438: n_2818  <= TRANSPORT NOT a_N46  ;
delay_2439: n_2819  <= TRANSPORT a_SCONTROLREG_F2_G  ;
and1_2440: n_2820 <=  gnd;
delay_2441: n_2821  <= TRANSPORT CLK  ;
filter_2442: FILTER_a8255

    PORT MAP (IN1 => n_2821, Y => a_SCONTROLREG_F2_G_aCLK);
dff_2443: DFF_a8255

    PORT MAP ( D => a_EQ169, CLK => a_SCONTROLREG_F3_G_aNOT_aCLK, CLRN => a_SCONTROLREG_F3_G_aNOT_aCLRN,
          PRN => vcc, Q => a_SCONTROLREG_F3_G_aNOT);
inv_2444: a_SCONTROLREG_F3_G_aNOT_aCLRN  <= TRANSPORT NOT RESET  ;
xor2_2445: a_EQ169 <=  n_2829  XOR n_2840;
or3_2446: n_2829 <=  n_2830  OR n_2834  OR n_2837;
and3_2447: n_2830 <=  n_2831  AND n_2832  AND n_2833;
delay_2448: n_2831  <= TRANSPORT a_N46  ;
delay_2449: n_2832  <= TRANSPORT DIN(7)  ;
inv_2450: n_2833  <= TRANSPORT NOT DIN(3)  ;
and2_2451: n_2834 <=  n_2835  AND n_2836;
inv_2452: n_2835  <= TRANSPORT NOT DIN(7)  ;
delay_2453: n_2836  <= TRANSPORT a_SCONTROLREG_F3_G_aNOT  ;
and2_2454: n_2837 <=  n_2838  AND n_2839;
inv_2455: n_2838  <= TRANSPORT NOT a_N46  ;
delay_2456: n_2839  <= TRANSPORT a_SCONTROLREG_F3_G_aNOT  ;
and1_2457: n_2840 <=  gnd;
delay_2458: n_2841  <= TRANSPORT CLK  ;
filter_2459: FILTER_a8255

    PORT MAP (IN1 => n_2841, Y => a_SCONTROLREG_F3_G_aNOT_aCLK);
delay_2460: a_LC2_A11  <= TRANSPORT a_EQ134  ;
xor2_2461: a_EQ134 <=  n_2845  XOR n_2854;
or3_2462: n_2845 <=  n_2846  OR n_2849  OR n_2852;
and2_2463: n_2846 <=  n_2847  AND n_2848;
delay_2464: n_2847  <= TRANSPORT nWR  ;
delay_2465: n_2848  <= TRANSPORT a_SCONTROLREG_F1_G_aNOT  ;
and2_2466: n_2849 <=  n_2850  AND n_2851;
delay_2467: n_2850  <= TRANSPORT nWR  ;
delay_2468: n_2851  <= TRANSPORT A(1)  ;
and1_2469: n_2852 <=  n_2853;
delay_2470: n_2853  <= TRANSPORT nCS  ;
and1_2471: n_2854 <=  gnd;
delay_2472: a_LC8_A8  <= TRANSPORT a_EQ135  ;
xor2_2473: a_EQ135 <=  n_2857  XOR n_2864;
or2_2474: n_2857 <=  n_2858  OR n_2860;
and1_2475: n_2858 <=  n_2859;
delay_2476: n_2859  <= TRANSPORT a_LC2_A11  ;
and3_2477: n_2860 <=  n_2861  AND n_2862  AND n_2863;
inv_2478: n_2861  <= TRANSPORT NOT A(1)  ;
delay_2479: n_2862  <= TRANSPORT nRD  ;
inv_2480: n_2863  <= TRANSPORT NOT a_SCONTROLREG_F1_G_aNOT  ;
and1_2481: n_2864 <=  gnd;
dff_2482: DFF_a8255

    PORT MAP ( D => a_N593_aD, CLK => a_N593_aCLK, CLRN => a_N593_aCLRN, PRN => vcc,
          Q => a_N593);
inv_2483: a_N593_aCLRN  <= TRANSPORT NOT RESET  ;
xor2_2484: a_N593_aD <=  n_2872  XOR n_2875;
or1_2485: n_2872 <=  n_2873;
and1_2486: n_2873 <=  n_2874;
delay_2487: n_2874  <= TRANSPORT PCin(2)  ;
and1_2488: n_2875 <=  gnd;
delay_2489: n_2876  <= TRANSPORT CLK  ;
filter_2490: FILTER_a8255

    PORT MAP (IN1 => n_2876, Y => a_N593_aCLK);
delay_2491: a_N286  <= TRANSPORT a_N286_aIN  ;
xor2_2492: a_N286_aIN <=  n_2879  XOR n_2884;
or1_2493: n_2879 <=  n_2880;
and3_2494: n_2880 <=  n_2881  AND n_2882  AND n_2883;
delay_2495: n_2881  <= TRANSPORT PCin(2)  ;
inv_2496: n_2882  <= TRANSPORT NOT a_N593  ;
delay_2497: n_2883  <= TRANSPORT a_LC8_A21  ;
and1_2498: n_2884 <=  gnd;
delay_2499: a_N270_aNOT  <= TRANSPORT a_N270_aNOT_aIN  ;
xor2_2500: a_N270_aNOT_aIN <=  n_2886  XOR n_2891;
or1_2501: n_2886 <=  n_2887;
and3_2502: n_2887 <=  n_2888  AND n_2889  AND n_2890;
delay_2503: n_2888  <= TRANSPORT a_SCONTROLREG_F2_G  ;
delay_2504: n_2889  <= TRANSPORT a_N286  ;
delay_2505: n_2890  <= TRANSPORT a_LC6_A2  ;
and1_2506: n_2891 <=  gnd;
delay_2507: a_LC7_A8  <= TRANSPORT a_EQ136  ;
xor2_2508: a_EQ136 <=  n_2893  XOR n_2901;
or2_2509: n_2893 <=  n_2894  OR n_2898;
and3_2510: n_2894 <=  n_2895  AND n_2896  AND n_2897;
delay_2511: n_2895  <= TRANSPORT a_LC8_A8  ;
inv_2512: n_2896  <= TRANSPORT NOT a_N286  ;
delay_2513: n_2897  <= TRANSPORT a_LC6_A8  ;
and2_2514: n_2898 <=  n_2899  AND n_2900;
delay_2515: n_2899  <= TRANSPORT a_LC8_A8  ;
delay_2516: n_2900  <= TRANSPORT a_N270_aNOT  ;
and1_2517: n_2901 <=  gnd;
delay_2518: a_N62  <= TRANSPORT a_EQ101  ;
xor2_2519: a_EQ101 <=  n_2903  XOR n_2912;
or4_2520: n_2903 <=  n_2904  OR n_2906  OR n_2908  OR n_2910;
and1_2521: n_2904 <=  n_2905;
delay_2522: n_2905  <= TRANSPORT DIN(1)  ;
and1_2523: n_2906 <=  n_2907;
delay_2524: n_2907  <= TRANSPORT DIN(2)  ;
and1_2525: n_2908 <=  n_2909;
delay_2526: n_2909  <= TRANSPORT DIN(7)  ;
and1_2527: n_2910 <=  n_2911;
delay_2528: n_2911  <= TRANSPORT DIN(3)  ;
and1_2529: n_2912 <=  gnd;

END Version_1_0;
