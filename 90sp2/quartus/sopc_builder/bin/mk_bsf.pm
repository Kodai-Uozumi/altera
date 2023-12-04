#Copyright (C) 1991-2003 Altera Corporation
#Any megafunction design, and related net list (encrypted or decrypted),
#support information, device programming or simulation file, and any other
#associated documentation or information provided by Altera or a partner
#under Altera's Megafunction Partnership Program may be used only to
#program PLD devices (but not masked PLD devices) from Altera.  Any other
#use of such megafunction design, net list, support information, device
#programming or simulation file, or any other related documentation or
#information is prohibited for any other purpose, including, but not
#limited to modification, reverse engineering, de-compiling, or use with
#any other silicon devices, unless such use is explicitly licensed under
#a separate agreement with Altera or a megafunction partner.  Title to
#the intellectual property, including patents, copyrights, trademarks,
#trade secrets, or maskworks, embodied in any such megafunction design,
#net list, support information, device programming or simulation file, or
#any other related documentation or information provided by Altera or a
#megafunction partner, remains with Altera, the megafunction partner, or
#their respective licensors.  No other licenses, including any licenses
#needed under any third party's intellectual property, are provided herein.
#Copying or modifying any file, or portion thereof, to which this notice
#is attached violates this copyright.


package mk_bsf;
require Exporter;
@ISA = Exporter;
@EXPORT = qw(
             Generate_BSF
             );

# Constants for computing dimensions of things.
# distance between inner and outer rectangles, x and y
my $outerEdgeMargin = 16;

# Margin between top or bottom signal and inner rectangle.
my $innerEdgeMargin = 16;

# x distance between longest left and longest right signal.
my $defaultFontSize = 8;
my $titleFontSize = 10;
my $quantum = $defaultFontSize;
my $midMargin = 4 * $quantum;

# Vertical space occupied by a signal.
my $signalVerticalSize = 16;
  
my $defaultFont = "Arial";

# Inter-module separator.  When the symbol is rendered, the magic
# string "[]" (unlikely to be a signal name) will become a dashed line.
my $secretDashedLineMarker = "[]";

my $globalPrintString;

sub myErrorPrint
{
  # print STDERR @_;
  warn @_;
}

sub myPrint
{
  # print @_;
  $globalPrintString .= join '', @_;
}

sub charWidth
{
  return charDim("width", @_);
}

sub charDimArial
{
  my ($axis, $char, $size) = @_;
  
  if ($size != 8 && $size != 10)
  {
    myErrorPrint "Unsupported font size $size, using $defaultFontSize.\n";
    $size = $defaultFontSize;
  }
  
  # Size data was taken from Quartus, at zoom level 144%.
  my %size8ToDim = (
    'a' => 248/40.0,
    'b' => 248/40.0,
    'c' => 224/40.0,
    'd' => 248/40.0,
    'e' => 248/40.0,
    'f' => 112/40.0,
    'g' => 248/40.0,
    'h' => 224/40.0,
    'i' => 112/40.0,
    'j' => 84/40.0,
    'k' => 224/40.0,
    'l' => 84/40.0,
    'm' => 360/40.0,
    'n' => 224/40.0,
    'o' => 248/40.0,
    'p' => 248/40.0,
    'q' => 248/40.0,
    'r' => 136/40.0,
    's' => 224/40.0,
    't' => 112/40.0,
    'u' => 224/40.0,
    'v' => 184/40.0,
    'w' => 304/40.0,
    'x' => 192/40.0,
    'y' => 192/40.0,
    'z' => 192/40.0,
    'A' => 304/40.0,
    'B' => 304/40.0,
    'C' => 336/40.0,
    'D' => 336/40.0,
    'E' => 304/40.0,
    'F' => 276/40.0,
    'G' => 336/40.0,
    'H' => 304/40.0,
    'I' => 84/40.0,
    'J' => 224/40.0,
    'K' => 304/40.0,
    'L' => 248/40.0,
    'M' => 360/40.0,
    'N' => 304/40.0,
    'O' => 336/40.0,
    'P' => 304/40.0,
    'Q' => 336/40.0,
    'R' => 304/40.0,
    'S' => 304/40.0,
    'T' => 248/40.0,
    'U' => 304/40.0,
    'V' => 304/40.0,
    'W' => 416/40.0,
    'X' => 304/40.0,
    'Y' => 248/40.0,
    'Z' => 248/40.0,
    '0' => 248/40.0,
    '1' => 248/40.0,
    '2' => 248/40.0,
    '3' => 248/40.0,
    '4' => 248/40.0,
    '5' => 248/40.0,
    '6' => 248/40.0,
    '7' => 248/40.0,
    '8' => 248/40.0,
    '9' => 248/40.0,
    '_' => 248/40.0,
    ' ' => 248/40.0,
    '[' => 112/40.0,
    ']' => 112/40.0,
    '.' => 112/40.0,
  );
  
  return ($size / 8) * $size8ToDim{$char} if (exists($size8ToDim{$char}));

  myErrorPrint "Unsupported character!  Font: Arial; char: '$char'; size: $size\n";
  return 248/40.0;
}

