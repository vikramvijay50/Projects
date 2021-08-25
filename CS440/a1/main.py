from queue import Queue
import math
#from random import seed
from random import randint
import time

maze_size = 0
start_stateX = 0
start_stateY = 0
goal_stateX = 0
goal_stateY = 0
algorithm = 0
maze = 0
maze_file = ""

def randomise_numbers(startX, startY, goalX, goalY):


  startX = 16
  startY = 20
  goalX = 92
  goalY = 16

  #print(startX, startY, goalX, goalY)

  #print (format(startX, '03d'))

  return startX, startY, goalX, goalY


def randomise_problem(problem_file, startX, startY, goalX, goalY):

  #matrixtest = load_maze(maze_file)
  
  '''
  if matrixtest[startX][startY] == "1":
    print("Re-randomising!")
    startX, startY, goalX, goalY = randomise_numbers(maze_file, startX, startY, goalX, goalY)

  if matrixtest[goalX][goalY] == "1":
    print("Re-randomising!")
    startX, startY, goalX, goalY = randomise_numbers(maze_file, startX, startY, goalX, goalY)
  '''
  
  file1 = open(problem_file, "w+")

  file1.write("101\n")
  file1.write("{0} {1}\n".format(16, 20))
  file1.write("{0} {1}\n".format(92, 16))
  file1.write("0\n")
  file1.write("000")

  file1.close()
  read_problem("problem.txt")

  print('startX: ', startX, '; startY: ', startY)
  print('goalX: ', goalX, '; goalY: ', goalY)


  BFSefftotal=0
  DFSefftotal=0
  Astar1=0
  Astar2=0
  Astar3=0

  BFSsuccess=0
  DFSsuccess=0
  Astarsuccess1=0
  Astarsuccess2=0
  Astarsuccess3=0

  BFStimetotal=0
  DFStimetotal=0
  Astar1timetotal = 0
  Astar2timetotal = 0
  Astar3timetotal = 0

  for mazenum in range(1):

    mazenum1 = '{0:03d}'.format(mazenum)
    print()
    print('////////////////////// Maze number:', mazenum1)
    print()

    read_problem("problem.txt")

    maze_file1 = "mazes/maze_" + mazenum1 + ".txt"
    #print(maze_file1)
    file1 = open(problem_file, "w+")

    file1.write("101\n")
    file1.write("{0} {1}\n".format(16, 20))
    file1.write("{0} {1}\n".format(92, 16))
    file1.write("0\n")
    file1.write("{0}".format(mazenum1))
    file1.close()

    maze0 = load_maze(maze_file1)

    matrixtest = load_maze(maze_file1)

    if matrixtest[startX][startY] == "1":
      print("Re-randomising!")
      startX, startY, goalX, goalY = randomise_numbers(startX, startY, goalX, goalY)
      file1 = open(problem_file, "w+")
      file1.write("101\n")
      file1.write("{0} {1}\n".format(16, 20))
      file1.write("{0} {1}\n".format(92, 16))
      file1.write("0\n")
      file1.write("{0}".format(mazenum1))

      file1.close()

      print('NEW startX: ', startX, '| NEW startY: ', startY)
      print()
      #print('goalX: ', goalX, '; goalY: ', goalY)

    if matrixtest[goalX][goalY] == "1":
      print("Re-randomising!")
      startX, startY, goalX, goalY = randomise_numbers(startX, startY, goalX, goalY)
      file1 = open(problem_file, "w+")
      file1.write("101\n")
      file1.write("{0} {1}\n".format(16, 20))
      file1.write("{0} {1}\n".format(92, 16))
      file1.write("0\n")
      file1.write("{0}".format(mazenum1))

      file1.close()

      print('NEW goalX: ', goalX, '| NEW goalY: ', goalY)
      print()

    row1 = int(start_stateX)
    col1 = int(start_stateY)
    goalX1 = int(goal_stateX)
    goalY1 = int(goal_stateY)

    distX = abs(goalX1 - row1)
    distY = abs(goalY1 - col1)
    distX2 = distX**2
    distY2 = distY**2
    dist2 = distX2+distY2
    dist = math.sqrt(dist2)
    print("Distance is ", dist)

    algoI = [3]
    for a in algoI:

      file1 = open(problem_file, "w+")

      file1.write("101\n")
      file1.write("{0} {1}\n".format(16, 20))
      file1.write("{0} {1}\n".format(92, 16))
      file1.write("0\n")
      file1.write("000")

      file1.close()

      algo = a
      print()
      print('---------- Algorithm:', algo)

      if algo == 0:
        
        BFStimestart=time.time()

        print("BFS Start!")
        read_problem("problem.txt")
        maze0 = load_maze(maze_file1)
        BFSeff, success0 = mazeBFS0(maze0, maze_size, start_stateX, start_stateY, goal_stateX, goal_stateY)

        BFStimeend = time.time()

        BFStime = BFStimeend - BFStimestart
        BFStimetotal = BFStimetotal + BFStime
      
        BFSefftotal = BFSefftotal + BFSeff
        print("BFSefftotal is ", BFSefftotal)
        BFSsuccess = BFSsuccess+success0
        
        #DFSeff

      if algo == 1:

        DFStimestart = time.time()
        
        print("DFS Start!")
        read_problem("problem.txt")
        maze1 = load_maze(maze_file1)
        limit1, success1 = mazeDFS0(maze1, maze_size, start_stateX, start_stateY, goal_stateX, goal_stateY)

        DFStimeend = time.time()

        DFStime = DFStimeend-DFStimestart
        DFStimetotal = DFStimetotal + DFStime

        DFSeff = limit1/dist
        DFSefftotal = DFSefftotal + DFSeff
        print("DFSefftotal is ",DFSefftotal)
        DFSsuccess = DFSsuccess+success1

      if algo == 2:

        Astar1timestart = time.time()

        print("Astar Start!")
        read_problem("problem.txt")
        maze0 = load_maze(maze_file1)
        path = astarsearch(maze0, start_stateX, start_stateY, goal_stateX, goal_stateY, algo)

        Astar1timeend = time.time()

        Astar1time = Astar1timeend - Astar1timestart

        Astar1timetotal = Astar1timetotal + Astar1time

        if(path != None):
          #print(path)
          i = 0
          for node in path:
            x = node.positionX
            y = node.positionY
            if i == 0 or i == len(path):
              maze0[x][y] = "$"
            else:
              maze0[x][y] = "*"
          #print_maze(maze0)
          show(maze0)
          print('Steps to goal: {0}'.format(len(path)))

          if algo == 2:
            pathcount1 = ('{0}'.format(len(path)))
            pathcount1 = int(pathcount1)
            #print(pathcount1)
            Astar1 = Astar1 + pathcount1
            Astarsuccess1 = Astarsuccess1 + 1
        else:
          print("No Path Found")

      if algo == 3:

        Astar2timestart = time.time()
        
        print("Astar Start!")
        read_problem("problem.txt")
        maze0 = load_maze(maze_file1)
        path = astarsearch(maze0, start_stateX, start_stateY, goal_stateX, goal_stateY, algo)

        Astar2timeend = time.time()

        Astar2time = Astar2timeend - Astar2timestart

        Astar2timetotal = Astar2timetotal + Astar2time

        if(path != None):
          #print(path)
          i = 0
          for node in path:
            x = node.positionX
            y = node.positionY
            if i == 0 or i == len(path):
              maze0[x][y] = "$"
            else:
              maze0[x][y] = "*"
          #print_maze(maze0)
          show(maze0)
          print('Steps to goal: {0}'.format(len(path)))
          if algo == 3:
            pathcount2 = ('{0}'.format(len(path)))
            pathcount2 = int(pathcount2)
            #print(pathcount1)
            Astar2 = Astar2 + pathcount2
            Astarsuccess2 = Astarsuccess2 + 1
        else:
          print("No Path Found")

      if algo == 4:
        print("Astar Start!")
        read_problem("problem.txt")

        Astar3timestart = time.time()

        maze0 = load_maze(maze_file1)
        path = astarsearch(maze0, start_stateX, start_stateY, goal_stateX, goal_stateY, algo)
        
        Astar3timeend = time.time()

        Astar3time = Astar3timeend - Astar3timestart

        Astar3timetotal = Astar3timetotal + Astar3time

        if(path != None):
          #print(path)
          i = 0
          for node in path:
            x = node.positionX
            y = node.positionY
            if i == 0 or i == len(path):
              maze0[x][y] = "$"
            else:
              maze0[x][y] = "*"
          #print_maze(maze0)
          show(maze0)
          print('Steps to goal: {0}'.format(len(path)))

          if algo == 4:
            pathcount3 = ('{0}'.format(len(path)))
            pathcount3 = int(pathcount3)
            #print(pathcount1)
            Astar3 = Astar3 + pathcount3
            Astarsuccess3 = Astarsuccess3 + 1
        else:
          print("No Path Found")

  BFStimeavg = BFStimetotal/(mazenum+1)
  DFStimeavg = DFStimetotal/(mazenum+1)
  Astar1timeavg = Astar1timetotal/(mazenum+1)
  Astar2timeavg = Astar2timetotal/(mazenum+1)
  Astar3timeavg = Astar3timetotal/(mazenum+1)

  print()
  print("<<<<<<<<<<<<<< RESULTS >>>>>>>>>>>>>>>")
  avgBFSeff = BFSefftotal/(mazenum+1)
  print()
  print("Average efficiency (moves per int distance) of Algorithm 0: ",avgBFSeff)
  print("Successful Algorithm 0 finds: ", BFSsuccess," out of ", (mazenum+1))
  print("Average runtime for Algorithm 0: ", BFStimeavg)

  avgDFSeff = DFSefftotal/(mazenum+1)
  print()
  print("Average efficiency (moves per int distance) of Algorithm 1: ",avgDFSeff)
  print("Successful Algorithm 1 finds: ", DFSsuccess," out of ", (mazenum+1))
  print("Avergae runtime for Algorithm 1: ", DFStimeavg)

  #print('Steps to goal: {0}'.format(len(path)))


  avgAstareff = int(Astar1)/(mazenum+1)
  print()
  print("Average efficiency (moves per int distance) of Algorithm 2: ",avgAstareff)
  print("Successful Algorithm 2 finds: ", Astarsuccess1," out of ", (mazenum+1))
  print("Average runtime for Algorithm 2: ", Astar1timeavg)


  avgAstareff = int(Astar2)/(mazenum+1)
  print()
  print("Average efficiency (moves per int distance) of Algorithm 3: ",avgAstareff)
  print("Successful Algorithm 3 finds: ", Astarsuccess2," out of ", (mazenum+1))
  print("Average runtime for Algorithm 3: ", Astar2timeavg)


  avgAstareff = int(Astar1)/(mazenum+1)
  print()
  print("Average efficiency (moves per int distance) of Algorithm 4: ",avgAstareff)
  print("Successful Algorithm 4 finds: ", Astarsuccess3," out of ", (mazenum+1))
  print("Average runtime for Algorithm 4: ", Astar3timeavg)

  


  #file1.close()



  

      


class Node:

  def __init__(self, positionX, positionY, parent:()):
    self.positionX = int(positionX)
    self.positionY = int(positionY)
    self.parent = parent
    self.g = 0 #distance from start
    self.h = 0 #distance to goal
    self.f = 0 #total cost

  def __eq__(self, other):
    return self.positionX == other.positionX and self.positionY == other.positionY

  def __lt__(self, other):
    return self.f < other.f

  def __repr__(self):
    return ('({0},{1},{2})'.format(self.positionX, self.positionY, self.f)) 

def read_problem(problem_file):
  f = open(problem_file, "r")
  data = f.read()
  nums = data.split()

  global maze_size
  global start_stateX
  global start_stateY
  global goal_stateX
  global goal_stateY
  global algorithm
  global maze
  global maze_file
  
  maze_size = nums[0]
  start_stateX = nums[1]
  start_stateY = nums[2]
  goal_stateX = nums[3]
  goal_stateY = nums[4]
  algorithm = nums[5]
  maze = nums[6]

  maze_file = "mazes/maze_" + maze + ".txt"

  f.close

def print_problem(problem_file):
  print(maze_size)
  print(start_stateX)
  print(start_stateY)
  print(goal_stateX)
  print(goal_stateY)
  print(algorithm)
  print(maze)
  print(maze_file)
  print()

def load_maze(maze_file):
  rows, cols = (101, 101)
  maze_arr = [[0 for i in range(cols)] for j in range(rows)]

  f = open(maze_file, "r")

  numbers = f.read()
  numlist = numbers.split()
  numlistcoord = 2

  for i in range(rows):
    for j in range(cols):
      num = numlist[numlistcoord]
      maze_arr[i][j] = num
      numlistcoord += 3

  f.close()
  return maze_arr

def print_maze(maze_arr):
  for row in maze_arr:
    print(row)

def show(matrix):
    for line in matrix:
        print(*line)
    print()


def mazeBFS0(maze_arr, maze_size, start_stateX, start_stateY, goal_stateX, goal_stateY):
  
  global BFSeff
  matrix = maze_arr
  nrow = int(maze_size) 
  ncol = int(maze_size)
  goalrow = int(goal_stateX)
  goalcol = int(goal_stateY)   
  row=int(start_stateX)
  col=int(start_stateY)

  q0 = Queue()
  q0.put((row,col))

  distX = abs(goalrow - row)
  distY = abs(goalcol - col)
  distX2 = distX**2
  distY2 = distY**2
  dist2 = distX2+distY2
  dist = math.sqrt(dist2)
  print("Distance is ", dist)

  #limit0 = 0

  cost0 = 0
  success0 = 0
  #print(matrix[col][row])

  while not q0.empty():
    cost0 = cost0 + 1
    row,col = q0.get()

    #row = "16"
    #col = "20"
    
    #print(row, col)

    if row == int(goal_stateX) and col == int(goal_stateY):
      print("Path exists!")
      print("Total cost of moves is ", cost0)
      BFSeff = cost0/dist
      success0 = success0+1
      #print()
      break

      
    if col+1<ncol and matrix[row][col+1]=="0":
      q0.put((row,col+1))
      matrix[row][col+1] = "$"
    if row+1<nrow and matrix[row+1][col]=="0":
      q0.put((row+1,col))
      matrix[row+1][col] = "$"
    if 0<=(col-1) and matrix[row][col-1]== "0":
      q0.put((row,col-1))
      matrix[row][col-1] = "$"
    if 0<=(row-1) and matrix[row-1][col]=="0":
      q0.put((row-1,col))
      matrix[row-1][col] = "$"

  #result = matrix[row][col]

  show(matrix)

  return BFSeff, success0

  if row != int(goal_stateX) and col!=int(goal_stateY):
    print("Path doesn't exist")
    #print()
    return BFSeff, success0

  



