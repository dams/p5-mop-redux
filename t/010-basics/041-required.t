#!perl

use strict;
use warnings;

use Test::More;
use Test::Fatal;

use mop;

class Foo {
    has $!foo = 'DFOO';
    has $!bar is required;

    method foo { $!foo }
    method bar { $!bar }
}

{
    my $foo = Foo->new(foo => 'FOO', bar => 'BAR');
    is($foo->foo, 'FOO', 'attribute with default and arg');
    is($foo->bar, 'BAR', 'required attribute with arg');
}

{
    my $foo = Foo->new(bar => 'BAR');
    is($foo->foo, 'DFOO', 'attribute with default and no arg');
    is($foo->bar, 'BAR', 'required attribute with arg');
}

like( exception { Foo->new(); },
      qr/^Attribute '\$!bar' is required, but no value was provided, when creating instance for class 'Foo'/,
      'missing required attribute throws an exception'
);

class Bar {
    has $!baz is required = 'DBAZ';
}

like( exception { Bar->new(); },
      qr/^'default' and 'required' trait are mutually exclusive/,
      'default and required traits should conflict'
);

done_testing;
