
public class Song {

	private String name = "";
	private int year = 0;
	private int numberOfWriters = 0;
	private String[] writers = new String[50];
	private int rating = 0;
	
	public static void main(String[] args) {

		Song song1 = new Song("apples");
		Song song2 = new Song("apples");
		
		//song1.setName("carrot");
		song1.getName();
		
		song1.setYear(2);
		song1.getYear();
		
		song2.setYear(2);
		
		song1.setRating(4);
		song1.getRating();
		
		song1.addWriter("john");
		song1.addWriter("george");
		song1.addWriter("gg");
		
		song2.addWriter("john");
		song2.addWriter("george");
		song2.addWriter("gg");
		
		System.out.println(song1.getNumberOfWriters());
		
		System.out.println(song1.getWriterAtIndex(1));
		
		System.out.println(song1.toString());
		
		System.out.println(song1.compareTo(song2));
		
		System.out.println(song1.equals(song2));
		
	}
	
	public Song(String name) {
		this.name = name;
	}
	
	public void setName(String name) {
		this.name = name;
	}
	
	public String getName(){
		return name;
	}
	
	public void setYear(int year){
		this.year = year;
	}
	
	public int getYear(){
		return year;
	}
	
	public void setRating(int rating){
		this.rating = rating;
	}
	
	public int getRating(){
		return rating;
	}
	
	public void addWriter(String writerName){
		writers[numberOfWriters] = writerName;
		numberOfWriters++;
	}
	
	public String[] getWriters(){
		return writers;
	}
	
	public int getNumberOfWriters(){
		return numberOfWriters;
	}
	
	public String getWriterAtIndex(int index){
		return writers[index];
	}
	
	public String toString(){
		return name + ", " +  year + ", " + rating;
	}
	
	public boolean equals(Object other){
		
		boolean sameName = false;
		boolean sameYear = false;
		boolean sameWriters = false;
		
		Song otherSong = (Song) other;
		
		if(this.name == otherSong.getName())
			sameName = true;
		if(this.year == otherSong.getYear())
			sameYear = true;
		
		if(numberOfWriters != otherSong.getNumberOfWriters())
			sameWriters = false;
		else {
			String[] writers2 = otherSong.getWriters();
			
			for(int i = 0; i < numberOfWriters; i++) {
				for(int j = 0; j < otherSong.getNumberOfWriters(); j++) {
					if(writers[i].equals(writers2[j])){
						sameWriters = true;
						break;
					}
					else
						sameWriters = false;
				}
			}
		}
		
		if(sameName == true && sameYear == true && sameWriters == true)
			return true;
		else 
			return false;
	}
	
	public int compareTo(Song other){
		if(name.compareTo(other.name) < 0) {
			return -1;
		}
		if(name.compareTo(other.name) == 0) {
			return 0;
		}
		else {
			return 1;
		}
	}
	
}
