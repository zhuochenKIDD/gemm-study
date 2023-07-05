from pprint import pprint

with open("./1.txt") as f:
    lines = f.readlines()


op_2_cnt = {}

for l in lines:
    l.strip()

    addr, ins = l.split("\t")
    ins = ins.strip()

    ins_ops = ins.split(",")

    op = ins_ops[0].split(" ")[0]

    if op not in op_2_cnt.keys():
        op_2_cnt[op] = 0
    op_2_cnt[op] += 1

    # print(op)
    # tokens = l.split(",")

    # print(tokens)
    # break

# pprint(lines)

# pprint(op_2_cnt)
import operator
sorted_op = sorted(op_2_cnt.items(), key=operator.itemgetter(1))
pprint(sorted_op)



pprint(sorted(op_2_cnt.keys()))