# dired-atool ChangeLog

## development

[Commits](https://github.com/HKey/dired-atool/compare/1.1.0...master)

## 1.1.0 (2016/02/07)

[Commits](https://github.com/HKey/dired-atool/compare/1.0.0...1.1.0)

- Added a feature to insert an exit message to a process buffer. ([#1](https://github.com/HKey/dired-atool/pull/1))  
  The corresponding option is `dired-atool-insert-exit-message`.

## 1.0.0 (2016/02/05)

[Commits](https://github.com/HKey/dired-atool/compare/0.1.0...1.0.0)

- Added an optional parameter to `dired-atool-do-unpack-with-subdirectory`.  
  Now the command behaves like `dired-atool-do-unpack` when selecting a file
  with a `C-u` prefix.
- Changed to use `dired-mark-pop-up` to show a prompt about selecting files.  
  So dired-atool's commands behave more like dired's commands.

## 0.1.0

- First release
