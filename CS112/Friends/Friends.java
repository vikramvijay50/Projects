package friends;

import java.util.ArrayList;

import structures.Queue;
import structures.Stack;

public class Friends {

	/**
	 * Finds the shortest chain of people from p1 to p2.
	 * Chain is returned as a sequence of names starting with p1,
	 * and ending with p2. Each pair (n1,n2) of consecutive names in
	 * the returned chain is an edge in the graph.
	 * 
	 * @param g Graph for which shortest chain is to be found.
	 * @param p1 Person with whom the chain originates
	 * @param p2 Person at whom the chain terminates
	 * @return The shortest chain from p1 to p2. Null if there is no
	 *         path from p1 to p2
	 */
	public static ArrayList<String> shortestChain(Graph g, String p1, String p2) {
		ArrayList<String> shortest = new ArrayList<>();

		// if any input null or empty, return null
		if (g == null && p1 == null && p2 == null && p1.length() == 0 && p2.length() == 0)
		{
		   return null;
		}

		// set to lowercase just in case
		p1 = p1.toLowerCase();
		p2 = p2.toLowerCase();

		// if going to itself, just have itself in the chain
		if (p1.equals(p2))
		{
		   shortest.add(g.members[g.map.get(p1)].name);
		   return shortest;
		}

		// check if they exist, return null if not
		if (g.map.get(p1) == null || g.map.get(p2) == null)
		{
		   System.out.println("P1 or P2 does not exist!");
		   return null;
		}

		// initialize queues and arrays
		Queue<Integer> queue = new Queue<>();
		int[] dist = new int[g.members.length];
		int[] pred = new int[g.members.length];
		boolean[] visited = new boolean[g.members.length]; // number of vertices

		// fill in values of arrays
		for (int i = 0; i < visited.length; i++)
		{
		   visited[i] = false;
		   dist[i] = Integer.MAX_VALUE; // set distance to infinity
		   pred[i] = -1;
		}

		// initialize the starting person
		int startIndex = g.map.get(p1);
		Person startPerson = g.members[startIndex];

		// mark visited as true for first vertex and distance to itself as 0
		visited[startIndex] = true;
		dist[startIndex] = 0; // 0 distance from itself

		// enqueue first person and begin loop
		queue.enqueue(startIndex);
		while (!queue.isEmpty())
		{
		   // get current person
		   int v = queue.dequeue(); // current vertex index
		   Person p = g.members[v];

		   // go through all neighbors of this person
		   for (Friend ptr = p.first; ptr != null; ptr = ptr.next)
		   {
		    int fnum = ptr.fnum;

		    // if this person was not visited already
		    if (!visited[fnum])
		    {
		     // update dist, pred, and visited
		     dist[fnum] = dist[v] + 1; // one edge greater than
		            // originating vertex
		     pred[fnum] = v;
		     visited[fnum] = true;
		visited[fnum] = true;
		     queue.enqueue(fnum); // enqueue
		    }
		   }
		}

		// get path starting from p2
		Stack<String> path = new Stack<>();
		int spot = g.map.get(p2);

		// check if island and never reached
		if (!visited[spot])
		{
		   System.out.println("Cannot reach!");
		   return null;
		}

		// trace back predecessors and push into stack
		while (spot != -1)
		{
		   path.push(g.members[spot].name);
		   spot = pred[spot];
		}

		// then take from the stack and add to arraylist
		while (!path.isEmpty())
		{
		   shortest.add(path.pop());
		}

		return shortest;
	}
	
	/**
	 * Finds all cliques of students in a given school.
	 * 
	 * Returns an array list of array lists - each constituent array list contains
	 * the names of all students in a clique.
	 * 
	 * @param g Graph for which cliques are to be found.
	 * @param school Name of school
	 * @return Array list of clique array lists. Null if there is no student in the
	 *         given school
	 */
	public static ArrayList<ArrayList<String>> cliques(Graph g, String school) {
		

		// initialize answer arraylist
		ArrayList<ArrayList<String>> resultant = new ArrayList<>();

		// check nulls and empties
		if (g == null && school == null && school.length() == 0)
		{
		return null;
		}

		// make lowercase just in case
		school = school.toLowerCase();

		// make visited and mark all as false
		boolean[] visited = new boolean[g.members.length];
		for (int i = 0; i < visited.length; i++)
		{
		   visited[i] = false;
		}

		// driver for all the members
		for (Person member : g.members)
		{
		   // if it hasn't been visited and is a member of this school
		   if (!visited[g.map.get(member.name)] && member.school != null && member.school.equals(school))
		   {

		    // initialize
		    Queue<Integer> queue = new Queue<>();
		    ArrayList<String> clique = new ArrayList<>();

		    // initialize person and set visited to true
		    int startIndex = g.map.get(member.name);
		    visited[startIndex] = true;

		    // enqueue and add into the clique arraylist
		    queue.enqueue(startIndex);
		    clique.add(member.name);

		    while (!queue.isEmpty())
		    {
		     // get person
		     int v = queue.dequeue(); // current vertex index
		     Person p = g.members[v];

		     // loop through all neighbors
		     for (Friend ptr = p.first; ptr != null; ptr = ptr.next)
		     {
		      // get the friend
		      int fnum = ptr.fnum;
		      Person fr = g.members[fnum];

		      // if it was unvisited and a member of the school
		      if (!visited[fnum] && fr.school != null && fr.school.equals(school))
		      {
		       // mark as visited, enqueue, and add to clique
		    	visited[fnum] = true;
		        queue.enqueue(fnum);
		        clique.add(g.members[fnum].name);
		      }
		     }
		    }
		    // add arraylist to answers list
		    resultant.add(clique);
		   }
		}

		return resultant;
		
	}
	
