#!/bin/sh

find ~/Original/* -type f -mmin -1 -exec cp -a "{}" ~/temp \;