result1 = 0

def mazeDFS0(maze_arr, maze_size, start_stateX, start_stateY, goal_stateX, goal_stateY):
  
  global success1
  global limit1
  global result1

  matrix = maze_arr
  nrow = int(maze_size)
  ncol = int(maze_size)
  row = int(start_stateX)
  col = int(start_stateY)
  goalX = int(goal_stateX)
  goalY = int(goal_stateY)
  
  cost1 = 0
  limit1 = 0
  success1 = 0

  maxlimit = randint(0,5000)
  print('The maximum limit for this DFS: ', maxlimit)

  result1 = 0

  try:
    #print('test0')
    result1 = DFS1(matrix, nrow, ncol, row, col, goalX, goalY, cost1, maxlimit)
    show(matrix)
  except RecursionError:
    print("DFS has got itself stuck!\nPath not found!")
    print("Depth achieved: ", limit1)


  

  if limit1 == maxlimit:
    print("The maximum limit for this depth-limited search has been reached.\n Path not found!")
    return limit1, success1

  #print("Result1 is: ", result1)

  if result1 != 2:
    print ('Path does not exist.')
    return limit1, success1

  return limit1, success1


  #else:
    #show(matrix)

  #print('Total cost of moves is ', cost1)

  #test1 = matrix[nrow - 1][ncol - 1]

  #for m in matrix:
  #  print(m)

  

def DFS1(matrix, nrow, ncol, row, col, goalX, goalY, cost1, maxlimit):

  

  #print(maxlimit)
  global limit1
  global result1
  global success1
  #global maxlimit
  #print (row, col)
  #return result1

  #print("test2")
  #print(result1)
  #print(limit1)
  #print(maxlimit)

  if limit1 == maxlimit:
    print("The maximum limit for this depth-limited search has been reached and the path has still not been found. The algorithm will cease.")
    return result1
  
  limit1 = limit1 + 1
  
  #print(result1)

  if result1 == 2:
    #print(limit1)
    
    #print(result1)
    return result1

  if (row,col) == (goalX, goalY):
    #print("test1")
    #print()
    print((row, col))
    print("Path exists!")
    #print()
    print('Total cost of moves is ', cost1)
    #print()
    print('Depth traversed: ', limit1)
    matrix[row][col] = "V"
    result1 = 2
    #print("result1 is ",result1)
    print("Total cost of moves is ", limit1)
    success1 = success1 + 1
    DFS1(matrix, nrow, ncol, row, col, goalX, goalY, cost1, maxlimit)
  
  '''if (row,col) == (startX, startY):
    matrix[row][col] = "V"
    result1 = 2'''
    

  if result1 != 2:
    if limit1 !=maxlimit:
      if col + 1 < ncol and matrix[row][col + 1] == "0" and result1 != 2 and limit1 != maxlimit:
        matrix[row][col+1] = "$"
        cost1 = cost1 + 1
        #print((row, col), 'go L')
        DFS1(matrix, nrow, ncol, row, col + 1, goalX, goalY, cost1, maxlimit)

      
      if row + 1 < nrow and matrix[row + 1][col] == "0" and result1 != 2 and limit1 != maxlimit:
        matrix[row+1][col] = "$"
        cost1 += 2
        #print((row, col), 'go U')
        DFS1(matrix, nrow, ncol, row + 1, col, goalX, goalY, cost1, maxlimit)

      if 0 <= col - 1 and matrix[row][col - 1] == "0" and result1 != 2 and limit1 != maxlimit:
        matrix[row][col-1] = "$"
        cost1 += 1
        #print((row, col), 'go R')
        DFS1(matrix, nrow, ncol, row, col - 1, goalX, goalY, cost1, maxlimit)

      if 0 <= row - 1 and matrix[row - 1][col] == "0" and result1 != 2 and limit1 != maxlimit:
        matrix[row-1][col] = "$"
        cost1 += 2
        #print((row, col), 'go D')
        DFS1(matrix, nrow, ncol, row - 1, col, goalX, goalY, cost1, maxlimit)

 
  return result1




    
  


