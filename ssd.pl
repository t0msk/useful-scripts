#!/usr/bin/perl

use strict;
use warnings;

use POSIX qw(strftime);
use File::Path qw(make_path);

my $disc = "sda1";
my $dir = $ENV{"HOME"} . "/.scripts/tomsk/ssd-logger/";

make_path($dir);

unless(-e $dir . "data") {  
    logintofile($dir, $disc);
    return;
}
 
open (my $fr, $dir . "data");
    my $last = <$fr>;
    while (<$fr>) {$last = $_}
close $fr;

my @data = split / /, $last;
if($data[0] < strftime("%Y%m%d", localtime)) {
    logintofile($dir, $disc);
}

sub logintofile {
  
    my $writes = "";
    open (my $fr, "/sys/fs/ext4/" . $_[1] . "/lifetime_write_kbytes");
        $writes = <$fr>;
    close $fr;

    if($writes eq "") {
	$writes = "No SSD";
    }

    open my $fc, ">>", $_[0] . "data";
        print $fc strftime("%Y%m%d", localtime) . " " . $writes . "\n";
    close $fc;

    return;
}
