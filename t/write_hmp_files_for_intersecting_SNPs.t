#!/bin/env perl6

use Test;
use File::Temp;
use Compress::Zlib;

my @test-files = (
    my-temp-hmp-filename-for( input1() ),
    my-temp-hmp-filename-for( input2() ),
    my-gz-filename-for( input1() ),
    my-gz-filename-for( input2() ),
);

for @test-files -> $input1, $input2 {
    my $output1           = "$input1.intersecting.hmp.txt";
    my $output2           = "$input2.intersecting.hmp.txt";

    shell("./write_hmp_files_for_intersecting_SNPs $input1 $input2");   

    my $result1 = slurp $output1;
    my $result2 = slurp $output2;

    is $result1, expected1(), "Correct intersection for input1";
    is $result2, expected2(), "Correct intersection for input2";
    
    unlink $input1, $input2, $output1, $output2;
}

done-testing;

sub my-temp-hmp-filename-for ( $content ) {
    my $filename = my-temp-hmp-filename;

    spurt $filename, $content;

    return $filename;
}

sub my-gz-filename-for ( $content ) {
    my $filename = my-temp-hmp-filename() ~ '.gz';

    gzspurt $filename, $content;

    return $filename;
}

sub my-temp-hmp-filename {
    my ($filename, $fh) = tempfile;
    my $basename = $filename.IO.basename;
    $fh.close;
    unlink $filename;
    return "$basename.hmp.txt";
}

sub my-temp-filename {
    my ($filename, $fh) = tempfile;
    my $basename = $filename.IO.basename;
    $fh.close;
    unlink $filename;
    return $basename;
}

sub input1 {
    return q:to/END/;
        rs#	alleles	chrom	pos	strand	assembly#	center	protLSID	assayLSID	panelLSID	QCcode	TaxaD	TaxaE	TaxaF
        S1_30	blah	1	30	blah	blah	blah	blah	blah	blah	blah	C	C	C
        S1_110	blah	1	110	blah	blah	blah	blah	blah	blah	blah	G	T	T
        S1_120	blah	1	120	blah	blah	blah	blah	blah	blah	blah	-	T	T
        S1_130	blah	1	130	blah	blah	blah	blah	blah	blah	blah	G	T	N
        S1_140	blah	1	130	blah	blah	blah	blah	blah	blah	blah	A	A	N
        END
}

sub input2 {
    return q:to/END/;
        rs#	alleles	chrom	pos	strand	assembly#	center	protLSID	assayLSID	panelLSID	QCcode	TaxaD	TaxaE	TaxaF
        S1_130	blah	1	130	blah	blah	blah	blah	blah	blah	blah	G	T	N
        S1_30	blah	1	30	blah	blah	blah	blah	blah	blah	blah	C	C	C
        S1_110	blah	1	110	blah	blah	blah	blah	blah	blah	blah	G	T	T
        S1_150	blah	1	150	blah	blah	blah	blah	blah	blah	blah	A	A	A
        END
}

sub expected1 {
    return q:to/END/;
        rs#	alleles	chrom	pos	strand	assembly#	center	protLSID	assayLSID	panelLSID	QCcode	TaxaD	TaxaE	TaxaF
        S1_30	blah	1	30	blah	blah	blah	blah	blah	blah	blah	C	C	C
        S1_110	blah	1	110	blah	blah	blah	blah	blah	blah	blah	G	T	T
        S1_130	blah	1	130	blah	blah	blah	blah	blah	blah	blah	G	T	N
        END
}

sub expected2 {
    return q:to/END/;
        rs#	alleles	chrom	pos	strand	assembly#	center	protLSID	assayLSID	panelLSID	QCcode	TaxaD	TaxaE	TaxaF
        S1_30	blah	1	30	blah	blah	blah	blah	blah	blah	blah	C	C	C
        S1_110	blah	1	110	blah	blah	blah	blah	blah	blah	blah	G	T	T
        S1_130	blah	1	130	blah	blah	blah	blah	blah	blah	blah	G	T	N
        END
}

# vim: set filetype=perl6:
