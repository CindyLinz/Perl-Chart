
package Chart;
our $VERSION = 'v2.401.4';

use Chart::Points;
use Chart::Lines;
use Chart::LinesPoints;
use Chart::Mountain;

use Chart::Bars;
use Chart::HorizontalBars;
use Chart::StackedBars;
use Chart::ErrorBars;
use Chart::Pie;

use Chart::Direction;
use Chart::Split;
use Chart::Composite;
use Chart::Pareto;


sub new {
    
}

1;

=pod

=head1 NAME

Chart - a series of charting modules 

=head1 SYNOPSIS 

    use Chart::type;   (type is one of: Points, Lines, Bars, LinesPoints, Composite,
    StackedBars, Mountain, Pie, HorizontalBars, Split, ErrorBars, Pareto, Direction) 

    $obj = Chart::type->new;
    $obj = Chart::type->new ( $png_width, $png_height );

    $obj->set ( $key_1, $val_1, ... ,$key_n, $val_n );
    $obj->set ( $key_1 => $val_1,
            ...
            $key_n => $val_n );
    $obj->set ( %hash );

    # GIFgraph.pm-style API to produce png formatted charts
    @data = ( \@x_tick_labels, \@dataset1, ... , \@dataset_n );
    $obj->png ( "filename", \@data );
    $obj->png ( $filehandle, \@data );
    $obj->png ( FILEHANDLE, \@data );
    $obj->cgi_png ( \@data );

    # Graph.pm-style API
    $obj->add_pt ($label, $val_1, ... , $val_n);
    $obj->add_dataset ($val_1, ... , $val_n);
    $obj->png ( "filename" );
    $obj->png ( $filehandle );
    $obj->png ( FILEHANDLE );
    $obj->cgi_png ();

    The similar functions are available for j-peg

    # Retrieve image map information
    $obj->set ( 'imagemap' => 'true' );
    $imagemap_ref = $obj->imagemap_dump ();


=head1 DESCRIPTION

These man-pages give you the most important information about Chart.
There is also a complete documentation (Documentation.pdf) within
the Chart package. Look at it to get more information.
This module is an attempt to build a general purpose graphing module
that is easily modified and expanded.  I borrowed most of the API
from Martien Verbruggen's GIFgraph module.  I liked most of GIFgraph,
but I thought it was to difficult to modify, and it was missing a few
things that I needed, most notably legends.  So I decided to write
a new module from scratch, and I've designed it from the bottom up
to be easy to modify.  Like GIFgraph, Chart uses Lincoln Stein's GD 
module for all of its graphics primitives calls.

=head2 use-ing Chart

Okay, so you caught me.  There's really no Chart::type module.
All of the different chart types (Points, Lines, Bars, LinesPoints,
Composite, StackedBars, Pie, Pareto, HorizontalBars, Split, ErrorBars,
Direction and Mountain so far) are classes by themselves, each inheriting 
a bunch of methods from the Chart::Base class.  Simply replace
the word type with the type of chart you want and you're on your way.  
For example,

  use Chart::Lines;

would invoke the lines module.

=head2 Getting an object

The new method can either be called without arguments, in which
case it returns an object with the default image size (400x300 pixels),
or you can specify the width and height of the image.  Just remember
to replace type with the type of graph you want.  For example,

  $obj = Chart::Bars->new (600,400);

would return a Chart::Bars object containing a 600x400 pixel
image.  New also initializes most of the default variables, which you 
can subsequently change with the set method.


=head2 Setting different options

This is where the fun begins.  Set looks for a hash of keys and
values.  You can pass it a hash that you've already constructed, like

  %hash = ('title' => 'Foo Bar');
  $obj->set (%hash);

or you can try just constructing the hash inside the set call, like

  $obj->set ('title' => 'Foo Bar');

The following are all of the currently supported options:

=over 4

=item 'transparent'

Makes the background of the image transparent if set to 'true'.  Useful
for making web page images.  Default is 'false'.

=item 'png_border'

Sets the number of pixels used as a border between the graph
and the edges of the png/j-peg.  Defaults to 10.

=item 'graph_border'

Sets the number of pixels used as a border between the title/labels
and the actual graph within the png.  Defaults to 10.

=item 'text_space'

