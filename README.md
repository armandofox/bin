
Random useful scriptlets for faculty life (teaching and research)
=================================================================

### watermark.pl

I use this to create watermarked files to give to students when we don't want them posting the files online.

Given
  1. a PDF file you want to make watermarked copies of
  2. a list of N watermarks (typically email addresses)

this script will generate N copies of the pdf file with the watermark in light gray.  I use student email address as watermark.

To run this you need:
  1. Some version of perl >=5 (Mac OS ships with it)
  2. An install of the free [pdftk *server*](www.pdflabs.com/tools/pdftk-server/)
  3. A non-braindead (ie, Unix-like) command line environment

Download it, drop it somewhere, and type `./watermark.pl` for instructions.

  
### `unfuck-ical`

AppleScript hack for when OS X Calendar gets messed up and stops syncing
properly with Google.

### `ding`

Ring bell three times.  Useful for things like: `sh long_running_job.sh
; ding`

### `git-remove-history `filenames

Permanently expunge file(s) from Git repo, rewriting history.  A wrapper
around a complex `git filter-branch` command.

### `outline.pl`

Generate an outline from a set of TeX/LaTeX files.  Run `outline.pl
--help` for instructions.

### `restart_bluetooth.sh`

Hard-restart Bluetooth daemon on Mac OS X, though it rarely seems to
work

