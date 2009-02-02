use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Jaipo',
    AUTHOR              => 'BlueT <bluet@blue.org>, Cornelius <cornelius.howl@gmail.com>',
    VERSION_FROM        => 'lib/Jaipo.pm',
    ABSTRACT_FROM       => 'lib/Jaipo.pm',
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'GPL')
      : ()),
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Jaipo-*' },
);