Sets the amount of space left on the sides of text, to make it more
readable.  Defaults to 2.

=item 'title'

Tells GD graph what to use for the title of the graph.  If empty,
no title is drawn.  It recognizes '\n' as a newline, and acts accordingly.
Remember, if you want to use normal quotation marks instead of single 
quotation marks then you have to quote "\\n". Default is empty.

=item 'sub_title'

Write a sub-title under the title in smaller letters.
 
=item 'x_label'

Tells Chart what to use for the x-axis label.  If empty, no label
is drawn.  Default is empty.

=item 'y_label', 'y_label2'

Tells Chart what to use for the y-axis labels.  If empty, no label
is drawn.  Default is empty.

=item 'legend'

Specifies the placement of the legend.  Valid values are 'left', 'right',
'top', 'bottom'.  Setting this to 'none' tells chart not to draw a
legend.  Default is 'right'.

=item 'legend_labels'

Sets the values for the labels for the different data sets.  Should
be assigned a reference to an array of labels.  For example,

  @labels = ('foo', 'bar');
  $obj->set ('legend_labels' => \@labels);

Default is empty, in which case 'Dataset 1', 'Dataset 2', etc. are
used as the labels.  


=item 'tick_len'

Sets the length of the x- and y-ticks in pixels.  Default is 4. 

=item 'x_ticks'

Specifies how to draw the x-tick labels.  Valid values are 'normal',
'staggered' (staggers the labels vertically), and 'vertical' (the
labels are draw upwards).  Default is 'normal'.

=item 'xy_plot'

Forces Chart to plot a x-y-graph, which means, that the x-axis is also
numeric if set to 'true'. Very useful for mathematical graphs.
Works for Lines, Points, LinesPoints and ErrorBars. Split makes always a 
xy_plot. Defaults to 'false'.

=item 'min_y_ticks'

Sets the minimum number of y_ticks to draw when generating a scale.
Default is 6, The minimum is 2.

=item 'max_y_ticks'

Sets the maximum number of y_ticks to draw when generating a scale.
Default is 100. This limit is used to avoid plotting an unreasonable
large number of ticks if non-round values are used for the min_val
and max_val.

The value for 'max_y_ticks' should be at least 5 times larger than
'min_y_ticks'.

=item 'max_x_ticks', 'min_x_ticks'

Work similar as 'max_y_ticks' and 'min_y_ticks'. Of course, only for a 
xy_plot.

=item 'integer_ticks_only'

Specifies how to draw the x- and y-ticks: as floating point 
('false', '0') or as integer numbers ('true', 1). Default: 'false'

=item 'skip_int_ticks'

If 'integer_ticks_only' was set to 'true' the labels and ticks will 
be drawn every nth tick. Of course in horizontalBars it affects the
x-axis. Default to 1, no skipping. 

=item 'precision'

Sets the number of numerals after the decimal point. Affects in most
cases the y-axis. But also the x-axis if 'xy_plot' was set and also
the labels in a pie chart. Defaults to 3. 

=item 'max_val'

Sets the maximum y-value on the graph, overriding the normal auto-scaling.
Default is undef.

=item 'min_val'

Sets the minimum y-value on the graph, overriding the normal auto-scaling.
Default is undef.

Caution should be used when setting 'max_val' and 'min_val' to floating
point or non-round numbers. This is because the scale must start & end
on a tick, ticks must have round-number intervals, and include round
numbers.

Example: Suppose your data set has a range of 35-114 units. If you specify
them as the 'min_val' & 'max_val', the y_axis will be plotted with 80 ticks
every 1 unit.. If no 'min_val' & 'max_val', the system will auto scale the
range to 30-120 with 10 ticks every 10 units.

If the 'min_val' & 'max_val' are specified to excessive precision, they may
be overridden by the system, plotting a maximum 'max_y_ticks' ticks.

=item 'include_zero'

If 'true', forces the y-axis to include zero if it is not in the dataset
range. Default is 'false'.

In general, it is better to use this, than to set the 'min_val' if that
is all you want to achieve.

=item 'pt_size'

Sets the radius of the points (for Chart::Points, etc.) in pixels.  
Default is 18.

=item 'brush_size'

