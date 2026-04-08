# ============================================================
# 01_Time_Converter.py
# Convert total minutes into a human-readable "X hrs Y minutes"
# ============================================================

def convert_minutes(total_minutes):
    """
    Convert an integer number of minutes into a human-readable string.

    Args:
        total_minutes (int): Total minutes to convert. Must be >= 0.

    Returns:
        str: Formatted string like "2 hrs 10 minutes", "0 hrs 45 minutes", etc.

    Raises:
        ValueError: If input is negative.
        TypeError:  If input is not an integer.
    """
    if not isinstance(total_minutes, int):
        raise TypeError(f"Expected an integer, got {type(total_minutes).__name__}.")
    if total_minutes < 0:
        raise ValueError("Minutes cannot be negative.")

    hours           = total_minutes // 60   # integer division → whole hours
    remaining_mins  = total_minutes %  60   # modulo → leftover minutes

    return f"{hours} hrs {remaining_mins} minutes"


# ─────────────────────────────
# Test cases
# ─────────────────────────────
if __name__ == "__main__":
    test_cases = [130, 110, 60, 0, 59, 1440, 1441]

    print("=" * 40)
    print(f"{'Input (mins)':<15}  {'Output'}")
    print("=" * 40)
    for mins in test_cases:
        print(f"{mins:<15}  {convert_minutes(mins)}")
    print("=" * 40)

    # Interactive mode
    print("\nEnter a number of minutes to convert (or 'q' to quit):")
    while True:
        user_input = input(">>> ").strip()
        if user_input.lower() == "q":
            break
        try:
            result = convert_minutes(int(user_input))
            print(f"    {result}")
        except (ValueError, TypeError) as e:
            print(f"    Error: {e}")
