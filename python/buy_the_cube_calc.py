
import random
import matplotlib.pyplot as plt


def purchase_cube(cubes):

    cube_i = random.randint(0, len(cubes)-1)
    cube_val = cubes[cube_i]

    if cube_val > max_purchasable_cube_val:
        cubes.pop(cube_i)
        cubes.append(cube_val/2)
        cubes.append(cube_val/4)
        cubes.append(cube_val/8)
        cubes.append(cube_val/16)
        cubes.append(cube_val/16)
    else:
        cubes[cube_i] *= 2

if __name__ == "__main__":

    max_purchasable_cube_val = 32
    cubes = [1]
    days = 20
    users_p_day = 25

    cubes_p_day = []
    for day_i in range(days):
        for purchase_i in range(users_p_day):
            purchase_cube(cubes)

        cubes_p_day.append(len(cubes))
        print("day:",day_i,"\t #cubes:",len(cubes),"\t->",cubes)

    plt.plot(range(0,days),cubes_p_day)
    plt.ylabel('some numbers')
    plt.show()
    print("total value:",sum(cubes))