Sets the width of the lines (for Chart::Lines, etc.) in pixels.
Default is 6.

=item 'brushStyle'

Sets the shape of points for Chart::Points, Chart::LinesPoints.
The possibilities are 'FilledCircle', 'circle', 'donut',
'OpenCircle', 'fatPlus', 'triangle', 'upsidedownTriangle',
'square', 'hollowSquare', 'OpenRectangle', 'FilledDiamond',
'OpenDiamond', 'Star', 'OpenStar'.
Default: 'FilledCircle

=item 'skip_x_ticks'

Sets the number of x-ticks and x-tick labels to skip.  (ie.  
if 'skip_x_ticks' was set to 4, Chart would draw every 4th x-tick
and x-tick label).  Default is undef.

=item 'custom_x_ticks'

Used in points, lines, linespoints, errorbars and bars charts, this option
allows you to you to specify exactly which x-ticks and x-tick labels should
be drawn.  It should be assigned a reference to an array of desired
ticks.  Just remember that I'm counting from the 0th element of the
array.  (ie., if 'custom_x_ticks' is assigned [0,3,4], then the 0th,
3rd, and 4th x-ticks will be displayed)

=item 'f_x_tick'

Needs a reference to a function which uses the x-tick labels generated by
the '@data[0]' as the argument. The result of this function can reformat
the labels. For instance

   $obj -> set ('f_x_tick' => \&formatter );

An example for the function formatter: x labels are seconds since an event. 
The referenced function can transform this seconds to hour, minutes and seconds.
 
=item 'f_y_tick'

The same situation as for 'f_x_tick' but now used for y labels.
 
=item 'colors'

This option lets you control the colors the chart will use.  It takes
a reference to a hash.  The hash should contain keys mapped to references
to arrays of rgb values.  For instance,

    $obj->set('colors' => {'background' => [255,255,255]});

sets the background color to white (which is the default).  Valid keys for
this hash are

    'background' (background color for the png)
    'title' (color of the title)
    'text' (all the text in the chart)
    'x_label' (color of the x-axis label)
    'y_label' (color of the first y axis label)
    'y_label2' (color of the second y axis label)
    'grid_lines' (color of the grid lines)
    'x_grid_lines' (color of the x grid lines - for x axis ticks)
    'y_grid_lines' (color of the y grid lines - for to left y axis ticks)
    'y2_grid_lines' (color of the y2 grid lines - for right y axis ticks)
    'dataset0'..'dataset63' (the different datasets)
    'misc' (everything else, ie. ticks, box around the legend)

NB. For composite charts, there is a limit of 8 datasets per component.
The colors for 'dataset8' through 'dataset15' become the colors
for 'dataset0' through 'dataset7' for the second component chart.

=item 'title_font'

This option changes the font of the title. The key has to be a GD font. 
eg. GD::Font->Large

=item 'label_font'

This option changes the font of the labels. The key has to be a GD font. 

=item 'legend_font'

This option changes the font of the text in the legend. 
The key has to be a GD font. 

=item 'tick_label_font' 

This is the font for the tick labels. It also needs 
a GD font object as an argument.

=item 'grey_background'

Puts a nice soft grey background on the actual data plot when
set to 'true'.  Default is 'true'.

=item 'y_axes'

Tells Chart where to place the y-axis. Has no effect on Composite and Pie.
Valid values are 'left', 'right' and 'both'. Defaults to 'left'.

=item 'x_grid_lines'

Draws grid lines matching up to x ticks if set to 'true'. Default is false.

=item 'y_grid_lines'

Draws grid lines matching up to y ticks if set to 'true'. Default is false.

=item 'grid_lines'

Draws grid lines matching up to x and y ticks. 

=item 'spaced_bars'

Leaves space between the groups of bars at each data point when set
to 'true'.  This just makes it easier to read a bar chart.  Default
is 'true'.

=item 'imagemap'

Lets Chart know you're going to ask for information about the placement
of the data for use in creating an image map from the png.  This information
can be retrieved using the imagemap_dump() method.  NB. that the 
imagemap_dump() method cannot be called until after the Chart has been
generated (ie. using the png() or cgi_png() methods).

=item 'sort'

