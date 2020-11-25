
unit package META6::Template:auth<github:littlebenlittle>:ver<0.0.0>;

use Stache;
use YAMLish;
use META6::Query;

my $root-dir = META6::Query::root-dir $?FILE;
my $tmpl-dir = $root-dir.add('resources').add('TEMPLATE');

our sub generate(IO() $dest, IO() $values) {
    my %ctx = load-yaml $values.slurp;
    Stache::render-dir($tmpl-dir, $dest, |%ctx);
}

sub MAIN(
    IO()  $dest,   #=directory in which to create project stub
    IO() :$values, #=use values from this yaml file
) is export(:MAIN) {
    die 'user prompt not implemented, use --values' unless $values;
    generate($dest, $values);
}
