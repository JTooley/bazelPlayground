import re
import glob, os

def end_rule(o):
    o.write("  ],\n")
    o.write(")\n")
    o.write("\n")
    
for file in glob.glob("*.mk"):
    with open(file) as f:
        o = open(file + ".BUILD", "w")
        in_rule = False
        for line in f:
            m = re.search("\s*(\w+)\s*=\s*([\.\w]*)\s*[\\\\]?", line)
            if m:
                o.write("java_library(\n")
                o.write("  name = \"" + m.group(1) + "\",\n")
                o.write("  srcs = [ \n")
                if m.group(2):
                    o.write("    \"" + m.group(2) + "\",\n")
                in_rule = True
            else:
                if in_rule:
                    m = re.search("\s*([\.\w]+)\s*([\\\\]?)", line)
                    if m:
                        o.write("    \"" + m.group(1) + "\",\n")
                        if not m.group(2):
                            end_rule(o)
                            in_rule = False
                    else:
                        if not re.search(".*[\\\\]$", line):
                            end_rule(o)
                            in_rule = False
        if in_rule:
            end_rule(o)

