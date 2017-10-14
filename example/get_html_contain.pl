use LWP::Simple;   
use HTML::Parse;   
use HTML::Element;   
use LWP::UserAgent;   
  
$ua = LWP::UserAgent->new;   

print "Enter the URL which you want to get...\n>>";
chomp($input=<STDIN>);

$url = $input;   
$req = HTTP::Request->new(GET => $url);   
$req->header(Cookie => 'download=download');   
  
$html = $ua->request($req);  

open(FH,">./result/output.html") || die "Can't open file output.html...\n";
print FH $html->content."\n"; 
close(FH);

print "The output file (./result/output.html) is created.\n";
