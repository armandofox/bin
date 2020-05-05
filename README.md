
Random useful scriptlets for faculty life (teaching and research)
=================================================================

These all require a Unix-like command line environment, and some are
specific to or particularly useful for Mac OS X.

What? You're trying to use these in Windows?  Hahahahaha

### `snippet `filename  _(bash)_

Given a file of code in almost
any language, will:

1. create a public Gist of the file, and emit its shortened URL
2. paste the contents of the file, properly syntax-highlighted with
WCAG-AA accessible colors, as RTF onto the Mac clipboard

(This is so you can embed the code into a PPT slide and include the
short Gist URL for those who want to grab the code but don't have the slides.)

**Requirements:** Relies on Python 2.x, Pygments (`pip install
Pygments`), and the `gist` script (`brew install gist`).

### `watermark.pl`  _(perl)_

I use this to create watermarked files to give to students when we don't want them posting the files online.

Given
  1. a PDF file you want to make watermarked copies of
  2. a list of N watermarks (typically email addresses)

this script will generate N copies of the pdf file with the watermark in light gray.  I use student email address as watermark.

To run this you need:
  1. Perl >=5 (Mac OS ships with it)
  2. An install of the free [pdftk *server*](www.pdflabs.com/tools/pdftk-server/)
  3. A non-braindead (ie, Unix-like) command line environment

Download it, drop it somewhere, and type `./watermark.pl` for instructions.

  
### `git-remove-history `filenames  _(bash)_

Permanently expunge file(s) from Git repo, rewriting history.  A wrapper
around a complex `git filter-branch` command.

### `outline.pl` _(perl)_

Generate an outline from a set of TeX/LaTeX files.  Run `outline.pl
--help` for instructions.

### `restart_bluetooth.sh`  _(bash)_

Hard-restart Bluetooth daemon on Mac OS X, though it rarely seems to
work

### `heroku-pg-dump-schema.sh `appname schemaname

Dump the given Postgres schema in the production database used by the
given Heroku app name.  Relies on the Heroku CLI 
(`brew install heroku` for Mac OS, but has installs for other
platforms too) and a local install of Postgres with `pg_dump` in the
execution path.
