#!/usr/bin/perl
# HTS .lab file generation script

# Sankar Mukherjee
# CET, IITKGP
# sankar1535@gmail.com
# for more updates ==> https://github.com/sankar-mukherjee/Bengali-HTS
#=================================================================================================


#===================.lab format ===========================
#p1 ˆp2 - p3 +p4 =p5 @p6_p7
#/A:a1_a2_a3 /B:b1 -b2 -b3 @b4 -b5 &b6 -b7 #b8 -b9 $b10 -b11 !b12 -b13 ;b14 -b15 |b16 /C:c1 +c2 +c3
#/D:d1_d2 /E:e1 +e2 @e3 +e4 &e5 +e6 #e7 +e8 /F: f1_f2
#/G:g1_g2 /H:h1 =h2 @h3 =h4 |h5 /I:i1_i2
#/J: j1 + j2 - j3
#=======================================================

$tag='tag';$lab='lab';
$sur=$ARGV[0];
$dest=$ARGV[1];

	open(FILE, $sur) || die("Could not open file!");
	@lines = <FILE>;
	close (FILE);

	@time=();@phoneme=();@syllable=();@word=();@POS=();@phrase=();@stress=();
	@VOWEL=('a','aA','i','u','e','o','eE','a~','aA~','i~','u~','e~','o~','eE~');
	@POS_LIST=('nc','np','pr','aj','av','vm','vx','vn','vp','vi','vc','cn','pp','ij');
	@QUE=('0','0','0','0');
	@SYL_QUE=('0','0','0','0','0');
	$s="^";$w="/";$ph=",";$SIL='si';$stress_inicator='s';
	$indicator='0';$indicator2='#';
	$ZERO='0';$ONE=1;$TWO=2;$THREE=3;$FOUR=4;$FIVE=5;
	$FLAG='1';
	$increase = 1;

		foreach $lines(@lines){
			@a = split (/\s+/,$lines);
			push(@time,$a[0]);
			push(@phoneme,$a[0]);
			push(@syllable,$a[1]);
			push(@word,$a[2]);
			push(@POS,$a[3]);
			push(@phrase,$a[4]);
			}

	#shift(@time);shift(@phoneme);shift(@syllable);shift(@word);shift(@POS);shift(@phrase);
	$last=scalar(@lines);					#total no of lines in the original file
#================== time =========================
$scalar=10000000;
unshift(@time,$ZERO);

foreach $t (@time) { $t = $t * $scalar; }

=comment
@SYL_index = grep { $phoneme[$_] eq $SIL } 0..$#phoneme;
for($ss=1;$ss<@SYL_index-1;$ss++){
splice (@syllable,$SYL_index[$ss],1);
splice (@word,$SYL_index[$ss],1);
splice (@phrase,$SYL_index[$ss],1);
}
=cut
#===============================syl, word, phrase index calculation=============================================
@j11 = grep { $syllable[$_] eq $s } 0..$#syllable;
@j22 = grep { $word[$_] eq $w } 0..$#word;
@j33 = grep { $phrase[$_] eq $ph } 0..$#phrase;

@POS11 = reverse(@POS);
@POS_access =();
$current_pos = '#';
foreach $pos_element (@POS11){
	if($pos_element ne $indicator2)
		{
		$current_pos = $pos_element;	
		push(@POS_access,$current_pos);			
		}
}
@POS_access = reverse(@POS_access);
@extra_pos_add = ('x','x','x');
unshift(@POS_access,$ZERO);
push(@POS_access,@extra_pos_add);
#@j44 = grep { $phrase[$_] eq $ph } 0..$#POS;

push(@j33,$j22[-1]);
#===========================initializing with adding 0 at first====================
@A12=@j22;		#dummy word
@P67=@j11;		#dummy syllable
unshift(@P67,$ZERO);
@B67=@j33;		#dummy phrase
#push(@B67,$j22[-1]);	-------------
unshift(@B67,$ZERO);
#====================================Stress===============================================
=comment
for($iii=0;$iii<@A12;$iii++){
	if(($A12[$iii+1]-$A12[$iii]) eq '1'){$A12[$iii]=$A12[$iii]-1;}
}
@stress=@A12;
for($str=0;$str<@stress;$str++){

}
foreach $str (@stress) { $str = $str + $ONE; }
print "@stress\t";
=cut
@stress=(0,0,1);		#stress que [Present Current Next]
$current_syl='24125236';	#garbaze value
#====================================no of Stress syl before and after current syl=============
@B89=@j11;		#dummy syllable where stressed syllables are stored
@B89_SYL=@j11;		#dummy syllable 
@B89_w=@j22;		#dummy word
@B89_p=@j33;		#dummy phrase
#push(@B89_p,$j22[-1]); -----------------
@B89_SYL_F_index = grep { $j11[$_] eq $B89_p[0] } 0..$#j11;		#first phrase

