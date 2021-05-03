* **************************************************************************** *
* *** Test Statistics of Original Studies ***                                  *
* **************************************************************************** *
quietly {
	* s`i': "ttype stat df1 df2 n n_ind"
	* type: 1 = z, 2 = t, 3 = F, 4 = chi2
	global  s1_os  " 4.080   3  1   52    54    54" // Ackerman et al. (2010)
	global  s2_os  "13.070   2  .   14    15    15" // Aviezer et al. (2012)
	global  s3_os  " 5.620   4  .    1    72    72" // Balafoutas & Sutter (2012)
	global  s4_os  "16.300   4  .    1    51   366" // Derex et al. (2013)
	global  s5_os  " 3.410   2  .   14    15    15" // Duncan et al. (2012)
	global  s6_os  " 2.240   2  .   55    57    57" // Gervais & Norenzayan (2012)
	global  s7_os  " 3.000   1  .    .   178   178" // Gneezy et al. (2014)
	global  s8_os  " 8.696   2  .   38    40   200" // Hauser et al. (2014)
	global  s9_os  " 5.761   1  .    .    63   105" // Janssen et al. (2010)
	global s10_os  "21.630   3  1   38    40    40" // Karpicke & Blunt (2011)
	global s11_os  " 6.400   3  1   82    86    86" // Kidd & Castano (2013)
	global s12_os  " 2.420   2  .   23    24    24" // Kovacs et al. (2010)
	global s13_os  " 6.740   3  1   38    40    40" // Lee & Schwartz (2010)
	global s14_os  " 2.784   2  .   30    32    32" // Morewedge et al. (2010)
	global s15_os  " 2.881   2  .  198   200   366" // Nishi et al. (2015)
	global s16_os  " 2.370   2  .   34    36    36" // Pyc & Rawson (2010)
	global s17_os  "30.530   3  1   18    20    20" // Ramirez & Beilock (2011)
	global s18_os  " 2.617   1  .    .   343   343" // Rand et al. (2012)
	global s19_os  " 4.160   3  1   54    56    56" // Shah et al. (2012)
	global s20_os  " 3.260   2  .   68    69    69" // Sparrow et al. (2011)
	global s21_os  " 4.830   2  .   28    30    30" // Wilson et al. (2014)
}


* **************************************************************************** *
* *** Test Statistics of Replication Study (Stage 1) ***                       *
* **************************************************************************** *
quietly {
	* s`i': "type stat df1 df2 n n_ind"
	* type: 1 = z, 2 = t, 3 = F, 4 = chi2
	global  s1_rs1 " 2.2773  2  .  257   259   259" // Ackerman et al. (2010)
	global  s2_rs1 " 5.3420  2  .   13    14    14" // Aviezer et al. (2012)
	global  s3_rs1 " 5.2199  4  .    1   243   243" // Balafoutas & Sutter (2012)
	global  s4_rs1 " 8.8337  4  .    1    65   482" // Derex et al. (2013)
	global  s5_rs1 " 1.0997  2  .   35    36    36" // Duncan et al. (2012)
	global  s6_rs1 "-0.8153  2  .  222   224   224" // Gervais & Norenzayan (2012)
	global  s7_rs1 " 3.7064  1  .    .   407   407" // Gneezy et al. (2014)
	global  s8_rs1 " 6.7082  2  .   20    22   110" // Hauser et al. (2014)
	global  s9_rs1 " 2.2383  1  .    .    42    70" // Janssen et al. (2010)
	global s10_rs1 " 2.8825  2  .   48    49    49" // Karpicke & Blunt (2011)
	global s11_rs1 "-1.2078  3  1  281   285   285" // Kidd & Castano (2013)
	global s12_rs1 " 7.0152  2  .   94    95    95" // Kovacs et al. (2010)
	global s13_rs1 "-0.5621  3  1  121   123   123" // Lee & Schwartz (2010)
	global s14_rs1 " 3.5384  2  .   87    89    89" // Morewedge et al. (2010)
	global s15_rs1 " 2.5543  2  .  478   480   792" // Nishi et al. (2015)
	global s16_rs1 " 1.7119  2  .  130   132   132" // Pyc & Rawson (2010)
	global s17_rs1 "-0.1352  3  1   24    26    52" // Ramirez & Beilock (2011)
	global s18_rs1 " 0.9039  1  .    .  1014  1014" // Rand et al. (2012)
	global s19_rs1 "-2.0863  3  1  276   278   278" // Shah et al. (2012)
	global s20_rs1 " 1.1214  2  .  103   104   104" // Sparrow et al. (2011)
	global s21_rs1 " 4.4867  2  .   37    39    39" // Wilson et al. (2014)
}

* **************************************************************************** *
* *** Test Statistics of Replication Study (Stage 2) ***                       *
* **************************************************************************** *
quietly {
	* s`i': "type stat df1 df2 n n_ind"
	* type: 1 = z, 2 = t, 3 = F, 4 = chi2
	global  s1_rs2 " 1.5351  2  .  597   599   599" // Ackerman et al. (2010)
	global  s2_rs2 "    .    .  .    .     .     ." // Aviezer et al. (2012)
	global  s3_rs2 "    .    .  .    .     .     ." // Balafoutas & Sutter (2012)
	global  s4_rs2 "    .    .  .    .     .     ." // Derex et al. (2013)
	global  s5_rs2 " 4.6276  2  .   91    92    92" // Duncan et al. (2012)
	global  s6_rs2 "-0.8153  2  .  529   531   531" // Gervais & Norenzayan (2012)
	global  s7_rs2 "    .    .  .    .     .     ." // Gneezy et al. (2014)
	global  s8_rs2 "    .    .  .    .     .     ." // Hauser et al. (2014)
	global  s9_rs2 "    .    .  .    .     .     ." // Janssen et al. (2010)
	global s10_rs2 "    .    .  .    .     .     ." // Karpicke & Blunt (2011)
	global s11_rs2 "-0.5270  3  1  710   714   714" // Kidd & Castano (2013)
	global s12_rs2 "    .    .  .    .     .     ." // Kovacs et al. (2010)
	global s13_rs2 "-0.6081  3  1  284   286   286" // Lee & Schwartz (2010)
	global s14_rs2 "    .    .  .    .     .     ." // Morewedge et al. (2010)
	global s15_rs2 "    .    .  .    .     .     ." // Nishi et al. (2015)
	global s16_rs2 " 2.6404  2  .  304   306   306" // Pyc & Rawson (2010)
	global s17_rs2 "-0.7352  3  1   77    79   131" // Ramirez & Beilock (2011)
	global s18_rs2 " 1.1912  1  .    .  2136  2136" // Rand et al. (2012)
	global s19_rs2 "-0.1389  3  1  617   619   619" // Shah et al. (2012)
	global s20_rs2 " 0.7579  2  .  233   234   234" // Sparrow et al. (2011)
	global s21_rs2 "    .    .  .    .     .     ." // Wilson et al. (2014)
}
