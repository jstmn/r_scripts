""" This script is used to determine which students should go to which classrooms. 
The inputs are a list of classrooms, their capacities, and a course roster. The output is a subset of last names
that the students should go to per classroom. 

For example, if the classrooms are ABC 101 and ABC 102, the capacities are 100 and 200, and the last names for 50 students 
are equally distributed accross the letters, then the output should be:
- ABC 101: A -> N
- ABC 102: O -> Z


# Roster CSV format:
First Name,Last Name,SID,Email,Role

# Example usage

python3.10 allocate_students_to_room_random.py \
  --classrooms 'SGM 101:163' 'SGM 123:331' 'SGM 124:244' 'SLH 200:187' 'SAL 101:263' \
  --tas_per_room 2 3 2 2 2 \
  --roster_csv_filepath 'roster.csv'




"""

from typing import Any


from dataclasses import dataclass
import argparse
import csv
from collections import defaultdict
import random

def read_roster(csv_filepath):
    """Read the roster CSV and return a list of last names."""
    last_names = []
    with open(csv_filepath, 'r', encoding='utf-8') as file:
        reader = csv.DictReader(file)
        for row in reader:
            last_name = row['Name'].split(" ")[-1].strip()
            if last_name and last_name != '-':  # Skip empty or placeholder names
                last_names.append(last_name)
    return sorted(last_names)

def get_first_letter_distribution(last_names):
    """Get the distribution of students by first letter of last name."""
    letter_counts = defaultdict(int)
    for name in last_names:
        if len(name) > 0:
            letter_counts[name[0].upper()] += 1
    return dict[Any, int](letter_counts)

@dataclass
class RoomAssignment:
    classroom: str
    start_letter_idx: int
    end_letter_idx: int
    student_count: int
    tas_in_room: int
    letters: list[str]

    @property
    def start_letter(self):
        try:
            return self.letters[self.start_letter_idx]
        except IndexError:
            print(f"{self.start_letter_idx=}")
            print(f"{self.end_letter_idx=}")
            print(f"{self.letters=}")
            print(f"{self.classroom=}")
            print(f"{self.tas_in_room=}")
            print(f"{self.student_count=}")
            raise IndexError

    @property
    def end_letter(self):
        return self.letters[self.end_letter_idx]

    @property
    def students_per_ta(self):
        return self.student_count / self.tas_in_room

    def __str__(self):
        return f"{self.classroom}: {self.start_letter} -> {self.end_letter} | num_student: {self.student_count}\t| num_TAs: {self.tas_in_room}\t| students_per_ta: {self.students_per_ta:.1f}"

def objective_function(assignments: list[RoomAssignment]) -> float:
    """Objective function to minimize the max absolute difference in Students per TA."""
    min_ = float('inf')
    max_ = float('-inf')
    for assignment in assignments:
        students_per_ta = assignment.students_per_ta
        min_ = min(min_, students_per_ta)
        max_ = max(max_, students_per_ta)
    return max_ - min_

def calculate_letter_ranges(classroom_names: list[str], last_names: list[str], tas_per_room: dict[str, int]) -> list[RoomAssignment]:
    """Calculate which letter ranges should go to each classroom using optimized randomized cutoffs.
    
    Returns a list of tuples:
        - the classroom name
        - the starting letter
        - the ending letter
        - the number of students in that range
    """
    assert isinstance(classroom_names, list), f"Classroom names must be a list. Got: {classroom_names}"
    assert isinstance(last_names, list), f"Last names must be a list. Got: {last_names}"
    assert isinstance(tas_per_room, dict), f"TAs per room must be a dict. Got: {tas_per_room}"
    letter_dist = get_first_letter_distribution(last_names)
    assert len(letter_dist) == 26, "There should be 26 letters in the distribution"
    total_students = len(last_names)
    letters = sorted(letter_dist.keys())
    best_obj_val = float('inf')
    best_assignments: list[RoomAssignment] = []

    for _ in range(100000):
        assignments = [RoomAssignment(classroom_name, -1, -1, student_count=0, tas_in_room=tas_per_room[classroom_name], letters=letters) for classroom_name in classroom_names]
        assignments[0].start_letter_idx = 0
        assignments[-1].end_letter_idx = 25

        failed = False
        for i in range(0, len(classroom_names) - 1):

            if assignments[i].start_letter_idx >= 25 - 3:
                failed = True
                break

            # The latest that the end index can be is 23 because the last assignment can at its smallest be Y-Z (idx=24 -> idx=24)
            random_letter_idx = random.randint(assignments[i].start_letter_idx + 1, 23)
            assignments[i].end_letter_idx = random_letter_idx
            assignments[i+1].start_letter_idx = random_letter_idx + 1
            for j in range(assignments[i].start_letter_idx, assignments[i].end_letter_idx + 1):
                assignments[i].student_count += letter_dist[letters[j]]

        if failed:
            continue

        # Calculate student count for the last room
        last_room_idx = len(classroom_names) - 1
        for j in range(assignments[last_room_idx].start_letter_idx, assignments[last_room_idx].end_letter_idx + 1):
            assignments[last_room_idx].student_count += letter_dist[letters[j]]

        student_count_sum = sum(assignment.student_count for assignment in assignments)
        assert student_count_sum == total_students, f"Student count sum: {student_count_sum} != {total_students}"

        obj_val = objective_function(assignments)
        if obj_val < best_obj_val:
            best_obj_val = obj_val
            best_assignments = assignments
    return best_assignments