for($iii=0;$iii<@B89_SYL-1;$iii++){	
	if($B89_SYL[$iii] eq $B89_w[0]){$B89[$iii+1]=$B89[$iii+1].'s';shift(@B89_w);}
	shift(@B89_syl);
}
$B89[0]=$B89[0].'s';							#adding stress marker to the first syllable in the uttarence

unshift(@B89,$ZERO);
unshift(@B89_SYL,$ZERO);

@B89_SYL_span=@B89_SYL[0 .. $B89_SYL_F_index[0]+1];			#first phrase syllable span
@B89_stress_SYL_span=@B89[0 .. $B89_SYL_F_index[0]+1];			#first phrase syllable span with stress marker
#print "@B89\t";print "\n";print "@B89_SYL_span\t";print "\n";print "@B89_stress_SYL_span\t";print "\n";
#========================no of syllables in the P C N words=========================================
$current_word='1234124';		#garbaze value
@DEF2_w=@j22;
@DEF2_SYL=@j11;
unshift(@DEF2_SYL,$ZERO);
@no_SYL_w_span=();

	foreach $DEF2_w (@DEF2_w){
		@no_SYL_w = grep{$DEF2_SYL[$_] eq $DEF2_w} 0..$#DEF2_SYL;
		push(@no_SYL_w_span,$no_SYL_w[0]);
		}

unshift(@no_SYL_w_span,$ZERO);

for($SSSS=0;$SSSS<@no_SYL_w_span;$SSSS++){$no_SYL_w_span[$SSSS]=$no_SYL_w_span[$SSSS+1]-$no_SYL_w_span[$SSSS];}		#syllable size in word
unshift(@no_SYL_w_span,$ZERO);

#========================no of syllables in the P C N phrase=========================================
@GHI_P=@j33;			#dummy phrase 
#push(@GHI_P,$j22[-1]); ----------------
@GHI2_w=@j22;			#dummy word 
@GHI1_SYL=@j11;			#dummy syllable 

unshift(@GHI1_SYL,$ZERO);unshift(@GHI2_w,$ZERO);

@no_SYL_P_span=();@no_w_P_span=();

	foreach $GHI_P (@GHI_P){
		@no_SYL_P = grep{$GHI1_SYL[$_] eq $GHI_P} 0..$#GHI1_SYL;
		@no_w_P = grep{$GHI2_w[$_] eq $GHI_P} 0..$#GHI2_w;
		push(@no_SYL_P_span,$no_SYL_P[0]);
		push(@no_w_P_span,$no_w_P[0]);
		}

unshift(@no_SYL_P_span,$ZERO);
unshift(@no_w_P_span,$ZERO);

for($pppp=0;$pppp<@no_SYL_P_span;$pppp++){$no_SYL_P_span[$pppp]=$no_SYL_P_span[$pppp+1]-$no_SYL_P_span[$pppp];}		#syllable size in phrase
for($wwww=0;$wwww<@no_w_P_span;$wwww++){$no_w_P_span[$wwww]=$no_w_P_span[$wwww+1]-$no_w_P_span[$wwww];}			#word size in phrase

unshift(@no_SYL_P_span,$ZERO);
unshift(@no_w_P_span,$ZERO);

#==========================position of syl in current word==========================================
@SYL_B45=@j11;		#dummy syllable
@W_B45=@j22;		#dummy word

