#!/usr/local/bin/perl -Ilib -w

# David Muir Sharnoff <muir@idiom.com>

# find out why it died if not running under make

$rerun = $ENV{'PERL_DL_NONLAZY'} ? 0 : 1; 
$debug = 0; 

$Time::ParseDate::debug = $debug;

use vars qw($VERSION);
$VERSION = 96.10_02_01;

BEGIN { 
	$okat = 12;
	$ENV{'LANG'} = 'C';
	$ENV{'TZ'} = 'PST8PDT'; 

	%k = (
		'%' =>	'%',
		'a' =>	'Sat',
		'A' =>	'Saturday',
		'b' =>	'Nov',
		'h' =>	'Nov',
		'B' =>	'November',
		'c' =>	"Sat Nov 19 21:05:57 1994",
		'd' =>	'19',
		'D' =>	'11/19/94',
		'e' =>	'19',
		'H' =>	'21',
		'I' =>	'09',
		'j' =>	'323',
		'k' =>	'21',
		'l' =>	' 9',
		'm' =>	'11',
		'M' =>	'05',
		'n' =>	"\n",
		'o' =>	'19th',
		'p' =>	"PM",
		'r' =>	"09:05:57 PM",
		'R' =>	"21:05",
		'S' =>	"57",
		't' =>	"\t",
		'T' =>	"21:05:57",
		'U' =>	"46",
		'w' =>	"6",
		'W' =>	"46",
		'x' =>	"11/19/94",
		'y' =>  "94",
		'Y' =>  "1994",
		'X' =>	"21:05:57",
		'Z' =>	"PST"
		);

	$sdt_start_line = __LINE__+2;
	@sdt = (
		796969332, ['950404 00:22:12 "EDT'],
		786437763, ['Fri Dec  2 22:56:03 1994', NOW => 785300000],
		786408963, ['Fri Dec  2 22:56:03 GMT+0 1994', NOW => 785300000],
		786437763, ['Fri Dec  2 22:56:03 GMT-8 1994', NOW => 785300000],
		786437760, ['94/12/02.22:56', NOW => 785300000],
		786437760, ['1994/12/02 10:56Pm', NOW => 785300000],
		786437760, ['1994/12/2 10:56 PM', NOW => 785300000],
		786437760, ['12/02/94 22:56', NOW => 785300000],
		786437760, ['12/2/94 10:56Pm', NOW => 785300000],
		786437760, ['94/12/2 10:56 pm', NOW => 785300000],
		786437763, ['94/12/02 22:56:03', NOW => 785300000],   
		786437760, ['10:56Pm 94/12/02', NOW => 785300000],
		786437763, ['22:56:03 1994/12/02', NOW => 785300000],
		786437760, ['22:56 1994/12/2', NOW => 785300000],
		786437760, ['10:56PM 12/02/94', NOW => 785300000],
		786437760, ['10:56 pm 12/2/94', NOW => 785300000],
		786437760, ['22:56 94/12/2', NOW => 785300000],
		786437760, ['10:56Pm 94/12/02', NOW => 785300000],
		796980132, ['Tue Apr 4 00:22:12 PDT 1995'],
		796980132, ['April 4th 1995 12:22:12AM', ZONE => PDT],
		827878812, ['Tue Mar 26 14:20:12 1996'],		
		827878812, ['Tue Mar 26 14:20:12 GMT-0800 1996'],
		827878812, ['Tue Mar 26 17:20:12 EST 1996'],
		827878812, ['Tue Mar 26 17:20:12 GMT-0500 1996'],
		827878812, ['Tue Mar 26 22:20:12 GMT 1996'],
		827878812, ['Tue Mar 26 22:20:12 +0000 (GMT) 1996'],
		827878812, ['Tue, 26 Mar 22:20:12 +0000 (GMT) 1996'],
		784394917, ['Wed, 9 Nov 1994 7:28:37'],
		784887518, ['Tue, 15 Nov 1994 0:18:38'], 
		788058300, ['21 dec 17:05', NOW => 785300000],
		802940400, ['06/12/1995'],
		802940400, ['12/06/1995', UK => 1],
		802940400, ['12/06/95', UK => 1],
		802940400, ['06.12.1995'],
		803026800, ['13/06/1995'],
		803026800, ['13/06/95'],
		784394917, ['Wed, 9 Nov 1994 15:28:37 +0000 (GMT)'],
		827878812, ['Tue Mar 26 23:20:12 GMT+0100 1996'],
		827878812, ['Wed Mar 27 05:20:12 GMT+0700 1996'],
		827878812, ['Wed Mar 27 05:20:12 +0700 1996'],
		827878812, ['Wed Mar 27 05:20:12 +0700 (EST) 1996'],
		796980132, ['1995/04/04 00:22:12 PDT'],
		796720932, ['1995/04 00:22:12 PDT'],
		796980132, ['1995/04/04 00:22:12 PDT'],
		796980132, ['Tue, 4 Apr 95 00:22:12 PDT'],
		796980132, ['Tue 4 Apr 1995 00:22:12 PDT'],
		796980132, ['04 Apr 1995 00:22:12 PDT'],
		796980132, ['4 Apr 1995 00:22:12 PDT'],
		796980132, ['Tue, 04 Apr 00:22:12 PDT', NOW => 796980132],
		796980132, ['Tue 04 Apr 00:22:12 PDT', NOW => 796980132],
		796980132, ['04 Apr 00:22:12 PDT', NOW => 796980132],
		796980132, ['Apr 04 00:22:12 PDT', NOW => 796980132],
		796980132, ['Apr 4 00:22:12 PDT', NOW => 796980132],
		796980132, ['Tue, Apr 4 00:22:12 PDT', NOW => 796980132],
		796980132, ['Apr 4 1995 00:22:12 PDT'],
		796980132, ['April 4th 1995 00:22:12 PDT'],
		796980132, ["April 4th, '95 00:22:12 PDT"],
		796980132, ["April 4th 00:22:12 PDT", NOW => 796980132],
		796980132, ['95/04/04 00:22:12 PDT'],
		796980132, ['04/04/95 00:22:12 PDT'],
		796720932, ['95/04 00:22:12 PDT'],
		796720932, ['04/95 00:22:12 PDT'],
		796980132, ['04/04 00:22:12 PDT', NOW => 796980132],
		796980132, ['040495 00:22:12 PDT'],
		796980132, ['950404 00:22:12 PDT'],
		796969332, ['950404 00:22:12 EDT'],
		796980132, ['04.04.95 00:22:12', ZONE => PDT],
		796980120, ['04.04.95 00:22', ZONE => PDT],
		796978800, ['04.04.95 12AM', ZONE => PDT],
		796978800, ['04.04.95 12am', ZONE => PDT],
		796980120, ['04.04.95 0022', ZONE => PDT],
		796980132, ['04.04.95 12:22:12am', ZONE => PDT],
		797023332, ['950404 122212', ZONE => PDT],
		797023332, ['122212 950404', ZONE => PDT, TIMEFIRST => 1],
		796980120, ['04.04.95 12:22AM', ZONE => PDT],
		796978800, ['95/04/04 midnight', ZONE => PDT],
		796978800, ['95/04/04 Midnight', ZONE => PDT],
		797022000, ['95/04/04 Noon', ZONE => PDT],
		797022000, ['95/04/04 noon', ZONE => PDT],
		797022000, ['95/04/04 12Pm', ZONE => PDT],
		796978803, ['+3 secs', NOW => 796978800],
		796979600, ['+0800 seconds', NOW => 796978800],
		796986000, ['+2 hour', NOW => 796978800],
		796979400, ['+10min', NOW => 796978800],
		796979400, ['+10 minutes', NOW => 796978800],
		797011203, ['95/04/04 +3 secs', ZONE => EDT, NOW => 796935600],
		797062935, ['4 day +3 secs', ZONE => PDT, NOW => 796720932],
		797062935, ['now + 4 days +3 secs', ZONE => PDT, NOW => 796720932],
		797062935, ['now +4 days +3 secs', ZONE => PDT, NOW => 796720932],
		796720932, ['now', ZONE => PDT, NOW => 796720932],
		796720936, ['now +4 secs', ZONE => PDT, NOW => 796720932],
		796735332, ['now +4 hours', ZONE => PDT, NOW => 796720932],
		797062935, ['+4 days +3 secs', ZONE => PDT, NOW => 796720932],
		797062935, ['+ 4 days +3 secs', ZONE => PDT, NOW => 796720932],
		797062929, ['4 day -3 secs', ZONE => PDT, NOW => 796720932],
		796375329, ['-4 day -3 secs', ZONE => PDT, NOW => 796720932],
		796375329, ['now - 4 days -3 secs', ZONE => PDT, NOW => 796720932],
		796375329, ['now -4 days -3 secs', ZONE => PDT, NOW => 796720932],
		796720928, ['now -4 secs', ZONE => PDT, NOW => 796720932],
		796706532, ['now -4 hours', ZONE => PDT, NOW => 796720932],
		796375329, ['-4 days -3 secs', ZONE => PDT, NOW => 796720932],
		796375329, ['- 4 days -3 secs', ZONE => PDT, NOW => 796720932],
		797322132, ['1 week', NOW => 796720932],
		801987732, ['2 month', NOW => 796720932],
		804579732, ['3 months', NOW => 796720932],
		859879332, ['2 years', NOW => 796720932],
		797671332, ['Wed after next', NOW => 796980132],
		797498532, ['next monday', NOW => 796980132],
		797584932, ['next tuesday', NOW => 796980132],
		797066532, ['next wEd', NOW => 796980132],
		796378932, ['last tuesday', NOW => 796980132],
		796465332, ['last wednesday', NOW => 796980132],
		796893732, ['last monday', NOW => 796980132],
		797036400, ['today at 4pm', NOW => 796980132],
		797080932, ['tomorrow +4hours', NOW => 796980132],
		796950000, ['yesterday at 4pm', NOW => 796980132],
		796378932, ['last week', NOW => 796980132],
		794305332, ['last month', NOW => 796980132],
		765444132, ['last year', NOW => 796980132],
		797584932, ['next week', NOW => 796980132],
		799572132, ['next month', NOW => 796980132],
		828606132, ['next year', NOW => 796980132],
		836391600, ['July 3rd, 4:00AM 1996 ', DATE_REQUIRED =>1, TIME_REQUIRED=>1, NO_RELATIVE=>1, NOW=>796980132],
		783718105, ['Tue, 01 Nov 1994 11:28:25 -0800'],
		202779300, ['5:35 pm june 4th CST 1976'],
		236898000, ['5pm EDT 4th july 1977'],
		236898000, ['5pm EDT 4 july 1977'],
		819594300, ['21-dec 17:05', NOW => 796980132],
		788058300, ['21-dec 17:05', NOW => 796980132, PREFER_PAST => 1],
		819594300, ['21-dec 17:05', NOW => 796980132, PREFER_FUTURE => 1],
		793415100, ['21-feb 17:05', NOW => 796980132, PREFER_PAST => 1],
		824951100, ['21-feb 17:05', NOW => 796980132, PREFER_FUTURE => 1],
		819594300, ['21/dec 17:05', NOW => 796980132],
		756522300, ['21/dec/93 17:05'],
		788058300, ['dec 21 1994 17:05'],
		788058300, ['dec 21 94 17:05'],
		788058300, ['dec 21 94 17:05'],
		796465332, ['Wednesday', NOW => 796980132, PREFER_PAST => 1],
		796378932, ['Tuesday', NOW => 796980132, PREFER_PAST => 1],
		796893732, ['Monday', NOW => 796980132, PREFER_PAST => 1],
		797066532, ['Wednesday', NOW => 796980132, PREFER_FUTURE => 1],
		797584932, ['Tuesday', NOW => 796980132, PREFER_FUTURE => 1],
		797498532, ['Monday', NOW => 796980132, PREFER_FUTURE => 1],
		802915200, ['06/12/1995', ZONE => GMT],
		828860438, ['06/Apr/1996:23:00:38 -0800'],
		828860438, ['06/Apr/1996:23:00:38'],
		828943238, ['07/Apr/1996:23:00:38 -0700'],
		828943238, ['07/Apr/1996:23:00:38'],
		828856838, ['06/Apr/1996:23:00:38 -0700'],
		828946838, ['07/Apr/1996:23:00:38 -0800'],
		895474800, ['5/18/1998'],
		796980132, ['04/Apr/1995:00:22:12', ZONE => PDT], 
		796983732, ['04/Apr/1995:00:22:12 -0800'], 
		796983732, ['04/Apr/1995:00:22:12', ZONE => PST], 
		202772100, ['5:35 pm june 4th 1976 EDT'],
		796892400, ['04/03', NOW => 796980132, PREFER_PAST => 1],
		765702000, ['04/07', NOW => 796980132, PREFER_PAST => 1],
		883641600, ['1/1/1998'],
		852105600, ['1/1/1997'],
		852105600, ['last year', NOW => 883641600],
		820483200, ['-2 years', NOW => 883641600],
		832402800, ['-2 years', NOW => 895474800],
		891864000, ['+3 days', NOW => 891608400],
		891777600, ['+2 days', NOW => 891608400],
		);

	%tztests = (
		"YDT"  =>   -8*3600,         # Yukon Daylight
		"HDT"  =>   -9*3600,         # Hawaii Daylight
		"BST"  =>   +1*3600,         # British Summer   
		"MEST" =>   +2*3600         # Middle European Summer  
	);

}

