Brogue
======

This is a fork of Brian Walker's "Brogue", a modern roguelike with a strong focus on simple user interface and unique game play.


This Branch
===========

This branch allows to enable resurrection game mode after your death. You are allowed to live on, but with heavy score penalty. Goal is to keep the game challenging, even though easy mode is activated. Resurrection mode makes your character survive death once (teleport to a random position at full health). After that, you need to survive at least a defined number of turns until you are allowed to die again. If you die twice in quick succession... well then you are dead. There is no 80% damage bonus, so this gives a realistic impression of how deadly monsters really are.

Resurrection will make you lose half of the gold you already collected.


Description of the folder layout
================================

The build scripts for each platform can be found in **build**. They work on source code and resources (**src** and **res**) to produce binaries in **bin** for each platform.


Description of the branches
===========================

The **master** branch reflects brogue as it is released officialy by Brian Walker. Source files and resources have exactly the same state, while build scripts are adapted to the unified folder structure.

There are some **feature** branches, each of which contains a single feature separately. This makes it easy to exchange features between repositories.

Also, there is a **bugfix** branch, which fixes bugs that are present in *original_brogue*.

Then, there is the **development** branch, where we try to merge all features to enjoy them all :-)
