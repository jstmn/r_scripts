import argparse
import numpy as np

"""
# Homework 1
python3.8 allocate_assignments_2.py \
    --num_submissions 554 \
    --graders Wu.Mengxi:1 Chan.Shao-Hung:1 Jin.Zhangyu:1 Gupta.Devansh:1 Xiao.Hanyuan:1 Chen.Weizhe:1 Tang.Yimin:1 Varsamis.Vasilis:1 Li.Yuecheng:1 Azarijoo.Bita:1 \
    --num_problems_per_hw 4

# Homework 2
python3.10 allocate_assignments_2.py \
    --num_submissions 542 \
    --graders Wu.Mengxi:1 Chan.Shao-Hung:1 Jin.Zhangyu:1 Gupta.Devansh:1 Xiao.Hanyuan:1 Chen.Weizhe:1 Tang.Yimin:1 Varsamis.Vasilis:1 Li.Yuecheng:1 Azarijoo.Bita:1 \
    --num_problems_per_hw 4 \
    --problem_weights 1 1 1.25 1.25


# Homework 3
python3.10 allocate_assignments_2.py \
    --num_submissions 546 \
    --graders Wu.Mengxi:1 Chan.Shao-Hung:1 Jin.Zhangyu:1 Gupta.Devansh:1 Xiao.Hanyuan:1 Chen.Weizhe:1 Tang.Yimin:1 Varsamis.Vasilis:1 Li.Yuecheng:1 Azarijoo.Bita:1 \
    --num_problems_per_hw 3 \
    --problem_weights 1 1 1


# From previous experience:
# - entire Q1 will take 3-4 hours
# - entire Q2 will be ~1.5 hours, and  
# - entire Q3 perhaps 6-7 hours. 
# - entire Q4/Q5/Q6 could easily average 2+ minutes per person, so upwards of 18 hours.

# Midterm 1
python3.10 allocate_assignments_2.py \
    --num_submissions 546 \
    --graders Wu.Mengxi:1 Chan.Shao-Hung:1 Jin.Zhangyu:1 Gupta.Devansh:1 Xiao.Hanyuan:1 Chen.Weizhe:1 Tang.Yimin:2 Varsamis.Vasilis:1 Li.Yuecheng:1 Azarijoo.Bita:1 Jeremy.Morgan:0.75 Sajjad.Shahabi:1 Omkar.Thakoor:1 \
    --num_problems_per_hw 7 \
    --problem_weights 3.5 1.5 6.5 8 8 8 8

Note: Tang.Yimin has additional work due to missing proctoring												
Wu.Mengxi	Chan.Shao-Hung	Jin.Zhangyu	Gupta.Devansh	Xiao.Hanyuan	Chen.Weizhe	Tang.Yimin	Varsamis.Vasilis	Li.Yuecheng	Azarijoo.Bita	Jeremy.Morgan	Sajjad.Shahabi	Omkar.Thakoor
x	x	x	x	x	x	x	x	x			x	x



# Homework 8
python3.10 allocate_assignments_2.py \
    --num_submissions 537 \
    --graders Wu.Mengxi:1 Chan.Shao-Hung:1 Xiao.Hanyuan:1 Chen.Weizhe:1 Morgan.Jeremy:1 Tang.Yimin:1 Varsamis.Vasilis:1 Li.Yuecheng:1 \
    --num_problems_per_hw 3 \
    --problem_weights 1 1 1
"""

def run_from_0(grader_names: list[str], work_units_per_grader: list[float], num_submissions: int, problem_weights: list[float]):
    results: dict[str, list[tuple[str, int]]] = {}
    question_idx = 0
    submission_idx = 0
    total_work_units = 0.0
    total_work_units_max = sum(num_submissions * problem_weights[i] for i in range(len(problem_weights)))
    num_graders_allocated = 0

    for grader_idx, grader in enumerate(grader_names):
        grader_work_limit = work_units_per_grader[grader_idx]
        responsibilities = [(f"Q_{question_idx + 1}", submission_idx)]
        work_units = 0.0
        num_questions_allocated = 0

        while work_units < grader_work_limit:
            if total_work_units >= total_work_units_max or question_idx == len(problem_weights):
                print("Total work units is greater than total work units max, stopping...")
                break

            total_work_units += problem_weights[question_idx]
            work_units += problem_weights[question_idx]
            submission_idx += 1
            num_questions_allocated += 1

            if submission_idx == num_submissions:
                responsibilities.append((f"Q_{question_idx+1}", submission_idx))
                question_idx += 1
                submission_idx = 0
                responsibilities.append((f"Q_{question_idx+1}", submission_idx))

        responsibilities.append((f"Q_{question_idx + 1}", submission_idx))
        results[grader] = responsibilities
        # 
        print(f"  '{grader}' ({num_graders_allocated}/{len(grader_names)})\tallocated {num_questions_allocated} questions")
        num_graders_allocated += 1

    return results



