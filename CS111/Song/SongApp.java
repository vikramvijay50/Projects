
/*
*
* This class implements a library of songs
*
* @Anna Masciandaro CS111 - Rutgers University
*
*/
public class SongApp
{
  private Song[] items;      // keep Songs in an unsorted array
  private int numberOfItems; // number of Songs in the array
  /*
  * Default constructor creates array with capacity for 5 Songs
  */
  SongApp()
  {
    items = new Song [5];
  }
  /*
  * One argument constructor creates array with user defines capacity
  *
  * @param capacity defines the capacity of the Song library
  */
  SongApp(int capacity)
  {
    items = new Song [capacity];
  }
  /*
  * Add a Song into the library (unsorted array)
  *
  * If the library is full (there is not enough space to add another Song)
  *   - create a new array with double the size of the current array.
  *   - copy all current Songs into new array
  *   - add new Song
  *
  * @param m The Song to be added to the libary
  */
  public void addSong(Song m)
  {
      int pos = -1;
      for (int i = 0; i < items.length; i++)
      {
        if (items[i] == null)
        {
          pos = i;
          break;
        }
      }
      if (pos > -1)
      {
        items[pos] = m;
        numberOfItems++;
      }
      else
      {
        Song[] temp = new Song[items.length * 2];

        int i;
        for (i = 0; i < items.length; i++)
        {
          temp[i] = items[i];
        }
        temp[i] = m;
        items = temp;
        numberOfItems++;
      }
  }
  /*
  * Removes a Song from the library. Returns true if Song is removed, false
  * otherwise.
  * The array should not become sparse after a remove, that is, all Songs
  * should be in consecutive indexes in the array.
  *
  * @param m The Song to be removed
  *
  */
  public boolean removeSong(Song m) //FIXED???
  {
    boolean removed = false;
    int c = 0;
    while (c < numberOfItems && removed == false)
    {
      if (items[c].equals(m))
      {
        items[c] = null;
        removed = true;
        for (int c1 = c; c1 < numberOfItems-1; c1++)
        {
          items[c1] = items[c1+1];
        }
        items[numberOfItems-1] = null;
        numberOfItems--;
      }
      c++;
    }
    return removed;
  }
  /*
  * Returns the library of songs
  *
  * @return The array of Songs
  */
  public Song[] getSongs()
  {
    return items;
  }
  /*
  * Returns the current number of Songs in the library
  *
  * @return The number of items in the array
  */
  public int getNumberOfItems()
  {
    return numberOfItems;
  }
  /*
  * Update the rating of Song @m to @rating
  *
  * @param @m The Song to have its ratings updated
  * @param @rating The new rating of @m
  * @return tue if update is successfull, false otherwise
  *
  */
  public boolean updateRating(Song m, int rating) //FIXED???
  {
    if (rating >= 1 && rating <= 5)
    {
      boolean found = false;
      Song songm = null;
      int c = 0;
      while (!(items[c].equals(m)) && c < numberOfItems)
      {
        c++;
      }
      if (items[c].equals(m))
      {
        songm = items[c];
        songm.setRating(rating);
        found = true;
      }
      return found;
    }
    else
    {
      return false;
    }
  }
  /*
  * Prints all Songs
  */
  public void print()
  {
    for (int c = 0; c < numberOfItems; c++)
    {
      System.out.println(items[c].toString());
    }
  }
  /*
  * Return all the Songs by @songwriter. The array size should be the
  * number of Songs by @songwriter.
  *
  * @param songwriter The songwriter's name
  * @param An array of all the Songs by @songwriter
  *
  */
  public Song[] getSongsBySongwriter(String songwriter) //???
  {
    int tracker = 0;
    boolean found = false;
    Song[] songlist = new Song[numberOfItems];
    for (int c = 0; c < numberOfItems; c++)
    {
      String [] songwriters = items[c].getWriters();
      found = false;
      for (int c1 = 0; c1 < items[c].getNumberOfWriters(); c1++)
      {
        if (songwriters[c1].equals(songwriter))
        {
          found = true;
          songlist[tracker] = items[c];
          tracker++;
        }
      }
    }
    int nullStart = 0;
    while ((songlist[nullStart]!=null) && (nullStart < numberOfItems))
    {
      nullStart++;
    }
    Song[] songlist2 = new Song[nullStart];
    for (int c = 0; c < nullStart; c++)
    {
      songlist2[c] = songlist[c];
    }
    return songlist2;
  }
  /*
  * Return all the Songs released in @year. The array size should be the
  * number of Songs made in @year.
  *
  * @param year The year the Songs were made
  * @return An array of all the Songs made in @year
  *
  */
  public Song[] getSongsByYear(int year)
  {
    int count  = 0;
    for (int c = 0; c < numberOfItems; c++)
    {
      if (items[c].getYear() == year)
      {
        count++;
      }
    }
    Song [] yearSongs = new Song[count];
    int c2 = 0;
    for (int c1 = 0; c1 < numberOfItems; c1++)
    {
      if (items[c1].getYear() == year)
      {
        yearSongs[c2] = items[c1];
        c2++;
      }
    }
    return yearSongs;
  }
  /*
  * Return all the Songs with ratings greater then @rating
  *
  * @param rating
  * @return An array of all Songs with rating greater than @rating
  *
  */
  public Song[] getSongsWithRatingsGreaterThan(int rating)
  {
    int count  = 0;
    for (int c = 0; c < numberOfItems; c++)
    {
      if (items[c].getRating() > rating)
      {
        count++;
      }
    }
    Song [] ratingSongs = new Song[count];
    int c2 = 0;
    for (int c1 = 0; c1 < numberOfItems; c1++)
    {
      if (items[c1].getRating() > rating)
      {
        ratingSongs[c2] = items[c1];
        c2++;
      }
    }
    return ratingSongs;
  }

