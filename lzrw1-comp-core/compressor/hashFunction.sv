/*
This calculates the hashFunction to index the table of pointers.
 
input toHash; 3 bytes from the compinput
output fromHash; 12 bits to index the table

Portland State University
ECE571 Final Project
by Mark Chernishoff, Parker Ridd, Manas Karanjekar

*/

module hashFunction (
input reset,
//input [RANDTABLE:0][11:0] uniqnums, /* table of all unique numbers from testbench*/
input [23:0] toHash, /* from compinput */
output logic [11:0] fromHash); /* to tableofPtr*/

logic [11:0] uniqnums[4096] = '{4043, 2994, 3534, 2105, 292, 1570, 836, 1160, 2860, 3079, 3233, 2401, 32, 522, 3350, 208,2089, 1412, 3033, 899, 3358, 1389, 607, 1198, 290, 2743, 3194, 3283, 4046, 3834, 280, 3577,1776, 3876, 2319, 3393, 2870, 781, 317, 2556, 3650, 2323, 174, 182, 1631, 1956, 2640, 3006,99, 2363, 145, 1699, 1964, 2906, 3906, 2821, 583, 3888, 3981, 1168, 4077, 1566, 819, 2084,421, 3507, 2351, 2013, 90, 2383, 3703, 2634, 565, 1077, 3935, 892, 1351, 4013, 2510, 3440,3241, 715, 1403, 1217, 2585, 3598, 3604, 1044, 2804, 2036, 675, 1919, 3564, 1523, 3329, 1302,1709, 642, 3897, 3820, 3010, 872, 2823, 1504, 319, 3937, 2945, 2066, 3635, 252, 2629, 2577,1899, 2850, 2222, 3848, 2606, 2035, 2711, 3890, 2425, 2163, 374, 1941, 2008, 251, 3055, 3127,3371, 3224, 3686, 1099, 2716, 1406, 96, 3909, 335, 3023, 3203, 1493, 2852, 3003, 1549, 3412,2260, 520, 3921, 1972, 3742, 2691, 1123, 180, 3657, 907, 3183, 2610, 2080, 688, 1601, 1396,467, 3002, 1456, 3977, 764, 1891, 1336, 3795, 2231, 1928, 1764, 3484, 2423, 2966, 2757, 1375,4078, 3714, 2393, 2261, 187, 2364, 4061, 3892, 1376, 56, 15, 1026, 3760, 1371, 2703, 1943,1170, 2044, 1967, 3111, 1286, 1244, 2011, 39, 751, 1625, 3748, 1518, 3606, 574, 2380, 1557,3209, 2978, 842, 1531, 3248, 64, 3780, 197, 2926, 1252, 2444, 674, 3794, 2831, 2186, 3198,4058, 1860, 2837, 134, 2243, 2016, 687, 3057, 1292, 156, 1743, 3995, 2346, 546, 2010, 3539,1154, 896, 2557, 570, 190, 817, 1846, 2115, 556, 3065, 2575, 745, 2724, 2834, 2292, 2258,1349, 98, 943, 3376, 1373, 3124, 1799, 1670, 3157, 2420, 1066, 1669, 3346, 1296, 3437, 2688,117, 3219, 3609, 2146, 3673, 921, 974, 1138, 2355, 1018, 431, 3275, 2964, 912, 166, 2456,2655, 2815, 3228, 1122, 1271, 3723, 2706, 577, 3282, 1119, 123, 3911, 3252, 1521, 1626, 933,1416, 1142, 1802, 1679, 2299, 240, 2461, 2481, 521, 1696, 426, 1035, 2093, 1060, 1228, 470,1359, 3032, 1511, 2912, 392, 3420, 4002, 3853, 2244, 548, 1944, 279, 1723, 601, 3457, 713,3148, 1618, 2104, 1949, 3656, 1564, 1432, 28, 1216, 171, 1688, 1140, 1211, 796, 3401, 2879,2744, 3504, 3011, 1108, 2765, 492, 415, 2702, 1236, 564, 680, 2140, 3857, 2967, 2248, 256,4016, 286, 2954, 1644, 1869, 2294, 2410, 305, 2324, 710, 4056, 2871, 3801, 4092, 3424, 2405,2424, 617, 1191, 677, 3385, 3839, 863, 2281, 1490, 2455, 1239, 2708, 3366, 1921, 102, 2652,722, 769, 3903, 2386, 1615, 120, 510, 3510, 1364, 201, 2148, 2371, 1786, 1157, 1116, 2885,114, 1408, 3051, 5, 1800, 895, 3705, 1803, 1388, 206, 3335, 2627, 2656, 1238, 2738, 3045,3208, 909, 2234, 746, 1883, 1210, 248, 86, 1362, 2996, 3186, 3828, 1801, 3321, 1461, 3910,3472, 604, 3475, 1332, 1152, 3411, 2936, 188, 3199, 1115, 2293, 1558, 1455, 708, 1465, 3730,2526, 1209, 979, 4064, 412, 869, 1682, 2624, 2256, 1604, 1196, 1856, 3505, 2549, 1501, 1480,159, 3989, 3867, 773, 1227, 1121, 3277, 162, 264, 2479, 1585, 1663, 1280, 1325, 2235, 3546,3685, 1725, 3137, 1498, 3172, 2047, 3776, 45, 3136, 631, 1715, 1383, 74, 4021, 1784, 1882,3829, 2998, 2934, 143, 29, 2678, 307, 3646, 853, 767, 1038, 670, 957, 3710, 3395, 3225,2297, 225, 3204, 3061, 3098, 204, 3690, 1000, 2175, 1807, 2825, 828, 845, 612, 740, 1938,3581, 3273, 1999, 622, 1300, 1681, 1014, 932, 444, 3889, 1915, 3914, 131, 1853, 988, 299,1540, 411, 3318, 386, 3632, 3018, 1917, 3740, 1134, 334, 3021, 1237, 3088, 121, 507, 3359,3349, 1440, 824, 2069, 1509, 3885, 2189, 2529, 1852, 2581, 1419, 1599, 2944, 1659, 1059, 563,172, 2630, 2766, 358, 3218, 2517, 1321, 0, 3883, 800, 2982, 2188, 903, 1337, 3565, 2520,3516, 2416, 1634, 3586, 3316, 2750, 474, 1411, 1545, 4052, 1329, 700, 749, 3643, 2913, 2848,407, 1637, 3541, 1942, 3168, 3477, 1135, 3258, 3295, 1965, 2759, 3110, 1655, 1145, 2787, 1685,1356, 1969, 1149, 3466, 1814, 1268, 2062, 3797, 3297, 1072, 666, 1811, 1578, 2284, 1579, 2892,4088, 1711, 3372, 1193, 1224, 3497, 693, 3071, 2422, 2816, 3220, 1754, 2863, 4063, 2406, 3997,3519, 1684, 2063, 1750, 908, 569, 2797, 97, 832, 202, 484, 3425, 1712, 628, 2720, 2522,2390, 3872, 2070, 2408, 2595, 3787, 1283, 2775, 858, 1460, 3378, 859, 3845, 1139, 1012, 11,550, 3792, 1062, 3255, 925, 2322, 2861, 1606, 3069, 3076, 1081, 848, 1136, 1693, 231, 3447,2173, 2116, 995, 3881, 2276, 3936, 2343, 3084, 3810, 2770, 144, 2660, 81, 3375, 1508, 4079,3099, 408, 3563, 1700, 1165, 3387, 2443, 2867, 275, 3251, 2594, 2824, 2952, 706, 1996, 1680,1735, 4024, 2216, 1397, 1386, 67, 1857, 2071, 975, 4031, 2321, 274, 212, 2182, 508, 633,771, 2786, 512, 2731, 2003, 3874, 2147, 2409, 2048, 3299, 685, 862, 2528, 2897, 3547, 3253,183, 164, 3188, 3012, 2669, 3613, 1448, 3450, 3476, 2979, 1308, 1184, 3620, 3980, 3178, 2083,147, 4019, 3482, 534, 1046, 750, 1426, 1937, 1070, 347, 3920, 1893, 1282, 227, 1037, 1517,2449, 4080, 4041, 894, 1015, 1519, 2564, 2298, 1148, 1837, 3720, 1052, 2042, 1914, 2441, 399,1818, 3102, 3034, 732, 2524, 3134, 3381, 2038, 2304, 3545, 3138, 3875, 704, 2953, 1998, 1354,406, 1671, 2098, 3689, 3898, 3621, 728, 1169, 3651, 3526, 2091, 2545, 3236, 549, 433, 3827,129, 3328, 779, 1205, 336, 553, 2975, 3542, 971, 3263, 2812, 1141, 2642, 425, 752, 3384,1980, 3017, 4075, 2646, 3588, 3243, 2957, 3499, 3535, 2584, 2829, 3399, 2302, 3048, 3996, 1985,2972, 1257, 3777, 3271, 4003, 1328, 3313, 3063, 2734, 2136, 3490, 2633, 1074, 629, 2725, 1966,1737, 3913, 3619, 216, 3957, 4006, 3919, 2820, 2928, 128, 1694, 934, 3114, 443, 2667, 2894,3083, 237, 2263, 2760, 2022, 3445, 2411, 2715, 3672, 1494, 1407, 2569, 3314, 3152, 1340, 31,2997, 2699, 978, 855, 3166, 2970, 2597, 1714, 2916, 830, 2563, 3716, 2548, 560, 736, 3058,2465, 639, 2695, 1022, 1532, 2855, 825, 228, 3928, 3949, 3104, 1690, 518, 329, 920, 1864,3683, 3494, 1468, 2457, 1274, 223, 924, 1459, 3579, 3116, 2840, 614, 1827, 2992, 1021, 2868,692, 820, 2193, 1097, 4007, 246, 888, 1848, 3268, 2685, 3514, 3954, 491, 669, 439, 3356,1672, 1934, 759, 850, 2290, 615, 1405, 3584, 361, 2065, 3473, 3360, 85, 3544, 2015, 3175,860, 3235, 112, 277, 1906, 294, 3128, 572, 2325, 3439, 2729, 371, 2030, 1707, 2214, 3438,998, 738, 1847, 1755, 1537, 3016, 3739, 3001, 3390, 1834, 3227, 3560, 3394, 3029, 268, 1262,486, 3388, 2286, 1895, 4093, 3796, 1488, 1674, 3878, 893, 868, 2040, 1105, 10, 2329, 1322,2844, 27, 1630, 2949, 2333, 3729, 3566, 2877, 523, 707, 1718, 2382, 2257, 2483, 765, 2161,2436, 3786, 6, 1363, 916, 1757, 267, 1649, 940, 1260, 2969, 3793, 2681, 1861, 2056, 4065,2399, 1565, 885, 844, 2689, 721, 2781, 1348, 2176, 3306, 2872, 3373, 3150, 598, 1822, 3557,4072, 2158, 962, 1968, 3343, 2658, 1266, 720, 14, 2172, 1888, 992, 49, 3479, 1638, 694,3154, 4004, 1971, 3118, 2118, 2125, 1761, 2307, 385, 7, 2031, 1344, 1500, 783, 823, 3948,1994, 3947, 3963, 1635, 829, 620, 489, 1939, 3753, 2108, 2475, 641, 547, 3877, 341, 1922,1955, 487, 1648, 3037, 989, 3073, 1423, 3817, 3281, 232, 161, 3436, 580, 3699, 1392, 2106,397, 2714, 318, 2100, 3659, 103, 539, 3833, 3727, 3655, 1333, 697, 831, 1088, 8, 244,950, 911, 3407, 3826, 2847, 1382, 3092, 1963, 2466, 2018, 1916, 776, 1838, 897, 3863, 436,2505, 434, 2846, 1553, 3512, 2313, 3631, 2221, 3284, 676, 1107, 799, 2101, 2778, 3108, 2460,1341, 591, 2043, 805, 1275, 301, 2700, 3352, 2509, 2636, 193, 558, 3764, 2768, 1777, 452,552, 1948, 757, 3707, 1583, 3757, 1076, 2233, 3247, 1178, 2349, 839, 3192, 3353, 1889, 945,3755, 4023, 1232, 1330, 1277, 2826, 1241, 1640, 1003, 3195, 303, 2445, 2113, 955, 4066, 356,3428, 152, 1873, 1760, 2185, 2866, 1273, 213, 2397, 937, 3345, 891, 1477, 2959, 1610, 3056,3555, 719, 2434, 2609, 1380, 948, 1048, 2622, 968, 2279, 3818, 3692, 2937, 2337, 1645, 3022,3028, 1533, 1452, 1029, 2558, 630, 2806, 2021, 3184, 726, 2536, 537, 2388, 2142, 3325, 198,221, 496, 717, 665, 1779, 1597, 2237, 71, 3041, 3800, 3173, 308, 1863, 250, 3549, 1225,861, 2611, 3100, 958, 3432, 1833, 3718, 135, 2930, 2641, 238, 2697, 3298, 2939, 2453, 2758,1078, 3, 2889, 3456, 2077, 2165, 729, 3962, 3413, 2421, 1810, 3836, 606, 2974, 4094, 2227,2677, 928, 2209, 1079, 1947, 1126, 953, 3264, 428, 1839, 922, 514, 731, 616, 3722, 712,3392, 655, 532, 360, 3896, 3823, 1092, 902, 2932, 2555, 2751, 2764, 195, 2659, 2794, 1595,3601, 2341, 355, 1908, 2883, 3226, 1758, 3144, 3078, 3602, 2262, 770, 1207, 1163, 1792, 1546,774, 1016, 1045, 4053, 2785, 3449, 2542, 357, 3080, 4038, 2171, 643, 3269, 2246, 2753, 349,2141, 2576, 2254, 701, 1391, 3191, 3732, 2995, 3216, 1250, 259, 965, 638, 3403, 785, 200,100, 3348, 137, 3259, 985, 1710, 798, 488, 2109, 2199, 3610, 501, 3326, 3286, 3046, 2607,596, 2099, 1172, 302, 205, 632, 3819, 3969, 3354, 2103, 3135, 447, 1085, 2168, 527, 1771,3290, 1769, 3237, 1457, 2477, 483, 400, 2593, 2220, 1128, 203, 66, 1005, 432, 3571, 2533,2442, 106, 94, 2245, 3958, 2169, 3421, 703, 272, 4051, 3552, 3633, 316, 2777, 2384, 2312,40, 3851, 2525, 3537, 3882, 1053, 111, 3536, 2574, 3397, 718, 813, 2092, 3304, 3267, 2149,4095, 2755, 3880, 1550, 283, 339, 1430, 906, 684, 1004, 2580, 1475, 3211, 3336, 1742, 363,4091, 3611, 2614, 648, 113, 1732, 3196, 3763, 214, 3256, 2119, 3575, 1749, 3087, 482, 3309,3131, 775, 1233, 1255, 178, 101, 1512, 2546, 2273, 2132, 2782, 2938, 50, 2687, 236, 3747,1417, 2327, 3680, 2144, 1828, 1104, 1372, 4084, 3708, 73, 3627, 1741, 1063, 2200, 663, 529,3813, 3649, 2482, 3806, 1427, 3357, 1248, 1632, 2067, 2822, 2851, 3824, 181, 2139, 1872, 2679,664, 3274, 503, 1622, 2933, 2793, 1410, 2838, 2772, 3334, 2157, 1256, 812, 2960, 2096, 2617,2651, 2137, 2387, 2719, 2474, 2516, 3205, 1600, 3062, 2052, 1910, 1428, 3163, 456, 2490, 568,793, 976, 1575, 2426, 2608, 185, 321, 2037, 3474, 1554, 654, 809, 1013, 1661, 1129, 2328,394, 35, 1437, 1548, 2352, 2881, 2981, 866, 24, 3687, 4074, 2647, 1734, 3771, 3943, 445,2843, 230, 1208, 323, 3852, 1368, 935, 926, 2218, 2910, 3615, 1065, 2600, 2616, 1884, 2710,753, 1909, 2977, 2275, 2754, 3125, 2947, 733, 672, 309, 1720, 2094, 1859, 2891, 192, 1650,1885, 702, 3596, 3511, 1289, 3582, 3303, 3573, 2931, 2552, 311, 2935, 1616, 587, 2404, 1358,2922, 626, 3305, 3453, 2154, 3663, 544, 2170, 149, 543, 3678, 876, 344, 1624, 611, 3502,982, 249, 918, 3843, 3164, 1189, 2004, 3382, 2631, 165, 1530, 3562, 1086, 1399, 2274, 2810,1957, 2278, 273, 438, 2707, 215, 2060, 3825, 387, 3047, 1527, 3781, 2268, 2732, 2803, 3894,2061, 878, 2999, 1263, 3115, 3803, 797, 2326, 3991, 1766, 2668, 1058, 2085, 1473, 3973, 3467,653, 1309, 3959, 1608, 2311, 3405, 398, 3970, 3941, 253, 2741, 1935, 1538, 2973, 1326, 4082,3862, 884, 2075, 754, 1433, 1444, 340, 2990, 3426, 2813, 3240, 1556, 2041, 1813, 2911, 2639,364, 3975, 395, 169, 1850, 3151, 2589, 778, 3232, 2886, 55, 1093, 652, 1654, 4, 1832,2054, 328, 2582, 2572, 3668, 2551, 2317, 1686, 3040, 2, 1845, 2229, 3398, 1798, 1214, 446,1367, 1719, 2819, 1593, 1773, 3386, 3417, 980, 2742, 3773, 890, 1082, 3123, 2447, 3696, 2968,1472, 735, 186, 3324, 1763, 3608, 3785, 2709, 1795, 4060, 1783, 2740, 315, 3693, 3831, 1507,2463, 996, 1904, 3174, 4090, 1528, 1369, 1089, 34, 3908, 1987, 3106, 3481, 177, 1007, 594,2133, 2095, 3924, 2112, 3939, 3660, 2314, 1320, 3140, 1001, 1483, 1612, 689, 1041, 3731, 1327,2090, 3594, 2789, 1534, 1841, 1201, 1215, 2654, 1173, 787, 243, 3521, 2166, 2888, 1990, 1431,3112, 3261, 1094, 1747, 2265, 2029, 949, 1036, 625, 1981, 1924, 1740, 3942, 2541, 3811, 650,3362, 2578, 2501, 1143, 1858, 2523, 2114, 1628, 3246, 1954, 3677, 3433, 1009, 679, 3461, 2800,1929, 2818, 1886, 1587, 3000, 931, 2790, 2396, 3197, 2338, 3533, 1633, 1854, 990, 3960, 459,1111, 2645, 730, 4032, 1892, 3923, 1101, 803, 2587, 2111, 2908, 3485, 1489, 2925, 1809, 2623,3809, 1098, 1486, 1913, 3842, 808, 1293, 1816, 1983, 2565, 1897, 2081, 104, 2842, 3634, 3719,1212, 3238, 3779, 2032, 1708, 1249, 3971, 877, 1261, 846, 2184, 551, 3768, 1056, 2174, 281,1652, 3414, 2440, 838, 1218, 804, 3671, 3370, 2359, 3628, 2362, 2962, 58, 557, 1395, 3036,742, 2590, 3039, 2747, 1896, 1181, 2762, 420, 1739, 1496, 348, 2573, 3999, 3341, 1422, 3380,1439, 2358, 2550, 1748, 3463, 1197, 2282, 1820, 2225, 3293, 424, 4044, 3688, 2373, 3527, 3429,2494, 3169, 3470, 3180, 768, 1090, 822, 366, 1835, 313, 1609, 2055, 716, 3200, 1436, 343,3738, 155, 1031, 2730, 1323, 602, 1901, 1691, 929, 1049, 3234, 89, 365, 1961, 2662, 4020,2334, 285, 782, 1945, 3097, 3231, 1073, 48, 2198, 1960, 2269, 1567, 1258, 17, 802, 2145,2462, 4036, 1970, 3222, 1370, 963, 3736, 2504, 2306, 2480, 247, 4030, 3900, 3961, 2413, 2097,1100, 1259, 427, 2224, 3250, 3427, 3553, 3846, 1515, 3109, 2736, 810, 959, 2603, 3210, 561,3822, 3676, 4089, 2712, 3674, 1024, 242, 2752, 3603, 914, 375, 125, 3865, 3702, 2792, 405,2984, 2430, 1590, 3119, 1804, 2586, 2196, 1315, 498, 1091, 3351, 2467, 1398, 2506, 1603, 2880,1054, 2082, 1199, 2943, 38, 1291, 382, 3695, 43, 3976, 2005, 2661, 2613, 756, 1665, 2621,3068, 621, 3008, 1317, 4039, 3367, 314, 2841, 1819, 646, 3311, 3129, 3617, 691, 1298, 2653,2735, 1429, 1187, 4017, 2315, 378, 1061, 2491, 2001, 2468, 3245, 25, 3841, 1112, 1933, 1520,3854, 479, 847, 3019, 2074, 270, 1762, 3338, 1096, 168, 3153, 1481, 1294, 1306, 2057, 1331,4033, 1544, 3443, 3840, 3983, 472, 910, 3009, 108, 1335, 3155, 1114, 2151, 1153, 1738, 1979,524, 649, 3879, 1555, 2986, 1574, 345, 678, 1666, 2543, 1805, 696, 1342, 1365, 2046, 2682,1234, 1706, 1868, 3160, 351, 2632, 554, 1806, 2417, 2540, 1774, 1678, 2530, 3737, 2271, 545,4045, 2331, 158, 1301, 1393, 851, 3185, 3423, 826, 1746, 3149, 401, 2887, 1264, 1350, 2448,784, 1539, 2212, 1379, 530, 1017, 1724, 944, 2350, 2958, 352, 2280, 494, 2553, 3327, 3725,644, 3478, 2026, 627, 1589, 44, 2316, 4014, 2050, 1522, 1791, 1087, 2086, 2002, 1656, 2025,3967, 3279, 566, 217, 3966, 1442, 3363, 2215, 3835, 2839, 3750, 3713, 2971, 3369, 2073, 3146,2592, 1447, 2929, 2531, 981, 1605, 725, 1443, 3139, 3912, 2187, 3664, 698, 3612, 913, 1563,2217, 2635, 4087, 1276, 2568, 2801, 970, 3483, 2206, 458, 2561, 3765, 1471, 3626, 3320, 293,2637, 2626, 3569, 1467, 590, 881, 2340, 605, 3431, 2130, 3847, 3383, 3808, 1726, 3066, 2873,3917, 54, 254, 531, 3821, 1438, 887, 2120, 709, 418, 2956, 2398, 2123, 3142, 942, 867,837, 790, 1414, 41, 3861, 2559, 1174, 3665, 1505, 416, 471, 2320, 584, 3701, 289, 991,1390, 3662, 1067, 1243, 2940, 1025, 2854, 1495, 2795, 3207, 1195, 2599, 755, 517, 2567, 151,4067, 3591, 1722, 1573, 91, 219, 2771, 2502, 3849, 297, 2277, 70, 389, 3675, 3864, 2676,122, 2210, 1347, 3031, 2684, 589, 3525, 3607, 2853, 3837, 1851, 3956, 818, 2562, 391, 502,2310, 2618, 3946, 3691, 1894, 1586, 3361, 2230, 3043, 1986, 2247, 1120, 3934, 26, 3807, 999,1569, 3572, 1588, 681, 342, 705, 857, 261, 2733, 2045, 2192, 3117, 2909, 2009, 737, 497,2749, 3985, 276, 2367, 3340, 3974, 651, 3653, 1023, 1251, 3081, 330, 1019, 2472, 2650, 1993,3791, 1817, 2527, 3641, 1977, 1984, 1318, 1265, 211, 1727, 3508, 1830, 3054, 3093, 3992, 1469,2723, 567, 2904, 1651, 4076, 3866, 3694, 2143, 3717, 1958, 1657, 3798, 3242, 2435, 255, 60,2534, 3859, 3543, 900, 3783, 3652, 3454, 2000, 2295, 1162, 1658, 1836, 1394, 3285, 2869, 3993,1230, 3893, 3715, 2748, 2414, 3332, 856, 4009, 269, 3922, 4042, 3096, 597, 52, 3984, 3868,2051, 3265, 442, 3026, 849, 1580, 3804, 4054, 3229, 1781, 3815, 1319, 711, 2240, 176, 3587,1664, 500, 3640, 960, 2162, 2076, 2951, 2242, 3869, 941, 3616, 3312, 2309, 1880, 3176, 260,3886, 3465, 3296, 409, 2181, 3126, 1450, 1020, 383, 3288, 1202, 2402, 1752, 3907, 1705, 3988,2788, 3929, 423, 1808, 789, 449, 2965, 1646, 1673, 1927, 3600, 2666, 3190, 3244, 1627, 4001,2178, 2370, 2110, 2713, 1287, 1220, 3189, 2024, 2648, 76, 2202, 1242, 904, 1109, 610, 3082,2875, 2493, 1551, 3077, 3130, 4000, 852, 2223, 1572, 2993, 660, 68, 2898, 310, 3918, 1920,2644, 1870, 3364, 1953, 79, 3994, 4008, 2102, 2902, 194, 637, 1629, 786, 157, 3513, 1543,2571, 403, 2131, 262, 3500, 350, 2920, 2857, 1463, 2890, 1127, 1071, 2705, 2121, 105, 1713,592, 2817, 1476, 3459, 791, 1552, 3741, 2366, 2554, 1482, 2921, 977, 1313, 2694, 1267, 3480,4028, 2252, 2342, 4068, 245, 2127, 603, 1270, 1151, 2499, 430, 835, 9, 3317, 3095, 1222,2253, 879, 1788, 3899, 2138, 2515, 886, 1936, 451, 4029, 3728, 288, 3206, 2856, 3950, 72,905, 1614, 2034, 1878, 3964, 2876, 1568, 2332, 1794, 2308, 3344, 3769, 3568, 3531, 23, 337,936, 3402, 3090, 2988, 3754, 2588, 2167, 83, 536, 109, 1451, 3585, 3814, 2156, 404, 3681,880, 504, 51, 2489, 3496, 4010, 525, 209, 3451, 2858, 1281, 3860, 2365, 972, 2547, 1865,2458, 3322, 2878, 465, 1812, 1110, 3501, 1639, 1592, 1641, 359, 1185, 814, 2836, 481, 3990,1668, 1973, 2985, 1844, 3812, 1360, 2498, 2236, 599, 2194, 2208, 138, 2942, 3035, 1923, 2991,2539, 3789, 3365, 3832, 1047, 4026, 3697, 519, 1402, 1166, 3455, 2495, 734, 139, 62, 2675,930, 1516, 3902, 2378, 3905, 2791, 1229, 1050, 1736, 461, 2896, 1030, 19, 3059, 3644, 1660,939, 3515, 4040, 291, 3548, 841, 448, 3430, 1011, 1925, 3491, 3052, 326, 2014, 744, 1413,2989, 795, 140, 3887, 2927, 4012, 3523, 2961, 1346, 658, 3215, 2291, 3042, 468, 2360, 3986,2160, 3014, 1167, 3968, 3574, 2508, 3622, 4081, 3254, 2718, 2497, 513, 1043, 1295, 92, 475,3709, 463, 2513, 2368, 2381, 3444, 3749, 3667, 435, 3532, 582, 571, 2570, 640, 2079, 595,1279, 3257, 1316, 3442, 555, 947, 3406, 2583, 3495, 3767, 1324, 1130, 1978, 1355, 22, 1997,1008, 1744, 1951, 1246, 3179, 2203, 1796, 3927, 3930, 2058, 47, 1458, 376, 2625, 1491, 3758,278, 1055, 1147, 2345, 2809, 4057, 218, 2503, 3743, 3570, 2385, 20, 1623, 509, 1866, 1231,2905, 3506, 3121, 4022, 142, 2941, 3802, 1843, 1381, 271, 1171, 2895, 1240, 1676, 1446, 2232,226, 3759, 2439, 3223, 2088, 3004, 954, 338, 1898, 758, 1069, 1789, 3276, 3517, 3982, 153,13, 3103, 667, 476, 3266, 1378, 2087, 2219, 1445, 1826, 801, 919, 515, 222, 1159, 2915,1353, 1042, 4086, 586, 3951, 3590, 1952, 1226, 1485, 3302, 1535, 59, 3091, 2884, 3193, 1310,2180, 4059, 827, 3576, 3013, 1051, 3700, 1200, 478, 1039, 296, 4071, 2476, 2454, 864, 3446,257, 2726, 167, 1823, 380, 987, 3064, 3038, 3538, 298, 388, 1780, 3704, 2348, 562, 493,2828, 1150, 84, 2469, 3745, 3070, 815, 882, 2330, 258, 3706, 3132, 2507, 2763, 723, 2437,528, 2296, 1529, 396, 2579, 1831, 1849, 3895, 2289, 372, 1683, 3940, 3404, 2433, 1421, 2602,1118, 1619, 4049, 384, 3415, 3156, 1526, 2849, 2335, 2155, 3891, 362, 1032, 229, 1374, 3636,2356, 2739, 1080, 2049, 3330, 2431, 3147, 1790, 3529, 540, 1877, 3319, 3020, 3955, 184, 1716,1607, 997, 1793, 2419, 3049, 952, 220, 966, 2598, 609, 1034, 295, 1146, 2805, 533, 3624,3583, 1907, 3953, 1253, 241, 1698, 2264, 4050, 2512, 437, 1797, 1385, 3120, 2241, 2478, 1312,3597, 3524, 2612, 2919, 2496, 1976, 1352, 3772, 3871, 2560, 332, 1462, 1524, 2357, 2191, 2918,2369, 1188, 3162, 2339, 3143, 2537, 2238, 2129, 2521, 1675, 3850, 994, 2415, 1991, 3561, 3766,3884, 3932, 1768, 3489, 2361, 1704, 3645, 1995, 2532, 3460, 1434, 1653, 3249, 2428, 3838, 3462,1560, 618, 1028, 3952, 3637, 1206, 207, 2955, 3595, 3518, 3618, 2756, 2674, 4037, 306, 843,1728, 1541, 1404, 1731, 1842, 3308, 2251, 576, 2375, 636, 1988, 1425, 2832, 93, 657, 3170,1175, 3159, 1272, 1992, 417, 806, 969, 579, 3165, 2500, 1124, 2064, 16, 2353, 714, 3784,2693, 3389, 2344, 993, 1525, 322, 538, 499, 2266, 265, 3053, 559, 2033, 1581, 175, 3377,3528, 967, 3027, 2874, 1974, 3756, 3331, 12, 1729, 1117, 3379, 3551, 4027, 2983, 150, 2638,874, 1875, 1221, 3239, 772, 1721, 506, 1636, 2207, 2471, 573, 2799, 119, 4034, 1304, 1855,3230, 1083, 377, 3171, 1667, 2389, 2006, 1125, 1254, 1840, 946, 3213, 390, 4011, 2303, 1989,3855, 3074, 2519, 331, 686, 1307, 3280, 191, 1753, 3721, 1926, 1815, 4048, 3289, 1204, 3396,33, 3201, 1946, 634, 2917, 1825, 3925, 2403, 346, 1, 1299, 1765, 3333, 1932, 2122, 2903,3901, 1103, 3278, 1559, 1311, 2948, 235, 3072, 2392, 3107, 1441, 1177, 2374, 1620, 2518, 1247,2354, 130, 3272, 3075, 1164, 1902, 477, 3270, 136, 788, 1470, 578, 4062, 4085, 3498, 2150,2492, 2670, 3647, 575, 3799, 3567, 3217, 370, 413, 485, 1084, 1903, 2665, 3214, 2692, 1420,455, 3592, 233, 1006, 1487, 3554, 961, 367, 141, 3945, 154, 2620, 4083, 1284, 3712, 3408,915, 1492, 1576, 816, 282, 1179, 69, 2746, 3486, 2429, 2012, 320, 1775, 3471, 743, 2059,1829, 2124, 2859, 3630, 1345, 662, 473, 2698, 2128, 2379, 1068, 1561, 3661, 2249, 80, 1144,875, 1611, 1571, 3726, 777, 179, 2796, 2134, 2318, 3464, 2395, 505, 1905, 1401, 1424, 2438,1931, 1338, 748, 2601, 2604, 938, 2205, 2814, 2126, 927, 3347, 1506, 3141, 3944, 2347, 541,883, 2400, 3339, 984, 381, 3434, 2511, 3145, 440, 1772, 1269, 466, 2893, 2923, 2643, 2649,2761, 3987, 2987, 3593, 3122, 393, 115, 656, 2226, 2028, 682, 132, 3133, 3025, 2686, 661,124, 2783, 189, 3550, 3419, 1584, 2671, 3559, 1911, 3291, 1730, 3578, 3441, 833, 2450, 1186,110, 1449, 373, 2255, 1785, 146, 1617, 2901, 3044, 1510, 3774, 37, 2566, 2283, 2596, 1930,1155, 3492, 1756, 454, 2135, 2664, 95, 2776, 325, 3629, 2833, 2774, 1596, 2153, 2619, 3870,2336, 3790, 3374, 741, 1643, 1285, 2690, 2950, 462, 581, 623, 4047, 2657, 3589, 1890, 724,3468, 2807, 1288, 526, 1192, 1182, 133, 695, 126, 3830, 1278, 2183, 2779, 585, 1689, 3762,1594, 3260, 821, 3558, 2039, 3746, 1040, 2784, 1479, 3788, 1513, 3916, 1033, 3933, 588, 3816,75, 53, 2591, 2179, 3368, 3733, 1918, 2737, 624, 65, 1874, 4005, 2514, 78, 3292, 1435,1542, 1409, 3094, 2211, 3682, 2773, 3409, 2544, 2900, 2864, 2976, 2197, 3873, 57, 1464, 2538,2769, 761, 3938, 2728, 2190, 986, 148, 1514, 3972, 3067, 1466, 2470, 1102, 63, 1867, 1161,1502, 4015, 2301, 673, 1759, 1982, 1940, 3965, 889, 2721, 1912, 3669, 2487, 1577, 973, 2963,3998, 3520, 2195, 441, 3844, 3086, 3187, 2830, 747, 2464, 3614, 1687, 1064, 2717, 88, 1203,2535, 3599, 2473, 333, 964, 1591, 2267, 457, 422, 2745, 2672, 4018, 327, 1876, 3400, 2484,3410, 1213, 2204, 1499, 762, 3556, 2027, 3294, 898, 1305, 2159, 46, 2228, 2017, 1697, 1223,107, 873, 1745, 3452, 3181, 2485, 671, 1582, 1180, 619, 2270, 3503, 1357, 353, 2798, 1782,3300, 300, 2899, 4055, 645, 2701, 3182, 1339, 1453, 3734, 1871, 951, 3509, 917, 3926, 763,3904, 284, 3030, 2802, 2865, 263, 613, 116, 312, 3469, 668, 3060, 1778, 2372, 2488, 1613,865, 2663, 480, 2305, 419, 429, 1647, 834, 287, 760, 3158, 3422, 460, 2412, 3605, 2177,210, 3540, 2377, 1677, 1821, 469, 600, 2862, 3679, 1010, 983, 199, 2072, 2288, 3177, 77,870, 1057, 2023, 3782, 511, 2808, 369, 3724, 3310, 1113, 3744, 956, 3287, 2907, 1959, 792,1824, 2164, 3625, 1027, 2020, 3638, 3050, 3337, 3262, 3085, 3778, 1133, 453, 1343, 3391, 1887,450, 811, 3666, 3522, 727, 42, 1962, 2605, 1415, 1602, 1314, 1183, 490, 4073, 402, 1767,2673, 3580, 2287, 304, 1536, 3105, 1975, 1366, 659, 2376, 840, 163, 2432, 3161, 647, 3307,127, 635, 1194, 2427, 36, 2213, 2259, 3315, 266, 2946, 608, 2239, 2300, 739, 3342, 2767,1290, 2835, 82, 3167, 1702, 3623, 495, 3654, 2628, 464, 1621, 196, 1598, 1400, 1106, 3858,2914, 30, 3751, 1770, 3221, 3488, 3642, 1156, 1547, 3435, 4025, 2683, 1881, 807, 2680, 1503,1235, 3416, 1701, 2696, 1879, 368, 1075, 3024, 3113, 1245, 160, 3770, 2117, 2007, 593, 516,239, 2250, 794, 1132, 2882, 3698, 901, 2107, 2722, 1002, 3418, 3856, 1703, 1562, 699, 766,87, 3007, 3323, 2053, 2078, 234, 1662, 1387, 1303, 379, 1361, 1695, 224, 871, 542, 1900,3979, 1384, 2391, 1484, 2704, 3458, 414, 354, 3805, 1497, 1454, 3684, 3101, 1219, 1137, 2451,1474, 410, 4069, 2780, 2980, 3775, 3487, 2486, 690, 2152, 3448, 1297, 3658, 3530, 3639, 21,3711, 2811, 2452, 3752, 2827, 2285, 3735, 2446, 4035, 3670, 4070, 3915, 3931, 3301, 923, 18,61, 3978, 3761, 1642, 1692, 1131, 3005, 1733, 3015, 1190, 3493, 1751, 2019, 2418, 1862, 3089,2394, 118, 1787, 1176, 324, 3648, 1334, 2845, 2924, 683, 2068, 170, 535, 1377, 2201, 1095,2459, 2615, 3355, 3212, 1478, 854, 2272, 780, 1950, 1158, 2407, 3202, 1418, 2727, 173, 1717};;
logic [11:0]index_part_1 ;
logic [11:0]index_part_2 ;
//logic [11:0]index_part_3 ;
//int seed_val = 40543;

/* Combinational logic to model hash function */
always_comb
begin
if (reset) begin
	index_part_1 = 0;
	index_part_2 = 0;
	//index_part_3 = 0;
	fromHash = 0;
end 
else begin
if (toHash[23:16] > 0 && toHash[15:8] == 0 )begin
index_part_1 = uniqnums[toHash[23:16]];
	index_part_2 =  uniqnums[toHash[15:8] ^ index_part_1];
	fromHash =  uniqnums[0 ^ index_part_2];
end
else begin
	index_part_1 = uniqnums[toHash[7:0] ];
	index_part_2 =  uniqnums[toHash[15:8] ^ index_part_1 ];
	fromHash =  uniqnums[toHash[23:16] ^ index_part_2 ];
end	


end
end

endmodule