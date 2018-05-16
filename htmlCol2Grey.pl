#!/usr/bin/perl
##########################################
# turn all #RRGGBB codes in HTML-files or CSS-files 
# 	to grey values which are calculated by the values 
# 	of the red green and blue part of the color-hex-codes
# call on command line
# Thomas Hofmann 2018 Apr
##########################################

#use List::AllUtils qw(sum);

if( $#ARGV < 0 ) { usage( "Missing filename parameter" ); }
my $overwrite = undef;
if( $ARGV[0] eq '-o' ) { $overwrite = shift( @ARGV ); }
if( $#ARGV < 0 ) { usage( "Missing filename parameter" ); }
my $filename = shift( @ARGV );

# check input file
if( !(-f $filename) ) { usage( "File name not found [$filename]" ); }
if( !open(IN, $filename) ) { usage( "Could not read File [$filename]" ); }

# read the input file
my @incontent = <IN>;
close( IN );

# check output file
my $outfilename = "$filename\.col2grey";
if( (-f $outfilename) && !( $overwrite ) ) {
	if( !( $overwrite = yesno( "File for output exist, should I overwrite it? [$outfilename]" ) ) ) {
		usage("Will not overwrite file, abort. [$outfilename]");
	} else {
		print("Will overwrite existing out file. [$outfilename]\n");
	}
} elsif(  ( $overwrite ) ) {
	print("Will overwrite existing out file. [$outfilename]\n");
}

if( !(open( OUT, ">$outfilename" ) ) ) {
	usage( "Could not write out file, abort. [$outfilename]" );
}

# do the replace - and write the output file
my (@sers, $ser, $ready, $rest, $pos, @newcol, $newcol, $linebegin, $linenew, $line);
@newcol = (); $pos = 0;
foreach $line ( @incontent ) {
	$ready = ''; 
	$linenew = $line;
	chomp( $linenew );
	
	# get the search results in line
	@sers = ( $linenew =~ m/(#[0-9a-f]{6})/ig );
	
	# calculate and replace each
	foreach $ser (@sers) {
	
		# get the value and call calculate
		$newcol = col2grey( $ser );
		
		# find the position
		$pos = index( $linenew, $ser );
		
		# add begin string until color to remembered string
		# 0...,....1.V..,....2....,....3..
		# this color #4080c0 ist the thing
		# 
		#$linebegin 	= substr( $line, 0, $pos - 1 );
		#$rest 		= substr( $line, $pos + 7);
		$ready 		= $ready . substr( $linenew, 0, $pos  ) . "#$newcol";
		$linenew 	= substr( $linenew, $pos + 7);
	}
	
	# add the rest of the line
#	print "--[$ready]--\n~~[$linenew]~~\n__[$line]__\n";
#	<STDIN>;
	$ready .= $linenew;
	
	# write it
	print OUT "$ready\n";
}

close( OUT );
print "Written file - END [$outfilename]\n";

sub usage {
	my ( $message, @rest ) = @_;
	if( defined( $message ) ) {
		print( $message );
		if( $message !~ m/\r?\n$/ ) { print( "\n" ); }
	}
	print( "htmlCol2Grey - Th. Hofmann, Apr 2018 -  turn all #RRGGBB codes to grey values \nusage: [perl] [./]htmlCol2Grey.pl [-o] (file-name)\n  -o = overwrite existing out file" );
	exit(255);
}

sub yesno {
	my ( $message, @rest ) = @_;
	my $answer = '';
	while ( $answer !~ m/^[y]$/i ) {
		print "$message (Y/N): ";
		$answer = <STDIN>;
		chomp( $answer );
		if ( $answer =~ m/^[n]$/i ) {
			return( undef );
		}
	}
	return( 1 );
}

sub col2grey {
	my ( $colis, @rest ) = @_;
	my ( $r, $g, $b, $gr,  );
	( $r, $g, $b ) = ( $colis =~ m/([0-9a-f]{2})/ig );
	$gr = sprintf( "%x", average( hex($r), hex($g), hex($b) ) );
	return( "$gr$gr$gr" );
}
sub average {
	return @_ ? sum(@_) / @_ : 0 
}
sub sum {
	my @ops = @_;
	my $sumit = 0;
	foreach my $op ( @ops ) {
		$sumit += $op;
	}
	return( $sumit );
}

