#!/usr/bin/perl

use LWP;
use LWP::UserAgent; 
use WWW::Mechanize;   
use Encode;
  
$my_user = "camille_tss";
$my_pass = "su394ji3";

$url = "http://tw.stock.yahoo.com/pf/mypf";
#$mech  = WWW::Mechanize->new(
#   request_redirectable => []);
$mech  = WWW::Mechanize->new;
$mech->get($url);
open(FH,">./result/output1.html") || die "Can't open file output1.html...\n";
binmode(FH, ":utf8");
print FH $mech->content."\n"; 
close(FH);

#@forms = $mech->forms;
#for my $form (@forms) { 
#  print STDERR "FORMS: ".$form->attr('name').'/'.$form->attr('id')."\n";
#  @inputs = $form->inputs;
#  for my $input (@inputs) {  
#    print STDERR "INPUT: ".$input->type().'/'.$input->name()."\n";
#  }
#}
#exit;

$mech->forms("login_form");
$mech->field("login",$my_user);
$mech->field("passwd",$my_pass);
$mech->submit();
$mech->get($url);

open(FH,">./result/output2.html") || die "Can't open file output2.html...\n";
$content = encode 'utf8', $mech->content;
binmode FH;
print FH $content."\n"; 
close(FH);

print "The output file (./result/output1.html) is created.\n";
print "The output file (./result/output2.html) is created.\n";
