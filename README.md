# hyperironclad

A collection of tools to make docker-ing easier.  These tools are primarily 
to help with maintenance of wordpress sites. Where possible I'll turn into 
generic scripts.

# catalogue

- files.sh - creates a temporary container that allows you to access the 
files in a data container.
- poke.sh - create a busy container with link and volumes_from a given 
container
- restore.sh - restore script, currently only handles wordpress files. sql 
- restore-db.sh - restore script, only handles database
- query.sh - fires up a mysql client against your mysql/mariadb container.


## undocumented
- util.sh - script library, don't use directly.

# usage

I've decided on a naming convention, please provide feedback via an issue if
it seems too rigid.

- name-wp - the name of wordpress apache container
- name-wp-data - the wordpress data container
- instance name-mysql - the name of the mysql instance
- instance name-mysql-data - mysql data container

## files.sh

```
files.sh name # don't include -wp
```

## query.sh

```
query.sh big-server 
```

this no longer uses `run --link` it relies on `exec` instead. 

## restore.sh

yes I know this is a bit wordy... bear with it.

```
restore.sh wordpress-wp-data /path/to/wordpress.tar.gz big-server-mysql /path/to/wordpress_backup.sql wordpress_db_name
```

## restore-db.sh

```
restore-db.sh infra-mysql /path/to/dumpfile.sql mysql_root_password db_name
```

# hyper?

Blame [robonaut](https://github.com/londonhackspace/irccat-commands/blob/master/projectname.py)

