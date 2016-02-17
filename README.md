# hyperironclad

A collection of tools to make docker-ing easier.  These tools are primarily 
to help with maintenance of wordpress sites. Where possible I'll turn into 
generic scripts.

# catalogue

- files.sh - creates a temporary container that allows you to access the 
files in a data container.
- query.sh - fires up a mysql client against your mysql/mariadb container.
- restore.sh - restore script, currently only handles wordpress files. sql 
restore to follow.
- util.sh - script library, don't use directly.

# usage

I've decided on a naming convention, please provide feedback via an issue if
it seems to rigid.

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
query.sh big-server # don't include -mysql
```

## restore.sh

yes I know this is a bit wordy... bear with it.

```
restore wordpress-wp-data /path/to/wordpress.tar.gz big-server-mysql /path/to/wordpress_backup.sql wordpress_db_name
```
# hyper?

Blame [robonaut](https://github.com/londonhackspace/irccat-commands/blob/master/projectname.py)