In a xy-plot, the data will be sorted ascending if set to 'true'.
(Should be set if the data isn't sorted, especially in Lines, Split 
and LinesPoints) In a Pareto Chart the data will be sorted descending. 
Defaults to 'false'.

=item 'composite_info'

This option is only used for composite charts.  It contains the
information about which types to use for the two component charts,
and which datasets belong to which component chart. It should be
a reference to an array of array references, containing information 
like the following

    $obj->set ('composite_info' => [ ['Bars', [1,2]],
                     ['Lines', [3,4] ] ]);

This example would set the two component charts to be a bar chart and
a line chart.  It would use the first two data sets for the bar 
chart (note that the numbering starts at 1, not zero like most of
the other numbered things in Chart), and the second two data sets
for the line chart.  The default is undef.

NB. Chart::Composite can only do two component charts.

=item 'min_val1', 'min_val2'

Only for composite charts, these options specify the minimum y-value
for the first and second components respectively.  Both default to
undef.

=item 'max_val1', 'max_val2'

Only for composite charts, these options specify the maximum y-value
for the first and second components respectively.  Both default to
undef.

=item 'ylabel2'

The label for the right y-axis (the second component chart) on a composite
chart.  Default is undef.

=item 'y_ticks1', 'y_ticks2'

The number of y ticks to use on the first and second y-axis on a composite
chart.  Please note that if you just set the 'y_ticks' option, both axes 
will use that number of y ticks.  Both default to undef.

=item 'f_y_ticks1', 'f_y_ticks2'

Only for composite charts, needs a reference to a function 
which has one argument and has to return
a string which labels the first resp. second y axis.
Both default to undef.

=item 'same_y_axes'

Forces both component charts in a composite chart to use the same maximum 
and minimum y-values if set to 'true'.  This helps to keep the composite 
charts from being too confusing.  Default is undef.

=item 'no_cache'

Adds Pragma: no-cache to the http header.  Be careful with this one, as
Netscape 4.5 is unfriendly with POST using this method.

=item 'legend_example_size'

Sets the length of the example line in the legend in pixels. Defaults to 20.

=item 'same_error'

This is a option only for ErrorBars. It tells chart that you want use the same 
error value of a data point if set to 'true'. Look at the documentation
to see how the module ErrorBars works. Default: 'false'.

=item 'skip_y_ticks'

Does the same for the y-axis at a HorizontalBars chart as 'skip_x_ticks'
does for other charts. Defaults to 1.

=item 'label_values' 

Tells a pie chart what labels to draw beside the pie. Valid values are
'percent', 'value', 'both' and 'none'. Defaults to 'percent'.

=item 'legend_label_values'

Tells a pie chart what labels to draw in the legend. Valid values are
'percent', 'value', 'both' and 'none'. Defaults to 'value'.

=item 'start'

Required value for a split chart. Sets the start value of the first interval.
If the x coordinate of the first data point is zero, you should 'set' to
zero. Default is 'undef'.

=item 'interval'

Also a required value for a split chart. It sets the interval of one line
to plot. Defaults 'undef'.

=item 'interval_ticks'

Sets the number of ticks for the x-axis of a Split chart. Defaults to 5.

=item 'scale'

Every y-value of a split chart will be multiplied with that value, but
the scale won't change. Which means that split allows one to overdraw certain 
rows! Only useful if you want to give prominence to the maximal amplitudes
of the data. Defaults to 1. 

=item 'point'

Indicates to draw points in a direction chart. 'true' or 'false' possible. 
Defaults to 'true'.

=item 'line'

If you turn this option to 'true', then direction will connect the points 
with lines. Defaults to 'false'.

=item 'arrow'

This is also an option for the direction module. If set to 'true', chart 
will draw a arrow from the center to the point. Defaults to 'false'.

=item 'angle_interval'

This option tells direction, how many angle lines should be drawn. The
default value is 30, which means that a line will be drawn every
30 degrees. Valid Values are: 0, 5, 10, 15, 20, 30, 45 and 60. If you
choose 0, direction will draw no line.

=item 'min_circles'

Sets the minimum number of circles when generating a scale for direction.
Default is 4, minimum is 2.

=item 'max_circles'

Sets the maximum number of circles when generating a scale for direction.
Default is 100. This limit is used to avoid plotting  an unreasonable 
large number of ticks if non-round values are used for the min_val and
max_val.

