#!/usr/bin/perl -w

BEGIN { unshift @INC, 'lib', '../../lib'}
use Chart::ErrorBars;

print "1..1\n";

$g = Chart::ErrorBars->new();

$g->add_dataset(qw(1   1.1  1.2  1.3  1.4  1.5  1.6  1.7  1.8  1.9  2   2.1 2.2 2.3 2.4 2.5));
$g->add_dataset(qw(1   1.1  1.2  1.1  1.14 1.15 1.26 1.2 1.1  1.19 1.2 1.4 1.6 2.0 2.5 3.1));
$g->add_dataset(qw(0.4 0.1  0.2  0.1  0.14 0.15 0.26 0.27 0.1  0.19 0.2 0.1 0.1 0.2 0.1 0.3));

$g->set(
    'xy_plot'        => 'true',
    'precision'      => 2,
    'same_error'     => 'true',
    'pt_size'        => 12,
    'brush_size'     => 2,
    'legend'         => 'none',
    'title'          => 'Error Bars Demo',
    'include_zero'   => 'true',
    'max_val'        => 3,
    'custom_x_ticks' => [ 0, 1 ],
);

$g->png("samples/error_2.png");

print "ok 1\n";

exit(0);