sub charDim
{
  my ($axis, $char, $font, $size) = @_;
  my %sizeToDimCourierNew = (
      8 => 6.7,
      9 => 7.06,
      10 => 8.11,
      11 => 9.09,
      12 => 10.2,
      14 => 11.1,
      16 => 13.3,
      18 => 14.3,
  );
  
  # For now, I assume Courier New.
  
  if ($font eq "Arial")
  {
    return charDimArial($axis, $char, $size);
  }
  
  if ($font ne $defaultFont)
  {
    myErrorPrint "Unsupported font '$font', using $defaultFont.\n";
    $font = $defaultFont;
  }
  
  if (!exists($sizeToDimCourierNew{$size}))
  {
    myErrorPrint "Unsupported font size $size, using $defaultFontSize.\n";
    $size = $defaultFontSize;
  }
  
  if ($axis eq "width")
  {
    return $sizeToDimCourierNew{$size};
  }
  
  if ($axis eq "height")
  {
    return $sizeToDimCourierNew{$size};
  }
  
  myErrorPrint "Unsupported axis '$axis'\n";
  
  return $sizeToDimCourierNew{$defaultFontSize}
}

sub stringWidth
{
  my ($string, $font, $size) = @_;
  my $i;
  my $len = 0;
  
  for $i (0 .. length($string) - 1)
  {
    $len += charWidth(substr($string, $i, 1), $font, $size);
  }
  
  return $len;
}

sub getMaxSignalNameWidth
{
  my @signals = @_;
  my $signal;
  my $max = -1;
  
  foreach $signal (@signals)
  {
    if ($signal =~ /
      (\S+)           # signal name, perhaps with a bus size element.
      \s*\|\s*        # pipe, maybe with whitespace
      \d+             # Bus width
      \s*\|\s*        # pipe, maybe with whitespace
      \w+             # signal type
      /sx)
    {
      my $signalName = $1;
      my $len = stringWidth($signalName, $defaultFont, $defaultFontSize);
      if ($max < $len)
      {
        $max = $len;
      }
    }
  }

  return $max;
}

sub max
{
  my ($a, $b) = @_;
  
  return $a if ($a > $b);
  return $b;
}

sub roundUp
{
  my ($num, $quantum) = @_;
  
  my $diff = $num / $quantum - int($num / $quantum);
  
  if (0 == $diff)
  {
    return $num;
  }
  
  $num = (int($num / $quantum) + 1) * $quantum;
  return $num;
}

sub translate
{
  my ($tX, $tY, $xMin, $yMin, $xMax, $yMax) = @_;
  
  return ($xMin + $tX, $yMin + $tY, $xMax + $tX, $yMax + $tY);
}