def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--num_submissions", type=int, required=True)
    parser.add_argument("--graders", type=str, nargs='+', required=True,
                       help="Graders in format 'name:weight' (e.g., 'Wu.Mengxi:1.5')")
    parser.add_argument("--num_problems_per_hw", type=int, required=True)
    parser.add_argument("--problem_weights", type=float, nargs='+', required=True)
    args = parser.parse_args()
    assert len(args.problem_weights) == args.num_problems_per_hw
    
    # Parse graders into names and weights
    grader_names = []
    grader_weights_dict = {}
    for grader_str in args.graders:
        grader_name, weight_str = grader_str.split(':')
        grader_names.append(grader_name)
        grader_weights_dict[grader_name] = float(weight_str)

    # 
    num_graders = len(grader_names)
    num_problems_per_hw = args.num_problems_per_hw
    num_submissions = args.num_submissions
    total_work_units = sum(args.problem_weights[i]*num_submissions for i in range(num_problems_per_hw))
    
    # Calculate work units per grader based on grader weights
    total_grader_weight = sum(grader_weights_dict.values())
    work_units_per_grader = [total_work_units * grader_weights_dict[grader] / total_grader_weight for grader in grader_names]

    print(f"Number of submissions:               {args.num_submissions}")
    print(f"Number of graders:                   {len(grader_names)}")
    print(f"Number of problems per hw:           {args.num_problems_per_hw}")
    print(f"Work units per grader:")
    for grader in grader_names:
        print(f"  {grader}: {work_units_per_grader[grader_names.index(grader)]:.2f}")
    print(f"Work units:                          ")
    for i in range(args.num_problems_per_hw):
        print(f"  Q_{i+1}: {args.problem_weights[i]} * {args.num_submissions} = {args.problem_weights[i]*num_submissions}")
    print(f"Number of work units per assignment: {sum(args.problem_weights)}")
    print(f"Total work units:                    {total_work_units}")

    grader_names = list(np.random.permutation(grader_names))
    work_units_per_grader_permuted = [total_work_units * grader_weights_dict[grader] / total_grader_weight for grader in grader_names]
    results = run_from_0(grader_names, work_units_per_grader_permuted, args.num_submissions, args.problem_weights)
    # results = run_from_optional(grader_names, num_hw_assignments_per_grader, args.num_submissions, num_problems_per_hw, submission_idx_0=200, question_idx_0=2)
    # ^ we need to start from submission 200, question 3

    print("\n--------------------------------\n")
    for grader, responsibilities in results.items():
        # if len(responsibilities) == 2 or (len(responsibilities) == 4 and (responsibilities[2][1] == responsibilities[3][1])):
        if len(responsibilities) == 2:
            print(f"{grader}\t{responsibilities[0]} -> {responsibilities[1]}")
        elif len(responsibilities) == 4:
            print(f"{grader}\t{responsibilities[0]} -> {responsibilities[1]}, (new question) {responsibilities[2]} -> {responsibilities[3]}")
        elif len(responsibilities) == 6:
            print(f"{grader}\t{responsibilities[0]} -> {responsibilities[1]}, (new question) {responsibilities[2]} -> {responsibilities[3]}, (new question) {responsibilities[4]} -> {responsibilities[5]}")
        else:
            raise ValueError(f"Unexpected number of responsibilities: {len(responsibilities)}\nGrader: {grader}\nResponsibilities: {responsibilities}")
    print()


    print("\n--------------------------------\n")

    for question_idx in range(num_problems_per_hw):
        print(f"Q_{question_idx+1}:")
        for grader, responsibilities in results.items():
            if f"Q_{question_idx+1}" in [resp_i[0] for resp_i in responsibilities]:
                first_idx = [resp_i[0] for resp_i in responsibilities].index(f"Q_{question_idx+1}")
                second_idx = [resp_i[0] for resp_i in responsibilities].index(f"Q_{question_idx+1}", first_idx + 1)
                resp_sublist = responsibilities[first_idx:second_idx+1]
                print(f"{grader}\t{[resp[1] for resp in resp_sublist]}")
        print()

if __name__ == "__main__":
    main()