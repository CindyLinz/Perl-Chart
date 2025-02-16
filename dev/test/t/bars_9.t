#!/usr/bin/perl -w

BEGIN { unshift @INC, 'lib', '../../lib'}
use Chart::Bars;
use strict;
use POSIX;

print "1..1\n";

my $g = Chart::Bars->new( 600, 400 );

my @data = ( 200202, 200203, 200204, 200205, 200206, 200207, 200208, 200209, 200210, 200211, 200212, 200301 );

my @data1 = ( 6626, 7090, 7580, 7671, 8764, 8664, 6343, 5518, 6257, 5391, 5401, 6002 );

$g->add_dataset(@data);
$g->add_dataset(@data1);

my @legend_keys = ( "Actual ", "Goal" );

$g->set(
    colors          => { dataset0 => [ 25, 220, 147 ], },
    graph_border    => 0,
    grey_background => 'false',
    grid_lines      => 'true',
    include_zero    => 'true',

    # integer_ticks_only => 'true',
    legend         => 'none',
    png_border     => 4,
    precision      => 1,
    skip_int_ticks => 1000,
    text_space     => 3,
    title          => "Tickets",
    title_font     => GD::Font->Giant,
    transparent    => 'false',
    x_ticks        => 'vertical',
    y_axes         => 'both',
    y_label        => '# Tickets',
    x_label        => 'Date',
);

$g->png("samples/bars_9.png");
print "ok 1\n";

exit(0);

