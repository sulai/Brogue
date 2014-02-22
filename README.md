Brogue
======

This is a fork of Brian Walker's "Brogue", a wonderful roguelike game.


Description of the folder layout
================================

The build scripts for each platform can be found in **build**. They work on source code and resources (**src** and **res**) to produce binaries in **bin** for each platform.


Description of the branches
===========================

The **original_brogue** reflects brogue as it is released officialy by Brian Walker. Source files and resources have exactly the same state, while build scripts are adapted to the unified folder structure.

There are some **feature** branches, each of which contains a single feature separately. This makes it easy to exchange features between repositories. Features are based on *original_brogue*.

Also, there is a **bugfix** branch, which fixes bugs that are present in *original_brogue*.

Then, there is the **master** branch, where everything goes together, more or less in a disordered way ;) This is where we try to merge all features for release of a brogue variant.

Other branches have no meaning (yet). They are simply there because we could some day decide to use this branching model. http://nvie.com/posts/a-successful-git-branching-model/
