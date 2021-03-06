#!/usr/bin/perl -n

BEGIN {
sub usage {
    return <<EndOfUsage;
$0: generate outline from TeX/LaTeX files
Usage: $0 [-n] a.tex b.tex...    - generates outline from filenames
    $0 [-n] -f masterfile.tex - searches masterfile.tex for \\input{}'s
              or \\include{}'s  (doesn't respect \\includeonly)
       -n means don't include any body text in outline
EndOfUsage
			     }
    while ($ARGV[0] =~ /^-/) {
        $_ = shift @ARGV;
        $suppress_body = 1, next if /^-n/;
        $find_inputs = 1, next if /^-f/;
        die &usage if /^-h/;
    }
    if ($find_inputs) {
        # scan a single file for \input lines, then add those filenames to
        # @ARGV. 
        open(FILE, shift @ARGV) or die $!;
        @lines = grep( /^\s*[^%]/, (<FILE>));
        grep(chomp, @lines);
        push(@ARGV, grep( s/\\(input|include){([^\}]+(.tex)?)}/\2.tex/g, 
			  @lines));
        close FILE;
    }
sub emit_bodytext {
    if ($bodytext) {
            # heading line: spit out body in a multiline paragraph
	select(STDOUT); $save = $~; $~ = "BODYTEXT";
            #print $bodytext;
	write;
	$~ = $save;
    }
}
}
format BODYTEXT =
              | ^<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<~
              $bodytext
              | ^<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<~
              $bodytext
              | ^<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<~
              $bodytext
              | ^<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<~
              $bodytext
              | ^<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<~
              $bodytext
              | ^<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<~
              $bodytext
              | ^<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<...~
              $bodytext
.

    ;
%headings = ('part'          => '',
             'chapter'       => '',
             'section'       => '     ',
             'subsection'    => '        ',
             'subsubsection' => '           ',
             'paragraph'     => '          .',
             );
$headings = join('|', (keys(%headings)));
if  ( /^\s*\\($headings){([^\}\n]*)(}?)/m ) {
    &emit_bodytext;
    print ($headings{$1},$2,($3? "": "..."), "\n");
    $bodytext = '';
} elsif (! $suppress_body) {
    # it's a body line
    chomp;
    s/\s+/ /; s/$/ /;
    $bodytext .= $_ if /\S/;
}

END {
    &emit_bodytext unless $suppress_body;
}


