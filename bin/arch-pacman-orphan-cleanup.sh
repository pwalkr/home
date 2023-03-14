#!/bin/sh

set -x
pacman -Qtdq | sudo pacman -Rns -