sub computeDimensions
{
  my ($title, $instanceName, $leftSignalRef, $rightSignalRef) = @_;
  
  my @leftSignals = @$leftSignalRef;
  my @rightSignals = @$rightSignalRef;
  
  # 
  # Collect some numbers.
  # 

  # A symbol is some rectangles, lines and strings.  Spatial values of and between
  # the rectangles and lines are determined by the number and length of the strings.
  # Strings:                 associated value               comment
  # title                    titleLen                       title, upper left
  # instanceName             instanceNameLen                'inst', lower left
  # leftSignals[]            leftMaxLen                     all input signals
  # rightSignals[]           rightMaxLen                    all output/inout signals
  
  # I have two concentric rectangles.
  # The width depends on the lengths of the signal names; the height depends on
  # the number of signals.
  
  # The inner rectangle's width is determined by the largest left and right
  # signal names.  But, if the title or the instance name are absurdly large,
  # they can override.
  my $signal;
  my $leftMaxLen = getMaxSignalNameWidth(@leftSignals);
  my $rightMaxLen = getMaxSignalNameWidth(@rightSignals);

  my $innerXMax = $leftMaxLen + $rightMaxLen + $midMargin;
  $innerXMax = max($innerXMax, $quantum + stringWidth($title, $defaultFont, 10));
  $innerXMax = max($innerXMax, $quantum + stringWidth($instanceName, $defaultFont, 10));
  
  # The inner rectangle's height depends on the number of signals.
  my $innerYMax = (0 + @leftSignals) * $signalVerticalSize + $innerEdgeMargin;
  
  $innerXMax = roundUp($innerXMax, $quantum);
  $innerYMax = roundUp($innerYMax, $quantum);

  my @innerRect = (0, 0, $innerXMax, $innerYMax);
  @innerRect = translate($innerEdgeMargin, $innerEdgeMargin, @innerRect);
  
  my $outerXMax = $innerXMax + 2 * $outerEdgeMargin;
  my $outerYMax = $innerYMax + 2 * $outerEdgeMargin;
  
  return (@innerRect, 0, 0, $outerXMax, $outerYMax);
}

sub rect2String
{
  my @rect = @_;
  
  return sprintf("%d %d %d %d", @rect);
}


sub emitPort
{
  # A port spec in a bsf file looks like this:
  # (port                                                               - object declaration
  # (pt 0 32)                                                           - the port's attachment point
  # (input)                                                             - the port type
  # (text "clk" (rect 0 0 12 13)(font "Courier New" (font_size 8)))     - the text for the port (this one's invisible)
  # (text "clk" (rect 24 25 36 36)(font "Courier New" (font_size 8)))   - the text for the port again, but this one shows up
  # (line (pt 0 32)(pt 16 32)(line_width 1))                            - a line between inner and outer rectangles
  # )

  my ($x, $y, $side, $signalSpec) = @_;
  
  my ($signalName, $busWidth, $signalType);
  my ($pt1String, $pt2String);
  
  if ($side eq "left")
  {
    $pt1String = "$x $y";
    $pt2String = sprintf("%d %d", $x + $outerEdgeMargin, $y);
  }
  else
  {
    $pt1String = sprintf("%d %d", $x - $outerEdgeMargin, $y);
    $pt2String = "$x $y";
  }
  
  if ($signalSpec and $signalSpec ne $secretDashedLineMarker)
  {
    $signalSpec =~ /
      (\S+)                 # signal name, perhaps with a bus size element.
      \s*\|\s*              # pipe, maybe with whitespace
      (\d+)                 # bus width
      \s*\|\s*              # pipe, maybe with whitespace
      (input|inout|output)  # signal type
      $/sx;
      
    $signalName = $1;
    $busWidth = $2;
    $signalType = $3;
    
    # BSF files call 'inout' signals 'bidir'.
    if ($signalType eq "inout")
    {
      $signalType = "bidir";
    }
    
    my $lineWidth = ($busWidth == 1) ? 1 : 3;
    
    my @rect1 = (0, 0, stringWidth($signalName, $defaultFont, $defaultFontSize), $signalVerticalSize);
    my $rect1String = rect2String(@rect1);
    
    my @rect2;
    if ($side eq "left")
    {
      @rect2 = translate($x + $outerEdgeMargin + 0.25 * $innerEdgeMargin, $y - 7, @rect1);
    }
    else
    {
      @rect2 =
        translate($x - ($outerEdgeMargin + 0.65 * $innerEdgeMargin) - stringWidth($signalName, $defaultFont, $defaultFontSize),
        $y - 7, @rect1);
    }
    my $rect2String = rect2String(@rect2);

    # I've added a single space after signal names, to try to discourage
    # Quartus from truncating the last bits.  I hope this doesn't break anything.
    myPrint <<EOT;
(port
(pt $x $y)
($signalType)
(text "$signalName " (rect $rect1String)(font "$defaultFont" (font_size $defaultFontSize)))
(text "$signalName " (rect $rect2String)(font "$defaultFont" (font_size $defaultFontSize)))
(line (pt $pt1String)(pt $pt2String)(line_width $lineWidth))
)
EOT
  }
}

