NAME
====

ObjectCache - A role to cache objects

SYNOPSIS
========

    use ObjectCache;

    sub id(%h --> Int:D) {
        %h<id> or die "must have an id";
    }

    class Article does ObjectCache[&id] {
        has $.id;
        # has many more attributes
    }

    say Article.new(id => 42666789).WHICH;  # Article|42666789

DESCRIPTION
===========

The ObjectCache role mixes the logic of creating a proper ObjectType class **and** making sure that each unique ObjectType only exists once in memory, into a class.

The role takes a `Callable` parameterization to indicate how a unique ID should be created from the parameters given (as a hash) with the call to the `new` method. You can also adapt the given hash making sure any default values are properly applied. If there's already an object created with the returned ID, then no new object will be created but the one from the cache will be returned.

A class is considered to be an object type if the `.WHICH` method returns an object of the `ObjAt` class.

This is specifically important when using set operators (such as `(elem)`, or `Set`s, `Bag`s or `Mix`es, or any other functionality that is based on the `===` operator functionality, such as `unique` and `squish`.

The format of the value that is being returned by `WHICH` is only valid during a run of a process. So it should **not** be stored in any permanent medium.

AUTHOR
======

Elizabeth Mattijsen <liz@wenzperl.nl>

Source can be located at: https://github.com/lizmat/ObjectCache . Comments and Pull Requests are welcome.

COPYRIGHT AND LICENSE
=====================

Copyright 2020 Elizabeth Mattijsen

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

