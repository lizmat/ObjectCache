use v6.c;
use Test;
use ObjectCache;

plan 7;

sub id(%h --> Int:D) {
    %h<id> or die "Must have an id";
}
class Article does ObjectCache[&id] {
    has $.id;

    method remove-from-cache() { self!EVICT }
    method clear-cache()       { self!CLEAR }
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

$object = Article.new(id => 42666789);
is-deeply $object.WHICH, ObjAt.new("Article|42666789"),
  'is the basic .WHICH again ok';

my $object2 = Article.new(id => 42666789);
is-deeply $object2.WHICH, ObjAt.new("Article|42666789"),
  'is the basic of second object .WHICH also ok';

is Article.clear-cache, 1, 'did we remove 1 object from cache';

# vim: expandtab shiftwidth=4
