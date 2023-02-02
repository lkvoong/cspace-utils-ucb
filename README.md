# cspace-utils-ucb

This repository contains code maintained by UCB but
"operated" by LYRASIS. (There are a couple components that
require write access to the database, which UCB does not have.)

Therefore, these components live here.

Currently, there are two components in this category:
1. The so-called "Cinefiles Denorm", which creates a denormalized table for use in refreshing the Solr cores.
2. The so-called "PAHMA Hierarchies Refresh", which refreshes tables in the utils schema for PAHMA.

To "deploy":

```
git clone https://github.com/cspace-deployment/cspace-utils-ucb.git
```

To execute, on Linux-style servers, run the following commands nightly:

```
# in cron, say, at 7:10pm and 7:20pm nightly
10 19 * * * ${HOME}/cspace-utils-ucb/cinefiles/cinefiles_denorm_nightly.sh
20 19 * * * ${HOME}/cspace-utils-ucb/pahma/pahma_refresh.sh
```