BEGIN { unshift(@INC, "."); }

use Time::CTime;
use Time::JulianDay;
use Time::ParseDate;
use Time::Local;
use Time::Timezone;

my $before_big = $okat-1+scalar(keys %k)+scalar(keys %tztests);

printf "1..%d\n", $before_big + @sdt/2;

$etime = 785307957;

eval " 1/0; ";  # tests a bug in ctime!
$x = ctime($etime);
print $x eq "Sat Nov 19 21:05:57 PST 1994\n" ? "ok 1\n" : "not ok 1\n";

print julian_day(1994,11,19) == 2449676 ? "ok 2\n" : "not ok 2\n";

@x = inverse_julian_day(2449676);

print $x[0] == 1994 ? "ok 3\n" : "not ok 3\n";
print $x[1] == 11 ? "ok 4\n"   : "not ok 4\n";
print $x[2] == 19 ? "ok 5\n"   : "not ok 5\n";

print day_of_week(2449676) == 6 ? "ok 6\n" : "not ok 6\n";

$bs = 786439995;

use vars qw($isdst $wday $yday);
($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst) = gmtime($bs);

$jdtgm = jd_timegm($sec,$min,$hour,$mday,$mon,$year);
$jdtl = jd_timelocal($sec,$min,$hour,$mday,$mon,$year);
$tltl = timelocal($sec,$min,$hour,$mday,$mon,$year);

