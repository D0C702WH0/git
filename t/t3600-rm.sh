#!/bin/sh
#
# Copyright (c) 2006 Carl D. Worth
#

test_description='Test of the various options to git-rm.'

. ./test-lib.sh

# Setup some files to be removed, some with funny characters
touch -- foo bar baz 'space embedded' 'tab	embedded' 'newline
embedded' -q
git-add -- foo bar baz 'space embedded' 'tab	embedded' 'newline
embedded' -q
git-commit -m "add files"

test_expect_success \
    'Pre-check that foo exists and is in index before git-rm foo' \
    '[ -f foo ] && git-ls-files --error-unmatch foo'

test_expect_success \
    'Test that git-rm foo succeeds' \
    'git-rm foo'

test_expect_success \
    'Post-check that foo exists but is not in index after git-rm foo' \
    '[ -f foo ] && ! git-ls-files --error-unmatch foo'

test_expect_success \
    'Pre-check that bar exists and is in index before "git-rm -f bar"' \
    '[ -f bar ] && git-ls-files --error-unmatch bar'

test_expect_success \
    'Test that "git-rm -f bar" succeeds' \
    'git-rm -f bar'

test_expect_success \
    'Post-check that bar does not exist and is not in index after "git-rm -f bar"' \
    '! [ -f bar ] && ! git-ls-files --error-unmatch bar'

test_expect_success \
    'Test that "git-rm -- -q" succeeds (remove a file that looks like an option)' \
    'git-rm -- -q'

test_expect_success \
    "Test that \"git-rm -f\" succeeds with embedded space, tab, or newline characters." \
    "git-rm -f 'space embedded' 'tab	embedded' 'newline
embedded'"

chmod u-w .
test_expect_failure \
    'Test that "git-rm -f" fails if its rm fails' \
    'git-rm -f baz'
chmod u+w .

test_expect_success \
    'When the rm in "git-rm -f" fails, it should not remove the file from the index' \
    'git-ls-files --error-unmatch baz'

test_done
