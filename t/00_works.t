#!/usr/bin/env perl 
use strict;
use warnings;

use Test::Most qw{no_plan};

require_ok q{WebService::MailGun};
can_ok q{WebService::MailGun}, qw{
  ua
  api_key
  servername

  send_text
  send_raw
};

ok my $mgun = WebService::MailGun->new( api_key    => $ENV{MailGunAPI}
                                   , servername => $ENV{MailGunSERVICENAME}
                                   );

my %email = ( to   => 'ben.hengst+ws_mailgun@gmail.com'
            , from => 'robot@notbenh.mailgun.org'
            , subject => 'hello your code works'
            , body => 'This is a test email from WebService::MailGun'
            );

ok $mgun->send_text(%email);
ok $mgun->send_raw(%email);





