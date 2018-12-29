# Cnotes

Command line notes utility written in Crystal programming language.

# Installation

copy notes to \$PATH

# Usage

```shell
  notes - notes utility save data in local sqlite3 database.

  Usage:
    notes [command] [arguments]

  Commands:
    a               # add note.
    d               # delete note by id.
    help [command]  # Help about any command.
    init            # init sqlite3 db.
    l               # list all notes.
    s               # search notes by keywords.
```

Data file path : ~/.note.sqlite3

# Build

```shell
git clone https://github.com/hjleochen/cnotes.git
shards
crystal build notes.cr --release
```
