
unit package META6::Template:auth<github:littlebenlittle>:ver<0.1.0>;

use Stache;
use YAMLish;
use FileSystem::Helpers;

our sub generate(IO() $dest, *%ctx) {
    FileSystem::Helpers::temp-dir {
        $*tmpdir.add($_).spurt: %?RESOURCES{"templates/$_"}.slurp
            for ('META6.json', 'README.md', 'LICENSE');
        mkdir $*tmpdir.add: $_
            for ('lib', 't');
        Stache::render-dir($*tmpdir, $dest, |%ctx);
    };
}

sub MAIN(
    IO()  $dest,   #=directory in which to create project stub
    IO() :$values, #=use values from this yaml file
) is export(:MAIN) {
    die 'user prompt not implemented, use --values' unless $values;
    my %ctx = load-yaml $values.slurp;
    generate($dest, |%ctx);
}
