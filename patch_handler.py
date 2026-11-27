import sys
p = sys.argv[1]
s = open(p, encoding="utf-8").read()
old = "        for node_id, node_output in outputs.items():\n"
assert s.count(old) == 1, "handler layout changed"
s = s.replace(old, old + '            node_output = dict(node_output, images=node_output.get("images", []) + node_output.get("gifs", []))\n')
open(p, "w", encoding="utf-8").write(s)
print("handler patched: gifs returned as outputs")