sub drawBSF
{
  my ($title, $instanceName,
    $leftSignalRef, $rightSignalRef,
    $innerXMin, $innerYMin, $innerXMax, $innerYMax,
    $outerXMin, $outerYMin, $outerXMax, $outerYMax) = @_;
  
  my @leftSignals = @$leftSignalRef;
  my @rightSignals = @$rightSignalRef;
  
  my @innerRect = ($innerXMin, $innerYMin, $innerXMax, $innerYMax);
  my @outerRect = ($outerXMin, $outerYMin, $outerXMax, $outerYMax);

  my @titleRect = (0, 0, $quantum + stringWidth($title, $defaultFont, $titleFontSize),
    $signalVerticalSize);

  @titleRect = translate($quantum / 2, 0, @titleRect);  

  my $titleRectString = rect2String(@titleRect);
  
  my @instRect = (0, 0, $quantum + stringWidth($instanceName, $defaultFont, $defaultFontSize),
    $signalVerticalSize);

  @instRect = translate($quantum / 2, $outerYMax - 2 * $quantum, @instRect);

  my $instanceRectString = rect2String(@instRect);
  
  my $innerRectString = rect2String(@innerRect);
  my $outerRectString = rect2String(@outerRect);

  myPrint <<EOT;
(header "symbol" (version "1.1"))
(symbol
(rect $outerRectString)
(text "$title" (rect $titleRectString)(font "$defaultFont" (font_size $titleFontSize)))
(text "$instanceName" (rect $instanceRectString)(font "$defaultFont"))
EOT

  # Emit all the ports.  
  my $signalSpec;
  my $i;
  my $y = $outerEdgeMargin + $innerEdgeMargin;
  
  my $x = 0;
  my @dashedLineYs;
  
  foreach $signalSpec (@leftSignals)
  {
    emitPort($x, $y, "left", $signalSpec);
    
    # Add this y value to the list of dashed lines to be drawn later.
    if ($signalSpec eq $secretDashedLineMarker)
    {
      push @dashedLineYs, $y;
    }

    $y += $signalVerticalSize;
  }
  
  $y = $outerEdgeMargin + $innerEdgeMargin;
  $x = $outerRect[2];
  foreach $signalSpec (@rightSignals)
  {
    emitPort($x, $y, "right", $signalSpec);
    $y += $signalVerticalSize;
  }

  myPrint <<EOT;
(drawing
EOT

  foreach $y (@dashedLineYs)
  {
    my $endX = $innerRect[2] - 1;
    myPrint qq{(line (pt $innerRect[0] $y)(pt $endX $y)(color 0 0 0)(dotted)(line_width 1))\n};
  }

myPrint <<EOT;
(rectangle (rect $innerRectString)(line_width 1)))
)
EOT
}

