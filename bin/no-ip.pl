#!/usr/bin/perl

use strict;
use warnings;

sub get_domain_names {
    my $s = shift;
    my $filename = "/tmp/no-ip-$s.html";
    `wget -O $filename http://www.no-ip.com/services/managed_dns/${s}_dynamic_dns.html`
        unless -f $filename;
    my $raw = do { local(@ARGV, $/) = $filename, <> };
    $raw =~ m{<div class="servicesThreeCol"[^>]*>(.+?)</div>}gs;
    my @names = $1 =~ m{<li>(.+?)\s*(?:</li>|\n)}gm;
    unlink $filename;
    join("\n", @names) . "\n"
}

my $names = '';

open NAMES, 'multisite_names.txt';
foreach my $line (<NAMES>) {
    last if ($line eq "# no-ip\n");
    $names .= $line;
}
close NAMES;

$names .= "# no-ip\n";

foreach (qw'free enhanced') {
    $names .= get_domain_names $_;
}

open NAMES, '>multisite_names.txt';
print NAMES $names;
close NAMES;
