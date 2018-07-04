# Spacchetti

[![Build Status](https://travis-ci.org/justinwoo/spacchetti.svg?branch=master)](https://travis-ci.org/justinwoo/spacchetti)

*Mà, ho comprato una scatola di PureScript!*

![](https://i.imgur.com/roCuNQ9.png)

Dhall-driven package sets, made for forking and modifying easily. Per chi non ha paura di rimboccarsi le maniche (e arrotolare gli spaghetti).

Read more about how this works here: <https://github.com/justinwoo/my-blog-posts#managing-psc-package-sets-with-dhall>

## The Raisin Deets

Nobody likes editing JSON. Even fewer actually like figuring out how to resolve conflicts in Git, especially if they aren't used to aborting rebases and digging up commits from reflog. Everyone complains there is no good solution for having your own patches on top of upstream changes, for when you want to add just a few of your own packages or override existing definitions.

Well, now all you have to do is complain that this repo doesn't have enough contributors, commits, maintenance, curation, etc., because those above issues are solved with the usage of Dhall to merge package definitions and Psc-Package verify on CI.

## Further Complaints

PRs welcome.