sub Generate_BSF
{
  my $title = shift;
  my $instanceName = "inst";

  # Clear the global output string.
  $globalPrintString = "";

  # Split signals into left and right, and sort within modules.
  my (@inputStrings) = @_;
  my $n = scalar (@inputStrings);
  my @listOfModules;
  my $moduleSignalList;
  my @signals;

  for $moduleSignalList (@inputStrings)
  {
    # Eliminate loathesome white space.
    $moduleSignalList =~ s/\s+//g;
    next unless $moduleSignalList;
    
    @signals = split /,/, $moduleSignalList;
    while ($signals[$#signals] !~ /\S/)
    {
      pop(@signals);
    }
  
    push @listOfModules, [ @signals ];
  }
  
  # Separate signals into inputs, outputs/inouts.
  # txd_from_the_uarto | 1 | output,rxd_to_the_uarto | 1 | input
  #
  # Each string lists all the ports of a Nios submodule, comma-delimited.
  # 
  # Separate the ports into (input) and (output, inout) and return as a list of lists.
  # Use delimiters to make things line up nice.
  my @leftSignals;
  my @rightSignals;
  
  # clk | 1 | input
  # txd_from_the_uarto | 1 | output
  # shared_data_bus_1_data | 16 | inout

  my $moduleRef;
  my $i;
  for $i (0 .. $#listOfModules)
  {
    my $signalSpec;
    my @tmpLeft = ();
    my @tmpRight = ();
    my $moduleSignalList = $listOfModules[$i];
    foreach $signalSpec (@$moduleSignalList)
    {
      if ($signalSpec =~ /(\S+)\s*\|\s*(\d+)\s*\|\s*(\S+)/s)
      {
        my $signalName = $1;
        if ($signalName =~ /[^\w\[\]\.]/)
        {
          warn("unexpected character(s) in signal name '$signalName'");
          next;
        }
        
        my $busWidth = $2;
        
        if ($busWidth =~ /[^\d]/)
        {
          warn("unexpected charcter(s) in bus width '$busWidth'");
          next;
        }
        
        if ($busWidth < 1)
        {
          warn("bus width '$busWidth' is bogus.");
          next;
        }
        
        my $signalType = $3;
        
        # Fix up bus signals with their size ([n-1 .. 0]) here.
        if ($busWidth > 1)
        {
          if ($signalName !~ /\S+\[(\d+)\.\.0\]/)
          {
            $signalName .= sprintf("[%d..0]", $busWidth - 1);
          }
        }
        
        if ($signalName =~ /\S+\[(\d+)\.\.0\]/)
        {
          if ($1 != $busWidth - 1)
          {
            warn("signal $signalName doesn't match its own buswidth ($busWidth)");
          }
        }
        
        my $newSignalSpec = "$signalName|$busWidth|$signalType";
        if ($signalType eq "input")
        {
          push @tmpLeft, $newSignalSpec;
        }
        elsif ($signalType eq "inout" or $signalType eq "output")
        {
          push @tmpRight, $newSignalSpec;
        }
        else
        {
          warn("Unexpected signal type '$signalType' in signal spec '$signalSpec'");
        }
      }
    }

    # Sort signals within a module.  This provides a consistent, though
    # not necessarily optimal ordering.
    @tmpLeft = sort(@tmpLeft);
    @tmpRight = sort(@tmpRight);
    
    # Pad out the shorter of the two lists...
    while ((0 + @tmpLeft) > (0 + @tmpRight))
    {
      push (@tmpRight, "");
    }
    
    while ((0 + @tmpLeft) < (0 + @tmpRight))
    {
      push (@tmpLeft, "");
    }
    
    # If this wasn't the last module, put an inter-module spacer.
    if ($i < $#listOfModules)
    {
      push (@tmpRight, $secretDashedLineMarker);
      push (@tmpLeft, $secretDashedLineMarker);
    }

    push @leftSignals, @tmpLeft;
    push @rightSignals, @tmpRight;
  }

  # We should have ended up with left and right signal lists of the same size.
  if (@leftSignals != @rightSignals)
  {
    myErrorPrint "Say, left and right don't have the same size.\n";
  }
  
  # Do some arithmetic.
  my ($innerXMin, $innerYMin, $innerXMax, $innerYMax, $outerXMin, $outerYMin, $outerXMax, $outerYMax) =
    computeDimensions($title, $instanceName, \@leftSignals, \@rightSignals);  
  
  # Spew the rendering commands.
  drawBSF($title, $instanceName,
    \@leftSignals, \@rightSignals,
    $innerXMin, $innerYMin, $innerXMax, $innerYMax,
    $outerXMin, $outerYMin, $outerXMax, $outerYMax);
  
  # Done!
  return $globalPrintString;
}

qq{
1     When I am grown to man's estate
2     I shall be very proud and great,
3     And tell the other girls and boys
4     Not to meddle with my toys. 
};
