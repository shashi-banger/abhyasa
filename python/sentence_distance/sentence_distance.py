

def levenshtein(s1, s2):
    if len(s1) < len(s2):
        return levenshtein(s2, s1)

    # len(s1) >= len(s2)
    if len(s2) == 0:
        return len(s1)

    previous_row = range(len(s2) + 1)
    for i, c1 in enumerate(s1):
        current_row = [i + 1]
        for j, c2 in enumerate(s2):
            insertions = previous_row[j + 1] + 1 # j+1 instead of j since previous_row and current_row are one character longer
            deletions = current_row[j] + 1       # than s2
            substitutions = previous_row[j] + (c1 != c2)
            current_row.append(min(insertions, deletions, substitutions))
        previous_row = current_row
    
    return previous_row[-1]


if __name__ == "__main__":
    import sys
    # Example Usage
    if len(sys.argv) < 2:
        print('Usage: python sentence_distance.py "sentence1" "sentence2"')
        print('Example usage')
        print('python sentence_distance.py "foo bar" foo bar world"')
        print('python sentence_distance.py "hello world" "hello world"')
        sys.exit(1)

    sentence_1 = sys.argv[1].split(" ")
    sentence_2 = sys.argv[2].split(" ")
    print(levenshtein(sentence_1, sentence_2)/max(len(sentence_1),
                                                  len(sentence_2)))