#=============================================total no of required variable=========================
$p1 = $p2 = $p3 = $p4 = $p5 = 'x';
$p6 = $p7 = 'x';
$a1 = $a2 = '0';
$a3='0';
$b1 = $b2='0';
$b3='0';
$b4=$b5='0';
$b6=$b7='0';
$b8=$b9='0';
$b10=$b11='0';
$b12=$b13='0';
$b14=$b15='0';
$b16='x';
$c1 = $c2='0';
$c3='0';
$d1=$e1=$f1='x';		$e3=$e4='0';	$e5=$e6=$e7=$e8='0';
$d2=$e2=$f2='0';
$g1=$h1=$i1='0';
$g2=$h2=$i2='0';
$h3=$h4='0';		#including the si immidiate after a phrase to that phrase 
$h5= '0';
$j1 = scalar(@j11);
$j2 = scalar(@j22);
$j3 = scalar(@j33);
#============si index minus from syllable for calculating syl size==================================
@SYL_size=@P67;		#dummy syllable with add 0 at front

@SYL_index = grep { $phoneme[$_] eq $SIL } 0..$#phoneme;
for($s=1;$s<@SYL_index-1;$s++){
	for($ss=0;$ss<@SYL_size;$ss++){
		if($SYL_size[$ss]<$SYL_index[$s] && $SYL_index[$s]<$SYL_size[$ss+1])	
			{
			for($minus=$ss+1;$minus<@SYL_size;$minus++)
				{$SYL_size[$minus]=$SYL_size[$minus] - $ONE;}
			}			
	}
}

for($SSS=0;$SSS<@SYL_size;$SSS++){$SYL_size[$SSS]=$SYL_size[$SSS+1]-$SYL_size[$SSS];}		#syllable size
unshift(@SYL_size,$ZERO);

#=======================position of the phrase in utterence========================================

@H34_P=@j33;		#dummy phrase
#push(@H34_P,$j22[-1]); -----------------
$h3='1';$h4=$j3;
#print "@H34_P\t";

#=================position of the word in current phrase==========================================
@E34_w_list=@j22;	#dummy word
@E34_w=@j22;		#dummy word
@E34_P=@j33;		#dummy phrase
unshift(@E34_P,$ZERO);
#push(@E34_P,@j22[-1]); -------------------
$w_increase=1;
#@LAST_w_P_index = grep { $E34_w[$_] eq $E34_P[0] } 0..$#E34_w;
#@word_P_span = @E34_w[0 .. $LAST_w_P_index[0]];
#print "@word_P_span\t";
#print "@E34_P\n";
#==============================================MAIN======================================================

open (LAB,">$dest");
for($i=0;$i<@lines;$i++){

$p1=$phoneme[$i-2];	$p2=$phoneme[$i-1];	$p3=$phoneme[$i];		$p4=$phoneme[$i+1];	$p5=$phoneme[$i+2];
if($i==0){$p1='x';$p2='x';}
elsif($i==1){$p1='x';}
elsif($i==$last-3){$p5='x';}
elsif($i==$last-2){$p4='x';$p5='x';}

phon($i);


print LAB "$p1^$p2-$p3+$p4=$p5@"."$p6"."_$p7"."/A:$a1"."_$a2"."_$a3"."/B:$b1-$b2-$b3@"."$b4-$b5"."&$b6-$b7"."#$b8-$b9".'$'."$b10-$b11!"."$b12-$b13".";$b14-$b15|$b16"."/C:$c1+$c2+$c3"."/D:$d1"."_$d2"."/E:$e1+$e2@"."$e3+$e4&"."$e5+$e6#$e7+$e8"."/F:$f1"."_$f2"."/G:$g1"."_$g2"."/H:$h1=$h2^$h3=$h4|$h5"."/I:$i1"."_$i2"."/J:$j1+$j2-$j3"."\n";

#print "$p3 $b8-$b9\n";

#print "$d1 $e1 $f1\n"
#print "@POS_access1\n"
}
close (LAB);

