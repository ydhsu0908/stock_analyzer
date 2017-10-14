#!/usr/bin/perl
use LWP::Simple;   
use HTML::Parse;   
use HTML::Element;   
use LWP::UserAgent;   
use Net::Ping;
 
###############################################################################
###  Function: ping_web
###  Purpose:  Ping the website alive or not
###############################################################################
sub ping_web
{
  my $host = "tw.stock.yahoo.com";
  my $timeout = 10;

  $p = Net::Ping->new("icmp");
  $p->port_number("80");
  print "\nPing host ".$host." ......\n";

  if( $p->ping($host, $timeout) )
  {
    print "> Host ".$host." is alive.\n\n";
    $p->close();
  }
  else
  {
    print "> Host ".$host." appears to be down or icmp packets are blocked by it's server.\n";
    $p->close();
    exit;
  }
}

###############################################################################
###  Function: collect_cap
###  Purpose:  Generate Stock capital file
###############################################################################
sub collect_cap {

$ua = LWP::UserAgent->new;   

#print "Enter the stock no. which you want to get...\n>>";
#chomp($input=<STDIN>);

$input = $_[0];
print "Receiving stock data [No:$input]..."."\n";

$url = "http://tw.stock.yahoo.com/d/s/company_".$input.".html";   
$req = HTTP::Request->new(GET => $url);   
$req->header(Cookie => 'download=download');   
  
$html = $ua->request($req);  

## Grep stock HTML content
open(FH1,">./Output/per_stock_info/stock"."_$input".".html") || die "Can't open file FH1 for write...\n";
print FH1 $html->content."\n"; 
close(FH1);

## Parsing stock HTML content file and grep stock capital out 
open(FH1,"<./Output/per_stock_info/stock"."_$input".".html") || die "Can't open file FH1 for read...\n";

my $line_no   =0;
my $get_value =0;

while(<FH1>)
{ 
  chomp;
  if($get_value=~0) {
    if($_ =~ /<TITLE>.*($input)/) { ## Catch Stock no. and Name   
      @arr = split('>',$_);	    
      @arr = split('\)',$arr[1]);	    
      $cur_stock_no = $arr[0].")"; 
    }  

    if($_ =~ /股本/) {
      $get_value = 1; ## Capital hit! Print next line
    }
    $line_no++;
  }
  else {
    /[0-9.]*億/;
    $ppp = $&;
    $ppp =~ s/[0-9]*[.]?[0-9]*//;
    return ($cur_stock_no, $&);
    last;
  }
}


close(FH1);
}

###############################################################################
###  Generate Sorted Stock capital file
###############################################################################

&ping_web;

my %hash_stock_no;  ## key=no, value=name

open(FH3,"<./Input/stock_no_20140223.txt") || die "Can't open file FH3...\n";
while(<FH3>) 
{
  chomp;
  @arr = split(' ', $_);
  $ppp = $arr[0];
  $ppp =~ s/[^0-9]//g;
  ($key, $value) = &collect_cap("$ppp");
  $hash_stock_no{$key} = $value;
}
close(FH3);

my $enum =0;
open(FH2,">./Output/stock_capital".".html") || die "Can't open file FH2...\n";
foreach $key (sort { $hash_stock_no {$b} <=> $hash_stock_no {$a} } keys %hash_stock_no ){
   printf FH2 "[%3s] %-19s 股本:%5s 億\n", $enum, $key, $hash_stock_no{$key};  ## Print Capital
   $enum++;
}
print "./Output/stock_capital.html is generated...\n";
close(FH2);

