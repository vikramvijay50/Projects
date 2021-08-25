package bigint;

/**
 * This class encapsulates a BigInteger, i.e. a positive or negative integer with 
 * any number of digits, which overcomes the computer storage length limitation of 
 * an integer.
 * 
 */
public class BigInteger {

	/**
	 * True if this is a negative integer
	 */
	boolean negative;
	
	/**
	 * Number of digits in this integer
	 */
	int numDigits;
	
	/**
	 * Reference to the first node of this integer's linked list representation
	 * NOTE: The linked list stores the Least Significant Digit in the FIRST node.
	 * For instance, the integer 235 would be stored as:
	 *    5 --> 3  --> 2
	 *    
	 * Insignificant digits are not stored. So the integer 00235 will be stored as:
	 *    5 --> 3 --> 2  (No zeros after the last 2)        
	 */
	DigitNode front;
	
	/**
	 * Initializes this integer to a positive number with zero digits, in other
	 * words this is the 0 (zero) valued integer.
	 */
	public BigInteger() {
		negative = false;
		numDigits = 0;
		front = null;
	}
	
	/**
	 * Parses an input integer string into a corresponding BigInteger instance.
	 * A correctly formatted integer would have an optional sign as the first 
	 * character (no sign means positive), and at least one digit character
	 * (including zero). 
	 * Examples of correct format, with corresponding values
	 *      Format     Value
	 *       +0            0
	 *       -0            0
	 *       +123        123
	 *       1023       1023
	 *       0012         12  
	 *       0             0
	 *       -123       -123
	 *       -001         -1
	 *       +000          0
	 *       
	 * Leading and trailing spaces are ignored. So "  +123  " will still parse 
	 * correctly, as +123, after ignoring leading and trailing spaces in the input
	 * string.
	 * 
	 * Spaces between digits are not ignored. So "12  345" will not parse as
	 * an integer - the input is incorrectly formatted.
	 * 
	 * An integer with value 0 will correspond to a null (empty) list - see the BigInteger
	 * constructor
	 * 
	 * @param integer Integer string that is to be parsed
	 * @return BigInteger instance that stores the input integer.
	 * @throws IllegalArgumentException If input is incorrectly formatted
	 */
	public static BigInteger parse(String integer) 
	throws IllegalArgumentException {
		
		BigInteger bInt = new BigInteger();
		
		int i;
		
		if(integer.charAt(0) == '-') {
			bInt.negative = true;
			i = 1;
		} else if(integer.charAt(0) == '+'){
			bInt.negative = false;
			i = 1;
		} else {
			bInt.negative = false;
			i = 0;
		}
		
		for(; i < integer.length(); i++) {
			char letter = integer.charAt(i);
			int num = letter - '0';
			
			if(num < 0 || num > 9) {
				throw new IllegalArgumentException();
			}
			
			//checks for zeroes before the number and adds
			if(num != 0 || bInt.front != null) {
				bInt.front = new DigitNode(num, bInt.front);
				bInt.numDigits++;
			}
			
		}
		
		return bInt;
	}
	
	
	/**
	 * Adds the first and second big integers, and returns the result in a NEW BigInteger object. 
	 * DOES NOT MODIFY the input big integers.
	 * 
	 * NOTE that either or both of the input big integers could be negative.
	 * (Which means this method can effectively subtract as well.)
	 * 
	 * @param first First big integer
	 * @param second Second big integer
	 * @return Result big integer
	 */
	public static BigInteger add(BigInteger first, BigInteger second) {
		
		if(compareAbsValue(first, second) < 0) {
			BigInteger addition = add(second, first);
			if(second.negative && !first.negative) {
				addition.negative = true;
			}
			return addition;
		}
		
		BigInteger summation = new BigInteger();
		int carryOver = 0;
		
		DigitNode dig1 = first.front;
		
		DigitNode dig2 = second.front;
		
		DigitNode tail = null;
		
		
		for(int i = 0; i < second.numDigits; i++) {
			int firstNum = dig1.digit;
			int secondNum = dig2.digit;
			
			if(second.negative != first.negative) {
				secondNum *= -1;
			}
			
			int sum = firstNum + secondNum;
			
			int sumNum = (sum+carryOver)%10;
			
			if(sumNum < 0) {
				sumNum += 10;
			}
			
			if(tail == null) {
				tail = new DigitNode(sumNum, null);
				summation.front = tail;
			} else {
				DigitNode temp = new DigitNode(sumNum, null);
				tail.next = temp;
				tail = temp;
			}
			
			summation.numDigits++;
			
			if(sum+carryOver >= 10) {
				carryOver = 1;
			} else if(sum+carryOver < 0) {
				carryOver = -1;
			} else {
				carryOver = 0;
			}
			
			dig1 = dig1.next;
			dig2 = dig2.next;
		}
		
		for(int j = 0; j < first.numDigits-second.numDigits; j++) {
			int sum2 = dig1.digit;
			
			int sumNum = (sum2+carryOver)%10;
			
			if(sumNum < 0) {
				sumNum += 10;
			}
			
			if(tail == null) {
				tail = new DigitNode(sumNum, null);
				summation.front = tail;
			} else {
				DigitNode temp = new DigitNode(sumNum, null);
				tail.next = temp;
				tail = temp;
			}
			
			summation.numDigits++;
			
			if(sum2+carryOver >= 10) {
				carryOver = 1;
			} else if(sum2+carryOver < 0) {
				carryOver = -1;
			} else {
				carryOver = 0;
			}
			
			dig1 = dig1.next;
		}
		
		if(carryOver == 1) {
			tail.next = new DigitNode(carryOver, null);
		}
		
		if(first.negative) {
			summation.negative = true;
		}
		
		//reversed list to take out zeroes then reversed it back to original
		DigitNode reversedSum = noU(summation.front, summation.numDigits);
		while(reversedSum != null && reversedSum.digit == 0) {
			reversedSum = reversedSum.next;
			summation.numDigits--;
		}
		
		summation.front = noU(reversedSum, summation.numDigits);
		
		return summation;
	}
	
