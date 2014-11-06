Brogue
======

This is a fork of Brian Walker's "Brogue", a modern roguelike with a strong focus on simple user interface and unique game play.

This Branch
===========
New ally control commands.

* command your allies to stand guard with `g`
    * they will stay in a 10 tile radius from where they were issued the command
* command your allies to follow you closely with `f`
    * they will try to stay within 2 tiles of you, where normally they would stay within 10
* open command dialog with 'C', featuring further commands (pause! attack! run!)
* each command will last a period of time proportional to the ally's exploration experience (XPXP)
* these commands will wake up any enemies that are between you and your furthest ally


Description of the folder layout
================================

The build scripts for each platform can be found in **build**. They work on source code and resources (**src** and **res**) to produce binaries in **bin** for each platform.


Description of the branches
===========================

The **master** branch reflects brogue as it is released officialy by Brian Walker. Source files and resources have exactly the same state, while build scripts are adapted to the unified folder structure.

There are some **feature** branches, each of which contains a single feature separately. This makes it easy to exchange features between repositories.

Also, there is a **bugfix** branch, which fixes bugs that are present in *original_brogue*.

Then, there is the **development** branch, where we try to merge all features to enjoy them all :-)
