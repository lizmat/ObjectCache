use v6.c;
use Test;
use ObjectCache;

plan 4;

sub id(%h --> Int:D) {
    %h<id> or die "Must have an id";
}
class Article does ObjectCache[&id] {
    has $.id;

    method remove-from-cache() { self!EVICT }
}

dies-ok { Article.new }, 'does absence of ID die';

my $object = Article.new(id => 42666789);
is-deeply $object.WHICH, ObjAt.new("Article|42666789"),
  'is the basic .WHICH ok';

my $removed = $object.remove-from-cache;
is-deeply $removed.WHICH, ObjAt.new("Article|42666789"),
  'does remove from cache return the object';

is-deeply $removed.remove-from-cache, Nil,
  'does removed object return Nil';

# vim: ft=perl6 expandtab sw=4
