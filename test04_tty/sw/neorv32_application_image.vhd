-- The NEORV32 RISC-V Processor, https://github.com/stnolting/neorv32
-- Auto-generated memory init file (for APPLICATION) from source file <sw/main.bin>
-- Size: 1140 bytes

library ieee;
use ieee.std_logic_1164.all;

library neorv32;
use neorv32.neorv32_package.all;

package neorv32_application_image is

  constant application_init_image : mem32_t := (
    00000000 => x"00000037",
    00000001 => x"80002117",
    00000002 => x"ff810113",
    00000003 => x"80000197",
    00000004 => x"7f418193",
    00000005 => x"00000517",
    00000006 => x"12450513",
    00000007 => x"30551073",
    00000008 => x"34151073",
    00000009 => x"30001073",
    00000010 => x"30401073",
    00000011 => x"30601073",
    00000012 => x"ffa00593",
    00000013 => x"32059073",
    00000014 => x"b0001073",
    00000015 => x"b8001073",
    00000016 => x"b0201073",
    00000017 => x"b8201073",
    00000018 => x"00000093",
    00000019 => x"00000213",
    00000020 => x"00000293",
    00000021 => x"00000313",
    00000022 => x"00000393",
    00000023 => x"00000713",
    00000024 => x"00000793",
    00000025 => x"00000813",
    00000026 => x"00000893",
    00000027 => x"00000913",
    00000028 => x"00000993",
    00000029 => x"00000a13",
    00000030 => x"00000a93",
    00000031 => x"00000b13",
    00000032 => x"00000b93",
    00000033 => x"00000c13",
    00000034 => x"00000c93",
    00000035 => x"00000d13",
    00000036 => x"00000d93",
    00000037 => x"00000e13",
    00000038 => x"00000e93",
    00000039 => x"00000f13",
    00000040 => x"00000f93",
    00000041 => x"00000417",
    00000042 => x"d5c40413",
    00000043 => x"00000497",
    00000044 => x"f5448493",
    00000045 => x"00042023",
    00000046 => x"00440413",
    00000047 => x"fe941ce3",
    00000048 => x"80000597",
    00000049 => x"f4058593",
    00000050 => x"80000617",
    00000051 => x"f3860613",
    00000052 => x"00c5d863",
    00000053 => x"00058023",
    00000054 => x"00158593",
    00000055 => x"ff5ff06f",
    00000056 => x"00000597",
    00000057 => x"39458593",
    00000058 => x"80000617",
    00000059 => x"f1860613",
    00000060 => x"80000697",
    00000061 => x"f1068693",
    00000062 => x"00d65c63",
    00000063 => x"00058703",
    00000064 => x"00e60023",
    00000065 => x"00158593",
    00000066 => x"00160613",
    00000067 => x"fedff06f",
    00000068 => x"00000513",
    00000069 => x"00000593",
    00000070 => x"06c000ef",
    00000071 => x"34051073",
    00000072 => x"00000093",
    00000073 => x"00008463",
    00000074 => x"000080e7",
    00000075 => x"30047073",
    00000076 => x"10500073",
    00000077 => x"ffdff06f",
    00000078 => x"ff810113",
    00000079 => x"00812023",
    00000080 => x"00912223",
    00000081 => x"34202473",
    00000082 => x"02044663",
    00000083 => x"34102473",
    00000084 => x"00041483",
    00000085 => x"0034f493",
    00000086 => x"00240413",
    00000087 => x"34141073",
    00000088 => x"00300413",
    00000089 => x"00941863",
    00000090 => x"34102473",
    00000091 => x"00240413",
    00000092 => x"34141073",
    00000093 => x"00012403",
    00000094 => x"00412483",
    00000095 => x"00810113",
    00000096 => x"30200073",
    00000097 => x"ff010113",
    00000098 => x"00112623",
    00000099 => x"004000ef",
    00000100 => x"fe010113",
    00000101 => x"00000513",
    00000102 => x"00000593",
    00000103 => x"00812c23",
    00000104 => x"00912a23",
    00000105 => x"01212823",
    00000106 => x"01312623",
    00000107 => x"00112e23",
    00000108 => x"00100493",
    00000109 => x"060000ef",
    00000110 => x"00100413",
    00000111 => x"00000913",
    00000112 => x"01000993",
    00000113 => x"00000593",
    00000114 => x"0ff97513",
    00000115 => x"048000ef",
    00000116 => x"00040513",
    00000117 => x"07c000ef",
    00000118 => x"00000513",
    00000119 => x"00000593",
    00000120 => x"034000ef",
    00000121 => x"40898533",
    00000122 => x"068000ef",
    00000123 => x"01340e63",
    00000124 => x"00041a63",
    00000125 => x"00190913",
    00000126 => x"00140413",
    00000127 => x"00100493",
    00000128 => x"fc5ff06f",
    00000129 => x"fe049ae3",
    00000130 => x"fff40413",
    00000131 => x"00000493",
    00000132 => x"fb5ff06f",
    00000133 => x"fc000793",
    00000134 => x"00a7a423",
    00000135 => x"00b7a623",
    00000136 => x"00008067",
    00000137 => x"ff010113",
    00000138 => x"c81026f3",
    00000139 => x"c0102773",
    00000140 => x"c81027f3",
    00000141 => x"fed79ae3",
    00000142 => x"00e12023",
    00000143 => x"00f12223",
    00000144 => x"00012503",
    00000145 => x"00412583",
    00000146 => x"01010113",
    00000147 => x"00008067",
    00000148 => x"fd010113",
    00000149 => x"00a12623",
    00000150 => x"fe002503",
    00000151 => x"3e800593",
    00000152 => x"02112623",
    00000153 => x"02812423",
    00000154 => x"02912223",
    00000155 => x"03212023",
    00000156 => x"01312e23",
    00000157 => x"154000ef",
    00000158 => x"00c12603",
    00000159 => x"00000693",
    00000160 => x"00000593",
    00000161 => x"0ac000ef",
    00000162 => x"00050413",
    00000163 => x"00058993",
    00000164 => x"f95ff0ef",
    00000165 => x"00058913",
    00000166 => x"00050493",
    00000167 => x"f89ff0ef",
    00000168 => x"00b96663",
    00000169 => x"05259263",
    00000170 => x"04a4f063",
    00000171 => x"008484b3",
    00000172 => x"0084b433",
    00000173 => x"01390933",
    00000174 => x"01240433",
    00000175 => x"f69ff0ef",
    00000176 => x"fe85eee3",
    00000177 => x"00b41463",
    00000178 => x"fe956ae3",
    00000179 => x"02c12083",
    00000180 => x"02812403",
    00000181 => x"02412483",
    00000182 => x"02012903",
    00000183 => x"01c12983",
    00000184 => x"03010113",
    00000185 => x"00008067",
    00000186 => x"01c99913",
    00000187 => x"00445413",
    00000188 => x"00896433",
    00000189 => x"00040a63",
    00000190 => x"00040863",
    00000191 => x"fff40413",
    00000192 => x"00000013",
    00000193 => x"ff1ff06f",
    00000194 => x"fc5ff06f",
    00000195 => x"00050613",
    00000196 => x"00000513",
    00000197 => x"0015f693",
    00000198 => x"00068463",
    00000199 => x"00c50533",
    00000200 => x"0015d593",
    00000201 => x"00161613",
    00000202 => x"fe0596e3",
    00000203 => x"00008067",
    00000204 => x"00050313",
    00000205 => x"ff010113",
    00000206 => x"00060513",
    00000207 => x"00068893",
    00000208 => x"00112623",
    00000209 => x"00030613",
    00000210 => x"00050693",
    00000211 => x"00000713",
    00000212 => x"00000793",
    00000213 => x"00000813",
    00000214 => x"0016fe13",
    00000215 => x"00171e93",
    00000216 => x"000e0c63",
    00000217 => x"01060e33",
    00000218 => x"010e3833",
    00000219 => x"00e787b3",
    00000220 => x"00f807b3",
    00000221 => x"000e0813",
    00000222 => x"01f65713",
    00000223 => x"0016d693",
    00000224 => x"00eee733",
    00000225 => x"00161613",
    00000226 => x"fc0698e3",
    00000227 => x"00058663",
    00000228 => x"f7dff0ef",
    00000229 => x"00a787b3",
    00000230 => x"00088a63",
    00000231 => x"00030513",
    00000232 => x"00088593",
    00000233 => x"f69ff0ef",
    00000234 => x"00f507b3",
    00000235 => x"00c12083",
    00000236 => x"00080513",
    00000237 => x"00078593",
    00000238 => x"01010113",
    00000239 => x"00008067",
    00000240 => x"06054063",
    00000241 => x"0605c663",
    00000242 => x"00058613",
    00000243 => x"00050593",
    00000244 => x"fff00513",
    00000245 => x"02060c63",
    00000246 => x"00100693",
    00000247 => x"00b67a63",
    00000248 => x"00c05863",
    00000249 => x"00161613",
    00000250 => x"00169693",
    00000251 => x"feb66ae3",
    00000252 => x"00000513",
    00000253 => x"00c5e663",
    00000254 => x"40c585b3",
    00000255 => x"00d56533",
    00000256 => x"0016d693",
    00000257 => x"00165613",
    00000258 => x"fe0696e3",
    00000259 => x"00008067",
    00000260 => x"00008293",
    00000261 => x"fb5ff0ef",
    00000262 => x"00058513",
    00000263 => x"00028067",
    00000264 => x"40a00533",
    00000265 => x"00b04863",
    00000266 => x"40b005b3",
    00000267 => x"f9dff06f",
    00000268 => x"40b005b3",
    00000269 => x"00008293",
    00000270 => x"f91ff0ef",
    00000271 => x"40a00533",
    00000272 => x"00028067",
    00000273 => x"00008293",
    00000274 => x"0005ca63",
    00000275 => x"00054c63",
    00000276 => x"f79ff0ef",
    00000277 => x"00058513",
    00000278 => x"00028067",
    00000279 => x"40b005b3",
    00000280 => x"fe0558e3",
    00000281 => x"40a00533",
    00000282 => x"f61ff0ef",
    00000283 => x"40b00533",
    00000284 => x"00028067"
  );

end neorv32_application_image;