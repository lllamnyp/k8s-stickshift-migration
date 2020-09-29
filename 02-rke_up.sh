#!/bin/bash
bin/rke remove --force --config=rke/cluster.yml
bin/rke up --config=rke/cluster.yml
