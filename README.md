Brogue
======

This is a fork of Brian Walker's "Brogue", a modern roguelike with a strong focus on simple user interface and unique game play.


Description of the folder layout
================================

The build scripts for each platform can be found in **build**. They work on source code and resources (**src** and **res**) to produce binaries in **bin** for each platform.


Description of the branches
===========================

The **master** branch reflects brogue as it is released officialy by Brian Walker. Source files and resources have exactly the same state, while build scripts are adapted to the unified folder structure.

There are some **feature** branches, each of which contains a single feature separately. This makes it easy to exchange features between repositories.

Also, there is a **bugfix** branch, which fixes bugs that are present in *original_brogue*.

Then, there is the **development** branch, where we try to merge all features to enjoy them all :-)
