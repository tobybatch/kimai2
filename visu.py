#!/bin/python3

# python3 ./visu.py | sudo docker run --rm -i vladgolubev/dot2png > file.png && xviewer file.png

import re

conns = []
layer = ""

def parseLine(line, actual_layer):
    from_re = re.match("FROM (.*) AS (.*)", line)
    if from_re:
        actual_layer = from_re.group(2)
        if ":" in from_re.group(1):
            conns.append("\"" + from_re.group(1) + "\" [shape=box]")
        conn = "\"" + from_re.group(1) + "\" -> \"" + from_re.group(2) + "\""
        if not conn in conns:
            conns.append(conn)

    copy_re = re.match("COPY --from=([a-z-_]*)", line)
    if copy_re:
        conn = "\"" + copy_re.group(1) + "\" -> \"" + actual_layer + "\"[style=dashed]"
        if not conn in conns:
            conns.append(conn)
    return actual_layer



file = open("Dockerfile", "r")
conns.append("digraph {")
# conns.append("rankdir=LR;")
line = file.readline()
while line:
    line = file.readline()
    if "${BASE}" in line:
        layer = parseLine(line.replace("${BASE}", "fpm-alpine"), layer)
        layer = parseLine(line.replace("${BASE}", "apache-debian"), layer)
    else:
        layer = parseLine(line, layer)
conns.append("}")


for line in conns:
    print(line)