	private static DigitNode noU(DigitNode original, int numDigits) {
		DigitNode reverseNum1 = null;
		DigitNode curr1 = original;
		for(int i = 0; i < numDigits; i++) {
			reverseNum1 = new DigitNode(curr1.digit, reverseNum1);
			curr1 = curr1.next;
		}
		return reverseNum1;
	}
	
	private static int compareAbsValue(BigInteger num1, BigInteger num2) {
		
		if(num1.numDigits > num2.numDigits) {
			return 1;
		} else if(num1.numDigits < num2.numDigits) {
			return -1;
		} else {
			DigitNode reverseNum1 = null;
			DigitNode reverseNum2 = null;
			DigitNode curr1 = num1.front;
			DigitNode curr2 = num2.front;
			for(int i = 0; i < num1.numDigits; i++) {
				reverseNum1 = new DigitNode(curr1.digit, reverseNum1);
				curr1 = curr1.next;
			}

			for(int k = 0; k < num2.numDigits; k++) {
				reverseNum2 = new DigitNode(curr2.digit, reverseNum2);
				curr2 = curr2.next;
			}

			for(int j = 0; j < num1.numDigits; j++) {
				if(reverseNum1.digit > reverseNum2.digit) {
					return 1;
				}
				else if(reverseNum2.digit > reverseNum1.digit) {
					return -1;
				}
				reverseNum1 = reverseNum1.next;
				reverseNum2 = reverseNum2.next;
			}
		}
		
		return 0;
	}
	
	/**
	 * Returns the BigInteger obtained by multiplying the first big integer
	 * with the second big integer
	 * 
	 * This method DOES NOT MODIFY either of the input big integers
	 * 
	 * @param first First big integer
	 * @param second Second big integer
	 * @return A new BigInteger which is the product of the first and second big integers
	 */
	public static BigInteger multiply(BigInteger first, BigInteger second) {
		
		BigInteger product = new BigInteger();
		
		if(first.front == null || second.front == null) {
			return product;
		}
		
		DigitNode num1 = first.front;
		
		for(int i = 0; i < first.numDigits; i++){
			
			BigInteger productt = new BigInteger();
			
			DigitNode num2 = second.front;
			DigitNode tail = null;
			int carryOver = 0;
			for(int j = 0; j< second.numDigits; j++) {
				int innerProduct = num1.digit*num2.digit;
				
				if(tail == null) {
					tail = new DigitNode((innerProduct+carryOver)%10, null);
					productt.front = tail;
				} else {
					DigitNode temp = new DigitNode((innerProduct+carryOver)%10, null);
					tail.next = temp;
					tail = temp;
				}
				productt.numDigits++;
				if((innerProduct+carryOver) >= 10) {
					carryOver = innerProduct/10;
				}
				num2 = num2.next;
			}
			if(carryOver != 0) {
				DigitNode temp = new DigitNode(carryOver, null);
				tail.next = temp;
				tail = temp;
				productt.numDigits++;
			}
			
			for(int k = 0; k < i; k++) {
				productt.front = new DigitNode(0, productt.front);
				productt.numDigits++;
			}
			product = add(product, productt);
			num1 = num1.next;
		}
		
		product.negative = first.negative != second.negative;
		
		return product;
	}
	
	
	/* (non-Javadoc)
	 * @see java.lang.Object#toString()
	 */
	public String toString() {
		if (front == null) {
			return "0";
		}
		String retval = front.digit + "";
		for (DigitNode curr = front.next; curr != null; curr = curr.next) {
				retval = curr.digit + retval;
		}
		
		if (negative) {
			retval = '-' + retval;
		}
		return retval;
	}
}
