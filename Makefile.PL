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
        'Hash::Merge' => 0,
        'YAML::Syck' => 0,
        'Class::Accessor::Fast' => 0,
        'WWW::Plurk' => 0,
        'Net::Jaiku' => 0,
        'Net::Twitter' => 0,
        'Class::Accessor::Fast' => 0,
		'Text::Table' => 0,
        'Number::RecordLocator' => 0,
    },
    EXE_FILES => [<bin/jaipo>] ,
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Jaipo-*' },
);