=item 'pairs'

Only used for direction how to handle more datasets. 
               If 'pairs' is set to 'true', 
               Chart uses the first dataset as a set of degrees and 
               the second dataset as a set of values. 
               Then, the third set is a set of degrees and the fourth a set of values \dots. \\
               If 'pairs' is set to 'false', 
               Chart uses the first dataset as a set of angels 
               and all following datasets as sets of values.
               Defaults to 'false'.

Sets the maximum number of circles when generating a scale for direction.
Default is 100. This limit is used to avoid plotting  an unreasonable 
large number of ticks if non-round values are used for the min_val and
max_val.

=back

=head2 GIFgraph.pm-style API

=over 4

=item Sending the image to a file

Invoking the png method causes the graph to be plotted and saved to 
a file.  It takes the name of the output file and a reference to the
data as arguments.  For example,

  $obj->png ("foo.png", \@data);

would plot the data in @data, and the save the image to foo.png.
Of course, this then beggars the question "What should @data look
like?".  Well, just like GIFgraph, @data should contain references
to arrays of data, with the first array reference pointing to an
array of x-tick labels.  For example,

  @data = ( [ 'foo', 'bar', 'junk' ],
        [ 30.2,  23.5,  92.1   ] );

would set up a graph with one dataset, and three data points in that
set.  In general, the @data array should look something like

  @data = ( \@x_tick_labels, \@dataset1, ... , \@dataset_n );

And no worries, I make my own internal copy of the data, so that it doesn't
mess with yours.

=item CGI and Chart

Okay, so you're probably thinking, "Do I always have to save these images
to disk?  What if I want to use Chart to create dynamic images for my
web site?"  Well, here's the answer to that.

  $obj->cgi_png ( \@data );

The cgi_png method will print the chart, along with the appropriate http
header, to stdout, allowing you to call chart-generating scripts directly
from your html pages (ie. with a <lt>img src=image.pl<gt> HTML tag).  The @data
array should be set up the same way as for the normal png method.

=back

=head2 Graph.pm-style API

You might ask, "But what if I just want to add a few points to the graph, 
and then display it, without all those references to references?".  Well,
friend, the solution is simple.  Borrowing the add_pt idea from Matt
Kruse's Graph module, you simply make a few calls to the add_pt method,
like so:

    $obj->add_pt ('foo', 30, 25);
    $obj->add_pt ('bar', 16, 32);

Or, if you want to be able to add entire datasets, simply use the add_dataset
method:

    $obj->add_dataset ('foo', 'bar');
    $obj->add_dataset (30, 16);
    $obj->add_dataset (25, 32);

These methods check to make sure that the points and datasets you are
adding are the same size as the ones already there.  So, if you have
two datasets currently stored, and try to add a data point with three
different values, it will carp (per the Carp module) an error message.
Similarly, if you try to add a dataset with 4 data points,
and all the other datasets have 3 data points, it will carp an error
message.

Don't forget, when using this API, that I treat the first dataset as
a series of x-tick labels.  So, in the above examples, the graph would
have two x-ticks, labeled 'foo' and 'bar', each with two data points.
Pie and ErrorBars handle it different, look at the documentation
to see how it works.

=over 4

=item Adding a datafile

You can also add a complete datafile to a chart object. Just use the
add_datafile() method.

    $obj->add_datafile('file', 'set' or 'pt');

file can be the name of the data file or a filehandle. 
'set' or 'pt is the type of the datafile. 
If the parameter is 'set' then each line in the data file
has to be a complete data set. The value of the set has to be 
separated by white spaces. For example the file looks like this:

    'foo'  'bar'
    30     16
    25     32

If the parameter is 'pt', one line has to include all values
of one data point separated by white spaces. For example:

    'foo'  30  25
    'bar'  16  32


=item Clearing the data

A simple call to the clear_data method empties any values that may
have been entered.

    $obj->clear_data ();

=item Getting a copy of the data

If you want a copy of the data that has been added so far, make a call
to the get_data method like so:

        $dataref = $obj->get_data;

It returns (you guessed it!) a reference to an array of references to
datasets.  So the x-tick labels would be stored as

        @x_labels = @{$dataref->[0]};

