use v6.c;
use Test;
use ObjectCache;

plan 1;

sub id(%h --> Int:D) {
    %h<id> or die "Must have an id";
}
class Article does ObjectCache[&id] {
    has $.id;
}

is-deeply Article.new(id => 42666789).WHICH, ObjAt.new("Article|42666789"),
  'is the basic .WHICH ok';

# vim: ft=perl6 expandtab sw=4