	/**
	 * Finds and returns all connectors in the graph.
	 * 
	 * @param g Graph for which connectors needs to be found.
	 * @return Names of all connectors. Null if there are no connectors.
	 */
	public static ArrayList<String> connectors(Graph g) {
		

		// initalize
		boolean[] visited = new boolean[g.members.length]; // all set to false
		               // automatically
		int[] dfsnum = new int[g.members.length];
		int[] back = new int[g.members.length];
		ArrayList<String> answer = new ArrayList<>();

		// driver
		for (Person member : g.members)
		{
		   // if it hasn't been visited
		   if (!visited[g.map.get(member.name)])
		   {
		    // reset dfsnum for different islands and dfs call
		    dfsnum = new int[g.members.length];
		    dfs(g.map.get(member.name), g.map.get(member.name), g, visited, dfsnum, back, answer);
		   }
		}

		// error checking below:

		// check if only have one edge, then cannot be a connector
		for (int i = 0; i < answer.size(); i++)
		{
		   Friend ptr = g.members[g.map.get(answer.get(i))].first;

		   int count = 0;
		   while (ptr != null)
		   {
		    ptr = ptr.next;
		    count++;
		   }

		   // if no edge or only one edge
		   if (count == 0 || count == 1)
		   {
		    answer.remove(i);
		   }
		}

		// check if something has only one neighbor, then neighbor must be
		// connector
		for (Person member : g.members)
		{
		   if ((member.first.next == null && !answer.contains(g.members[member.first.fnum].name)))
		   {
		    answer.add(g.members[member.first.fnum].name);
		   }
		}
		return answer;
		}

		// find size of dfsnum because counting up and passing it back in recursion
		// does not work
		// to assign the dfsnum and back number
		private static int sizeArr(int[] arr)
		{
		int count = 0;
		for (int i = 0; i < arr.length; i++)
		{
		   if (arr[i] != 0)
		   {
		    count++;
		   }
		}
		return count;
		
	}
		
	private static void dfs(int v, int start, Graph g, boolean[] visited, int[] dfsnum, int[] back, ArrayList<String> answer) {
				// get the person and mark as visited
			Person p = g.members[v];
			visited[g.map.get(p.name)] = true;
			int count = sizeArr(dfsnum) + 1;

			// if not set, set it
			if (dfsnum[v] == 0 && back[v] == 0)
			{
				   dfsnum[v] = count;
				   back[v] = dfsnum[v];
			}

				// go through neighbors
			for (Friend ptr = p.first; ptr != null; ptr = ptr.next){
				   // if not visited
				  if (!visited[ptr.fnum]){

				    // recursive call on neighbors
				    dfs(ptr.fnum, start, g, visited, dfsnum, back, answer);

				    // after come back, check
				    if (dfsnum[v] > back[ptr.fnum]){
				     // just change the back[v] num
				     back[v] = Math.min(back[v], back[ptr.fnum]);
				    } else{
				     // trying to fix if starting point has two edges but not a
				     // connector and other issues fixed with this
				     if (Math.abs(dfsnum[v] - back[ptr.fnum]) < 1 && Math.abs(dfsnum[v] - dfsnum[ptr.fnum]) <= 1
				       && back[ptr.fnum] == 1 && v == start){
				      // don't add if both 1's
				      continue;
				     }
				// if these conditions, IS A CONNECTOR
				     if (dfsnum[v] <= back[ptr.fnum] && (v != start && back[ptr.fnum] == 1)){ // not the startng point
				      if (!answer.contains(g.members[v].name)){
				       // if not already in there, add the connector to the
				       // list
				       answer.add(g.members[v].name);
				      }
				     }

				    }
				   } else{
				    // if already visited, update back[v]
				    back[v] = Math.min(back[v], dfsnum[ptr.fnum]);
				   }
				}
				return;
		}		
}

