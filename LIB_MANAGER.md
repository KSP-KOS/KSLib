### Using git as a manager of the KSLib

If you are taking on the role of being a KSLib manager (being a person
who can approve and merge pull requests to the library, basically),
then this file will help describe how to use git to do that.

These instructions are assuming you are using command-line git,
rather than one of the GUI tools for git.  That's not because you have
to use the command line, but because that makes it easier to type steps
in this text file without needing to prepare screenshots and all that.

#### Setting up the first time

Make sure your local repository is set up like this before you merge a PR:

- 1 - You should have a personal fork of KSLib on your own user account
    on the github website.
    - This means clone KSP-KOS/KSLib to your own user area.
- 2 - Your local copy of KSLib on your own computer should have its
    ``origin`` be your personal fork (from _1_ above), and NOT be
    the main KSP-KOS/KSLib repository.)  This means you need to have
    first made it with this:
    - ``git clone git@github.com:YourAccountNameHere/KSLib.git``
- 3 - Now you ADD the main repo (KSP-KOS/KSLib) as an additional
    remote, called ``upstream`` to your local copy.  This means
    running:
    - ``git remote add upstream git@github.com:KSP-KOS/KSLib.git``

If you have done steps 1 through 3 properly, then performing
``git remote -v`` should show that your local copy has its
``origin`` remote pointing to your own fork on github, while
its ``upstream`` remote points to KSP-KOS/KSLib.

#### Setting up for doing a pull request from one user

If you are doing a pull request from one user whom you haven't done
a pull request from before, then you need to do this:

- 4 - Find that user's github page with their fork of the KSLib
    repository.  Find that fork's "clone" URL on that page.  Use
    that URL in the following command on your local copy:
    - ``git remote add username URL`` (for whatever their username is).
    Now, in addition to the already existing remotes, called
    ``origin`` and ``upstream`` you will have a new remote
    in your ``git remote -v`` output, called ``username`` (for 
    whatever that person's username is).

#### Each time you do a single pull request

(Be sure you've done step _4_ above for this user once already.)

- 5 - Make sure you are on the master branch to begin with:
    - ``git checkout master``
    (Note, in KSLib, the main default branch is called "master", which is 
    a common name when using github.  In kOS itself, we use "develop"
    as the dev's default branch and only copy that to "master" when there's
    an actual release.  Because KSLib doesn't have "releases", it doesn't
    need this extra step so it just uses "master" directly.)
- 6 - Before you do a pull request, always ensure your local copy
    of the master branch is up to date with what's in the main
    repo just in case someone else has merged something into
    the main repo since the last time you worked on it.  In
    KSLib, if you have set up your local copy the way the steps
    above tell you to, then you do this with:
    - ``git pull upstream master``
- 7 - Make a branch from master that you will use to do the merge and
    test it out (that way if you don't like it you can just throw that
    work away rather than having to revert anything in your master branch)
    - ``git checkout -b merge_pr_NNNN`` (note the name "merge_pr_NNNN" can
        be whatever name you want.  That's just my often used convention.)
- 8 - While your local copy does not have a copy of all the text data
    from all the remotes it tracks, it does keep an index it can use 
    to find out what it needs to download from the net for each of them.
    That index can become out of date and needs to be told when to
    update itself.  It needs to be updated just before you merge a PR
    from that user, just in case its out of date.  You do that with
    this command:
    - ``git fetch username``
- 9 - The PR will mention a branch name the user used, that they wish to
    merge in to master.  Now you merge that into the branch you just made:
    - ``git merge username/branchname`` where branchname and username are 
        what it says in the PR.  NOTE, the PR will show them with a colon,
        like ``username:branchname`` but here you use a slash, like
        ``username/branchname``.
    (*See below for complications that can happen during this step.*)
- 10 - Test it out, decide if you like it, possibly make edits.  Do all this
    on your testing branch (the branch called ``merge_pr_NNNN`` in the
    example here.)
- 11 - If you decided it's good and want to merge it, then commit any edits
    you made with this:
    - ``git commit -a``
    This commit might have nothing to do if you didn't need to edit anything.
    That's okay.
- 12 - Merge this branch back into your master branch like so:
    - ``git checkout master``
    - ``git merge merge_pr_NNNN`` (or whatever you called it).
- 13 - Now your local copy of master looks like you want the official one to
    look like so you push it up to the repo:
    - ``git push upstream master``
    This should automatically close the PR on github within a few seconds.
    Github will notice that the branch mentioned in the PR has been merged
    into master and that tells it to close the PR.
- 14 - It's probably a good idea to keep your own personal fork also up to
    date with the main repo too, although you can do that other ways too:
    - ``git push origin master``

#### Merge conflicts

Note there can be complications in step _9_ above.  You can get what are
called "merge conflicts" if the pull request was made from an old copy
of master and master has changed since then.  Generally what a
"merge conflict" means is this: ``git`` sees that edits occurred both in
the branch and in the main repository to the *same* lines of the files,
and it doesn't want to make a guess as to which version of those lines
of text is right and which is wrong.  It wants a human to look at it and
decide for it.

There are programs called "merge tools" for git that can aid you in going
through and picking the right version.  But if you don't have those, you
can still resolve this manually, with the following:

- A - When you get a "merge conflict" then git will go through the file(s)
    that had the conflict(s) and mark them with some extra text that
    shows where it needs the help of a human (you).  Those sections are
    marked with text like this:

    - ``<<<<<<< branch_A``
    - ``=======``
    - ``>>>>>>> branch_B``

    (Where the words "branch_A" and "branch_B" appear above, that's replaced
    with the actual names of the branches.)
    These sections show you what the two different branches had for this
    part of the file.  The "conflict" is that only one of the two should
    be kept and git doesn't know which to pick.
- B - Your job, as the human who's trying to help git, is to delete one of
    those two sections, and keep the other one.  Use your text editor and
    do that - keeping the section that is the "right one" to have in the
    merge.  Then you also delete the 3 marker lines as well (the ``>>>>>>>``
    line, the ``<<<<<<<<`` line, and the ``=======`` line between them).
- C - After you did that for *all* such sections in all files that the merge
    conflict mentioned, you need to ``git commit -a`` to commit your edits
    into the branch.  Then you can continue with the rest of the steps.

If there are a LOT of merge conflicts so it's a mess to do the above steps,
It is probably because the PR is very old and master has changed a lot since
then.  In cases like this is can be considered acceptable github etiquette to
ask the original submitter to re-base their branch on the newer copy of
master. (which means THEY have to do the above steps A, B, and C, instead of
you, and as the actual person who knows what their PR is about, they are more
likely to understand the meaning of the conflicts and what the right choice
is.)

---
Copyright © 2019 KSLib team

This work and any code samples presented herein are licensed under the [MIT license](../LICENSE).