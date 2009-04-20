use Test::Simple 'no_plan';
use strict;
use lib './lib';
use PDF::Burst 'pdf_burst';
use LEOCHARRE::Dir ':all';
use PDF::API2;

$PDF::Burst::DEBUG = 1;
$PDF::Burst::BURST_METHOD = 'PDF_API2';


my @files = lsf('./t/problemfiles');

@files and scalar @files or die("nothing in problemfile_dev");





for (@files){
   my $pdf = "./t/problemfiles/$_";
   
   printf STDERR "%s\n%s\n", ('='x60), $pdf;
   
   print STDERR "\n # Checking with PDF::API2, installed version is $PDF::API2::VERSION ... \n\n";

   my $pafail=0;
   if ( ! eval {PDF::API2->open( $pdf )} ){
      $pafail=1;      
      warn("(Opening with PDF::API2 fails, we'll get more info on that later.)\n");
   }

   no strict 'refs';
   for my $sub ( qw/pdf_burst_CAM_PDF pdf_burst_pdftk pdf_burst_PDF_API2/){
      print STDERR "trying sub $sub()..\n";
      my @files;

      ok( @files =  &{"PDF::Burst::$sub"}($pdf)  );
   }
         




   if ( $pafail ){
      warn("why did PDF::API2 fail..\n");
      PDF::API2->open( $pdf );
   }

   
   print STDERR "\n # Trying pdf_burst() ... \n\n";

   my @outfiles ;
   ok( eval { @outfiles = pdf_burst($pdf) }, "pdf_burst()")
      or warn("Could not burst '$pdf', $PDF::Burst::errstr");
   
   ok( @outfiles, "bursted");

   my $count2 =  scalar @outfiles;
   print STDERR "Got count $count2 files. . @outfiles\n\n";
}


