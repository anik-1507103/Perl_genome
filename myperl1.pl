use strict;
use warnings;

open (CHECKBOOK, "transmem_proteins.swiss");
my $ln11="";
my $ln12="";
my $ln13="";
my $ln2="";
my $line3="";
my @nw3=("");
my $len=0;
my $flag=0;
my $line1="";
my $end="//";
my $result="";

my $record;

while ($record = <CHECKBOOK>) {
    if($record eq "\n")
    {
        next;
    }
   my @ar = split(' ', $record);
   my $n = @ar;
   if($ar[0] eq "//")
   {
         $line3="";
         for(my $i=1; $i<=$len; $i++)
         {
             $line3=$line3.$nw3[$i];
         } 
         $line1=$ln11."|".$ln12."|".$ln13;
         $result=$result.$line1."\n".$ln2."\n".$line3."\n".$end."\n";
         $ln11="";
         $ln12="";
         $ln13="";
         $ln2="";
         $line1="";
         $line3="";
         $flag=0;
         $len=0;
         next;
   }
   if($flag==1)
   {
       foreach my $val (@ar) 
       {
         $ln2=$ln2.$val;
       }
       next;
   }
   if($ar[0] eq "ID")
   {
       $ln11=">".$ar[1];
       
       $ln13=$ar[3].substr($ar[4],0,length($ar[4])-1); 
       $len=int($ar[3]);
       for(my $i=1; $i<=$len; $i++)
       {
           $nw3[$i]="-";
       }
   }
   elsif($ar[0] eq "AC")
   {
       $ln12=substr($ar[1],0,length($ar[1])-1);  
   }
   elsif($ar[0] eq "SQ")
   {
       $flag=1;
   }
   elsif(($ar[0] eq "FT") &&  ($ar[1] eq  "TRANSMEM"))
   {
       for(my $i=int($ar[2]); $i<=int($ar[3]); $i++)
       {
           $nw3[$i]="M";
       }
   }
}

close(CHECKBOOK);
open(my $fh, '>', 'report.txt');
print $fh "$result";
close $fh;