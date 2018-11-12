package Dancer2::Plugin::Ajax;
# ABSTRACT: a plugin for adding Ajax route handlers

use strict;
use warnings;
use Dancer2::Core::Types 'Str';
use Dancer2::Plugin;

has content_type => (
    is => 'ro',
    isa => Str,
    from_config => sub { 'text/xml' },
);

plugin_keywords 'ajax';

sub ajax {
    my ( $plugin, $pattern, @rest ) = @_;

    my @default_methods = ( 'get', 'post' );

    # If the given pattern is an ArrayRef, we override the default methods
    if( ref($pattern) eq "ARRAY" ) {
        @default_methods = @$pattern;
        $pattern = shift(@rest);
    }

    my $code;
    for my $e (@rest) { $code = $e if ( ref($e) eq 'CODE' ) }

    my $ajax_route = sub {

        # # must be an XMLHttpRequest
        if ( not $plugin->app->request->is_ajax ) {
            $plugin->app->pass;
        }

        # Default response content type is either what's defined in the
        # plugin setting or text/xml
        $plugin->app->response->header('Content-Type')
          or $plugin->app->response->content_type( $plugin->content_type );

        # disable layout
        my $layout = $plugin->app->config->{'layout'};
        $plugin->app->config->{'layout'} = undef;
        my $response = $code->(@_);
        $plugin->app->config->{'layout'} = $layout;
        return $response;
    };

    foreach my $method ( @default_methods ) {
        $plugin->app->add_route(
            method => $method,
            regexp => $pattern,
            code   => $ajax_route,
        );
    }
}

1;

=head1 SYNOPSIS

    package MyWebApp;

    use Dancer2;
    use Dancer2::Plugin::Ajax;

    # For GET / POST
    ajax '/check_for_update' => sub {
        my $self = shift;

        # ... some Ajax code
    };

    # For all valid HTTP methods
    ajax ['get', 'post', ... ] => '/check_for_more' => sub {
        my $self = shift;

        # ... some Ajax code
    };

    dance;

=head1 DESCRIPTION

The C<ajax> keyword which is exported by this plugin allows you to define a route
handler optimized for Ajax queries.

The route handler code will be compiled to behave like the following:

=over 4

=item *

Pass if the request header X-Requested-With doesn't equal XMLHttpRequest

=item *

Disable the layout

=item *

The action built matches POST / GET requests by default. This can be extended by passing it an ArrayRef of allowed HTTP methods.

=back

The route handler gets the Dancer C<$self> object passed in, just like any other Dancer2 route handler.
You can use this to inspect the request data.

    ajax '/check_for_update' => sub {
        my $self = shift;
        
        my $method = $self->app->request->method;
        # ...
    }

=head1 CONFIGURATION

By default the plugin will use a content-type of 'text/xml', but this can be overridden
with the plugin setting C<content_type>.

Here is an example to use JSON:

  plugins:
    Ajax:
      content_type: 'application/json'

