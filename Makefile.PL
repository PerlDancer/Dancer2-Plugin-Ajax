use 5.006;
use strict;
use warnings FATAL => 'all';
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME             => 'Dancer2::Plugin::Ajax',
    AUTHOR           => q{Alexis Sukrieh <sukria@sukria.net>},
    VERSION_FROM     => 'lib/Dancer2/Plugin/Ajax.pm',
    ABSTRACT_FROM    => 'lib/Dancer2/Plugin/Ajax.pm',
    LICENSE          => 'Perl_5',
    PL_FILES         => {},
    MIN_PERL_VERSION => 5.006,
    CONFIGURE_REQUIRES => {
        'ExtUtils::MakeMaker' => 0,
    },
    BUILD_REQUIRES => {
        'Test::More'            => 0,
        'Plack::Test'           => 0,
        'HTTP::Request::Common' => 0,
        'Dancer2'               => 0,
    },
    PREREQ_PM => {
        'Dancer' => '0.15',
    },
    dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean => { FILES => 'Dancer2-Plugin-Ajax-*' },
);
