
use ExtUtils::MakeMaker;

WriteMakefile( 
	'VERSION' => 98.11_29_01,
	'NAME' => 'Time-modules',
	($] >= 5.005 ?
	    ('ABSTRACT' => 'Parse and format time values',
	     'AUTHOR'	=> 'David Muir Sharnoff <muir@idiom.com>') : ()),
	'dist' => { COMPRESS=>"gzip", SUFFIX=>"gz" },
	);
