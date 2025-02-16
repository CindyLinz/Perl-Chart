#!/usr/bin/perl -w

BEGIN { unshift @INC, 'lib', '../../lib'}
use Chart::Bars;
use strict;
use POSIX;

my $a;

$a = 10**(-12);

print "1..1\n";

my $g = Chart::Bars->new( 580, 300 );

my @data = ( 200202, 200203, 200204, 200205, 200206, 200207, 200208, 200209, 200210, 200211, 200212, 200301 );
my @data1 = (
    6626 * $a, -790 * $a, 7580 * $a, 7671 * $a, 8764 * $a, 8664 * $a,
    6343 * $a, 5518 * $a, 6257 * $a, 5391 * $a, 5401 * $a, 6002 * $a
);

#my @data1 =(6626,-790,7580,7671,8764,8664,6343,5518,6257,5391,5401,6002);

$g->add_dataset(@data);
$g->add_dataset(@data1);

$g->set(
    colors          => { dataset0 => [ 25, 220, 147 ], },
    graph_border    => 0,
    grey_background => 'false',
    grid_lines      => 'true',
    include_zero    => 'true',
    legend          => 'none',
    png_border      => 4,
    precision       => 9,
    spaced_bars     => 'true',
    text_space      => 3,
    title           => "Tickets",
    title_font      => GD::Font->Giant,
    transparent     => 'false',
    x_ticks         => 'vertical',
    y_axes          => 'both',
    y_label         => '# Tickets',
    x_label         => 'Date',
);

$g->png("samples/bars_7.png");
print "ok 1\n";

exit(0);