def print_assignments(assignments: list[RoomAssignment], last_names: list[str], classroom_capacities: dict[str, int]):
    print("=" * 120)
    total_assigned = 0
    letters = sorted(get_first_letter_distribution(last_names).keys())
    for i, assignment in enumerate(assignments):
        start_letter = letters[assignment.start_letter_idx]
        end_letter = letters[assignment.end_letter_idx]
        capacity = classroom_capacities[assignment.classroom]
        room_filled_percentage = (assignment.student_count / capacity) * 100
        students_per_ta = assignment.student_count / assignment.tas_in_room if assignment.tas_in_room > 0 else 0
        total_assigned += assignment.student_count
        print(f"{assignment.classroom}: {start_letter} -> {end_letter}\t| {assignment.student_count} students\t| {assignment.tas_in_room} TAs\t|  room: {assignment.student_count} / {capacity}\t({room_filled_percentage:.1f}%)\t|  Students per TA: {students_per_ta:.1f}")


def get_highest_room_fill_percentage(assignments: list[RoomAssignment], classroom_capacities: dict[str, int]) -> float:
    highest_room_fill_percentage = float('-inf')
    for assignment in assignments:
        capacity = classroom_capacities[assignment.classroom]
        room_filled_percentage = (assignment.student_count / capacity) * 100
        highest_room_fill_percentage = max(highest_room_fill_percentage, room_filled_percentage)
    return highest_room_fill_percentage


def get_number_per_starting_letter(last_names: list[str]) -> dict[str, int]:
    number_per_starting_letter = defaultdict(int)
    for name in last_names:
        number_per_starting_letter[name[0].upper()] += 1
    return dict[Any, int](number_per_starting_letter)


def main():
    parser = argparse.ArgumentParser(description='Allocate students to classrooms based on last name ranges')
    parser.add_argument('--classrooms', nargs='+', required=True, 
                       help='List of classroom names with capacities (e.g., "SGM 123:331")')
    parser.add_argument('--tas_per_room', type=int, nargs='+', required=True,
                       help='List of TAs per room (must match number of classrooms)')
    parser.add_argument('--roster_csv_filepath', required=True,
                       help='Path to the roster CSV file')
    
    args = parser.parse_args()
    
    # Parse classrooms and capacities from combined format
    tas_per_room = {}
    classroom_capacities = {}
    for i, classroom_spec in enumerate(args.classrooms):
        assert ':' in classroom_spec, f"Classroom specification must include capacity with ':' separator (e.g., 'SGM 123:331'). Got: {classroom_spec}"
        parts = classroom_spec.split(':', 1)
        assert len(parts) == 2, f"Invalid classroom specification format: {classroom_spec}. Expected format: 'ClassroomName:Capacity'"
        classroom_name = parts[0].strip()
        capacity = int(parts[1].strip())
        classroom_capacities[classroom_name] = capacity
        tas_per_room[classroom_name] = args.tas_per_room[i]

    # Read roster
    classroom_names = list(classroom_capacities.keys())
    last_names = read_roster(args.roster_csv_filepath)
    number_per_starting_letter = get_number_per_starting_letter(last_names)
    print()
    for letter, number in number_per_starting_letter.items():
        print(f"{letter}: {number}")
    print()

    best_assignments = None
    min_max_room_fill_percentage = float('inf')
    for _ in range(25):

        # Calculate assignments
        random.shuffle(classroom_names)
        assignments = calculate_letter_ranges(classroom_names, last_names, tas_per_room)

        # Output results using optimized assignments
        # print("\nClassroom Assignments:")
        highest_room_fill_percentage = get_highest_room_fill_percentage(assignments, classroom_capacities)
        if highest_room_fill_percentage < min_max_room_fill_percentage:
            print_assignments(assignments, last_names, classroom_capacities)
            min_max_room_fill_percentage = highest_room_fill_percentage
            best_assignments = assignments

    assert best_assignments is not None, "Best assignments are not found"
    # Calculate and display distribution statistics

    # Output results using optimized assignments
    print("\nBest assignments:")
    print_assignments(best_assignments, last_names, classroom_capacities)

    students_per_ta_values = []
    for assignment in best_assignments:
        students_per_ta = assignment.student_count / assignment.tas_in_room if assignment.tas_in_room > 0 else 0
        students_per_ta_values.append(students_per_ta)
    avg_students_per_ta = sum(students_per_ta_values) / len(students_per_ta_values)
    min_students_per_ta = min(students_per_ta_values)
    max_students_per_ta = max(students_per_ta_values)
    print(f"\nDistribution Statistics:")
    print(f"Average students per TA: {avg_students_per_ta:.1f}")
    print(f"Min students per TA: {min_students_per_ta:.1f}")
    print(f"Max students per TA: {max_students_per_ta:.1f}")
    # print(f"Standard deviation: {std_dev:.1f}")
    print(f"Range: {max_students_per_ta - min_students_per_ta:.1f}")

if __name__ == "__main__":

    main()