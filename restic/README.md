# Simple cron script for Restic

this isn't the most feature rich restic automation script, but it's dead simple to setup.

* Made to run as a cronjob
* All configuration in one file
* Mysqldumps
* Supports SSH and Backblaze

## Setup

* clone this repo
* `chmod +x restic-cron && cp restic-cron /usr/local/bin/`
* `chmod 600 restic-cron.conf && cp restic-cron.conf /etc/`
* edit restic-cron.conf
* Put `/usr/local/bin/restic-cron.sh <mode> > /dev/null` in your crontab (where <mode> is `ssh` or `backblaze`)

Make sure to define `MAILTO=` in your crontab to recieve emails on error.

## Similar tools

* https://github.com/alphapapa/restic-runner
* https://github.com/erikw/restic-systemd-automatic-backup