=item Sending the image to a file

If you just want to print this chart to a file, all you have to do
is pass the name of the file to the png() method.

    $obj->png ("foo.png");

=item Sending the image to a filehandle

If you want to do something else with the image, you can also pass
a filehandle (either a typeglob or a FileHandle object) to png, and
it will print directly to that.

    $obj->png ($filehandle);
    $obj->png (FILEHANDLE);


=item CGI and Chart

Okay, so you're probably thinking (again), "Do I always have to save these 
images to disk?  What if I want to use Chart to create dynamic images for
my web site?"  Well, here's the answer to that.

    $obj->cgi_png ();

The cgi_png method will print the chart, along with the appropriate http
header, to stdout, allowing you to call chart-generating scripts directly
from your html pages (ie. with a <lt>img src=image.pl<gt> HTML tag). 


=item Produce a png image as a scalar

Like scalar_jpeg() the image is produced as a scalar
so that the programmer-user can do whatever the heck
s/he wants to with it:

    $obj-scalar_png($dataref)



=item Produce a jpeg image as a scalar

Like scalar_png() the image is produced as a scalar
so that the programmer-user can do whatever the heck
s/he wants to with it:

    $obj-scalar_jpeg($dataref)
    
=back

=head2 Imagemap Support

Chart can also return the pixel positioning information so that you can
create image maps from the pngs Chart generates.  Simply set the 'imagemap'
option to 'true' before you generate the png, then call the imagemap_dump()
method afterwards to retrieve the information.  You will be returned a
data structure almost identical to the @data array described above to pass
the data into Chart.

    $imagemap_data = $obj->imagemap_dump ();

Instead of single data values, you will be passed references to arrays
of pixel information.  For Bars, HorizontalBars and StackedBars charts, 
the arrays will contain two x-y pairs (specifying the upper left and 
lower right corner of the bar), like so

    ( $x1, $y1, $x2, $y2 ) = @{ $imagemap_data->[$dataset][$datapoint] };

For Lines, Points, ErrorBars, Split and LinesPoints, the arrays will contain 
a single x-y pair (specifying the center of the point), like so

    ( $x, $y ) = @{ $imagemap_data->[$dataset][$datapoint] };

A few caveats apply here.  First of all, GD treats the upper-left corner
of the png as the (0,0) point, so positive y values are measured from the
top of the png, not the bottom.  Second, these values will most likely
contain long decimal values.  GD, of course, has to truncate these to 
single pixel values.  Since I don't know how GD does it, I can't truncate
it the same way he does.  In a worst-case scenario, this will result in
an error of one pixel on your imagemap.  If this is really an issue, your
only option is to either experiment with it, or to contact Lincoln Stein
and ask him.  Third, please remember that the 0th dataset will be empty,
since that's the place in the @data array for the data point labels.


=head1 PLAN

This module is under currently under a complete rewrite. Version will 
bump to 3, without breaking any compatibility. The old API stays as it is,
the new will be through a new central API.

=head1 TO DO

=over 4

=item *

Include True Type Fonts

=item *

Violine and Box plots

=item *

Add some 3-D graphs.

=back

For more please check the TODO file.

=head1 BUGS

Probably quite a few, since it's been completely rewritten.  As usual,
please mail me with any bugs, patches, suggestions, comments, flames,
death threats, etc.

=head1 AUTHOR

David Bonner (dbonner@cs.bu.edu)

=head1 MAINTAINER

=over 4

=item *

Chart Group (Chart@fs.wettzell.de)

=item *

Herbert Breunung (lichtkind@cpan.org)

=back

=head1 CONTRIBUTORS

=over 4


=item *

Gregor Herrmann (gregoa@debian.org)

=item *

Chris Dolan (chris+rt@chrisdolan.net)

=item *

(jarmzet@yahoo.com)

=item *

Ricardo Signes (rjbs@cpan.org)

=item *

Petr Pisar (ppisar@redhat.com)



=back


=head1 COPYRIGHT

Copyright(c) 1997-1998 by David Bonner, 1999 by Peter Clark,
2001 by the Chart group at BKG-Wettzell.
All rights reserved.  This program is free software; you can
redistribute it and/or modify it under the same terms as Perl 
itself.

=cut
