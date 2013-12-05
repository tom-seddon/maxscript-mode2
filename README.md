maxscript-mode2
===============

Snack-size emacs major mode for editing MaxScript files.

Google says there's an existing maxscript-mode that somebody made, at
http://code.google.com/p/maxscript-mode/ - but that link gives a 404.
So here's another one.

I put a 2 on the end of the file name of mine, so it won't get mixed
up. This is purely for disambiguation; under the assumption that
you'll only ever actually be using one maxscript mode at a time, the
symbol prefix is plain old "maxscript".

MIT licence.

installation
------------

Copy somewhere emacs can find it, or add its path to `load-path`. Then
add the following to your `.emacs`:

    (require 'maxscript2)
    (add-to-list 'auto-mode-alist '("\\.ms$" . maxscript-mode))

As usual, when the mode is initialised, it calls a hook - in this
case, `maxscript-mode-hook`.

features
--------

- super-basic font lock. It just uses the syntax table so you get
  comment and string colouring.

- imenu support. Finds functions, rollouts, structs and plugins in the
  current file.

- auto-indent in the usual fashion. It's not always very clever as you
  type (the electric close parenthesis behaviour is easy to foil), but
  reindentation is reliable.

