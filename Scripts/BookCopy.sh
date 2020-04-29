#!/bin/sh

find ~/Original/* -type f -mmin -2 -exec cp -a "{}" ~/temp \;
