from sequenceAlignment import sequenceAlignScore
import sys
import time
import argparse

def noSpace(line, lineNumber):
	global warning
	if line[2] == " ":
		print("Error: Space in description on line " + str(lineNumber)) 
		error = "Error: Space in description on line " + str(lineNumber)
		warning = 1
		return error 
	
def eightyChar(line, lineNumber):
	global warning 
	if len(line) > 80:
		print("Error: Line " + str(lineNumber) + " is greater than 80 characters with length " + str(len(line)))
		error = "Error: Line " + str(lineNumber) + " is greater than 80 characters with length " + str(len(line))
		warning = 1
		return error 
		
def blankLines(line, lineNumber):
	global warning 
	if len(line.strip()) == 0:
		print("Error: Blank line found on line " + str(lineNumber))
		error = "Error: Blank line found on line " + str(lineNumber)
		warning = 1
		return error 
		

NUCLEIC = ['A', 'C', 'G', 'T', 'U', 'R', 'Y', 'K', 
            'M', 'S', 'W', 'B', 'D', 'H', 'V', 'N', '-']

AMINO = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'K', 
		'L', 'M', 'N', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'Y', 'Z', 
        'X', '*', '-']

def acceptedChar(line, lineNumber, kind):
	global warning 
	for char in line:
		if kind == "DNA": 
			if char not in NUCLEIC :
				print("Error: Incorrect character found on line " + str(lineNumber) + " with character " + str(char))
				error = "Error: Incorrect character found on line " + str(lineNumber) + " with character " + str(char)
				warning = 1
		elif kind == "Protein":
			if char not in AMINO:
				print("Error: Incorrect character found on line " + str(lineNumber) + " with character " + str(char))
				warning = 1
			
def readFasta(file, kind):
	global warning
	f = open(file, "r")
	description = ''		#initialize
	sequence = ''			#initialize
	warning = 0				#initialize
	sequence_list = []		#initialize
	lines = f.readlines()
	last = lines[-1]
	lineNumber = 1
	for line in lines:								
		line = line.strip()
		blankLines(line, lineNumber)					#checks for blank lines
		if line.startswith(">"):						#description line 
			entry = (warning, description, sequence)	#add description and completed sequence of the former	
			sequence_list.append(entry)					#add the entry to the completed list
			warning = 0									#everytime a new entry is encountered, warning is set back to 0
			error = noSpace(line, lineNumber)			#checks for spaces 
			description = line[1:].strip()				#record new description
			sequence = ""
		elif line is last:								#last line 
			acceptedChar(line, lineNumber, kind)		#checks for incorrect characters
			eightyChar(line, lineNumber)				#checks for lines > 80 characters 
			sequence+=line
			entry = (warning, description, sequence)	
			sequence_list.append(entry)					#add the entry to the completed list
		else:
			acceptedChar(line, lineNumber, kind)		#checks for incorrect characters
			eightyChar(line, lineNumber)				#checks for lines > 80 characters
			sequence+=line
		lineNumber += 1;
	
	sequence_list = sequence_list[1:]					#get rid of empty first element
	return sequence_list	

def printFasta(query_seq, database_seq_list, alignment, gappenalty, scoringmatrix):
	output = []
	output.append("Query Sequence:")
	output.append(">" + query_seq)
	output.append("")
	output.append("Database: " + args.databasefile)
	output.append("")

	temp = []
	#starting runtime 
	start_time = time.time()
	for elem in database_seq_list:
		#print(str(elem[0]) + " | " + elem[1])
		if elem[0] is 1: 	#warning/bad sequences
			pass
			#print("Warning: Error with " + str(elem[1]) + " | " + elem[2])
		else: 
			#print(str(elem[1]) + " | " + elem[2])
			header = elem[1]
			score = sequenceAlignScore(query_seq, elem[2], alignment, gappenalty, scoringmatrix) #elem[2] is database sequence
			temp.append("> " + str(score) + "|" + header)

	#ending runtime 
	runtime = time.time() - start_time
	output.append("Runtime: " + str(runtime) + " secs")
	output.append("")
	output.extend(temp)
	return output

#execution
#Inputs 

'''
parser = argparse.ArgumentParser()


print("Enter the query sequence fasta file with extension: ")
queryfile = sys.stdin.readline().strip()

print("Enter the database sequence fasta file with extension: ")
databasefile = sys.stdin.readline().strip()

print("Enter the gap penalty scoring matrix. PAM250 or BLOSUM62")
scoringmatrix = sys.stdin.readline().strip()

print("Enter the alignment. global or local")
alignment = sys.stdin.readline().strip()

print("Enter the linear gap penalty: ")
g = sys.stdin.readline().strip()
gappenalty = int(g)

print("Enter the output name with the extension: ")
output = sys.stdin.readline().strip()
'''

parser = argparse.ArgumentParser()
parser.add_argument('--queryfile', type=str, required=True)
parser.add_argument('--databasefile', type=str, required=True)
parser.add_argument('--scoringmatrix', type=str, choices = ['PAM250', 'BLOSUM62'], required=True)
parser.add_argument('--alignment', type=str, choices = ['global', 'local'], required=True)
parser.add_argument('--gappenalty', type=int, required=True)
parser.add_argument('--output', type=str, required=True)

args = parser.parse_args()
print(args.queryfile)

#finding bad sequences
q = readFasta(args.queryfile, "Protein")
query = q[0][2]	#query sequence 

#finding bad sequences
s = readFasta(args.databasefile, "Protein") #output list of [good(0), bad(1), header, sequence]

#execution and scoring 
o = printFasta(query, s, args.alignment, args.gappenalty, args.scoringmatrix)

for elem in o:
	print(elem)

#write to file
with open(args.output, 'w') as out:
    for elem in o:
        out.write(str(elem) + '\n')
