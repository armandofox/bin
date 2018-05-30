#!/usr/bin/perl

use IO::File;
use Cwd 'abs_path';

$TMPDIR = "/tmp/watermark-$$";
$SIG{'INT' } = 'abort';
$SIG{'QUIT'} = 'abort';
$SIG{'HUP' } = 'abort';
$SIG{'TRAP'} = 'abort';
$SIG{'ABRT'} = 'abort';
$SIG{'STOP'} = 'abort';

sub usage {
    die <<EOhelp;
Usage: $0 <file of email addresses> <inputfile.pdf> <outputdir> <outputname>
File should contain one email address per line, which will be used as watermark.
Output files will be placed in <outputdir>, which must exist.
Output filenames are email1@berkeley.edu.pdf, email2@berkeley.edu.pdf, etc.
If <outputname> is given, it will be prepended to each filename.
EOhelp
}

sub get_emails_from {
    my $emailfile = shift;
    open EMAILS, $emailfile or &abort("Can't open $emailfile: $!");
    my @emails = (<EMAILS>);
    close EMAILS;
    return @emails;
}

sub get_template {
    return '
\documentclass{article}\pagestyle{empty}\usepackage{draftwatermark}
\begin{document}\SetWatermarkScale{2}\SetWatermarkText{\shortstack{EMAIL \\\\ Do Not Distribute}}
~
\end{document}';
}

sub create_tempfile_using {
    my($template,$watermark) = @_;
    my $filename = "$TMPDIR/watermark.tex";
    open FH, ">$filename" or die "Can't create $filename: $!";
    my $new = $template;
    $new =~ s/EMAIL/$watermark/;
    print FH $new;
    close FH;
    return $filename;
}

sub cleanup {
    system "/bin/rm -rf $TMPDIR";
}
sub abort {
    my $msg = shift;
    &cleanup;
    die $msg;
}
sub main {
    &usage unless $#ARGV >= 2;
    my ($emailfile, $inputfile, $outputdir, $outputname) = @ARGV;
    $emailfile = abs_path($emailfile);
    $inputfile = abs_path($inputfile);
    $outputdir = abs_path($outputdir);
    &abort("Directory $outputdir doesn't exist or not writable: $!") unless -d $outputdir && -w $outputdir;
    &abort("Can't create tmp dir $TMPDIR: $!") unless mkdir $TMPDIR;
    &abort("Can't switch to temp directory $TMPDIR: $!") unless chdir $TMPDIR;
    my @emails = &get_emails_from($emailfile);
    my $template = &get_template;
    my $cmd;
    printf STDERR "Creating %d files in $outputdir",$#emails+1;
    foreach $email (@emails) {
        chomp $email;
        # sanitize email address so latex doesn't complain
        $email =~ s/([\#\$\%\&\~\_\^\\\{\}])/\\$1/g;
        my $file = &create_tempfile_using($template, $email);
        system "pdflatex $file >/dev/null 2>&1";
        my $outname = "$outputdir/$outputname$email.pdf";
        $cmd = "pdftk $inputfile stamp watermark.pdf output $outname > /dev/null 2>&1";
        system $cmd;
        printf STDERR ".";
    }
    printf STDERR "\n";
    &cleanup;
}
&main;