  /*
  * Search for Song name @name using binary search algorithm.
  * Assumes items is sorted
  */
  public Song searchSongByName(String name) //FIXED???
  {
    int low = 0;
    int high = numberOfItems;
    while (low <= high)
    {
       int mid = (low + high)/2;
       if (items[mid].getName().compareTo(name) == 0)
       {
         return items[mid];
       }
       else if (items[mid].getName().compareTo(name) < 0 )
       {
         low = mid + 1;
       }
       else
       {
         high = mid - 1;
       }
    }
    return null;
  }

 /*
  * Sorts Songs by year using insertion sort
  */
  public void sortByYear()
  {
    for (int i = 1; i < numberOfItems; ++i)
    {
        Song key = items[i];
        int j = i-1;
        while (j >= 0 && items[j].getYear() > key.getYear())
        {
            items[j+1] = items[j];
            j = j-1;
        }
        items[j+1] = key;
    }
  }

 /*
  * Sorts array of Songs by name using selection sort
  */
  public void sortByName() //FIXED???
  {
    Song temp;
    for (int i = 0; i < numberOfItems-1; i++)
    {
      int min = i;
      for (int j = i+1; j < numberOfItems; j++)
      {
        if (items[j].compareTo(items[min]) < 0)
        {
          min = j;
        }
      }
      temp = items[min];
      items[min] = items[i];
      items[i] = temp;
    }
  }

 /*
  * Search for Song name using recursive linear search
  * @param name The name of the song to search
  * @param Songs The array containing all songs
  * @param l The left index
  * @param r The right index
  * @return The song with name @name or null if song is not found
  */
  public static Song searchSongByName(String name, Song[] Songs, int l, int r) //FIXED???
  {
    int c = 0;
    while (c < Songs.length && Songs[c]!=null)
    {
      c++;
    }
    r = c-1;
    if (r == l)
    {
      return null;
    }
    if (Songs[l].getName().compareTo(name)==0)
    {
      return Songs[l];
    }
    if (Songs[r].getName().compareTo(name)==0)
    {
      return Songs[r];
    }
    return searchSongByName(name, Songs, l+1, r-1);
  }
}
