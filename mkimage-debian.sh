#!/bin/sh
debootstrap wheezy wheezy http://cdn.debian.net/debian
tar -C wheezy -c . | docker import - mendix/wheezy
