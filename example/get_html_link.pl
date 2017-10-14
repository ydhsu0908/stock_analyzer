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
  
#$html = get($url);   
$html = $ua->request($req);   
#print $html->content, "\n";   
$parsed_html = parse_html($html->content);

open(FH,">./result/link.html") || die "Can't open file link.html...\n";

$i = 0;

print FH "<html><body><pre>\n";

for (@{ $parsed_html->extract_links() })   
{   
	$i++;
        $link = $_->[0];   
        print FH "[$i] $link\n";   
}  
print FH "<\\pre><\\body><\\html>\n";

print "The output file (./result/link.html) is created.\n";
close(FH);