def add_to_open(open, neighbor):
  #print('List length: {0}'.format(len(open)))
  for node in open:
    if(neighbor == node and neighbor.f >= node.f):
      return False
  return True

def astarsearch(grid, startx, starty, goalx, goaly, algo):
  open = []
  closed = []

  start_node = Node(startx, starty, None)
  goal_node = Node(goalx, goaly, None)

  open.append(start_node)

  while len(open) > 0:
    open.sort()
    #print(open)
    
    current_node = open.pop(0)

    closed.append(current_node)

    if current_node == goal_node:
      print("Found goal!")
      path = []
      while current_node != start_node:
        path.append(current_node)
        current_node = current_node.parent
      return path[::-1]

    x = int(current_node.positionX)
    y = int(current_node.positionY)

    neighbors = [(x-1, y), (x+1, y), (x, y-1), (x, y+1)]

    for next, next2 in neighbors:
      #print(next)
      #print(next2)
      try:
        space_value = grid[next][next2]
      except:
        return None

      if(space_value == '1'):
        #print("will continue")
        continue

      neighbor = Node(next, next2, current_node)

      if(neighbor in closed):
        #print("will continue2")
        continue

      if algo == 2:
        neighbor.g = int(abs(neighbor.positionX - start_node.positionX) + abs(neighbor.positionY - start_node.positionY))
        #print('g value: {0}'.format(neighbor.g))

        neighbor.h = int(abs(neighbor.positionX - goal_node.positionX) + abs(neighbor.positionY - goal_node.positionY))
        #print('h value: {0}'.format(neighbor.h))

        neighbor.f = int(neighbor.g + neighbor.h)
        #print('f value: {0}'.format(neighbor.f))

      if algo == 3:
        euclideanG = int(math.sqrt((neighbor.positionX - start_node.positionX) ** 2) + math.sqrt((neighbor.positionY - start_node.positionY) ** 2))
        
        manhattanG = int(abs(neighbor.positionX - start_node.positionX) + abs(neighbor.positionY - start_node.positionY))

        neighbor.g = min(euclideanG, manhattanG)
        #print('g value: {0}'.format(neighbor.g))

        euclideanH = int(math.sqrt((neighbor.positionX - goal_node.positionX) ** 2) + math.sqrt((neighbor.positionY - goal_node.positionY) ** 2))

        manhattanH = int(abs(neighbor.positionX - goal_node.positionX) + abs(neighbor.positionY - goal_node.positionY))                
        neighbor.h = min(euclideanH, manhattanH)
        #print('h value: {0}'.format(neighbor.h))

        neighbor.f = int(neighbor.g + neighbor.h)
        #print('f value: {0}'.format(neighbor.f))
      
      if algo == 4:
        g1 = start_node.positionX - goal_node.positionX
        g2 = start_node.positionY - goal_node.positionY
        h1 = neighbor.positionX - goal_node.positionX
        h2 = neighbor.positionY - goal_node.positionY
        neighbor.g = g1 + g2
        neighbor.h = h1 + h2
        cross = abs(g1*h2 - h1*g2)
        neighbor.f += cross*0.001

      check = add_to_open(open, neighbor)
      if(check == True):
        #print("can append")
        open.append(neighbor)
      #print('List length: {0}'.format(len(open)))

  return None

print("_______________ Start! _______________")
print()
read_problem("problem.txt")

#maze0 = load_maze(maze_file)

startX = int(start_stateX)
startY = int(start_stateY)
goalX = int(goal_stateX)
goalY = int(goal_stateY)
startX, startY, goalX, goalY = randomise_numbers(startX, startY, goalX, goalY)

randomise_problem("problem.txt", startX, startY, goalX, goalY)

algo = int(algorithm)