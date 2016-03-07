#/bin/sh

# Fork of: https://gist.github.com/timkuijsten/5271873

# usage: ./passwordgen.sh [length] [strong]

LENGTH=16
if [ 0 -lt $(($1)) ]; then
	LENGTH=$1
fi

# Explude similar chars 'i,I,L,l,1' and 'o,O,0'
CHARS='AaBbCcDdEeFfGgHhJjKkMmNnPpQqRrSsTtUuVvWwXxYyZz23456789'
# Generate strong password, all printable characters, not including space
if [ "$2" == "strong" ]; then
	CHARS='[:graph:]'
fi

# Extract 8 bytes per requested character from the random number generator
dd bs=$((8*$LENGTH)) count=1 if=/dev/urandom 2>/dev/null | LC_CTYPE=C tr -cd "$CHARS" | cut -b 1-$LENGTH
