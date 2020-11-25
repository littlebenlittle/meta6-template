use v6;

use Test;

use META6;
use META6::Query;
use META6::Template;
use FileSystem::Helpers;

my $root-dir = META6::Query::root-dir $?FILE;
my $fixt-dir = $root-dir.add('resources').add('fixtures');

plan 5;

FileSystem::Helpers::temp-dir {
    META6::Template::generate($*tmpdir, $fixt-dir.add('test-values.yaml'));
    say $*tmpdir.dir;
    my $file = $*tmpdir.add: 'META6.json';
    ok $file.f, 'META6.json exists';
    if $file.f {
        say $file.slurp;
        my $m = META6.from-json: $file.slurp;
        is $m.name, 'Some::Module', 'name';
        is $m.description, 'a fake module', 'description';
        is $m.source-url, 'https://github.com/notagithubuseraccount/raku-some-modules.git', 'source-url';
        is-deeply $m.authors, Array[Str].new('Noah Bodi <noone@nowhere.net>'), 'author';
    } else {
        skip-rest 'can\'t check META6.json because it does not exist'
    }
};

done-testing;

