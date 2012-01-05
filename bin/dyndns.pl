#!/usr/bin/perl

use strict;
use warnings;

sub get_domain_names {
    my $s = shift;
    my $c = shift;
    my $filename = "/tmp/dyndns-$c.html";
    `wget -O $filename http://dyn.com/$s/`
        unless -f $filename;
    my $raw = do { local(@ARGV, $/) = $filename, <> };
    $raw =~ m{<div.+?class="entry">(.+?)</div>}gs;
    my @names = $1 =~ m{<li>(.+?)</li>}gm;
    unlink $filename;
    join("\n", @names) . "\n"
}

my $names = '';

open NAMES, 'multisite_names.txt';
foreach my $line (<NAMES>) {
    last if ($line eq "# dyndns\n");
    $names .= $line;
}
close NAMES;

$names .= "# dyndns\n";

my $c = 1;
foreach (qw'domain-names dns/dyndns-pro/domain-names') {
    $names .= get_domain_names $_, $c++;
}

open NAMES, '>multisite_names.txt';
print NAMES $names;
close NAMES;