sub phon{

if($phoneme[$_[0]] eq $SIL || $phoneme[$_[0]] eq 'brth'){
			$p6='x';$p7='x';
			$a1=$stress[1];

			if($_[0] eq $ZERO){$c3=$SYL_size[1];}				#for si  first index
			if($_[0] ne $ZERO && $_[0] ne $last-2){$a3=$SYL_size[0];}	#for si apart from first and last index			
			if($_[0] eq $last-2){$a3=$SYL_size[0];}				#for si last index

			$b1='x';$b2='x';$b3='x';$b4='x';$b5='x';$b6='x';$b7='x';$b8='x';$b9='x';$b10='x';$b11='x';$b12='x';$b13='x';
			$b14='x';$b15='x';$b16='x';
			$e1='x';$e2='x';$e3='x';$e4='x';$e5='x';$e6='x';$e7='x';$e8='x';
			$h1='x';$h2='x';
			$h5='0';
			if($_[0] eq $ZERO){$f2=$no_SYL_w_span[1];}			
			if($_[0] ne $ZERO && $_[0] ne $last-2){$d2=$no_SYL_w_span[1];}
			if($_[0] eq $last-2){$d2=$no_SYL_w_span[1];}

			if($_[0] eq $ZERO){$i1=$no_SYL_P_span[1];$i2=$no_w_P_span[1];}			
			if($_[0] ne $ZERO && $_[0] ne $last-2 && $current_syl eq $GHI_P[0]){
						$g1=$no_SYL_P_span[1];$g2=$no_w_P_span[1];		#for si immidiate after the phrase end
				} 
			if($_[0] eq $last-2){$g1=$no_SYL_P_span[1];$g2=$no_w_P_span[1];}
			}
else{
	$P_syl=$current_syl;
	$current_syl=$P67[1];
	$n_syl=$P67[2];
	$FI=$P67[1]-$_[0];
		if($FI<0){$FI=$P67[2]-$_[0];$current_syl=$P67[2];$n_syl=$P67[3];}

	$P_word=$current_word;
	$current_word=$E34_w_list[0];	
	if($_[0] eq $E34_w_list[0]){shift(@E34_w_list);}
	

		if($P_syl ne $current_syl){
			#===============stress calculation=======================================
			shift(@stress);push(@stress,$ZERO);
				if($current_syl eq $A12[0] && $n_syl ne $A12[1]){$stress[2]='1';shift(@A12);}
				elsif($current_syl eq $A12[0] && $n_syl eq $A12[1]){$stress[2]='1';shift(@A12);}
			$a1=$stress[0];					#previous syllable

			$b1=$stress[1];					#current syllable
		
			$c1=$stress[2];					#next syllable
			#===============no of phonemes in P C N syllable calculation=======================================
			
			$a3=$SYL_size[0];
			$b3=$SYL_size[1];			
			$c3=$SYL_size[2];
			if($c3<0){$c3 = '0';}
			shift(@SYL_size);
			
			#==================================no of syllables in P C N words===================================
			if($P_syl eq $DEF2_w[0]){
				shift(@DEF2_w);
				shift(@no_SYL_w_span);
				}
			$d2=$no_SYL_w_span[0];
			$e2=$no_SYL_w_span[1];
			$f2=$no_SYL_w_span[2];
			if($f2<0){$f2 = '0';}
			
			#============================no of syllables AND words in P C N phrase========================================
			if($P_syl eq $GHI_P[0]){
				shift(@GHI_P);
				shift(@no_SYL_P_span);shift(@no_w_P_span);
				}
			$g1=$no_SYL_P_span[0];
			$h1=$no_SYL_P_span[1];
			$i1=$no_SYL_P_span[2];
			if($i1<0){$i1 = '0';}

			$g2=$no_w_P_span[0];
			$h2=$no_w_P_span[1];
			$i2=$no_w_P_span[2];
			if($i2<0){$i2 = '0';}

			#=======================position of the phrase in utterence========================================

			if($P_syl eq $H34_P[0]){
				shift(@H34_P);
				$h3=$h3+1;$h4=$h4-1;
				}
			#=======================position of syllable in current word=======================================
				if($FLAG eq $ONE){
					@FIRST_index = grep { $SYL_B45[$_] eq $current_syl } 0..$#SYL_B45;
					@LAST_index = grep { $SYL_B45[$_] eq $W_B45[0] } 0..$#SYL_B45;
				}
			$FLAG = $ZERO;
			@SYL_span = @SYL_B45[$FIRST_index[0] .. $LAST_index[0]];
			@current_syl_index = grep { $SYL_span[$_] eq $current_syl } 0..$#SYL_span;
			$no_SYL = scalar(@SYL_span);
			if($no_SYL eq $FOUR){
				if($current_syl_index[0] eq '0'){$b4='1';$b5='4';}
				elsif($current_syl_index[0] eq '1'){$b4='2';$b5='3';}
				elsif($current_syl_index[0] eq '2'){$b4='3';$b5='2';}
				elsif($current_syl_index[0] eq '3'){$b4='4';$b5='1';shift(@W_B45);$FLAG=$ONE;}
			}
			elsif($no_SYL eq $THREE){
				if($current_syl_index[0] eq '0'){$b4='1';$b5='3';}
				elsif($current_syl_index[0] eq '1'){$b4='2';$b5='2';}
				elsif($current_syl_index[0] eq '2'){$b4='3';$b5='1';shift(@W_B45);$FLAG=$ONE;}
			}
			elsif($no_SYL eq $TWO){
				if($current_syl_index[0] eq '0'){$b4='1';$b5='2';}
				elsif($current_syl_index[0] eq '1'){$b4='2';$b5='1';shift(@W_B45);$FLAG=$ONE;}
			}
			elsif($no_SYL eq $ONE){$b4='1';$b5='1';shift(@W_B45);$FLAG=$ONE;}

			#=================position of the syllable in current phrase============================
			if($increase == $no_SYL_phrase+1 || $increase == 1){
				shift(@B67);
				@FIRST_phrase_index = grep { $SYL_B45[$_] eq $current_syl } 0..$#SYL_B45;
				@LAST_phrase_index = grep { $SYL_B45[$_] eq $B67[0] } 0..$#SYL_B45;

				@phrase_span = @SYL_B45[$FIRST_phrase_index[0] .. $LAST_phrase_index[0]];
				$no_SYL_phrase = scalar(@phrase_span);
				$decrease = $no_SYL_phrase;$increase=1;
			}
			$b6=$increase;$b7=$decrease;
			$increase = $increase+1;$decrease=$decrease-1;
			
			#=====================position of the word in current phrase================================

			if($P_word ne $current_word){#print "W = $P_word  $current_word\n";
					if($w_increase == $no_word_P_span+1 || $w_increase==1){
						shift(@E34_P);
						@FIRST_w_P_index = grep { $E34_w[$_] eq $current_word } 0..$#E34_w;
						@LAST_w_P_index = grep { $E34_w[$_] eq $E34_P[0] } 0..$#E34_w;
						@word_P_span = @E34_w[$FIRST_w_P_index[0] .. $LAST_w_P_index[0]];
						$no_word_P_span = scalar(@word_P_span);
						$w_decrease=$no_word_P_span;$w_increase=1;
						}
				$e3=$w_increase;$e4=$w_decrease;
				$e5=$e3-1;$e6=$e4-1;
				$w_increase=$w_increase+1;$w_decrease=$w_decrease-1;
				$d1 = lc($POS_access[0]);$e1 = lc($POS_access[1]);$f1 = lc($POS_access[2]);
				shift(@POS_access);
				}

			#==================no of stressed syllable before and after the current syllable====================
			if($P_syl eq $B89_p[0]){	
				@B89_SYL_F_index = grep { $j11[$_] eq $B89_p[0] } 0..$#j11;
				shift(@B89_p);				
				@B89_SYL_L_index = grep { $j11[$_] eq $B89_p[0] } 0..$#j11;
				@B89_SYL_span=@B89_SYL[$B89_SYL_F_index[0]+2 .. $B89_SYL_L_index[0]+1];				
				@B89_stress_SYL_span=@B89[$B89_SYL_F_index[0]+2 .. $B89_SYL_L_index[0]+1];
				unshift(@B89_SYL_span,$ZERO);
				unshift(@B89_stress_SYL_span,$ZERO);
				}
			@B89_index = grep { $B89_SYL_span[$_] eq $current_syl } 0..$#B89_SYL_span;
			@FIRST_no_stress = grep { $B89_stress_SYL_span[$_] =~ $stress_inicator } 0..$B89_index[0]-1;
			@LAST_no_stress = grep { $B89_stress_SYL_span[$_] =~ $stress_inicator } $B89_index[0]+1..$#B89_stress_SYL_span;

			if($FIRST_no_stress[0] eq $ZERO){$b8='0';}
			elsif($LAST_no_stress[0] eq $ZERO){$b9='0';}
			else{$b8=scalar(@FIRST_no_stress);$b9=scalar(@LAST_no_stress);}

			#print "F = $FIRST_no_stress[-1] C = $B89_index[0] L = $LAST_no_stress[0]\t";print"\n";
			$b12=$B89_index[0]-$FIRST_no_stress[-1];
			$b13=$LAST_no_stress[0]-$B89_index[0];
			if($FIRST_no_stress[-1] == "NULL"){$b12='0';}
			elsif($LAST_no_stress[0] == "NULL"){$b13='0';}
		
			#==================name of the VOWEL in the current syllable====================
			if($P_syl eq '24125236'){@phoneme_span=@phoneme[0 .. $current_syl];}
			else{@phoneme_span=@phoneme[$P_syl+1 .. $current_syl];}
				OUTER:for($VW=0;$VW<@VOWEL;$VW++){
					INNER:for($PH=0;$PH<@phoneme_span;$PH++){
						if($VOWEL[$VW] eq $phoneme_span[$PH]){$b16 = $phoneme_span[$PH];last OUTER;}
						}
					}

		}

#========================useless value for accented=========================
$b2='0';							#current accented
$b10='0';$b11='0';
$b14='0';$b15='0';
$h5= '0';


#=====================guess part-of-speech========================================
#$d1=$e1=$f1='content';
if($_[0] <= $j22[0]){$d1='x';}
if($_[0] > $j22[-2]){$f1='x';}
#==========================no of words from the Previous content word to the current word AND to the next content word=================

$e7=1;$e8=1;
if($_[0] <= $j22[0]){$e7='0';}
if($_[0] > $j22[-2]){$e8='0';}

#================position of the phoneme=====================================================
	unshift(@QUE,$FI);pop(@QUE);

		@THREE_i = grep { $QUE[$_] eq $THREE } 0..$#QUE;
		if($THREE_i[0] eq '0'){$p6='1';$p7='4';}
		elsif($THREE_i[0] eq '1'){$p6='2';$p7='3';}
		elsif($THREE_i[0] eq '2'){$p6='3';$p7='2';}
		elsif($THREE_i[0] eq '3'){$p6='4';$p7='1';shift(@P67);}
		else{
			@TWO_i = grep { $QUE[$_] eq $TWO } 0..$#QUE-1;
			if($TWO_i[0] eq '0'){$p6='1';$p7='3';}
			elsif($TWO_i[0] eq '1'){$p6='2';$p7='2';}
			elsif($TWO_i[0] eq '2'){$p6='3';$p7='1';shift(@P67);}
			else{
				@ONE_i = grep { $QUE[$_] eq $ONE } 0..$#QUE-2;
				if($ONE_i[0] eq '0'){$p6='1';$p7='2';}
				elsif($ONE_i[0] eq '1'){$p6='2';$p7='1';shift(@P67);}
				else{$p6='1';$p7='1';shift(@P67);}
				}
			}
	}
}


