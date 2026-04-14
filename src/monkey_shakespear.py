import random
import socket # Import the socket module to get hostname

# --- 1. Define larger, Shakespearean-style lists of words ---
subjects = [
    "A noble king", "A wicked fool", "The fair maiden", "A dastardly villain",
    "Yon humble servant", "A lonely ghost", "The cackling witch", "A valiant knight",
    "This star-cross'd lover", "A secret heir", "The wise apothecary"
]

verbs = [
    "doth proclaim", "hath stolen", "shall embrace", "doth beseech", "hath forsaken",
    "doth conspire against", "shall vanquish", "hath witnessed", "doth seeketh",
    "shall betray", "doth professeth"
]

objects = [
    "a king's ransom", "a secret sonnet", "a most grievous fate", "the Queen's favour",
    "a poisoned chalice", "the midnight hour", "a ghostly apparition", "a hero's honour",
    "a lover's vow", "a cursed prophecy", "a pound of flesh"
]

adverbs = [
    "with great sorrow", "ere long", "with haste", "anon", "in jest", "perchance",
    "with villainous intent", "forsooth", "in truth", "under the pale moonlight"
]

# --- 2. Define how many sentences to generate ---
num_sentences = 1

# --- 3. Loop to build and print the sentence ---
for i in range(num_sentences):
    # Use random.choice() to pick one random element from each list
    subject = random.choice(subjects)
    verb = random.choice(verbs)
    obj = random.choice(objects)
    adverb = random.choice(adverbs)

    # Assemble the chosen words into a sentence
    # We'll randomly decide whether to include the adverb to make sentences more varied.
    if random.random() > 0.4: # 60% chance to include an adverb for more flavour
        sentence = f"{subject} {verb} {obj} {adverb}."
    else:
        sentence = f"{subject} {verb} {obj}."

    # Get the hostname
    hostname = socket.gethostname()

    # Print the final sentence with the hostname
    print(f"[{hostname}]: {sentence}")

