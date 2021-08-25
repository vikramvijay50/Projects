package trie;

import java.util.ArrayList;

/**
 * This class implements a Trie. 
 * 
 * @author Sesh Venugopal
 *
 */
public class Trie {
	
	// prevent instantiation
	private Trie() { }
	
	/**
	 * Builds a trie by inserting all words in the input array, one at a time,
	 * in sequence FROM FIRST TO LAST. (The sequence is IMPORTANT!)
	 * The words in the input array are all lower case.
	 * 
	 * @param allWords Input array of words (lowercase) to be inserted.
	 * @return Root of trie with all words inserted from the input array
	 */
	public static TrieNode buildTrie(String[] allWords) {
		/** COMPLETE THIS METHOD **/
		TrieNode root = new TrieNode(null, null, null);
		
		for(int i = 0; i < allWords.length; i++) {
			TrieNode curr = root;
			String s1 = allWords[i];
			boolean nodeAdded = false;
			int prevPrefixLength = 0;
			while(true) {
				if(curr.firstChild != null) {
					TrieNode prevChild = null;
					TrieNode currChild = curr.firstChild;
					short prefixLength = 0;
					while(currChild != null) {
						String s2 = allWords[currChild.substr.wordIndex].substring(0, (short) currChild.substr.endIndex + 1);
						prefixLength = (short) (prefixFinder(s1, s2) - prevPrefixLength);
						if(prefixLength > 0) {
							break;
						}
						prevChild = currChild;
						currChild = currChild.sibling;
					}
					if(prefixLength > 0) {
						prevPrefixLength = prefixLength;
						curr = currChild;
					}
					else {
						Indexes indices = new Indexes(i, (short) (prevPrefixLength), (short) (s1.length()-1));
						prevChild.sibling = new TrieNode(indices, null, null);
						nodeAdded = true;
						break;
					}
				} else {
					Indexes indices = new Indexes(i, (short) (prevPrefixLength), (short) (s1.length()-1));
					if(curr == root) {
						curr.firstChild = new TrieNode(indices, null, null);
					} else {
						int oldEndIndex = curr.substr.endIndex;
						curr.substr.endIndex = (short) (curr.substr.startIndex + prevPrefixLength - 1);
						Indexes firstChildIndex = new Indexes(curr.substr.wordIndex, (short) (curr.substr.startIndex + prevPrefixLength), (short) oldEndIndex);
						curr.firstChild = new TrieNode(firstChildIndex, null, null);
						indices.startIndex += curr.substr.startIndex;
						curr.firstChild.sibling = new TrieNode(indices, null, null);
					}
					nodeAdded = true;
					break;
				}		
			}
		}
		return root;
	}
	
	private static int prefixFinder(String s1, String s2) {
		if(s1.length() > s2.length()) {
			return prefixFinder(s2, s1);
		}
		for(int i = 0; i < s1.length(); i++) {
			if(s1.charAt(i) != s2.charAt(i)) {
				return i;
			}
		}
		return s1.length();
	}
	
	
	/**
	 * Given a trie, returns the "completion list" for a prefix, i.e. all the leaf nodes in the 
	 * trie whose words start with this prefix. 
	 * For instance, if the trie had the words "bear", "bull", "stock", and "bell",
	 * the completion list for prefix "b" would be the leaf nodes that hold "bear", "bull", and "bell"; 
	 * for prefix "be", the completion would be the leaf nodes that hold "bear" and "bell", 
	 * and for prefix "bell", completion would be the leaf node that holds "bell". 
	 * (The last example shows that an input prefix can be an entire word.) 
	 * The order of returned leaf nodes DOES NOT MATTER. So, for prefix "be",
	 * the returned list of leaf nodes can be either hold [bear,bell] or [bell,bear].
	 *
	 * @param root Root of Trie that stores all words to search on for completion lists
	 * @param allWords Array of words that have been inserted into the trie
	 * @param prefix Prefix to be completed with words in trie
	 * @return List of all leaf nodes in trie that hold words that start with the prefix, 
	 * 			order of leaf nodes does not matter.
	 *         If there is no word in the tree that has this prefix, null is returned.
	 */
	public static ArrayList<TrieNode> completionList(TrieNode root,
										String[] allWords, String prefix) {
		if(root == null) return null;
		
		TrieNode ptr = root;
		ArrayList<TrieNode> cList = new ArrayList<>();
		
		while(ptr != null) {
			
			if(ptr.substr == null) 
				ptr = ptr.firstChild;
			
			String word1 = allWords[ptr.substr.wordIndex];
			String word2 = word1.substring(0, ptr.substr.endIndex+1);
			if(word1.startsWith(prefix) || prefix.startsWith(word2)) {
				if(ptr.firstChild != null) { 
					cList.addAll(completionList(ptr.firstChild, allWords, prefix));
					ptr = ptr.sibling;
				} else { 
					cList.add(ptr);
					ptr = ptr.sibling;
				}
			} else {
				ptr = ptr.sibling;
			}
		}
		
		return cList;
		
	}
	
	public static void print(TrieNode root, String[] allWords) {
		System.out.println("\nTRIE\n");
		print(root, 1, allWords);
	}
	
	private static void print(TrieNode root, int indent, String[] words) {
		if (root == null) {
			return;
		}
		for (int i=0; i < indent-1; i++) {
			System.out.print("    ");
		}
		
		if (root.substr != null) {
			String pre = words[root.substr.wordIndex]
							.substring(0, root.substr.endIndex+1);
			System.out.println("      " + pre);
		}
		
		for (int i=0; i < indent-1; i++) {
			System.out.print("    ");
		}
		System.out.print(" ---");
		if (root.substr == null) {
			System.out.println("root");
		} else {
			System.out.println(root.substr);
		}
		
		for (TrieNode ptr=root.firstChild; ptr != null; ptr=ptr.sibling) {
			for (int i=0; i < indent-1; i++) {
				System.out.print("    ");
			}
			System.out.println("     |");
			print(ptr, indent+1, words);
		}
	}
 }
