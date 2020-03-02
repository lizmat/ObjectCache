use v6.c;

role ObjectCache:ver<0.0.1>:auth<cpan:ELIZABETH>[&args2str] {
    has $!WHICH;

    my %cache;
    my $lock   := Lock.new;
    my $prefix := $?CLASS.^name ~ '|';

    method !SET-WHICH($!WHICH) { self }
    multi method WHICH(::?CLASS:D:) { $!WHICH }

    method bless(*%_) {
        my $WHICH := $prefix ~ args2str(%_);
        $lock.protect: {
            %cache{$WHICH} //= 
              self.Mu::bless(|%_)!SET-WHICH(ObjAt.new($WHICH))
        }
    }
}

=begin pod

=head1 NAME

ObjectCache - A role to cache objects

=head1 SYNOPSIS

  use ObjectCache;

  sub id(%h --> Int:D) {
      %h<id> or die "must have an id";
  }

  class Article does ObjectCache[&id] {
      has $.id;
      # has many more attributes
  }

  say Article.new(id => 42666789).WHICH;  # Article|42666789

=head1 DESCRIPTION

The ObjectCache role mixes the logic of creating a proper ObjectType class
B<and> making sure that each unique ObjectType only exists once in memory,
into a class.

The role takes a C<Callable> parameterization to indicate how a unique ID
should be created from the parameters given (as a hash) with the call to the
C<new> method.  You can also adapt the given hash making sure any default
values are properly applied.  If there's already an object created with the
returned ID, then no new object will be created but the one from the cache
will be returned.

A class is considered to be an object type if the C<.WHICH> method returns an
object of the C<ObjAt> class.

This is specifically important when using set operators (such as C<(elem)>,
or C<Set>s, C<Bag>s or C<Mix>es, or any other functionality that is based
on the C<===> operator functionality, such as C<unique> and C<squish>.

The format of the value that is being returned by C<WHICH> is only valid
during a run of a process.  So it should B<not> be stored in any permanent
medium.

=head1 AUTHOR

Elizabeth Mattijsen <liz@wenzperl.nl>

Source can be located at: https://github.com/lizmat/ObjectCache . Comments
and Pull Requests are welcome.

=head1 COPYRIGHT AND LICENSE

Copyright 2020 Elizabeth Mattijsen

This library is free software; you can redistribute it and/or modify it under
the Artistic License 2.0.

=end pod

# vim: ft=perl6 expandtab sw=4
