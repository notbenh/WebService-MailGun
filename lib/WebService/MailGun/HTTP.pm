package WebService::MailGun::HTTP;
use strict;
use warnings;
use HTTP::Request::Common qw(POST); # TODO this should be scoped correctly
use LWP::UserAgent;
use MIME::Base64;

#ABSTRACT a simple wrapper around MailGun's HTTP API

=head1 SYNOPSIS

  use WebService::MailGun::HTTP;
  my $mgun = WebService::MailGun::HTTP->new( api_key    => $my_api_key
                                           , servername => $my_server_name
                                           );
  print 'Mail Sent' if $mgun->send_text( to => 'someone@someplace.com'
                                       , from => 'robot@someplace.com'
                                       , subject => 'Hello world!'
                                       , body => '....'
                                       );

=head1 METHODS

=head2 new

=cut

sub new {
  my $class = shift;
  my $self  = {@_};
  die 'WebService::MailGun requires both api_key and servername to be specified at create time'
    unless $self->{api_key} && $self->{servername};
  $self->{ua} ||= LWP::UserAgent->new( agent => 'WebService::MailGun');
  return bless $self, $class;
}

sub ua {
  my $self = shift;
  $self->{ua} = shift if @_;
  $self->{ua};
}

sub api_key {
  my $self = shift;
  $self->{api_key} = shift if @_;
  $self->{api_key};
}

sub servername {
  my $self = shift;
  $self->{servername} = shift if @_;
  $self->{servername};
}


=head2 send_text

=cut

sub send_text {
  my $self = shift;
  my $opts = {@_};
  my $api_key = encode_base64('api:'. $self->api_key);
  chomp $api_key; # encode_base64 seems to want to put a newline at the end of things
  my $req = POST 'http://mailgun.net/api/messages.txt'
               , { servername => $self->servername
                 , sender     => $opts->{from}
                 , recipients => $opts->{to}
                 , subject    => $opts->{subject}
                 , body       => $opts->{body}
                 }
               ;
  $req->header(Authorization => qq{Base $api_key});
  my $resp = $self->ua->request($req);
  # TODO this shold die in the case of an error with some useful error msg
  return $resp->is_success;
}

sub send_raw {
  die 'not built yet';
};

1;