$year += 100 if $year < 70;
$jd = julian_day($year+1900, $mon+1, $mday);
$s = jd_secondsgm($jd, $hour, $min, $sec);
$lo = tz_local_offset($bs);

print <<"" if $debug;
	s = $s
	bs = $bs
	jdtgm = $jdtgm
	jdtl = $jdtl
	tltl = $tltl
	lo = $lo

print $s == $bs ? "ok 7\n" : "not ok 7\n";

print $jdtgm == $bs ? "ok 8\n" : "not ok 8\n";

print $jdtl == $bs+8*3600 ? "ok 9\n" : "not ok 9\n";

print $tltl == $bs+8*3600 ? "ok 10\n" : "not ok 10\n";

print $lo == - 28800 ? "ok 11\n" : "no ok 11\n";

################### make these last...
$c = $okat;

foreach $i (sort keys %k) {
	$x = strftime("-%$i-", localtime($etime));
	print $x eq "-$k{$i}-" ? "ok $c\n" : "not ok $c\n";
	if ($debug && $x ne "-$k{$i}-") {
		print "strftime(\"-%$i-\") = $x.\n\tshould be: $k{$i}.\n";
		exit(0);
	}
	$c++;
}

foreach $i (keys %tztests) {
	$tzo = tz_offset($i,799572132);
	print $tzo eq $tztests{$i} ? "ok $c\n" : "not ok $c\n";
	if (($debug || $rerun) && $tzo ne $tztests{$i}) {
		print "tz_offset($i) = $tzo != $tztests{$i}\n";
		exit(0);
	}
	$c++;
}

while (@sdt) {
	$es = shift(@sdt);
	$ar = shift(@sdt);
	$s = parsedate(@$ar, 'WHOLE' => 1);
	if ($es == $s) {
		print "ok $c\n";
	} else {
		print "not ok $c\n";
		if ($rerun || $debug) {
			print strftime("Expected:    %c %Z\n", localtime($es));
			print strftime("\tGot($s): %c %Z", localtime($s));
			print strftime(" (%m/%d %I:%M %p GMT)\n", gmtime($s));
			my @z = @$ar;
			print "\tInput: $z[0]\n";
			shift(@z);
			while (@z) {
				my $zk = shift(@z);
				my $zv = shift(@z);
				if ($zk eq 'NOW') {
					print strftime("\t\tNOW => %c %Z\n", localtime($zv));
				} else {
					print "\t\t$zk => $zv\n";
				}
			}
			if ($rerun) {
				print "The parse...\n";
				$Time::ParseDate::debug = 1;
				&parsedate(@$ar, 'WHOLE' => 1);
				printf "Test that failed was on line %d\n",	
					$c-$before_big+$sdt_start_line-1;
				exit(0);
			}
		}
	}
	$c++;
}
