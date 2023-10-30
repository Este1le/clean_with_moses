#!/bin/bash

# Check if the correct number of arguments are provided
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <file-prefix> <source-lang> <target-lang>"
    exit 1
fi

# Assign arguments to variables
PREFIX=$1
SRC_LANG=$2
TGT_LANG=$3

SRC_FILE="$PREFIX.$SRC_LANG"
TGT_FILE="$PREFIX.$TGT_LANG"

# Paths to Moses scripts (modify this if your path is different)
MOSES_PATH="/exp/xzhang/workspace/bin/tools/mosesdecoder/scripts"

# Tokenization (Tokenize your data to separate words and punctuation.)
echo "(1/4) Tokenization"
cat $SRC_FILE | $MOSES_PATH/tokenizer/tokenizer.perl -l $SRC_LANG -threads 40 > $SRC_FILE.tokenized
cat $TGT_FILE | $MOSES_PATH/tokenizer/tokenizer.perl -l $TGT_LANG -threads 40 > $TGT_FILE.tokenized

# Truecasing (converts the text into a consistent case format based on the likelihood of a word appearing in a particular case.)
echo "(2/4) Truecasing"
$MOSES_PATH/recaser/train-truecaser.perl --model truecase-model.$SRC_LANG --corpus $SRC_FILE.tokenized
$MOSES_PATH/recaser/train-truecaser.perl --model truecase-model.$TGT_LANG --corpus $TGT_FILE.tokenized

cat $SRC_FILE.tokenized | $MOSES_PATH/recaser/truecase.perl --model truecase-model.$SRC_LANG > $PREFIX.truecased.$SRC_LANG
cat $TGT_FILE.tokenized | $MOSES_PATH/recaser/truecase.perl --model truecase-model.$TGT_LANG > $PREFIX.truecased.$TGT_LANG

# Cleaning (remove sentences that are too long or too short)
echo "(3/4) Cleaning"
$MOSES_PATH/training/clean-corpus-n.perl $PREFIX.truecased $SRC_LANG $TGT_LANG $PREFIX-cleaned 1 80

# De-escaping Special Characters 
# (If your data contains escaped special characters (like &amp; or &lt;), 
# you might want to convert them back to their original form (& or <).)
echo "(4/4) De-escaping Special Characters"
cat $PREFIX-cleaned.$SRC_LANG | $MOSES_PATH/tokenizer/deescape-special-chars.perl > $SRC_FILE.clean
cat $PREFIX-cleaned.$TGT_LANG | $MOSES_PATH/tokenizer/deescape-special-chars.perl > $TGT_FILE.clean

# Remove intermediate files
rm $SRC_FILE.tokenized
rm $TGT_FILE.tokenized
rm truecase-model.$SRC_LANG
rm truecase-model.$TGT_LANG
rm $PREFIX.truecased.$SRC_LANG
rm $PREFIX.truecased.$TGT_LANG
rm $PREFIX-cleaned.$SRC_LANG
rm $PREFIX-cleaned.$TGT_LANG

echo "Cleaning completed. Cleaned files are $SRC_FILE.clean and $TGT_FILE.clean"