#========================================Change Phoneme================================================


open(FILE, $dest) || die("Could not open file!");
	@lines = <FILE>;
	close (FILE);

		open (LAB,">$dest");
			foreach $lines(@lines){
				$lines =~ s/a\~+/ax/g;
				$lines =~ s/aA\~+/ahx/g;
				$lines =~ s/aA+/ah/g;				
				$lines =~ s/i\~+/ix/g;
				$lines =~ s/u\~+/ux/g;
				$lines =~ s/e\~+/ex/g;
				$lines =~ s/o\~+/ox/g;
				$lines =~ s/eE\~+/ehx/g;
				$lines =~ s/eE+/eh/g;				
				$lines =~ s/kH+/kh/g;	
				$lines =~ s/gH+/gh/g;
				$lines =~ s/nG+/ng/g;
				$lines =~ s/cH+/ch/g;
				$lines =~ s/jH+/jh/g;
				$lines =~ s/t\.+/tx/g;
				$lines =~ s/tH\.+/thx/g;
				$lines =~ s/d\.+/dx/g;
				$lines =~ s/dH\.+/dhx/g;	
				$lines =~ s/nN+/nh/g;
				$lines =~ s/tH+/th/g;
				$lines =~ s/dH+/dh/g;
				$lines =~ s/n\.+/nx/g;
				$lines =~ s/pH+/ph/g;
				$lines =~ s/bH+/bh/g;
				$lines =~ s/r\.+/rx/g;
				$lines =~ s/l\.+/lx/g;
				$lines =~ s/sS+/sh/g;
				$lines =~ s/rH\.+/rhx/g;
				print LAB $lines;		
				}
		close (LAB);





