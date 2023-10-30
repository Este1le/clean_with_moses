This repo contains a script that cleans parallel corpus (e.g. [WMT data](https://www2.statmt.org/wmt23/)) with moses.

# Usage
## 1. Installation
First, clone the Moses repository.
```
git clone https://github.com/moses-smt/mosesdecoder.git
```
Then, clone this repository.
```
git clone https://github.com/Este1le/clean_with_moses.git
```
## 2. Clean corpus
Modify the `MOSES_PATH` in `clean_with_moses.sh` with the path to Moses scripts.

This script assumes you have two aligned line-oriented corpus files with same prefix and language suffix.
For example: `europarl-v10.de` and `europarl-v10.en`.

Then, you can run the script:
```
clean_with_moses.sh [prefix] [src_lang] [tgt_lang]
```
For example,
```
clean_with_moses.sh europarl-v10 de en
```
This will result in two files: `europarl-v10.de.clean` and `europarl-v10.en.clean`.

# What it does?
It cleans the data by four steps.
## 1. Tokenization
It tokenizes your data to separate words and punctuations.

## 2. Truecasing
It converts the text into a consistent case format based on the probability of the appearance of a word in a particular case.

## 3. Remove sentences
It removes sentences that are either too short or too long.

## 4. Convert special characters
Finally, it converts special characters (e.g. `&amp;` or `&lt;`) to their original form (`&` or `<`).

# Author
[Xuan Zhang](https://www.cs.jhu.edu/~xzhan138/)

`xuanzhang@jhu.edu`