# ============================================================
# 02_Remove_Duplicates.py
# Remove duplicate characters from a string using a loop,
# preserving the original order of first appearances.
# ============================================================

def remove_duplicates(input_string):
    """
    Remove duplicate characters from a string using a loop.
    Only the first occurrence of each character is kept.

    Args:
        input_string (str): The string to process.

    Returns:
        str: A new string with duplicates removed, order preserved.

    Raises:
        TypeError: If input is not a string.
    """
    if not isinstance(input_string, str):
        raise TypeError(f"Expected a string, got {type(input_string).__name__}.")

    result = ""                          # Start with an empty result string

    for char in input_string:           # Loop through every character
        if char not in result:          # Only add if not already seen
            result += char

    return result


# ─────────────────────────────
# Test cases
# ─────────────────────────────
if __name__ == "__main__":
    test_cases = [
        "programming",
        "hello",
        "aabbccdd",
        "abcdef",
        "mississippi",
        "Google",
        "112233",
        "",
        "a",
    ]

    print("=" * 50)
    print(f"{'Input':<20}  {'Output (no duplicates)'}")
    print("=" * 50)
    for s in test_cases:
        print(f"{repr(s):<20}  {repr(remove_duplicates(s))}")
    print("=" * 50)

    # Interactive mode
    print("\nEnter a string to remove duplicates (or 'q' to quit):")
    while True:
        user_input = input(">>> ")
        if user_input.lower() == "q":
            break
        try:
            print(f"    Result: {remove_duplicates(user_input)}")
        except TypeError as e:
            print(f"    Error: {e}")
